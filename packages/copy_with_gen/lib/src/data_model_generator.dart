import 'dart:isolate';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:analyzer/src/dart/constant/value.dart';
import 'package:analyzer/src/dart/element/element.dart';
import 'package:build/build.dart' show BuildStep, log;
import 'package:copy_with/copy_with.dart';
import 'package:jinja/jinja.dart';
import 'package:jinja/loaders.dart';
import 'package:source_gen/source_gen.dart';

final templateDir = Uri.parse("package:copy_with_gen/templates");
final templates = Isolate.resolvePackageUriSync(templateDir);
final env = Environment(
  autoReload: false,
  loader: FileSystemLoader(paths: <String>[templates!.toFilePath()]),
  leftStripBlocks: true,
  trimBlocks: true,
);

class DataModelGenerator extends GeneratorForAnnotation<DataModel> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    log.info('Generating DataModel for $element');
    final visitor = ModelVisitor(annotation);
    element.visitChildren(visitor);
    final value = env.getTemplate("data_model.dart.jinja2").render({
      "clazz": {
        "mixin_name": "_\$${visitor.className}",
        "concrete_name": "_${visitor.className}",
        "name": visitor.className,
        "properties": visitor.fields.keys
            .map((field) => visitor.fields[field]!.toJson())
            .toList(),
      }
    });
    return value;
  }
}

const enumChecker = TypeChecker.fromRuntime(Enum);

class FieldInfo {
  final String name;
  final String type;
  final String emptyValue;
  final bool isDataModel;
  final bool isRequired;
  final bool isNullable;

  FieldInfo({
    required this.name,
    required this.type,
    required this.isDataModel,
    required this.isRequired,
    required this.isNullable,
    required this.emptyValue,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "type": type,
      "is_data_model": isDataModel,
      "is_required": isRequired,
      "is_nullable": isNullable,
      "empty_value": emptyValue,
    };
  }
}

class ModelVisitor extends SimpleElementVisitor<void> {
  late String className;
  final fields = <String, FieldInfo>{};
  ConstantReader annotation;

  ModelVisitor(this.annotation);

  Map<DartType, String> _readEmptyValues(ConstantReader input) {
    final rawMap = input.read("emptyValues").mapValue;
    final Map<DartType, String> emptyValues = {};
    for (final key in rawMap.keys) {
      final value = rawMap[key]! as DartObjectImpl;
      final typing = key!.toTypeValue()!;
      if (value.variable != null) {
        emptyValues[typing] = value.variable!.name;
      } else {
        throw Exception("Only variable is accepted for empty value '$typing'");
      }
    }
    return emptyValues;
  }

  @override
  void visitConstructorElement(ConstructorElement element) {
    for (final parameter in element.parameters) {
      // check if has data model annotation
      bool isDataModel = false;
      if (parameter.type.element is ClassElement) {
        final classElement = parameter.type.element as ClassElement;
        for (ElementAnnotation meta in classElement.metadata) {
          final object = meta.computeConstantValue()!;
          final annotationTypeName = object.type?.element?.name;
          if (annotationTypeName == "DataModel") {
            isDataModel = true;
            break;
          }
        }
      }
      String? emptyValue;

      // look up user defined empty values
      final values = _readEmptyValues(annotation);
      for (final key in values.keys) {
        final typeChecker = TypeChecker.fromStatic(key);
        if (typeChecker.isExactlyType(parameter.type)) {
          emptyValue = values[key]!;
          break;
        }
      }

      if (emptyValue == null) {
        // no value override, use default
        if (parameter.isOptional) {
          emptyValue = "null";
        } else if (parameter.type.isDartCoreBool) {
          emptyValue = "false";
        } else if (parameter.type.isDartCoreDouble) {
          emptyValue = "0.0";
        } else if (parameter.type.isDartCoreInt) {
          emptyValue = "0";
        } else if (parameter.type.isDartCoreList) {
          emptyValue = "const []";
        } else if (parameter.type.isDartCoreMap) {
          emptyValue = "const {}";
        } else if (parameter.type.isDartCoreSet) {
          emptyValue = "const {}";
        } else if (parameter.type.isDartCoreString) {
          emptyValue = "''";
        } else if (parameter.type.isDartCoreIterable) {
          emptyValue = "const []";
        } else if (parameter.type.isDartCoreEnum) {
          final typeName = parameter.type.toString().replaceFirst("?", "");
          emptyValue = "$typeName.values.first";
        } else if (enumChecker.isAssignableFromType(parameter.type)) {
          final temp = parameter.type.element as EnumElementImpl;
          final typeName = parameter.type.toString().replaceFirst("?", "");
          final firstValue = temp.fields[0].name;
          emptyValue = "$typeName.$firstValue";
        } else if (isDataModel) {
          final typeName = parameter.type.toString().replaceFirst("?", "");
          emptyValue = "const $typeName.empty()";
        } else {
          emptyValue = null;
        }
      }

      if (emptyValue == null) {
        throw Exception("Empty value not found for '${parameter.type}'");
      }
      fields[parameter.name] = FieldInfo(
        name: parameter.name,
        type: parameter.type.toString(),
        isDataModel: isDataModel,
        isRequired: parameter.isRequired,
        isNullable: parameter.isOptional,
        emptyValue: emptyValue,
      );
    }
    final elementReturnType = element.type.returnType.toString();
    className = elementReturnType.replaceFirst('*', '');
  }
}

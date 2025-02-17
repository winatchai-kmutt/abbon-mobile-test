import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart' show BuildStep, log;
import 'package:copy_with/copy_with.dart';
import 'package:source_gen/source_gen.dart';

class CopyWithGenerator extends GeneratorForAnnotation<CopyWith> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    try {
      log.info('Generating CopyWith method for $element');
      final visitor = ModelVisitor();
      element.visitChildren(visitor);
      final classBuffer = StringBuffer();
      classBuffer.writeln(
          'extension ${visitor.className}CopyWithGen on ${visitor.className} {');
      classBuffer.writeln('${visitor.className} copyWith({');
      for (final field in visitor.fields.keys) {
        final variable = field;
        classBuffer.writeln("${visitor.fields[field]} Function()? $variable,");
      }
      classBuffer.writeln('})');
      classBuffer.writeln('{');
      classBuffer.writeln('return ${visitor.className}(');
      for (final field in visitor.fields.keys) {
        final variable = field;
        classBuffer
            .writeln("$field: $variable != null ? $variable() : this.$field,");
      }
      classBuffer.writeln(');');
      classBuffer.writeln('}');
      classBuffer.writeln('}');
      return classBuffer.toString();
    } catch (e, st) {
      log.severe('Error generating CopyWith method for $element: $e', st);
      rethrow;
    }
  }

  void generateGettersAndSetters(
      ModelVisitor visitor, StringBuffer classBuffer) {
    for (final field in visitor.fields.keys) {
      final variable =
          field.startsWith('_') ? field.replaceFirst('_', '') : field;

      classBuffer.writeln(
          "${visitor.fields[field]} get $variable => variables['$variable'];");

      classBuffer.writeln('set $variable(${visitor.fields[field]} $variable)');
      classBuffer.writeln('=> $field = $variable;');
    }
  }
}

class ModelVisitor extends SimpleElementVisitor<void> {
  late String className;
  final fields = <String, dynamic>{};

  @override
  void visitConstructorElement(ConstructorElement element) {
    final elementReturnType = element.type.returnType.toString();
    className = elementReturnType.replaceFirst('*', '');
  }

  @override
  void visitFieldElement(FieldElement element) {
    if (element.getter?.metadata.isNotEmpty ?? false) {
      for (var meta in element.getter!.metadata) {
        if (meta.isOverride) {
          return;
        }
      }
    }
    final elementType = element.type.toString();
    fields[element.name] = elementType.replaceFirst('*', '');
  }
}

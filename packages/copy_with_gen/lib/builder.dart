library;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'src/copy_with_generator.dart';
import 'src/data_model_generator.dart';

Builder dataModel(BuilderOptions options) {
  return SharedPartBuilder([DataModelGenerator()], 'dataModel');
}

Builder copyWith(BuilderOptions options) {
  return SharedPartBuilder([CopyWithGenerator()], 'copyWith');
}

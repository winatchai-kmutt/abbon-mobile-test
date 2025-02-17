library;

import 'package:meta/meta_meta.dart';

@Target({TargetKind.classType})
class CopyWith {
  const CopyWith();
}

@Target({TargetKind.classType})
class DataModel {
  const DataModel({
    this.copyWith = true,
    this.equals = true,
    this.empty = true,
    this.json = true,
    this.emptyValues = const {},
  });

  final bool copyWith;
  final bool equals;
  final bool empty;
  final bool json;
  final Map<Type, dynamic> emptyValues;
}

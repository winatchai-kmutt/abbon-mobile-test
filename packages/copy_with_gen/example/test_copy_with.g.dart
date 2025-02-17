// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_copy_with.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

extension ModelACopyWithGen on ModelA {
  ModelA copyWith({
    int? Function()? id,
    List<String> Function()? names,
    double Function()? price,
    SimpleA? Function()? simpleA,
  }) {
    return ModelA(
      id: id != null ? id() : this.id,
      names: names != null ? names() : this.names,
      price: price != null ? price() : this.price,
      simpleA: simpleA != null ? simpleA() : this.simpleA,
    );
  }
}

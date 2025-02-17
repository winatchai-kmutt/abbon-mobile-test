// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_data_model.dart';

// **************************************************************************
// DataModelGenerator
// **************************************************************************

mixin _$SimpleA {
  int? get a => throw UnimplementedError();
  String get b => throw UnimplementedError();
  List<String> get names => throw UnimplementedError();
  MyEum get type => throw UnimplementedError();
  Uri get uri => throw UnimplementedError();
  SimpleB? get simpleB => throw UnimplementedError();
  SimpleA copyWith({
    int? Function()? a,
    String Function()? b,
    List<String> Function()? names,
    MyEum Function()? type,
    Uri Function()? uri,
    SimpleB? Function()? simpleB,
  }) {
    throw UnimplementedError();
  }
}

class _SimpleA extends Equatable implements SimpleA {
  const _SimpleA({
    this.a,
    required this.b,
    required this.names,
    required this.type,
    required this.uri,
    this.simpleB,
  });

  const _SimpleA.empty()
      : a = null,
        b = '',
        names = const [],
        type = MyEum.A,
        uri = kUriEmptyValue,
        simpleB = null;
  @override
  final int? a;
  @override
  final String b;
  @override
  final List<String> names;
  @override
  final MyEum type;
  @override
  final Uri uri;
  @override
  final SimpleB? simpleB;
  @override
  SimpleA copyWith({
    int? Function()? a,
    String Function()? b,
    List<String> Function()? names,
    MyEum Function()? type,
    Uri Function()? uri,
    SimpleB? Function()? simpleB,
  }) {
    return SimpleA(
      a: a != null ? a() : this.a,
      b: b != null ? b() : this.b,
      names: names != null ? names() : this.names,
      type: type != null ? type() : this.type,
      uri: uri != null ? uri() : this.uri,
      simpleB: simpleB != null ? simpleB() : this.simpleB,
    );
  }

  @override
  List<Object?> get props => [
        a,
        b,
        names,
        type,
        uri,
        simpleB,
      ];
}

mixin _$SimpleB {
  Map<String, int> get a => throw UnimplementedError();
  Set<int> get b => throw UnimplementedError();
  SimpleA get simpleA => throw UnimplementedError();
  MyEum get type => throw UnimplementedError();
  SimpleB copyWith({
    Map<String, int> Function()? a,
    Set<int> Function()? b,
    SimpleA Function()? simpleA,
    MyEum Function()? type,
  }) {
    throw UnimplementedError();
  }
}

class _SimpleB extends Equatable implements SimpleB {
  const _SimpleB({
    required this.a,
    required this.b,
    required this.simpleA,
    required this.type,
  });

  const _SimpleB.empty()
      : a = const {},
        b = const {},
        simpleA = const SimpleA.empty(),
        type = MyEum.A;
  @override
  final Map<String, int> a;
  @override
  final Set<int> b;
  @override
  final SimpleA simpleA;
  @override
  final MyEum type;
  @override
  SimpleB copyWith({
    Map<String, int> Function()? a,
    Set<int> Function()? b,
    SimpleA Function()? simpleA,
    MyEum Function()? type,
  }) {
    return SimpleB(
      a: a != null ? a() : this.a,
      b: b != null ? b() : this.b,
      simpleA: simpleA != null ? simpleA() : this.simpleA,
      type: type != null ? type() : this.type,
    );
  }

  @override
  List<Object?> get props => [
        a,
        b,
        simpleA,
        type,
      ];
}

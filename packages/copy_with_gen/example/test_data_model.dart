import 'package:copy_with/copy_with.dart';
import 'package:equatable/equatable.dart';

part 'test_data_model.g.dart';

enum MyEum {
  A,
  B,
  C;
}

class ConstantUri implements Uri {
  const ConstantUri();

  @override
  // TODO: implement authority
  String get authority => throw UnimplementedError();

  @override
  // TODO: implement data
  UriData? get data => throw UnimplementedError();

  @override
  // TODO: implement fragment
  String get fragment => throw UnimplementedError();

  @override
  // TODO: implement hasAbsolutePath
  bool get hasAbsolutePath => throw UnimplementedError();

  @override
  // TODO: implement hasAuthority
  bool get hasAuthority => throw UnimplementedError();

  @override
  // TODO: implement hasEmptyPath
  bool get hasEmptyPath => throw UnimplementedError();

  @override
  // TODO: implement hasFragment
  bool get hasFragment => throw UnimplementedError();

  @override
  // TODO: implement hasPort
  bool get hasPort => throw UnimplementedError();

  @override
  // TODO: implement hasQuery
  bool get hasQuery => throw UnimplementedError();

  @override
  // TODO: implement hasScheme
  bool get hasScheme => throw UnimplementedError();

  @override
  // TODO: implement host
  String get host => throw UnimplementedError();

  @override
  // TODO: implement isAbsolute
  bool get isAbsolute => throw UnimplementedError();

  @override
  bool isScheme(String scheme) {
    // TODO: implement isScheme
    throw UnimplementedError();
  }

  @override
  Uri normalizePath() {
    // TODO: implement normalizePath
    throw UnimplementedError();
  }

  @override
  // TODO: implement origin
  String get origin => throw UnimplementedError();

  @override
  // TODO: implement path
  String get path => throw UnimplementedError();

  @override
  // TODO: implement pathSegments
  List<String> get pathSegments => throw UnimplementedError();

  @override
  // TODO: implement port
  int get port => throw UnimplementedError();

  @override
  // TODO: implement query
  String get query => throw UnimplementedError();

  @override
  // TODO: implement queryParameters
  Map<String, String> get queryParameters => throw UnimplementedError();

  @override
  // TODO: implement queryParametersAll
  Map<String, List<String>> get queryParametersAll =>
      throw UnimplementedError();

  @override
  Uri removeFragment() {
    // TODO: implement removeFragment
    throw UnimplementedError();
  }

  @override
  Uri replace(
      {String? scheme,
      String? userInfo,
      String? host,
      int? port,
      String? path,
      Iterable<String>? pathSegments,
      String? query,
      Map<String, dynamic>? queryParameters,
      String? fragment}) {
    // TODO: implement replace
    throw UnimplementedError();
  }

  @override
  Uri resolve(String reference) {
    // TODO: implement resolve
    throw UnimplementedError();
  }

  @override
  Uri resolveUri(Uri reference) {
    // TODO: implement resolveUri
    throw UnimplementedError();
  }

  @override
  // TODO: implement scheme
  String get scheme => throw UnimplementedError();

  @override
  String toFilePath({bool? windows}) {
    // TODO: implement toFilePath
    throw UnimplementedError();
  }

  @override
  // TODO: implement userInfo
  String get userInfo => throw UnimplementedError();
}

const data = DataModel(
  emptyValues: {
    Uri: kUriEmptyValue,
  },
);

@data
class SimpleA with _$SimpleA {
  const factory SimpleA({
    int? a,
    required String b,
    required List<String> names,
    required MyEum type,
    required Uri uri,
    SimpleB? simpleB,
  }) = _SimpleA;

  const factory SimpleA.empty() = _SimpleA.empty;
}

@data
class SimpleB with _$SimpleB {
  const factory SimpleB({
    required Map<String, int> a,
    required Set<int> b,
    required SimpleA simpleA,
    required MyEum type,
  }) = _SimpleB;

  const factory SimpleB.empty() = _SimpleB.empty;
}

const kMyEnumEmptyValue = MyEum.A;
const kUriEmptyValue = ConstantUri();

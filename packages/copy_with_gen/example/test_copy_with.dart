import 'package:copy_with/copy_with.dart';
import 'test_data_model.dart';

part 'test_copy_with.g.dart';

@CopyWith()
class ModelA {
  final int? id;
  final List<String> names;
  final double price;
  final SimpleA? simpleA;

  const ModelA({
    required this.id,
    required this.names,
    required this.price,
    this.simpleA,
  });
}

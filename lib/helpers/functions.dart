import 'package:uuid/uuid.dart';

class Functions {
  static String generateId() {
    return Uuid().v4();
  }
}

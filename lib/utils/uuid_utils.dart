import 'package:uuid/uuid.dart';

class UuidUtils {
  static final Uuid _uuid = Uuid();

  static String generateTraceId() {
    return _uuid.v4();
  }
}
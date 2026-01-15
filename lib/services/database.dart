// Cầu nối đa nền tảng: Web dùng database_web.dart, Mobile/Desktop dùng database_io.dart
export 'database_io.dart' if (dart.library.html) 'database_web.dart';

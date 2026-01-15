// Điểm nhập khối phục nền tảng — web dùng database_web.dart, IO dùng database_io.dart
export 'database_io.dart' if (dart.library.html) 'database_web.dart';

// Cross-platform entry point. On web this file exports `database_web.dart`,
// on IO platforms it exports `database_io.dart` which uses sqflite.
export 'database_io.dart' if (dart.library.html) 'database_web.dart'; 
 
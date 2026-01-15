// Triển khai cho web sử dụng window.localStorage để lưu giao dịch
import 'dart:convert';
// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;
import '../models/transaction.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  static const _key = 'transactions_storage_v1';

  List<Map<String, dynamic>> _readList() {
    final raw = html.window.localStorage[_key];
    if (raw == null) return [];
    try {
      final decoded = json.decode(raw) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  Future<int> insertTransaction(TransactionModel tx) async {
    final list = _readList();
    // gán id: id lớn nhất hiện có + 1 hoặc 1
    final maxId = list.map((e) => e['id'] as int? ?? 0).fold<int>(0, (p, n) => n > p ? n : p);
    final id = maxId + 1;
    final map = tx.toMap();
    map['id'] = id;
    list.add(map);
    html.window.localStorage[_key] = json.encode(list);
    return id;
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    final list = _readList();
    // sắp xếp theo ngày giảm dần
    final parsed = list.map((m) => TransactionModel.fromMap(m)).toList();
    parsed.sort((a, b) => b.date.compareTo(a.date));
    return parsed;
  }

  Future<int> deleteTransaction(int id) async {
    final list = _readList();
    final before = list.length;
    list.removeWhere((e) => (e['id'] as num?)?.toInt() == id);
    html.window.localStorage[_key] = json.encode(list);
    return before - list.length;
  }

  Future<int> updateTransaction(TransactionModel tx) async {
    final list = _readList();
    final index = list.indexWhere((e) => (e['id'] as num?)?.toInt() == tx.id);
    if (index != -1) {
      final map = tx.toMap();
      map['id'] = tx.id; // đảm bảo id được giữ nguyên
      list[index] = map;
      html.window.localStorage[_key] = json.encode(list);
      return 1;
    }
    return 0;
  }
}

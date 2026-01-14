// Web implementation using window.localStorage to persist transactions as JSON
import 'dart:convert';
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
    // assign id: max existing id + 1 or 1
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
    // sort by date desc
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
}

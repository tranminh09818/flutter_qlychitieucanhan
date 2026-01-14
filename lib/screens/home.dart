// trang để chuyển sang thêm giao dịch( kết nối )
import 'package:flutter/material.dart';
import 'package:flutter_qlychitieucanhan/theme.dart';
import '../services/database.dart';
import '../models/transaction.dart';
import '../screens/transaction_detail.dart';
import '../services/database_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<TransactionModel> _transactions = [];
  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final dbService = DatabaseService.instance;

    final db = await dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('transactions');

    setState(() {
      _transactions = maps
          .map(
            (map) => TransactionModel(
              id: map['id'],
              title: map['title'],
              amount: map['amount'],
              date: DateTime.parse(map['date']),
              category:
                  map['category'] ??
                  'Khác', // Default to 'Khác' if category is null
            ),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quán lý chi tiêu',
          style: TextStyle(fontWeight: FontWeight.bold), // in đậm
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        // phần của ai tự code ( cmt tên, tách phần của mk viết ra )
        children: [
          Expanded(
            child: _transactions.isEmpty
                ? Center(
                    child: Text(
                      'Chưa có giao dịch',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = _transactions[index];
                      return ListTile(
                        title: Text(transaction.title),
                        subtitle: Text(
                          transaction.date.toLocal().toString().split(' ')[0],
                        ),
                        trailing: Text(
                          '${transaction.amount.toStringAsFixed(2)} VND',
                        ),
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TransactionDetailScreen(
                                transaction: transaction,
                              ),
                            ),
                          );
                          if (result == 'deleted') {
                            _loadTransactions();
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      //nút bấm thêm giao dịch
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Chuyển sang trang thêm giao dịch khi nút được nhấn
          Navigator.pushNamed(context, '/add-transaction');
        },
        backgroundColor: AppColors.primaryAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}

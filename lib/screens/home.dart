// trang để chuyển sang thêm giao dịch( kết nối )

import 'package:flutter/material.dart';
import 'package:flutter_qlychitieucanhan/screens/add_screen.dart';
import 'package:flutter_qlychitieucanhan/theme.dart';
<<<<<<< HEAD
import 'package:flutter_qlychitieucanhan/services/database.dart';
import 'package:flutter_qlychitieucanhan/models/transaction.dart';
=======
import '../services/database.dart';
import '../models/transaction.dart';
import '../screens/transaction_detail.dart';
import '../services/database_service.dart';
>>>>>>> f82a40e88ca5f2c090045d76b5d16e0d0e56569f

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<TransactionModel> _transactions = [];
<<<<<<< HEAD
  bool _isLoading = true;
  double _totalAmount = 0;

  @override
  void initState() {
    super.initState();
    _loadTransactions(); // Tải dữ liệu khi mở app
  }

  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);
    final list = await DatabaseHelper.instance.getAllTransactions();
    if (mounted) {
      setState(() {
        _transactions = list;
        // Tính tổng tiền
        _totalAmount = list.fold(0, (sum, item) => sum + item.amount);
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteTransaction(int id) async {
    await DatabaseHelper.instance.deleteTransaction(id);
    _loadTransactions(); // Tải lại danh sách sau khi xóa
=======
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
>>>>>>> f82a40e88ca5f2c090045d76b5d16e0d0e56569f
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      appBar: AppBar (
        title: const Text('Quản lý chi tiêu',
        style:TextStyle(fontWeight: FontWeight.bold) // in đậm 
=======
      appBar: AppBar(
        title: const Text(
          'Quán lý chi tiêu',
          style: TextStyle(fontWeight: FontWeight.bold), // in đậm
>>>>>>> f82a40e88ca5f2c090045d76b5d16e0d0e56569f
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
<<<<<<< HEAD
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _transactions.isEmpty
              ? const Center(child: Text('Chưa có giao dịch nào'))
              : Column(
                  children: [
                    // Hiển thị tổng tiền
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text('Tổng chi tiêu', style: TextStyle(color: AppColors.subTextColor)),
                          const SizedBox(height: 8),
                          Text(
                            '${_totalAmount.toStringAsFixed(0)} đ',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.expenseColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Danh sách giao dịch
                    Expanded(
                      child: ListView.builder(
                        itemCount: _transactions.length, // số lượng giao dịch
                        itemBuilder: (context, index) { // xây dựng từng mục trong danh sách giao dịch

                          final tx = _transactions[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.primaryAccent,
                                child: Text(
                                  tx.category.isNotEmpty ? tx.category[0] : '?', // lấy chữ cái đầu của loại giao dịch
                                  style: const TextStyle(color: Colors.white), 
                                ),
                              ),
                              title: Text(
                                tx.title,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '${tx.date.day}/${tx.date.month}/${tx.date.year} - ${tx.category}', // hiển thị ngày và loại giao dịch
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${tx.amount.toStringAsFixed(0)} đ', // hiển thị số tiền với định dạng không có chữ số thập phân
                                    style: const TextStyle(
                                        color: AppColors.expenseColor, fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.grey),
                                    onPressed: () {
                                      if (tx.id != null) _deleteTransaction(tx.id!); // xóa giao dịch khi nhấn nút
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
      //nút bấm thêm giao dịch
      floatingActionButton: FloatingActionButton(
  backgroundColor: AppColors.primaryAccent,
  child: const Icon(Icons.add),
  onPressed: () async {
    final result = await showModalBottomSheet( //hiện thị màn hình thêm giao dịch
      context: context,
      isScrollControlled: true,
      builder: (_) => const AddScreen(),
    );

    // Nếu kết quả trả về là true (đã lưu), tải lại danh sách
    if (result == true) {
      _loadTransactions();
    }
  },
),

=======
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
>>>>>>> f82a40e88ca5f2c090045d76b5d16e0d0e56569f
    );
  }
}

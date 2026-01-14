// trang để chuyển sang thêm giao dịch( kết nối )

import 'package:flutter/material.dart';
import 'package:flutter_qlychitieucanhan/screens/add_screen.dart';
import 'package:flutter_qlychitieucanhan/theme.dart';
import 'package:flutter_qlychitieucanhan/services/database.dart';
import 'package:flutter_qlychitieucanhan/models/transaction.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<TransactionModel> _transactions = [];
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar (
        title: const Text('Quản lý chi tiêu',
        style:TextStyle(fontWeight: FontWeight.bold) // in đậm 
        ),
        centerTitle: true, 
        backgroundColor: AppColors.primaryColor,
      ),
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

    );
  }
}

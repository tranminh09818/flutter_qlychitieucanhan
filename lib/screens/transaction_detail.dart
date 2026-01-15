import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'edit_transaction_screen.dart';
import '../services/database.dart';
import 'package:flutter_qlychitieucanhan/theme.dart';

class TransactionDetailScreen extends StatefulWidget {
  final TransactionModel
  transaction; // Nhận dữ liệu giao dịch từ màn hình trước

  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  late TransactionModel transaction; // Biến lưu dữ liệu để hiển thị và cập nhật

  @override
  void initState() {
    super.initState();
    transaction = widget.transaction; // Khởi tạo dữ liệu ban đầu từ widget cha
  }

  void _updateTransaction(TransactionModel updatedTransaction) {
    setState(() {
      transaction =
          updatedTransaction; // Cập nhật dữ liệu mới và vẽ lại giao diện
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chi tiết giao dịch')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tiêu đề: ${transaction.title}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            Text(
              'Số tiền: ${transaction.amount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 8),
            Text(
              'Ngày: ${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 8),
            Text(
              'Loại: ${transaction.category}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Chuyển sang màn hình sửa và đợi kết quả trả về
                final updatedTransaction =
                    await Navigator.push<TransactionModel>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditTransactionScreen(
                          transaction: transaction,
                        ), // Truyền dữ liệu sang màn hình sửa
                      ),
                    );
                if (updatedTransaction != null) {
                  _updateTransaction(updatedTransaction);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAccent,
                foregroundColor: Colors.white,
              ),
              child: Text('Sửa giao dịch'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.expenseColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Xác nhận xóa'),
                    content: Text('Bạn có chắc muốn xóa giao dịch này?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('Hủy'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text('Xóa', style: TextStyle(color: AppColors.expenseColor)),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  if (transaction.id != null) {
                    await DatabaseHelper.instance.deleteTransaction(
                      transaction.id!,
                    );
                  }
                  if (!mounted) return;
                  Navigator.pop(context, 'deleted');
                }
              },
              child: Text('Xóa giao dịch'),
            ),
          ],
        ),
      ),
    );
  }
}

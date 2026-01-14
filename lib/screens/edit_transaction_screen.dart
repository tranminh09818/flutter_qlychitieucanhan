import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/database.dart';
import '../services/database_service.dart';

class EditTransactionScreen extends StatefulWidget {
  final TransactionModel transaction;

  const EditTransactionScreen({super.key, required this.transaction});

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  late TextEditingController _titleController; // Quản lý ô nhập Tiêu đề
  late TextEditingController _amountController; // Quản lý ô nhập Số tiền
  late String _category; // Lưu loại chi tiêu đang chọn
  late DateTime _date; // Lưu ngày tháng đang chọn

  @override
  void initState() {
    super.initState();
    // Lấy dữ liệu cũ (từ widget.transaction) điền sẵn vào các ô nhập liệu
    _titleController = TextEditingController(text: widget.transaction.title);
    _amountController = TextEditingController(
      text: widget.transaction.amount.toString(),
    );
    _category = widget.transaction.category;
    _date = widget.transaction.date;
  }

  // Dọn dẹp bộ nhớ
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _updateTransaction() {
    // Tạo đối tượng mới với dữ liệu từ form, nhưng giữ nguyên ID cũ
    final updatedTransaction = TransactionModel(
      id: widget.transaction.id,
      title: _titleController.text,
      amount:
          double.tryParse(_amountController.text) ??
          0.0, // Đổi kiểu chuỗi sang số
      category: _category,
      date: _date,
    );

    // Gọi Database để lưu xuống bộ nhớ máy
    final databaseService = DatabaseService.instance;

    databaseService.updateTransaction(updatedTransaction);

    // Đóng màn hình và trả dữ liệu mới về màn hình trước
    Navigator.pop(context, updatedTransaction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa giao dịch'),
      ), // Thanh tiêu đề trên cùng
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Sắp xếp các phần tử theo chiều dọc
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Tiêu đề'),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Số tiền'),
            ),
            // Menu thả xuống (Dropdown) chọn danh mục
            DropdownButton<String>(
              value: _category, // Giá trị hiện tại
              onChanged: (value) {
                setState(() {
                  // Cập nhật lại giao diện khi chọn mục mới
                  _category = value!;
                });
              },
              items: ['Ăn uống', 'Di chuyển', 'Nhà cửa', 'Giải trí', 'Khác']
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ),
                  ) // Chuyển List String thành List DropdownMenuItem
                  .toList(),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text('Ngày: ${_date.toLocal().toString().split(' ')[0]}'),
                TextButton(
                  onPressed: () async {
                    // Mở lịch (DatePicker)
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _date,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    // Nếu người dùng chọn ngày (không bấm Cancel)
                    if (selectedDate != null) {
                      setState(() {
                        _date =
                            selectedDate; // Cập nhật biến _date và vẽ lại UI
                      });
                    }
                  },
                  child: Text('Chọn ngày'),
                ),
              ],
            ),

            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateTransaction, // Gọi hàm lưu khi bấm
              child: Text('Cập nhật'),
            ),
          ],
        ),
      ),
    );
  }
}

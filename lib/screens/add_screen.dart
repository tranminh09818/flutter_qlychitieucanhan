// trang thêm giao dịch - dùng làm BottomSheet
import 'package:flutter/material.dart';
import 'package:flutter_qlychitieucanhan/models/transaction.dart';
import 'package:flutter_qlychitieucanhan/theme.dart';
import 'package:flutter_qlychitieucanhan/services/database.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Ăn uống';

  final List<String> _categories = [
    'Ăn uống',
    'Di chuyển',
    'Nhà cửa',
    'Giải trí',
    'Khác',
  ];

  // chọn ngày
  Future<void> _pickDate() async { //
    final picked = await showDatePicker( // hiển thị hộp thoại chọn ngày
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) { // nếu người dùng chọn ngày
      setState(() => _selectedDate = picked);// cập nhật ngày được chọn
    }
  }

  // lưu giao dịch
  void _saveTransaction() async {
    final title = _titleController.text.trim(); // lấy chuỗi và xóa khoảng trắng
    final amountText = _amountController.text.trim();// lấy chuỗi và xóa khoảng trắng

    if (amountText.isEmpty) { // nếu không nhập số tiền
      _showMessage('Vui lòng nhập số tiền');
      return;
    }

    final amount = double.tryParse(amountText); // chuyển chuỗi sang số thực
    if (amount == null || amount <= 0) { // nếu không chuyển được hoặc số tiền không hợp lệ
      _showMessage('Số tiền không hợp lệ');
      return;
    }

    final transaction = TransactionModel(
      title: title.isEmpty ? 'Không tên' : title,
      amount: amount,
      date: _selectedDate,
      category: _selectedCategory,
    );

    await DatabaseHelper.instance.insertTransaction(transaction);

    if (!mounted) return; // Kiểm tra xem màn hình còn tồn tại không trước khi pop

    Navigator.pop(context, true);
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context) 
        .showSnackBar(SnackBar(content: Text(msg))); 
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Thêm giao dịch',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // tiêu đề
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Tiêu đề',
                hintText: 'VD: Ăn mì',
              ),
            ),

            const SizedBox(height: 12),

            // số tiền
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Số tiền',
                suffixText: 'đ',
              ),
            ),

            const SizedBox(height: 12),

            // danh mục
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: _categories
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCategory = value);
                }
              },
              decoration: const InputDecoration(
                labelText: 'Danh mục',
              ),
            ),

            const SizedBox(height: 12),

            // ngày
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Ngày: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  ),
                ),
                TextButton(
                  onPressed: _pickDate,
                  child: const Text('Chọn ngày'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // nút lưu
            ElevatedButton(
              onPressed: _saveTransaction,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAccent,
              ),
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }
}

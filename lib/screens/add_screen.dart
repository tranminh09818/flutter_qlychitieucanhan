// trang thêm giao dịch
import 'package:flutter/material.dart';
import 'package:flutter_qlychitieucanhan/theme.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm giao dịch', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Form nhập liệu sẽ ở đây'),
      ),
    );
  }
}
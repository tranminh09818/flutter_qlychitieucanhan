// trang chính( trang chủ)
import 'package:flutter/material.dart';
import 'package:flutter_qlychitieucanhan/screens/home.dart';
import 'package:flutter_qlychitieucanhan/screens/add_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false, 
      home: const Home(),
      routes: {
        '/add-transaction': (context) => const AddScreen(), // định nghĩa route để chuyển trang để thêm giao dịch
      },
    ),
  );
}

class SandBox extends StatelessWidget { // dùng sau nếu cần 
  const SandBox({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
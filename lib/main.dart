// trang chính( trang chủ)
import 'package:flutter/material.dart';
import 'package:flutter_qlychitieucanhan/screens/home.dart';
import 'package:flutter_qlychitieucanhan/screens/button_screen.dart';
import 'package:flutter_qlychitieucanhan/theme.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        useMaterial3: true,
      ),
      home: const Home(),
      routes: {
        '/add-transaction': (context) => const ButtonScreen(), // định nghĩa route để chuyển trang để thêm giao dịch
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
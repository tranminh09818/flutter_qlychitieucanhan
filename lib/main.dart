// trang chính( trang chủ)
import 'package:flutter/material.dart';
import 'package:flutter_qlychitieucanhan/screens/home.dart';

void main() {
  runApp(const  MaterialApp(
    home: Home () // -> bên trang home.dart
  ));
}
class SandBox extends StatelessWidget { // dùng sau nếu cần 
  const SandBox({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
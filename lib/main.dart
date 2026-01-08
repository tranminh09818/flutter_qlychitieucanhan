// trang chính( trang chủ)
import 'package:flutter/material.dart';
import 'package:flutter_qlychitieucanhan/screens/home.dart';

void main() {
  runApp(const  MaterialApp(
    home: Home () // -> bên trang home.dart
  ));
}
class MyWidget extends StatelessWidget { // dùng sau nếu cần 
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
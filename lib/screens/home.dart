// trang để chuyển sang thêm giao dịch( kết nối )
import 'package:flutter/material.dart';
import 'package:flutter_qlychitieucanhan/theme.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar (
        title: const Text('Quán lý chi tiêu',
        style:TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: const Center(  // phần của ai tự code ( cmt  tách phần của mk viết ra ) 
        child: Text('chưa có giao dịch nào'),
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
    );
  }
}
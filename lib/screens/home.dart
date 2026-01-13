// trang để chuyển sang thêm giao dịch( kết nối )
import 'package:flutter/material.dart';
import 'package:flutter_qlychitieucanhan/theme.dart';
import '../services/database.dart';
import '../models/transaction.dart';
import '../screens/transaction_detail.dart';

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
        style:TextStyle(fontWeight: FontWeight.bold) // in đậm 
        ),
        centerTitle: true, 
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(  // phần của ai tự code ( cmt tên, tách phần của mk viết ra ) 
        children: [
          Container()
        
        ],





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

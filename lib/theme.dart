// bộ giao diện chung cho app, màu sắc, font chữ, kích thước
import 'package:flutter/material.dart';
// màu này dùng trong app nha: dùng thì vd: color: AppColors.primaryColor, là được 
class AppColors {
  static const Color primaryColor = Color.fromRGBO(46, 125, 50, 1);   // Màu chủ đạo
  static const Color primaryAccent = Color.fromRGBO(27, 94, 32, 1);   // Màu nhấn, nút bấm

  static const Color backgroundColor = Color.fromRGBO(18, 18, 18, 1); // Màu nền ứng dụng
  static const Color surfaceColor = Color.fromRGBO(30, 30, 30, 1);    // Màu nền các thẻ (Card)

  static const Color expenseColor = Color.fromRGBO(211, 47, 47, 1);   // Màu khoản chi
  static const Color incomeColor = Color.fromRGBO(56, 142, 60, 1);    // Màu khoản thu
  static const Color warningColor = Color.fromRGBO(255, 160, 0, 1);   // Màu cảnh báo quá hạn mức

  static const Color titleColor = Color.fromRGBO(255, 255, 255, 1);   // Màu tiêu đề
  static const Color subTextColor = Color.fromRGBO(176, 190, 197, 1); // Màu chữ phụ, ngày tháng
}

//MODEL CHO GIAO DỊCH( mọi người phải dùng chung dựa trên model này tránh lỗi "!cấm đổi" )
class TransactionModel {
  final int? id; 
  final String title; // cho tiêu đề 
  final double amount; // cho tiền 
  final DateTime date; // cho ngày giao dịch
  final String category; // cho loại giao dịch

  TransactionModel({this.id, required this.title, required this.amount, required this.date, required this.category}); // để khởi tạo

  Map<String, dynamic> toMap() {  // chuyển đổi object thành Map để lưu trữ
    final map = <String, dynamic>{
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(), // chuyển ngày thành chuỗi để lưu 
      'category': category,// lưu loại giao dịch
    };
    if (id != null) map['id'] = id;  // thêm id nếu nó khác null
    return map; 
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) { // chuyển đổi từ Map thành object , factory để tạo instance mới, instance 
    return TransactionModel(
      id: map['id'] as int?,  // chuyển id về int tương tự với mấy cái sau
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(), 
      date: DateTime.parse(map['date'] as String), 
      category: map['category'] as String? ?? 'Khác', // nếu không có loại giao dịch thì gán là 'Khác' ?? để tránh lỗi null 
    );
  }
}
extension TransactionModelExt on TransactionModel { 
  TransactionModel copyWithId(int id) => // tạo bản sao của TransactionModel với id mới| database sẽ tự tạo id khi thêm mới
  TransactionModel(
   id: id, // các thuộc tính còn lại giữ nguyên
   title: title,
   amount: amount,
   date: date,
   category: category,
   );
} // "dạng giao dịch hóa hơn nên dùng extension"
import 'package:flutter/material.dart';

class SearchAndSummaryScreen extends StatefulWidget {
  final double totalAmount;
  final Function(String) onSearch;
  final Function(String) onFilter;
  final Function() onReset;
  final Function() onDeleteAll;

  const SearchAndSummaryScreen({
    super.key,
    required this.totalAmount,
    required this.onSearch,
    required this.onFilter,
    required this.onReset,
    required this.onDeleteAll,
  });

  @override
  State<SearchAndSummaryScreen> createState() => _SearchAndSummaryScreenState();
}

class _SearchAndSummaryScreenState extends State<SearchAndSummaryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Tất cả';
  final List<String> _categories = [
    'Tất cả',
    'Ăn uống',
    'Di chuyển',
    'Nhà cửa',
    'Giải trí',
    'Khác',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Hàm format tiền: 5000000 -> "5.000.000đ"
  String _formatMoney(double amount) {
    if (amount == 0) return "0đ";
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}đ';
  }

  // Hiển thị dialog xác nhận
  void _showConfirmDialog(String title, String message, Function() onYes) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Không'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onYes();
              // Hiện thông báo thành công
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    title.contains('làm lại')
                        ? 'Tổng tiền đã làm lại về 0đ'
                        : 'Tất cả giao dịch đã xóa',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Có'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TÌM KIẾM & LỌC
        Card(
          margin: const EdgeInsets.all(16),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Ô TÌM KIẾM
                Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Tìm kiếm giao dịch...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (text) {
                          widget.onSearch(text);
                        },
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                // CÁC NÚT LỌC
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                            widget.onFilter(
                              category == 'Tất cả' ? '' : category,
                            );
                          },
                          selectedColor: Colors.blue.withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.blue : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        //  TỔNG TIỀN
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // TIÊU ĐỀ
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tổng cộng',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 8),
                // SỐ TIỀN
                Text(
                  _formatMoney(widget.totalAmount),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 20),
                // HAI NÚT CHỨC NĂNG
                Row(
                  children: [
                    // NÚT LÀM LẠI
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showConfirmDialog(
                            'Làm lại',
                            'Bạn có chắc muốn làm lại tổng tiền về 0?',
                            widget.onReset,
                          );
                        },
                        icon: const Icon(Icons.refresh, size: 20),
                        label: const Text('Làm lại'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[50],
                          foregroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // NÚT XÓA TẤT CẢ
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showConfirmDialog(
                            'Xóa tất cả',
                            'Bạn có chắc muốn xóa tất cả giao dịch?',
                            widget.onDeleteAll,
                          );
                        },
                        icon: const Icon(Icons.delete_outline, size: 20),
                        label: const Text('Xóa tất cả'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[50],
                          foregroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

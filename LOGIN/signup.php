<?php
// Kiểm tra xem dữ liệu đã được gửi từ biểu mẫu đăng ký chưa
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Lấy dữ liệu từ biểu mẫu
    $username = $_POST["username"];
    $password = $_POST["password"];
    $confirm_password = $_POST["confirm_password"];

    // Thực hiện các kiểm tra tính hợp lệ của dữ liệu, ví dụ: kiểm tra xem tên người dùng đã tồn tại chưa
    // Đây chỉ là ví dụ đơn giản, bạn cần thay đổi phần này để phù hợp với cấu trúc dữ liệu và yêu cầu của bạn

    // Kiểm tra xem mật khẩu đã được xác nhận đúng không
    if ($password !== $confirm_password) {
        echo "Mật khẩu và xác nhận mật khẩu không khớp.";
        exit;
    }

    // Thêm thông tin người dùng mới vào cơ sở dữ liệu
    // Đây là bước quan trọng và cần phải được triển khai một cách an toàn và chính xác,
    // Bạn cần sử dụng các phương pháp bảo mật như PDO hoặc MySQLi để tránh tấn công SQL injection

    // Điều hướng người dùng đến trang chính của ứng dụng hoặc trang đăng nhập
    header("Location: login.php");
    exit;
}
?>

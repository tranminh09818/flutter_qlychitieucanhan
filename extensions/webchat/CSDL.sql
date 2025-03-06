VIII:
1 thêm dữ liệu vào bảng
INSERT INTO ten_bang (ten_cot1, ten_cot2, ..., ten_cotN)
VALUES (gia_tri1, gia_tri2, ..., gia_triN);
VD:thêm 1 bảng với mã sách mã nxb, tên sách, số lượng.
INSERT INTO SÁCH (Mã sách, Mã NXB, Tên sách, Số lượng)
VALUES (1234, 4567, 'Thúy Kiều', 2);
2 xóa dữ liệu
DELETE FROM ten_bang
WHERE dieu_kien;
VD:xóa 1 sách
DELETE FROM SÁCH
WHERE Mã Sách = 1;
3 Sửa dữ liệu
UPDATE ten_bang
SET ten_cot1 = gia_tri_moi1, ten_cot2 = gia_tri_moi2, ..., ten_cotN = gia_tri_moiN
WHERE dieu_kien;
VD:cập nhật sách
UPDATE SÁCH
SET Tên sách = 'Thúy Kiều'
WHERE Mã sách = 1;
4 câu lệnh truy vấn
SELECT ten_cot1, ten_cot2, ..., ten_cotN
FROM ten_bang
WHERE dieu_kien;
VD: -lấy tất cả sách
SELECT * FROM SÁCH;
-Lấy riêng sách theo tên
SELECT SÁCH.Tên sách, Vị trí.kệ
FROM SÁCH
INNER JOIN Vị trí  ON SÁCH.Tên sách = Vị trí.mã vị trí;
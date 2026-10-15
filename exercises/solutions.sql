-- =====================================================================
-- HOTEL MANAGEMENT - 120 BÀI LUYỆN SQL (PostgreSQL) - ĐÁP ÁN
-- Mốc "hôm nay" trong các bài: 2026-06-30 (để kết quả ổn định)
-- Ghi chú dữ liệu:
--   room_types.details   = 'Deluxe Double #5'      -> hạng = split_part(details,' ',1)
--   customer_types.details = 'Khách VIP - hạng 3'  -> loại = split_part(details,' - ',1)
--   payments.payment_details = 'Tiền mặt - GD000001'
--   Doanh thu phòng   = booking_histories.total_payment
--   Doanh thu dịch vụ = invoice_details.quantity * service_details.price
-- =====================================================================


-- ## Module 1 — SELECT, WHERE, ORDER BY, LIMIT, DISTINCT

-- ### Bài 1 — Bảng giá phòng
-- Đề: Lễ tân cần bảng giá để báo khách qua điện thoại. Liệt kê tên phòng và giá, phòng đắt nhất lên đầu.
-- Output: room_name, price
SELECT room_name, price
FROM rooms
ORDER BY price DESC;

-- ### Bài 2 — Phòng cho khách công tác
-- Đề: Một công ty hỏi phòng có giá từ 2.000.000 đến 3.000.000/đêm. Lọc các phòng phù hợp, giá tăng dần.
-- Output: id, room_name, price
SELECT id, room_name, price
FROM rooms
WHERE price BETWEEN 2000000 AND 3000000
ORDER BY price;

-- ### Bài 3 — Nhân viên đã nghỉ
-- Đề: Phòng nhân sự cần danh sách nhân viên đã ngừng hoạt động để thu hồi thẻ ra vào.
-- Output: id, fullname, phone, created_date
SELECT id, fullname, phone, created_date
FROM employees
WHERE is_active = false
ORDER BY id;

-- ### Bài 4 — Tri ân khách lớn tuổi
-- Đề: Marketing muốn gửi quà cho 10 khách hàng lớn tuổi nhất.
-- Output: fullname, dob, phone
SELECT fullname, dob, phone
FROM customers
ORDER BY dob
LIMIT 10;

-- ### Bài 5 — Đơn vị tính trong kho
-- Đề: Kế toán kho muốn biết hệ thống đang dùng những đơn vị tính nào (không trùng).
-- Output: unit
SELECT DISTINCT unit
FROM service_details
ORDER BY unit;

-- ### Bài 6 — Khách họ Nguyễn / Trần
-- Đề: Chương trình "Dòng họ Việt" ưu đãi cho khách họ Nguyễn hoặc Trần. Lấy danh sách khách đủ điều kiện.
-- Output: id, fullname, email
SELECT id, fullname, email
FROM customers
WHERE fullname LIKE 'Nguyễn %' OR fullname LIKE 'Trần %'
ORDER BY fullname;

-- ### Bài 7 — Voucher còn hiệu lực
-- Đề: Khách đến check-in ngày 2026-01-15 hỏi có voucher nào áp dụng được. Liệt kê voucher còn hiệu lực ngày đó.
-- Output: voucher_code, voucher_percent, date_start, date_end
SELECT voucher_code, voucher_percent, date_start, date_end
FROM vouchers
WHERE DATE '2026-01-15' BETWEEN date_start AND date_end;

-- ### Bài 8 — Voucher giảm sâu
-- Đề: Liệt kê voucher giảm từ 25% trở lên; ưu tiên % giảm cao, cùng % thì voucher hết hạn sớm hơn lên trước.
-- Output: voucher_code, voucher_percent, date_end
SELECT voucher_code, voucher_percent, date_end
FROM vouchers
WHERE voucher_percent >= 25
ORDER BY voucher_percent DESC, date_end;

-- ### Bài 9 — Hàng cần đặt thêm
-- Đề: Mặt hàng nào tồn kho dưới 50 cần lên đơn đặt hàng? Sắp theo tồn kho tăng dần.
-- Output: service_code, name_service, remaining_inventory, unit
SELECT service_code, name_service, remaining_inventory, unit
FROM service_details
WHERE remaining_inventory < 50
ORDER BY remaining_inventory;

-- ### Bài 10 — Đồ thất lạc khu thể thao
-- Đề: Quản lý khu tiện ích cần danh sách đồ thất lạc còn đang giữ, tìm thấy ở Hồ bơi hoặc Gym.
-- Output: id, item_name, location_found, date_found
SELECT id, item_name, location_found, date_found
FROM lost_items
WHERE status = 'Đang giữ'
  AND location_found IN ('Hồ bơi', 'Gym')
ORDER BY date_found DESC;

-- ### Bài 11 — Booking chưa cọc
-- Đề: Kế toán cần nhắc khách đóng cọc. Lấy các booking có tiền cọc bằng 0.
-- Output: id, customer_id, date_booking, date_start
SELECT id, customer_id, date_booking, date_start
FROM bookings
WHERE deposits = 0
ORDER BY date_start;

-- ### Bài 12 — Phân trang danh sách khách
-- Đề: Màn hình CRM hiển thị 10 khách/trang theo id. Viết truy vấn lấy trang 3.
-- Output: id, fullname, phone
SELECT id, fullname, phone
FROM customers
ORDER BY id
LIMIT 10 OFFSET 20;


-- ## Module 2 — Hàm chuỗi, ngày, số và xử lý NULL

-- ### Bài 13 — Chuẩn hóa thông tin nhân viên
-- Đề: Xuất danh sách in thẻ nhân viên: họ tên viết HOA, email viết thường, và độ dài họ tên.
-- Output: id, ten_in_the, email, do_dai_ten
SELECT id,
       UPPER(fullname)  AS ten_in_the,
       LOWER(email)     AS email,
       LENGTH(fullname) AS do_dai_ten
FROM employees;

-- ### Bài 14 — Tên gọi trên thiệp
-- Đề: Thiệp chúc mừng chỉ ghi tên (từ cuối cùng của họ tên). Tách tên của từng khách.
-- Output: fullname, ten
SELECT fullname,
       split_part(fullname, ' ', -1) AS ten
FROM customers;

-- ### Bài 15 — Che CCCD
-- Đề: Báo cáo gửi đối tác không được lộ CCCD đầy đủ. Hiển thị CCCD dạng '********1234' (chỉ giữ 4 số cuối).
-- Output: fullname, cccd_an
SELECT fullname,
       repeat('*', length(citizen_identity) - 4) || right(citizen_identity, 4) AS cccd_an
FROM customers;

-- ### Bài 16 — Tuổi khách hàng
-- Đề: Tính tuổi hiện tại (số năm tròn) của từng khách hàng tính đến 2026-06-30.
-- Output: fullname, dob, tuoi
SELECT fullname, dob,
       EXTRACT(YEAR FROM age(DATE '2026-06-30', dob))::int AS tuoi
FROM customers
ORDER BY tuoi DESC;

-- ### Bài 17 — Số đêm lưu trú
-- Đề: Tính số đêm của từng booking (ngày trả phòng - ngày nhận phòng).
-- Output: id, date_start, date_end, so_dem
SELECT id, date_start, date_end,
       date_end::date - date_start::date AS so_dem
FROM bookings
ORDER BY so_dem DESC;

-- ### Bài 18 — Thứ nhận phòng
-- Đề: Bộ phận buồng phòng muốn biết khách nhận phòng vào thứ mấy để xếp ca. Hiển thị thứ (1=Thứ 2 ... 7=Chủ nhật) và tên thứ.
-- Output: id, date_start, thu_so, thu_ten
SELECT id, date_start,
       EXTRACT(ISODOW FROM date_start)::int AS thu_so,
       to_char(date_start, 'Dy')            AS thu_ten
FROM bookings;

-- ### Bài 19 — Giải mã voucher
-- Đề: Mã voucher có dạng VC + YYMM + số thứ tự. Tách ra tháng phát hành dạng 'YYYY-MM' và tính số ngày hiệu lực.
-- Output: voucher_code, thang_phat_hanh, so_ngay_hieu_luc
SELECT voucher_code,
       '20' || substring(voucher_code, 3, 2) || '-' || substring(voucher_code, 5, 2) AS thang_phat_hanh,
       date_end - date_start AS so_ngay_hieu_luc
FROM vouchers;

-- ### Bài 20 — Booking không dùng voucher
-- Đề: Trong danh sách booking, cột voucher hiển thị 'Không dùng' nếu khách không áp voucher.
-- Output: id, customer_id, voucher
SELECT id, customer_id,
       COALESCE(vouchers_id::text, 'Không dùng') AS voucher
FROM bookings;

-- ### Bài 21 — Yêu cầu đặc biệt
-- Đề: Phiếu bàn giao buồng phòng: nếu không có yêu cầu đặc biệt thì ghi 'Không có yêu cầu'.
-- Output: booking_id, yeu_cau
SELECT booking_id,
       COALESCE(special_request, 'Không có yêu cầu') AS yeu_cau
FROM booking_histories;

-- ### Bài 22 — Giá sau VAT
-- Đề: Niêm yết giá đã gồm VAT 8%, làm tròn đến hàng nghìn, kèm giá quy ra triệu đồng (2 chữ số thập phân).
-- Output: room_name, price, gia_vat, gia_trieu
SELECT room_name, price,
       ROUND(price * 1.08, -3)        AS gia_vat,
       ROUND(price * 1.08 / 1e6, 2)   AS gia_trieu
FROM rooms;

-- ### Bài 23 — Tách hạng phòng và kiểu giường
-- Đề: Từ mô tả loại phòng (vd 'Deluxe Double #5') tách ra hạng phòng và kiểu giường, liệt kê các tổ hợp không trùng.
-- Output: hang_phong, kieu_giuong
SELECT DISTINCT
       split_part(details, ' ', 1) AS hang_phong,
       split_part(details, ' ', 2) AS kieu_giuong
FROM room_types
ORDER BY 1, 2;

-- ### Bài 24 — SĐT quốc tế
-- Đề: Hệ thống gửi SMS quốc tế yêu cầu số dạng +84xxxxxxxxx. Chuyển đổi SĐT khách hàng.
-- Output: fullname, phone, phone_intl
SELECT fullname, phone,
       '+84' || substring(phone FROM 2) AS phone_intl
FROM customers;


-- ## Module 3 — CASE WHEN

-- ### Bài 25 — Phân khúc phòng
-- Đề: Gắn nhãn phân khúc: giá < 1,5tr 'Bình dân'; < 3tr 'Trung cấp'; còn lại 'Cao cấp'.
-- Output: room_name, price, phan_khuc
SELECT room_name, price,
       CASE WHEN price < 1500000 THEN 'Bình dân'
            WHEN price < 3000000 THEN 'Trung cấp'
            ELSE 'Cao cấp' END AS phan_khuc
FROM rooms;

-- ### Bài 26 — Nhóm tuổi khách
-- Đề: Phân nhóm tuổi (tính đến 2026-06-30): < 30 'Trẻ'; 30–45 'Trung niên trẻ'; 46–60 'Trung niên'; > 60 'Cao tuổi'.
-- Output: fullname, tuoi, nhom_tuoi
SELECT fullname, tuoi,
       CASE WHEN tuoi < 30 THEN 'Trẻ'
            WHEN tuoi <= 45 THEN 'Trung niên trẻ'
            WHEN tuoi <= 60 THEN 'Trung niên'
            ELSE 'Cao tuổi' END AS nhom_tuoi
FROM (SELECT fullname, EXTRACT(YEAR FROM age(DATE '2026-06-30', dob))::int AS tuoi FROM customers) t;

-- ### Bài 27 — Trạng thái voucher
-- Đề: Tại ngày 2026-06-30, mỗi voucher ở trạng thái 'Chưa hiệu lực', 'Đang hiệu lực' hay 'Hết hạn'?
-- Output: voucher_code, date_start, date_end, trang_thai
SELECT voucher_code, date_start, date_end,
       CASE WHEN DATE '2026-06-30' < date_start THEN 'Chưa hiệu lực'
            WHEN DATE '2026-06-30' > date_end   THEN 'Hết hạn'
            ELSE 'Đang hiệu lực' END AS trang_thai
FROM vouchers;

-- ### Bài 28 — Cảnh báo tồn kho
-- Đề: Gắn mức cảnh báo: 0 'Hết hàng'; < 50 'Sắp hết'; < 200 'Ổn định'; còn lại 'Tồn nhiều'.
-- Output: name_service, remaining_inventory, canh_bao
SELECT name_service, remaining_inventory,
       CASE WHEN remaining_inventory = 0 THEN 'Hết hàng'
            WHEN remaining_inventory < 50 THEN 'Sắp hết'
            WHEN remaining_inventory < 200 THEN 'Ổn định'
            ELSE 'Tồn nhiều' END AS canh_bao
FROM service_details;

-- ### Bài 29 — Loại hình lưu trú
-- Đề: Theo số đêm: 1 đêm 'Qua đêm'; 2–3 đêm 'Ngắn ngày'; từ 4 đêm 'Dài ngày'.
-- Output: id, so_dem, loai_luu_tru
SELECT id, so_dem,
       CASE WHEN so_dem <= 1 THEN 'Qua đêm'
            WHEN so_dem <= 3 THEN 'Ngắn ngày'
            ELSE 'Dài ngày' END AS loai_luu_tru
FROM (SELECT id, date_end::date - date_start::date AS so_dem FROM bookings) t;

-- ### Bài 30 — Cuối tuần hay ngày thường
-- Đề: Revenue manager muốn biết booking nhận phòng cuối tuần (Thứ 7, CN) hay ngày thường.
-- Output: id, date_start, loai_ngay
SELECT id, date_start,
       CASE WHEN EXTRACT(ISODOW FROM date_start) IN (6, 7) THEN 'Cuối tuần'
            ELSE 'Ngày thường' END AS loai_ngay
FROM bookings;

-- ### Bài 31 — Lead time đặt phòng
-- Đề: Lead time = số ngày từ lúc đặt đến ngày nhận phòng. Phân loại: 0 'Đặt ngay'; 1–7 'Sát ngày'; 8–21 'Bình thường'; > 21 'Đặt sớm'.
-- Output: id, lead_time, nhom_lead_time
SELECT id, lead_time,
       CASE WHEN lead_time = 0 THEN 'Đặt ngay'
            WHEN lead_time <= 7 THEN 'Sát ngày'
            WHEN lead_time <= 21 THEN 'Bình thường'
            ELSE 'Đặt sớm' END AS nhom_lead_time
FROM (SELECT id, date_start::date - date_booking::date AS lead_time FROM bookings) t;

-- ### Bài 32 — Mức đặt cọc
-- Đề: Phân loại tiền cọc: 0 'Chưa cọc'; ≤ 500k 'Cọc giữ chỗ'; ≤ 1tr 'Cọc tiêu chuẩn'; > 1tr 'Cọc cao'.
-- Output: id, deposits, muc_coc
SELECT id, deposits,
       CASE WHEN deposits = 0 THEN 'Chưa cọc'
            WHEN deposits <= 500000 THEN 'Cọc giữ chỗ'
            WHEN deposits <= 1000000 THEN 'Cọc tiêu chuẩn'
            ELSE 'Cọc cao' END AS muc_coc
FROM bookings;

-- ### Bài 33 — Danh xưng trong thư
-- Đề: Thư mời tiệc cuối năm cần danh xưng: nam 'Anh', nữ 'Chị', ghép với tên (từ cuối).
-- Output: fullname, loi_chao  (vd 'Kính gửi Anh Hùng')
SELECT fullname,
       'Kính gửi ' || CASE gender WHEN 'Nam' THEN 'Anh ' ELSE 'Chị ' END
                   || split_part(fullname, ' ', -1) AS loi_chao
FROM employees;

-- ### Bài 34 — Ưu tiên xử lý đồ thất lạc
-- Đề: Sắp danh sách đồ thất lạc: 'Đang giữ' lên đầu, rồi 'Đã trả khách', cuối cùng 'Đã thanh lý'; trong mỗi nhóm mới nhất trước.
-- Output: id, item_name, status, date_found
SELECT id, item_name, status, date_found
FROM lost_items
ORDER BY CASE status WHEN 'Đang giữ' THEN 1
                     WHEN 'Đã trả khách' THEN 2
                     ELSE 3 END,
         date_found DESC;

-- ### Bài 35 — Ca làm khi nhặt đồ
-- Đề: Xác định ca làm việc lúc tìm thấy đồ: 06h–<14h 'Ca sáng'; 14h–<22h 'Ca chiều'; còn lại 'Ca đêm'.
-- Output: id, date_found, ca
SELECT id, date_found,
       CASE WHEN EXTRACT(HOUR FROM date_found) >= 6  AND EXTRACT(HOUR FROM date_found) < 14 THEN 'Ca sáng'
            WHEN EXTRACT(HOUR FROM date_found) >= 14 AND EXTRACT(HOUR FROM date_found) < 22 THEN 'Ca chiều'
            ELSE 'Ca đêm' END AS ca
FROM lost_items;

-- ### Bài 36 — Nhãn khuyến mãi
-- Đề: Gắn nhãn hiển thị trên app: ≥ 50% 'Siêu sale'; ≥ 20% 'Sale lớn'; còn lại 'Ưu đãi'.
-- Output: voucher_code, voucher_percent, nhan
SELECT voucher_code, voucher_percent,
       CASE WHEN voucher_percent >= 50 THEN 'Siêu sale'
            WHEN voucher_percent >= 20 THEN 'Sale lớn'
            ELSE 'Ưu đãi' END AS nhan
FROM vouchers;


-- ## Module 4 — Aggregate, GROUP BY, HAVING

-- ### Bài 37 — Tổng quan giá phòng
-- Đề: Giám đốc hỏi: có bao nhiêu phòng, giá thấp nhất, cao nhất, trung bình (làm tròn) là bao nhiêu?
-- Output: so_phong, gia_min, gia_max, gia_tb
SELECT COUNT(*) AS so_phong, MIN(price) AS gia_min, MAX(price) AS gia_max, ROUND(AVG(price)) AS gia_tb
FROM rooms;

-- ### Bài 38 — Cơ cấu nhân sự
-- Đề: Đếm số nhân viên theo giới tính và trạng thái làm việc.
-- Output: gender, is_active, so_nv
SELECT gender, is_active, COUNT(*) AS so_nv
FROM employees
GROUP BY gender, is_active
ORDER BY gender, is_active;

-- ### Bài 39 — Khách theo thế hệ
-- Đề: Đếm số khách theo thập niên sinh (1960, 1970, ...).
-- Output: thap_nien, so_khach
SELECT (EXTRACT(YEAR FROM dob)::int / 10) * 10 AS thap_nien, COUNT(*) AS so_khach
FROM customers
GROUP BY 1
ORDER BY 1;

-- ### Bài 40 — Booking theo tháng
-- Đề: Đếm số booking theo tháng nhận phòng trong năm 2025.
-- Output: thang, so_booking
SELECT to_char(date_start, 'YYYY-MM') AS thang, COUNT(*) AS so_booking
FROM bookings
WHERE date_start >= '2025-01-01' AND date_start < '2026-01-01'
GROUP BY 1
ORDER BY 1;

-- ### Bài 41 — Tháng thu cọc lớn
-- Đề: Tổng tiền cọc theo tháng đặt phòng, chỉ giữ các tháng thu cọc trên 3 triệu.
-- Output: thang_dat, tong_coc
SELECT to_char(date_booking, 'YYYY-MM') AS thang_dat, SUM(deposits) AS tong_coc
FROM bookings
GROUP BY 1
HAVING SUM(deposits) > 3000000
ORDER BY 1;

-- ### Bài 42 — Giá trị nhập kho
-- Đề: Top 10 mặt hàng có tổng giá trị nhập kho (số lượng × đơn giá nhập) cao nhất.
-- Output: servicedetails_id, tong_sl_nhap, tong_gia_tri
SELECT servicedetails_id, SUM(quantity) AS tong_sl_nhap, SUM(quantity * price) AS tong_gia_tri
FROM inventory_receiving
GROUP BY servicedetails_id
ORDER BY tong_gia_tri DESC
LIMIT 10;

-- ### Bài 43 — Nhập kho nhiều lần
-- Đề: Những mặt hàng nào được nhập kho từ 2 lần trở lên?
-- Output: servicedetails_id, so_lan_nhap
SELECT servicedetails_id, COUNT(*) AS so_lan_nhap
FROM inventory_receiving
GROUP BY servicedetails_id
HAVING COUNT(*) >= 2
ORDER BY so_lan_nhap DESC;

-- ### Bài 44 — Thống kê đồ thất lạc
-- Đề: Đếm đồ thất lạc theo vị trí và trạng thái.
-- Output: location_found, status, so_mon
SELECT location_found, status, COUNT(*) AS so_mon
FROM lost_items
GROUP BY location_found, status
ORDER BY location_found, status;

-- ### Bài 45 — Khách quay lại
-- Đề: Những khách có từ 2 booking trở lên (khách quay lại)?
-- Output: customer_id, so_booking
SELECT customer_id, COUNT(*) AS so_booking
FROM bookings
GROUP BY customer_id
HAVING COUNT(*) >= 2
ORDER BY so_booking DESC, customer_id;

-- ### Bài 46 — Phòng được đặt nhiều
-- Đề: Top 5 phòng được đặt nhiều lần nhất.
-- Output: room_id, so_lan_dat
SELECT room_id, COUNT(*) AS so_lan_dat
FROM bookings
GROUP BY room_id
ORDER BY so_lan_dat DESC, room_id
LIMIT 5;

-- ### Bài 47 — Tỉ lệ dùng voucher
-- Đề: Mỗi tháng nhận phòng: tổng booking, số booking có voucher, không voucher và % có voucher.
-- Output: thang, tong, co_voucher, khong_voucher, pct_voucher
SELECT to_char(date_start, 'YYYY-MM') AS thang,
       COUNT(*) AS tong,
       COUNT(*) FILTER (WHERE vouchers_id IS NOT NULL) AS co_voucher,
       SUM(CASE WHEN vouchers_id IS NULL THEN 1 ELSE 0 END) AS khong_voucher,
       ROUND(100.0 * COUNT(vouchers_id) / COUNT(*), 1) AS pct_voucher
FROM bookings
GROUP BY 1
ORDER BY 1;

-- ### Bài 48 — Số đêm trung bình theo thứ
-- Đề: Khách nhận phòng thứ nào thường ở lâu nhất? Tính số đêm trung bình theo thứ nhận phòng.
-- Output: thu, so_booking, dem_tb
SELECT EXTRACT(ISODOW FROM date_start)::int AS thu,
       COUNT(*) AS so_booking,
       ROUND(AVG(date_end::date - date_start::date), 2) AS dem_tb
FROM bookings
GROUP BY 1
ORDER BY dem_tb DESC;

-- ### Bài 49 — Thành viên đoàn
-- Đề: Mỗi đoàn khách: số thành viên và danh sách thành viên kèm quan hệ trên một dòng (vd 'Lê Văn An (Con), ...').
-- Output: group_id, so_tv, danh_sach
SELECT group_id,
       COUNT(*) AS so_tv,
       string_agg(fullname || ' (' || relationship || ')', ', ' ORDER BY fullname) AS danh_sach
FROM group_members
GROUP BY group_id
ORDER BY so_tv DESC, group_id;

-- ### Bài 50 — Cơ cấu voucher
-- Đề: Thống kê voucher theo mức % giảm: số voucher và số ngày hiệu lực trung bình.
-- Output: voucher_percent, so_voucher, ngay_hieu_luc_tb
SELECT voucher_percent, COUNT(*) AS so_voucher, ROUND(AVG(date_end - date_start), 1) AS ngay_hieu_luc_tb
FROM vouchers
GROUP BY voucher_percent
ORDER BY voucher_percent;


-- ## Module 5 — JOIN (INNER, LEFT, FULL, SELF, CROSS, anti-join)

-- ### Bài 51 — Nhân viên và chức vụ
-- Đề: Danh sách nhân viên kèm tên chức vụ.
-- Output: id, fullname, role_name
SELECT e.id, e.fullname, r.role_name
FROM employees e
JOIN roles r ON r.id = e.role_id
ORDER BY e.id;

-- ### Bài 52 — Chi tiết booking
-- Đề: Bảng điều phối lễ tân: mỗi booking hiển thị tên khách, tên phòng, nhân viên tạo booking, ngày nhận/trả phòng.
-- Output: booking_id, khach, phong, nhan_vien, date_start, date_end
SELECT b.id AS booking_id, c.fullname AS khach, r.room_name AS phong,
       e.fullname AS nhan_vien, b.date_start, b.date_end
FROM bookings b
JOIN customers c ON c.id = b.customer_id
JOIN rooms r     ON r.id = b.room_id
JOIN employees e ON e.id = b.employee_id
ORDER BY b.date_start;

-- ### Bài 53 — Sơ đồ phòng
-- Đề: Mỗi phòng kèm hạng phòng (từ room_types) và trạng thái hiện tại (từ room_status).
-- Output: room_name, hang_phong, loai_phong, trang_thai
SELECT r.room_name,
       split_part(rt.details, ' ', 1) AS hang_phong,
       rt.details AS loai_phong,
       split_part(rs.details, ' #', 1) AS trang_thai
FROM rooms r
JOIN room_types rt  ON rt.id = r.roomtype_id
JOIN room_status rs ON rs.id = r.room_status
ORDER BY r.room_name;

-- ### Bài 54 — Khách VIP
-- Đề: Danh sách khách thuộc loại 'Khách VIP' để chăm sóc đặc biệt.
-- Output: id, fullname, phone, loai_khach
SELECT c.id, c.fullname, c.phone, ct.details AS loai_khach
FROM customers c
JOIN customer_types ct ON ct.id = c.customer_type
WHERE ct.details LIKE 'Khách VIP%';

-- ### Bài 55 — Số booking của mọi khách
-- Đề: Liệt kê TẤT CẢ khách hàng và số booking của họ (khách chưa đặt lần nào hiển thị 0).
-- Output: id, fullname, so_booking
SELECT c.id, c.fullname, COUNT(b.id) AS so_booking
FROM customers c
LEFT JOIN bookings b ON b.customer_id = c.id
GROUP BY c.id, c.fullname
ORDER BY so_booking DESC, c.id;

-- ### Bài 56 — Khách chưa từng đặt phòng
-- Đề: Marketing muốn gửi ưu đãi lần đầu cho khách có hồ sơ nhưng chưa từng booking.
-- Output: id, fullname, email
SELECT c.id, c.fullname, c.email
FROM customers c
LEFT JOIN bookings b ON b.customer_id = c.id
WHERE b.id IS NULL;

-- ### Bài 57 — Phòng chưa từng có khách
-- Đề: Phòng nào chưa từng được đặt? (cần kiểm tra vị trí / giá)
-- Output: id, room_name, price
SELECT r.id, r.room_name, r.price
FROM rooms r
LEFT JOIN bookings b ON b.room_id = r.id
WHERE b.id IS NULL
ORDER BY r.price DESC;

-- ### Bài 58 — Lệch trạng thái tài khoản
-- Đề: Audit IT: nhân viên đang làm việc (is_active = true) nhưng tài khoản hệ thống bị khóa, và ngược lại nhân viên đã nghỉ mà tài khoản vẫn mở.
-- Output: username, fullname, nv_active, tk_active, van_de
SELECT a.username, e.fullname, e.is_active AS nv_active, a.is_active AS tk_active,
       CASE WHEN e.is_active AND NOT a.is_active THEN 'NV đang làm nhưng TK bị khóa'
            ELSE 'NV đã nghỉ nhưng TK còn mở' END AS van_de
FROM accounts a
JOIN employees e ON e.id = a.employee_id
WHERE e.is_active <> a.is_active;

-- ### Bài 59 — Ma trận phân quyền
-- Đề: Báo cáo phân quyền: username, họ tên, chức vụ, quyền được cấp.
-- Output: username, fullname, role_name, permission
SELECT a.username, e.fullname, r.role_name, au.permission
FROM accounts a
JOIN employees e    ON e.id = a.employee_id
JOIN roles r        ON r.id = e.role_id
JOIN authorities au ON au.username = a.username
ORDER BY au.permission, a.username;

-- ### Bài 60 — Mặt hàng chưa từng nhập
-- Đề: Mặt hàng có trong danh mục nhưng chưa có phiếu nhập kho nào.
-- Output: service_code, name_service
SELECT sd.service_code, sd.name_service
FROM service_details sd
LEFT JOIN inventory_receiving ir ON ir.servicedetails_id = sd.id
WHERE ir.id IS NULL;

-- ### Bài 61 — Xuất kho không có nhập
-- Đề: Đối soát kho: mặt hàng đã có phiếu xuất nhưng chưa từng có phiếu nhập (nghi sai sót).
-- Output: service_code, name_service, tong_xuat
SELECT sd.service_code, sd.name_service, SUM(idl.quantity) AS tong_xuat
FROM service_details sd
JOIN inventory_delivery idl ON idl.servicedetails_id = sd.id
WHERE NOT EXISTS (SELECT 1 FROM inventory_receiving ir WHERE ir.servicedetails_id = sd.id)
GROUP BY sd.service_code, sd.name_service;

-- ### Bài 62 — Tiền dịch vụ mỗi hóa đơn
-- Đề: Tính tổng tiền dịch vụ (số lượng × giá bán) của từng hóa đơn.
-- Output: invoices_id, so_dong, tien_dich_vu
SELECT idt.invoices_id, COUNT(*) AS so_dong, SUM(idt.quantity * sd.price) AS tien_dich_vu
FROM invoice_details idt
JOIN service_details sd ON sd.id = idt.servicedetails_id
GROUP BY idt.invoices_id
ORDER BY tien_dich_vu DESC;

-- ### Bài 63 — Hóa đơn đầy đủ
-- Đề: In danh sách hóa đơn: mã HĐ, ngày xuất, tên khách, phòng, phương thức thanh toán, thu ngân.
-- Output: invoice_id, issue_date, khach, phong, phuong_thuc, thu_ngan
SELECT i.id AS invoice_id, i.issue_date, c.fullname AS khach, r.room_name AS phong,
       split_part(p.payment_details, ' - ', 1) AS phuong_thuc, e.fullname AS thu_ngan
FROM invoices i
JOIN bookings b  ON b.id = i.booking_id
JOIN customers c ON c.id = b.customer_id
JOIN rooms r     ON r.id = b.room_id
JOIN payments p  ON p.id = i.payment_id
JOIN employees e ON e.id = i.employee_id
ORDER BY i.issue_date;

-- ### Bài 64 — Gọi trả đồ thất lạc
-- Đề: Với đồ còn 'Đang giữ': tên món, tên & SĐT khách để gọi, nhân viên đã nhặt được.
-- Output: item_name, khach, sdt_khach, nv_nhat
SELECT li.item_name, c.fullname AS khach, c.phone AS sdt_khach, e.fullname AS nv_nhat
FROM lost_items li
JOIN customers c ON c.id = li.customer_id
JOIN employees e ON e.id = li.employee_id
WHERE li.status = 'Đang giữ';

-- ### Bài 65 — Voucher áp sai thời hạn
-- Đề: Kiểm soát nội bộ: booking áp voucher nhưng ngày đặt nằm ngoài thời gian hiệu lực của voucher.
-- Output: booking_id, date_booking, voucher_code, date_start, date_end
SELECT b.id AS booking_id, b.date_booking, v.voucher_code, v.date_start, v.date_end
FROM bookings b
JOIN vouchers v ON v.id = b.vouchers_id
WHERE b.date_booking::date NOT BETWEEN v.date_start AND v.date_end;

-- ### Bài 66 — Phát hiện overbooking (SELF JOIN)
-- Đề: Tìm các cặp booking cùng phòng có khoảng lưu trú chồng lấn nhau.
-- Output: room_id, booking_1, booking_2, start_1, end_1, start_2, end_2
SELECT b1.room_id, b1.id AS booking_1, b2.id AS booking_2,
       b1.date_start AS start_1, b1.date_end AS end_1, b2.date_start AS start_2, b2.date_end AS end_2
FROM bookings b1
JOIN bookings b2 ON b2.room_id = b1.room_id
                AND b1.id < b2.id
                AND b1.date_start < b2.date_end
                AND b2.date_start < b1.date_end;

-- ### Bài 67 — Công suất phòng theo ngày (JOIN điều kiện khoảng)
-- Đề: Với mỗi ngày của tháng 08/2025, đếm số phòng có khách lưu trú qua đêm đó (ngày nào không có khách vẫn hiển thị 0).
-- Output: ngay, so_phong_co_khach
SELECT d::date AS ngay, COUNT(DISTINCT b.room_id) AS so_phong_co_khach
FROM generate_series(DATE '2025-08-01', DATE '2025-08-31', INTERVAL '1 day') d
LEFT JOIN bookings b ON d::date >= b.date_start::date AND d::date < b.date_end::date
GROUP BY d
ORDER BY d;

-- ### Bài 68 — Đối soát nhập–xuất (FULL OUTER JOIN)
-- Đề: Theo từng mặt hàng: tổng nhập, tổng xuất, chênh lệch. Phải hiện cả mặt hàng chỉ có nhập hoặc chỉ có xuất.
-- Output: servicedetails_id, tong_nhap, tong_xuat, chenh_lech
SELECT COALESCE(n.sid, x.sid) AS servicedetails_id,
       COALESCE(n.tong_nhap, 0) AS tong_nhap,
       COALESCE(x.tong_xuat, 0) AS tong_xuat,
       COALESCE(n.tong_nhap, 0) - COALESCE(x.tong_xuat, 0) AS chenh_lech
FROM (SELECT servicedetails_id AS sid, SUM(quantity) AS tong_nhap FROM inventory_receiving GROUP BY 1) n
FULL OUTER JOIN
     (SELECT servicedetails_id AS sid, SUM(quantity) AS tong_xuat FROM inventory_delivery GROUP BY 1) x
  ON x.sid = n.sid
ORDER BY 1;

-- ### Bài 69 — Hóa đơn chỉ có tiền phòng
-- Đề: Hóa đơn nào không phát sinh dòng dịch vụ nào?
-- Output: invoice_id, booking_id, issue_date
SELECT i.id AS invoice_id, i.booking_id, i.issue_date
FROM invoices i
LEFT JOIN invoice_details idt ON idt.invoices_id = i.id
WHERE idt.id IS NULL
ORDER BY i.id;

-- ### Bài 70 — Tiền dịch vụ sau giảm giá
-- Đề: Mỗi dòng dịch vụ: thành tiền gốc, % giảm (0 nếu không voucher) và thành tiền sau giảm.
-- Output: invoices_id, name_service, quantity, thanh_tien, pct_giam, sau_giam
SELECT idt.invoices_id, sd.name_service, idt.quantity,
       idt.quantity * sd.price AS thanh_tien,
       COALESCE(v.voucher_percent, 0) AS pct_giam,
       ROUND(idt.quantity * sd.price * (1 - COALESCE(v.voucher_percent, 0) / 100.0)) AS sau_giam
FROM invoice_details idt
JOIN service_details sd ON sd.id = idt.servicedetails_id
LEFT JOIN vouchers v    ON v.id = idt.vouchers_id
ORDER BY idt.invoices_id;


-- ## Module 6 — Subquery, IN, EXISTS, ANY/ALL

-- ### Bài 71 — Phòng trên giá trung bình
-- Đề: Các phòng có giá cao hơn giá trung bình toàn khách sạn.
-- Output: room_name, price
SELECT room_name, price
FROM rooms
WHERE price > (SELECT AVG(price) FROM rooms)
ORDER BY price DESC;

-- ### Bài 72 — Khách chi tiêu trên trung bình
-- Đề: Khách có tổng tiền phòng (booking_histories.total_payment) cao hơn mức chi tiêu trung bình của một khách.
-- Output: customer_id, tong_chi
SELECT b.customer_id, SUM(h.total_payment) AS tong_chi
FROM bookings b
JOIN booking_histories h ON h.booking_id = b.id
GROUP BY b.customer_id
HAVING SUM(h.total_payment) > (
    SELECT AVG(s) FROM (
        SELECT SUM(h2.total_payment) AS s
        FROM bookings b2 JOIN booking_histories h2 ON h2.booking_id = b2.id
        GROUP BY b2.customer_id) x)
ORDER BY tong_chi DESC;

-- ### Bài 73 — Nhân viên đã thu ngân
-- Đề: Những nhân viên đã từng xuất ít nhất một hóa đơn (dùng EXISTS).
-- Output: id, fullname
SELECT e.id, e.fullname
FROM employees e
WHERE EXISTS (SELECT 1 FROM invoices i WHERE i.employee_id = e.id)
ORDER BY e.id;

-- ### Bài 74 — Nhân viên chưa bán được phòng
-- Đề: Nhân viên đang làm việc nhưng chưa tạo booking nào (dùng NOT EXISTS).
-- Output: id, fullname, role_id
SELECT e.id, e.fullname, e.role_id
FROM employees e
WHERE e.is_active
  AND NOT EXISTS (SELECT 1 FROM bookings b WHERE b.employee_id = e.id)
ORDER BY e.id;

-- ### Bài 75 — Dịch vụ bán trong tháng 12/2025
-- Đề: Mặt hàng nào đã được bán (có trong invoice_details) trong tháng 12/2025? Dùng IN.
-- Output: service_code, name_service
SELECT service_code, name_service
FROM service_details
WHERE id IN (SELECT servicedetails_id FROM invoice_details
             WHERE use_date >= '2025-12-01' AND use_date < '2026-01-01');

-- ### Bài 76 — Booking gần nhất của mỗi khách (subquery tương quan)
-- Đề: Với mỗi khách, lấy booking có ngày đặt gần nhất.
-- Output: customer_id, booking_id, date_booking
SELECT b.customer_id, b.id AS booking_id, b.date_booking
FROM bookings b
WHERE b.date_booking = (SELECT MAX(b2.date_booking) FROM bookings b2 WHERE b2.customer_id = b.customer_id)
ORDER BY b.customer_id;

-- ### Bài 77 — So sánh giá từng phòng (scalar subquery)
-- Đề: Mỗi phòng: số lần được đặt và chênh lệch giá so với giá trung bình.
-- Output: room_name, price, so_lan_dat, chenh_lech_tb
SELECT r.room_name, r.price,
       (SELECT COUNT(*) FROM bookings b WHERE b.room_id = r.id) AS so_lan_dat,
       ROUND(r.price - (SELECT AVG(price) FROM rooms)) AS chenh_lech_tb
FROM rooms r
ORDER BY so_lan_dat DESC, r.room_name;

-- ### Bài 78 — Năng suất bán phòng trung bình
-- Đề: Trung bình mỗi nhân viên (có tạo booking) tạo bao nhiêu booking? Max là bao nhiêu? (dùng bảng dẫn xuất)
-- Output: so_nv, booking_tb, booking_max
SELECT COUNT(*) AS so_nv, ROUND(AVG(cnt), 2) AS booking_tb, MAX(cnt) AS booking_max
FROM (SELECT employee_id, COUNT(*) AS cnt FROM bookings GROUP BY employee_id) t;

-- ### Bài 79 — Gợi ý upsell (ALL)
-- Đề: Superior là hạng bán chạy. Để upsell, tìm các phòng có giá cao hơn TẤT CẢ phòng hạng Superior.
-- Output: room_name, price
SELECT room_name, price
FROM rooms
WHERE price > ALL (SELECT r.price FROM rooms r
                   JOIN room_types rt ON rt.id = r.roomtype_id
                   WHERE rt.details LIKE 'Superior%')
ORDER BY price DESC;

-- ### Bài 80 — Khách quen chưa từng mất đồ
-- Đề: Khách có từ 2 booking trở lên và chưa từng có món đồ thất lạc nào.
-- Output: customer_id, so_booking
SELECT customer_id, COUNT(*) AS so_booking
FROM bookings
WHERE customer_id NOT IN (SELECT customer_id FROM lost_items WHERE customer_id IS NOT NULL)
GROUP BY customer_id
HAVING COUNT(*) >= 2;


-- ## Module 7 — CTE (WITH), Recursive CTE

-- ### Bài 81 — Tổng doanh thu mỗi booking
-- Đề: Với mỗi booking: tiền phòng, tiền dịch vụ (0 nếu không có), tổng cộng.
-- Output: booking_id, tien_phong, tien_dv, tong
WITH dv AS (
    SELECT i.booking_id, SUM(idt.quantity * sd.price) AS tien_dv
    FROM invoices i
    JOIN invoice_details idt ON idt.invoices_id = i.id
    JOIN service_details sd  ON sd.id = idt.servicedetails_id
    GROUP BY i.booking_id
)
SELECT h.booking_id, h.total_payment AS tien_phong,
       COALESCE(dv.tien_dv, 0) AS tien_dv,
       h.total_payment + COALESCE(dv.tien_dv, 0) AS tong
FROM booking_histories h
LEFT JOIN dv ON dv.booking_id = h.booking_id
ORDER BY tong DESC;

-- ### Bài 82 — Doanh thu theo tháng
-- Đề: Báo cáo tháng: doanh thu phòng (theo tháng trả phòng) và doanh thu dịch vụ (theo tháng sử dụng), ghép theo tháng.
-- Output: thang, dt_phong, dt_dv, dt_tong
WITH phong AS (
    SELECT date_trunc('month', date_end) AS thang, SUM(total_payment) AS dt_phong
    FROM booking_histories GROUP BY 1
), dv AS (
    SELECT date_trunc('month', idt.use_date) AS thang, SUM(idt.quantity * sd.price) AS dt_dv
    FROM invoice_details idt JOIN service_details sd ON sd.id = idt.servicedetails_id
    GROUP BY 1
)
SELECT to_char(COALESCE(p.thang, d.thang), 'YYYY-MM') AS thang,
       COALESCE(p.dt_phong, 0) AS dt_phong,
       COALESCE(d.dt_dv, 0)    AS dt_dv,
       COALESCE(p.dt_phong, 0) + COALESCE(d.dt_dv, 0) AS dt_tong
FROM phong p
FULL JOIN dv d ON d.thang = p.thang
ORDER BY 1;

-- ### Bài 83 — Top 10 khách & hạng đề xuất
-- Đề: Top 10 khách theo tổng chi tiêu (phòng + dịch vụ) và đề xuất hạng: ≥ 20tr 'Kim cương', ≥ 10tr 'Vàng', còn lại 'Bạc'.
-- Output: customer_id, fullname, tong_chi, hang_de_xuat
WITH dv AS (
    SELECT i.booking_id, SUM(idt.quantity * sd.price) AS tien_dv
    FROM invoices i
    JOIN invoice_details idt ON idt.invoices_id = i.id
    JOIN service_details sd  ON sd.id = idt.servicedetails_id
    GROUP BY i.booking_id
), chi AS (
    SELECT b.customer_id, SUM(h.total_payment + COALESCE(dv.tien_dv, 0)) AS tong_chi
    FROM bookings b
    JOIN booking_histories h ON h.booking_id = b.id
    LEFT JOIN dv ON dv.booking_id = b.id
    GROUP BY b.customer_id
)
SELECT chi.customer_id, c.fullname, chi.tong_chi,
       CASE WHEN tong_chi >= 20000000 THEN 'Kim cương'
            WHEN tong_chi >= 10000000 THEN 'Vàng'
            ELSE 'Bạc' END AS hang_de_xuat
FROM chi JOIN customers c ON c.id = chi.customer_id
ORDER BY tong_chi DESC
LIMIT 10;

-- ### Bài 84 — Tỉ lệ lấp đầy theo tháng
-- Đề: Occupancy tháng = số đêm phòng đã bán / (tổng số phòng × số ngày trong tháng). Tính cho năm 2025 (gán số đêm vào tháng nhận phòng).
-- Output: thang, dem_ban, dem_kha_dung, occupancy_pct
WITH ban AS (
    SELECT date_trunc('month', date_start) AS thang, SUM(date_end::date - date_start::date) AS dem_ban
    FROM bookings
    WHERE date_start >= '2025-01-01' AND date_start < '2026-01-01'
    GROUP BY 1
), cap AS (
    SELECT (SELECT COUNT(*) FROM rooms) AS so_phong
)
SELECT to_char(thang, 'YYYY-MM') AS thang, dem_ban,
       so_phong * EXTRACT(DAY FROM thang + INTERVAL '1 month - 1 day')::int AS dem_kha_dung,
       ROUND(100.0 * dem_ban / (so_phong * EXTRACT(DAY FROM thang + INTERVAL '1 month - 1 day')), 2) AS occupancy_pct
FROM ban CROSS JOIN cap
ORDER BY 1;

-- ### Bài 85 — Lịch check-in (Recursive CTE)
-- Đề: Dùng recursive CTE sinh các ngày tháng 08/2025, đếm số lượt check-in mỗi ngày (ngày không có vẫn hiện 0).
-- Output: ngay, so_checkin
WITH RECURSIVE lich AS (
    SELECT DATE '2025-08-01' AS ngay
    UNION ALL
    SELECT ngay + 1 FROM lich WHERE ngay < DATE '2025-08-31'
)
SELECT l.ngay, COUNT(b.id) AS so_checkin
FROM lich l
LEFT JOIN bookings b ON b.date_start::date = l.ngay
GROUP BY l.ngay
ORDER BY l.ngay;

-- ### Bài 86 — KPI nhân viên
-- Đề: Mỗi nhân viên: số booking đã tạo, số hóa đơn đã xuất, số đồ thất lạc đã nhặt (0 nếu không có).
-- Output: id, fullname, so_booking, so_hoa_don, so_do_nhat
WITH bk AS (SELECT employee_id, COUNT(*) n FROM bookings   GROUP BY 1),
     hd AS (SELECT employee_id, COUNT(*) n FROM invoices   GROUP BY 1),
     dl AS (SELECT employee_id, COUNT(*) n FROM lost_items GROUP BY 1)
SELECT e.id, e.fullname,
       COALESCE(bk.n, 0) AS so_booking,
       COALESCE(hd.n, 0) AS so_hoa_don,
       COALESCE(dl.n, 0) AS so_do_nhat
FROM employees e
LEFT JOIN bk ON bk.employee_id = e.id
LEFT JOIN hd ON hd.employee_id = e.id
LEFT JOIN dl ON dl.employee_id = e.id
ORDER BY COALESCE(bk.n, 0) + COALESCE(hd.n, 0) + COALESCE(dl.n, 0) DESC;

-- ### Bài 87 — Khách "ngủ đông"
-- Đề: Khách có lần nhận phòng gần nhất cách mốc 2026-06-30 hơn 180 ngày → cần chiến dịch kéo lại.
-- Output: customer_id, fullname, lan_cuoi, so_ngay_vang
WITH lan_cuoi AS (
    SELECT customer_id, MAX(date_start)::date AS lan_cuoi
    FROM bookings GROUP BY customer_id
)
SELECT lc.customer_id, c.fullname, lc.lan_cuoi, DATE '2026-06-30' - lc.lan_cuoi AS so_ngay_vang
FROM lan_cuoi lc JOIN customers c ON c.id = lc.customer_id
WHERE DATE '2026-06-30' - lc.lan_cuoi > 180
ORDER BY so_ngay_vang DESC;

-- ### Bài 88 — Biên lợi nhuận mặt hàng
-- Đề: Giá vốn = giá nhập bình quân gia quyền. So với giá bán hiện tại, tính lãi gộp/đơn vị và % biên lợi nhuận; mặt hàng bán lỗ đưa lên đầu.
-- Output: name_service, gia_von, gia_ban, lai_gop, bien_pct
WITH von AS (
    SELECT servicedetails_id, SUM(quantity * price) / SUM(quantity) AS gia_von
    FROM inventory_receiving GROUP BY 1
)
SELECT sd.name_service, ROUND(v.gia_von) AS gia_von, sd.price AS gia_ban,
       ROUND(sd.price - v.gia_von) AS lai_gop,
       ROUND(100 * (sd.price - v.gia_von) / sd.price, 1) AS bien_pct
FROM von v JOIN service_details sd ON sd.id = v.servicedetails_id
ORDER BY bien_pct;


-- ## Module 8 — UNION, INTERSECT, EXCEPT

-- ### Bài 89 — Danh bạ chung
-- Đề: Tổng đài cần một danh bạ gồm cả nhân viên và khách hàng: họ tên, SĐT, email, loại liên hệ.
-- Output: fullname, phone, email, loai
SELECT fullname, phone, email, 'Nhân viên' AS loai FROM employees
UNION ALL
SELECT fullname, phone, email, 'Khách hàng' FROM customers
ORDER BY fullname;

-- ### Bài 90 — Thẻ kho
-- Đề: Lập thẻ kho: gộp phiếu nhập (số dương) và phiếu xuất (số âm) thành một nhật ký, sắp theo mặt hàng và thời gian.
-- Output: servicedetails_id, thoi_gian, loai, so_luong
SELECT servicedetails_id, in_date AS thoi_gian, 'Nhập' AS loai, quantity AS so_luong FROM inventory_receiving
UNION ALL
SELECT servicedetails_id, out_date, 'Xuất', -quantity FROM inventory_delivery
ORDER BY servicedetails_id, thoi_gian;

-- ### Bài 91 — Khách vừa ở vừa mất đồ (INTERSECT)
-- Đề: Những customer_id vừa có booking vừa có đồ thất lạc.
-- Output: customer_id
SELECT customer_id FROM bookings
INTERSECT
SELECT customer_id FROM lost_items
ORDER BY 1;

-- ### Bài 92 — Hàng nhập về nhưng chưa bán (EXCEPT)
-- Đề: Mặt hàng đã nhập kho nhưng chưa bán được lần nào.
-- Output: servicedetails_id
SELECT servicedetails_id FROM inventory_receiving
EXCEPT
SELECT servicedetails_id FROM invoice_details
ORDER BY 1;

-- ### Bài 93 — Doanh thu dịch vụ theo phương thức + dòng tổng
-- Đề: Doanh thu dịch vụ theo phương thức thanh toán, cuối bảng có dòng 'TỔNG CỘNG' (dùng UNION ALL).
-- Output: phuong_thuc, doanh_thu
WITH t AS (
    SELECT split_part(p.payment_details, ' - ', 1) AS phuong_thuc, idt.quantity * sd.price AS tien
    FROM invoices i
    JOIN payments p          ON p.id = i.payment_id
    JOIN invoice_details idt ON idt.invoices_id = i.id
    JOIN service_details sd  ON sd.id = idt.servicedetails_id
)
SELECT phuong_thuc, doanh_thu FROM (
    SELECT phuong_thuc, SUM(tien) AS doanh_thu, 1 AS ord FROM t GROUP BY phuong_thuc
    UNION ALL
    SELECT 'TỔNG CỘNG', SUM(tien), 2 FROM t
) x
ORDER BY ord, doanh_thu DESC;


-- ## Module 9 — Báo cáo tổng hợp, pivot bằng CASE, ROLLUP

-- ### Bài 94 — Pivot booking theo quý
-- Đề: Số booking năm 2025 theo phân khúc giá phòng (Bình dân < 1,5tr / Trung cấp < 3tr / Cao cấp), mỗi quý là một cột.
-- Output: phan_khuc, q1, q2, q3, q4, ca_nam
SELECT CASE WHEN r.price < 1500000 THEN 'Bình dân'
            WHEN r.price < 3000000 THEN 'Trung cấp'
            ELSE 'Cao cấp' END AS phan_khuc,
       COUNT(*) FILTER (WHERE EXTRACT(QUARTER FROM b.date_start) = 1) AS q1,
       COUNT(*) FILTER (WHERE EXTRACT(QUARTER FROM b.date_start) = 2) AS q2,
       COUNT(*) FILTER (WHERE EXTRACT(QUARTER FROM b.date_start) = 3) AS q3,
       COUNT(*) FILTER (WHERE EXTRACT(QUARTER FROM b.date_start) = 4) AS q4,
       COUNT(*) AS ca_nam
FROM bookings b JOIN rooms r ON r.id = b.room_id
WHERE b.date_start >= '2025-01-01' AND b.date_start < '2026-01-01'
GROUP BY 1
ORDER BY 1;

-- ### Bài 95 — Doanh thu dịch vụ có subtotal (ROLLUP)
-- Đề: Doanh thu dịch vụ theo đơn vị tính → mặt hàng, có dòng tổng phụ mỗi đơn vị và dòng tổng toàn bộ.
-- Output: unit, name_service, doanh_thu
SELECT COALESCE(sd.unit, '== TỔNG ==') AS unit,
       COALESCE(sd.name_service, CASE WHEN sd.unit IS NOT NULL THEN '-- Tổng ' || sd.unit END) AS name_service,
       SUM(idt.quantity * sd.price) AS doanh_thu
FROM invoice_details idt
JOIN service_details sd ON sd.id = idt.servicedetails_id
GROUP BY ROLLUP (sd.unit, sd.name_service)
ORDER BY sd.unit NULLS LAST, sd.name_service NULLS LAST;

-- ### Bài 96 — Báo cáo thu ngân
-- Đề: Mỗi thu ngân: số hóa đơn thu tiền mặt, số hóa đơn không dùng tiền mặt, % không tiền mặt.
-- Output: thu_ngan, hd_tien_mat, hd_khong_tien_mat, pct_khong_tien_mat
SELECT e.fullname AS thu_ngan,
       SUM(CASE WHEN p.payment_details LIKE 'Tiền mặt%' THEN 1 ELSE 0 END) AS hd_tien_mat,
       SUM(CASE WHEN p.payment_details NOT LIKE 'Tiền mặt%' THEN 1 ELSE 0 END) AS hd_khong_tien_mat,
       ROUND(100.0 * SUM(CASE WHEN p.payment_details NOT LIKE 'Tiền mặt%' THEN 1 ELSE 0 END) / COUNT(*), 1) AS pct_khong_tien_mat
FROM invoices i
JOIN employees e ON e.id = i.employee_id
JOIN payments p  ON p.id = i.payment_id
GROUP BY e.fullname
ORDER BY COUNT(*) DESC;

-- ### Bài 97 — Hiệu quả voucher
-- Đề: Mỗi voucher đã được dùng: số lần áp vào booking, số dòng dịch vụ áp dụng, tổng tiền dịch vụ được giảm.
-- Output: voucher_code, voucher_percent, lan_dung_booking, lan_dung_dv, tien_giam_dv
WITH bk AS (SELECT vouchers_id, COUNT(*) n FROM bookings WHERE vouchers_id IS NOT NULL GROUP BY 1),
     dv AS (SELECT idt.vouchers_id, COUNT(*) n, SUM(idt.quantity * sd.price) AS tien
            FROM invoice_details idt JOIN service_details sd ON sd.id = idt.servicedetails_id
            WHERE idt.vouchers_id IS NOT NULL GROUP BY 1)
SELECT v.voucher_code, v.voucher_percent,
       COALESCE(bk.n, 0) AS lan_dung_booking,
       COALESCE(dv.n, 0) AS lan_dung_dv,
       ROUND(COALESCE(dv.tien, 0) * v.voucher_percent / 100) AS tien_giam_dv
FROM vouchers v
LEFT JOIN bk ON bk.vouchers_id = v.id
LEFT JOIN dv ON dv.vouchers_id = v.id
WHERE bk.n IS NOT NULL OR dv.n IS NOT NULL
ORDER BY tien_giam_dv DESC;

-- ### Bài 98 — Phân tích phản hồi
-- Đề: Phân loại feedback: chứa 'yếu' → 'Tiêu cực', còn lại 'Tích cực'; đếm theo loại và nội dung.
-- Output: cam_xuc, feedback, so_luot
SELECT CASE WHEN feedback LIKE '%yếu%' THEN 'Tiêu cực' ELSE 'Tích cực' END AS cam_xuc,
       feedback, COUNT(*) AS so_luot
FROM booking_histories
GROUP BY 1, 2
ORDER BY 1, so_luot DESC;

-- ### Bài 99 — Dashboard KPI
-- Đề: Một dòng KPI tổng: số khách đã lưu trú, số booking, tổng đêm bán, ADR (doanh thu phòng/đêm), ALOS (số đêm TB/booking), doanh thu phòng.
-- Output: so_khach, so_booking, tong_dem, adr, alos, dt_phong
SELECT COUNT(DISTINCT b.customer_id) AS so_khach,
       COUNT(*) AS so_booking,
       SUM(b.date_end::date - b.date_start::date) AS tong_dem,
       ROUND(SUM(h.total_payment) / NULLIF(SUM(b.date_end::date - b.date_start::date), 0)) AS adr,
       ROUND(AVG(b.date_end::date - b.date_start::date), 2) AS alos,
       SUM(h.total_payment) AS dt_phong
FROM bookings b
JOIN booking_histories h ON h.booking_id = b.id;

-- ### Bài 100 — Pivot khách theo loại × nhóm tuổi
-- Đề: Số khách theo loại khách (hàng) và nhóm tuổi (cột: duoi_30, tu_30_45, tu_46_60, tren_60), tuổi tính đến 2026-06-30.
-- Output: loai_khach, duoi_30, tu_30_45, tu_46_60, tren_60
WITH t AS (
    SELECT split_part(ct.details, ' - ', 1) AS loai_khach,
           EXTRACT(YEAR FROM age(DATE '2026-06-30', c.dob))::int AS tuoi
    FROM customers c JOIN customer_types ct ON ct.id = c.customer_type
)
SELECT loai_khach,
       COUNT(*) FILTER (WHERE tuoi < 30)               AS duoi_30,
       COUNT(*) FILTER (WHERE tuoi BETWEEN 30 AND 45)  AS tu_30_45,
       COUNT(*) FILTER (WHERE tuoi BETWEEN 46 AND 60)  AS tu_46_60,
       COUNT(*) FILTER (WHERE tuoi > 60)               AS tren_60
FROM t
GROUP BY loai_khach
ORDER BY loai_khach;


-- ## Module 10 — Window Function (20 bài)

-- ### Bài 101 — Xếp hạng giá trong hạng phòng (RANK)
-- Đề: Xếp hạng giá phòng trong từng hạng phòng (Standard, Deluxe, ...), đắt nhất hạng 1.
-- Output: hang_phong, room_name, price, hang_gia
SELECT split_part(rt.details, ' ', 1) AS hang_phong, r.room_name, r.price,
       RANK() OVER (PARTITION BY split_part(rt.details, ' ', 1) ORDER BY r.price DESC) AS hang_gia
FROM rooms r JOIN room_types rt ON rt.id = r.roomtype_id
ORDER BY hang_phong, hang_gia;

-- ### Bài 102 — Booking gần nhất mỗi khách (ROW_NUMBER)
-- Đề: Làm lại bài 76 bằng ROW_NUMBER: mỗi khách chỉ lấy 1 booking có ngày đặt gần nhất.
-- Output: customer_id, booking_id, date_booking
SELECT customer_id, id AS booking_id, date_booking
FROM (SELECT b.*, ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY date_booking DESC, id DESC) AS rn
      FROM bookings b) t
WHERE rn = 1
ORDER BY customer_id;

-- ### Bài 103 — Top 3 dịch vụ mỗi tháng (DENSE_RANK)
-- Đề: Mỗi tháng, top 3 mặt hàng có doanh thu dịch vụ cao nhất (đồng hạng thì lấy cả).
-- Output: thang, name_service, doanh_thu, xep_hang
WITH t AS (
    SELECT to_char(idt.use_date, 'YYYY-MM') AS thang, sd.name_service,
           SUM(idt.quantity * sd.price) AS doanh_thu
    FROM invoice_details idt JOIN service_details sd ON sd.id = idt.servicedetails_id
    GROUP BY 1, 2
)
SELECT * FROM (
    SELECT t.*, DENSE_RANK() OVER (PARTITION BY thang ORDER BY doanh_thu DESC) AS xep_hang
    FROM t) x
WHERE xep_hang <= 3
ORDER BY thang, xep_hang;

-- ### Bài 104 — Doanh thu lũy kế (running total)
-- Đề: Doanh thu phòng theo ngày trả phòng năm 2025 và doanh thu lũy kế từ đầu năm.
-- Output: ngay, dt_ngay, dt_luy_ke
SELECT ngay, dt_ngay, SUM(dt_ngay) OVER (ORDER BY ngay) AS dt_luy_ke
FROM (SELECT date_end::date AS ngay, SUM(total_payment) AS dt_ngay
      FROM booking_histories
      WHERE date_end >= '2025-01-01' AND date_end < '2026-01-01'
      GROUP BY 1) t
ORDER BY ngay;

-- ### Bài 105 — Tăng trưởng MoM (LAG)
-- Đề: Doanh thu phòng theo tháng, doanh thu tháng trước, % tăng trưởng so với tháng trước.
-- Output: thang, dt, dt_thang_truoc, tang_truong_pct
SELECT thang, dt,
       LAG(dt) OVER (ORDER BY thang) AS dt_thang_truoc,
       ROUND(100.0 * (dt - LAG(dt) OVER (ORDER BY thang)) / NULLIF(LAG(dt) OVER (ORDER BY thang), 0), 1) AS tang_truong_pct
FROM (SELECT to_char(date_end, 'YYYY-MM') AS thang, SUM(total_payment) AS dt
      FROM booking_histories GROUP BY 1) t
ORDER BY thang;

-- ### Bài 106 — Khoảng cách giữa hai lần lưu trú (LAG)
-- Đề: Với khách có nhiều booking: số ngày từ lần nhận phòng trước đến lần này; gắn nhãn 'Quay lại nhanh' nếu ≤ 90 ngày.
-- Output: customer_id, booking_id, date_start, lan_truoc, so_ngay_cach, nhan
SELECT customer_id, booking_id, date_start, lan_truoc,
       date_start::date - lan_truoc::date AS so_ngay_cach,
       CASE WHEN date_start::date - lan_truoc::date <= 90 THEN 'Quay lại nhanh' ELSE 'Quay lại chậm' END AS nhan
FROM (SELECT customer_id, id AS booking_id, date_start,
             LAG(date_start) OVER (PARTITION BY customer_id ORDER BY date_start) AS lan_truoc
      FROM bookings) t
WHERE lan_truoc IS NOT NULL
ORDER BY customer_id, date_start;

-- ### Bài 107 — Thời gian phòng trống giữa hai lượt (LEAD)
-- Đề: Với mỗi booking, tìm ngày nhận phòng của lượt khách kế tiếp ở CÙNG phòng và số ngày phòng bỏ trống ở giữa.
-- Output: room_id, booking_id, date_end, luot_ke_tiep, so_ngay_trong
SELECT room_id, id AS booking_id, date_end,
       LEAD(date_start) OVER w AS luot_ke_tiep,
       LEAD(date_start) OVER w ::date - date_end::date AS so_ngay_trong
FROM bookings
WINDOW w AS (PARTITION BY room_id ORDER BY date_start)
ORDER BY room_id, date_start;

-- ### Bài 108 — Trung bình trượt 7 ngày
-- Đề: Số check-in mỗi ngày trong Q3/2025 (kể cả ngày 0) và trung bình trượt 7 ngày gần nhất.
-- Output: ngay, so_checkin, ma7
WITH lich AS (
    SELECT d::date AS ngay FROM generate_series(DATE '2025-07-01', DATE '2025-09-30', INTERVAL '1 day') d
), t AS (
    SELECT l.ngay, COUNT(b.id) AS so_checkin
    FROM lich l LEFT JOIN bookings b ON b.date_start::date = l.ngay
    GROUP BY l.ngay
)
SELECT ngay, so_checkin,
       ROUND(AVG(so_checkin) OVER (ORDER BY ngay ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS ma7
FROM t
ORDER BY ngay;

-- ### Bài 109 — Chia hạng khách theo chi tiêu (NTILE)
-- Đề: Chia khách đã lưu trú thành 4 nhóm đều nhau theo tổng tiền phòng: nhóm 1 'Kim cương', 2 'Vàng', 3 'Bạc', 4 'Đồng'.
-- Output: customer_id, tong_chi, nhom, hang
SELECT customer_id, tong_chi, nhom,
       CASE nhom WHEN 1 THEN 'Kim cương' WHEN 2 THEN 'Vàng' WHEN 3 THEN 'Bạc' ELSE 'Đồng' END AS hang
FROM (SELECT b.customer_id, SUM(h.total_payment) AS tong_chi,
             NTILE(4) OVER (ORDER BY SUM(h.total_payment) DESC) AS nhom
      FROM bookings b JOIN booking_histories h ON h.booking_id = b.id
      GROUP BY b.customer_id) t
ORDER BY tong_chi DESC;

-- ### Bài 110 — Tỉ trọng doanh thu (SUM OVER ())
-- Đề: Doanh thu từng mặt hàng và % đóng góp vào tổng doanh thu dịch vụ.
-- Output: name_service, doanh_thu, ti_trong_pct
SELECT sd.name_service, SUM(idt.quantity * sd.price) AS doanh_thu,
       ROUND(100.0 * SUM(idt.quantity * sd.price) / SUM(SUM(idt.quantity * sd.price)) OVER (), 2) AS ti_trong_pct
FROM invoice_details idt JOIN service_details sd ON sd.id = idt.servicedetails_id
GROUP BY sd.name_service
ORDER BY doanh_thu DESC;

-- ### Bài 111 — Tỉ trọng trong nhóm đơn vị
-- Đề: Như bài 110 nhưng % tính trong từng đơn vị tính (unit), kèm tổng doanh thu của unit đó.
-- Output: unit, name_service, doanh_thu, dt_unit, pct_trong_unit
SELECT unit, name_service, doanh_thu,
       SUM(doanh_thu) OVER (PARTITION BY unit) AS dt_unit,
       ROUND(100.0 * doanh_thu / SUM(doanh_thu) OVER (PARTITION BY unit), 2) AS pct_trong_unit
FROM (SELECT sd.unit, sd.name_service, SUM(idt.quantity * sd.price) AS doanh_thu
      FROM invoice_details idt JOIN service_details sd ON sd.id = idt.servicedetails_id
      GROUP BY sd.unit, sd.name_service) t
ORDER BY unit, doanh_thu DESC;

-- ### Bài 112 — Lần lưu trú đầu tiên (FIRST_VALUE)
-- Đề: Mỗi booking hiển thị kèm phòng mà khách đó đã ở trong lần đầu tiên và ngày nhận phòng lần đầu.
-- Output: customer_id, booking_id, room_id, phong_lan_dau, ngay_lan_dau
SELECT customer_id, id AS booking_id, room_id,
       FIRST_VALUE(room_id)    OVER w AS phong_lan_dau,
       FIRST_VALUE(date_start) OVER w AS ngay_lan_dau
FROM bookings
WINDOW w AS (PARTITION BY customer_id ORDER BY date_start)
ORDER BY customer_id, date_start;

-- ### Bài 113 — Người bán gần nhất của phòng (LAST_VALUE + frame)
-- Đề: Với mỗi booking, cho biết nhân viên đã tạo booking MỚI NHẤT của phòng đó (chú ý frame mặc định của LAST_VALUE).
-- Output: room_id, booking_id, date_booking, nv_moi_nhat
SELECT room_id, id AS booking_id, date_booking,
       LAST_VALUE(employee_id) OVER (PARTITION BY room_id ORDER BY date_booking
                                     ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS nv_moi_nhat
FROM bookings
ORDER BY room_id, date_booking;

-- ### Bài 114 — Tồn kho lũy kế theo thời gian
-- Đề: Từ thẻ kho (nhập +, xuất −) tính số tồn lũy kế sau mỗi giao dịch của từng mặt hàng; đánh dấu thời điểm tồn âm.
-- Output: servicedetails_id, thoi_gian, loai, so_luong, ton_luy_ke, canh_bao
WITH the_kho AS (
    SELECT servicedetails_id, in_date AS thoi_gian, 'Nhập' AS loai, quantity AS so_luong FROM inventory_receiving
    UNION ALL
    SELECT servicedetails_id, out_date, 'Xuất', -quantity FROM inventory_delivery
)
SELECT *, CASE WHEN ton_luy_ke < 0 THEN 'TỒN ÂM' END AS canh_bao
FROM (SELECT t.*, SUM(so_luong) OVER (PARTITION BY servicedetails_id ORDER BY thoi_gian
                                      ROWS UNBOUNDED PRECEDING) AS ton_luy_ke
      FROM the_kho t) x
ORDER BY servicedetails_id, thoi_gian;

-- ### Bài 115 — Vị trí giá phòng (PERCENT_RANK, CUME_DIST)
-- Đề: Mỗi phòng nằm ở phân vị giá nào? Tính PERCENT_RANK và CUME_DIST theo giá, hiển thị dạng %.
-- Output: room_name, price, percent_rank_pct, cume_dist_pct
SELECT room_name, price,
       ROUND(100 * PERCENT_RANK() OVER (ORDER BY price)::numeric, 1) AS percent_rank_pct,
       ROUND(100 * CUME_DIST()    OVER (ORDER BY price)::numeric, 1) AS cume_dist_pct
FROM rooms
ORDER BY price;

-- ### Bài 116 — Chuỗi ngày liên tiếp có khách nhận phòng (gaps & islands)
-- Đề: Trong năm 2025, tìm các chuỗi ngày LIÊN TIẾP mà ngày nào cũng có ít nhất 1 check-in; liệt kê ngày bắt đầu, kết thúc, độ dài, dài nhất trước.
-- Output: tu_ngay, den_ngay, so_ngay
WITH d AS (
    SELECT DISTINCT date_start::date AS ngay FROM bookings
    WHERE date_start >= '2025-01-01' AND date_start < '2026-01-01'
), g AS (
    SELECT ngay, ngay - (ROW_NUMBER() OVER (ORDER BY ngay))::int AS grp FROM d
)
SELECT MIN(ngay) AS tu_ngay, MAX(ngay) AS den_ngay, COUNT(*) AS so_ngay
FROM g
GROUP BY grp
ORDER BY so_ngay DESC, tu_ngay;

-- ### Bài 117 — Nhân viên xuất sắc mỗi tháng
-- Đề: Mỗi tháng đặt phòng, nhân viên tạo nhiều booking nhất (đồng hạng thì lấy hết).
-- Output: thang, employee_id, fullname, so_booking
SELECT thang, employee_id, fullname, so_booking
FROM (SELECT to_char(b.date_booking, 'YYYY-MM') AS thang, b.employee_id, e.fullname,
             COUNT(*) AS so_booking,
             RANK() OVER (PARTITION BY to_char(b.date_booking, 'YYYY-MM') ORDER BY COUNT(*) DESC) AS rk
      FROM bookings b JOIN employees e ON e.id = b.employee_id
      GROUP BY 1, 2, 3) t
WHERE rk = 1
ORDER BY thang, employee_id;

-- ### Bài 118 — So với mức chi thường ngày của khách
-- Đề: Mỗi booking: tiền phòng, tiền phòng trung bình của chính khách đó, và chênh lệch (booking nào chi đột biến).
-- Output: customer_id, booking_id, total_payment, tb_cua_khach, chenh_lech
SELECT b.customer_id, b.id AS booking_id, h.total_payment,
       ROUND(AVG(h.total_payment) OVER (PARTITION BY b.customer_id)) AS tb_cua_khach,
       ROUND(h.total_payment - AVG(h.total_payment) OVER (PARTITION BY b.customer_id)) AS chenh_lech
FROM bookings b JOIN booking_histories h ON h.booking_id = b.id
ORDER BY b.customer_id, b.date_start;

-- ### Bài 119 — Khách mới hay khách cũ
-- Đề: Gắn nhãn từng booking: lần lưu trú đầu tiên của khách là 'Khách mới', các lần sau 'Khách quay lại'; kèm lần thứ mấy. Đếm số khách mới / quay lại theo tháng.
-- Output: thang, khach_moi, khach_quay_lai
WITH t AS (
    SELECT id, date_start,
           ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY date_start) AS lan_thu
    FROM bookings
)
SELECT to_char(date_start, 'YYYY-MM') AS thang,
       COUNT(*) FILTER (WHERE lan_thu = 1) AS khach_moi,
       COUNT(*) FILTER (WHERE lan_thu > 1) AS khach_quay_lai
FROM t
GROUP BY 1
ORDER BY 1;

-- ### Bài 120 — Tổng cọc 3 booking gần nhất (frame ROWS)
-- Đề: Với mỗi nhân viên, tại từng booking tính tổng tiền cọc của 3 booking gần nhất (gồm booking hiện tại) để theo dõi chất lượng thu cọc.
-- Output: employee_id, booking_id, date_booking, deposits, coc_3_gan_nhat
SELECT employee_id, id AS booking_id, date_booking, deposits,
       SUM(deposits) OVER (PARTITION BY employee_id ORDER BY date_booking
                           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS coc_3_gan_nhat
FROM bookings
ORDER BY employee_id, date_booking;

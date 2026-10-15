# Hotel Management — 120 bài luyện SQL (PostgreSQL)

Mốc "hôm nay" dùng trong đề: **2026-06-30**. Đáp án: `solutions.sql` (mỗi bài đánh số giống file này).

Ghi chú dữ liệu:

- `room_types.details` dạng `'Deluxe Double #5'` → hạng phòng = từ đầu tiên
- `customer_types.details` dạng `'Khách VIP - hạng 3'`; `payments.payment_details` dạng `'Tiền mặt - GD000001'`
- Doanh thu phòng = `booking_histories.total_payment`; doanh thu dịch vụ = `invoice_details.quantity × service_details.price`
- Dữ liệu cố ý có lỗi để luyện đối soát: overbooking, voucher áp sai hạn, tài khoản lệch trạng thái, xuất kho không có nhập…


## Module 1 — SELECT, WHERE, ORDER BY, LIMIT, DISTINCT

**Bài 1 — Bảng giá phòng**  
Lễ tân cần bảng giá để báo khách qua điện thoại. Liệt kê tên phòng và giá, phòng đắt nhất lên đầu.  
*Output:* `room_name, price`

**Bài 2 — Phòng cho khách công tác**  
Một công ty hỏi phòng có giá từ 2.000.000 đến 3.000.000/đêm. Lọc các phòng phù hợp, giá tăng dần.  
*Output:* `id, room_name, price`

**Bài 3 — Nhân viên đã nghỉ**  
Phòng nhân sự cần danh sách nhân viên đã ngừng hoạt động để thu hồi thẻ ra vào.  
*Output:* `id, fullname, phone, created_date`

**Bài 4 — Tri ân khách lớn tuổi**  
Marketing muốn gửi quà cho 10 khách hàng lớn tuổi nhất.  
*Output:* `fullname, dob, phone`

**Bài 5 — Đơn vị tính trong kho**  
Kế toán kho muốn biết hệ thống đang dùng những đơn vị tính nào (không trùng).  
*Output:* `unit`

**Bài 6 — Khách họ Nguyễn / Trần**  
Chương trình "Dòng họ Việt" ưu đãi cho khách họ Nguyễn hoặc Trần. Lấy danh sách khách đủ điều kiện.  
*Output:* `id, fullname, email`

**Bài 7 — Voucher còn hiệu lực**  
Khách đến check-in ngày 2026-01-15 hỏi có voucher nào áp dụng được. Liệt kê voucher còn hiệu lực ngày đó.  
*Output:* `voucher_code, voucher_percent, date_start, date_end`

**Bài 8 — Voucher giảm sâu**  
Liệt kê voucher giảm từ 25% trở lên; ưu tiên % giảm cao, cùng % thì voucher hết hạn sớm hơn lên trước.  
*Output:* `voucher_code, voucher_percent, date_end`

**Bài 9 — Hàng cần đặt thêm**  
Mặt hàng nào tồn kho dưới 50 cần lên đơn đặt hàng? Sắp theo tồn kho tăng dần.  
*Output:* `service_code, name_service, remaining_inventory, unit`

**Bài 10 — Đồ thất lạc khu thể thao**  
Quản lý khu tiện ích cần danh sách đồ thất lạc còn đang giữ, tìm thấy ở Hồ bơi hoặc Gym.  
*Output:* `id, item_name, location_found, date_found`

**Bài 11 — Booking chưa cọc**  
Kế toán cần nhắc khách đóng cọc. Lấy các booking có tiền cọc bằng 0.  
*Output:* `id, customer_id, date_booking, date_start`

**Bài 12 — Phân trang danh sách khách**  
Màn hình CRM hiển thị 10 khách/trang theo id. Viết truy vấn lấy trang 3.  
*Output:* `id, fullname, phone`


## Module 2 — Hàm chuỗi, ngày, số và xử lý NULL

**Bài 13 — Chuẩn hóa thông tin nhân viên**  
Xuất danh sách in thẻ nhân viên: họ tên viết HOA, email viết thường, và độ dài họ tên.  
*Output:* `id, ten_in_the, email, do_dai_ten`

**Bài 14 — Tên gọi trên thiệp**  
Thiệp chúc mừng chỉ ghi tên (từ cuối cùng của họ tên). Tách tên của từng khách.  
*Output:* `fullname, ten`

**Bài 15 — Che CCCD**  
Báo cáo gửi đối tác không được lộ CCCD đầy đủ. Hiển thị CCCD dạng '********1234' (chỉ giữ 4 số cuối).  
*Output:* `fullname, cccd_an`

**Bài 16 — Tuổi khách hàng**  
Tính tuổi hiện tại (số năm tròn) của từng khách hàng tính đến 2026-06-30.  
*Output:* `fullname, dob, tuoi`

**Bài 17 — Số đêm lưu trú**  
Tính số đêm của từng booking (ngày trả phòng - ngày nhận phòng).  
*Output:* `id, date_start, date_end, so_dem`

**Bài 18 — Thứ nhận phòng**  
Bộ phận buồng phòng muốn biết khách nhận phòng vào thứ mấy để xếp ca. Hiển thị thứ (1=Thứ 2 ... 7=Chủ nhật) và tên thứ.  
*Output:* `id, date_start, thu_so, thu_ten`

**Bài 19 — Giải mã voucher**  
Mã voucher có dạng VC + YYMM + số thứ tự. Tách ra tháng phát hành dạng 'YYYY-MM' và tính số ngày hiệu lực.  
*Output:* `voucher_code, thang_phat_hanh, so_ngay_hieu_luc`

**Bài 20 — Booking không dùng voucher**  
Trong danh sách booking, cột voucher hiển thị 'Không dùng' nếu khách không áp voucher.  
*Output:* `id, customer_id, voucher`

**Bài 21 — Yêu cầu đặc biệt**  
Phiếu bàn giao buồng phòng: nếu không có yêu cầu đặc biệt thì ghi 'Không có yêu cầu'.  
*Output:* `booking_id, yeu_cau`

**Bài 22 — Giá sau VAT**  
Niêm yết giá đã gồm VAT 8%, làm tròn đến hàng nghìn, kèm giá quy ra triệu đồng (2 chữ số thập phân).  
*Output:* `room_name, price, gia_vat, gia_trieu`

**Bài 23 — Tách hạng phòng và kiểu giường**  
Từ mô tả loại phòng (vd 'Deluxe Double #5') tách ra hạng phòng và kiểu giường, liệt kê các tổ hợp không trùng.  
*Output:* `hang_phong, kieu_giuong`

**Bài 24 — SĐT quốc tế**  
Hệ thống gửi SMS quốc tế yêu cầu số dạng +84xxxxxxxxx. Chuyển đổi SĐT khách hàng.  
*Output:* `fullname, phone, phone_intl`


## Module 3 — CASE WHEN

**Bài 25 — Phân khúc phòng**  
Gắn nhãn phân khúc: giá < 1,5tr 'Bình dân'; < 3tr 'Trung cấp'; còn lại 'Cao cấp'.  
*Output:* `room_name, price, phan_khuc`

**Bài 26 — Nhóm tuổi khách**  
Phân nhóm tuổi (tính đến 2026-06-30): < 30 'Trẻ'; 30–45 'Trung niên trẻ'; 46–60 'Trung niên'; > 60 'Cao tuổi'.  
*Output:* `fullname, tuoi, nhom_tuoi`

**Bài 27 — Trạng thái voucher**  
Tại ngày 2026-06-30, mỗi voucher ở trạng thái 'Chưa hiệu lực', 'Đang hiệu lực' hay 'Hết hạn'?  
*Output:* `voucher_code, date_start, date_end, trang_thai`

**Bài 28 — Cảnh báo tồn kho**  
Gắn mức cảnh báo: 0 'Hết hàng'; < 50 'Sắp hết'; < 200 'Ổn định'; còn lại 'Tồn nhiều'.  
*Output:* `name_service, remaining_inventory, canh_bao`

**Bài 29 — Loại hình lưu trú**  
Theo số đêm: 1 đêm 'Qua đêm'; 2–3 đêm 'Ngắn ngày'; từ 4 đêm 'Dài ngày'.  
*Output:* `id, so_dem, loai_luu_tru`

**Bài 30 — Cuối tuần hay ngày thường**  
Revenue manager muốn biết booking nhận phòng cuối tuần (Thứ 7, CN) hay ngày thường.  
*Output:* `id, date_start, loai_ngay`

**Bài 31 — Lead time đặt phòng**  
Lead time = số ngày từ lúc đặt đến ngày nhận phòng. Phân loại: 0 'Đặt ngay'; 1–7 'Sát ngày'; 8–21 'Bình thường'; > 21 'Đặt sớm'.  
*Output:* `id, lead_time, nhom_lead_time`

**Bài 32 — Mức đặt cọc**  
Phân loại tiền cọc: 0 'Chưa cọc'; ≤ 500k 'Cọc giữ chỗ'; ≤ 1tr 'Cọc tiêu chuẩn'; > 1tr 'Cọc cao'.  
*Output:* `id, deposits, muc_coc`

**Bài 33 — Danh xưng trong thư**  
Thư mời tiệc cuối năm cần danh xưng: nam 'Anh', nữ 'Chị', ghép với tên (từ cuối).  
*Output:* `fullname, loi_chao  (vd 'Kính gửi Anh Hùng')`

**Bài 34 — Ưu tiên xử lý đồ thất lạc**  
Sắp danh sách đồ thất lạc: 'Đang giữ' lên đầu, rồi 'Đã trả khách', cuối cùng 'Đã thanh lý'; trong mỗi nhóm mới nhất trước.  
*Output:* `id, item_name, status, date_found`

**Bài 35 — Ca làm khi nhặt đồ**  
Xác định ca làm việc lúc tìm thấy đồ: 06h–<14h 'Ca sáng'; 14h–<22h 'Ca chiều'; còn lại 'Ca đêm'.  
*Output:* `id, date_found, ca`

**Bài 36 — Nhãn khuyến mãi**  
Gắn nhãn hiển thị trên app: ≥ 50% 'Siêu sale'; ≥ 20% 'Sale lớn'; còn lại 'Ưu đãi'.  
*Output:* `voucher_code, voucher_percent, nhan`


## Module 4 — Aggregate, GROUP BY, HAVING

**Bài 37 — Tổng quan giá phòng**  
Giám đốc hỏi: có bao nhiêu phòng, giá thấp nhất, cao nhất, trung bình (làm tròn) là bao nhiêu?  
*Output:* `so_phong, gia_min, gia_max, gia_tb`

**Bài 38 — Cơ cấu nhân sự**  
Đếm số nhân viên theo giới tính và trạng thái làm việc.  
*Output:* `gender, is_active, so_nv`

**Bài 39 — Khách theo thế hệ**  
Đếm số khách theo thập niên sinh (1960, 1970, ...).  
*Output:* `thap_nien, so_khach`

**Bài 40 — Booking theo tháng**  
Đếm số booking theo tháng nhận phòng trong năm 2025.  
*Output:* `thang, so_booking`

**Bài 41 — Tháng thu cọc lớn**  
Tổng tiền cọc theo tháng đặt phòng, chỉ giữ các tháng thu cọc trên 3 triệu.  
*Output:* `thang_dat, tong_coc`

**Bài 42 — Giá trị nhập kho**  
Top 10 mặt hàng có tổng giá trị nhập kho (số lượng × đơn giá nhập) cao nhất.  
*Output:* `servicedetails_id, tong_sl_nhap, tong_gia_tri`

**Bài 43 — Nhập kho nhiều lần**  
Những mặt hàng nào được nhập kho từ 2 lần trở lên?  
*Output:* `servicedetails_id, so_lan_nhap`

**Bài 44 — Thống kê đồ thất lạc**  
Đếm đồ thất lạc theo vị trí và trạng thái.  
*Output:* `location_found, status, so_mon`

**Bài 45 — Khách quay lại**  
Những khách có từ 2 booking trở lên (khách quay lại)?  
*Output:* `customer_id, so_booking`

**Bài 46 — Phòng được đặt nhiều**  
Top 5 phòng được đặt nhiều lần nhất.  
*Output:* `room_id, so_lan_dat`

**Bài 47 — Tỉ lệ dùng voucher**  
Mỗi tháng nhận phòng: tổng booking, số booking có voucher, không voucher và % có voucher.  
*Output:* `thang, tong, co_voucher, khong_voucher, pct_voucher`

**Bài 48 — Số đêm trung bình theo thứ**  
Khách nhận phòng thứ nào thường ở lâu nhất? Tính số đêm trung bình theo thứ nhận phòng.  
*Output:* `thu, so_booking, dem_tb`

**Bài 49 — Thành viên đoàn**  
Mỗi đoàn khách: số thành viên và danh sách thành viên kèm quan hệ trên một dòng (vd 'Lê Văn An (Con), ...').  
*Output:* `group_id, so_tv, danh_sach`

**Bài 50 — Cơ cấu voucher**  
Thống kê voucher theo mức % giảm: số voucher và số ngày hiệu lực trung bình.  
*Output:* `voucher_percent, so_voucher, ngay_hieu_luc_tb`


## Module 5 — JOIN (INNER, LEFT, FULL, SELF, CROSS, anti-join)

**Bài 51 — Nhân viên và chức vụ**  
Danh sách nhân viên kèm tên chức vụ.  
*Output:* `id, fullname, role_name`

**Bài 52 — Chi tiết booking**  
Bảng điều phối lễ tân: mỗi booking hiển thị tên khách, tên phòng, nhân viên tạo booking, ngày nhận/trả phòng.  
*Output:* `booking_id, khach, phong, nhan_vien, date_start, date_end`

**Bài 53 — Sơ đồ phòng**  
Mỗi phòng kèm hạng phòng (từ room_types) và trạng thái hiện tại (từ room_status).  
*Output:* `room_name, hang_phong, loai_phong, trang_thai`

**Bài 54 — Khách VIP**  
Danh sách khách thuộc loại 'Khách VIP' để chăm sóc đặc biệt.  
*Output:* `id, fullname, phone, loai_khach`

**Bài 55 — Số booking của mọi khách**  
Liệt kê TẤT CẢ khách hàng và số booking của họ (khách chưa đặt lần nào hiển thị 0).  
*Output:* `id, fullname, so_booking`

**Bài 56 — Khách chưa từng đặt phòng**  
Marketing muốn gửi ưu đãi lần đầu cho khách có hồ sơ nhưng chưa từng booking.  
*Output:* `id, fullname, email`

**Bài 57 — Phòng chưa từng có khách**  
Phòng nào chưa từng được đặt? (cần kiểm tra vị trí / giá)  
*Output:* `id, room_name, price`

**Bài 58 — Lệch trạng thái tài khoản**  
Audit IT: nhân viên đang làm việc (is_active = true) nhưng tài khoản hệ thống bị khóa, và ngược lại nhân viên đã nghỉ mà tài khoản vẫn mở.  
*Output:* `username, fullname, nv_active, tk_active, van_de`

**Bài 59 — Ma trận phân quyền**  
Báo cáo phân quyền: username, họ tên, chức vụ, quyền được cấp.  
*Output:* `username, fullname, role_name, permission`

**Bài 60 — Mặt hàng chưa từng nhập**  
Mặt hàng có trong danh mục nhưng chưa có phiếu nhập kho nào.  
*Output:* `service_code, name_service`

**Bài 61 — Xuất kho không có nhập**  
Đối soát kho: mặt hàng đã có phiếu xuất nhưng chưa từng có phiếu nhập (nghi sai sót).  
*Output:* `service_code, name_service, tong_xuat`

**Bài 62 — Tiền dịch vụ mỗi hóa đơn**  
Tính tổng tiền dịch vụ (số lượng × giá bán) của từng hóa đơn.  
*Output:* `invoices_id, so_dong, tien_dich_vu`

**Bài 63 — Hóa đơn đầy đủ**  
In danh sách hóa đơn: mã HĐ, ngày xuất, tên khách, phòng, phương thức thanh toán, thu ngân.  
*Output:* `invoice_id, issue_date, khach, phong, phuong_thuc, thu_ngan`

**Bài 64 — Gọi trả đồ thất lạc**  
Với đồ còn 'Đang giữ': tên món, tên & SĐT khách để gọi, nhân viên đã nhặt được.  
*Output:* `item_name, khach, sdt_khach, nv_nhat`

**Bài 65 — Voucher áp sai thời hạn**  
Kiểm soát nội bộ: booking áp voucher nhưng ngày đặt nằm ngoài thời gian hiệu lực của voucher.  
*Output:* `booking_id, date_booking, voucher_code, date_start, date_end`

**Bài 66 — Phát hiện overbooking (SELF JOIN)**  
Tìm các cặp booking cùng phòng có khoảng lưu trú chồng lấn nhau.  
*Output:* `room_id, booking_1, booking_2, start_1, end_1, start_2, end_2`

**Bài 67 — Công suất phòng theo ngày (JOIN điều kiện khoảng)**  
Với mỗi ngày của tháng 08/2025, đếm số phòng có khách lưu trú qua đêm đó (ngày nào không có khách vẫn hiển thị 0).  
*Output:* `ngay, so_phong_co_khach`

**Bài 68 — Đối soát nhập–xuất (FULL OUTER JOIN)**  
Theo từng mặt hàng: tổng nhập, tổng xuất, chênh lệch. Phải hiện cả mặt hàng chỉ có nhập hoặc chỉ có xuất.  
*Output:* `servicedetails_id, tong_nhap, tong_xuat, chenh_lech`

**Bài 69 — Hóa đơn chỉ có tiền phòng**  
Hóa đơn nào không phát sinh dòng dịch vụ nào?  
*Output:* `invoice_id, booking_id, issue_date`

**Bài 70 — Tiền dịch vụ sau giảm giá**  
Mỗi dòng dịch vụ: thành tiền gốc, % giảm (0 nếu không voucher) và thành tiền sau giảm.  
*Output:* `invoices_id, name_service, quantity, thanh_tien, pct_giam, sau_giam`


## Module 6 — Subquery, IN, EXISTS, ANY/ALL

**Bài 71 — Phòng trên giá trung bình**  
Các phòng có giá cao hơn giá trung bình toàn khách sạn.  
*Output:* `room_name, price`

**Bài 72 — Khách chi tiêu trên trung bình**  
Khách có tổng tiền phòng (booking_histories.total_payment) cao hơn mức chi tiêu trung bình của một khách.  
*Output:* `customer_id, tong_chi`

**Bài 73 — Nhân viên đã thu ngân**  
Những nhân viên đã từng xuất ít nhất một hóa đơn (dùng EXISTS).  
*Output:* `id, fullname`

**Bài 74 — Nhân viên chưa bán được phòng**  
Nhân viên đang làm việc nhưng chưa tạo booking nào (dùng NOT EXISTS).  
*Output:* `id, fullname, role_id`

**Bài 75 — Dịch vụ bán trong tháng 12/2025**  
Mặt hàng nào đã được bán (có trong invoice_details) trong tháng 12/2025? Dùng IN.  
*Output:* `service_code, name_service`

**Bài 76 — Booking gần nhất của mỗi khách (subquery tương quan)**  
Với mỗi khách, lấy booking có ngày đặt gần nhất.  
*Output:* `customer_id, booking_id, date_booking`

**Bài 77 — So sánh giá từng phòng (scalar subquery)**  
Mỗi phòng: số lần được đặt và chênh lệch giá so với giá trung bình.  
*Output:* `room_name, price, so_lan_dat, chenh_lech_tb`

**Bài 78 — Năng suất bán phòng trung bình**  
Trung bình mỗi nhân viên (có tạo booking) tạo bao nhiêu booking? Max là bao nhiêu? (dùng bảng dẫn xuất)  
*Output:* `so_nv, booking_tb, booking_max`

**Bài 79 — Gợi ý upsell (ALL)**  
Superior là hạng bán chạy. Để upsell, tìm các phòng có giá cao hơn TẤT CẢ phòng hạng Superior.  
*Output:* `room_name, price`

**Bài 80 — Khách quen chưa từng mất đồ**  
Khách có từ 2 booking trở lên và chưa từng có món đồ thất lạc nào.  
*Output:* `customer_id, so_booking`


## Module 7 — CTE (WITH), Recursive CTE

**Bài 81 — Tổng doanh thu mỗi booking**  
Với mỗi booking: tiền phòng, tiền dịch vụ (0 nếu không có), tổng cộng.  
*Output:* `booking_id, tien_phong, tien_dv, tong`

**Bài 82 — Doanh thu theo tháng**  
Báo cáo tháng: doanh thu phòng (theo tháng trả phòng) và doanh thu dịch vụ (theo tháng sử dụng), ghép theo tháng.  
*Output:* `thang, dt_phong, dt_dv, dt_tong`

**Bài 83 — Top 10 khách & hạng đề xuất**  
Top 10 khách theo tổng chi tiêu (phòng + dịch vụ) và đề xuất hạng: ≥ 20tr 'Kim cương', ≥ 10tr 'Vàng', còn lại 'Bạc'.  
*Output:* `customer_id, fullname, tong_chi, hang_de_xuat`

**Bài 84 — Tỉ lệ lấp đầy theo tháng**  
Occupancy tháng = số đêm phòng đã bán / (tổng số phòng × số ngày trong tháng). Tính cho năm 2025 (gán số đêm vào tháng nhận phòng).  
*Output:* `thang, dem_ban, dem_kha_dung, occupancy_pct`

**Bài 85 — Lịch check-in (Recursive CTE)**  
Dùng recursive CTE sinh các ngày tháng 08/2025, đếm số lượt check-in mỗi ngày (ngày không có vẫn hiện 0).  
*Output:* `ngay, so_checkin`

**Bài 86 — KPI nhân viên**  
Mỗi nhân viên: số booking đã tạo, số hóa đơn đã xuất, số đồ thất lạc đã nhặt (0 nếu không có).  
*Output:* `id, fullname, so_booking, so_hoa_don, so_do_nhat`

**Bài 87 — Khách "ngủ đông"**  
Khách có lần nhận phòng gần nhất cách mốc 2026-06-30 hơn 180 ngày → cần chiến dịch kéo lại.  
*Output:* `customer_id, fullname, lan_cuoi, so_ngay_vang`

**Bài 88 — Biên lợi nhuận mặt hàng**  
Giá vốn = giá nhập bình quân gia quyền. So với giá bán hiện tại, tính lãi gộp/đơn vị và % biên lợi nhuận; mặt hàng bán lỗ đưa lên đầu.  
*Output:* `name_service, gia_von, gia_ban, lai_gop, bien_pct`


## Module 8 — UNION, INTERSECT, EXCEPT

**Bài 89 — Danh bạ chung**  
Tổng đài cần một danh bạ gồm cả nhân viên và khách hàng: họ tên, SĐT, email, loại liên hệ.  
*Output:* `fullname, phone, email, loai`

**Bài 90 — Thẻ kho**  
Lập thẻ kho: gộp phiếu nhập (số dương) và phiếu xuất (số âm) thành một nhật ký, sắp theo mặt hàng và thời gian.  
*Output:* `servicedetails_id, thoi_gian, loai, so_luong`

**Bài 91 — Khách vừa ở vừa mất đồ (INTERSECT)**  
Những customer_id vừa có booking vừa có đồ thất lạc.  
*Output:* `customer_id`

**Bài 92 — Hàng nhập về nhưng chưa bán (EXCEPT)**  
Mặt hàng đã nhập kho nhưng chưa bán được lần nào.  
*Output:* `servicedetails_id`

**Bài 93 — Doanh thu dịch vụ theo phương thức + dòng tổng**  
Doanh thu dịch vụ theo phương thức thanh toán, cuối bảng có dòng 'TỔNG CỘNG' (dùng UNION ALL).  
*Output:* `phuong_thuc, doanh_thu`


## Module 9 — Báo cáo tổng hợp, pivot bằng CASE, ROLLUP

**Bài 94 — Pivot booking theo quý**  
Số booking năm 2025 theo phân khúc giá phòng (Bình dân < 1,5tr / Trung cấp < 3tr / Cao cấp), mỗi quý là một cột.  
*Output:* `phan_khuc, q1, q2, q3, q4, ca_nam`

**Bài 95 — Doanh thu dịch vụ có subtotal (ROLLUP)**  
Doanh thu dịch vụ theo đơn vị tính → mặt hàng, có dòng tổng phụ mỗi đơn vị và dòng tổng toàn bộ.  
*Output:* `unit, name_service, doanh_thu`

**Bài 96 — Báo cáo thu ngân**  
Mỗi thu ngân: số hóa đơn thu tiền mặt, số hóa đơn không dùng tiền mặt, % không tiền mặt.  
*Output:* `thu_ngan, hd_tien_mat, hd_khong_tien_mat, pct_khong_tien_mat`

**Bài 97 — Hiệu quả voucher**  
Mỗi voucher đã được dùng: số lần áp vào booking, số dòng dịch vụ áp dụng, tổng tiền dịch vụ được giảm.  
*Output:* `voucher_code, voucher_percent, lan_dung_booking, lan_dung_dv, tien_giam_dv`

**Bài 98 — Phân tích phản hồi**  
Phân loại feedback: chứa 'yếu' → 'Tiêu cực', còn lại 'Tích cực'; đếm theo loại và nội dung.  
*Output:* `cam_xuc, feedback, so_luot`

**Bài 99 — Dashboard KPI**  
Một dòng KPI tổng: số khách đã lưu trú, số booking, tổng đêm bán, ADR (doanh thu phòng/đêm), ALOS (số đêm TB/booking), doanh thu phòng.  
*Output:* `so_khach, so_booking, tong_dem, adr, alos, dt_phong`

**Bài 100 — Pivot khách theo loại × nhóm tuổi**  
Số khách theo loại khách (hàng) và nhóm tuổi (cột: duoi_30, tu_30_45, tu_46_60, tren_60), tuổi tính đến 2026-06-30.  
*Output:* `loai_khach, duoi_30, tu_30_45, tu_46_60, tren_60`


## Module 10 — Window Function (20 bài)

**Bài 101 — Xếp hạng giá trong hạng phòng (RANK)**  
Xếp hạng giá phòng trong từng hạng phòng (Standard, Deluxe, ...), đắt nhất hạng 1.  
*Output:* `hang_phong, room_name, price, hang_gia`

**Bài 102 — Booking gần nhất mỗi khách (ROW_NUMBER)**  
Làm lại bài 76 bằng ROW_NUMBER: mỗi khách chỉ lấy 1 booking có ngày đặt gần nhất.  
*Output:* `customer_id, booking_id, date_booking`

**Bài 103 — Top 3 dịch vụ mỗi tháng (DENSE_RANK)**  
Mỗi tháng, top 3 mặt hàng có doanh thu dịch vụ cao nhất (đồng hạng thì lấy cả).  
*Output:* `thang, name_service, doanh_thu, xep_hang`

**Bài 104 — Doanh thu lũy kế (running total)**  
Doanh thu phòng theo ngày trả phòng năm 2025 và doanh thu lũy kế từ đầu năm.  
*Output:* `ngay, dt_ngay, dt_luy_ke`

**Bài 105 — Tăng trưởng MoM (LAG)**  
Doanh thu phòng theo tháng, doanh thu tháng trước, % tăng trưởng so với tháng trước.  
*Output:* `thang, dt, dt_thang_truoc, tang_truong_pct`

**Bài 106 — Khoảng cách giữa hai lần lưu trú (LAG)**  
Với khách có nhiều booking: số ngày từ lần nhận phòng trước đến lần này; gắn nhãn 'Quay lại nhanh' nếu ≤ 90 ngày.  
*Output:* `customer_id, booking_id, date_start, lan_truoc, so_ngay_cach, nhan`

**Bài 107 — Thời gian phòng trống giữa hai lượt (LEAD)**  
Với mỗi booking, tìm ngày nhận phòng của lượt khách kế tiếp ở CÙNG phòng và số ngày phòng bỏ trống ở giữa.  
*Output:* `room_id, booking_id, date_end, luot_ke_tiep, so_ngay_trong`

**Bài 108 — Trung bình trượt 7 ngày**  
Số check-in mỗi ngày trong Q3/2025 (kể cả ngày 0) và trung bình trượt 7 ngày gần nhất.  
*Output:* `ngay, so_checkin, ma7`

**Bài 109 — Chia hạng khách theo chi tiêu (NTILE)**  
Chia khách đã lưu trú thành 4 nhóm đều nhau theo tổng tiền phòng: nhóm 1 'Kim cương', 2 'Vàng', 3 'Bạc', 4 'Đồng'.  
*Output:* `customer_id, tong_chi, nhom, hang`

**Bài 110 — Tỉ trọng doanh thu (SUM OVER ())**  
Doanh thu từng mặt hàng và % đóng góp vào tổng doanh thu dịch vụ.  
*Output:* `name_service, doanh_thu, ti_trong_pct`

**Bài 111 — Tỉ trọng trong nhóm đơn vị**  
Như bài 110 nhưng % tính trong từng đơn vị tính (unit), kèm tổng doanh thu của unit đó.  
*Output:* `unit, name_service, doanh_thu, dt_unit, pct_trong_unit`

**Bài 112 — Lần lưu trú đầu tiên (FIRST_VALUE)**  
Mỗi booking hiển thị kèm phòng mà khách đó đã ở trong lần đầu tiên và ngày nhận phòng lần đầu.  
*Output:* `customer_id, booking_id, room_id, phong_lan_dau, ngay_lan_dau`

**Bài 113 — Người bán gần nhất của phòng (LAST_VALUE + frame)**  
Với mỗi booking, cho biết nhân viên đã tạo booking MỚI NHẤT của phòng đó (chú ý frame mặc định của LAST_VALUE).  
*Output:* `room_id, booking_id, date_booking, nv_moi_nhat`

**Bài 114 — Tồn kho lũy kế theo thời gian**  
Từ thẻ kho (nhập +, xuất −) tính số tồn lũy kế sau mỗi giao dịch của từng mặt hàng; đánh dấu thời điểm tồn âm.  
*Output:* `servicedetails_id, thoi_gian, loai, so_luong, ton_luy_ke, canh_bao`

**Bài 115 — Vị trí giá phòng (PERCENT_RANK, CUME_DIST)**  
Mỗi phòng nằm ở phân vị giá nào? Tính PERCENT_RANK và CUME_DIST theo giá, hiển thị dạng %.  
*Output:* `room_name, price, percent_rank_pct, cume_dist_pct`

**Bài 116 — Chuỗi ngày liên tiếp có khách nhận phòng (gaps & islands)**  
Trong năm 2025, tìm các chuỗi ngày LIÊN TIẾP mà ngày nào cũng có ít nhất 1 check-in; liệt kê ngày bắt đầu, kết thúc, độ dài, dài nhất trước.  
*Output:* `tu_ngay, den_ngay, so_ngay`

**Bài 117 — Nhân viên xuất sắc mỗi tháng**  
Mỗi tháng đặt phòng, nhân viên tạo nhiều booking nhất (đồng hạng thì lấy hết).  
*Output:* `thang, employee_id, fullname, so_booking`

**Bài 118 — So với mức chi thường ngày của khách**  
Mỗi booking: tiền phòng, tiền phòng trung bình của chính khách đó, và chênh lệch (booking nào chi đột biến).  
*Output:* `customer_id, booking_id, total_payment, tb_cua_khach, chenh_lech`

**Bài 119 — Khách mới hay khách cũ**  
Gắn nhãn từng booking: lần lưu trú đầu tiên của khách là 'Khách mới', các lần sau 'Khách quay lại'; kèm lần thứ mấy. Đếm số khách mới / quay lại theo tháng.  
*Output:* `thang, khach_moi, khach_quay_lai`

**Bài 120 — Tổng cọc 3 booking gần nhất (frame ROWS)**  
Với mỗi nhân viên, tại từng booking tính tổng tiền cọc của 3 booking gần nhất (gồm booking hiện tại) để theo dõi chất lượng thu cọc.  
*Output:* `employee_id, booking_id, date_booking, deposits, coc_3_gan_nhat`


-- ## Module 1 — SELECT, WHERE, ORDER BY, LIMIT, DISTINCT

/* 
**Bài 3 — Nhân viên đã nghỉ**  
Phòng nhân sự cần danh sách nhân viên đã ngừng hoạt động để thu hồi thẻ ra vào.  
*Output:* `id, fullname, phone, created_date`
*/
select id, fullname, phone, created_date
from employees
where is_active = false

/* 
**Bài 4 — Tri ân khách lớn tuổi**  
Marketing muốn gửi quà cho 10 khách hàng lớn tuổi nhất.  
*Output:* `fullname, dob, phone`
*/
select fullname, dob, phone
from customers
order by dob asc
limit 10

/* 
**Bài 5 — Đơn vị tính trong kho**  
Kế toán kho muốn biết hệ thống đang dùng những đơn vị tính nào (không trùng).  
*Output:* `unit`
*/
select distinct(unit)
from service_details

/* 
**Bài 6 — Khách họ Nguyễn / Trần**  
Chương trình "Dòng họ Việt" ưu đãi cho khách họ Nguyễn hoặc Trần. Lấy danh sách khách đủ điều kiện.  
*Output:* `id, fullname, email`
*/
select id, fullname, email
from customers
where fullname like '%Nguyễn%' or fullname like '%Trần%'


/* 
**Bài 7 — Voucher còn hiệu lực**  
Khách đến check-in ngày 2026-01-15 hỏi có voucher nào áp dụng được. Liệt kê voucher còn hiệu lực ngày đó.  
*Output:* `voucher_code, voucher_percent, date_start, date_end`
*/
select voucher_code, voucher_percent, date_start, date_end
from vouchers
where date_start <= '2026-01-15' and date_end >= '2026-01-15'

/* 
**Bài 8 — Voucher giảm sâu**  
Liệt kê voucher giảm từ 25% trở lên; ưu tiên % giảm cao, cùng % thì voucher hết hạn sớm hơn lên trước.  
*Output:* `voucher_code, voucher_percent, date_end`
*/
select voucher_code, voucher_percent, date_end
from vouchers
where voucher_percent >= 25
order by voucher_percent desc, date_end asc

/* 
**Bài 9 — Hàng cần đặt thêm**  
Mặt hàng nào tồn kho dưới 50 cần lên đơn đặt hàng? Sắp theo tồn kho tăng dần.  
*Output:* `service_code, name_service, remaining_inventory, unit`
*/
select service_code, name_service, remaining_inventory, unit
from service_details
where remaining_inventory < 50
order by remaining_inventory asc

/* 
**Bài 10 — Đồ thất lạc khu thể thao**  
Quản lý khu tiện ích cần danh sách đồ thất lạc còn đang giữ, tìm thấy ở Hồ bơi hoặc Gym.  
*Output:* `**Bài 10 — Đồ thất lạc khu thể thao**  
Quản lý khu tiện ích cần danh sách đồ thất lạc còn đang giữ, tìm thấy ở Hồ bơi hoặc Gym.  
*Output:* `id, item_name, location_found, date_found``
*/
select id, item_name, location_found, date_found
from lost_items
where status = 'Đang giữ' and location_found = 'Gym' or location_found = 'Hồ bơi'

/* 
**Bài 11 — Booking chưa cọc**  
Kế toán cần nhắc khách đóng cọc. Lấy các booking có tiền cọc bằng 0.  
*Output:* `id, customer_id, date_booking, date_start`
*/
select id, customer_id, date_booking, date_start
from bookings
where deposits = 0

/* 
**Bài 12 — Phân trang danh sách khách**  
Màn hình CRM hiển thị 10 khách/trang theo id. Viết truy vấn lấy trang 3.  
*Output:* `id, fullname, phone`
*/
select id, fullname, phone
from customers
limit 10 offset 20

--##Module 2 — Hàm chuỗi, ngày, số và xử lý NULL

/* 
**Bài 13 — Chuẩn hóa thông tin nhân viên**  
Xuất danh sách in thẻ nhân viên: họ tên viết HOA, email viết thường, và độ dài họ tên.  
*Output:* `id, ten_in_the, email, do_dai_ten`
*/
select id, upper(fullname) as ten_in_the, lower(email) as email, length(fullname) as do_dai_ten
from customers

/* 
**Bài 14 — Tên gọi trên thiệp**  
Thiệp chúc mừng chỉ ghi tên (từ cuối cùng của họ tên). Tách tên của từng khách.  
*Output:* `fullname, ten`
*/
select fullname, split_part(fullname, ' ', -1) as ten
from customers

/* 
**Bài 15 — Che CCCD**  
Báo cáo gửi đối tác không được lộ CCCD đầy đủ. Hiển thị CCCD dạng '********1234' (chỉ giữ 4 số cuối).  
*Output:* `fullname, cccd_an`
*/
select fullname, 
	repeat('*',length(citizen_identity)) || right(citizen_identity, 4) as cccd_an
from customers

/* 
**Bài 16 — Tuổi khách hàng**  
Tính tuổi hiện tại (số năm tròn) của từng khách hàng tính đến 2026-06-30.  
*Output:* `fullname, dob, tuoi`
*/
select fullname, extract(year from age(DATE'2026-06-30', dob))::int as tuoi
from customers

/* 
**Bài 17 — Số đêm lưu trú**  
Tính số đêm của từng booking (ngày trả phòng - ngày nhận phòng).  
*Output:* `id, date_start, date_end, so_dem`
*/
select id, date_start, date_end, date_end::date - date_start::date as so_dem
from bookings

/* 
**Bài 18 — Thứ nhận phòng**  
Bộ phận buồng phòng muốn biết khách nhận phòng vào thứ mấy để xếp ca. Hiển thị thứ (1=Thứ 2 ... 7=Chủ nhật) và tên thứ.  
*Output:* `id, date_start, thu_so, thu_ten`
*/
select id, date_start, 
	extract(isodow from date_start)::int as thu_so,
	to_char(date_start,'Dy') as thu_ten
from bookings

/* 
**Bài 19 — Giải mã voucher**  
Mã voucher có dạng VC + YYMM + số thứ tự. Tách ra tháng phát hành dạng 'YYYY-MM' và tính số ngày hiệu lực.  
*Output:* `voucher_code, thang_phat_hanh, so_ngay_hieu_luc`
*/
select '20' || substring(voucher_code,3,2) || '-' || substring(voucher_code,5,2) as thang_phat_hanh,
	date_end - date_start as so_ngay_hieu_luc
from vouchers

/* 
**Bài 20 — Booking không dùng voucher**  
Trong danh sách booking, cột voucher hiển thị 'Không dùng' nếu khách không áp voucher.  
*Output:* `id, customer_id, voucher
*/
select id,
	   customer_id,
	   COALESCE(cast(vouchers_id as varchar), 'Không dùng') as voucher
from bookings

/* 
**Bài 21 — Yêu cầu đặc biệt**  
Phiếu bàn giao buồng phòng: nếu không có yêu cầu đặc biệt thì ghi 'Không có yêu cầu'.  
*Output:* `booking_id, yeu_cau`
*/
select booking_id,
       COALESCE(special_request, 'Không có yêu cầu') as yeu_cau
from booking_histories

/* 
**Bài 22 — Giá sau VAT**  
Niêm yết giá đã gồm VAT 8%, làm tròn đến hàng nghìn, kèm giá quy ra triệu đồng (2 chữ số thập phân).  
*Output:* `room_name, price, gia_vat, gia_trieu`
*/
select room_name,
       price,
	   round(price * 1.08, -3) as gia_vat,
	   round((price*1.08) / 1000000.0, 2) as gia_trieu
from rooms

/* 
**Bài 23 — Tách hạng phòng và kiểu giường**  
Từ mô tả loại phòng (vd 'Deluxe Double #5') tách ra hạng phòng và kiểu giường, liệt kê các tổ hợp không trùng.  
*Output:* `hang_phong, kieu_giuong`
*/
select distinct split_part(details, ' ', 1) as hang_phong,
	split_part(details, ' ', 2) as kieu_giuong
from room_types

/* 
**Bài 24 — SĐT quốc tế**  
Hệ thống gửi SMS quốc tế yêu cầu số dạng +84xxxxxxxxx. Chuyển đổi SĐT khách hàng.  
*Output:* `fullname, phone, phone_intl`
*/
select fullname,
	phone,
	'+84' || substring(phone from 2) as phone_intl
from customers

-- ## Module 3 — CASE WHEN
/* 
**Bài 25 — Phân khúc phòng**  
Gắn nhãn phân khúc: giá < 1,5tr 'Bình dân'; < 3tr 'Trung cấp'; còn lại 'Cao cấp'.  
*Output:* `room_name, price, phan_khuc`
*/
select 
	room_name,
	price,
	case
		when price < 1500000 then 'Bình dân'
		when price < 3000000 then 'Trung cấp'
		else 'Cao cấp'
	end as phan_khuc
from rooms

/* 
**Bài 26 — Nhóm tuổi khách**  
Phân nhóm tuổi (tính đến 2026-06-30): < 30 'Trẻ'; 30–45 'Trung niên trẻ'; 46–60 'Trung niên'; > 60 'Cao tuổi'.  
*Output:* `fullname, tuoi, nhom_tuoi`
*/
select 
	fullname,
	extract(year from age(DATE'2026-06-30' ,dob))::int as tuoi,
	case
		when extract(year from age(DATE'2026-06-30' ,dob))::int < 30 then 'Trẻ'
		when extract(year from age(DATE'2026-06-30' ,dob))::int between 30 and 45 then 'Trung niên trẻ'
		when extract(year from age(DATE'2026-06-30' ,dob))::int between 46 and 60 then 'Trung niên'
		else 'Cao tuổi'
	end as nhom_tuoi
from customers

/* 
**Bài 27 — Trạng thái voucher**  
Tại ngày 2026-06-30, mỗi voucher ở trạng thái 'Chưa hiệu lực', 'Đang hiệu lực' hay 'Hết hạn'?  
*Output:* `voucher_code, date_start, date_end, trang_thai`
*/
select
	voucher_code,
	date_start,
	date_end,
	case
		when date_end > date'2026-06-30' and date_start < date'2026-06-30' then 'Đang hiệu lực'
		when date_end < date'2026-06-30' then 'Hết hạn'
		when date_start > date'2026-06-30' then 'Chưa hiệu lực'
	end as trang_thai
from vouchers

/* 
**Bài 28 — Cảnh báo tồn kho**  
Gắn mức cảnh báo: 0 'Hết hàng'; < 50 'Sắp hết'; < 200 'Ổn định'; còn lại 'Tồn nhiều'.  
*Output:* `name_service, remaining_inventory, canh_bao`
*/
select 
	name_service,
	remaining_inventory,
	case
		when remaining_inventory = 0 then 'Hết hàng'
		when remaining_inventory < 50 then 'Sắp hết'
		when remaining_inventory < 200 then 'Ổn định'
		else 'Tồn nhiều'
	end as canh_bao
from service_details

/* 
**Bài 29 — Loại hình lưu trú**  
Theo số đêm: 1 đêm 'Qua đêm'; 2–3 đêm 'Ngắn ngày'; từ 4 đêm 'Dài ngày'.  
*Output:* `id, so_dem, loai_luu_tru`
*/
select 
	id,
	(date_end::date - date_start::date)::int as so_dem,
	case 
		when (date_end::date - date_start::date)::int = 1 then 'Qua đêm'
		when (date_end::date - date_start::date)::int between 2 and 3 then 'Qua đêm'
		when (date_end::date - date_start::date)::int >= 4 then 'Dài ngày'
	end as loai_luu_tru
from bookings

/* 
**Bài 30 — Cuối tuần hay ngày thường**  
Revenue manager muốn biết booking nhận phòng cuối tuần (Thứ 7, CN) hay ngày thường.  
*Output:* `id, date_start, loai_ngay`
*/
select 
	id,
	date_start,
	case 
		when extract(isodow from date_start)::int between 6 and 7 then 'cuối tuần' 
		else 'ngày thường'
	end as loai_ngay
from bookings

/* 
**Bài 31 — Lead time đặt phòng**  
Lead time = số ngày từ lúc đặt đến ngày nhận phòng. Phân loại: 0 'Đặt ngay'; 1–7 'Sát ngày'; 8–21 'Bình thường'; > 21 'Đặt sớm'.  
*Output:* `id, lead_time, nhom_lead_time`
*/
select 
	id,
	(date_start::date - date_booking::date)::int as lead_time,
	case
		when (date_start::date - date_booking::date)::int = 0 then 'Đặt ngay'
		when (date_start::date - date_booking::date)::int between 1 and 7 then 'Sát ngày'
		when (date_start::date - date_booking::date)::int between 8 and 21 then 'Bình thường'
		else 'Đặt sớm'
	end as nhom_lead_time
from bookings
		
/* 
**Bài 32 — Mức đặt cọc**  
Phân loại tiền cọc: 0 'Chưa cọc'; ≤ 500k 'Cọc giữ chỗ'; ≤ 1tr 'Cọc tiêu chuẩn'; > 1tr 'Cọc cao'.  
*Output:* `id, deposits, muc_coc`
*/
select 
	id,
	deposits,
	case
		when deposits = 0 then 'Chưa cọc'
		when deposits <= 500000 then 'Cọc giữ chỗ'
		when deposits <= 1000000 then 'Cọc tiêu chuẩn'
		else 'Cọc cao'
	end as muc_coc
from bookings

/* 
**Bài 33 — Danh xưng trong thư**  
Thư mời tiệc cuối năm cần danh xưng: nam 'Anh', nữ 'Chị', ghép với tên (từ cuối).  
*Output:* `fullname, loi_chao  (vd 'Kính gửi Anh Hùng')`
*/
select 
	fullname,
	'Kính gửi ' ||case gender when 'Nam' then 'Anh ' when 'Nữ' then 'Chị ' end || split_part(fullname, ' ', -1) as loi_chao
from employees

/* 
**Bài 34 — Ưu tiên xử lý đồ thất lạc**  
Sắp danh sách đồ thất lạc: 'Đang giữ' lên đầu, rồi 'Đã trả khách', cuối cùng 'Đã thanh lý'; trong mỗi nhóm mới nhất trước.  
*Output:* `id, item_name, status, date_found`
*/
select 
	id,
	item_name,
	status,
	date_found
from lost_items
order by
	case status
		when 'Đang giữ' then 1
		when 'Đã trả khách' then 2
		when 'Đã thanh lý' then 3
		else 4
	end asc,
	date_found desc

/* 
**Bài 35 — Ca làm khi nhặt đồ**  
Xác định ca làm việc lúc tìm thấy đồ: 06h–<14h 'Ca sáng'; 14h–<22h 'Ca chiều'; còn lại 'Ca đêm'.  
*Output:* `id, date_found, ca`
*/
select 
	id,
	date_found,
	case
		when extract(hour from date_found)::int >= 6 and extract(hour from date_found)::int < 14 then 'Ca sáng'
		when extract(hour from date_found)::int >= 14 and extract(hour from date_found)::int < 22 then 'Ca chiều'
		else 'Ca đêm'
	end as ca
from lost_items

/* 
**Bài 36 — Nhãn khuyến mãi**  
Gắn nhãn hiển thị trên app: ≥ 50% 'Siêu sale'; ≥ 20% 'Sale lớn'; còn lại 'Ưu đãi'.  
*Output:* `voucher_code, voucher_percent, nhan`
*/
select
	voucher_code,
	voucher_percent,
	case 
		when voucher_percent >= 50 then 'Siêu sale'
		when voucher_percent >= 20 then 'Sale lớn'
		else 'Ưu đãi'
	end as nhan
from vouchers

-- ## Module 4 — Aggregate, GROUP BY, HAVING
/* 
**Bài 37 — Tổng quan giá phòng**  
Giám đốc hỏi: có bao nhiêu phòng, giá thấp nhất, cao nhất, trung bình (làm tròn) là bao nhiêu?  
*Output:* `so_phong, gia_min, gia_max, gia_tb`
*/
select count(*) as so_phong, min(price) as gia_min, max(price) as gia_max, avg(price) as gia_tb
from rooms
	
/* 
**Bài 38 — Cơ cấu nhân sự**  
Đếm số nhân viên theo giới tính và trạng thái làm việc.  
*Output:* `gender, is_active, so_nv`
*/
select gender, is_active, count(id) as so_nv
from employees
group by gender, is_active

/* 
**Bài 39 — Khách theo thế hệ**  
Đếm số khách theo thập niên sinh (1960, 1970, ...).  
*Output:* `thap_nien, so_khach`
*/
select 
	(extract(year from dob)::int) / 10 as thap_nien,
	count(*) as so_khach
from customers
group by 1
order by 1 asc

/* 
**Bài 40 — Booking theo tháng**  
Đếm số booking theo tháng nhận phòng trong năm 2025.  
*Output:* `thang, so_booking`
*/
select 
	extract(month from date_start)::int,
	count(*) as so_booking
from bookings
where extract(year from date_start)::int = 2025
group by 1
order by 1 asc
	
/* 
**Bài 41 — Tháng thu cọc lớn**  
Tổng tiền cọc theo tháng đặt phòng, chỉ giữ các tháng thu cọc trên 3 triệu.  
*Output:* `thang_dat, tong_coc`
*/
SELECT to_char(date_booking, 'YYYY-MM') AS thang_dat, SUM(deposits) AS tong_coc
FROM bookings
GROUP BY 1
HAVING SUM(deposits) > 3000000
ORDER BY 1

/* 
**Bài 42 — Giá trị nhập kho**  
Top 10 mặt hàng có tổng giá trị nhập kho (số lượng × đơn giá nhập) cao nhất.  
*Output:* `servicedetails_id, tong_sl_nhap, tong_gia_tri`
*/
select servicedetails_id, sum(quantity) as tong_sl_nhap, sum(quantity * price) as tong_gia_tri
from inventory_receiving
group by servicedetails_id
order by tong_gia_tri desc
limit 10

/* 
**Bài 43 — Nhập kho nhiều lần**  
Những mặt hàng nào được nhập kho từ 2 lần trở lên?  
*Output:* `servicedetails_id, so_lan_nhap`
*/
select servicedetails_id, count(*) as so_lan_nhap
from inventory_receiving
group by servicedetails_id
having count(*) >= 2

/* 
**Bài 44 — Thống kê đồ thất lạc**  
Đếm đồ thất lạc theo vị trí và trạng thái.  
*Output:* `location_found, status, so_mon`
*/
select location_found, status, count(*) as so_mon
from lost_items
group by location_found, status

/* 
**Bài 45 — Khách quay lại**  
Những khách có từ 2 booking trở lên (khách quay lại)?  
*Output:* `customer_id, so_booking`
*/
select customer_id, count(*) as so_booking
from bookings
group by customer_id
having count(*) >= 2
order by so_booking 

/* 
**Bài 46 — Phòng được đặt nhiều**  
Top 5 phòng được đặt nhiều lần nhất.  
*Output:* `room_id, so_lan_dat`
*/
select 
	room_id,
	count(*) as so_lan_dat
from bookings
group by room_id
order by so_lan_dat desc
limit 5

/* 
**Bài 47 — Tỉ lệ dùng voucher**  
Mỗi tháng nhận phòng: tổng booking, số booking có voucher, không voucher và % có voucher.  
*Output:* `thang, tong, co_voucher, khong_voucher, pct_voucher`
*/
select
	to_char(date_start, 'YYYY-MM') as thang,
	count(*) as tong,
	count (*) filter(where vouchers_id is not null) as co_voucher,
	sum(case when vouchers_id is null then 1 else 0 end) as khong_voucher,
	round((100.0*(count (*) filter(where vouchers_id is not null)))/count(*),2) as pct_voucher
from bookings
group by to_char(date_start, 'YYYY-MM')
order by to_char(date_start, 'YYYY-MM') asc, tong desc

/* 
**Bài 48 — Số đêm trung bình theo thứ**  
Khách nhận phòng thứ nào thường ở lâu nhất? Tính số đêm trung bình theo thứ nhận phòng.  
*Output:* `thu, so_booking, dem_tb`
*/
select 
	extract(isodow from date_start) as thu,
	round(avg(date_end::date - date_start::date), 2) as dem_tb
from bookings
group by extract(isodow from date_start)
order by dem_tb desc

/* 
**Bài 49 — Thành viên đoàn**  
Mỗi đoàn khách: số thành viên và danh sách thành viên kèm quan hệ trên một dòng (vd 'Lê Văn An (Con), ...').  
*Output:* `group_id, so_tv, danh_sach`
*/
select 
	group_id, count(*) as so_tv, 
	string_agg(fullname || ' (' || relationship || ')', ', ' ORDER BY fullname) AS danh_sach
from group_members
group by group_id

/* 
**Bài 50 — Cơ cấu voucher**  
Thống kê voucher theo mức % giảm: số voucher và số ngày hiệu lực trung bình.  
*Output:* `voucher_percent, so_voucher, ngay_hieu_luc_tb`
*/
select 
	voucher_percent,
	count(*) as so_voucher,
	avg((date_end - date_start)::int)
from vouchers
group by 1
order by 1

--## Module 5 — JOIN (INNER, LEFT, FULL, SELF, CROSS, anti-join)
/* 
**Bài 51 — Nhân viên và chức vụ**  
Danh sách nhân viên kèm tên chức vụ.  
*Output:* `id, fullname, role_name`
*/
select p.id, fullname, role_name
from employees p join roles r on p.role_id = r.id

/* 
**Bài 52 — Chi tiết booking**  
Bảng điều phối lễ tân: mỗi booking hiển thị tên khách, tên phòng, nhân viên tạo booking, ngày nhận/trả phòng.  
*Output:* `booking_id, khach, phong, nhan_vien, date_start, date_end`
*/
select b.id as booking_id, c.fullname as khach, r.room_name as phong, e.fullname as nhan_vien, date_start, date_end
from bookings b join employees e on b.employee_id = e.id
				join customers c on b.customer_id = c.id
				join rooms r on r.id = b.room_id
ORDER BY b.date_start

/* 
**Bài 53 — Sơ đồ phòng**  
Mỗi phòng kèm hạng phòng (từ room_types) và trạng thái hiện tại (từ room_status).  
*Output:* `room_name, hang_phong, loai_phong, trang_thai`
*/
select room_name, rty.details as hang_phong, rst.details as trang_thai
from rooms r
join room_status rst on r.room_status = rst.id
join room_types rty on r.roomtype_id = rty.id	

/* 
**Bài 54 — Khách VIP**  
Danh sách khách thuộc loại 'Khách VIP' để chăm sóc đặc biệt.  
*Output:* `id, fullname, phone, loai_khach`
*/
select c.id, c.fullname, ct.details
from customers c
join customer_types ct on c.customer_type = ct.id
where ct.details like '%VIP%'

/* 
**Bài 55 — Số booking của mọi khách**  
Liệt kê TẤT CẢ khách hàng và số booking của họ (khách chưa đặt lần nào hiển thị 0).  
*Output:* `id, fullname, so_booking`
*/
select c.id, c.fullname, count(c.id) as so_booking
from customers c
join bookings b on b.customer_id = c.id
group by c.id
order by so_booking desc,c.id

/* 
**Bài 56 — Khách chưa từng đặt phòng**  
Marketing muốn gửi ưu đãi lần đầu cho khách có hồ sơ nhưng chưa từng booking.  
*Output:* `id, fullname, email`
*/
select c.id, c.fullname, c.email
from customers c
left join bookings b on b.customer_id = c.id
where b.id is null

/* 
**Bài 57 — Phòng chưa từng có khách**  
Phòng nào chưa từng được đặt? (cần kiểm tra vị trí / giá)  
*Output:* `id, room_name, price`
*/
select r.id,r.room_name,r.price
from bookings b
right join rooms r on b.room_id=r.id
where b.id is null
ORDER BY r.price DESC

/* 
**Bài 58 — Lệch trạng thái tài khoản**  
Audit IT: nhân viên đang làm việc (is_active = true) nhưng tài khoản hệ thống bị khóa, và ngược lại nhân viên đã nghỉ mà tài khoản vẫn mở.  
*Output:* `username, fullname, nv_active, tk_active, van_de`
*/
select a.username, e.fullname, e.is_active as nv_active, a.is_active as tk_active,
	case when e.is_active and not a.is_active then 'nhan vien dang lam nhung tai khoan bi khoa'
											  else 'nhan vien nghi lam nhung tai khoan van hoat dong'
											  end as van_de
from employees e 
join accounts a on a.employee_id = e.id
where e.is_active <> a.is_active

/* 
**Bài 59 — Ma trận phân quyền**  
Báo cáo phân quyền: username, họ tên, chức vụ, quyền được cấp.  
*Output:* `username, fullname, role_name, permission`
*/
select a.username,fullname,role_name, au.permission
from employees e
join roles r on e.role_id = r.id
join accounts a on a.employee_id = e.id
join authorities au on a.username = au.username
ORDER BY au.permission, a.username

/* 
**Bài 60 — Mặt hàng chưa từng nhập**  
Mặt hàng có trong danh mục nhưng chưa có phiếu nhập kho nào.  
*Output:* `service_code, name_service`
*/
select service_code, name_service
from service_details sd
left join inventory_receiving ir on sd.id = ir.servicedetails_id
where ir.id is null

/* 
**Bài 61 — Xuất kho không có nhập**  
Đối soát kho: mặt hàng đã có phiếu xuất nhưng chưa từng có phiếu nhập (nghi sai sót).  
*Output:* `service_code, name_service, tong_xuat`
*/
select service_code, name_service, sum(idl.quantity) as tong_xuat
from service_details sd
join inventory_delivery idl on idl.servicedetails_id = sd.id
where not exists (select 1 from inventory_receiving ir where ir.servicedetails_id = sd.id)
group by service_code, name_service

/* 
**Bài 62 — Tiền dịch vụ mỗi hóa đơn**  
Tính tổng tiền dịch vụ (số lượng × giá bán) của từng hóa đơn.  
*Output:* `invoices_id, so_dong, tien_dich_vu`
*/
select invoices_id, count(*) as so_dong, sum(ide.quantity*sd.price) as tien_dich_vu
from invoices i
join invoice_details ide on ide.invoices_id = i.id
join service_details sd on sd.id = ide.servicedetails_id
group by invoices_id
order by tien_dich_vu desc

/* 
**Bài 63 — Hóa đơn đầy đủ**  
In danh sách hóa đơn: mã HĐ, ngày xuất, tên khách, phòng, phương thức thanh toán, thu ngân.  
*Output:* `invoice_id, issue_date, khach, phong, phuong_thuc, thu_ngan`
*/
select i.id as invoice_id, i.issue_date, c.fullname as khách,r.room_name as phòng, 
	split_part(p.payment_details, '-',1) as "phương thức thanh toán", e.fullname as "thu ngân"
from invoices i
join bookings b on i.booking_id = b.id
join customers c on c.id = b.customer_id
join rooms r on b.room_id = r.id
join payments p on i.payment_id = p.id
join employees e on i.employee_id = e.id
ORDER BY i.issue_date;

/* 
**Bài 64 — Gọi trả đồ thất lạc**  
Với đồ còn 'Đang giữ': tên món, tên & SĐT khách để gọi, nhân viên đã nhặt được.  
*Output:* `item_name, khach, sdt_khach, nv_nhat`
*/
select item_name, c.fullname as khach, c.phone as sdt_khach, e.fullname as nv_nhat
from lost_items li
join customers c on li.customer_id = c.id
join employees e on li.employee_id = e.id 
where li.status = 'Đang giữ'

/* 
**Bài 65 — Voucher áp sai thời hạn**  
Kiểm soát nội bộ: booking áp voucher nhưng ngày đặt nằm ngoài thời gian hiệu lực của voucher.  
*Output:* `booking_id, date_booking, voucher_code, date_start, date_end`
*/
select b.id as booking_id, date_booking, voucher_code, v.date_start, v.date_end
from bookings b
join vouchers v on b.vouchers_id = v.id
where b.date_booking < v.date_start or b.date_booking > v.date_end

/* 
**Bài 66 — Phát hiện overbooking (SELF JOIN)**  
Tìm các cặp booking cùng phòng có khoảng lưu trú chồng lấn nhau.  
*Output:* `room_id, booking_1, booking_2, start_1, end_1, start_2, end_2`
*/
select b1.room_id, b1.id as booking_1, b2.id as booking_2, b1.date_start as start_1, b1.date_end as end_1, b2.date_start as start_2, b2.date_end as end_2
from bookings b1 
join bookings b2 on b1.room_id = b2.room_id
				and b1.id < b2.id
				and b1.date_start < b2.date_end
				and b2.date_start < b1.date_end

/* 
**Bài 67 — Công suất phòng theo ngày (JOIN điều kiện khoảng)**  
Với mỗi ngày của tháng 08/2025, đếm số phòng có khách lưu trú qua đêm đó (ngày nào không có khách vẫn hiển thị 0).  
*Output:* `ngay, so_phong_co_khach`
*/
select d::date, count (distinct(b.room_id)) as so_phong_co_khach
from generate_series(date'2025-08-01', date'2025-08-31', interval '1 day') d
left join bookings b on d::date >= b.date_start::date and d::date < b.date_end::date
GROUP BY d
ORDER BY d;

/* 
**Bài 68 — Đối soát nhập–xuất (FULL OUTER JOIN)**  
Theo từng mặt hàng: tổng nhập, tổng xuất, chênh lệch. Phải hiện cả mặt hàng chỉ có nhập hoặc chỉ có xuất.  
*Output:* `servicedetails_id, tong_nhap, tong_xuat, chenh_lech`
*/
select 
	coalesce(x.sid, n.sid) as servicedetails_id,
	coalesce(n.tong_nhap, 0) as tong_nhap,
	coalesce(x.tong_xuat, 0) as tong_xuat,
	coalesce(n.tong_nhap, 0) - coalesce(x.tong_xuat, 0) as chenh_lech
from (select servicedetails_id as sid ,sum(quantity) as tong_xuat from inventory_delivery group by 1) x
full outer join (select servicedetails_id as sid,sum(quantity) tong_nhap from inventory_receiving group by 1) n
on x.sid = n.sid
ORDER BY 1;

/* 
**Bài 69 — Hóa đơn chỉ có tiền phòng**  
Hóa đơn nào không phát sinh dòng dịch vụ nào?  
*Output:* `invoice_id, booking_id, issue_date`
*/
select i.id as invoice_id, i.booking_id, i.issue_date
from invoices i 
left join invoice_details ide
on i.id = ide.invoices_id
where ide.id is null

/* 
**Bài 70 — Tiền dịch vụ sau giảm giá**  
Mỗi dòng dịch vụ: thành tiền gốc, % giảm (0 nếu không voucher) và thành tiền sau giảm.  
*Output:* `invoices_id, name_service, quantity, thanh_tien, pct_giam, sau_giam`
*/
select  invoices_id,
				name_service,
				quantity,
				ide.quantity * sd.price as thanh_tien,
				coalesce(v.voucher_percent, 0) as pct_giam,
				round((ide.quantity * sd.price) - ((ide.quantity * sd.price)*coalesce(v.voucher_percent, 0))/100, 2) as sau_giam
				
from invoice_details ide
join service_details sd on sd.id = ide.servicedetails_id
left join vouchers v on ide.vouchers_id = v.id
ORDER BY ide.invoices_id;

-- ## Module 6 — Subquery, IN, EXISTS, ANY/ALL
/* 
**Bài 71 — Phòng trên giá trung bình**  
Các phòng có giá cao hơn giá trung bình toàn khách sạn.  
*Output:* `room_name, price`
*/
select room_name, price
from rooms
where price > (select avg(price) from rooms)

/* 
**Bài 72 — Khách chi tiêu trên trung bình**  
Khách có tổng tiền phòng (booking_histories.total_payment) cao hơn mức chi tiêu trung bình của một khách.  
*Output:* `customer_id, tong_chi`
*/
select 
	customer_id, 
	sum(bh.total_payment) as tong_chi
from bookings b
join booking_histories bh on bh.booking_id = b.id
group by customer_id
having sum(total_payment) > 
	(select avg(s)  
	 from(
	 	select sum(total_payment) as s
	 	from bookings b2
	 	join booking_histories bh2 on bh2.booking_id = b2.id
	 	group by customer_id
		)
	)
order by tong_chi desc

/* 
**Bài 73 — Nhân viên đã thu ngân**  
Những nhân viên đã từng xuất ít nhất một hóa đơn (dùng EXISTS).  
*Output:* `id, fullname`
*/
select e.id, e.fullname
from employees e
where exists (
					select 1
					from invoices i
					where i.employee_id = e.id
				)
order by e.id

/* 
**Bài 74 — Nhân viên chưa bán được phòng**  
Nhân viên đang làm việc nhưng chưa tạo booking nào (dùng NOT EXISTS).  
*Output:* `id, fullname, role_id`
*/
select e.id, e.fullname, e.role_id
from employees e
where e.is_active = true  and not exists(
								select 1
								from bookings b
								where b.employee_id = e.id
							  )

/* 
**Bài 75 — Dịch vụ bán trong tháng 12/2025**  
Mặt hàng nào đã được bán (có trong invoice_details) trong tháng 12/2025? Dùng IN.  
*Output:* `service_code, name_service`
*/
select sde.service_code, sde.name_service
from service_details sde
where sde.id in (select i.servicedetails_id
				 from invoice_details i
				 where i.use_date::date >= date'2025-12-01' and i.use_date::date <= date'2025-12-31'
				)
/* 
**Bài 76 — Booking gần nhất của mỗi khách (subquery tương quan)**  
Với mỗi khách, lấy booking có ngày đặt gần nhất.  
*Output:* `customer_id, booking_id, date_booking`
*/
select c.id, b.id as booking_id, b.date_booking
from customers c
join bookings b on c.id = b.customer_id
where b.date_booking = (select max(b2.date_booking) from bookings b2 where b2.customer_id = c.id)
ORDER BY b.customer_id;


/* 
**Bài 77 — So sánh giá từng phòng (scalar subquery)**  
Mỗi phòng: số lần được đặt và chênh lệch giá so với giá trung bình.  
*Output:* `room_name, price, so_lan_dat, chenh_lech_tb`
*/
select
	room_name,
	price,
	(select count(*) from bookings b where b.room_id = r.id) as so_lan_dat,
	(r.price - (select avg(r2.price) from rooms r2)) as chenh_lech_tb
from rooms r
ORDER BY so_lan_dat DESC, r.room_name

/* 
**Bài 78 — Năng suất bán phòng trung bình**  
Trung bình mỗi nhân viên (có tạo booking) tạo bao nhiêu booking? Max là bao nhiêu? (dùng bảng dẫn xuất)  
*Output:* `so_nv, booking_tb, booking_max`
*/
select count(bang_tam.id_nv), avg(s_bk) as booking_tb, max(s_bk) as booking_max
from (select employee_id as id_nv, count(*) as s_bk
	  from bookings 
	  group by employee_id
	) as bang_tam
/* 
**Bài 79 — Gợi ý upsell (ALL)**  
Superior là hạng bán chạy. Để upsell, tìm các phòng có giá cao hơn TẤT CẢ phòng hạng Superior.  
*Output:* `room_name, price`
*/
select r.room_name, r.price 
from rooms r
where r.price > (
	select max(r2.price)
	from rooms r2 
	join room_types rt on r2.roomtype_id = rt.id
	where rt.details like '%Superior%'
)
order by price desc

/* 
**Bài 80 — Khách quen chưa từng mất đồ**  
Khách có từ 2 booking trở lên và chưa từng có món đồ thất lạc nào.  
*Output:* `customer_id, so_booking`
*/
select customer_id, count(*) as so_booking
from bookings b 
where b.customer_id not in (
	select li.customer_id
	from lost_items li
	where customer_id is not null
)
group by customer_id
having count(*) >= 2

-- ## Module 7 — CTE (WITH), Recursive CTE
/* 
**Bài 81 — Tổng doanh thu mỗi booking**  
Với mỗi booking: tiền phòng, tiền dịch vụ (0 nếu không có), tổng cộng.  
*Output:* `booking_id, tien_phong, tien_dv, tong`
*/
with dv as(
	select i.booking_id, sum(ide.quantity*sde.price) as tien_dv
	from invoices i 
	join invoice_details ide on ide.invoices_id = i.id
	join service_details sde on sde.id = ide.servicedetails_id
	group by booking_id
) 
select bh.id, bh.total_payment as tien_phong, coalesce(tien_dv, 0) as tien_dv, (bh.total_payment + coalesce(tien_dv, 0)) as tong
from booking_histories as bh
left join dv on bh.booking_id = dv.booking_id
order by tong desc

/* 
**Bài 82 — Doanh thu theo tháng**  
Báo cáo tháng: doanh thu phòng (theo tháng trả phòng) và doanh thu dịch vụ (theo tháng sử dụng), ghép theo tháng.  
*Output:* `thang, dt_phong, dt_dv, dt_tong`
*/
with phong as(
	select date_trunc('month',bh.date_end) as thang, sum(total_payment) as dt_phong
	from booking_histories bh
	group by 1
), dich_vu as(
	select date_trunc('month', ide.use_date) as thang ,
		sum(ide.quantity*sde.price) as dt_dv
	from invoices i
	join invoice_details ide on i.id = ide.invoices_id
	join service_details sde on sde.id = ide.servicedetails_id
	group by 1
)
select 
	to_char(coalesce(p.thang, dv.thang), 'YYYY-MM') as thang,
	coalesce(p.dt_phong, 0) as dt_phong,
	coalesce(dv.dt_dv) as dt_dv,
	(coalesce(p.dt_phong, 0) + coalesce(dv.dt_dv)) as dt_tong
from phong p 
full join dich_vu dv on p.thang = dv.thang
order by 1

/* 
**Bài 83 — Top 10 khách & hạng đề xuất**  
Top 10 khách theo tổng chi tiêu (phòng + dịch vụ) và đề xuất hạng: ≥ 20tr 'Kim cương', ≥ 10tr 'Vàng', còn lại 'Bạc'.  
*Output:* `customer_id, fullname, tong_chi, hang_de_xuat`
*/
with phong as(
	select b.customer_id as customer_id, sum(total_payment)  as tong_phong
	from bookings b
	join booking_histories bh on b.id = bh.booking_id
	group by 1
),dich_vu as(
	select b.customer_id as customer_id, sum(ide.quantity*sde.price) as tong_dv
	from bookings b
	join invoices i on b.id = i.booking_id
	join invoice_details ide on ide.invoices_id = i.id
	join service_details sde on ide.servicedetails_id = sde.id
	group by 1
)
select c.id as customer_id,
		c.fullname,
		(coalesce(p.tong_phong, 0) + coalesce(dv.tong_dv, 0)) as tong_chi,
		case
			when (coalesce(p.tong_phong, 0) + coalesce(dv.tong_dv, 0)) >= 20000000 then 'Kim cương'
			when (coalesce(p.tong_phong, 0) + coalesce(dv.tong_dv, 0)) >= 10000000 then 'Vàng'
			else 'Bạc'
			end as hang_de_xuat
		
from customers c
join phong p on p.customer_id = c.id
full join dich_vu dv on dv.customer_id = p.customer_id
order by tong_chi desc
limit 10


/* 
**Bài 84 — Tỉ lệ lấp đầy theo tháng**  
Occupancy tháng = số đêm phòng đã bán / (tổng số phòng × số ngày trong tháng). Tính cho năm 2025 (gán số đêm vào tháng nhận phòng).  
*Output:* `thang, dem_ban, dem_kha_dung, occupancy_pct`
*/
with da_ban
















	
				
	


	

	



	   
















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




	

	



	   
















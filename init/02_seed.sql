-- =============================================
-- Seed ~100 dòng fake / bảng (deterministic với setseed)
-- =============================================
SELECT setseed(0.42);

-- Helper: sinh họ tên tiếng Việt ngẫu nhiên
CREATE OR REPLACE FUNCTION fake_name() RETURNS VARCHAR AS $$
SELECT (ARRAY['Nguyễn','Trần','Lê','Phạm','Hoàng','Huỳnh','Phan','Vũ','Võ','Đặng','Bùi','Đỗ','Hồ','Ngô','Dương'])[1 + floor(random()*15)::int]
    || ' ' ||
       (ARRAY['Văn','Thị','Minh','Ngọc','Thanh','Quốc','Hữu','Đức','Thu','Gia','Bảo','Khánh'])[1 + floor(random()*12)::int]
    || ' ' ||
       (ARRAY['An','Bình','Châu','Dũng','Giang','Hà','Hải','Hùng','Lan','Linh','Long','Mai','Nam','Phúc','Quân','Sơn','Tâm','Trang','Tuấn','Vy'])[1 + floor(random()*20)::int];
$$ LANGUAGE sql VOLATILE;

CREATE OR REPLACE FUNCTION rnd_int(lo INT, hi INT) RETURNS INT AS $$
SELECT lo + floor(random() * (hi - lo + 1))::int;
$$ LANGUAGE sql VOLATILE;

-- ============ DANH MỤC ============

INSERT INTO roles (role_name)
SELECT (ARRAY['Admin','Manager','Receptionist','Housekeeping','Accountant','Security','Chef','Waiter','Technician','Sales'])[1 + (i-1) % 10]
       || ' ' || lpad(i::text, 3, '0')
FROM generate_series(1,100) i;

INSERT INTO customer_types (details)
SELECT (ARRAY['Khách lẻ','Khách đoàn','Khách VIP','Khách doanh nghiệp','Khách thân thiết'])[1 + (i-1) % 5]
       || ' - hạng ' || i
FROM generate_series(1,100) i;

INSERT INTO room_types (details)
SELECT (ARRAY['Standard','Superior','Deluxe','Suite','Family','Presidential'])[1 + (i-1) % 6]
       || ' ' || (ARRAY['Single','Double','Twin','Triple'])[1 + (i-1) % 4] || ' #' || i
FROM generate_series(1,100) i;

INSERT INTO room_status (details)
SELECT (ARRAY['Trống','Đã đặt','Đang ở','Đang dọn','Bảo trì'])[1 + (i-1) % 5] || ' #' || i
FROM generate_series(1,100) i;

INSERT INTO service_types (details)
SELECT (ARRAY['Ăn uống','Giặt ủi','Spa','Minibar','Đưa đón','Tour','Gym','Karaoke'])[1 + (i-1) % 8] || ' #' || i
FROM generate_series(1,100) i;

INSERT INTO vouchers (voucher_code, voucher_percent, date_start, date_end)
SELECT 'VC' || to_char(d, 'YYMM') || lpad(i::text, 4, '0'),
       (ARRAY[5,10,15,20,25,30,50])[rnd_int(1,7)],
       d,
       d + rnd_int(7, 90)
FROM (SELECT i, DATE '2025-01-01' + rnd_int(0, 600) AS d FROM generate_series(1,100) i) s;

INSERT INTO payments (payment_details)
SELECT (ARRAY['Tiền mặt','Chuyển khoản','Thẻ Visa','Thẻ Mastercard','Ví MoMo','ZaloPay','VNPay QR'])[1 + (i-1) % 7] || ' - GD' || lpad(i::text, 6, '0')
FROM generate_series(1,100) i;

-- ============ CẤP 1 ============

INSERT INTO employees (citizen_identity, fullname, gender, dob, address, phone, email, avatar, created_date, is_active, role_id)
SELECT '0' || lpad(rnd_int(1, 99999999)::text, 11, '0'),
       fake_name(),
       (ARRAY['Nam','Nữ'])[rnd_int(1,2)],
       DATE '1970-01-01' + rnd_int(0, 12000),
       rnd_int(1, 500) || ' ' || (ARRAY['Lê Lợi','Trần Hưng Đạo','Nguyễn Huệ','Hai Bà Trưng','Kim Mã','Cầu Giấy','Láng Hạ'])[rnd_int(1,7)]
           || ', ' || (ARRAY['Hà Nội','TP.HCM','Đà Nẵng','Hải Phòng','Cần Thơ'])[rnd_int(1,5)],
       '09' || lpad(rnd_int(0, 99999999)::text, 8, '0'),
       'emp' || i || '@hotel.vn',
       'https://i.pravatar.cc/150?img=' || (1 + i % 70),
       DATE '2018-01-01' + rnd_int(0, 2800),
       random() > 0.1,
       rnd_int(1, 100)
FROM generate_series(1,100) i;

INSERT INTO customers (fullname, citizen_identity, phone, email, dob, customer_type)
SELECT fake_name(),
       '0' || lpad(rnd_int(1, 99999999)::text, 11, '0'),
       '03' || lpad(rnd_int(0, 99999999)::text, 8, '0'),
       'customer' || i || '@gmail.com',
       DATE '1960-01-01' + rnd_int(0, 16000),
       rnd_int(1, 100)
FROM generate_series(1,100) i;

INSERT INTO rooms (room_name, price, roomtype_id, room_status)
SELECT 'P' || (1 + (i-1) / 10) || lpad(((i-1) % 10 + 1)::text, 2, '0'),
       rnd_int(5, 50) * 100000,
       rnd_int(1, 100),
       rnd_int(1, 100)
FROM generate_series(1,100) i;

INSERT INTO service_details (name_service, price, service_code, remaining_inventory, unit, servicetype_id)
SELECT (ARRAY['Nước suối','Coca Cola','Bia Hà Nội','Mì ly','Snack','Giặt áo','Massage 60p','Xe đưa đón sân bay','Buffet sáng','Cà phê sữa'])[1 + (i-1) % 10]
           || ' #' || i,
       rnd_int(1, 100) * 10000,
       'SV' || lpad(i::text, 4, '0'),
       rnd_int(0, 500),
       (ARRAY['chai','lon','gói','ly','lần','suất','kg'])[rnd_int(1,7)],
       rnd_int(1, 100)
FROM generate_series(1,100) i;

-- ============ CẤP 2 ============

INSERT INTO accounts (username, pass, created_date, is_active, employee_id)
SELECT 'user' || lpad(i::text, 3, '0'),
       crypt('123456', gen_salt('bf', 6)),   -- bcrypt, mật khẩu chung: 123456
       TIMESTAMP '2020-01-01' + (rnd_int(0, 2000) || ' days')::interval,
       random() > 0.1,
       i                                       -- 1 account / 1 employee
FROM generate_series(1,100) i;

INSERT INTO lost_items (item_name, description, date_found, location_found, employee_id, customer_id, status)
SELECT (ARRAY['Điện thoại','Ví da','Chìa khóa','Kính mát','Sạc laptop','Đồng hồ','Áo khoác','Tai nghe'])[rnd_int(1,8)],
       'Đồ thất lạc #' || i,
       TIMESTAMP '2025-01-01' + (rnd_int(0, 600) || ' days')::interval + (rnd_int(0, 1439) || ' minutes')::interval,
       (ARRAY['Sảnh','Phòng','Nhà hàng','Hồ bơi','Gym','Bãi đỗ xe'])[rnd_int(1,6)],
       rnd_int(1, 100),
       rnd_int(1, 100),
       (ARRAY['Đang giữ','Đã trả khách','Đã thanh lý'])[rnd_int(1,3)]
FROM generate_series(1,100) i;

INSERT INTO customer_groups (customer_id)
SELECT rnd_int(1, 100) FROM generate_series(1,100);

INSERT INTO inventory_receiving (servicedetails_id, quantity, price, in_date)
SELECT rnd_int(1, 100), rnd_int(10, 200), rnd_int(1, 80) * 10000,
       TIMESTAMP '2025-01-01' + (rnd_int(0, 600) || ' days')::interval
FROM generate_series(1,100);

INSERT INTO inventory_delivery (servicedetails_id, quantity, out_date)
SELECT rnd_int(1, 100), rnd_int(1, 50),
       TIMESTAMP '2025-01-01' + (rnd_int(0, 600) || ' days')::interval
FROM generate_series(1,100);

-- ============ CẤP 3 ============

INSERT INTO authorities (username, permission, details)
SELECT 'user' || lpad(i::text, 3, '0'),
       p.perm,
       'Quyền ' || p.perm
FROM generate_series(1,100) i
CROSS JOIN LATERAL (
    SELECT (ARRAY['ROLE_ADMIN','ROLE_MANAGER','ROLE_RECEPTION','ROLE_STAFF','ROLE_ACCOUNTANT'])[1 + (i-1) % 5] AS perm
) p;

INSERT INTO group_members (fullname, relationship, group_id)
SELECT fake_name(),
       (ARRAY['Vợ','Chồng','Con','Bố','Mẹ','Bạn','Đồng nghiệp'])[rnd_int(1,7)],
       rnd_int(1, 100)
FROM generate_series(1,100);

INSERT INTO bookings (customer_id, room_id, date_booking, date_start, date_end, deposits, employee_id, vouchers_id)
SELECT rnd_int(1, 100),
       rnd_int(1, 100),
       b,
       b + (s || ' days')::interval + TIME '14:00',
       b + ((s + n) || ' days')::interval + TIME '12:00',
       rnd_int(0, 20) * 100000,
       rnd_int(1, 100),
       CASE WHEN random() < 0.4 THEN rnd_int(1, 100) END   -- 60% không dùng voucher
FROM (
    SELECT DATE '2025-01-01' + rnd_int(0, 600) AS b,
           rnd_int(0, 30) AS s,
           rnd_int(1, 7)  AS n
    FROM generate_series(1,100)
) x;

-- Cố ý tạo 3 ca overbooking (trùng phòng, chồng lấn ngày) để luyện phát hiện dữ liệu lỗi
UPDATE bookings b
SET room_id      = o.room_id,
    date_booking = o.date_booking,
    date_start   = o.date_start + INTERVAL '1 day',
    date_end     = o.date_end   + INTERVAL '1 day'
FROM bookings o
WHERE (b.id, o.id) IN ((10, 20), (30, 40), (50, 60));

-- ============ CẤP 4 & 5 ============

-- Lịch sử bám theo booking thật: 1 history / booking
INSERT INTO booking_histories (citizen_identity, booking_id, date_start, date_end, total_payment, special_request, feedback)
SELECT c.citizen_identity,
       b.id,
       b.date_start,
       b.date_end,
       r.price * GREATEST(1, (b.date_end::date - b.date_start::date)),
       (ARRAY[NULL,'Phòng tầng cao','Giường phụ','Check-in sớm','Không hút thuốc','View biển'])[rnd_int(1,6)],
       (ARRAY['Rất hài lòng','Phòng sạch sẽ','Nhân viên thân thiện','Wifi hơi yếu','Sẽ quay lại','Bữa sáng ngon'])[rnd_int(1,6)]
FROM bookings b
JOIN customers c ON c.id = b.customer_id
JOIN rooms r     ON r.id = b.room_id
ORDER BY b.id;

INSERT INTO invoices (booking_id, issue_date, employee_id, payment_id)
SELECT b.id, b.date_end, rnd_int(1, 100), rnd_int(1, 100)
FROM bookings b
ORDER BY b.id;

INSERT INTO invoice_details (invoices_id, servicedetails_id, quantity, use_date, vouchers_id)
SELECT inv.id,
       rnd_int(1, 100),
       rnd_int(1, 5),
       inv.issue_date - (rnd_int(1, 48) || ' hours')::interval,
       CASE WHEN random() < 0.2 THEN rnd_int(1, 100) END
FROM (SELECT rnd_int(1, 100) AS inv_id FROM generate_series(1,100)) r   -- random trước rồi mới join
JOIN invoices inv ON inv.id = r.inv_id;   -- có HĐ nhiều dòng, có HĐ không phát sinh dịch vụ

-- Dọn helper
DROP FUNCTION fake_name();
DROP FUNCTION rnd_int(INT, INT);

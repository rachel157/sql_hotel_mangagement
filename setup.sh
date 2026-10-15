#!/usr/bin/env bash
# Pull Postgres, tạo schema, seed data fake.
# Dùng: ./setup.sh          -> khởi tạo (giữ data nếu đã có)
#       ./setup.sh --reset  -> xóa volume, tạo lại từ đầu
set -euo pipefail
cd "$(dirname "$0")"

if [[ "${1:-}" == "--reset" ]]; then
  echo ">> Xóa container + volume cũ"
  docker compose down -v
fi

echo ">> Pull image"
docker compose pull

echo ">> Start Postgres"
docker compose up -d

echo ">> Đợi DB sẵn sàng + chạy init scripts..."
until [ "$(docker inspect -f '{{.State.Health.Status}}' hotel-postgres)" == "healthy" ]; do
  sleep 2
done
# init scripts chạy trước khi server nhận kết nối TCP; đợi thêm cho chắc
sleep 2

echo ">> Số dòng mỗi bảng:"
docker exec -i hotel-postgres psql -U hotel -d hotelmanagement <<'SQL'
SELECT table_name,
       (xpath('/row/c/text()', query_to_xml(format('SELECT count(*) AS c FROM %I', table_name), false, true, '')))[1]::text::int AS rows
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
SQL

echo ""
echo "Kết nối: postgresql://hotel:hotel123@localhost:5432/hotelmanagement"

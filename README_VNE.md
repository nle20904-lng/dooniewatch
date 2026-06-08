# 🕐 Doonie Watch — Phân Tích Dữ Liệu Shopee

> **⚠️ LƯU Ý QUAN TRỌNG**
> **Dữ liệu sử dụng trong dự án đã được ẩn danh (masked) và được phép sử dụng với sự đồng ý bằng văn bản từ chủ shop.**

---

## 📌 Mục lục

1. [Bối cảnh dự án](#1-bối-cảnh-dự-án)
2. [Quy trình thực hiện](#2-quy-trình-thực-hiện)
3. [Phân tích Insight chuyên sâu](#3-phân-tích-insight-chuyên-sâu)
4. [Kết quả đạt được (01/2025 → 05/2026)](#4-kết-quả-đạt-được-012025--052026)
5. [Giá trị & Kinh nghiệm thu được](#5-giá-trị--kinh-nghiệm-thu-được)

---

# 1. Bối cảnh dự án

**🔗 Demo:** *(đính kèm link Power BI report)*

> **⚠️ Lưu ý:** Toàn bộ dữ liệu đã được ẩn danh và được sử dụng với sự đồng ý bằng văn bản từ chủ shop.

## Khách hàng là ai?

Doonie Watch là một cửa hàng bán đồng hồ hoạt động trên Shopee Việt Nam hơn 2 năm, kinh doanh nhiều phân khúc như đồng hồ thời trang, điện tử và luxury từ các thương hiệu như Casio, DW, Longines, Movado,...

## Vấn đề trước tháng 01/2025

Trước khi triển khai dự án, chủ shop chưa có hệ thống quản lý dữ liệu bài bản. Toàn bộ việc theo dõi chỉ dựa trên dashboard mặc định của Shopee, dẫn đến:

* Báo cáo doanh thu thiếu nhất quán và khó kiểm chứng
* Không thể theo dõi lợi nhuận, cấu trúc chi phí hay biên lợi nhuận
* Các vấn đề vận hành như tỷ lệ hủy đơn cao tồn tại nhưng không được nhận diện
* Các quyết định kinh doanh chủ yếu dựa trên cảm tính

## Điều chủ shop cần

Chủ shop muốn vượt khỏi các báo cáo mặc định của Shopee để có:

* Góc nhìn toàn diện về doanh thu, lợi nhuận, khách hàng và rủi ro
* Khả năng tìm ra nguyên nhân gốc rễ của vấn đề
* Một hệ thống dữ liệu có khả năng mở rộng thay vì các file Excel rời rạc

## Vai trò của tôi — Hai trách nhiệm chính

Tôi tham gia dự án với vai trò **Freelance Data Consultant** ở cả hai mảng:

| Vai trò                       | Công việc                                                                                                                                                               |
| ----------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Data BI Analyst**           | Xây dựng hệ thống dữ liệu end-to-end: ingest dữ liệu bằng Python, thiết kế PostgreSQL Star Schema, pipeline bằng stored procedures và 4 dashboard Power BI tương tác    |
| **Digital Marketing Analyst** | Phân tích traffic & conversion trên Shopee, đánh giá hiệu quả chiến dịch quảng cáo, tối ưu phân bổ ngân sách theo brand/category và đưa ra insight marketing hàng tháng |

## Các dashboard đã xây dựng

| Dashboard                   | Mục tiêu kinh doanh               | Chỉ số chính                        |
| --------------------------- | --------------------------------- | ----------------------------------- |
| 📊 **P&L Tracking**         | Tăng lợi nhuận                    | Revenue, GPM, NPM, Cấu trúc chi phí |
| 👥 **Customer Analytics**   | Tăng trưởng & giữ chân khách hàng | New vs Returning, Retention Rate    |
| 🛒 **Traffic & Conversion** | Tối ưu hiệu quả marketing         | Views, CTR, Conversion Rate         |
| ⚠️ **Risk Management**      | Giảm rủi ro vận hành              | Cancellation Rate, Return Rate      |

> 📸 Xem mockup dashboard ở phần 2.5.

---

# 2. Quy trình thực hiện

## 2.1 Tổng quan Data Pipeline

```text
```text
Shopee Raw Exports (Excel)
          │
          ▼
  Python Ingestion Script
  ├── pandas: parse & normalize dữ liệu
  ├── openpyxl: đọc file Excel (.xlsx)
  └── sqlalchemy: load dữ liệu vào PostgreSQL
          │
          ▼
  PostgreSQL — schema root_data (staging layer)
  ├── root_data.order_all
  │      ← lưu dữ liệu đơn hàng thô từ Shopee
  │
  ├── root_data.orders
  │      ← dữ liệu đơn hàng đã deduplicate & upsert
  │
  ├── root_data.product_all
  │      ← dữ liệu performance sản phẩm thô
  │
  ├── root_data.product_performance
  │      ← dữ liệu performance đã làm sạch & merge
  │
  ├── root_data.sanpham
  │      ← master data sản phẩm (manual mapping)
  │
  ├── root_data.phanloai
  │      ← master data variants/phân loại
  │
  └── root_data.campaign
         ← dữ liệu chiến dịch quảng cáo
          │
          ▼
  3 Stored Procedures (schema stg)
  ├── prc_update_status_fact_txn_orders
  │      ← Bước 1: upsert & đồng bộ dữ liệu raw
  │
  ├── prc_insert_dim_tables
  │      ← Bước 2: build toàn bộ dimension tables
  │
  └── prc_insert_fact_tables
         ← Bước 3: tính toán toàn bộ fact tables
          │
          ▼
  Power BI (Import Mode)
  ├── DAX custom measures
  └── 4 Interactive Dashboards
```

---

## 2.2 EDA — Phân tích dữ liệu đầu vào

Trước khi xây dựng database, dữ liệu export từ Shopee được profiling để hiểu cấu trúc, chất lượng và các hạn chế của dữ liệu.

**📘 Từ điển dữ liệu đầu vào →** [Xem chi tiết](./data%20dictionary/data_dictionary_input.md)

### Hai nguồn dữ liệu chính

### Nguồn 1 — Order Export (`Order_all_YYYYMMDD_YYYYMMDD.xlsx`)

* 62 cột dữ liệu gồm: metadata đơn hàng, sản phẩm, giá bán, discount, shipping, phương thức thanh toán,...
* Vấn đề chính:

  * Package ID bị null với đơn hủy
  * Cancellation reason ở dạng text tự do
  * Một đơn nhiều SKU gây duplicate row

### Nguồn 2 — Product Performance Export (`parentskudetail_YYYYMMDD_YYYYMMDD.xlsx`)

* 40 cột dữ liệu: views, clicks, CTR, conversion rate,...
* Vấn đề chính:

  * Dữ liệu trộn giữa parent SKU và variant SKU
  * Format số kiểu Việt Nam (`15.690.000`)
  * % được lưu dưới dạng string

## Các phát hiện quan trọng từ EDA

| Insight                                         | Ý nghĩa                                                  |
| ----------------------------------------------- | -------------------------------------------------------- |
| COD chiếm ~70% đơn hàng                         | COD là nguyên nhân chính gây tỷ lệ hủy đơn cao           |
| Casio có CTR & Conversion đều cao               | Đây là brand có ROI marketing tốt nhất                   |
| Luxury watches nhiều view nhưng conversion thấp | Có trust gap                                             |
| HCM chiếm hơn 85% khách hàng                    | Đồng Nai & Bình Dương có nhu cầu tự nhiên chưa khai thác |

---

## 2.3 Thiết kế Star Schema & Tổ chức dữ liệu

**📗 Từ điển dữ liệu đầu ra →** [Xem chi tiết](./data%20dictionary/data_dictionary_output.md)

Hệ thống được thiết kế theo mô hình Star Schema để tối ưu cho Power BI Import Mode và analytical workloads.

### Các thành phần chính

* `dim_customer`
* `dim_products`
* `dim_variants`
* `fact_txn_orders`
* `fact_order_detail`
* `fact_daily_profit_and_loss`
* `fact_customer_monthly_metrics`
* `fact_monthly_risk_management`

Ngoài ra còn có các pre-aggregated fact tables để tăng hiệu năng dashboard.

---

## 2.4 Stored Procedures

Toàn bộ pipeline chạy qua 3 stored procedures:

```sql
call stg.prc_update_status_fact_txn_orders();
call stg.prc_insert_dim_tables();
call stg.prc_insert_fact_tables();
```

### 1. `prc_update_status_fact_txn_orders`

Chức năng:

* Upsert dữ liệu đơn hàng
* Đồng bộ trạng thái đơn
* Merge dữ liệu performance

### 2. `prc_insert_dim_tables`

Chức năng:

* Rebuild toàn bộ dimension tables
* Tạo surrogate key
* Mapping dữ liệu chuẩn hóa

### 3. `prc_insert_fact_tables`

Chức năng:

* Tính toán toàn bộ fact tables
* Generate KPI
* Aggregate dữ liệu phục vụ Power BI

---

## 2.5 Dashboard Mockups & Output

### 📊 Dashboard 1 — P&L Tracking

Mục tiêu:

* Theo dõi doanh thu
* Theo dõi lợi nhuận
* Kiểm soát chi phí vận hành

Insight chính:

* Platform fee chiếm ~81% operating expense

---

### 👥 Dashboard 2 — Customer Analytics

Mục tiêu:

* Theo dõi tăng trưởng khách hàng
* Đo retention rate
* Phân tích geographic segmentation

Insight chính:

* Các tỉnh nhỏ có retention tốt hơn HCM

---

### 🛒 Dashboard 3 — Traffic & Conversion

Mục tiêu:

* Theo dõi hiệu quả marketing
* Đo CTR & conversion
* Tìm brand hiệu quả nhất

Insight chính:

* Casio có ROI tốt nhất
* DW có CTR cao nhưng conversion thấp

---

### ⚠️ Dashboard 4 — Risk Management

Mục tiêu:

* Giảm tỷ lệ hủy đơn
* Theo dõi return/refund
* Phân tích risk theo payment method

Insight chính:

* COD có cancellation rate cao gấp gần 3 lần prepaid

---

# 3. Phân tích Insight chuyên sâu

## 🔴 Insight 1: COD là nguồn thất thoát doanh thu lớn nhất

COD chiếm khoảng 70% đơn hàng nhưng có tỷ lệ hủy lên đến 26.6%.

### Hành động đề xuất

* Chạy voucher campaign để chuyển COD sang ShopeePay
* Giảm tỷ trọng COD từ 70% → 55%

---

## 🟡 Insight 2: Platform Fee là trần lợi nhuận

Platform fee chiếm 80.69% operating expense.

### Hành động đề xuất

* Audit hiệu quả campaign hàng tháng
* Tắt các campaign CTR cao nhưng conversion thấp

---

## 🟢 Insight 3: Casio & Pindows là nhóm brand ROI cao

Casio và Pindows có conversion vượt benchmark.

### Hành động đề xuất

* Tăng ngân sách quảng cáo Casio 20–30%
* A/B test cho DW

---

## 🟡 Insight 4: Thị trường tỉnh còn chưa được khai thác

Đồng Nai & Bình Dương đã có demand tự nhiên dù chưa chạy ads.

### Hành động đề xuất

* Test paid acquisition ở Đồng Nai
* Chưa scale ở các tỉnh có cancellation rate cao

---

## 🔴 Insight 5: Retention đang tăng nhưng base còn nhỏ

Retention đạt 9.26% trong tháng 05/2026.

### Hành động đề xuất

* Xây dựng post-purchase flow
* Re-engagement campaign sau mua hàng

---

# 4. Kết quả đạt được (01/2025 → 05/2026)

## Tăng trưởng doanh thu

| Giai đoạn         | Revenue     | Net Profit | Avg NPM |
| ----------------- | ----------- | ---------- | ------- |
| 2024 (từ tháng 5) | 93.20M VND  | 6.29M VND  | 6.8%    |
| 2025              | 270.22M VND | 21.60M VND | 8.0%    |
| 2026 (Jan–May)    | ~162M VND   | 35.4M VND  | ~20%    |

### Kết quả nổi bật

* Monthly revenue tăng từ 8.38M → 34.5M
* Net margin tăng từ ~7% → ~20%
* Eliminate loss months
* Retention tăng mạnh

---

# 5. Giá trị & Kinh nghiệm thu được

## Domain Knowledge

* Hiểu sâu về e-commerce Việt Nam
* COD dynamics
* Shopee fee structure
* Campaign mechanism

## UI / UX

* Thiết kế dashboard cho non-technical users
* Storytelling bằng dashboard

## Technical Skills

| Mảng                | Kỹ năng                            |
| ------------------- | ---------------------------------- |
| Data Engineering    | Python ETL, pandas, sqlalchemy     |
| Database            | PostgreSQL, Star Schema            |
| SQL Analytics       | CTE, Window Functions, MERGE       |
| Visualization       | Power BI, DAX                      |
| Marketing Analytics | CTR × Conversion, cohort retention |

## Key Takeaways

* Infrastructure quan trọng hơn insight
* Marketing analytics cần business context
* COD risk là vấn đề vận hành, không chỉ là analytics
* Retention trong ngành đồng hồ cần benchmark riêng

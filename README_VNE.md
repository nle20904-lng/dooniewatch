# 🕐 Doonie Watch — Phân Tích Dữ Liệu Sàn Thương Mại Điện Tử Shopee

> **⚠️ LƯU Ý QUAN TRỌNG**
> **Toàn bộ dữ liệu sử dụng trong dự án này đã được làm mờ (masked) và được sự cho phép, đồng ý bằng văn bản từ chủ gian hàng.**

---

## 📌 Mục lục

1. [Bối cảnh & Tổng quan dự án](https://www.google.com/search?q=%231-b%E1%BB%91i-c%E1%BA%A3nh--t%E1%BB%95ng-quan-d%E1%BB%B1-%C3%A1n)
2. [Quy trình triển khai từng bước](https://www.google.com/search?q=%232-quy-tr%C3%ACnh-tri%E1%BB%83n-khai-t%E1%BB%ABng-b%C6%B0%E1%BB%9Bc)
3. [Phân tích chuyên sâu & Thấu hiểu dữ liệu (Insights)](https://www.google.com/search?q=%233-ph%C3%A2n-t%C3%ADch-chuy%C3%AAn-s%C3%A2u--th%E1%BA%A5u-hi%E1%BB%83u-d%E1%BB%AF-li%E1%BB%87u-insights)
4. [Thành tựu đạt được (Tháng 01/2025 → Tháng 05/2026)](https://www.google.com/search?q=%234-th%C3%A0nh-t%E1%BB%B1u-%C4%91%E1%BA%A1t-%C4%91%C6%B0%E1%BB%A3c-th%C3%A1ng-012025--th%C3%A1ng-052026)
5. [Giá trị tích lũy](https://www.google.com/search?q=%235-gi%C3%A1-tr%E1%BB%8B-t%C3%ADch-l%C5%A9y)

---

## 1. Bối cảnh & Tổng quan dự án

**🔗 Link Demo:** *(Liên kết đến báo cáo Power BI)*

> **⚠️ GHI CHÚ: Mọi số liệu đã được bảo mật và chỉ sử dụng cho mục đích demo với sự đồng ý của đối tác.**

### Khách hàng là ai?

Doonie Watch là thương hiệu bán lẻ đồng hồ vận hành trên sàn Shopee Việt Nam hơn 2 năm, chuyên cung cấp các dòng đồng hồ thời trang, đồng hồ điện tử và phân khúc cao cấp từ nhiều thương hiệu (Casio, Movado, DW, Longines,...).

### Vấn đề gặp phải — Trước tháng 01/2025

Trước khi tôi tham gia dự án, gian hàng hoàn toàn không có hệ thống quản lý dữ liệu bài bản. Mọi hoạt động theo dõi chỉ phụ thuộc vào các màn hình tổng quan mặc định của Shopee. Hệ quả là:

* Báo cáo doanh thu thiếu nhất quán và không đáng tin cậy.
* Không thể theo dõi chính xác lợi nhuận, cấu trúc chi phí hay biên lợi nhuận.
* Các vấn đề vận hành nghiêm trọng (như tỷ lệ hủy đơn cao) tồn tại nhưng bị "ẩn lấp".
* Mọi quyết định kinh doanh đều dựa vào cảm tính — doanh thu dậm chân tại chỗ ở mức nền thấp.

### Nhu cầu của Chủ doanh nghiệp

Chủ gian hàng mong muốn vượt ra khỏi các chỉ số bề nổi của Shopee để đạt được:

* Cái nhìn toàn diện (Full visibility) về hiệu suất kinh doanh từ doanh thu, lợi nhuận, hành vi khách hàng cho đến các rủi ro vận hành.
* Khả năng truy xuất tận gốc (Root-cause analysis) các vấn đề phát sinh ngay khi chúng xuất hiện.
* Một hạ tầng dữ liệu bền vững, có khả năng mở rộng (Scalable) chứ không phải các bảng tính Excel rời rạc dùng một lần.

### Vai trò của tôi — Trách nhiệm kép

Tôi đồng hành cùng dự án với tư cách **Cố vấn Dữ liệu Độc lập (Freelance Data Consultant)** đảm nhận hai vai trò cốt lõi:

| Vai trò | Trách nhiệm chính |
| --- | --- |
| **Data BI Analyst** | Xây dựng hạ tầng dữ liệu toàn diện (end-to-end): Tự động hóa nạp dữ liệu thô (Python), thiết kế cơ sở dữ liệu PostgreSQL (Mô hình Star Schema), thiết lập đường ống pipeline qua Stored Procedures, và hoàn thiện 4 dashboard Power BI tương tác (P&L, Khách hàng, Traffic/Conversion, Quản trị rủi ro). |
| **Digital Marketing Analyst** | Phân tích dữ liệu lưu lượng truy cập (Traffic) và tỷ lệ chuyển đổi (CR) trên Shopee để phát hiện các chiến dịch kém hiệu quả; tối ưu hóa ngân sách quảng cáo theo thương hiệu/danh mục; định vị khoảng cách giữa CTR và tỷ lệ chuyển đổi; đưa ra khuyến nghị tối ưu marketing hàng tháng. |

### Hệ thống Dashboard đầu ra

4 hệ thống dashboard tương tác trên Power BI được xây dựng nhằm giải quyết triệt để các bài toán kinh doanh cốt lõi:

| Dashboard | Mục tiêu kinh doanh | Chỉ số cốt lõi (KPIs) |
| --- | --- | --- |
| 📊 **Theo dõi P&L** | Tối ưu hóa lợi nhuận | Doanh thu, Biên LN gộp (GPM), Biên LN thuần (NPM), Cấu trúc chi phí vận hành (Opex). |
| 👥 **Phân tích Khách hàng** | Tăng trưởng & Giữ chân | Khách hàng Mới vs Khách quay lại, Tỷ lệ giữ chân (Retention Rate), Phân rã địa lý. |
| 🛒 **Traffic & Chuyển đổi** | Tối đa hóa ROI Marketing | Lượt xem, CTR, Tỷ lệ chuyển đổi (CR), Ma trận hiệu suất thương hiệu. |
| ⚠️ **Quản trị Rủi ro** | Giảm thiểu tổn thất vận hành | Tỷ lệ hủy đơn, Tỷ lệ hoàn hàng, Rủi ro theo Phương thức thanh toán & Tỉnh thành. |

---

### Mô phỏng Giao diện & Thành phần Dashboard

**🔗 Báo cáo Power BI:** *(link)*

---


## P&L Tracking

Báo cáo này tái hiện cấu trúc bảng P&L theo tháng, giúp team thấy được doanh thu đang đến từ đâu, chi phí đang ăn vào lợi nhuận ở lớp nào, và biên lợi nhuận thực tế đang ở mức nào so với kỳ trước.

**Doanh thu & giá vốn**
- Total Revenue — doanh thu thuần từ đơn hoàn thành trong tháng, kèm tăng trưởng MoM
- Total Unit Cost — tổng giá vốn hàng bán, phản ánh Gross Profit Margin (GPM)

**Chi phí vận hành (Operating Expense)**
- Platform Fee — phí sàn Shopee, chiếm tỷ trọng lớn nhất (~80% OpEx)
- Shipping Fee — phí vận chuyển
- Marketing Fee — chi phí quảng cáo trên sàn
- Tax Fee — thuế phát sinh

**Lợi nhuận**
- Net Profit — lợi nhuận ròng sau tất cả chi phí, kèm tăng trưởng MoM
- Gross Profit Margin (%) & Net Profit Margin (%) theo từng tháng

Nhìn vào đây, team có thể thấy ngay tháng nào biên gộp ổn nhưng biên ròng vẫn co lại vì platform fee tăng, hoặc doanh thu tăng trưởng tốt nhưng net profit không theo kịp do chi phí vận hành vượt ngưỡng.

---

## Customer Acquisition & Retention

Báo cáo này theo dõi chất lượng tệp khách hàng — không chỉ đếm số lượng mà phân tách rõ khách mới và khách quay lại, từ đó đánh giá được hiệu quả acquisition và mức độ gắn kết của người mua.

**Chỉ số tổng quan**
- Total Customers — tổng khách hàng trong tháng
- New Customers — khách mua lần đầu, kèm tăng trưởng MoM
- Returning Customers — khách mua lại, kèm tăng trưởng MoM
- Retention Rate (%) — tỷ lệ giữ chân, so với trung bình năm

**Phân tích chi tiết**
- Tỷ lệ New vs Returning theo từng tháng (biểu đồ xu hướng)
- MoM% tăng trưởng khách mới — phát hiện tháng nào acquisition đang chậm lại
- Breakdown theo thành phố — New Customer Rate và Retention Rate theo từng tỉnh/thành

Nhìn vào đây, team có thể thấy retention rate đang ở mức rất thấp (~4–9%) cho thấy phần lớn khách chỉ mua một lần, từ đó đặt câu hỏi cần ưu tiên giữ chân khách cũ hay tiếp tục đổ ngân sách kéo khách mới.

---

## Traffic & Conversion Performance

Báo cáo này theo dõi toàn bộ phễu từ lúc khách nhìn thấy sản phẩm đến lúc hoàn tất đơn hàng, giúp xác định điểm thắt cổ chai đang xảy ra ở bước nào trong hành trình mua.

**Chỉ số phễu**
- Views — tổng lượt hiển thị sản phẩm, kèm MoM
- Clicks — lượt click vào sản phẩm và CTR (Click-Through Rate), kèm MoM
- Add To Cart — lượt thêm vào giỏ hàng, kèm MoM
- Completed Orders — đơn hoàn thành, kèm MoM và Conversion Rate tổng

**Phân tích sâu**
- Drop-off Funnel — tỷ lệ rớt tại mỗi bước: từ 7,067 clicks chỉ còn 887 add-to-cart (12.55%) và 111 đơn hoàn thành (1.57%)
- Traffic Distribution by Product Category — danh mục nào đang kéo nhiều traffic nhất
- Brand Matrix (CTR vs Conversion Rate) — xác định thương hiệu nào có traffic cao nhưng convert kém, và ngược lại

Nhìn vào đây, team biết ngay vấn đề nằm ở đâu — nếu CTR thấp thì cần tối ưu ảnh và tiêu đề sản phẩm; nếu add-to-cart cao nhưng convert thấp thì vấn đề nằm ở trang checkout hoặc giá.

---

## Order Fulfillment Risk & Loss Management

Báo cáo này theo dõi các rủi ro sau khi đơn được đặt — hủy đơn và hoàn trả — và phân tích theo nhiều chiều để tìm ra nhóm sản phẩm, phương thức thanh toán hay khu vực địa lý nào đang gây tổn thất nhiều nhất.

**Chỉ số tổng quan**
- Canceled Orders — số đơn hủy trong tháng và Cancellation Rate (%), so với trung bình năm
- Returned Orders — số đơn hoàn trả và Returned Order Rate (%), so với trung bình năm

**Phân tích chi tiết**
- Fulfillment Risk Trend — xu hướng cancellation rate và return rate theo tháng, đặt cạnh tổng đơn
- Breakdown by Product Category — danh mục nào có tỷ lệ hủy/hoàn cao bất thường
- Brand Performance Risk Matrix — scatter plot xác định thương hiệu nào vừa có cancellation rate cao vừa có return rate cao
- Order Vulnerability by Payment Method — phương thức thanh toán nào (COD, SPayLater, v.v.) đi kèm với tỷ lệ hủy cao nhất
- Distribution by City — khu vực địa lý nào đang có cancellation rate vượt mức trung bình

Nhìn vào đây, team không chỉ biết "bao nhiêu đơn bị hủy" mà hiểu được nguyên nhân gốc rễ — ví dụ COD đang chiếm tỷ lệ hủy lớn nhất cho thấy cần xem xét chính sách thanh toán, hoặc một danh mục cụ thể có return rate cao bất thường gợi ý vấn đề về chất lượng sản phẩm hay mô tả sai.

---

## 2. Quy trình triển khai từng bước

### 2.1 Tổng quan Đường ống Dữ liệu (Data Pipeline)

```
Dữ liệu thô xuất từ Shopee (Excel)
          │
          ▼
  Script Ingestion bằng Python
  ├── pandas: Xử lý cấu trúc & Chuẩn hóa dữ liệu
  ├── openpyxl: Đọc tệp xlsx cấu trúc phức tạp
  └── sqlalchemy: Ghi dữ liệu vào PostgreSQL
          │
          ▼
  PostgreSQL — Schema root_data (Staging Layer)
  ├── root_data.order_all       ← Nơi tiếp nhận đơn hàng thô
  ├── root_data.orders          ← Đơn hàng đã loại trùng (Deduplicated) & Upsert
  ├── root_data.product_all     ← Hiệu suất sản phẩm thô
  ├── root_data.product_performance ← Dữ liệu sản phẩm sạch sau khi gom nhóm
  ├── root_data.sanpham         ← Danh mục sản phẩm gốc (Master data - nhập tay)
  ├── root_data.phanloai        ← Chi tiết phân loại/variant (Master data - nhập tay)
  └── root_data.campaign        ← Dữ liệu chiến dịch quảng cáo shopee
          │
          ▼
  3 Stored Procedures (Schema stg - Transformation Layer)
  ├── prc_update_status_fact_txn_orders  ← Bước 1: Đồng bộ trạng thái & Upsert dữ liệu thô
  ├── prc_insert_dim_tables              ← Bước 2: Khởi tạo/Cập nhật các bảng Chiều (Dimension)
  └── prc_insert_fact_tables             ← Bước 3: Tính toán toàn bộ các bảng Sự kiện (Fact)
          │
          ▼
  Power BI (Chế độ Import Mode)
  ├── Tính toán các chỉ số nâng cao bằng DAX Measures
  └── Trực quan hóa lên 4 Dashboard Tương tác

```

---

### 2.2 Phân tích Dữ liệu Khám phá (EDA Input)

Trước khi tiến hành thiết kế kiến trúc DB, các tệp dữ liệu xuất thô từ sàn được kiểm tra, đánh giá chất lượng kỹ lưỡng để hiểu rõ cấu trúc và các điểm hạn chế.

**Từ điển Dữ liệu Đầu vào (Input Data Dictionary) →** [Xem chi tiết tại đây](https://www.google.com/search?q=./data%2520dictionary/data_dictionary_input.md)

**Hai nguồn dữ liệu thô chính:**

**Nguồn 1 — Báo cáo Đơn hàng (`Order_all_YYYYMMDD_YYYYMMDD.xlsx`)**

* Gồm 62 cột: Chứa thông tin định danh đơn hàng, sản phẩm, phân loại, giá bán, giảm giá, phí vận hành sàn, phương thức thanh toán và địa chỉ người mua.
* Vấn đề cốt lõi: Các đơn hàng bị hủy thường bị khuyết ID kiện hàng (Package ID); lý do hủy nhập dạng text tự do cần bóc tách; các đơn có nhiều SKU tạo ra các dòng trùng lặp thông tin chung cần xử lý.

**Nguồn 2 — Báo cáo Hiệu suất Sản phẩm (`parentskudetail_YYYYMMDD_YYYYMMDD.xlsx`)**

* Gồm 40 cột: Lượt xem, lượt click, CTR, tỷ lệ chuyển đổi, lượt thêm vào giỏ hàng, tỷ lệ mua lại.
* Vấn đề cốt lõi: Dữ liệu bị trộn lẫn giữa dòng cấp sản phẩm cha (Parent) và dòng cấp phân loại (Variant); định dạng số kiểu Việt Nam (`15.690.000`) và các tỷ lệ phần trăm lưu ở dạng text (string) bắt buộc phải convert lại.

**Kết quả EDA trọng tâm dưới góc nhìn Tăng trưởng (Digital Marketing):**

| Phát hiện từ EDA | Ý nghĩa chiến lược đối với Marketing |
| --- | --- |
| Đơn COD chiếm đa số (~70%) | Phương thức thanh toán là yếu tố dự báo hủy đơn mạnh nhất — không phải do chất lượng sản phẩm. |
| Casio có chỉ số CTR × CR đều vượt mức trung bình | Xác định đây là thương hiệu ưu tiên ngân sách: Quảng cáo Casio đem lại ROI cao nhất. |
| Dòng đồng hồ Luxury: Lượt xem rất cao, Chuyển đổi gần như bằng 0 | Rào cản nằm ở niềm tin (Trust gap), không phải do thiếu nhu cầu → Cần đổi chiến lược nội dung/quà tặng thay vì giảm giá. |
| TP.HCM chiếm hơn 85% tổng lượng khách hàng | Các tỉnh lân cận (Đồng Nai, Bình Dương) bắt đầu xuất hiện nhu cầu tự nhiên → Thị trường ngách đầy tiềm năng chưa khai phá. |

---

### 2.3 Thiết lập Mô hình Dữ liệu Star Schema

**Từ điển Dữ liệu Đầu ra (Output Data Dictionary) →** [Xem chi tiết tại đây](https://www.google.com/search?q=./data%2520dictionary/data_dictionary_output.md)

```
dim_customer ─────────────────────────── fact_txn_orders
  key_customer_id (PK)                    transaction_order_id (PK)
  customer_id                             order_id
  customer_name                           key_customer_id (FK)
  city_key (FK → dim_city)               total_price
  district_key (FK → dim_district)       payment_method_id (FK)
  ward_key (FK → dim_ward)               order_status_id (FK)
                                          order_date_key (FK → dim_date)
                                                │
                              ┌─────────────────┴──────────────────┐
                              ▼                                     ▼
                    fact_order_detail                      fact_order_fee
                      order_id (FK)                         order_id (FK)
                      key_product_id (FK)                   fee_type_key_id (FK)
                      key_variants_id (FK)                  amount
                      total_price
                      quantity
                      unit_cost
                          │
              ┌───────────┴───────────┐
              ▼                       ▼
        dim_variants            dim_products
        key_variants_id (PK)    key_product_id (PK)
        key_product_id (FK)     product_name
        unit_cost               key_brand_id (FK → dim_brands)
        sale_price              key_category_id (FK → dim_category)
        variants_type_key_id    key_gender_id (FK → dim_gender)
        variants_size_key_id    key_strap_type_id
                                key_face_shape_id

Các Bảng Sự Kiện Đã Được Tính Toán Sẵn (Pre-aggregated Fact Tables):
  fact_daily_profit_and_loss (P&L theo ngày)
  fact_monthly_profit_and_loss (P&L theo tháng)
  fact_annually_profit_and_loss (P&L theo năm)
  fact_monthly_products_performance (Hiệu suất sản phẩm theo tháng)
  fact_customer_monthly_metrics (Chỉ số khách hàng theo tháng)
  fact_monthly_risk_management (Quản trị rủi ro theo tháng)
  fact_product_performance (Hiệu suất sản phẩm chi tiết)
  fact_campaign_performance (Hiệu suất chiến dịch quảng cáo)

```

---

### 2.4 Hệ thống Stored Procedures

Toàn bộ quy trình biến đổi dữ liệu từ tầng Staging thô lên các mô hình Fact/Dim sẵn sàng cho Power BI được tự động hóa qua **3 thủ tục lưu trữ (Stored Procedures)** chạy tuần tự:

```sql
call stg.prc_update_status_fact_txn_orders();
call stg.prc_insert_dim_tables();
call stg.prc_insert_fact_tables();

```

---

#### 1. `prc_update_status_fact_txn_orders` — Đồng bộ & Cập nhật Dữ liệu Thô (Upsert)

**Mục tiêu:** Đồng bộ dữ liệu mới nhất từ các bảng tạm (staging load) vào bảng làm việc chính thức. Đảm bảo xử lý mượt mà cả bản ghi mới lẫn cập nhật trạng thái đơn hàng cũ.

**Cơ chế hoạt động:**

* **Phần 1 — Khớp và cập nhật Đơn hàng (`root_data.orders`):** Tìm kiếm mã đơn hàng (`ma_don_hang`) mới xuất hiện để tiến hành `INSERT`. Với các đơn đã tồn tại, tiến hành cập nhật lại toàn bộ thông tin trạng thái, bởi trên Shopee đơn hàng liên tục chuyển đổi trạng thái (ví dụ: Chờ xử lý → Đã hoàn thành). Khóa khớp lệnh: `ma_don_hang` + `sku_san_pham` + `sku_phan_loai_hang`.
* **Phần 2 — Đồng bộ Hiệu suất sản phẩm (`root_data.product_performance`):** Sử dụng lệnh `MERGE` dựa trên bộ khóa `(thoi_gian, ma_san_pham, sku_san_pham, sku_phan_loai)`. Nếu khớp (`MATCHED`) sẽ cập nhật chỉ số traffic mới; nếu chưa có (`NOT MATCHED`) sẽ chèn dòng mới cho kỳ báo cáo đó.

---

#### 2. `prc_insert_dim_tables` — Khởi tạo toàn bộ Hệ thống Bảng Chiều (Dimensions)

**Mục tiêu:** Làm sạch (Truncate) và tái cấu trúc lại các bảng chiều từ nguồn dữ liệu chuẩn hóa nhằm tối ưu bộ nhớ và tốc độ truy vấn. Quy trình gồm **20 bước xử lý cụ thể**:

| Bước | Bảng Chiều (Dimension Table) | Nguồn dữ liệu | Logic xử lý dữ liệu |
| --- | --- | --- | --- |
| 1 | `dim_brands` | `root_data.sanpham` | Sử dụng hàm `RANK()` theo tên thương hiệu; gán khóa `-1` cho sản phẩm không rõ thương hiệu. |
| 2 | `dim_gender` | `root_data.sanpham` | Phân loại nhóm giới tính bằng `RANK()`; gán `-1` cho sản phẩm unisex/không rõ. |
| 3 | `dim_strap_type` | `root_data.sanpham` | Chuẩn hóa bảng tra cứu chất liệu dây (dây da, kim loại, cao su,...). |
| 4 | `dim_face_shape` | `root_data.sanpham` | Bảng tra cứu hình dáng mặt đồng hồ; gán `-1` cho các mẫu đặc biệt. |
| 5 | `dim_category` | `root_data.sanpham` | Định nghĩa phân khúc sản phẩm (đồng hồ điện tử, thời trang, cao cấp, phụ kiện). |
| 6 | `dim_products` | `root_data.sanpham` + liên kết Dim | Tạo khóa thay thế (surrogate key) bằng `ROW_NUMBER()`; liên kết đầy đủ các thuộc tính thương hiệu, giới tính, loại dây, kiểu mặt. |
| 7 | `dim_district` | `root_data.orders` | Trích xuất danh sách Quận/Huyện không trùng lặp từ thông tin giao hàng. |
| 8 | `dim_ward` | `root_data.orders` | Trích xuất danh sách Phường/Xã sạch từ địa chỉ đơn hàng. |
| 9 | `dim_city` | `root_data.orders` | Trích xuất danh sách Tỉnh/Thành phố chuẩn hóa toàn quốc. |
| 10 | `dim_customer` | `root_data.orders` | Định vị ngày mua hàng đầu tiên làm ngày đăng ký; mapping với địa chỉ vùng miền. |
| 11 | `dim_variants_type` | `root_data.phanloai` | Chuẩn hóa các biến thể màu sắc, phong cách của sản phẩm. |
| 12 | `dim_variants_size` | `root_data.phanloai` | Chuẩn hóa kích thước mặt đồng hồ (24mm, 32mm, size đôi,...). |
| 12b | `dim_variants` | `root_data.phanloai` + liên kết Dim | Lưu trữ lịch sử giá vốn (`unit_cost`) và giá bán (`sale_price`) trên từng biến thể — điểm mấu chốt để tính biên lợi nhuận gộp chuẩn xác. |
| 13a | `dim_campaign_group` | `root_data.campaign` | Gom nhóm các chiến dịch theo hình thức đấu thầu quảng cáo. |
| 13b | `dim_campaign_status` | `root_data.campaign` | Ánh xạ trạng thái quảng cáo (Đang chạy / Đang tạm dừng). |
| 13c | `dim_campaign` | `root_data.campaign` | Lưu chi tiết chiến dịch, ngày bắt đầu/kết thúc; gắn cờ ngân sách không giới hạn (`is_unlimited`). |
| 14 | `dim_order_status` | `root_data.orders` | Chuẩn hóa trạng thái đơn hàng về dạng số: Đã hủy = 0, Hoàn trả = -1,..., Đã hoàn thành = 6. |
| 15a | `dim_order_cancel_reason` | `root_data.orders` | Phân loại và gom cụm các lý do hủy đơn từ khách hàng và hệ thống. |
| 15b | `dim_payment_method` | `root_data.orders` | Phân tách các phương thức thanh toán trên Shopee. |
| 16 | `dim_date` | `generate_series` | Khởi tạo trục thời gian liên tục từ 2020-2035 hỗ trợ lọc theo ngày, tuần, tháng, quý, năm, cuối tuần. |
| 17 | `dim_profit_and_loss` | `dim_fee_type` + danh mục cố định | Phân loại định khoản kế toán: Nhóm ghi có (C) = Doanh thu thực tế, doanh thu chờ; Nhóm ghi nợ (D) = Giá vốn, các loại phí sàn. |
| 18 | `dim_products_metrics` | Dữ liệu cố định | Định nghĩa 5 chỉ số sản phẩm: lượt xem, lượt click, lượt thoát, thêm giỏ hàng, lượt mua. |
| 19 | `dim_customer_metrics` | Dữ liệu cố định | Định nghĩa 17 chỉ số đo lường hành vi, số lượng đơn và doanh thu từ tệp khách hàng. |
| 20 | `dim_monthly_risk_management_metrics` | Dữ liệu cố định | Định nghĩa 13 chỉ số phân tích rủi ro tổn thất vận hành và biến động GMV. |

---

#### 3. `prc_insert_fact_tables` — Tính toán và Đo lường Bảng Sự kiện (Facts)

**Mục tiêu:** Tổng hợp, tính toán dữ liệu thô kết hợp với các bảng chiều để xuất ra cấu trúc bảng sự kiện tinh gọn, phục vụ trực tiếp cho việc tải dữ liệu siêu tốc trên Power BI. Quy trình gồm **10 bước cốt lõi**:

| Bước | Bảng Sự kiện (Fact Table) | Hạt dữ liệu (Grain) | Logic xử lý trọng tâm |
| --- | --- | --- | --- |
| 1 | `fact_order_fee` | 1 dòng / đơn hàng × loại phí | Tách bạch 7 loại chi phí sàn: phí cố định, phí thanh toán, phí dịch vụ, phí Freeship Xtra (được cấu hình bằng 0.985% của `gia_goc`), phí voucher, thuế VAT (1%), và thuế TNCN (0.5%). |
| 2 | `fact_txn_orders` | 1 dòng / đơn hàng | Gộp các dòng sản phẩm chi tiết về cấp đơn hàng tổng; liên kết thông tin khách hàng, ngày đặt, trạng thái và hình thức thanh toán bằng các khối lệnh `CASE WHEN` phức tạp. |
| 3 | `fact_order_detail` | 1 dòng / đơn hàng × SKU × biến thể | Ánh xạ chính xác giá vốn lịch sử thông qua bảng `face_variant_cost_history` (áp dụng mô hình SCD Type 2) giúp tính toán giá vốn hàng bán (COGS) chuẩn xác theo thời gian thực. |
| 4 | `fact_product_performance` | 1 dòng / sản phẩm × kỳ báo cáo | Thực hiện bộ lọc loại bỏ các dòng cấp biến thể, chỉ giữ lại hiệu suất cấp sản phẩm cha (nơi `ten_phan_loai = '-'`). |
| 5 | `fact_campaign_performance` | 1 dòng / chiến dịch × sản phẩm × ngày | Tính tổng chi phí quảng cáo phát sinh = lượng chuyển đổi × giá mỗi chuyển đổi; liên kết với `dim_products` dựa trên định danh tên sản phẩm. |
| 6 | `fact_daily_profit_and_loss` | 1 dòng / ngày × hạng mục P&L | Tạo ma trận ngày × hạng mục dùng hàm `COALESCE(0)` để tránh bị rỗng dòng; bóc tách doanh thu theo trạng thái đơn (đã thu tiền vs chờ đối soát); bổ sung chi phí cố định (định mức cố định 17.000đ và 50.000đ/tháng) phân bổ đều cho từng ngày. |
| 7 | `fact_monthly_profit_and_loss` | 1 dòng / tháng × hạng mục P&L | Khối tổng hợp dữ liệu tài chính từ cấp ngày lên cấp tháng; khóa định danh dạng `YYYYMM`. |
| 8 | `fact_annually_profit_and_loss` | 1 dòng / năm × hạng mục P&L | Khối tổng hợp dữ liệu tài chính lên cấp năm; khóa định danh dạng `YYYY`. |
| 9 | `fact_monthly_products_performance` | 1 dòng / tháng × nhãn hàng × danh mục × chỉ số | Thực hiện kỹ thuật `UNPIVOT` biến đổi 5 chỉ số sản phẩm từ dạng cột ngang thành cấu trúc hàng dọc tinh gọn cho Power BI. |
| 10a | `fact_customer_monthly_metrics` | 1 dòng / tháng × khách hàng × chỉ số | Sử dụng hệ thống 12 bảng tạm liên tiếp (CTEs): Thiết lập nền tảng tháng → xác định đơn đầu tiên → đo chu kỳ mua lại → kiểm tra cờ khách cũ → tính tổng giá trị vòng đời (LTV) → đo khoảng cách ngày không mua hàng → chuyển đổi cấu trúc `UNPIVOT` ra 13 chỉ số hành vi. |
| 10b | `fact_monthly_risk_management` | 1 dòng / tháng × khu vực × sản phẩm × thanh toán × chỉ số | Thiết lập ma trận tổ hợp tất cả các chiều phân tích với 13 chỉ số rủi ro; dùng lệnh `LEFT JOIN` kết hợp 13 khối CTEs tính toán độc lập để đưa ra bức tranh toàn cảnh về đơn hủy, đơn hoàn và thất thoát GMV theo vùng miền. |

---

## 3. Phân tích chuyên sâu & Thấu hiểu dữ liệu (Insights)

### 🔴 Khám phá 1: Đơn COD là nguồn thất thoát doanh thu cốt lõi

Hình thức ship COD chiếm tới ~70% tổng lượng đơn hàng của shop nhưng lại sở hữu **tỷ lệ hủy đơn lên tới 26.6%** — cao gấp gần 3 lần so với các hình thức trả trước. Bản đồ địa lý cho thấy rủi ro này tập trung mạnh tại các tỉnh như Cà Mau, Vĩnh Long (những khu vực có thời gian vận chuyển dài), chứng minh rằng thời gian giao hàng tỷ lệ thuận với rủi ro bùng hàng COD.

**Hành động đề xuất (Marketing):** Triển khai chiến dịch tặng voucher độc quyền áp dụng riêng cho nhóm khách hàng từng mua COD tại các tỉnh, khuyến khích họ chuyển sang thanh toán qua Ví ShopeePay. Mục tiêu: Giảm tỷ trọng đơn COD từ 70% xuống dưới 55% trong vòng 3 months.

---

### 🟡 Khám phá 2: Chi phí sàn đóng vai trò "trần biên lợi nhuận"

Chi phí trả cho nền tảng Shopee chiếm tới **80.69% tổng chi phí vận hành (Opex)** của shop. Biên lợi nhuận gộp của gian hàng duy trì ở mức rất tốt (49–56%), tuy nhiên biên lợi nhuận thuần bị thu hẹp lại hoàn toàn phụ thuộc vào việc vung tay ngân sách cho quảng cáo Shopee chứ không phải do giá vốn sản phẩm. Trước khi quyết định vít ngân sách cho bất kỳ chiến dịch nào, chỉ số ROI chiến dịch bắt buộc phải được thẩm định.

**Hành động đề xuất (Marketing):** Thiết lập quy trình kiểm toán chiến dịch hàng tháng — tắt ngay lập tức các mẫu quảng cáo có tỷ lệ CTR-to-CR (Click sang Chuyển đổi) nằm dưới mức trung bình của shop. Tái phân bổ ngân sách sang dòng sản phẩm Casio và đồng hồ thời trang đã được chứng minh hiệu quả.

---

### 🟢 Khám phá 3: Casio và Pindows là "cỗ máy hái ra tiền" của gian hàng

Dựa trên Ma trận hiệu suất CTR × Tỷ lệ chuyển đổi, hai thương hiệu Casio và Pindows nằm hoàn toàn ở **vùng phía trên đường chuyển đổi trung bình** — tức là cứ có click vào là tỷ lệ chốt đơn cực kỳ cao so với mặt bằng chung. Ngược lại, thương hiệu DW có CTR rất cao (khách thích click xem) nhưng tỷ lệ mua lại dưới trung bình (dấu hiệu của việc cấn cạ về giá hoặc độ uy tín của gian hàng).

**Hành động đề xuất (Marketing):** Tăng ngay 20–30% ngân sách quảng cáo cho dòng Casio. Đồng thời triển khai thử nghiệm A/B testing đối với các link sản phẩm DW: Thử áp dụng chiến lược tạo giá neo (price anchoring) hoặc bán theo combo kèm phụ kiện để kích thích tỷ lệ chuyển đổi sau click.

---

### 🟡 Khám phá 4: Vùng thị trường địa lý chưa được khai phá

Hai tỉnh Đồng Nai và Bình Dương đang mang lại lượng đơn hàng và doanh thu tự nhiên đều đặn dù shop chưa từng chi một đồng quảng cáo nào tại đây. Việc dồn toàn bộ nguồn lực vào thị trường TP.HCM đang tạo ra rủi ro phụ thuộc vào một thị trường duy nhất.

**Hành động đề xuất (Marketing):** Trích lập ngân sách thử nghiệm khoảng ₫500.000/tháng chạy quảng cáo định vị mục tiêu riêng tại Đồng Nai. Tạm thời loại trừ hiển thị quảng cáo tại Cà Mau và Vĩnh Long cho đến khi quy trình gọi điện xác nhận đơn COD trước khi đi hàng được vận hành ổn định.

---

### 🔴 Khám phá 5: Tỷ lệ giữ chân khách hàng cải thiện nhưng quy mô còn mỏng

Tỷ lệ khách hàng quay lại mua hàng đạt mức 9.26% vào tháng 05/2026 — đánh dấu mức tăng trưởng số lượng khách hàng cũ lên tới +233% so với tháng trước, cho thấy những tín hiệu tốt từ các chương trình CSKH. Tuy nhiên, tính trung bình từ đầu năm 2026 đến nay chỉ số này mới đạt 4.45%.

**Hành động đề xuất (Marketing):** Xây dựng chuỗi kịch bản chăm sóc tự động sau mua: Ngày D+3 gửi tin nhắn nhờ đánh giá 5 sao nhận xu → Ngày D+30 gợi ý mua thêm hộp đựng/thay dây kèm voucher giảm 10% → Ngày D+60 gửi chương trình tri ân tái tương tác. Kỳ vọng nâng tỷ lệ giữ chân lên mức 12–15% trong vòng 2 months.

---

## 4. Thành tựu đạt được (Tháng 01/2025 → Tháng 05/2026)

### Tăng trưởng Doanh thu vượt bậc

| Kỳ báo cáo | Tổng Doanh thu | Lợi nhuận Thuần | Biên LN Thuần trung bình (NPM) |
| --- | --- | --- | --- |
| Năm 2024 (Tính từ tháng 5) | 93.20 Tr VND | 6.29 Tr VND | 6.8% |
| Năm 2025 (Trọn vẹn năm) | 270.22 Tr VND | 21.60 Tr VND | 8.0% |
| Năm 2026 (Từ tháng 1 - 5) | ~162.00 Tr VND | 35.40 Tr VND | **~20.0%** |

Doanh thu theo tháng: Tăng trưởng mạnh mẽ từ **8.38 Tr VND (Tháng 05/2024) lên 34.5 Tr VND (Tháng 05/2026)** — đạt mức **tăng trưởng thần tốc +311%** về quy mô dòng tiền.
Biên lợi nhuận thuần: Cải thiện rõ rệt từ mức **~7% (2024) lên chạm mốc ~20% (2026)** nhờ việc kiểm soát chặt chẽ chi phí ẩn và giảm sự phụ thuộc vào các chương trình giảm giá sâu vô tội vạ.

### Bước chuyển mình về Hiệu suất Lợi nhuận

* Bóc tách thành công chi phí sàn chiếm tới 81% chi phí opex → Giúp chủ shop đưa ra các quyết định cắt giảm quảng cáo rác một cách quyết đoán.
* Biên lợi nhuận gộp đi vào quỹ đạo ổn định ở mức 49–56%, chấm dứt tình trạng trồi sụt khó kiểm soát (từ 48% vọt lên 79% rồi lại sụt giảm) của năm 2024.
* Xóa sổ hoàn toàn các tháng lỗ dòng (như ghi nhận vào tháng 8 và tháng 11 năm 2025) → Tạo chuỗi mạch thắng lợi nhuận đều đặn +4–9 Tr VND/tháng trong năm 2026.

### Định lượng hóa Rủi ro Hủy đơn

| Phương thức thanh toán trên Shopee | Tỷ lệ hủy đơn thực tế |
| --- | --- |
| Thanh toán khi nhận hàng (COD) | **26.6%** |
| Mua trước trả sau (SPayLater) | 23.0% |
| Ví ShopeePay liên kết Ngân hàng | 18.5% |
| Số dư Ví ShopeePay | 14.3% |
| Qua Google Pay | **9.1%** |

### Phát triển Quy mô Tệp Khách hàng từ con số 0

* Quản lý và định danh chính xác **1.979 khách hàng duy nhất (Unique Customers)** xuyên suốt hơn 2 năm vận hành.
* Lượng khách hàng mới theo tháng: Tăng từ **28 khách (Tháng 05/2024) lên 159 khách (Tháng 03/2026)** — đạt mức **tăng trưởng +468%**.
* Tỷ lệ quay lại mua hàng (Retention) có bước nhảy vọt: Từ **1.9% (Tháng 12/2025) bứt phá lên 9.26% (Tháng 05/2026)**.

### Cung cấp Báo cáo Tình báo Tiếp thị (Marketing Intelligence)

* Xác minh dòng sản phẩm Casio chiếm tới **61% tổng lượng đơn toàn shop** → Trở thành kim chỉ nam cho việc gom hàng tồn kho và ưu tiên hiển thị.
* Vẽ rõ bản đồ đứt gãy chuyển đổi của dòng sản phẩm cao cấp (Luxury) → Đưa ra đề xuất cải tiến chiến lược làm video/hình ảnh thực tế để tăng uy tín.
* Vạch trần DW là thương hiệu có chỉ số ảo (CTR cao ngất ngưởng nhưng CR lẹt đẹt) → Đưa ra khuyến nghị thiết lập các chương trình tặng kèm sản phẩm mồi.
* Hoàn thiện hệ thống dashboard marketing đầu tiên kết nối trực tiếp giữa số tiền chi tiêu quảng cáo với trạng thái chuyển đổi đơn hàng thực tế sau cùng.

---

## 5. Giá trị tích lũy

### Kiến thức chuyên môn ngành (Domain Knowledge)

* Hiểu sâu sắc bản chất vận hành TMĐT tại Việt Nam: Sự áp đảo của hình thức COD, cấu trúc biểu phí phức tạp của Shopee, cơ chế vận hành của các ngày hội Flash Sale, các dạng đấu thầu quảng cáo hiển thị (DVHT).
* Phân loại danh mục ngành hàng đồng hồ: Đồng hồ điện tử, thời trang, cao cấp, phụ kiện — và cách mỗi nhóm sản phẩm phản ứng khác nhau với chỉ số CTR, tỷ lệ chuyển đổi, và tỷ lệ hủy đơn.
* Làm chủ dữ liệu hệ thống Shopee Seller: Nắm rõ giới hạn xuất file của sàn, định nghĩa chuẩn xác sự khác biệt giữa đơn tạm tính (placed) và đơn thực thu (confirmed), cùng cơ chế đẩy số của các chương trình trợ giá sàn.

### Tư duy thiết kế Trực quan (UI / UX)

* Thiết kế giao diện Power BI hướng tới người dùng cuối là chủ doanh nghiệp không chuyên về kỹ thuật — đặt tiêu chí rõ ràng, dễ hiểu lên trên sự ôm đồm chỉ số.
* Sáng tạo cấu trúc báo cáo định kỳ hàng tháng dạng "Simple Story" (Câu chuyện tinh gọn): Điểm sức khỏe → Chỉ số biến động → Nguyên nhân cốt lõi → Hành động thực thi.
* Phát triển thành công Chỉ số Sức khỏe Doanh nghiệp (Business Health Score từ 0–100) được tinh chỉnh liên tục cùng chủ shop để đảm bảo độ nhạy thông tin sát nhất với thực tế.

### Năng lực Kỹ thuật (Technical Skills)

| Mảng chuyên môn | Công nghệ & Kỹ thuật áp dụng |
| --- | --- |
| **Kỹ nghệ Dữ liệu (Data Engineering)** | Xây dựng công cụ nạp dữ liệu ETL bằng Python (`pandas`, `openpyxl`, `sqlalchemy`), thiết kế logic cập nhật không trùng lặp (Idempotent Upsert), quản lý phiên bản cấu trúc bảng dữ liệu. |
| **Cơ sở dữ liệu (Database)** | Quản trị PostgreSQL, thiết kế mô hình Star Schema chuẩn kho dữ liệu, thiết lập hệ thống đường ống tự động thông qua 3 Stored Procedures tuần tự, lưu trữ lịch sử giá bằng mô hình SCD Type 2 trên bảng `face_variant_cost_history`. |
| **Phân tích truy vấn SQL** | Sử dụng thuần thục CTEs nâng cao, các hàm cửa sổ (`RANK`, `ROW_NUMBER`, `LAG`), lệnh `MERGE` tối ưu hiệu năng và kỹ thuật `UNION ALL unpivot` để chuẩn hóa bảng dữ liệu ngang thành dọc. |
| **Trực quan hóa dữ liệu** | Vận hành Power BI Desktop, làm chủ ngôn ngữ DAX nâng cao (Tính toán MoM %, Tỷ lệ giữ chân khách hàng, Giá trị đơn hàng trung bình trượt rolling AOV, Tính điểm composite KPI). |
| **Phân tích Marketing** | Thiết lập ma trận đánh giá chéo CTR × CR, tính toán chỉ số ROI trên từng chiến dịch quảng cáo, phân tích tệp khách hàng lặp lại theo mô hình Cohort, phân đoạn thị trường theo địa lý. |
| **Tối ưu hóa hiệu năng** | Ứng dụng mô hình Power BI Import Mode kết hợp với việc đẩy toàn bộ gánh nặng tính toán xuống các bảng Fact pre-aggregated dưới PostgreSQL nhằm tối ưu tốc độ tải báo cáo tức thì. |

### Đúc kết cốt lõi sau dự án

* **Hạ tầng đi trước, insights theo sau** — Việc đầu tư xây dựng hệ thống pipeline tự động qua 3 stored procedures là quyết định sáng suốt nhất. Giờ đây, cứ mỗi khi có file dữ liệu tháng mới, mọi báo cáo tự động cập nhật mà không cần can thiệp thủ công.
* **Dữ liệu tiếp thị không thể tách rời bức tranh tài chính** — Chỉ số CTR của marketing sẽ trở nên vô nghĩa nếu đơn hàng đó bị hủy ở khâu giao nhận. Chính góc nhìn đa chiều (BI kết hợp Marketing) đã giúp chúng tôi lột trần được bài toán tổn thất từ đơn COD.
* **Rủi ro từ đơn COD là bài toán mang tính hệ thống** tại thị trường Việt Nam. Đây là vấn đề cần giải quyết bằng quy trình vận hành và kịch bản chăm sóc khách hàng chứ không thể xử lý thuần túy bằng các báo cáo phân tích trên màn hình.
* **Đo lường tỷ lệ giữ chân cần có hệ quy chiếu đặc thù** — Với một ngành hàng có chu kỳ mua sắm dài như đồng hồ vật lý, tỷ lệ quay lại đạt 9% là một con số rất ấn tượng; điều quan trọng là biết cách truyền đạt con số đó một cách đúng đắn để chủ doanh nghiệp hiểu đúng giá trị tệp khách hàng cũ mang lại.

---

## Công cụ & Hệ sinh thái Công nghệ áp dụng

| Tầng công nghệ | Công cụ sử dụng | Mục tiêu giải quyết |
| --- | --- | --- |
| **Thu thập dữ liệu (Ingestion)** | Python (`pandas`, `openpyxl`, `sqlalchemy`) | Tự động hóa bóc tách cấu trúc phức tạp và nạp các file Excel thô từ Shopee. |
| **Kho dữ liệu (Database)** | PostgreSQL | Lưu trữ tập trung dữ liệu toàn gian hàng theo cấu trúc Star Schema (Schema stg). |
| **Đường ống dữ liệu (Pipeline)** | 3 Stored Procedures (PostgreSQL) | Thực hiện chuỗi chu trình tự động: Đồng bộ → Tạo bảng Chiều → Tính toán bảng Sự kiện cho mỗi lần làm mới dữ liệu. |
| **Khám phá dữ liệu (Exploration)** | SQL (Analytical Queries) | Thực hiện các truy vấn phân tích nhanh (ad-hoc) phục vụ việc tìm kiếm logic trước khi đưa lên báo cáo. |
| **Trực quan hóa (Visualization)** | Power BI Desktop (Chế độ Import) | Thiết kế 4 màn hình dashboard tương tác sâu kết hợp hệ thống công thức DAX Measures. |
| **Phân tích Tăng trưởng** | Power BI + SQL | Xây dựng bản đồ hiệu suất chiến dịch quảng cáo, ma trận CTR/CR và phân mảnh thị trường theo địa lý. |

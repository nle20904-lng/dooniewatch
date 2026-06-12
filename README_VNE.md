# 🕐 Doonie Watch — Shopee Data Analytics

> **⚠️ LƯU Ý QUAN TRỌNG**
> **<span style="color:red">Dữ liệu sử dụng trong dự án này đã được ẩn danh hóa và được dùng với sự cho phép cũng như đồng ý bằng văn bản của chủ cửa hàng.</span>**

---

## 📌 Mục Lục

1. [Bối Cảnh & Vấn Đề](#1-bối-cảnh--vấn-đề)
2. [Quy Trình Thực Hiện](#2-quy-trình-thực-hiện)
3. [Phân Tích Insight Chuyên Sâu](#3-phân-tích-insight-chuyên-sâu)
4. [Kết Quả Đạt Được (Jan 2025 - May 2026)](#4-kết-quả-đạt-được-jan-2025---may-2026)
5. [Giá Trị Thu Được & Bài Học Kinh Nghiệm](#5-giá-trị-thu-được)

---

## 1. Bối Cảnh & Vấn Đề

[**🔗 Báo cáo Power BI Demo**](https://app.powerbi.com/view?r=eyJrIjoiOWFkOGQ5YTgtYjRhMi00YzQ4LThjZTMtM2Q5ZjdhNWExNmMyIiwidCI6ImQ2ZDEzZTBlLTdjYTAtNDNkNC05OTY1LTQyZDM4ZWU1M2RkYSIsImMiOjEwfQ%3D%3D)

### Khách hàng là ai?

Doonie Watch là một cửa hàng bán lẻ đồng hồ đã hoạt động trên sàn Shopee Việt Nam hơn 2 năm. Gian hàng kinh doanh đa dạng các phân khúc từ đồng hồ thời trang, đồng hồ điện tử cho đến dòng cao cấp thuộc nhiều thương hiệu lớn như Casio, Movado, DW, Longines và một số thương hiệu khác.

### Vấn Đề Nan Giải Trước Tháng 1/2025

Trước khi dự án này được triển khai, chủ cửa hàng hoàn toàn không có một hệ thống quản lý dữ liệu bài bản. Nguồn thông tin duy nhất họ tiếp cận được là từ các màn hình tổng hợp dữ liệu mặc định của Shopee. Điều này dẫn đến hàng loạt hệ lụy nghiêm trọng:

*   **Báo cáo doanh thu thiếu nhất quán:** Số liệu không đồng bộ và thiếu độ tin cậy.
*   **Mất kiểm soát tài chính:** Không thể theo dõi được lợi nhuận thực tế, cơ cấu chi phí cũng như biên lợi nhuận của từng dòng sản phẩm.
*   **Vận hành lỏng lẻo:** Tỷ lệ hủy đơn cao ngất ngưởng diễn ra liên tục nhưng hoàn toàn bị ngó lơ do thiếu công cụ giám sát.
*   **Ra quyết định theo cảm tính:** Doanh thu dậm chân tại chỗ ở mức rất thấp do không có chiến lược rõ ràng.
*   **Net Profit Margin gần như bằng 0%** trong nhiều tháng liên tiếp, dù Gross Margin đạt mức rất tốt (67–73%). Nguyên nhân chính là do chi phí marketing vận hành kém hiệu quả, "ngốn" sạch lợi nhuận.
*   **Retention Rate chạm đáy 0%** trên tất cả các tỉnh thành. Cửa hàng hoàn toàn không có khách hàng quay lại và cũng không triển khai bất kỳ chiến lược giữ chân nào.
*   **Conversion Rate chỉ đạt vỏn vẹn 1.23%:** Nhận tới 25.920 lượt click nhưng chỉ chuyển đổi thành công 320 đơn hàng hoàn thành.
*   **Cancellation Rate duy trì ở mức báo động (20–30%)** suốt 8 tháng liên tục. Đáng chú ý, dòng thương hiệu Longines có tỷ lệ hủy tiệm cận 100%, đồng thời xuất hiện nhiều bất thường theo khu vực tỉnh thành và phương thức thanh toán nhưng không được phát hiện kịp thời.
*   **Doanh thu lao dốc 33%** từ tháng 6 đến cuối năm mà không hề có bất kỳ chẩn đoán nguyên nhân hay hành động khắc phục nào.

![image alt](https://github.com/nle20904-lng/Doonie_Watch_Analytics_Projects_NLE/blob/main/images/before2025_1.png)

![image alt](https://github.com/nle20904-lng/Doonie_Watch_Analytics_Projects_NLE/blob/main/images/before2025_2.png)

![image alt](https://github.com/nle20904-lng/Doonie_Watch_Analytics_Projects_NLE/blob/main/images/before2025_3.png)

![image alt](https://github.com/nle20904-lng/Doonie_Watch_Analytics_Projects_NLE/blob/main/images/before2025_4.png)

### Kỳ Vọng Của Chủ Cửa Hàng

Chủ cửa hàng cần một giải pháp vượt trội hơn các báo cáo mặc định của Shopee, cụ thể là:
*   Một góc nhìn toàn diện và trực quan về hiệu quả kinh doanh dựa trên 4 trụ cột cốt lõi: Doanh thu, Lợi nhuận, Khách hàng và Quản trị rủi ro.
*   Khả năng đào sâu (drill-down) để tìm ra nguyên nhân gốc rễ của vấn đề ngay khi có bất thường phát sinh.
*   Một hạ tầng dữ liệu bài bản, vững chắc và có khả năng mở rộng linh hoạt thay vì các bảng tính Excel xử lý thủ công từng lần.

### Vai Trò Của Tôi — Trách Nhiệm Song Hành

Tôi tham gia vào dự án với tư cách là **Freelance Data Analyst**, đảm nhận song song hai vai trò chuyên môn:

| Vai trò | Trách nhiệm chính |
|---|---|
| **Data BI Analyst** | Xây dựng hạ tầng dữ liệu toàn diện (end-to-end): Chuẩn hóa dữ liệu thô đầu vào (Python), thiết kế mô hình cơ sở dữ liệu PostgreSQL (Star Schema), thiết lập hệ thống pipeline bằng stored procedure và phát triển 4 báo cáo Power BI tương tác chuyên sâu (bao gồm P&L, Phân tích khách hàng, Traffic/Conversion và Quản lý rủi ro). |
| **Digital Marketing Analyst** | Phân tích sâu dữ liệu traffic và conversion trên Shopee nhằm bóc tách các chiến dịch kém hiệu quả; tối ưu hóa ngân sách quảng cáo theo từng thương hiệu và danh mục sản phẩm; lập bản đồ hành trình từ CTR đến Conversion theo thương hiệu và đưa ra các khuyến nghị tối ưu hiệu suất marketing hàng tháng. |

### Các Sản Phẩm Dashboard Đầu Ra

Hệ thống gồm 4 dashboard Power BI tương tác được thiết kế chuyên biệt để giải quyết từng bài toán kinh doanh cốt lõi:

| Dashboard | Mục tiêu kinh doanh | Chỉ số cốt lõi (Key Metrics) |
|---|---|---|
| 📊 **P&L Tracking** | Tối ưu hóa năng lực sinh lời | Revenue, GPM, NPM, Operating Expense Structure |
| 👥 **Customer Analytics** | Phát triển tệp khách hàng và thúc đẩy tái mua | New vs Returning, Retention Rate, Geographic Breakdown |
| 🛒 **Traffic & Conversion** | Tối đa hóa chỉ số ROI marketing | Views, CTR, Conversion Rate, Brand Performance Matrix |
| ⚠️ **Risk Management** | Kiểm soát và giảm thiểu tổn thất vận hành | Cancellation Rate, Return Rate, Risk by Payment Method & City |

---

## 2. Quy Trình Thực Hiện

### 2.1 Luồng Xử Lý Dữ Liệu (Data Workflows)

![image alt](https://github.com/nle20904-lng/Doonie_Watch_Analytics_Projects_NLE/blob/main/images/workflow.png)

### 2.2 Dữ Liệu Đầu Vào (Input Data)

Xem chi tiết định nghĩa các trường dữ liệu tại → [`data dictionary/data_dictionary_input.md`](./data%20dictionary/data_dictionary_input.md)

![image alt](https://github.com/nle20904-lng/Doonie_Watch_Analytics_Projects_NLE/blob/main/images/input_dictionary.jpg)

| Tên File | Số Cột | Nội Dung Chi Tiết |
|---|---|---|
| `Order_all_YYYYMMDD.xlsx` | 62 | Thông tin đơn hàng, giá bán, chi phí vận chuyển, phương thức thanh toán, địa chỉ người mua và các loại phí nền tảng. |
| `parentskudetail_YYYYMMDD.xlsx` | 40 | Dữ liệu về lượt xem, lượt click, chỉ số CTR, tỷ lệ chuyển đổi, tỷ lệ thêm vào giỏ hàng và chỉ số tái mua. |

### 2.3 Dữ Liệu Đầu Ra (Output Data)

Xem chi tiết từ điển dữ liệu đầu ra tại → [`data dictionary/data_dictionary_output.md`](./data%20dictionary/data_dictionary_output.md)

Sơ đồ cấu trúc Database (DB Diagrams):
![image alt](https://github.com/nle20904-lng/Doonie_Watch_Analytics_Projects_NLE/blob/main/images/DB_Diagrams.png)

---
![image alt](https://github.com/nle20904-lng/Doonie_Watch_Analytics_Projects_NLE/blob/main/images/output_dictionary.jpg)

![image alt](https://github.com/nle20904-lng/Doonie_Watch_Analytics_Projects_NLE/blob/main/images/dashboard_dictionary.jpg)

### 2.4 Thủ Tục Lưu Trữ (Stored Procedures)

Hệ thống vận hành dựa trên 3 procedure được gọi tuần tự định kỳ mỗi tháng:

```sql
call stg.prc_update_status_fact_txn_orders();  -- upsert raw orders + product performance
call stg.prc_insert_dim_tables();              -- rebuild all 20 dimension tables
call stg.prc_insert_fact_tables();             -- compute all 10 fact tables
```

| # | Procedure | Purpose |
|---|---|---|
| 01 | `prc_update_status_fact_txn_orders` | Upsert đơn hàng mới và cập nhật thay đổi trạng thái. Merge dữ liệu hiệu suất sản phẩm qua MERGE. |
| 02 | `prc_insert_dim_tables` | Xây dựng lại toàn bộ 20 dimension table — thương hiệu, danh mục, phân loại, khách hàng, địa lý, ngày tháng, chiến dịch, mã dòng P&L. |
| 03 | `prc_insert_fact_tables` | Tính toán toàn bộ 10 fact table — P&L theo ngày/tháng, chỉ số khách hàng (pipeline 12 CTE), risk spine (13 metrics × tất cả dimension). |
 
### 2.5 Dashboard
 
## P&L Tracking
 
Report này tái hiện cấu trúc P&L chuẩn theo từng tháng, giúp team thấy rõ doanh thu đến từ đâu, lớp chi phí nào đang ăn vào lợi nhuận, và biên lợi nhuận thực tế đang ở mức nào so với các kỳ trước.
 
**Revenue & Cost of Goods**
- Total Revenue — doanh thu thuần từ các đơn hoàn thành trong tháng, kèm tăng trưởng MoM
- Total Unit Cost — tổng giá vốn hàng bán, phản ánh Gross Profit Margin (GPM)
**Operating Expenses (OpEx)**
- Platform Fee — phí nền tảng Shopee
- Shipping Fee — chi phí vận chuyển
- Marketing Fee — chi phí quảng cáo nội sàn
- Tax Fee — thuế áp dụng
**Profitability**
- Net Profit — lợi nhuận cuối cùng sau toàn bộ chi phí, kèm tăng trưởng MoM
- Gross Profit Margin (%) và Net Profit Margin (%) theo dõi từng tháng
Report này cho phép team ngay lập tức phát hiện những tháng gross margin giữ nguyên nhưng net margin thu hẹp do phí nền tảng tăng, hoặc những tháng doanh thu tăng nhưng lợi nhuận không theo vì chi phí vận hành vượt ngưỡng.
 
![image alt](https://github.com/nle20904-lng/Doonie_Watch_Analytics_Projects_NLE/blob/main/images/p%26l_dashboard.png)
 
---
 
## Customer Acquisition & Retention
 
Report này theo dõi chất lượng tệp khách hàng — không chỉ đếm số lượng, mà phân tách rõ ràng giữa khách mới và khách quay lại — để đánh giá hiệu quả thu hút và mức độ trung thành của người mua.
 
**Overview Metrics**
- Total Customers — tổng số khách hàng trong tháng
- New Customers — người mua lần đầu, kèm tăng trưởng MoM
- Returning Customers — người mua quay lại, kèm tăng trưởng MoM
- Retention Rate (%) — so sánh với trung bình năm
**Detailed Breakdown**
- Xu hướng New vs. Returning theo tháng
- Tốc độ tăng trưởng khách mới MoM% — làm nổi bật các tháng tốc độ thu hút khách đang chậm lại
- Phân tách theo thành phố — New Customer Rate và Retention Rate theo tỉnh/thành phố
Qua report này, team có thể quan sát thấy retention đang ở mức thấp (~4–9%), nghĩa là phần lớn khách chỉ mua một lần, từ đó đặt ra câu hỏi có nên ưu tiên giữ chân khách hiện hữu hay tiếp tục đầu tư vào thu hút khách mới.
 
![image alt](https://github.com/nle20904-lng/Doonie_Watch_Analytics_Projects_NLE/blob/main/images/customer_accquisition_dashboard.png)
 
---
 
## Traffic & Conversion Performance
 
Report này theo dõi toàn bộ phễu từ lượt hiển thị sản phẩm đến đơn hàng hoàn thành, xác định chính xác bước nào trong hành trình mua hàng đang gây ra tỷ lệ rớt lớn nhất.
 
**Funnel Metrics**
- Views — tổng lượt hiển thị sản phẩm, kèm thay đổi MoM
- Clicks — lượng click sản phẩm và Click-Through Rate (CTR), kèm thay đổi MoM
- Add To Cart — lượt thêm vào giỏ hàng, kèm thay đổi MoM
- Completed Orders — đơn hàng hoàn thành, kèm thay đổi MoM và Conversion Rate tổng thể
**Deep-Dive Analysis**
- Drop-off Funnel — tỷ lệ rớt từng bước: từ 7.067 click xuống 887 lượt thêm giỏ hàng (12.55%) xuống 111 đơn hoàn thành (1.57%)
- Phân bổ traffic theo danh mục sản phẩm — danh mục nào đang tạo ra lượng traffic lớn nhất
- Brand Matrix (CTR vs. Conversion Rate) — xác định thương hiệu có traffic cao nhưng conversion yếu, và ngược lại
Report này cho team biết chính xác vấn đề nằm ở đâu — CTR thấp chỉ ra hình ảnh và tiêu đề sản phẩm cần cải thiện; add-to-cart cao nhưng conversion thấp gợi ý có vấn đề ở bước thanh toán hoặc về giá.
 
![image alt](https://github.com/nle20904-lng/Doonie_Watch_Analytics_Projects_NLE/blob/main/images/traffic_conversion_dashboard.png)
 
---
 
## Order Fulfillment Risk & Loss Management
 
Report này giám sát các rủi ro sau đặt hàng — hủy đơn và hoàn trả — và phân tích chúng theo nhiều chiều để xác định sản phẩm, phương thức thanh toán hay khu vực nào đang gây ra tổn thất doanh thu lớn nhất.
 
**Overview Metrics**
- Canceled Orders — số lượng hủy đơn và Cancellation Rate (%), so chuẩn với trung bình năm
- Returned Orders — số lượng hoàn trả và Returned Order Rate (%), so chuẩn với trung bình năm
**Detailed Breakdown**
- Fulfillment Risk Trend — xu hướng tỷ lệ hủy đơn và hoàn trả theo thời gian, vẽ cùng với tổng khối lượng đơn hàng
- Phân tách theo danh mục sản phẩm — danh mục nào có tỷ lệ hủy hoặc hoàn trả bất thường cao
- Brand Performance Risk Matrix — biểu đồ scatter xác định thương hiệu có cả tỷ lệ hủy lẫn tỷ lệ hoàn trả cao cùng lúc
- Order Vulnerability by Payment Method — phương thức thanh toán nào (COD, SPayLater, v.v.) gắn liền với tỷ lệ hủy đơn cao nhất
- Phân bổ theo thành phố — khu vực nào liên tục vượt mức tỷ lệ hủy trung bình
Thay vì chỉ báo cáo số đơn bị hủy, dashboard này giúp team hiểu nguyên nhân gốc rễ — ví dụ, COD chiếm tỷ trọng lớn nhất trong các đơn hủy gợi ý cần xem lại chính sách thanh toán, trong khi tỷ lệ hoàn trả bất thường cao ở một danh mục cụ thể có thể chỉ ra vấn đề chất lượng sản phẩm hoặc mô tả sản phẩm không trung thực.
 
![image alt](https://github.com/nle20904-lng/Doonie_Watch_Analytics_Projects_NLE/blob/main/images/risk_management.png)
 
---
 
## 3. Phân Tích Insight Chuyên Sâu
 
### 🔴 COD là nguồn thất thoát doanh thu số 1
 
COD = ~70% đơn hàng nhưng tỷ lệ hủy 26.6% — cao gấp 3× so với thanh toán trước. 320 đơn bị hủy trong tháng 5/2026. Return rate ở mức 2.05% với xu hướng tăng MoM. Tập trung ở Cà Mau và Vĩnh Long (thời gian giao hàng dài hơn làm tăng rủi ro hủy đơn).
 
![image alt](https://github.com/nle20904-lng/Doonie_Watch_Analytics_Projects_NLE/blob/main/images/insight1.png)
 
**Hành động →** Chiến dịch voucher để chuyển người mua COD sang ShopeePay. Mục tiêu: giảm tỷ trọng COD từ 70% xuống 55% trong 3 tháng. Tạm dừng paid acquisition tại Cà Mau/Vĩnh Long cho đến khi xác minh COD được triển khai.
 
---
 
### 🟡 Phí nền tảng là trần biên lợi nhuận
 
Platform fees = 80.7% opex. Tổng doanh thu 344.9M nhưng lợi nhuận ròng chỉ 70.1M (~20% net margin). Sự thu hẹp biên lợi nhuận gắn trực tiếp với quyết định chi tiêu quảng cáo, không phải vấn đề sản phẩm.
 
![image alt](https://github.com/nle20904-lng/Doonie_Watch_Analytics_Projects_NLE/blob/main/images/insight2.png)
 
**Hành động →** Kiểm toán chiến dịch hàng tháng — tạm dừng các quảng cáo có CTR-to-conversion dưới trung bình, phân bổ lại ngân sách cho Casio.
 
---
 
### 🟢 Casio có chu kỳ conversion gắn liền với nghĩa vụ quân sự
 
Casio (đồng hồ điện tử) tăng đột biến conversion rate vào tháng 9 (công bố danh sách nhập ngũ) và tháng 2 (sau Tết / đợt nhập ngũ). Đây là các tín hiệu cầu có thể dự báo trước — ngân sách cần được chuẩn bị trước 4–6 tuần. Ngược lại, tháng 4–8 có lượt xem cao nhưng conversion yếu dù traffic lớn.
 
![image alt](https://github.com/nle20904-lng/Doonie_Watch_Analytics_Projects_NLE/blob/main/images/insight3.png)
 
**Hành động →** Tăng ngân sách quảng cáo Casio 20–30% bắt đầu từ tháng 8 và tháng 1. Giai đoạn tháng 4–8: giảm bid Casio, chuyển ngân sách sang đồng hồ thời trang để chuẩn bị cho mùa cao điểm cuối năm.
 
---
 
### 🔵 Đồng hồ thời trang chỉ convert tốt vào mùa quà tặng, yếu giữa năm
 
Đồng hồ thời trang (DW, Longines, Movado) chỉ convert tốt trong các giai đoạn nhu cầu quà tặng cao: cuối năm, Tết, Valentine's Day, Ngày Phụ Nữ (8/3). Tháng 4–8: traffic cao nhưng conversion thấp — người dùng đang lướt xem mà không có ý định mua. DW cụ thể cho thấy khoảng cách CTR-to-conversion gợi ý vấn đề về giá hoặc niềm tin.
 
![image alt](https://github.com/nle20904-lng/Doonie_Watch_Analytics_Projects_NLE/blob/main/images/insight4.png)
 
**Hành động →** Tháng 4–8: chuyển sang content nurturing (danh sách yêu thích, đánh giá) thay vì quảng cáo conversion. A/B test DW trước mùa cao điểm cuối năm: price anchor vs bundle offer.
 
---
 
### 🟢 Khách quay lại đang tăng; Đồng Nai là thị trường tiếp theo cần thử nghiệm
 
Returning customers tăng +233% MoM. Retention đạt 9.26% tháng 5/2026 — tăng so với mức trung bình YTD 4.45%. Lượng khách hàng tăng đột biến rõ rệt quanh Tết, dịp lễ cuối năm và một cửa sổ tái mua giữa năm. Tập trung tại HCMC (~85% khách hàng) = rủi ro phụ thuộc một thị trường. Đồng Nai thể hiện nhu cầu organic mà không có chi tiêu marketing nào.
 
![image alt](https://github.com/nle20904-lng/Doonie_Watch_Analytics_Projects_NLE/blob/main/images/insight5.png)
 
**Hành động →** Chạy thử nghiệm paid acquisition nhỏ tại Đồng Nai trước mùa cao điểm cuối năm. Chuỗi post-purchase: D+3 yêu cầu đánh giá → D+30 voucher phụ kiện → D+60 re-engagement.
 
---
 
## 4. Kết Quả Đạt Được (Jan 2025 - May 2026)
 
| Metric | Result |
|---|---|
| Monthly revenue run-rate | **+311%** (83.8M → 345M VND/tháng) |
| Net profit margin | **~7% → ~20%** |
| Monthly new customers | **+468%** (280 → 1.590/tháng đỉnh điểm) |
| Unique customers tracked | **19.790** |
| Cancellation rate | **24% → 21.9%** (xu hướng giảm) |
| 2025 total revenue processed | **2,70 tỷ+ VND** |
 
---
 
## 5. Giá Trị Thu Được
 
**Domain:** Thương mại điện tử Việt Nam & đặc thù COD · Cơ cấu phí và loại hình chiến dịch Shopee · Phân loại sản phẩm đồng hồ · Benchmark retention cho hàng hóa vật lý
 
**Technical:** Python ETL (pandas, openpyxl, sqlalchemy) · PostgreSQL Star Schema + SCD cost history · SQL CTEs / MERGE / window functions · Power BI DAX (MoM %, composite KPI score)
 
**Bài học rút ra:**
- Hạ tầng trước, insight sau — pipeline 3 procedure là đòn bẩy then chốt
- CTR đơn thuần vô nghĩa nếu không có bối cảnh cancellation rate (BI + Marketing liên miền)
- Rủi ro COD cần giải pháp vận hành, không phải thêm phân tích
- Benchmark retention cho hàng hóa vật lý cần khung tham chiếu riêng — 9% không nhất thiết là xấu
---
 
## Tools & Tech Stack
 
| Layer | Tool |
|---|---|
| Data Ingestion | Python — pandas, openpyxl, sqlalchemy |
| Database | PostgreSQL — Star Schema, 3 stored procedures |
| Visualization | Power BI Desktop — Import Mode, DAX |
| Marketing Analytics | Power BI + SQL — CTR/conversion matrix, campaign ROI |
 

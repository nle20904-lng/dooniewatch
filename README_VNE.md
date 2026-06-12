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

**🔗 Báo cáo mẫu (Demo):** *(link to Power BI report)*

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

Tôi tham gia vào dự án với tư cách là **Freelance Data Consultant (Cố vấn dữ liệu độc lập)**, đảm nhận song song hai vai trò chuyên môn:

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

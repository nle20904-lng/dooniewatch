# Data Dictionary — Input (Raw Shopee Exports)

> This document describes the raw data sources exported directly from the Shopee Seller Center before any transformation or cleaning.  
> Data has been masked and used with the permission of the shop owner.

---

## Source Files

| File Name | Description | Period |
|---|---|---|
| `Order_all_YYYYMMDD_YYYYMMDD.xlsx` | Full order-level transaction export from Shopee | Rolling monthly (e.g. Apr–May 2026) |
| `parentskudetail_YYYYMMDD_YYYYMMDD.xlsx` | Product & variant performance metrics from Shopee Analytics | Rolling monthly (e.g. May 2026) |

---

## Table 1: `orders` (Sheet: `orders` in Order export)

**Source:** Shopee Seller Center → Order Management → Export Orders  
**Grain:** One row per order line item (a single order may appear on multiple rows if it contains multiple SKUs)

| # | Column (Vietnamese) | English Translation | Data Type | Sample Value | Description |
|---|---|---|---|---|---|
| 1 | `Mã đơn hàng` | Order ID | VARCHAR | `260401KW474ETA` | Unique identifier for each Shopee order |
| 2 | `Mã Kiện Hàng` | Package ID | VARCHAR | `5929536478965248905` | Logistics package identifier; may be null for cancelled orders |
| 3 | `Ngày đặt hàng` | Order Date | DATETIME | `2026-04-01 02:22` | Timestamp when the order was placed by the buyer |
| 4 | `Trạng Thái Đơn Hàng` | Order Status | VARCHAR | `Hoàn thành`, `Đã hủy` | Final status of the order: Completed, Cancelled, Returned |
| 5 | `Sản Phẩm Bán Chạy` | Bestseller Flag | VARCHAR | `N`, `Y` | Whether the product was tagged as bestseller at time of order |
| 6 | `Lý do hủy` | Cancellation Reason | VARCHAR | `Hủy bởi người mua lí do là: Lý do khác` | Free-text reason string for cancelled orders; null for completed orders |
| 7 | `Nhận xét từ Người mua` | Buyer Note | VARCHAR | (free text) | Optional message from buyer at checkout |
| 8 | `Mã vận đơn` | Tracking Number | VARCHAR | `SPXVN060426037184` | Carrier tracking code; null if order was cancelled before shipment |
| 9 | `Đơn Vị Vận Chuyển` | Carrier | VARCHAR | `Nhanh-SPX Express`, `Hỏa Tốc-SPX Instant` | Shipping carrier and service tier |
| 10 | `Phương thức giao hàng` | Delivery Method | VARCHAR | `Mang hàng tới Bưu cục`, `Sắp xếp lấy hàng` | Drop-off at post office vs. seller schedules pickup |
| 11 | `Loại đơn hàng` | Order Type | VARCHAR | (often null) | Order type classification (standard, flash sale, etc.) |
| 12 | `Ngày giao hàng dự kiến` | Expected Delivery Date | DATETIME | `2026-04-01 23:59` | Shopee's estimated delivery deadline |
| 13 | `Ngày gửi hàng` | Shipment Date | DATETIME | `2026-04-04 16:00` | Date the seller handed the package to the carrier |
| 14 | `Thời gian giao hàng` | Actual Delivery Time | DATETIME | `2026-04-02 14:41` | Timestamp of successful delivery to buyer |
| 15 | `Trạng thái Trả hàng/Hoàn tiền` | Return/Refund Status | VARCHAR | `Đã Chấp Thuận Yêu Cầu` | Return request status; null if no return was initiated |
| 16 | `SKU sản phẩm` | Parent SKU | VARCHAR | `DH-WRO-001` | Seller-defined parent product SKU code |
| 17 | `Tên sản phẩm` | Product Name | VARCHAR | `Đồng Hồ WRO6 Thời Trang...` | Full product listing title on Shopee |
| 18 | `Cân nặng sản phẩm` | Product Weight (kg) | NUMERIC | `0.020` | Weight per unit in kilograms |
| 19 | `Tổng cân nặng` | Total Weight (kg) | NUMERIC | `0.040` | Total weight = product weight × quantity |
| 20 | `SKU phân loại hàng` | Variant SKU | VARCHAR | `DH-WRO-001-BAC-NAM32` | Seller-defined SKU for the specific variant ordered |
| 21 | `Tên phân loại hàng` | Variant Name | VARCHAR | `Bạc,Nam - 32 mm` | Variant label combining color and size |
| 22 | `Giá gốc` | Original Price (VND) | NUMERIC | `165000.00` | Listed price before any discounts |
| 23 | `Người bán trợ giá` | Seller Discount | NUMERIC | `5000.00` | Discount amount funded by the seller |
| 24 | `Được Shopee trợ giá` | Shopee Discount | NUMERIC | `0.00` | Discount amount subsidized by Shopee |
| 25 | `Tổng số tiền được người bán trợ giá` | Total Seller Subsidy | NUMERIC | `0.00` | Total value of seller-funded promotion |
| 26 | `Giá ưu đãi` | Discounted Price (VND) | NUMERIC | `165000.00` | Final unit price after discounts applied |
| 27 | `Số lượng` | Quantity Ordered | INTEGER | `1`, `2` | Number of units purchased |
| 28 | `Số lượng sản phẩm được hoàn trả` | Quantity Returned | INTEGER | `0`, `1` | Units returned by the buyer |
| 29 | `Tổng số tiền Người mua thanh toán` | Buyer Total Payment (VND) | NUMERIC | `165000.00` | Gross amount charged to the buyer |
| 30 | `Tổng giá trị đơn hàng (VND)` | Order Net Value (VND) | NUMERIC | `134050.00` | Net revenue received by the seller after Shopee deductions |
| 31 | `Mã giảm giá của Shop` | Shop Voucher Code | VARCHAR | (code or null) | Voucher code used, if any |
| 32 | `Hoàn Xu` | Shopee Coins Earned | NUMERIC | `29` | Coins awarded to buyer |
| 33 | `Mã giảm giá của Shopee` | Shopee Voucher | NUMERIC | `28050.00` | Shopee-funded voucher deduction |
| 34 | `Chỉ tiêu Combo Khuyến Mãi` | Combo Target Flag | VARCHAR | `N` | Whether this order is part of a combo promotion |
| 35 | `Giảm giá từ combo Shopee` | Shopee Combo Discount | NUMERIC | `0.00` | |
| 36 | `Giảm giá từ Combo của Shop` | Shop Combo Discount | NUMERIC | `0.00` | |
| 37 | `Shopee Xu được hoàn` | Shopee Coins Refunded | NUMERIC | `0` | |
| 38 | `Số tiền được giảm khi thanh toán bằng thẻ Ghi nợ` | Debit Card Discount | NUMERIC | `0.00` | |
| 39 | `Trade-in Discount` | Trade-in Discount | NUMERIC | `0.00` | |
| 40 | `Trade-in Bonus` | Trade-in Bonus | NUMERIC | `0.00` | |
| 41 | `Phí vận chuyển (dự kiến)` | Estimated Shipping Fee | NUMERIC | `37300.00` | Estimated carrier fee charged to the order |
| 42 | `Trade-in Bonus by Seller` | Trade-in Bonus by Seller | NUMERIC | `0.00` | |
| 43 | `Phí vận chuyển mà người mua trả` | Buyer-paid Shipping | NUMERIC | `0.00` | Shipping portion paid by buyer |
| 44 | `Phí vận chuyển tài trợ bởi Shopee (dự kiến)` | Shopee-subsidized Shipping | NUMERIC | `37300.00` | Portion of shipping fee subsidized by Shopee |
| 45 | `Phí vận chuyển trả hàng (đơn Trả hàng/hoàn tiền)` | Return Shipping Fee | NUMERIC | `0.00` | Shipping fee for returned orders |
| 46 | `Tổng số tiền người mua thanh toán` | Total Buyer Payment (VND) | NUMERIC | `134050.00` | Final amount debited from buyer's account |
| 47 | `Thời gian hoàn thành đơn hàng` | Order Completion Time | DATETIME | `2026-04-07 07:26` | When order status changed to "Completed" |
| 48 | `Thời gian đơn hàng được thanh toán` | Payment Timestamp | DATETIME | `2026-04-01 09:16` | When payment was confirmed |
| 49 | `Phương thức thanh toán` | Payment Method | VARCHAR | `Thanh toán khi nhận hàng`, `SPayLater`, `TK Ngân hàng liên kết ShopeePay`, `Ví ShopeePay`, `Thẻ Tín dụng/Ghi nợ`, `Apple Pay`, `Google Pay` | Buyer's payment method |
| 50 | `Phí cố định` | Fixed Platform Fee | NUMERIC | `20625.00` | Fixed fee charged by Shopee per transaction |
| 51 | `Phí Dịch Vụ` | Service Fee | NUMERIC | `0.00` | Additional service charge |
| 52 | `Phí xử lý giao dịch` | Transaction Processing Fee | NUMERIC | `0.00` | Payment gateway fee |
| 53 | `Tiền ký quỹ` | Deposit/Escrow | NUMERIC | `0.00` | |
| 54 | `Người Mua` | Buyer Username | VARCHAR | (masked) | Shopee username of the buyer |
| 55 | `Tên Người nhận` | Recipient Name | VARCHAR | (masked) | Full name of the delivery recipient |
| 56 | `Số điện thoại` | Phone Number | VARCHAR | (masked) | Contact number for delivery |
| 57 | `Tỉnh/Thành phố` | Province/City | VARCHAR | `TP. Hồ Chí Minh`, `Tỉnh Đồng Nai` | Delivery province or city |
| 58 | `TP / Quận / Huyện` | District | VARCHAR | `Quận 1` | Sub-district of delivery address |
| 59 | `Quận` | Ward | VARCHAR | (varies) | Ward-level address detail |
| 60 | `Địa chỉ nhận hàng` | Delivery Address | VARCHAR | (masked) | Full delivery address string |
| 61 | `Quốc gia` | Country | VARCHAR | `VN` | Always "VN" for Vietnam |
| 62 | `Ghi chú` | Internal Note | VARCHAR | (free text or null) | Seller's internal order note |

---

## Table 2: `parentskudetail` (Sheet: `Sản Phẩm Hiệu Quả Tốt`)

**Source:** Shopee Seller Center → Shopee Analytics → Product Performance Export  
**Grain:** One row per product variant; aggregated product-level rows included (where `Mã phân loại hàng` is null)

| # | Column (Vietnamese) | English Translation | Data Type | Sample Value | Description |
|---|---|---|---|---|---|
| 1 | `Mã sản phẩm` | Product ID | BIGINT | `21487599009` | Shopee's internal numeric product ID |
| 2 | `Sản phẩm` | Product Name | VARCHAR | `Đồng Hồ MVD Thời Trang...` | Full product listing title |
| 3 | `Tình trạng sản phẩm hiện tại` | Product Status | VARCHAR | `Đang hoạt động` | Active / Inactive / Banned |
| 4 | `Mã phân loại hàng` | Variant ID | BIGINT | `196262506388` | Shopee's numeric variant identifier; null for parent-level rows |
| 5 | `Tên Phân Loại` | Variant Name | VARCHAR | `MVD mặt trắng,Cặp Đôi - 2 Size` | Variant label (color + size combination) |
| 6 | `Trạng thái phân loại sản phẩm hiện tại` | Variant Status | VARCHAR | `Đang hoạt động` | Active / Inactive |
| 7 | `SKU phân loại` | Variant SKU | VARCHAR | `DH-MVD-002-TRANG-DOI` | Seller-assigned SKU for this variant |
| 8 | `SKU sản phẩm` | Parent SKU | VARCHAR | `DH-MVD-002` | Seller-assigned parent product SKU |
| 9 | `Doanh số (Đơn đã đặt) (VND)` | Sales — Placed Orders (VND) | NUMERIC | `15,690,000` | Revenue from all placed orders (including pending) |
| 10 | `Doanh số (Đơn đã xác nhận) (VND)` | Sales — Confirmed Orders (VND) | NUMERIC | `13,652,000` | Revenue from confirmed/completed orders only |
| 11 | `Lượt xem sản phẩm` | Product Views | INTEGER | `34756` | Total times the product page was viewed |
| 12 | `Lượt nhấp vào sản phẩm` | Product Clicks | INTEGER | `1894` | Total clicks on the product listing |
| 13 | `CTR` | Click-Through Rate | PERCENTAGE | `5.45%` | Clicks ÷ Impressions |
| 14 | `Tỷ lệ chuyển đổi đơn (Đơn đã đặt)` | Conversion Rate (Placed) | PERCENTAGE | `1.74%` | Placed orders ÷ Clicks |
| 15 | `Tỷ lệ chuyển đổi đơn (Đơn đã xác nhận)` | Conversion Rate (Confirmed) | PERCENTAGE | `1.58%` | Confirmed orders ÷ Clicks |
| 16 | `Đơn hàng đã đặt` | Orders Placed | INTEGER | `33` | Total number of placed orders |
| 17 | `Đơn đã xác nhận` | Orders Confirmed | INTEGER | `30` | Total confirmed/completed orders |
| 18 | `Sản phẩm (Đơn đã đặt)` | Units Placed | INTEGER | `33` | Units sold in placed orders |
| 19 | `Sản phẩm (Đơn đã xác nhận)` | Units Confirmed | INTEGER | `30` | Units sold in confirmed orders |
| 20 | `Người mua đã đặt hàng` | Unique Buyers (Placed) | INTEGER | `28` | Distinct buyers who placed orders |
| 21 | `Người mua có đơn đã xác nhận` | Unique Buyers (Confirmed) | INTEGER | `27` | Distinct buyers with confirmed orders |
| 22 | `Tỷ lệ chuyển đổi (Đơn đã đặt)` | Buyer Conversion Rate (Placed) | PERCENTAGE | `4.38%` | Unique placing buyers ÷ Unique visitors |
| 23 | `Tỷ lệ chuyển đổi (Đơn đã xác nhận)` | Buyer Conversion Rate (Confirmed) | PERCENTAGE | `4.23%` | Unique confirmed buyers ÷ Unique visitors |
| 24 | `Doanh thu trên mỗi đơn (Đơn đã đặt) (VND)` | Revenue per Placed Order (VND) | NUMERIC | `475,455` | Average order value for placed orders |
| 25 | `Doanh thu trên mỗi đơn (Đơn đã xác nhận) (VND)` | Revenue per Confirmed Order (VND) | NUMERIC | `455,067` | Average order value for confirmed orders |
| 26 | `Lượt hiển thị sản phẩm duy nhất` | Unique Impressions | INTEGER | `10436` | Unique users who saw the product in listings |
| 27 | `Lượt nhấp sản phẩm duy nhất` | Unique Clicks | INTEGER | `690` | Unique users who clicked the product |
| 28 | `Lượt truy cập sản phẩm` | Product Page Visits | INTEGER | `639` | Sessions that reached the product page |
| 29 | `Lượt xem trang sản phẩm` | Product Page Views | INTEGER | `2030` | Total product page views (includes multiple views per session) |
| 30 | `Số lượng khách thoát trang sản phẩm` | Bounces from Product Page | INTEGER | `112` | Visitors who left without interacting |
| 31 | `Tỷ lệ thoát Trang sản phẩm` | Product Page Bounce Rate | PERCENTAGE | `17.53%` | Bounces ÷ Product Page Visits |
| 32 | `Lượt click từ Trang tìm kiếm` | Clicks from Search | INTEGER | `180` | Clicks originating from the Shopee search results page |
| 33 | `Lượt thích` | Product Likes | INTEGER | `4` | Times product was "liked"/saved |
| 34 | `Lượt truy cập sản phẩm (Thêm vào giỏ hàng)` | Add-to-Cart Visits | INTEGER | `112` | Sessions in which the user added to cart |
| 35 | `Sản phẩm (Thêm vào giỏ hàng)` | Units Added to Cart | INTEGER | `280` | Total units added to cart |
| 36 | `Tỷ lệ chuyển đổi (theo lượt thêm vào giỏ hàng)` | Add-to-Cart Conversion Rate | PERCENTAGE | `17.53%` | Add-to-cart sessions ÷ Product page visits |
| 37 | `Tỷ lệ mua lại (Đơn đã đặt)` | Repeat Purchase Rate (Placed) | PERCENTAGE | `15.15%` | Buyers who placed more than one order |
| 38 | `Tỷ lệ đặt hàng lặp lại (Đơn hàng đã được xác nhận)` | Repeat Order Rate (Confirmed) | PERCENTAGE | `10.00%` | Repeat orders ÷ Total confirmed orders |
| 39 | `Số ngày trung bình mà Người mua quay lại đặt hàng (Đơn đã đặt)` | Avg Days to Repeat Purchase (Placed) | INTEGER | `0` | Average days between first and second order |
| 40 | `Số ngày trung bình để lặp lại đơn hàng (Đơn hàng đã được xác nhận)` | Avg Days to Repeat Order (Confirmed) | INTEGER | `0` | Average days between confirmed repeat orders |

---

## Additional Sheets in `parentskudetail`

| Sheet Name | Description |
|---|---|
| `Sản Phẩm Hiệu Quả Tốt` | High-performing products (used as primary input) |
| `Sản Phẩm Mới` | Newly listed products |
| `Giá không cạnh tranh` | Products flagged as non-competitive in price |
| `Giá cạnh tranh` | Products with competitive pricing |
| `Tăng trưởng cùng DVHT` | Products with supported growth |
| `Tối ưu chiến dịch DVHT` | Products with campaign optimization suggestions |
| `Theo dõi hiệu quả chiến dịch` | Campaign performance tracking |

---

## Known Data Quality Issues

| Issue | Description | Handling |
|---|---|---|
| **Null Package IDs** | Cancelled orders before pickup have no `Mã Kiện Hàng` | Set to NULL; excluded from delivery analytics |
| **Inconsistent Order Status** | Status values change format across Shopee export versions | Standardized via mapping table in ingestion script |
| **Cancellation Reason Free Text** | `Lý do hủy` is unstructured; contains embedded reason tags | Regex parsed to extract structured cancel reason and actor (buyer/system/seller) |
| **Duplicate Order Rows** | Orders with multiple SKUs may appear on multiple rows with same `Mã đơn hàng` | Deduplicated at ingestion; order-level aggregation handled in fact table |
| **Mixed Numeric Formats** | `parentskudetail` uses Vietnamese number formatting (`15.690.000`) and percentage strings (`5.45%`) | Cleaned to floats during ETL |
| **Parent vs Variant Rows** | `parentskudetail` mixes parent-level summary rows (null variant ID) with variant-level detail rows | Filtered and separated during modeling |
| **Non-unique Customer IDs** | `Người Mua` (buyer username) is not unique across export periods without consistent key generation | Custom `key_customer_id` generated via hashing |

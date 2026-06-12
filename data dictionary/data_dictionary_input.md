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

| # | Column | Data Type | Sample Value | Description |
|---|---|---|---|---|
| 1 | `order_id` | VARCHAR | `260401KW474ETA` | Unique identifier for each Shopee order |
| 2 | `package_id` | VARCHAR | `5929536478965248905` | Logistics package identifier; may be null for cancelled orders |
| 3 | `order_date` | DATETIME | `2026-04-01 02:22` | Timestamp when the order was placed by the buyer |
| 4 | `order_status` | VARCHAR | `Completed`, `Cancelled` | Final status of the order: Completed, Cancelled, Returned |
| 5 | `bestseller_flag` | VARCHAR | `N`, `Y` | Whether the product was tagged as bestseller at time of order |
| 6 | `cancellation_reason` | VARCHAR | `Cancelled by buyer: Other reason` | Free-text reason string for cancelled orders; null for completed orders |
| 7 | `buyer_note` | VARCHAR | (free text) | Optional message from buyer at checkout |
| 8 | `tracking_number` | VARCHAR | `SPXVN060426037184` | Carrier tracking code; null if order was cancelled before shipment |
| 9 | `carrier` | VARCHAR | `Express-SPX Express`, `Instant-SPX Instant` | Shipping carrier and service tier |
| 10 | `delivery_method` | VARCHAR | `Drop-off at Post Office`, `Schedule Pickup` | Drop-off at post office vs. seller schedules pickup |
| 11 | `order_type` | VARCHAR | (often null) | Order type classification (standard, flash sale, etc.) |
| 12 | `expected_delivery_date` | DATETIME | `2026-04-01 23:59` | Shopee's estimated delivery deadline |
| 13 | `shipment_date` | DATETIME | `2026-04-04 16:00` | Date the seller handed the package to the carrier |
| 14 | `actual_delivery_time` | DATETIME | `2026-04-02 14:41` | Timestamp of successful delivery to buyer |
| 15 | `return_refund_status` | VARCHAR | `Request Approved` | Return request status; null if no return was initiated |
| 16 | `parent_sku` | VARCHAR | `DH-WRO-001` | Seller-defined parent product SKU code |
| 17 | `product_name` | VARCHAR | `WRO6 Fashion Watch...` | Full product listing title on Shopee |
| 18 | `product_weight_kg` | NUMERIC | `0.020` | Weight per unit in kilograms |
| 19 | `total_weight_kg` | NUMERIC | `0.040` | Total weight = product weight × quantity |
| 20 | `variant_sku` | VARCHAR | `DH-WRO-001-BAC-NAM32` | Seller-defined SKU for the specific variant ordered |
| 21 | `variant_name` | VARCHAR | `Silver, Men - 32 mm` | Variant label combining color and size |
| 22 | `original_price_vnd` | NUMERIC | `165000.00` | Listed price before any discounts |
| 23 | `seller_discount` | NUMERIC | `5000.00` | Discount amount funded by the seller |
| 24 | `shopee_discount` | NUMERIC | `0.00` | Discount amount subsidized by Shopee |
| 25 | `total_seller_subsidy` | NUMERIC | `0.00` | Total value of seller-funded promotion |
| 26 | `discounted_price_vnd` | NUMERIC | `165000.00` | Final unit price after discounts applied |
| 27 | `quantity_ordered` | INTEGER | `1`, `2` | Number of units purchased |
| 28 | `quantity_returned` | INTEGER | `0`, `1` | Units returned by the buyer |
| 29 | `buyer_total_payment_vnd` | NUMERIC | `165000.00` | Gross amount charged to the buyer |
| 30 | `order_net_value_vnd` | NUMERIC | `134050.00` | Net revenue received by the seller after Shopee deductions |
| 31 | `shop_voucher_code` | VARCHAR | (code or null) | Voucher code used, if any |
| 32 | `shopee_coins_earned` | NUMERIC | `29` | Coins awarded to buyer |
| 33 | `shopee_voucher` | NUMERIC | `28050.00` | Shopee-funded voucher deduction |
| 34 | `combo_target_flag` | VARCHAR | `N` | Whether this order is part of a combo promotion |
| 35 | `shopee_combo_discount` | NUMERIC | `0.00` | |
| 36 | `shop_combo_discount` | NUMERIC | `0.00` | |
| 37 | `shopee_coins_refunded` | NUMERIC | `0` | |
| 38 | `debit_card_discount` | NUMERIC | `0.00` | |
| 39 | `trade_in_discount` | NUMERIC | `0.00` | |
| 40 | `trade_in_bonus` | NUMERIC | `0.00` | |
| 41 | `estimated_shipping_fee` | NUMERIC | `37300.00` | Estimated carrier fee charged to the order |
| 42 | `trade_in_bonus_by_seller` | NUMERIC | `0.00` | |
| 43 | `buyer_paid_shipping` | NUMERIC | `0.00` | Shipping portion paid by buyer |
| 44 | `shopee_subsidized_shipping` | NUMERIC | `37300.00` | Portion of shipping fee subsidized by Shopee |
| 45 | `return_shipping_fee` | NUMERIC | `0.00` | Shipping fee for returned orders |
| 46 | `total_buyer_payment_vnd` | NUMERIC | `134050.00` | Final amount debited from buyer's account |
| 47 | `order_completion_time` | DATETIME | `2026-04-07 07:26` | When order status changed to "Completed" |
| 48 | `payment_timestamp` | DATETIME | `2026-04-01 09:16` | When payment was confirmed |
| 49 | `payment_method` | VARCHAR | `Cash on Delivery`, `SPayLater`, `ShopeePay Linked Bank`, `ShopeePay Wallet`, `Credit/Debit Card`, `Apple Pay`, `Google Pay` | Buyer's payment method |
| 50 | `fixed_platform_fee` | NUMERIC | `20625.00` | Fixed fee charged by Shopee per transaction |
| 51 | `service_fee` | NUMERIC | `0.00` | Additional service charge |
| 52 | `transaction_processing_fee` | NUMERIC | `0.00` | Payment gateway fee |
| 53 | `deposit_escrow` | NUMERIC | `0.00` | |
| 54 | `buyer_username` | VARCHAR | (masked) | Shopee username of the buyer |
| 55 | `recipient_name` | VARCHAR | (masked) | Full name of the delivery recipient |
| 56 | `phone_number` | VARCHAR | (masked) | Contact number for delivery |
| 57 | `province_city` | VARCHAR | `Ho Chi Minh City`, `Dong Nai Province` | Delivery province or city |
| 58 | `district` | VARCHAR | `District 1` | Sub-district of delivery address |
| 59 | `ward` | VARCHAR | (varies) | Ward-level address detail |
| 60 | `delivery_address` | VARCHAR | (masked) | Full delivery address string |
| 61 | `country` | VARCHAR | `VN` | Always "VN" for Vietnam |
| 62 | `internal_note` | VARCHAR | (free text or null) | Seller's internal order note |

---

## Table 2: `parentskudetail` (Sheet: `Top Performing Products`)

**Source:** Shopee Seller Center → Shopee Analytics → Product Performance Export  
**Grain:** One row per product variant; aggregated product-level rows included (where `variant_id` is null)

| # | Column | Data Type | Sample Value | Description |
|---|---|---|---|---|
| 1 | `product_id` | BIGINT | `21487599009` | Shopee's internal numeric product ID |
| 2 | `product_name` | VARCHAR | `MVD Fashion Watch...` | Full product listing title |
| 3 | `product_status` | VARCHAR | `Active` | Active / Inactive / Banned |
| 4 | `variant_id` | BIGINT | `196262506388` | Shopee's numeric variant identifier; null for parent-level rows |
| 5 | `variant_name` | VARCHAR | `MVD White Dial, Couple Set - 2 Sizes` | Variant label (color + size combination) |
| 6 | `variant_status` | VARCHAR | `Active` | Active / Inactive |
| 7 | `variant_sku` | VARCHAR | `DH-MVD-002-TRANG-DOI` | Seller-assigned SKU for this variant |
| 8 | `parent_sku` | VARCHAR | `DH-MVD-002` | Seller-assigned parent product SKU |
| 9 | `sales_placed_orders_vnd` | NUMERIC | `15,690,000` | Revenue from all placed orders (including pending) |
| 10 | `sales_confirmed_orders_vnd` | NUMERIC | `13,652,000` | Revenue from confirmed/completed orders only |
| 11 | `product_views` | INTEGER | `34756` | Total times the product page was viewed |
| 12 | `product_clicks` | INTEGER | `1894` | Total clicks on the product listing |
| 13 | `click_through_rate` | PERCENTAGE | `5.45%` | Clicks ÷ Impressions |
| 14 | `conversion_rate_placed` | PERCENTAGE | `1.74%` | Placed orders ÷ Clicks |
| 15 | `conversion_rate_confirmed` | PERCENTAGE | `1.58%` | Confirmed orders ÷ Clicks |
| 16 | `orders_placed` | INTEGER | `33` | Total number of placed orders |
| 17 | `orders_confirmed` | INTEGER | `30` | Total confirmed/completed orders |
| 18 | `units_placed` | INTEGER | `33` | Units sold in placed orders |
| 19 | `units_confirmed` | INTEGER | `30` | Units sold in confirmed orders |
| 20 | `unique_buyers_placed` | INTEGER | `28` | Distinct buyers who placed orders |
| 21 | `unique_buyers_confirmed` | INTEGER | `27` | Distinct buyers with confirmed orders |
| 22 | `buyer_conversion_rate_placed` | PERCENTAGE | `4.38%` | Unique placing buyers ÷ Unique visitors |
| 23 | `buyer_conversion_rate_confirmed` | PERCENTAGE | `4.23%` | Unique confirmed buyers ÷ Unique visitors |
| 24 | `revenue_per_placed_order_vnd` | NUMERIC | `475,455` | Average order value for placed orders |
| 25 | `revenue_per_confirmed_order_vnd` | NUMERIC | `455,067` | Average order value for confirmed orders |
| 26 | `unique_impressions` | INTEGER | `10436` | Unique users who saw the product in listings |
| 27 | `unique_clicks` | INTEGER | `690` | Unique users who clicked the product |
| 28 | `product_page_visits` | INTEGER | `639` | Sessions that reached the product page |
| 29 | `product_page_views` | INTEGER | `2030` | Total product page views (includes multiple views per session) |
| 30 | `bounces_from_product_page` | INTEGER | `112` | Visitors who left without interacting |
| 31 | `product_page_bounce_rate` | PERCENTAGE | `17.53%` | Bounces ÷ Product Page Visits |
| 32 | `clicks_from_search` | INTEGER | `180` | Clicks originating from the Shopee search results page |
| 33 | `product_likes` | INTEGER | `4` | Times product was "liked"/saved |
| 34 | `add_to_cart_visits` | INTEGER | `112` | Sessions in which the user added to cart |
| 35 | `units_added_to_cart` | INTEGER | `280` | Total units added to cart |
| 36 | `add_to_cart_conversion_rate` | PERCENTAGE | `17.53%` | Add-to-cart sessions ÷ Product page visits |
| 37 | `repeat_purchase_rate_placed` | PERCENTAGE | `15.15%` | Buyers who placed more than one order |
| 38 | `repeat_order_rate_confirmed` | PERCENTAGE | `10.00%` | Repeat orders ÷ Total confirmed orders |
| 39 | `avg_days_to_repeat_purchase_placed` | INTEGER | `0` | Average days between first and second order |
| 40 | `avg_days_to_repeat_order_confirmed` | INTEGER | `0` | Average days between confirmed repeat orders |

---

## Additional Sheets in `parentskudetail`

| Sheet Name | Description |
|---|---|
| `Top Performing Products` | High-performing products (used as primary input) |
| `New Products` | Newly listed products |
| `Non-Competitive Pricing` | Products flagged as non-competitive in price |
| `Competitive Pricing` | Products with competitive pricing |
| `Supported Growth` | Products with supported growth |
| `Campaign Optimization` | Products with campaign optimization suggestions |
| `Campaign Performance Tracking` | Campaign performance tracking |

---

## Known Data Quality Issues

| Issue | Description | Handling |
|---|---|---|
| **Null Package IDs** | Cancelled orders before pickup have no `package_id` | Set to NULL; excluded from delivery analytics |
| **Inconsistent Order Status** | Status values change format across Shopee export versions | Standardized via mapping table in ingestion script |
| **Cancellation Reason Free Text** | `cancellation_reason` is unstructured; contains embedded reason tags | Regex parsed to extract structured cancel reason and actor (buyer/system/seller) |
| **Duplicate Order Rows** | Orders with multiple SKUs may appear on multiple rows with same `order_id` | Deduplicated at ingestion; order-level aggregation handled in fact table |
| **Mixed Numeric Formats** | `parentskudetail` uses Vietnamese number formatting (`15.690.000`) and percentage strings (`5.45%`) | Cleaned to floats during ETL |
| **Parent vs Variant Rows** | `parentskudetail` mixes parent-level summary rows (null variant ID) with variant-level detail rows | Filtered and separated during modeling |
| **Non-unique Customer IDs** | `buyer_username` is not unique across export periods without consistent key generation | Custom `key_customer_id` generated via hashing |

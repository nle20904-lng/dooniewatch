# 📖 Data Dictionary — Doonie Watch Analytics

> Full column-level documentation for all tables in the Doonie Watch data warehouse.
> Back to main project: [`README.md`](./README.md)

---

## 📌 Table of Contents

- [Fact Tables](#fact-tables)
  - [fact\_txn\_orders](#fact_txn_orders)
  - [fact\_order\_detail](#fact_order_detail)
  - [fact\_order\_fee](#fact_order_fee)
  - [fact\_monthly\_profit\_and\_loss](#fact_monthly_profit_and_loss)
  - [fact\_daily\_profit\_and\_loss](#fact_daily_profit_and_loss)
  - [fact\_annually\_profit\_and\_loss](#fact_annually_profit_and_loss)
  - [fact\_monthly\_risk\_management](#fact_monthly_risk_management)
  - [fact\_customer\_monthly\_metrics](#fact_customer_monthly_metrics)
  - [fact\_monthly\_products\_performance](#fact_monthly_products_performance)
  - [fact\_product\_performance](#fact_product_performance)
  - [fact\_campaign\_performance](#fact_campaign_performance)
- [Dimension Tables](#dimension-tables)
  - [dim\_customer](#dim_customer)
  - [dim\_products](#dim_products)
  - [dim\_variants](#dim_variants)
  - [face\_variant\_cost\_history](#face_variant_cost_history)
  - [dim\_brands](#dim_brands)
  - [dim\_category](#dim_category)
  - [dim\_profit\_and\_loss](#dim_profit_and_loss)
  - [dim\_monthly\_risk\_management\_metrics](#dim_monthly_risk_management_metrics)
  - [dim\_customer\_metrics](#dim_customer_metrics)
  - [dim\_products\_metrics](#dim_products_metrics)
  - [dim\_payment\_method](#dim_payment_method)
  - [dim\_order\_status](#dim_order_status)
  - [dim\_order\_cancel\_reason](#dim_order_cancel_reason)
  - [dim\_order\_refund\_status](#dim_order_refund_status)
  - [dim\_campaign](#dim_campaign)
  - [dim\_campaign\_group](#dim_campaign_group)
  - [dim\_campaign\_status](#dim_campaign_status)
  - [dim\_fee\_type](#dim_fee_type)
  - [dim\_fee\_group](#dim_fee_group)
  - [dim\_date](#dim_date)
  - [dim\_city](#dim_city)
  - [dim\_district](#dim_district)
  - [dim\_ward](#dim_ward)
  - [dim\_gender](#dim_gender)
  - [dim\_strap\_type](#dim_strap_type)
  - [dim\_face\_shape](#dim_face_shape)
  - [dim\_variants\_type](#dim_variants_type)
  - [dim\_variants\_size](#dim_variants_size)
- [Dashboard Metric Reference](#dashboard-metric-reference)

---

## Fact Tables

### fact_txn_orders

Central order transaction table. Every analytical domain joins through here.
**Source:** Shopee Sales Data | **Grain:** 1 row per order

| Column | Data Type | Description |
|---|---|---|
| `transaction_order_id` | bigint | Surrogate key uniquely identifying each order transaction in the warehouse |
| `order_id` | varchar | Natural/business order identifier as provided by Shopee |
| `key_customer_id` | bigint | FK → `dim_customer` |
| `order_date_key` | text | Date key in YYYYMMDD format — date the order was placed |
| `order_date` | timestamp | Full timestamp of when the order was placed |
| `order_status_id` | bigint | FK → `dim_order_status` |
| `order_cancel_reason_id` | bigint | FK → `dim_order_cancel_reason` (NULL if not cancelled) |
| `refund_status` | varchar | Label describing the refund status of the order |
| `total_price` | numeric | Total order value including all items (VND) |
| `payment_method_id` | bigint | FK → `dim_payment_method` |
| `order_complete_date_key` | text | Date key in YYYYMMDD format — date order was completed |
| `order_complete_dt` | timestamp | Full timestamp of when the order was marked as completed |

---

### fact_order_detail

Line-item breakdown of each order. Enables product-level revenue and COGS analysis.
**Source:** Shopee Sales Data | **Grain:** 1 row per order × product variant

| Column | Data Type | Description |
|---|---|---|
| `order_id` | varchar | Business order identifier — links to `fact_txn_orders` |
| `transaction_order_id` | bigint | FK → `fact_txn_orders` |
| `key_product_id` | bigint | FK → `dim_products` |
| `key_variants_id` | bigint | FK → `dim_variants` |
| `total_price` | numeric | Total selling price for this line item (quantity × unit sale price) |
| `quantity` | bigint | Number of units purchased |
| `unit_cost` | numeric | COGS per unit at time of purchase — snapshot from `dim_variants` |

---

### fact_order_fee

All platform-side fees applied to each order. Powers granular operating expense breakdown.
**Source:** Shopee Sales Data | **Grain:** 1 row per order × fee type

| Column | Data Type | Description |
|---|---|---|
| `order_id` | varchar | Business order identifier — links to `fact_txn_orders` |
| `fee_type_key_id` | bigint | FK → `dim_fee_type` |
| `amount` | numeric | Monetary amount of the fee (VND) |

---

### fact_monthly_profit_and_loss

Monthly aggregated P&L. Primary source for the Profit & Loss Tracking Dashboard.
**Source:** `fact_txn_orders`, `fact_order_detail`, `fact_order_fee` | **Grain:** 1 row per month × P&L code

| Column | Data Type | Description |
|---|---|---|
| `date_key` | text | YYYYMM format month key |
| `pl_id` | bigint | FK → `dim_profit_and_loss` |
| `amount` | numeric | Aggregated monthly monetary amount for the P&L line item (VND) |

**P&L line items tracked** (via `dim_profit_and_loss`):

| `pl_code` | Type | Description |
|---|---|---|
| `paid_revenue` | Revenue | Revenue from fully completed and paid orders |
| `pending_revenue` | Revenue | Revenue from orders completed but pending settlement |
| `unit_cost` | Cost of Goods | Total COGS — sum of unit cost × quantity across all sold items |
| `piship_fee` | Platform Fee | Shopee platform shipping subsidy fee charged to seller |
| `fixed_fee` | Platform Fee | Fixed Shopee commission fee per order |
| `service_fee` | Platform Fee | General Shopee service/commission fee |
| `payment_fee` | Platform Fee | Payment processing fee per transaction |
| `ads_fee` | Marketing Fee | Shopee advertising spend (promoted listings, search ads) |
| `discount_fee` | Marketing Fee | Seller-funded vouchers and discount costs |
| `income_tax_fee` | Tax | Personal/business income tax on sales |
| `vat_fee` | Tax | Value-added tax on platform fees and revenue |

---

### fact_daily_profit_and_loss

Daily P&L for granular trend analysis and anomaly detection.
**Source:** `fact_txn_orders`, `fact_order_detail`, `fact_order_fee` | **Grain:** 1 row per day × P&L code

| Column | Data Type | Description |
|---|---|---|
| `date_key` | text | YYYYMMDD format date key |
| `pl_id` | bigint | FK → `dim_profit_and_loss` |
| `amount` | numeric | Daily monetary amount for the P&L line item (VND) |

---

### fact_annually_profit_and_loss

Annual P&L rollup for year-over-year comparison.
**Source:** `fact_txn_orders`, `fact_order_detail`, `fact_order_fee` | **Grain:** 1 row per year × P&L code

| Column | Data Type | Description |
|---|---|---|
| `date_key` | text | YYYY format year key |
| `pl_id` | bigint | FK → `dim_profit_and_loss` |
| `amount` | numeric | Aggregated annual monetary amount for the P&L line item (VND) |

---

### fact_monthly_risk_management

Monthly operational risk metrics, sliced by geographic, product, brand, and payment dimensions.
**Source:** `fact_txn_orders` | **Grain:** 1 row per month × city × district × product × brand × payment method × metric

| Column | Data Type | Description |
|---|---|---|
| `month_key` | varchar | YYYYMM format month key |
| `city` | varchar | City name associated with the risk record |
| `district` | varchar | District name associated with the risk record |
| `key_product_id` | bigint | FK → `dim_products` |
| `key_brand_id` | bigint | FK → `dim_brands` |
| `payment_method_id` | bigint | FK → `dim_payment_method` |
| `metrics_id` | bigint | FK → `dim_monthly_risk_management_metrics` |
| `metrics_value` | numeric | Calculated value of the risk metric |

**Risk metrics tracked** (via `dim_monthly_risk_management_metrics`):

| `metrics_code` | Group | Description |
|---|---|---|
| `total_orders` | Volume | Total number of orders |
| `total_gmv` | Revenue | Total gross merchandise value (before deductions) |
| `completed_orders` | Fulfillment | Orders successfully completed |
| `completed_gmv` | Revenue | GMV from completed orders only |
| `delivered_orders` | Fulfillment | Orders delivered to customers |
| `canceled_orders` | Risk | Orders canceled before completion |
| `canceled_gmv` | Risk | GMV lost from canceled orders |
| `returned_orders` | Risk | Orders returned by customers after delivery |
| `approved_refund_orders` | Risk | Refund requests approved by seller/platform |
| `approved_refund_gmv` | Risk | GMV refunded to customers |
| `refund_requested_orders` | Risk | Orders with active refund requests |
| `refund_requested_gmv` | Risk | GMV currently under refund requests |
| `disputed_refund_orders` | Risk | Refund disputes resolved in seller's favor |

---

### fact_customer_monthly_metrics

Monthly behavioral and lifecycle metrics per customer. Powers the Executive Customer Dashboard.
**Source:** `fact_txn_orders`, `dim_customer_metrics` | **Grain:** 1 row per month × customer × metric

| Column | Data Type | Description |
|---|---|---|
| `month_key` | text | YYYYMM format month key |
| `customer_id` | text | Business key for the customer |
| `city` | varchar | City where the customer is located |
| `district` | varchar | District where the customer is located |
| `metric_id` | bigint | FK → `dim_customer_metrics` |
| `value` | numeric | Calculated value of the customer metric for the month |

**Customer metrics tracked** (via `dim_customer_metrics`):

| `metric_code` | Group | Description |
|---|---|---|
| `is_new_customer` | Acquisition | `1` if this is the customer's first purchase month, else `0` |
| `is_returning_customer` | Retention | `1` if customer has purchased in a previous month, else `0` |
| `is_active_customer` | Engagement | `1` if customer placed at least one order in the month, else `0` |
| `total_orders` | Volume | Total orders placed by the customer in the month |
| `completed_orders` | Volume | Orders successfully completed by the customer |
| `canceled_orders` | Risk | Orders canceled by the customer in the month |
| `total_revenue` | Revenue | Total revenue generated from this customer in the month |
| `lifetime_revenue` | Revenue | Cumulative revenue from the customer across all time |
| `lifetime_orders` | Volume | Cumulative orders from the customer across all time |
| `avg_order_value` | Revenue | Average order value for the customer in the month |
| `purchase_frequency` | Engagement | Number of purchase transactions in the month |
| `days_since_last_order` | Retention | Days elapsed since the customer's most recent order |

---

### fact_monthly_products_performance

Monthly product funnel metrics aggregated by brand and category. Powers the Executive Performance Dashboard.
**Source:** `fact_product_performance` | **Grain:** 1 row per month × brand × category × metric

| Column | Data Type | Description |
|---|---|---|
| `month_key` | text | YYYYMM format month key |
| `brand_id` | bigint | FK → `dim_brands` |
| `category_id` | bigint | FK → `dim_category` |
| `metric_id` | bigint | FK → `dim_products_metrics` |
| `amount` | numeric | Aggregated monthly value of the product performance metric |

**Product metrics tracked** (via `dim_products_metrics`):

| `metric_code` | Direction | Description |
|---|---|---|
| `views_count` | Higher = better | Total product listing views |
| `clicks` | Higher = better | Total clicks on the product listing |
| `add_to_cart` | Higher = better | Total add-to-cart actions |
| `exit_count` | Lower = better | Total exits from product page without further action |
| `orders` | Higher = better | Total orders placed for the product |

---

### fact_product_performance

Raw daily product-level performance data ingested from Shopee.
**Source:** Shopee Sales Data | **Grain:** 1 row per datetime × product

| Column | Data Type | Description |
|---|---|---|
| `date_time` | timestamp | Timestamp of the product performance measurement |
| `key_product_id` | bigint | FK → `dim_products` |
| `views_count` | bigint | Product listing views |
| `clicks` | bigint | Clicks on the product listing |
| `exit_count` | bigint | Exits from product page without action |
| `add_to_cart` | bigint | Add-to-cart actions |
| `orders` | bigint | Orders placed |
| `ordered_items` | bigint | Total units ordered |
| `ordered_revenue` | numeric | Total revenue generated (VND) |

---

### fact_campaign_performance

Performance metrics for each Shopee marketing campaign per product per day.
**Source:** Shopee Campaign Data | **Grain:** 1 row per campaign × product × datetime

| Column | Data Type | Description |
|---|---|---|
| `campaign_key_id` | bigint | FK → `dim_campaign` |
| `key_product_id` | bigint | FK → `dim_products` |
| `date_time` | timestamp | Timestamp of the campaign performance measurement |
| `views_count` | bigint | Times the campaign was viewed |
| `clicks` | bigint | Clicks on the campaign |
| `conversion_count` | bigint | Orders attributed to the campaign |
| `total_fee` | numeric | Total campaign fee charged for the period (VND) |

---

## Dimension Tables

### dim_customer

Customer master table with 3-level geographic resolution.
**Source:** Shopee Sales Data

| Column | Data Type | Description |
|---|---|---|
| `key_customer_id` | bigint | Surrogate PK |
| `customer_id` | varchar | Natural key from Shopee |
| `customer_name` | varchar | Full name of the customer |
| `city_key` | bigint | FK → `dim_city` |
| `district_key` | bigint | FK → `dim_district` |
| `ward_key` | bigint | FK → `dim_ward` |
| `customer_desc` | varchar | Additional notes about the customer |
| `register_dt` | timestamp | Date the customer registered on Shopee |

---

### dim_products

Product catalog with brand, category, and attribute linkages.
**Source:** Merchant Provided Data

| Column | Data Type | Description |
|---|---|---|
| `key_product_id` | bigint | Surrogate PK |
| `product_code` | varchar | Merchant-defined product code |
| `product_name` | varchar | Display name of the product |
| `product_desc` | varchar | Detailed product description |
| `key_brand_id` | bigint | FK → `dim_brands` |
| `key_gender_id` | bigint | FK → `dim_gender` |
| `key_strap_type_id` | bigint | FK → `dim_strap_type` |
| `key_face_shape_id` | bigint | FK → `dim_face_shape` |
| `key_category_id` | bigint | FK → `dim_category` |
| `campaign_key_id` | bigint | FK → `dim_campaign` |
| `product_status` | integer | `1` = active, `0` = inactive |
| `register_dt` | timestamp | Date product was first registered |
| `rec_created_dt` | timestamp | Warehouse insert timestamp |
| `rec_updated_dt` | timestamp | Warehouse last update timestamp |

---

### dim_variants

SKU-level detail with pricing and cost per variant.
**Source:** Merchant Provided Data

| Column | Data Type | Description |
|---|---|---|
| `key_variants_id` | bigint | Surrogate PK |
| `key_product_id` | bigint | FK → `dim_products` |
| `variants_code` | varchar | SKU code |
| `variants_desc` | varchar | Variant description (color, size, etc.) |
| `variants_type_key_id` | bigint | FK → `dim_variants_type` |
| `variants_size_key_id` | bigint | FK → `dim_variants_size` |
| `variants_status` | integer | `1` = active, `0` = inactive |
| `unit_cost` | numeric | Current cost price per unit (VND) |
| `sale_price` | numeric | Current selling price per unit (VND) |
| `register_dt` | timestamp | Date variant was first registered |
| `rec_created_dt` | timestamp | Warehouse insert timestamp |
| `rec_updated_dt` | timestamp | Warehouse last update timestamp |

---

### face_variant_cost_history

Historical cost tracking per variant — SCD Type 2 implementation for accurate historical COGS.
**Source:** Database

| Column | Data Type | Description |
|---|---|---|
| `key_variant_cost_history_id` | bigint | Surrogate PK |
| `key_variants_id` | bigint | FK → `dim_variants` |
| `variants_code` | varchar | Variant business code at time of record |
| `unit_cost` | numeric | Unit cost applicable for the validity period (VND) |
| `valid_from` | timestamp | Start datetime this cost becomes effective |
| `valid_to` | timestamp | End datetime this cost expires (`NULL` if still current) |
| `is_current` | boolean | `true` if this is the currently active cost record |

---

### dim_profit_and_loss

P&L line item definitions — lookup for `fact_monthly_profit_and_loss`.
**Source:** Database

| Column | Data Type | Description |
|---|---|---|
| `pl_id` | bigint | Surrogate PK |
| `pl_code` | varchar | Short code for the P&L line item (e.g. `paid_revenue`, `ads_fee`) |
| `pl_type` | varchar | Classification: `Revenue`, `Cost`, or `Expense` |
| `pl_desc` | varchar | Detailed description of the P&L line item |

---

### dim_monthly_risk_management_metrics

Risk metric definitions — lookup for `fact_monthly_risk_management`.
**Source:** Database

| Column | Data Type | Description |
|---|---|---|
| `metrics_id` | integer | Surrogate PK |
| `metrics_code` | varchar | Short code (e.g. `canceled_orders`, `total_gmv`) |
| `metrics_desc` | varchar | Detailed description of the metric |
| `metrics_group` | varchar | Category (e.g. Volume, Risk, Revenue, Fulfillment) |
| `format_type` | varchar | Display format: `percentage`, `currency`, or `integer` |
| `sort_order` | integer | Display order in dashboards |
| `is_active` | integer | `1` = in use, `0` = deprecated |

---

### dim_customer_metrics

Customer metric definitions — lookup for `fact_customer_monthly_metrics`.
**Source:** Database

| Column | Data Type | Description |
|---|---|---|
| `metric_id` | bigint | Surrogate PK |
| `metric_code` | varchar | Short code (e.g. `is_new_customer`, `lifetime_revenue`) |
| `metric_name` | varchar | Human-readable display name |
| `metric_group` | varchar | Grouping (e.g. Retention, Revenue, Engagement) |
| `metric_type` | varchar | Data format: `count`, `ratio`, or `currency` |
| `description` | varchar | Detailed explanation of how the metric is calculated |
| `sort_order` | bigint | Display order in dashboards |

---

### dim_products_metrics

Product metric definitions — lookup for `fact_monthly_products_performance`.
**Source:** Database

| Column | Data Type | Description |
|---|---|---|
| `metric_id` | bigint | Surrogate PK |
| `metric_code` | varchar | Short code (e.g. `views_count`, `add_to_cart`) |
| `metric_desc` | varchar | Detailed description of the metric |
| `metric_group` | varchar | Grouping (e.g. Traffic, Conversion) |
| `metric_direction` | varchar | `positive` (higher = better) or `negative` (lower = better) |

---

### dim_payment_method

Payment method lookup.
**Source:** Shopee Sales Data

| Column | Data Type | Description |
|---|---|---|
| `payment_method_id` | bigint | Surrogate PK |
| `payment_method` | varchar | Payment method name (e.g. COD, ShopeePay, SPayLater, Credit Card) |

---

### dim_order_status

Order status lookup.
**Source:** Shopee Sales Data

| Column | Data Type | Description |
|---|---|---|
| `order_status_id` | bigint | Surrogate PK |
| `order_status` | varchar | Status label (e.g. Completed, Cancelled, Returning, Delivered) |

---

### dim_order_cancel_reason

Order cancellation reason lookup.
**Source:** Shopee Sales Data

| Column | Data Type | Description |
|---|---|---|
| `order_cancel_reason_id` | bigint | Surrogate PK |
| `order_cancel_reason` | varchar | Description of the cancellation reason |

---

### dim_order_refund_status

Order refund status lookup.
**Source:** Shopee Sales Data

| Column | Data Type | Description |
|---|---|---|
| `order_refund_status_id` | bigint | Surrogate PK |
| `order_refund_status` | bigint | Numeric refund status code |

---

### dim_campaign

Shopee marketing campaign master.
**Source:** Shopee Campaign Data

| Column | Data Type | Description |
|---|---|---|
| `campaign_key_id` | bigint | Surrogate PK |
| `campaign_name` | varchar | Name of the Shopee marketing campaign |
| `campaign_group_key_id` | bigint | FK → `dim_campaign_group` |
| `campaign_status_key_id` | bigint | FK → `dim_campaign_status` |
| `start_dt` | timestamp | Campaign start date and time |
| `end_dt` | timestamp | Campaign end date and time |
| `is_unlimited` | varchar | `Y` if campaign has no end date, `N` otherwise |

---

### dim_campaign_group

Campaign group classification.
**Source:** `dim_campaign`

| Column | Data Type | Description |
|---|---|---|
| `campaign_group_key_id` | bigint | Surrogate PK |
| `campaign_group_name` | varchar | Name of the campaign group |
| `campaign_group_desc` | varchar | Description of the group |
| `register_dt` | timestamp | Date the group was registered |

---

### dim_campaign_status

Campaign status lookup.
**Source:** `dim_campaign`

| Column | Data Type | Description |
|---|---|---|
| `campaign_status_key_id` | bigint | Surrogate PK |
| `campaign_status` | varchar | Status label (e.g. Active, Ended, Scheduled) |
| `update_dt` | timestamp | Last updated timestamp |

---

### dim_fee_type

Individual fee type definitions.
**Source:** Shopee Sales Data

| Column | Data Type | Description |
|---|---|---|
| `fee_type_key_id` | bigint | Surrogate PK |
| `fee_type_name` | varchar | Name of the fee type (e.g. Commission, Shipping Subsidy) |
| `fee_type_desc` | varchar | Detailed description |
| `fee_group_key_id` | bigint | FK → `dim_fee_group` |
| `register_dt` | timestamp | Date registered |

---

### dim_fee_group

Fee grouping for operating expense rollup.
**Source:** Shopee Sales Data

| Column | Data Type | Description |
|---|---|---|
| `fee_group_key_id` | bigint | Surrogate PK |
| `fee_group_name` | varchar | Group name (e.g. Platform Fee, Shipping Fee, Marketing Fee) |
| `fee_group_desc` | varchar | Description of the fee group |
| `register_dt` | timestamp | Date registered |

---

### dim_date

Date dimension for time intelligence in Power BI.
**Source:** Database

| Column | Data Type | Description |
|---|---|---|
| `date_key` | text | YYYYMMDD format — used for joining with fact tables |
| `full_date` | date | Full calendar date |
| `day_of_month` | integer | Day number within month (1–31) |
| `day_of_week` | integer | Day number within week (1 = Monday, 7 = Sunday) |
| `day_name` | varchar | Full day name (e.g. Monday) |
| `week_of_year` | integer | ISO week number (1–53) |
| `month_number` | integer | Month number (1–12) |
| `month_name` | varchar | Full month name (e.g. January) |
| `quarter_number` | integer | Quarter (1–4) |
| `year_number` | integer | Four-digit year (e.g. 2026) |
| `is_weekend` | boolean | `true` if Saturday or Sunday |

---

### dim_city

City master — top level of the 3-tier geographic hierarchy.
**Source:** `dim_customer`

| Column | Data Type | Description |
|---|---|---|
| `key_city_id` | bigint | Surrogate PK |
| `city_name` | varchar | Name of the city (e.g. TP. Hồ Chí Minh) |
| `city_desc` | varchar | Additional notes |
| `register_dt` | timestamp | Date registered |

---

### dim_district

District master — second level of the geographic hierarchy.
**Source:** `dim_customer`

| Column | Data Type | Description |
|---|---|---|
| `key_district_id` | bigint | Surrogate PK |
| `district_name` | varchar | Name of the district |
| `district_desc` | varchar | Additional notes |
| `register_dt` | timestamp | Date registered |

---

### dim_ward

Ward master — most granular level of the geographic hierarchy.
**Source:** `dim_customer`

| Column | Data Type | Description |
|---|---|---|
| `key_ward_id` | bigint | Surrogate PK |
| `ward_name` | varchar | Name of the ward |
| `ward_desc` | varchar | Additional notes |
| `register_dt` | timestamp | Date registered |

---

### dim_gender

Gender classification for product targeting.
**Source:** `dim_products`

| Column | Data Type | Description |
|---|---|---|
| `key_gender_id` | bigint | Surrogate PK |
| `gender_name` | varchar | Classification name (e.g. Male, Female, Unisex) |
| `gender_desc` | varchar | Description |
| `gender_status` | integer | `1` = active, `0` = inactive |
| `register_dt` | timestamp | Date registered |
| `rec_created_dt` | timestamp | Warehouse insert timestamp |
| `rec_updated_dt` | timestamp | Warehouse last update timestamp |

---

### dim_strap_type

Watch strap type classification.
**Source:** `dim_products`

| Column | Data Type | Description |
|---|---|---|
| `key_strap_type_id` | bigint | Surrogate PK |
| `strap_type_name` | varchar | Strap material/type (e.g. Metal, Leather, Silicone) |
| `strap_type_desc` | varchar | Description of material and characteristics |
| `strap_type_status` | integer | `1` = active, `0` = inactive |
| `register_dt` | timestamp | Date registered |
| `rec_created_dt` | timestamp | Warehouse insert timestamp |
| `rec_updated_dt` | timestamp | Warehouse last update timestamp |

---

### dim_face_shape

Face shape suitability attribute for watch/product recommendations.
**Source:** `dim_products`

| Column | Data Type | Description |
|---|---|---|
| `key_face_shape_id` | bigint | Surrogate PK |
| `face_shape_name` | varchar | Face shape name (e.g. Oval, Round, Square) |
| `face_shape_desc` | varchar | Description and compatible product styles |
| `face_shape_status` | integer | `1` = active, `0` = inactive |
| `register_dt` | timestamp | Date registered |
| `rec_created_dt` | timestamp | Warehouse insert timestamp |
| `rec_updated_dt` | timestamp | Warehouse last update timestamp |

---

### dim_variants_type

Variant type classification (e.g. Color, Lens Type).
**Source:** `dim_variants`

| Column | Data Type | Description |
|---|---|---|
| `variants_type_key_id` | bigint | Surrogate PK |
| `variants_type_name` | varchar | Type name |
| `variants_type_desc` | varchar | Description |
| `register_dt` | timestamp | Date registered |

---

### dim_variants_size

Variant size classification.
**Source:** `dim_variants`

| Column | Data Type | Description |
|---|---|---|
| `variants_size_key_id` | bigint | Surrogate PK |
| `variants_size_name` | varchar | Size label (e.g. S, M, L, XL) |
| `variants_size_desc` | varchar | Size measurements and description |
| `register_dt` | timestamp | Date registered |

---

### dim_brands

Brand master for product classification and filtering.
**Source:** Merchant Provided Data

| Column | Data Type | Description |
|---|---|---|
| `key_brand_id` | bigint | Surrogate PK |
| `brand_name` | varchar | Display name of the brand (e.g. Casio, DW, Longines) |
| `brand_desc` | varchar | Notes about the brand |
| `brand_status` | integer | `1` = active, `0` = inactive |
| `register_dt` | timestamp | Date brand was registered |
| `rec_created_dt` | timestamp | Warehouse insert timestamp |
| `rec_updated_dt` | timestamp | Warehouse last update timestamp |

---

### dim_category

Product category hierarchy.
**Source:** `dim_products`

| Column | Data Type | Description |
|---|---|---|
| `key_category_id` | bigint | Surrogate PK |
| `category_name` | varchar | Display name (e.g. đồng hồ thời trang, đồng hồ điện tử, đồng hồ luxury) |
| `category_desc` | varchar | Category description |
| `category_status` | integer | `1` = active, `0` = inactive |
| `register_dt` | timestamp | Date registered |
| `rec_created_dt` | timestamp | Warehouse insert timestamp |
| `rec_updated_dt` | timestamp | Warehouse last update timestamp |

---

# Dashboard Metric Reference

Quick reference mapping each Power BI dashboard to its source tables and business metrics.

---

## 💰 Profit & Loss Tracking

**Source tables:** `fact_monthly_profit_and_loss`, `fact_daily_profit_and_loss`, `fact_annually_profit_and_loss`, `dim_profit_and_loss`

> **May 2026 snapshot:** Total Revenue 344,910,000 VND · GPM 56.34% · Net Profit 70,108,450 VND · Net Profit Margin 20.33% · Revenue MoM ▲17.4% · Net Profit MoM ▲2.7%
> **YTD 2026 (Jan–May):** Revenue 1,623M · Unit Cost 740.3M · Operating Expense 529.16M · Net Profit 353.5M

| Metric                 | pl_code                                 | Type          |
| ---------------------- | --------------------------------------- | ------------- |
| Paid Revenue           | `paid_revenue`                          | Revenue       |
| Pending Revenue        | `pending_revenue`                       | Revenue       |
| Unit Cost (COGS)       | `unit_cost`                             | Cost          |
| Platform Shipping Fee  | `piship_fee`                            | Platform Fee  |
| Fixed Commission Fee   | `fixed_fee`                             | Platform Fee  |
| Service Fee            | `service_fee`                           | Platform Fee  |
| Payment Processing Fee | `payment_fee`                           | Platform Fee  |
| Advertising Fee        | `ads_fee`                               | Marketing Fee |
| Discount/Voucher Cost  | `discount_fee`                          | Marketing Fee |
| Income Tax             | `income_tax_fee`                        | Tax           |
| VAT                    | `vat_fee`                               | Tax           |
| Total Expense          | `SUM(all expense pl_codes)`             | Derived       |
| Gross Profit           | `Revenue - Unit Cost`                   | Derived       |
| Gross Profit Margin    | `(Revenue - Unit Cost) / Revenue × 100` | Derived       |
| Net Profit             | `Revenue - Unit Cost - Total Expense`   | Derived       |
| Net Profit Margin      | `Net Profit / Revenue × 100`            | Derived       |
| Revenue MoM Growth     | `(Current Revenue - Previous Revenue) / Previous Revenue × 100` | Derived |
| Net Profit MoM Growth  | `(Current Net Profit - Previous Net Profit) / Previous Net Profit × 100` | Derived |

**Operating Expense Structure (May 2026):**

| Fee Group     | Share  |
| ------------- | ------ |
| Platform Fee  | 80.69% |
| Marketing Fee | 12.69% |
| Shipping Fee  | 2.62%  |
| Tax Fee       | ~4.00% |

---

## 👥 Customer Acquisition & Retention Overview

**Source tables:** `fact_customer_monthly_metrics`, `dim_customer_metrics`, `dim_customer`, `dim_city`

> **May 2026 snapshot:** Total Customers 1,080 · New 980 (90.74%) · Returning 100 (9.26%) · Retention Rate 9.26% · New MoM ▼14.0% · Returning MoM ▲233.3%
> **YTD 2026 avg retention rate:** 4.45%

| Metric                   | metric_code                                                                        | Description           |
| ------------------------ | ---------------------------------------------------------------------------------- | --------------------- |
| Total Customers          | `is_active_customer`                                                               | Count where value = 1 |
| New Customers            | `is_new_customer`                                                                  | Count where value = 1 |
| Returning Customers      | `is_returning_customer`                                                            | Count where value = 1 |
| Total Revenue            | `total_revenue`                                                                    | Sum of values         |
| Total Orders             | `total_orders`                                                                     | Sum of values         |
| Completed Orders         | `completed_orders`                                                                 | Sum of values         |
| Avg Order Value          | `avg_order_value`                                                                  | Average of values     |
| Purchase Frequency       | `purchase_frequency`                                                               | Average of values     |
| Days Since Last Order    | `days_since_last_order`                                                            | Average of values     |
| Retention Rate           | `Returning Customers / Total Customers × 100`                                      | Derived               |
| New Customer Growth Rate | `(Current New Customers - Previous New Customers) / Previous New Customers × 100` | Derived               |

**Top cities by customer volume (May 2026):**

| City                  | New Customers | Returning | Retention Rate |
| --------------------- | ------------- | --------- | -------------- |
| TP. Hồ Chí Minh       | 410           | 20        | 4.65%          |
| Tỉnh Đồng Nai         | 100           | 0         | 0.00%          |
| Thành phố Cần Thơ     | 40            | 20        | 33.33%         |
| Tỉnh Vĩnh Long        | 40            | 0         | 0.00%          |
| Thành phố Đà Nẵng     | 30            | 0         | 0.00%          |

---

## 🛒 Traffic & Conversion Performance

**Source tables:** `fact_monthly_products_performance`, `dim_products_metrics`, `dim_brands`, `dim_category`

> **May 2026 snapshot:** Views 1,530,620 (▼8.2%) · Clicks 70,670 (CTR MoM ▲2.2%) · Add to Cart 8,870 (▼14.2%) · Completed Orders 1,110 (▼6.7%)
> **YTD 2026 monthly averages:** Views 1,720,706 · Clicks 76,008 · Add to Cart 9,806 · Completed Orders 1,194

| Metric            | metric_code                        | Direction       |
| ----------------- | ---------------------------------- | --------------- |
| Product Views     | `views_count`                      | Higher = Better |
| Product Clicks    | `clicks`                           | Higher = Better |
| Add To Cart       | `add_to_cart`                      | Higher = Better |
| Completed Orders  | `orders`                           | Higher = Better |
| CTR               | `clicks / views_count × 100`       | Higher = Better |
| Conversion Rate   | `orders / clicks × 100`            | Higher = Better |
| Add-To-Cart Rate  | `add_to_cart / clicks × 100`       | Higher = Better |
| Views MoM Growth  | Monthly growth of product views    | Higher = Better |
| Clicks MoM Growth | Monthly growth of clicks           | Higher = Better |
| Orders MoM Growth | Monthly growth of completed orders | Higher = Better |

**Purchase funnel drop-off (May 2026):**

| Stage            | Count  | Rate   |
| ---------------- | ------ | ------ |
| Total Clicks     | 70,670 | 100%   |
| Add To Cart      | 8,870  | 12.55% |
| Completed Orders | 1,110  | 1.57%  |

**Traffic by product category (May 2026):**

| Category              | Views   |
| --------------------- | ------- |
| Đồng hồ thời trang    | 690,690 |
| Đồng hồ điện tử       | 549,250 |
| Đồng hồ luxury        | 290,680 |

---

## ⚠️ Order Fulfillment Risk & Loss Management

**Source tables:** `fact_monthly_risk_management`, `dim_monthly_risk_management_metrics`, `dim_payment_method`, `dim_brands`, `dim_city`

> **May 2026 snapshot:** Canceled Orders 320 · Cancellation Rate 21.92% (▼21.0% MoM) · Returned Orders 30 · Return Rate 2.05% (▼50.0% MoM)
> **YTD 2026 averages:** Avg Cancellation Rate 24.8% · Avg Return Rate 3.1% · Total Canceled 2,130 · Total Returned 260

| Metric                    | metrics_code                                            | Description                        |
| ------------------------- | ------------------------------------------------------- | ---------------------------------- |
| Total Orders              | `total_orders`                                          | Total orders placed                |
| Completed Orders          | `completed_orders`                                      | Successfully completed orders      |
| Delivered Orders          | `delivered_orders`                                      | Orders delivered to customers      |
| Canceled Orders           | `canceled_orders`                                       | Orders canceled before fulfillment |
| Returned Orders           | `returned_orders`                                       | Orders returned after delivery     |
| Total GMV                 | `total_gmv`                                             | Gross merchandise value            |
| Completed GMV             | `completed_gmv`                                         | GMV from completed orders          |
| Canceled GMV              | `canceled_gmv`                                          | Revenue lost due to cancellations  |
| Approved Refund Orders    | `approved_refund_orders`                                | Approved refund requests           |
| Approved Refund GMV       | `approved_refund_gmv`                                   | Refunded GMV                       |
| Refund Requested Orders   | `refund_requested_orders`                               | Pending refund requests            |
| Refund Requested GMV      | `refund_requested_gmv`                                  | GMV under review                   |
| Disputed Refund Orders    | `disputed_refund_orders`                                | Seller-won refund disputes         |
| Cancellation Rate         | `Canceled Orders / Total Orders × 100`                  | Derived                            |
| Returned Order Rate       | `Returned Orders / Total Orders × 100`                  | Derived                            |
| Refund Rate               | `Approved Refund Orders / Total Orders × 100`           | Derived                            |
| Order Vulnerability Share | Share of canceled and returned orders by payment method | Derived                            |

# 🕐 Doonie Watch — Shopee Data Analytics Project

> **⚠️ IMPORTANT NOTICE**
> **<span style="color:red">The data used in this project has been masked and is used with the explicit written permission and consent of the shop owner.</span>**

---

## 📌 Table of Contents

1. [Background & Context](#1-background--context)
2. [Process — Step by Step](#2-process--step-by-step)
3. [Insight Deep Dive](#3-insight-deep-dive)
4. [Achievements (Jan 2025 → May 2026)](#4-achievements-jan-2025--may-2026)
5. [Value Gained](#5-value-gained)

---

## 1. Background & Context

**🔗 Demo:** *(link to Power BI report)*

> <span style="color:red">**⚠️ NOTE: All data has been masked and used with the explicit permission and written consent of the shop owner.**</span>

### Who is the client?

Doonie Watch is a watch retailer operating on Shopee Vietnam for over 2 years, selling fashion, digital, and luxury watches across multiple brands (Casio, Movado, DW, Longines, and others).

### The Problem — Before January 2025

Prior to this engagement, the shop owner had no structured data management. Their only visibility came from Shopee's native summary screens. As a result:

- Revenue reporting was inconsistent and unreliable
- No way to track profit, cost structure, or margins
- Operational problems (high cancellation rate) existed but were invisible
- Decisions were made on intuition — revenue stagnated at a low baseline

### What the Owner Needed

The owner wanted to move beyond reading native Shopee reports and gain:
- Full visibility into business performance across revenue, profit, customers, and risk
- The ability to trace root causes of problems as they emerge
- A scalable data infrastructure, not one-off spreadsheets

### My Role — Dual Responsibilities

I was engaged as a **Freelance Data Consultant** across two domains:

| Role | Responsibilities |
|---|---|
| **Data BI Analyst** | Built end-to-end data infrastructure: raw data ingestion (Python), PostgreSQL database design (Star Schema), stored procedure pipelines, and 4 interactive Power BI dashboards covering P&L, customer analytics, traffic/conversion, and risk management |
| **Digital Marketing Analyst** | Analyzed Shopee traffic and conversion data to identify underperforming campaigns, optimized ad spend allocation across brands and categories, mapped CTR-to-conversion gaps by brand, and delivered monthly marketing performance recommendations |

### Dashboard Outputs

4 interactive Power BI dashboards built, each answering a core business objective:

| Dashboard | Business Objective | Key Metrics |
|---|---|---|
| 📊 **P&L Tracking** | Increase profitability | Revenue, GPM, NPM, Operating Expense Structure |
| 👥 **Customer Analytics** | Grow & retain customers | New vs Returning, Retention Rate, Geographic Breakdown |
| 🛒 **Traffic & Conversion** | Maximize marketing ROI | Views, CTR, Conversion Rate, Brand Performance Matrix |
| ⚠️ **Risk Management** | Reduce operational risk | Cancellation Rate, Return Rate, Risk by Payment Method & City |

> 📸 **See Section 2.5 below for detailed dashboard mockups.**

---

## 2. Process — Step by Step

### 2.1 Data Pipeline Overview

```
Shopee Raw Exports (Excel)
          │
          ▼
  Python Ingestion Script
  ├── pandas: parse & normalize
  ├── openpyxl: read xlsx
  └── sqlalchemy: load to PostgreSQL
          │
          ▼
  PostgreSQL — root_data schema (staging)
  ├── root_data.order_all       ← raw orders loaded here
  ├── root_data.orders          ← deduplicated, upserted
  ├── root_data.product_all     ← raw product performance
  ├── root_data.product_performance ← cleaned & merged
  ├── root_data.sanpham         ← product master (manual)
  ├── root_data.phanloai        ← variant master (manual)
  └── root_data.campaign        ← campaign data
          │
          ▼
  3 Stored Procedures (stg schema)
  ├── prc_update_status_fact_txn_orders  ← Step 1: upsert raw data
  ├── prc_insert_dim_tables              ← Step 2: populate dimension tables
  └── prc_insert_fact_tables             ← Step 3: compute all fact tables
          │
          ▼
  Power BI (Import Mode)
  ├── DAX custom measures
  └── 4 Interactive Dashboards
```

---

### 2.2 EDA — Exploratory Data Analysis (Input)

Before building the database, raw exports were profiled to understand structure, quality, and limitations.

**Input Data Dictionary →** [data dictionary/data_dictionary_input.md](./data%20dictionary/data_dictionary_input.md)

**Two primary input sources:**

**Source 1 — Order Export (`Order_all_YYYYMMDD_YYYYMMDD.xlsx`)**
- 62 columns: order metadata, product/variant info, pricing, discounts, shipping, payment method, buyer address, and platform fees
- Key issue: null package IDs on cancelled orders, free-text cancellation reasons requiring parsing, duplicate rows for multi-SKU orders

**Source 2 — Product Performance Export (`parentskudetail_YYYYMMDD_YYYYMMDD.xlsx`)**
- 40 columns: views, clicks, CTR, conversion rates, add-to-cart, repeat purchase rates
- Key issue: mixed parent-level and variant-level rows, Vietnamese number formatting (`15.690.000`), percentage values as strings

**Key EDA Findings (Digital Marketing lens):**

| Finding | Marketing Implication |
|---|---|
| COD orders dominate (~70%) | Payment method is the strongest predictor of cancellation — not product quality |
| Casio CTR × Conversion both above average | Confirmed budget priority: Casio ads deliver highest ROI |
| Luxury watches: high views, near-zero conversion | Trust gap, not demand gap — content/pricing strategy needed |
| HCMC drives 85%+ of customers | Adjacent provinces (Đồng Nai, Bình Dương) show organic demand — untapped market |

---

### 2.3 Data Organization & Star Schema Design

**Output Data Dictionary →** [data dictionary/data_dictionary_input.md](./data%20dictionary/data_dictionary_output.md)

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

Pre-aggregated Fact Tables (computed by stored procedures):
  fact_daily_profit_and_loss
  fact_monthly_profit_and_loss
  fact_annually_profit_and_loss
  fact_monthly_products_performance
  fact_customer_monthly_metrics
  fact_monthly_risk_management
  fact_product_performance
  fact_campaign_performance
```

---

### 2.4 Stored Procedures

The entire data pipeline from raw staging to Power BI-ready facts runs through **3 stored procedures**, called in sequence:

```sql
call stg.prc_update_status_fact_txn_orders();
call stg.prc_insert_dim_tables();
call stg.prc_insert_fact_tables();
```

---

#### `prc_update_status_fact_txn_orders` — Upsert Raw Data

**Purpose:** Sync raw Shopee export data from the staging load tables into the clean working tables. Handles both new records and updates to existing ones.

**What it does:**

**Part 1 — Orders upsert (`root_data.orders`)**
- Identifies new `ma_don_hang` (order IDs) in `root_data.order_all` that don't yet exist in `root_data.orders` → INSERTs them
- For existing orders, updates all 60+ columns — because Shopee orders can change status after export (e.g. pending → completed)
- Match key: `ma_don_hang` + `sku_san_pham` + `sku_phan_loai_hang`

**Part 2 — Product performance MERGE (`root_data.product_performance`)**
- Uses `MERGE` on `(thoi_gian, ma_san_pham, sku_san_pham, sku_phan_loai)` to upsert all 38 traffic/conversion metrics
- WHEN MATCHED → updates all performance fields
- WHEN NOT MATCHED → inserts new product-period records

---

#### `prc_insert_dim_tables` — Populate All Dimension Tables

**Purpose:** Truncate and rebuild all dimension tables from the clean `root_data` sources. Runs once per data refresh. Contains **20 steps**.

| Step | Dimension Table | Source | Logic |
|---|---|---|---|
| 1 | `dim_brands` | `root_data.sanpham` | RANK() by brand name; `-1` key for "No brand" |
| 2 | `dim_gender` | `root_data.sanpham` | RANK() by gender; `-1` for "không có" |
| 3 | `dim_strap_type` | `root_data.sanpham` | Material/strap type lookup |
| 4 | `dim_face_shape` | `root_data.sanpham` | Watch face shape lookup; `-1` for unknown |
| 5 | `dim_category` | `root_data.sanpham` | Product group (digital, fashion, luxury, accessories) |
| 6 | `dim_products` | `root_data.sanpham` + all dim joins | ROW_NUMBER() surrogate key; joins brands, gender, strap, face, category, campaign |
| 7 | `dim_district` | `root_data.orders` | Distinct `tp_quan_huyen` values |
| 8 | `dim_ward` | `root_data.orders` | Distinct `quan` values |
| 9 | `dim_city` | `root_data.orders` | Distinct `tinh_thanh_pho` values |
| 10 | `dim_customer` | `root_data.orders` | First-order date as register_dt; joins city/district/ward |
| 11 | `dim_variants_type` | `root_data.phanloai` | Variant color/style type |
| 12 | `dim_variants_size` | `root_data.phanloai` | Variant size (24mm, 32mm, Couple, etc.) |
| 12b | `dim_variants` | `root_data.phanloai` + dim joins | Stores `unit_cost` + `sale_price` per variant — critical for gross margin |
| 13a | `dim_campaign_group` | `root_data.campaign` | Bidding method grouping |
| 13b | `dim_campaign_status` | `root_data.campaign` | Active/stopped mapping |
| 13c | `dim_campaign` | `root_data.campaign` | Full campaign with start/end dates; `is_unlimited` flag |
| 14 | `dim_order_status` | `root_data.orders` | Normalized status mapping: Đã hủy=0, Hoàn trả=-1, … Hoàn thành=6 |
| 15a | `dim_order_cancel_reason` | `root_data.orders` | Distinct cancellation reasons |
| 15b | `dim_payment_method` | `root_data.orders` | Distinct payment methods |
| 16 | `dim_date` | `generate_series` | Full date spine 2020–2035 with day/week/month/quarter/year/weekend |
| 17 | `dim_profit_and_loss` | `dim_fee_type` + hardcoded entries | P&L line codes: C (credit) = paid_revenue, pending_revenue; D (debit) = unit_cost, fees |
| 18 | `dim_products_metrics` | Hardcoded | 5 metrics: views, clicks, exits, add-to-cart, orders |
| 19 | `dim_customer_metrics` | Hardcoded | 17 metrics: customer counts, order counts, revenue, behavior flags |
| 20 | `dim_monthly_risk_management_metrics` | Hardcoded | 13 metrics: order volume, refund/return counts, GMV variants |

---

#### `prc_insert_fact_tables` — Compute All Fact Tables

**Purpose:** Truncate and rebuild all fact tables from the modeled dimension tables and cleaned raw data. Contains **10 steps**.

| Step | Fact Table | Grain | Key Logic |
|---|---|---|---|
| 1 | `fact_order_fee` | 1 row per order × fee type | 7 fee types: fixed_fee, payment_fee, service_fee, piship_fee (0.985% of `gia_goc`), discount_fee, vat_fee (1%), income_tax_fee (0.5%) |
| 2 | `fact_txn_orders` | 1 row per order | Groups multi-SKU rows; joins dim_customer, dim_date, dim_order_status, dim_payment_method; order status mapped with CASE logic |
| 3 | `fact_order_detail` | 1 row per order × SKU × variant | Joins variant cost history via `face_variant_cost_history` (valid_from/valid_to SCD) for accurate historical COGS |
| 4 | `fact_product_performance` | 1 row per product × period | Filters parent-level rows only from `root_data.product_performance` (where `ten_phan_loai = '-'`) |
| 5 | `fact_campaign_performance` | 1 row per campaign × product × date | Total fee = conversions × cost_per_conversion; joins `dim_products` by product name |
| 6 | `fact_daily_profit_and_loss` | 1 row per date × P&L line | Full spine (date × pl_id) with COALESCE(0); revenue split by order_status_id (paid vs pending); fees joined from fact_order_fee; fixed monthly costs (17,000 + 50,000 VND) allocated per day |
| 7 | `fact_monthly_profit_and_loss` | 1 row per month × P&L line | Aggregated from daily P&L; month_key = YYYYMM |
| 8 | `fact_annually_profit_and_loss` | 1 row per year × P&L line | Aggregated from daily P&L; date_key = YYYY |
| 9 | `fact_monthly_products_performance` | 1 row per month × brand × category × metric | Unpivots 5 metrics (views, clicks, exits, add-to-cart, orders) into narrow format for Power BI |
| 10a | `fact_customer_monthly_metrics` | 1 row per month × customer × metric | 12 CTEs: monthly base → first purchase → purchase history → has_prior_purchase → lifetime → days since last order → final unpivot to 13 metric IDs |
| 10b | `fact_monthly_risk_management` | 1 row per month × city × district × product × brand × category × payment method × metric | Spine of all combinations × 13 metrics; LEFT JOIN 13 aggregation CTEs (m1–m13) for total/completed/canceled/delivered orders + refund/return counts + GMV variants |

---

### 2.5 Dashboard Mockups & Output

**🔗 Power BI Report:** *(link)*

Below are detailed mockups of each dashboard with their key metrics and layout.

---

#### 📊 Dashboard 1 — P&L Tracking

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│  PROFIT AND LOSS TRACKING          [Year: 2026 ▼]  [Month: May ▼]              │
├──────────────┬──────────────┬──────────────┬──────────────────────────────────┤
│ Total Revenue│ Total Unit   │ Total        │ Net Profit                        │
│  34,491,000  │ Cost         │ Expense      │  7,010,845                        │
│              │  15,060,000  │  12,420,155  │  ▲ MoM +2.7%                     │
│ ▲ MoM +17.4% │  GPM: 56.34% │ 2026: 52.92M │  2026 YTD: 35.4M                 │
├──────────────┴──────────────┴──────────────┴──────────────────────────────────┤
│                    Gross vs Net Margin (Line Chart)                             │
│  60% ─────────────────────────────────────── 56.34% (Gross)                   │
│  40%                                                                            │
│  20% ─────────────────────────────────────── 20.33% (Net)                     │
│       Jan      Feb      Mar      Apr      May                                  │
├────────────────────────────────┬───────────────────────────────────────────────┤
│  Monthly Performance (Bar)     │  Operating Expense Structure (Donut)          │
│  44M ████                      │                                               │
│  34M ████ ████ ████ ████ ████  │   Platform Fee  ████████████  80.69%          │
│       Jan  Feb  Mar  Apr  May  │   Marketing Fee ██           12.69%           │
│  ■ Revenue ■ Expense ■ Profit  │   Shipping      █             2.62%           │
└────────────────────────────────┴───────────────────────────────────────────────┘
Key Insight (Digital Marketing lens): Platform fees = 81% of opex.
Every incremental ad spend has outsized margin impact — audit ROI before scaling.
```

---

#### 👥 Dashboard 2 — Customer Acquisition & Retention

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│  CUSTOMER ACQUISITION & RETENTION         [Year: 2026 ▼]  [Month: May ▼]      │
├──────────────┬──────────────┬──────────────┬────────────────────────────────── ┤
│ Total        │ New          │ Returning    │ Retention Rate                    │
│ Customers    │ Customers    │ Customers    │  9.26%                            │
│     108      │     98       │     10       │  Avg 2026: 4.45%                  │
│              │ ▼ MoM -14%   │ ▲ MoM +233% │                                   │
├──────────────┴──────────────┴──────────────┴──────────────────────────────────┤
│   Monthly Customer Volume & Retention Rate Trend (Bar + Line)                  │
│                                                      ●  9.26%                  │
│   200 ████████████████████████████████████████  ●                              │
│   100 ████████████████████████████████████████                                 │
│        Jan      Feb      Mar      Apr      May                                  │
│   ■ New Customers  ■ Returning  ─── Retention Rate                             │
├────────────────────────────────┬───────────────────────────────────────────────┤
│  City Breakdown (Table)        │  New vs Returning (Donut)                     │
│  City             New  Return  │                                               │
│  TP. Hồ Chí Minh   41    2    │         90.74% New                            │
│  Tỉnh Đồng Nai     10    0    │       ○         9.26% Returning               │
│  Thành phố Cần Thơ  4    2    │                                               │
│  Tỉnh Vĩnh Long     4    0    │                                               │
├────────────────────────────────┴───────────────────────────────────────────────┤
│  MoM% New Customer Growth Rate (Line)                                          │
│  +41.07%    ●                                                                  │
│  +14.29% ●     ●  -5.56%                                                       │
│  -15.52%●          ● -31.65%                                                   │
│   Jan    Feb   Mar   Apr    May                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
Key Insight (Marketing lens): HCMC retention 4.65% — Cần Thơ at 33.33%.
Returning customers in smaller cities are more loyal; test re-engagement campaigns there.
```

---

#### 🛒 Dashboard 3 — Traffic & Conversion Performance

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│  TRAFFIC & CONVERSION PERFORMANCE    [Casio][DW][Longines][Movado][No brand]   │
├──────────────┬──────────────┬──────────────┬────────────────────────────────── ┤
│   Views      │   Clicks     │  Add to Cart │  Completed Orders                 │
│   153,062    │    7,067     │     887      │     111                           │
│ ▼ MoM -8.2%  │ ▲ CTR +2.2% │ ▼ MoM -14.2% │ ▼ MoM -6.7%                      │
│ Avg: 172,071 │ Avg: 7,601  │ Avg: 981    │  Avg: 119                          │
├──────────────┴──────────────┴──────────────┴──────────────────────────────────┤
│  Monthly Interaction Trends (Bar + Line)    │  Purchase Funnel (Horizontal Bar)│
│                                              │                                  │
│  10K ████                                   │  Clicks         7,067 ████████  │
│   5K ████ ████ ████ ████ ████               │  Add to Cart      887 ██  12.6% │
│        Jan  Feb  Mar  Apr  May              │  Completed Ord.   111 █   1.57% │
│  ── Conversion Rate                         │                   1.6% overall  │
├────────────────────────────────┬───────────────────────────────────────────────┤
│  Traffic by Category (Treemap) │  Brand Matrix: CTR vs Conversion (Scatter)   │
│  ┌──────────────┬──────────┐  │                                               │
│  │ đồng hồ điện│ đồng hồ  │  │  3% │            ● Casio (bubble=volume)      │
│  │ tử Casio    │ thời trang│  │  2% │  ● Pindows                             │
│  │   53,058    │  Movado   │  │  1% │                    ● DW  ● Movado       │
│  ├─────────────┤   37,655  │  │  0% │ ● Longines                             │
│  │ DW  26,172  ├──────────┤  │     └────────────────────────────────────    │
│  └─────────────┘  luxury   │  │      2%   3%   4%   5%   6%  (CTR →)        │
│                   25,489   │  │  Dashed line = avg conversion benchmark      │
└────────────────────────────┴───────────────────────────────────────────────────┘
Key Insight (Marketing lens): DW has high CTR (~6%) but below-benchmark conversion.
Ad budget for DW is attracting window-shoppers. A/B test price anchoring or bundle offers.
```

---

#### ⚠️ Dashboard 4 — Order Fulfillment Risk & Loss Management

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│  ORDER FULFILLMENT RISK & LOSS MANAGEMENT    [Casio][DW][Longines][Movado]     │
├──────────────┬──────────────┬──────────────┬────────────────────────────────── ┤
│ Canceled     │ Cancellation │ Returned     │ Returned Order Rate               │
│  Orders: 32  │   Rate       │  Orders: 3   │     2.05%                         │
│ ▼ MoM -21%   │   21.92%     │ ▼ MoM -50%   │  Avg 2026: 3.1%                   │
│ 2026 YTD:213 │ Avg: 24.8%   │ 2026 YTD: 26 │                                   │
├──────────────┴──────────────┴──────────────┴──────────────────────────────────┤
│  Monthly Fulfillment Risk Trends (Line)     │  Risk by City (Bar + Line)       │
│  30% ─────── cancellation ────────────      │                                  │
│  20%                                        │  HCMC     ████████████  ~22%     │
│  10%                                        │  Đ. Nai   ████         ~18%      │
│   0% ─── returned ────────────────          │  Cần Thơ  ██           ~15%      │
│       Jan    Feb   Mar   Apr   May          │  Cà Mau   ██████████   ~35% ⚠️  │
│  ── Total Orders (dotted)                   │  Vĩnh Long████████████  ~33% ⚠️  │
├────────────────────────────────┬───────────────────────────────────────────────┤
│  Risk by Category (Bar)        │  Risk by Payment Method (Bar + Line)          │
│                                │                                               │
│  đh điện tử  ████████  ~23%   │  COD         ████████████  26.6% ⚠️           │
│  đh thời trang ██████  ~18%   │  SPayLater   ████████      23.0%              │
│  đh luxury   ████      ~12%   │  Bank-linked ██████        18.5%              │
│  phụ kiện    ██        ~8%    │  ShopeePay   ████          14.3%              │
│                                │  Google Pay  ██             9.1% ✅           │
└────────────────────────────────┴───────────────────────────────────────────────┘
Key Insight: COD = 26.6% cancellation rate vs Google Pay = 9.1%.
Moving 20% of COD orders to prepaid would recover ~30 orders/month at current volume.
```

---

## 3. Insight Deep Dive

### 🔴 Insight 1: COD Is the Primary Revenue Leak

COD accounts for ~70% of orders but has a **26.6% cancellation rate** — nearly 3× higher than prepaid methods. The pattern concentrates in Cà Mau and Vĩnh Long (longer delivery windows), suggesting delivery time amplifies COD risk.

**Action (Marketing):** Voucher campaign targeting COD buyers in provincial cities to migrate to ShopeePay Wallet. Target: reduce COD share from 70% → 55% within 3 months.

---

### 🟡 Insight 2: Platform Fees Are a Margin Ceiling

Platform fees are **80.69% of operating costs**. Gross margin is healthy (49–56%) but net margin compression tracks directly with Shopee ad spend decisions — not product issues. Before scaling any campaign, ROI per campaign must be validated.

**Action (Marketing):** Monthly campaign audit — pause any ad with CTR-to-conversion below store average. Reallocate to Casio and fashion watches where conversion is proven.

---

### 🟢 Insight 3: Casio and Pindows Are the High-ROI Brands

In the Brand CTR × Conversion Matrix, Casio and Pindows sit **above the average conversion line** — meaning they convert better per click than their CTR would predict. DW has high CTR but below-average conversion (potential price/trust gap).

**Action (Marketing):** Increase Casio ad budget 20–30%. Run A/B test on DW listings: price anchor vs bundle offer to improve post-click conversion.

---

### 🟡 Insight 4: Untapped Geographic Market

Đồng Nai and Bình Dương already show organic demand with zero marketing investment. HCMC concentration creates single-market risk.

**Action (Marketing):** Test ₫50K/month paid acquisition in Đồng Nai first. Avoid Cà Mau and Vĩnh Long until pre-shipment COD verification is live.

---

### 🔴 Insight 5: Retention Is Growing but Base Remains Small

9.26% retention in May 2026 — but returning customers grew +233% MoM, signaling early traction. The 2026 YTD average is only 4.45%.

**Action (Marketing):** Post-purchase sequence: D+3 review request → D+30 accessory suggestion with 10% voucher → D+60 re-engagement offer. Estimated retention lift to 12–15% within 2 months.

---

## 4. Achievements (Jan 2025 → May 2026)

### Revenue Growth

| Period | Total Revenue | Net Profit | Avg NPM |
|---|---|---|---|
| 2024 (from May) | 93.20M VND | 6.29M VND | 6.8% |
| 2025 (full year) | 270.22M VND | 21.60M VND | 8.0% |
| 2026 (Jan–May) | ~162M VND | 35.4M VND | **~20%** |

Monthly revenue: **8.38M VND (May 2024) → 34.5M VND (May 2026)** — a **+311% increase** in run-rate.
Net profit margin: **~7% (2024) → ~20% (2026)**, driven by cost visibility and reduced discount dependency.

### Profitability Transformation

- Identified platform fees = 81% of opex → enabled targeted ad spend decisions
- Gross margin stabilized at 49–56% after volatile swings (48–79%) in 2024
- Eliminated loss months (Aug/Nov 2025) → consistent +4–9M VND/month profit in 2026

### Cancellation Risk Quantified

| Payment Method | Cancellation Rate |
|---|---|
| COD | **26.6%** |
| SPayLater | 23.0% |
| Bank-linked ShopeePay | 18.5% |
| ShopeePay Wallet | 14.3% |
| Google Pay | **9.1%** |

### Customer Base Built from Zero

- **1,979 unique customers** tracked across 2+ years
- Monthly new customers: **28 (May 2024) → 159 (Mar 2026)** — **+468% increase**
- Retention rate improved: **1.9% (Dec 2025) → 9.26% (May 2026)**

### Marketing Intelligence Delivered

- Confirmed Casio = **61% of all orders** → priority inventory + budget allocation
- Mapped luxury watch conversion gap → content strategy recommendation
- Identified DW as high-CTR/low-conversion outlier → A/B test recommendation
- First campaign performance dashboard linked ad spend to actual order outcomes

---

## 5. Value Gained

### Domain Knowledge

- Vietnamese e-commerce dynamics: COD dominance, Shopee platform fee structures, flash sale mechanics, seller campaign types (DVHT bidding)
- Watch product taxonomy: digital (điện tử), fashion (thời trang), luxury, accessories — and how each category behaves differently in CTR, conversion, and cancellation
- Shopee seller analytics: export format limitations, metric definitions (placed vs confirmed orders), platform incentive structures

### UI / UX

- Designed Power BI layouts for non-technical business owners — clarity over comprehensiveness
- Developed a "Simple Story" monthly report format: score → key metric → cause → action
- Business Health Score (0–100) calibrated iteratively with owner to ensure perceived accuracy

### Technical Skills

| Area | Skills |
|---|---|
| **Data Engineering** | Python ETL (pandas, openpyxl, sqlalchemy), idempotent upsert logic, schema versioning |
| **Database** | PostgreSQL, Star Schema design, stored procedures (3-procedure pipeline), SCD via `face_variant_cost_history` |
| **SQL Analytics** | CTEs, window functions (RANK, ROW_NUMBER, LAG), MERGE, UNION ALL unpivot patterns |
| **Visualization** | Power BI Desktop, DAX (MoM %, retention rate, rolling AOV, composite KPI score) |
| **Marketing Analytics** | CTR × Conversion matrix, campaign ROI analysis, cohort-based retention, geographic segmentation |
| **Import Mode** | Power BI Import Mode vs DirectQuery; pre-aggregated fact tables as performance pattern |

### Key Takeaways

- **Infrastructure before insight** — the 3-procedure pipeline was the most leveraged investment. Every new month's data flows automatically into all dashboards.
- **Marketing analytics needs business context** — CTR alone is meaningless without the cancellation rate data. Cross-domain visibility (BI + marketing) is what made the COD finding actionable.
- **COD risk is structurally underestimated** in Vietnamese e-commerce. It requires operational solutions, not more analytics.
- **Retention in long-cycle products needs custom benchmarks** — 9% retention for a physical watch business is not low; it just needs the right frame to communicate correctly.

---

## Tools & Tech Stack

| Layer | Tool | Purpose |
|---|---|---|
| **Data Ingestion** | Python (`pandas`, `openpyxl`, `sqlalchemy`) | Parse and load raw Shopee Excel exports |
| **Database** | PostgreSQL | Centralized storage with Star Schema (stg schema) |
| **Pipeline** | 3 Stored Procedures (PostgreSQL) | Upsert → Dimensions → Facts; full rebuild per refresh |
| **Exploration** | SQL (analytical queries) | Ad hoc analysis before visualization |
| **Visualization** | Power BI Desktop (Import Mode) | 4 dashboards + DAX measures |
| **Marketing Analytics** | Power BI + SQL | Campaign performance, CTR/conversion matrix, geographic segmentation |

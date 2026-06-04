# 🕐 Doonie Watch — Shopee Data Analytics Project

> **Note:** All metrics, data structures, and reporting frameworks belonging to the Doonie Watch brand have been authorized for public professional presentation via written consent by the business owner.

---

## 📌 Table of Contents

1. [Background Overview](#1-background-overview)
2. [Data Structure Overview](#2-data-structure-overview)
3. [Executive Summary](#3-executive-summary)
4. [Results & Impact](#4-results--impact)
5. [Insight Deep Dive](#5-insight-deep-dive)
6. [Recommendations](#6-recommendations)
7. [Tools & Tech Stack](#7-tools--tech-stack)
8. [Challenges & Lessons Learned](#8-challenges--lessons-learned)

---

## 1. Background Overview

**Role:** Freelance Data Consultant (Outsource)
**Duration:** May 2025 – Present
**Client:** Doonie Watch — a Shopee-based watch retailer with 2+ years of operation

Doonie Watch had been selling watches on Shopee for over two years but faced a critical **raw data crisis** as the business scaled: revenue reporting was inconsistent, cash flow visibility was poor, and operational inefficiencies were compounding — most visibly in a **24.06% order cancellation rate** caused by fragmented, unstructured data exports from Shopee's platform.

I was retained to fix the root problem — not just produce charts, but build a **data infrastructure** from scratch that would give the business owner real decision-making power.

**Scope of work:**

- Designed and implemented a centralized relational database from raw Shopee export files
- Built automated data ingestion pipelines using Python
- Modeled data using a **Star Schema** (Dimension & Fact tables)
- Developed **4 interactive Power BI dashboards** covering all core business domains
- Delivered ongoing monthly analysis and strategic recommendations

**Data Pipeline (End-to-End):**

```
Shopee Raw Data
      │
      ▼
Automatic Data Ingestion (Python)
      │
      ▼
Centralized Database
      │
      ▼
Data Modeling (Dim / Fact Tables)
      │
      ▼
Data Exploration
  ├── Product Performance
  ├── Customer Segment
  ├── Profit & Loss
  ├── E-Commerce Performance
  └── Operation Risk
      │
      ▼
Interactive Dashboards (Power BI / DAX)
  ├── Increase Revenue
  ├── Increase Profit
  ├── Reduce Cost
  └── Reduce Risk
```

---

## 2. Data Structure Overview

The database follows a **Star Schema** design — optimized for analytical queries and Power BI data modeling.

### Entity Relationship Diagram

```
dim_customer ──────────────────────────── fact_txn_orders
  key_customer_id (PK)                     transaction_order_id (PK)
  customer_id                              order_id
  customer_name                            key_customer_id (FK)
  city_key                                 total_price
                                           payment_method_id

                                                │
                                                ▼
                                        fact_order_detail
                                          order_id (FK)
                                          key_product_id (FK)
                                          key_variants_id (FK)
                                          total_price
                                          quantity
                                              │           │
                                              ▼           ▼
                                       dim_variants   dim_products
                                       key_variants_id  key_product_id (PK)
                                       key_product_id   product_name
                                       unit_cost        key_category_id
                                       sale_price
```

**Schema Rationale:**

- `fact_txn_orders` — captures every transaction at the order level, linked to customers and payment metadata
- `fact_order_detail` — line-item breakdown per order, enabling product-level profitability analysis
- `dim_customer` — customer master with geographic data for segmentation
- `dim_products` + `dim_variants` — product catalog with cost and pricing at the variant level (critical for accurate gross margin calculations)

This structure enables efficient slicing across time, product, customer geography, and payment method — all key dimensions for Shopee seller analytics.

---

## 3. Executive Summary

> **Analyzed Period: May 2026 | Business Health Score: 82 / 100**

The business is in a strong growth phase with healthy profitability, but is being held back by one persistent operational risk.

| Metric | Value | Trend |
|---|---|---|
| Total Revenue | 33.56M VND | ▲ +14.9% MoM ✅ |
| Net Profit | 5.30M VND | ▼ -20.5% MoM 🔴 |
| Net Profit Margin | 15.8% | ▼ -30.8% MoM 🔴 |
| Gross Profit Margin | 53.7% | ▼ -3.8% MoM 🔴 |
| Total Orders | 146 | ▼ -15.6% MoM 🔴 |
| Cancellation Rate | **21.92%** | ▼ -21.0% MoM ✅ (improving) |
| Conversion Rate | 1.60% | ▲ +1.2% MoM ✅ |
| Product Views | 153.1K | ▼ -8.2% MoM 🔴 |
| Avg Order Value (AOV) | 296,956 VND | ▲ +21.0% MoM ✅ |
| Total Customers (Historical) | 1,979 | ▲ growing |
| New Customers (This Month) | 100 | ▼ -12.3% MoM 🔴 |
| Customer Retention Rate | 9.09% | ▲ +254.5% MoM ✅ |

**Bottom Line:** Revenue is growing strongly (+14.9% MoM) and the business is structurally profitable. The single most pressing issue is the **21.92% cancellation rate** — more than 1 in 5 orders never completes, directly draining revenue and logistics resources. Alongside this, **customer retention at ~9%** signals a structural gap in post-purchase engagement that limits long-term revenue compounding.

---

## 4. Results & Impact

> Numbers extracted directly from raw data across the full engagement period (May 2024 – May 2026).

### 📈 Revenue Growth

The business grew from a fragmented early-stage operation to a structurally profitable store. Monthly revenue scaled from **8.38M VND (May 2024)** to a peak of **42.39M VND (March 2026)** — a **+406% increase** in monthly revenue run-rate.

| Period | Total Revenue | Net Profit | Avg NPM |
|---|---|---|---|
| 2024 (from May) | 93.20M VND | 6.29M VND | 6.8% |
| 2025 (full year) | 270.22M VND | 21.60M VND | 8.0% |
| 2026 (Jan–May) | ~160M VND | 31.47M VND | **19.7%** |

Net profit margin **nearly tripled** from ~7% in 2024–2025 to ~20% by 2026 — the direct result of better cost visibility, reduced discount dependency, and operational discipline enabled by the dashboards.

### 💰 Profitability Transformation

Before the data infrastructure was in place, the business had no reliable way to track operating expenses by category. Post-implementation:

- Identified that **platform fees account for ~81% of operating costs**, enabling targeted ad spend optimization
- Gross profit margin stabilized around **49–56%** in 2026 after volatile swings in 2024 (48–79%)
- Net profit shifted from loss months (Aug 2025: **-0.07M VND**; Nov 2025: **-0.40M VND**) to consistently **+4–9M VND/month** in 2026

### ⚠️ Cancellation Risk — Made Visible and Quantified

The cancellation problem was already hurting the business before the Risk Dashboard existed — it just wasn't measured. Post-implementation it became a trackable, drillable metric:

| Payment Method | Total Orders | Cancellation Rate |
|---|---|---|
| Thanh toán khi nhận hàng (COD) | 1,633 | **26.6%** |
| SPayLater | 230 | 23.0% |
| TK Ngân hàng liên kết ShopeePay | 357 | 18.5% |
| Ví ShopeePay | 56 | 14.3% |
| Google Pay | 22 | **9.1%** |

This data directly supported the recommendation to incentivize prepaid payment methods — moving customers from COD to ShopeePay Wallet or Google Pay alone could halve the cancellation rate.

### 👥 Customer Base Built from Zero

When the engagement started in May 2024, there was no structured customer database. By May 2026:

- **1,979 unique customers** acquired and tracked across 2+ years
- Monthly new customer acquisition grew from **28/month (May 2024)** to **159/month (March 2026)** — a **+468% increase**
- Retention rate trended upward through 2026: from 1.9% (Dec 2025) to **9.1% (May 2026)**, indicating early traction from post-purchase engagement improvements

### 🛒 Product & Brand Intelligence Unlocked

Before the E-Commerce Performance dashboard, the owner had no visibility into which brands and categories were actually converting vs. just attracting traffic. Key data findings (2026 YTD):

| Brand | Orders | Category |
|---|---|---|
| Casio | 364 | Digital watches |
| Movado | 133 | Fashion watches |
| DW | 93 | Fashion watches |
| Longines | 7 | Luxury watches |

- **Casio alone drives 61% of all orders** — confirmed as the core revenue engine requiring priority inventory and marketing
- **Fashion watches** capture the most traffic: 443,447 views (52% of store total), validating the category focus
- **Luxury watches** attract substantial views (132,471) but barely convert — pointing to a trust/pricing gap addressable with content strategy

---

## 5. Insight Deep Dive

### 🔴 Insight 1: Cancellation Rate Is the #1 Business Risk

**Metric:** Cancellation Rate = 24.06% (32 canceled / 133 total orders in May)
**YTD:** 213 canceled orders in 2026, avg 24.8% per month

The Risk Dashboard reveals that **Cash on Delivery (COD)** is the dominant payment method and the primary source of failed transactions. COD orders have a cancellation rate far above other payment methods (ShopeePay, bank transfer, credit card), suggesting the failure mode is **customer-side**: impulsive purchases followed by refusal upon delivery, or unavailability at the shipping address.

The cancellation problem is not random — it is concentrated in specific cities and product categories, making it a **targetable** operational issue.

---

### 🟡 Insight 2: Profitability Is Healthy But Margin Is Compressing

**Metric:** NPM = 21.8% in April (peak) → 15.78% in May and projected 15.28% in June

Despite operational pressure, the business maintains a positive profit structure. However, the P&L Dashboard shows a **downward trend in net profit margin** over the last two months. Operating expenses are dominated by **platform fees (80.98%)**, with marketing fees (12.37%) and shipping (2.64%) as secondary costs.

The gross margin (~53-55%) has been relatively stable, which means the compression is driven by operating cost growth outpacing revenue — a signal to scrutinize platform fee triggers (ads, featured listings) versus organic sales performance.

---

### 🟢 Insight 3: Fashion & Digital Watches Are Traffic Engines

**Metric:** Traffic by category — Fashion Watches: 69,069 views | Digital Watches: 54,925 views | Luxury: 29,068 views

The E-Commerce Performance Dashboard confirms that **fashion watches (đồng hồ thời trang)** and **digital watches (đồng hồ điện tử)** capture nearly 85% of total product views. In the Brand Matrix (CTR vs. Conversion Rate), **Casio and Pindows** occupy strong positions with above-average conversion rates relative to their CTR.

Luxury watches receive significantly fewer views but represent a higher-AOV opportunity that is currently under-marketed.

---

### 🟡 Insight 4: HCMC Dominates — Geographic Concentration Is a Double-Edged Sword

**Metric:** TP. Hồ Chí Minh = 213 new customers (2026 YTD), far ahead of Đồng Nai (29), Bình Dương (22), Hà Nội (18)

HCMC concentration simplifies logistics and delivery reliability. However, the business is exposed to a **single-market risk**: any platform-level disruption, local competitor entry, or seasonal demand shift in HCMC would have outsized impact. Meanwhile, neighboring provinces (Đồng Nai, Bình Dương, Cần Thơ) show organic demand with zero targeted marketing investment.

Notably, the cancellation rate **spikes in certain provincial cities** (Tỉnh Cà Mau, Tỉnh Vĩnh Long), likely due to longer delivery times increasing COD refusal risk.

---

### 🔴 Insight 5: Retention Is Critically Low

**Metric:** Retention Rate = 10.08% (May), Avg 2026 = 4.41% | 13 returning vs. 116 new customers

The Customer Dashboard shows the business is almost entirely dependent on **new customer acquisition** to sustain revenue. Returning customers made up only 9.09% of May's order volume. For a watch business — where the natural repurchase cycle is long — this is expected to a degree, but the current retention rate leaves significant untapped revenue on the table.

The returning customer MoM trend is actually **improving sharply (+233.3% MoM)**, which suggests early retention efforts may be gaining traction, but the base remains small.

---

## 6. Recommendations

### 1. 🔴 Fix COD Cancellations — Pre-Shipment Verification

Introduce a mandatory **confirmation step before dispatch** for all COD orders: an automated Shopee chat message or a brief phone call. This single intervention could recover 10-15% of currently lost orders. Additionally, consider offering small incentives (discount voucher, free shipping) to nudge high-AOV customers from COD to prepaid payment methods.

### 2. 🟡 Defend and Grow Net Margin

Audit all active advertising and featured listing spend on Shopee — platform fees are 81% of operating costs. Identify which campaigns are driving conversions vs. which are generating views without sales. Reallocate budget toward high-converting categories (Casio, fashion watches) and reduce spend on low-conversion SKUs.

### 3. 🟢 Build a Retention Engine

With AOV at ~331K VND and a healthy product catalog, even a modest retention improvement would compound significantly. Immediate actions:
- Post-purchase message sequence (review request → accessory suggestion → 60-day voucher)
- Birthday/anniversary reminders (collect dates at checkout)
- "Watch care" content series to maintain brand touchpoints between purchase cycles

### 4. 🟢 Expand to Tier-2 Markets Selectively

Target Đồng Nai and Bình Dương first — they already show organic demand with no marketing investment. Avoid provincial cities with high COD cancellation rates (Cà Mau, Vĩnh Long) until the verification system is in place.

### 5. 🟡 Prioritize Fashion & Digital Watch Inventory

These two categories drive 85% of traffic. Ensure sufficient inventory depth, prioritize them in homepage placement and promotional campaigns, and use them as the entry point for upselling into higher-margin luxury watches.

---

## 7. Tools & Tech Stack

| Layer | Tool | Purpose |
|---|---|---|
| **Data Ingestion** | Python (`pandas`, `openpyxl`, `sqlalchemy`) | Automated parsing and loading of raw Shopee CSV/Excel exports into the database |
| **Database** | SQL (Relational DB) | Centralized storage with Star Schema modeling (Dim/Fact tables) |
| **Data Modeling** | SQL (DDL + Views) | Defining relationships, building aggregation views for Power BI |
| **Data Exploration** | SQL (analytical queries) | Ad hoc querying to identify patterns before visualization |
| **Visualization** | Power BI Desktop | 4 interactive dashboards with drill-through, filters, and KPI tracking |
| **Calculated Metrics** | DAX (Power BI) | Custom measures: retention rate, cancellation rate, rolling AOV, MoM %, business health score |
| **Reporting** | Power BI (scheduled refresh) | Monthly delivery to business owner with executive narrative |

**Dashboards Built:**

| Dashboard | Key Metrics |
|---|---|
| 📊 Business Overview | Health Score, Revenue, Net Profit, Conversion Rate, Returned Order Rate |
| 💰 Profit & Loss | GPM, NPM, Operating Expense Structure, Monthly Performance |
| 👥 Customer Acquisition & Retention | New vs. Returning, Retention Rate, Geographic Breakdown |
| 🛒 E-Commerce Performance | Views, Clicks, CTR, Add-to-Cart Rate, Conversion Funnel, Traffic by Category, Brand CTR vs. Conversion Matrix |
| ⚠️ Order Fulfillment Risk | Cancellation Rate, Return Rate, Risk by Payment Method, City, Brand |

---

## 8. Challenges & Lessons Learned

### Challenges

**1. Raw Data Was Fragmented and Inconsistent**
Shopee's export format changed between periods, and fields like `customer_id` and `order_id` were not reliably unique across exports. Significant time was spent on deduplication, key mapping, and building idempotent ingestion logic so new monthly exports wouldn't corrupt historical data.

**2. No Existing Data Culture**
The business owner had been making decisions based on Shopee's native summary screens — total orders, basic revenue. Introducing the concept of a data pipeline, Star Schema, and multi-dimensional analysis required ongoing explanation before the dashboards became trusted tools rather than just pretty charts.

**3. COD Cancellation Was Misattributed**
Early assumptions blamed product quality or logistics delays. Data analysis revealed the real driver was payment method — a non-obvious finding that required cross-referencing the order detail fact table with payment metadata across multiple months.

**4. Defining a Useful "Business Score"**
Compressing the health of a business into a single score (0–100) required iterative calibration with the owner — weighting margin, retention, cancellation, and conversion in a way that felt accurate and actionable rather than arbitrary.

### Lessons Learned

- **Infrastructure before insight** — the most valuable work was building a reliable, scalable database, not the dashboards themselves. Clean data multiplies the value of every subsequent analysis.
- **Framing matters more than accuracy** — a technically correct metric that the stakeholder doesn't trust or understand has zero business impact. Investing in narrative (the "Simple Story" format) was as important as the numbers.
- **COD risk is underestimated in Vietnamese e-commerce** — the platform's default payment method creates a structural cancellation problem that requires operational, not analytical, solutions.
- **Retention metrics in long-cycle product categories need custom benchmarks** — standard SaaS retention benchmarks don't apply to physical goods with 1-2 year repurchase cycles. Custom cohort analysis was necessary to contextualize the 10% retention rate accurately.

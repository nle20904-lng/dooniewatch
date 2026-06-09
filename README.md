# 🕐 Doonie Watch — Shopee Data Analytics

> **⚠️ IMPORTANT NOTICE**
> **<span style="color:red">The data used in this project has been masked and is used with the explicit written permission and consent of the shop owner.</span>**

---

## 📌 Table of Contents

1. [1. Background & Context](#1-background--context)
2. [2. Process - Step by Step](#2-process---step-by-step)
3. [3. Insight Deep Dive](#3-insight-deep-dive)
4. [4. Achievements (Jan 2025 - May 2026)](#4-achievements-jan-2025---may-2026)
5. [5. Value Gained](#5-value-gained)

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

![image alt]()

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
 
---
 
## 2. Process — Step by Step
 
### 2.1 Data pipeline
 
![image alt]()
 
### 2.2 Input data
 
Full column definitions → [`data dictionary/data_dictionary_input.md`](./data%20dictionary/data_dictionary_input.md)
 
| File | Columns | Contents |
|---|---|---|
| `Order_all_YYYYMMDD.xlsx` | 62 | Orders, pricing, shipping, payment method, buyer address, platform fees |
| `parentskudetail_YYYYMMDD.xlsx` | 40 | Views, clicks, CTR, conversion rates, add-to-cart, repeat purchase |
 
### 2.3 DB Diagrams
 
Full schema → [`data dictionary/data_dictionary_output.md`](./data%20dictionary/data_dictionary_output.md)
 
![image alt]()
 
### 2.4 Stored procedures
 
Three procedures, called in sequence each month:
 
```sql
call stg.prc_update_status_fact_txn_orders();  -- upsert raw orders + product performance
call stg.prc_insert_dim_tables();              -- rebuild all 20 dimension tables
call stg.prc_insert_fact_tables();             -- compute all 10 fact tables
```
 
| # | Procedure | Purpose |
|---|---|---|
| 01 | `prc_update_status_fact_txn_orders` | Upserts new orders and updates status changes. Merges product performance via MERGE. |
| 02 | `prc_insert_dim_tables` | Rebuilds all 20 dimension tables — brands, categories, variants, customers, geography, dates, campaigns, P&L line codes. |
| 03 | `prc_insert_fact_tables` | Computes all 10 fact tables — daily/monthly P&L, customer metrics (12-CTE pipeline), risk spine (13 metrics × all dimensions). |
 
### 2.5 Dashboard
 
## P&L Tracking

This report recreates a standard P&L structure on a monthly basis, helping the team see where revenue is coming from, which cost layers are eating into profit, and where the actual margin stands compared to prior periods.

**Revenue & Cost of Goods**
- Total Revenue — net revenue from completed orders in the month, with MoM growth
- Total Unit Cost — total cost of goods sold, reflecting the Gross Profit Margin (GPM)

**Operating Expenses (OpEx)**
- Platform Fee — Shopee platform fee
- Shipping Fee — delivery costs
- Marketing Fee — in-platform advertising spend
- Tax Fee — applicable taxes

**Profitability**
- Net Profit — bottom-line profit after all costs, with MoM growth
- Gross Profit Margin (%) and Net Profit Margin (%) tracked month by month

This report allows the team to immediately spot months where gross margin holds steady but net margin shrinks due to rising platform fees, or where revenue grows but net profit doesn't follow because operating costs exceed the threshold.

![image alt]()
---

## Customer Acquisition & Retention

This report tracks the quality of the customer base — not just headcount, but a clear split between new and returning customers — to evaluate acquisition effectiveness and buyer loyalty.

**Overview Metrics**
- Total Customers — total customers in the month
- New Customers — first-time buyers, with MoM growth
- Returning Customers — repeat buyers, with MoM growth
- Retention Rate (%) — compared against the annual average

**Detailed Breakdown**
- New vs. Returning trend by month
- MoM% new customer growth rate — highlights months where acquisition is slowing
- Breakdown by city — New Customer Rate and Retention Rate by province/city

With this report, the team can observe that retention is sitting at a low level (~4–9%), meaning most customers only buy once, which raises the question of whether to prioritize retaining existing customers or continuing to invest in new customer acquisition.

![image alt]()

---

## Traffic & Conversion Performance

This report tracks the full funnel from product impressions to completed orders, pinpointing exactly which step in the purchase journey is causing the biggest drop-off.

**Funnel Metrics**
- Views — total product impressions, with MoM change
- Clicks — product click volume and Click-Through Rate (CTR), with MoM change
- Add To Cart — cart additions, with MoM change
- Completed Orders — fulfilled orders, with MoM change and overall Conversion Rate

**Deep-Dive Analysis**
- Drop-off Funnel — step-by-step fall-off rate: from 7,067 clicks to 887 add-to-carts (12.55%) to 111 completed orders (1.57%)
- Traffic Distribution by Product Category — which categories are driving the most traffic
- Brand Matrix (CTR vs. Conversion Rate) — identifies brands with high traffic but weak conversion, and vice versa

This report tells the team exactly where the problem lies — low CTR points to product images and titles needing work; high add-to-cart but low conversion suggests an issue at checkout or with pricing.

![image alt]()

---

## Order Fulfillment Risk & Loss Management

This report monitors post-order risks — cancellations and returns — and breaks them down across multiple dimensions to identify which products, payment methods, or regions are driving the most revenue loss.

**Overview Metrics**
- Canceled Orders — cancellation volume and Cancellation Rate (%), benchmarked against the annual average
- Returned Orders — return volume and Returned Order Rate (%), benchmarked against the annual average

**Detailed Breakdown**
- Fulfillment Risk Trend — cancellation and return rate trends over time, plotted alongside total order volume
- Breakdown by Product Category — which categories show abnormally high cancellation or return rates
- Brand Performance Risk Matrix — scatter plot identifying brands with both high cancellation and high return rates simultaneously
- Order Vulnerability by Payment Method — which payment methods (COD, SPayLater, etc.) are associated with the highest cancellation rates
- Distribution by City — which regions consistently exceed average cancellation rates

Rather than simply reporting how many orders were canceled, this dashboard helps the team understand root causes — for example, COD accounting for the largest share of cancellations suggests a need to revisit payment policies, while an unusually high return rate in a specific category may point to product quality issues or misleading descriptions.

![image alt]()
 
---
 
## 3. Insight Deep Dive
 
### 🔴 COD is the #1 revenue leak
 
COD = ~70% of orders but 26.6% cancellation rate — 3× higher than prepaid. Concentrated in Cà Mau and Vĩnh Long (longer delivery windows).
 
![image alt]()
 
**Action →** Voucher campaign to migrate COD buyers to ShopeePay. Target: 70% → 55% COD share in 3 months.
 
---
 
### 🟡 Platform fees are a margin ceiling
 
Platform fees = 80.7% of opex. Net margin compression tracks directly to ad spend decisions, not product issues.
 
![image alt]()
 
**Action →** Monthly campaign audit — pause below-avg CTR-to-conversion ads, reallocate to Casio.
 
---
 
### 🟢 Casio and Pindows are the high-ROI brands
 
Both sit above the avg conversion line in the Brand CTR × Conversion Matrix. DW has high CTR but below-avg conversion (price/trust gap).
 
![image alt]()
 
**Action →** +20–30% Casio ad budget. A/B test DW: price anchor vs bundle offer.
 
---
 
### 🟡 Untapped geographic demand
 
Đồng Nai and Bình Dương show organic demand with zero marketing. HCMC concentration (~85% of customers) = single-market risk.
 
![image alt]()
 
**Action →** Test paid acquisition in Đồng Nai first. Hold Cà Mau/Vĩnh Long until COD verification is live.
 
---
 
### 🔴 Retention is low but trending up
 
9.26% retention in May 2026 — but +233% MoM growth in returning customers. 2026 YTD avg = 4.45%.
 
![image alt]()
 
**Action →** Post-purchase sequence: D+3 review request → D+30 accessory voucher → D+60 re-engagement.
 
---
 
## 4. Achievements (Jan 2025 → May 2026)
 
| Metric | Result |
|---|---|
| Monthly revenue run-rate | **+311%** (83.8M → 345M VND/month) |
| Net profit margin | **~7% → ~20%** |
| Monthly new customers | **+468%** (280 → 1590/month peak) |
| Unique customers tracked | **19,790** |
| Cancellation rate | **24% → 21.9%** (trending down) |
| 2025 total revenue processed | **2,70B+ VND** |
 
---
 
## 5. Value Gained
 
**Domain:** Vietnamese e-commerce & COD dynamics · Shopee fee structures & campaign types · Watch product taxonomy · Retention benchmarks for physical goods
 
**Technical:** Python ETL (pandas, openpyxl, sqlalchemy) · PostgreSQL Star Schema + SCD cost history · SQL CTEs / MERGE / window functions · Power BI DAX (MoM %, composite KPI score)
 
**Key lessons:**
- Infrastructure before insight — the 3-procedure pipeline is the leverage point
- CTR alone is meaningless without cancellation rate context (cross-domain BI + Marketing)
- COD risk needs operational solutions, not more analytics
- Retention benchmarks for physical goods need custom frames — 9% is not inherently bad
---
 
## Tools & Tech Stack
 
| Layer | Tool |
|---|---|
| Data Ingestion | Python — pandas, openpyxl, sqlalchemy |
| Database | PostgreSQL — Star Schema, 3 stored procedures |
| Visualization | Power BI Desktop — Import Mode, DAX |
| Marketing Analytics | Power BI + SQL — CTR/conversion matrix, campaign ROI |

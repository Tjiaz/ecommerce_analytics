# 🛒 E-Commerce Analytics Pipeline

A data engineering practice project that joins transactional order data with web clickstream events to analyze customer behavior — from first website visit to purchase.

---

## 📌 Project Overview

This project explores how to connect two common real-world data sources:

- **Orders data** (PostgreSQL) — transactional records of customer purchases
- **Clickstream data** (AWS Glue / Athena) — web event logs tracking user browsing behavior

The goal is to answer questions like:
- How long after a user's first website visit do they make a purchase?
- Which referral sources (Google, Instagram, newsletter, etc.) drive the most revenue?
- What devices are customers using before they convert?

### Key SQL Skills Practiced
- Cross-source joins (PostgreSQL + AWS Athena)
- Type casting and string manipulation (`CAST`, `REPLACE`)
- Aggregations (`COUNT DISTINCT`, `SUM`, `MIN`)
- Debugging type mismatch errors
- Data modeling — identifying and designing join keys

---

## 🏗️ Architecture

```
┌─────────────────────┐        ┌──────────────────────────────┐
│   PostgreSQL (RDS)  │        │   AWS S3 + Glue Data Catalog │
│                     │        │                              │
│  orders table       │        │  clickstream_events_v2       │
│  - user_id (int)    │        │  - user_id (varchar)         │
│  - order_id         │        │  - event_time                │
│  - total_amount     │        │  - page                      │
│  - cookie_id ◄──────┼────────┼─ user_id (e.g. user_7269)   │
└─────────────────────┘        │  - referrer                  │
                               │  - device                    │
                               └──────────────────────────────┘
                                            │
                                            ▼
                               ┌──────────────────────────────┐
                               │        Amazon Athena          │
                               │   (Federated Query Engine)   │
                               │                              │
                               │  Joins both sources using    │
                               │  cookie_id as the bridge key │
                               └──────────────────────────────┘
                                            │
                                            ▼
                               ┌──────────────────────────────┐
                               │       Analytics Output        │
                               │  - order_count per user      │
                               │  - total_revenue per user    │
                               │  - first_visit_time per user │
                               └──────────────────────────────┘
```

### Why `cookie_id`?
The orders table uses integer `user_id` (e.g. `101`) while clickstream uses a string format (e.g. `user_7269`) — these are different ID systems that cannot be joined directly. A `cookie_id` column was added to the orders table to act as a bridge, storing the matching clickstream user identifier captured at checkout.

---

## ⚙️ Setup Instructions

### Prerequisites
- AWS account with Athena and Glue Data Catalog configured
- PostgreSQL database (local or RDS)
- Athena federated query connector for PostgreSQL

### Step 1 — Set Up the Orders Table (PostgreSQL)

```sql
CREATE TABLE orders (
    order_id    SERIAL PRIMARY KEY,
    user_id     INTEGER NOT NULL,
    total_amount DECIMAL(10, 2),
    cookie_id   VARCHAR  -- bridge key to clickstream
);
```

Add the `cookie_id` mapping for existing users:

```sql
ALTER TABLE orders ADD COLUMN cookie_id VARCHAR;

UPDATE orders SET cookie_id = 'user_7269' WHERE user_id = 101;
UPDATE orders SET cookie_id = 'user_6250' WHERE user_id = 102;
UPDATE orders SET cookie_id = 'user_2045' WHERE user_id = 103;
UPDATE orders SET cookie_id = 'user_1455' WHERE user_id = 104;
UPDATE orders SET cookie_id = 'user_6569' WHERE user_id = 105;
UPDATE orders SET cookie_id = 'user_2558' WHERE user_id = 106;
UPDATE orders SET cookie_id = 'user_1708' WHERE user_id = 107;
UPDATE orders SET cookie_id = 'user_5490' WHERE user_id = 108;
UPDATE orders SET cookie_id = 'user_1473' WHERE user_id = 109;
UPDATE orders SET cookie_id = 'user_1084' WHERE user_id = 110;
```

### Step 2 — Configure Athena Federated Query

1. Go to **AWS Athena > Data Sources > Connect data source**
2. Choose **PostgreSQL** connector
3. Set up connection to your PostgreSQL instance
4. Your orders table will be queryable as:
   ```
   "orders_postgres"."public"."orders"
   ```

### Step 3 — Register Clickstream Data in Glue

Ensure your clickstream S3 data is catalogued in AWS Glue with the schema:

| Column | Type |
|---|---|
| event_time | TIMESTAMP |
| user_id | VARCHAR |
| page | VARCHAR |
| referrer | VARCHAR |
| device | VARCHAR |

It will be queryable in Athena as:
```
"AwsDataCatalog"."analytics"."clickstream_events_v2"
```

### Step 4 — Run the Analytics Query

```sql
SELECT 
    o.user_id,
    COUNT(DISTINCT o.order_id)  AS order_count,
    SUM(o.total_amount)         AS total_revenue,
    MIN(c.event_time)           AS first_visit_time
FROM "orders_postgres"."public"."orders" o
LEFT JOIN "AwsDataCatalog"."analytics"."clickstream_events_v2" c
    ON o.cookie_id = c.user_id
GROUP BY o.user_id
ORDER BY total_revenue DESC;
```

---

## 🐛 Debugging Notes

| Error | Cause | Fix |
|---|---|---|
| `TYPE_MISMATCH: integer = varchar` | Joining int column to string column | Use `CAST(REPLACE(c.user_id, 'user_', '') AS INTEGER)` or add a `cookie_id` bridge column |
| `first_visit_time` returns NULL | JOIN not matching — IDs from different systems | Ensure `cookie_id` is populated in orders table |

---

## 📁 Project Structure

```
├── README.md
├── sql/
│   ├── create_orders_table.sql
│   ├── seed_cookie_ids.sql
│   └── analytics_query.sql
└── data/
    └── clickstream_sample.csv
```

---

## 🚀 Future Improvements

- [ ] Automate `cookie_id` capture at checkout via application layer
- [ ] Add dbt models for transformation layer
- [ ] Build a dashboard in Metabase or Grafana
- [ ] Add referrer attribution analysis

---

*Built as part of a data engineering learning journey. Practicing SQL, AWS Athena federated queries, and cross-source data modeling.*

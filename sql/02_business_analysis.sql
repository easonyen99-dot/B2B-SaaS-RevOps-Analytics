-- ============================================
-- 01. SALES PERFORMANCE
-- Business Question:
-- How effectively does NovaFlow convert opportunities into customers?
-- ============================================

-- KPI 01: Overall Win Rate
SELECT
    COUNT(*) AS total_opportunities,
    SUM(CASE WHEN result = 'Closed Won' THEN 1 ELSE 0 END) AS closed_won,
    ROUND(
        SUM(CASE WHEN result = 'Closed Won' THEN 1 ELSE 0 END)
        / COUNT(*) * 100,
        2
    ) AS win_rate_pct
FROM opportunities;


-- KPI 02: Win Rate by Lead Source
SELECT
    l.lead_source,
    COUNT(*) AS total_opportunities,
    SUM(CASE WHEN o.result = 'Closed Won' THEN 1 ELSE 0 END) AS closed_won,
    ROUND(
        SUM(CASE WHEN o.result = 'Closed Won' THEN 1 ELSE 0 END)
        / COUNT(*) * 100,
        2
    ) AS win_rate_pct
FROM opportunities o
JOIN leads l
    ON o.lead_id = l.lead_id
GROUP BY l.lead_source
ORDER BY win_rate_pct DESC;


-- KPI 03: Sales Cycle by Lead Source
SELECT
    l.lead_source,
    COUNT(*) AS closed_won,
    ROUND(
        AVG(DATEDIFF(o.close_date, o.created_date)),
        1
    ) AS avg_sales_cycle_days
FROM opportunities o
JOIN leads l
    ON o.lead_id = l.lead_id
WHERE o.result = 'Closed Won'
  AND o.close_date IS NOT NULL
GROUP BY l.lead_source
ORDER BY avg_sales_cycle_days ASC;


-- KPI 04: Average Deal Value by Lead Source
SELECT
    l.lead_source,
    COUNT(*) AS closed_won,
    ROUND(AVG(o.deal_value), 2) AS avg_deal_value
FROM opportunities o
JOIN leads l
    ON o.lead_id = l.lead_id
WHERE o.result = 'Closed Won'
GROUP BY l.lead_source
ORDER BY avg_deal_value DESC;


-- KPI 05: Total Deal Value by Lead Source
SELECT
    l.lead_source,
    COUNT(*) AS closed_won,
    ROUND(SUM(o.deal_value), 2) AS total_deal_value
FROM opportunities o
JOIN leads l
    ON o.lead_id = l.lead_id
WHERE o.result = 'Closed Won'
GROUP BY l.lead_source
ORDER BY total_deal_value DESC;
-- ============================================
-- 02. REVENUE HEALTH
-- Business Question:
-- How is NovaFlow's recurring revenue performing over time?
-- ============================================

-- KPI 06: Current MRR and ARR
SELECT
    revenue_month,
    ROUND(SUM(ending_mrr), 2) AS current_mrr,
    ROUND(SUM(ending_mrr) * 12, 2) AS current_arr
FROM monthly_revenue
WHERE revenue_month = (
    SELECT MAX(revenue_month)
    FROM monthly_revenue
)
GROUP BY revenue_month;


-- KPI 07: Monthly MRR Trend
SELECT
    revenue_month,
    ROUND(SUM(ending_mrr), 2) AS total_mrr
FROM monthly_revenue
GROUP BY revenue_month
ORDER BY revenue_month;


-- KPI 08: Monthly MRR Growth Rate
WITH monthly_mrr AS (
    SELECT
        revenue_month,
        SUM(ending_mrr) AS total_mrr
    FROM monthly_revenue
    GROUP BY revenue_month
),
mrr_with_previous AS (
    SELECT
        revenue_month,
        total_mrr,
        LAG(total_mrr) OVER (
            ORDER BY revenue_month
        ) AS previous_month_mrr
    FROM monthly_mrr
)
SELECT
    revenue_month,
    ROUND(total_mrr, 2) AS total_mrr,
    ROUND(previous_month_mrr, 2) AS previous_month_mrr,
    ROUND(
        (total_mrr - previous_month_mrr)
        / NULLIF(previous_month_mrr, 0) * 100,
        2
    ) AS mrr_growth_rate_pct
FROM mrr_with_previous
ORDER BY revenue_month;
-- ============================================
-- 03. RETENTION
-- Business Question:
-- How effectively does NovaFlow retain recurring revenue?
-- ============================================

-- KPI 09: Monthly GRR
SELECT
    revenue_month,
    ROUND(SUM(starting_mrr), 2) AS starting_mrr,
    ROUND(SUM(contraction_mrr), 2) AS contraction_mrr,
    ROUND(SUM(churn_mrr), 2) AS churn_mrr,
    ROUND(
        (
            SUM(starting_mrr)
            - SUM(contraction_mrr)
            - SUM(churn_mrr)
        ) / NULLIF(SUM(starting_mrr), 0) * 100,
        2
    ) AS grr_pct
FROM monthly_revenue
GROUP BY revenue_month
HAVING SUM(starting_mrr) > 0
ORDER BY revenue_month;


-- KPI 10: Monthly NRR
SELECT
    revenue_month,
    ROUND(SUM(starting_mrr), 2) AS starting_mrr,
    ROUND(SUM(expansion_mrr), 2) AS expansion_mrr,
    ROUND(SUM(contraction_mrr), 2) AS contraction_mrr,
    ROUND(SUM(churn_mrr), 2) AS churn_mrr,
    ROUND(
        (
            SUM(starting_mrr)
            + SUM(expansion_mrr)
            - SUM(contraction_mrr)
            - SUM(churn_mrr)
        ) / NULLIF(SUM(starting_mrr), 0) * 100,
        2
    ) AS nrr_pct
FROM monthly_revenue
GROUP BY revenue_month
HAVING SUM(starting_mrr) > 0
ORDER BY revenue_month;


-- KPI 11: Monthly Churn MRR
SELECT
    revenue_month,
    ROUND(SUM(churn_mrr), 2) AS churn_mrr
FROM monthly_revenue
GROUP BY revenue_month
ORDER BY revenue_month;
-- ============================================
-- 04. CUSTOMER HEALTH
-- Business Question:
-- How does customer health relate to churn risk and revenue loss?
-- ============================================

-- KPI 12: Observed Churn Rate by Health Status
SELECT
    p.health_status,
    COUNT(*) AS account_months,
    SUM(
        CASE
            WHEN r.churn_mrr > 0 THEN 1
            ELSE 0
        END
    ) AS churn_events,
    ROUND(
        SUM(
            CASE
                WHEN r.churn_mrr > 0 THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS churn_rate_pct
FROM product_usage p
JOIN monthly_revenue r
    ON p.account_id = r.account_id
   AND p.usage_month = r.revenue_month
GROUP BY p.health_status
ORDER BY churn_rate_pct DESC;


-- KPI 13: Churn MRR by Health Status
SELECT
    p.health_status,
    COUNT(*) AS churn_events,
    ROUND(SUM(r.churn_mrr), 2) AS total_churn_mrr,
    ROUND(AVG(r.churn_mrr), 2) AS avg_churn_mrr
FROM monthly_revenue r
JOIN product_usage p
    ON r.account_id = p.account_id
   AND r.revenue_month = p.usage_month
WHERE r.churn_mrr > 0
GROUP BY p.health_status
ORDER BY total_churn_mrr DESC;
-- ============================================
-- 05. GROWTH DIAGNOSIS
-- Business Question:
-- What is driving NovaFlow's recent growth slowdown?
-- ============================================

-- KPI 14: New MRR by Lead Source
SELECT
    l.lead_source,
    ROUND(SUM(r.new_mrr), 2) AS total_new_mrr
FROM monthly_revenue r
JOIN accounts a
    ON r.account_id = a.account_id
JOIN opportunities o
    ON a.account_id = o.account_id
JOIN leads l
    ON o.lead_id = l.lead_id
WHERE o.result = 'Closed Won'
GROUP BY l.lead_source
ORDER BY total_new_mrr DESC;


-- KPI 15: Monthly New Accounts and New MRR
SELECT
    revenue_month,
    COUNT(CASE WHEN new_mrr > 0 THEN 1 END) AS new_accounts,
    ROUND(SUM(new_mrr), 2) AS total_new_mrr,
    ROUND(
        AVG(CASE WHEN new_mrr > 0 THEN new_mrr END),
        2
    ) AS avg_new_mrr_per_account
FROM monthly_revenue
GROUP BY revenue_month
ORDER BY revenue_month;


-- KPI 16: Monthly Active Accounts
SELECT
    revenue_month,
    COUNT(DISTINCT CASE
        WHEN ending_mrr > 0 THEN account_id
    END) AS active_accounts
FROM monthly_revenue
GROUP BY revenue_month
ORDER BY revenue_month;

SELECT 
    health_status,
    COUNT(*) AS account_count
FROM accounts
GROUP BY health_status;

DESCRIBE accounts;
SELECT
    account_status,
    COUNT(*) AS account_count
FROM accounts
GROUP BY account_status;
DESCRIBE subscriptions;
SELECT
    COUNT(*) AS total_subscriptions,
    COUNT(DISTINCT account_id) AS unique_accounts,
    SUM(CASE WHEN a.account_id IS NULL THEN 1 ELSE 0 END) AS fk_errors
FROM subscriptions s
LEFT JOIN accounts a
    ON s.account_id = a.account_id;
SELECT
    COUNT(*) AS total_subscriptions,
    COUNT(DISTINCT s.account_id) AS unique_accounts,
    SUM(CASE WHEN a.account_id IS NULL THEN 1 ELSE 0 END) AS fk_errors
FROM subscriptions s
LEFT JOIN accounts a
    ON s.account_id = a.account_id;DESCRIBE monthly_revenue;

SELECT
    COUNT(*) AS total_revenue_rows,
    COUNT(DISTINCT m.account_id) AS unique_accounts,
    SUM(CASE WHEN a.account_id IS NULL THEN 1 ELSE 0 END) AS fk_errors
FROM monthly_revenue m
LEFT JOIN accounts a
    ON m.account_id = a.account_id;
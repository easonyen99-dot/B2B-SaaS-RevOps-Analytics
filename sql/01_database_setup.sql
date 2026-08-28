SHOW DATABASES;
CREATE DATABASE saas_revops;

USE saas_revops;
CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    segment VARCHAR(30),
    industry VARCHAR(50),
    region VARCHAR(50),
    employee_size INT,
    customer_since DATE,
    account_status VARCHAR(20)
);
SHOW TABLES;
DESCRIBE accounts;
CREATE TABLE IF NOT EXISTS leads (
    lead_id INT PRIMARY KEY,
    created_date DATE NOT NULL,
    company_name VARCHAR(100),
    lead_source VARCHAR(30),
    industry VARCHAR(50),
    company_size VARCHAR(30),
    region VARCHAR(50),
    lead_status VARCHAR(30)
);
DESCRIBE leads;
CREATE TABLE IF NOT EXISTS leads (
    lead_id INT PRIMARY KEY,
    created_date DATE NOT NULL,
    company_name VARCHAR(100),
    lead_source VARCHAR(30),
    industry VARCHAR(50),
    company_size VARCHAR(30),
    region VARCHAR(50),
    lead_status VARCHAR(30)
);
DESCRIBE leads;
CREATE TABLE IF NOT EXISTS opportunities (
    opportunity_id INT PRIMARY KEY,
    lead_id INT NOT NULL,
    account_id INT,
    sales_rep VARCHAR(100),
    stage VARCHAR(30),
    created_date DATE NOT NULL,
    close_date DATE,
    deal_value DECIMAL(12,2),
    probability DECIMAL(5,2),
    result VARCHAR(30),

    FOREIGN KEY (lead_id) REFERENCES leads(lead_id),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);
DESCRIBE opportunities;
CREATE TABLE IF NOT EXISTS subscriptions (
    subscription_id INT PRIMARY KEY,
    account_id INT NOT NULL,
    plan_name VARCHAR(30) NOT NULL,
    start_date DATE NOT NULL,
    renewal_date DATE,
    contract_term INT,
    monthly_fee DECIMAL(12,2) NOT NULL,
    subscription_status VARCHAR(20),

    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);
DESCRIBE subscriptions;
CREATE TABLE IF NOT EXISTS monthly_revenue (
    revenue_id INT PRIMARY KEY,
    account_id INT NOT NULL,
    revenue_month DATE NOT NULL,
    starting_mrr DECIMAL(12,2) DEFAULT 0,
    new_mrr DECIMAL(12,2) DEFAULT 0,
    expansion_mrr DECIMAL(12,2) DEFAULT 0,
    contraction_mrr DECIMAL(12,2) DEFAULT 0,
    churn_mrr DECIMAL(12,2) DEFAULT 0,
    ending_mrr DECIMAL(12,2) DEFAULT 0,

    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);
DESCRIBE monthly_revenue;
CREATE TABLE IF NOT EXISTS product_usage (
    usage_id INT PRIMARY KEY,
    account_id INT NOT NULL,
    usage_month DATE NOT NULL,
    active_users INT DEFAULT 0,
    login_frequency INT DEFAULT 0,
    feature_usage_count INT DEFAULT 0,
    support_tickets INT DEFAULT 0,
    last_login_date DATE,

    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);
CREATE TABLE IF NOT EXISTS product_usage (
    usage_id INT PRIMARY KEY,
    account_id INT NOT NULL,
    usage_month DATE NOT NULL,
    active_users INT DEFAULT 0,
    login_frequency INT DEFAULT 0,
    feature_usage_count INT DEFAULT 0,
    support_tickets INT DEFAULT 0,
    last_login_date DATE,

    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);
DESCRIBE product_usage;
SHOW TABLES;
USE saas_revops;

DESCRIBE leads;
DESCRIBE opportunities;
DESCRIBE accounts;
DESCRIBE subscriptions;
DESCRIBE monthly_revenue;
DESCRIBE product_usage;
ALTER TABLE product_usage
ADD COLUMN health_status VARCHAR(20);
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE product_usage;
TRUNCATE TABLE monthly_revenue;
TRUNCATE TABLE subscriptions;
TRUNCATE TABLE accounts;
TRUNCATE TABLE opportunities;
TRUNCATE TABLE leads;

SET FOREIGN_KEY_CHECKS = 1;
SELECT COUNT(*) AS row_count
FROM monthly_revenue;
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE product_usage;

TRUNCATE TABLE monthly_revenue;
TRUNCATE TABLE subscriptions;
TRUNCATE TABLE accounts;
TRUNCATE TABLE opportunities;
TRUNCATE TABLE leads;

SET FOREIGN_KEY_CHECKS = 1;
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';
LOAD DATA LOCAL INFILE 'C:/B2B-SaaS-RevOps-Analytics/data/leads.csv'
INTO TABLE leads
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) AS leads_count
FROM leads;
LOAD DATA LOCAL INFILE 'C:/B2B-SaaS-RevOps-Analytics/data/opportunities.csv'
INTO TABLE opportunities
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS opportunities_count
FROM opportunities;
SHOW SET FOREIGN_KEY_CHECKS = 0;

LOAD DATA LOCAL INFILE 'C:/B2B-SaaS-RevOps-Analytics/data/opportunities.csv'
INTO TABLE opportunitiesSET FOREIGN_KEY_CHECKS = 0;
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    opportunity_id,
    lead_id,
    @account_id,
    sales_rep,
    stage,
    created_date,
    @close_date,
    deal_value,
    probability,
    result
)
SET
    account_id = NULLIF(@account_id, ''),
    close_date = NULLIF(@close_date, '');

SET FOREIGN_KEY_CHECKS = 1;WARNINGS;
SET FOREIGN_KEY_CHECKS = 0;
SELECT @@FOREIGN_KEY_CHECKS;

LOAD DATA LOCAL INFILE 'C:/B2B-SaaS-RevOps-Analytics/data/opportunities.csv'
INTO TABLE opportunities
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    opportunity_id,
    lead_id,
    @account_id,
    sales_rep,
    stage,
    created_date,
    @close_date,
    deal_value,
    probability,
    result
)
SET
    account_id = NULLIF(@account_id, ''),
    close_date = NULLIF(@close_date, '');
SELECT COUNT(*) AS opportunities_count
FROM opportunities;
LOAD DATA LOCAL INFILE 'C:/B2B-SaaS-RevOps-Analytics/data/accounts_health_adjusted.csv'
INTO TABLE accounts
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) AS accounts_count
FROM accounts;
LOAD DATA LOCAL INFILE 'C:/B2B-SaaS-RevOps-Analytics/data/subscriptions_health_adjusted.csv'
INTO TABLE subscriptions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) AS subscriptions_count
FROM subscriptions;
LOAD DATA LOCAL INFILE 'C:/B2B-SaaS-RevOps-Analytics/data/monthly_revenue_health_adjusted.csv'
INTO TABLE monthly_revenue
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) AS monthly_revenue_count
FROM monthly_revenue;
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT revenue_id) AS unique_revenue_ids,
    MIN(revenue_id) AS min_id,
    MAX(revenue_id) AS max_id
FROM monthly_revenue;
SELECT *
FROM monthly_revenue
WHERE revenue_id = 0;
SHOW WARNINGS;
DELETE FROM monthly_revenue
WHERE revenue_id = 0;
SELECT COUNT(*) AS monthly_revenue_count
FROM monthly_revenue;
LOAD DATA LOCAL INFILE 'C:/B2B-SaaS-RevOps-Analytics/data/product_usage.csv'
INTO TABLE product_usage
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) AS product_usage_count
FROM product_usage;
SET FOREIGN_KEY_CHECKS = 1;
SELECT @@FOREIGN_KEY_CHECKS;
SELECT COUNT(*) AS orphan_opportunities
FROM opportunities o
LEFT JOIN leads l
    ON o.lead_id = l.lead_id
WHERE l.lead_id IS NULL;
SELECT COUNT(*) AS orphan_opportunity_accounts
FROM opportunities o
LEFT JOIN accounts a
    ON o.account_id = a.account_id
WHERE o.account_id IS NOT NULL
  AND a.account_id IS NULL;
  SELECT COUNT(*) AS orphan_subscriptions
FROM subscriptions s
LEFT JOIN accounts a
    ON s.account_id = a.account_id
WHERE a.account_id IS NULL;
SELECT COUNT(*) AS orphan_revenue
FROM monthly_revenue r
LEFT JOIN accounts a
    ON r.account_id = a.account_id
WHERE a.account_id IS NULL;
SELECT COUNT(*) AS orphan_product_usage
FROM product_usage p
LEFT JOIN accounts a
    ON p.account_id = a.account_id
WHERE a.account_id IS NULL;
SELECT COUNT(*) AS mrr_formula_errors
FROM monthly_revenue
WHERE ROUND(
    starting_mrr
    + new_mrr
    + expansion_mrr
    - contraction_mrr
    - churn_mrr,
    2
) <> ROUND(ending_mrr, 2);
SELECT COUNT(*) AS post_churn_errors
FROM monthly_revenue r1
WHERE EXISTS (
    SELECT 1
    FROM monthly_revenue r2
    WHERE r2.account_id = r1.account_id
      AND r2.revenue_month < r1.revenue_month
      AND r2.churn_mrr > 0
)
AND r1.ending_mrr > 0;
SELECT COUNT(*) AS churned_accounts
FROM accounts
WHERE account_status = 'Churned';
SELECT
    account_status,
    COUNT(*) AS account_count
FROM accounts
GROUP BY account_status
ORDER BY account_count DESC;
SELECT
    account_status,
    LENGTH(account_status) AS char_length,
    HEX(account_status) AS hex_value,
    COUNT(*) AS account_count
FROM accounts
GROUP BY account_status;
UPDATE accounts
SET account_status = REPLACE(account_status, CHAR(13), '');
SELECT
    account_status,
    LENGTH(account_status) AS char_length,
    COUNT(*) AS account_count
FROM accounts
GROUP BY account_status;
SELECT COUNT(*) AS churned_accounts
FROM accounts
WHERE account_status = 'Churned';
SELECT
    health_status,

    LENGTH(health_status) AS char_length,
    HEX(health_status) AS hex_value,
    COUNT(*) AS record_count
FROM product_usage
GROUP BY health_status;
UPDATE product_usage
SET health_status = REPLACE(health_status, CHAR(13), '');
SELECT
    health_status,
    LENGTH(health_status) AS char_length,
    COUNT(*) AS record_count
FROM product_usage
GROUP BY health_status;
SELECT
    subscription_status,
    LENGTH(subscription_status) AS char_length,
    HEX(subscription_status) AS hex_value,
    COUNT(*) AS record_count
FROM subscriptions
GROUP BY subscription_status;
UPDATE subscriptions
SET subscription_status = REPLACE(subscription_status, CHAR(13), '');
SELECT
    subscription_status,
    LENGTH(subscription_status) AS char_length,
    COUNT(*) AS record_count
FROM subscriptions
GROUP BY subscription_status;
SELECT
    result,
    LENGTH(result) AS char_length,
    HEX(result) AS hex_value,
    COUNT(*) AS record_count
FROM opportunities
GROUP BY result;
UPDATE opportunities
SET result = REPLACE(result, CHAR(13), '');
SELECT
    result,
    LENGTH(result) AS char_length,
    COUNT(*) AS record_count
FROM opportunities
GROUP BY result;
SELECT
    lead_status,
    LENGTH(lead_status) AS char_length,
    HEX(lead_status) AS hex_value,
    COUNT(*) AS record_count
FROM leads
GROUP BY lead_status;
UPDATE leads
SET lead_status = REPLACE(lead_status, CHAR(13), '');
SELECT
    lead_status,
    LENGTH(lead_status) AS char_length,
    COUNT(*) AS record_count
FROM leads
GROUP BY lead_status;
SELECT COUNT(*) AS closed_won_opportunities
FROM opportunities
WHERE result = 'Closed Won';
SELECT
    COUNT(*) AS total_opportunities,
    SUM(CASE WHEN result = 'Closed Won' THEN 1 ELSE 0 END) AS closed_won,
    ROUND(
        SUM(CASE WHEN result = 'Closed Won' THEN 1 ELSE 0 END)
        / COUNT(*) * 100,
        2
    ) AS win_rate_pct
FROM opportunities;
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
SELECT
    l.company_size,
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
GROUP BY l.company_size
ORDER BY win_rate_pct DESC;
SELECT
    l.industry,
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
GROUP BY l.industry
ORDER BY win_rate_pct DESC;
SELECT
    ROUND(
        AVG(DATEDIFF(close_date, created_date)),
        1
    ) AS avg_sales_cycle_days
FROM opportunities
WHERE result = 'Closed Won'
  AND close_date IS NOT NULL;
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
SELECT
    ROUND(AVG(deal_value), 2) AS avg_deal_value
FROM opportunities
WHERE result = 'Closed Won';
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
SELECT
    ROUND(SUM(deal_value), 2) AS total_closed_won_deal_value
FROM opportunities
WHERE result = 'Closed Won';
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
SELECT
    revenue_month,
    ROUND(SUM(ending_mrr), 2) AS current_mrr
FROM monthly_revenue
WHERE revenue_month = (
    SELECT MAX(revenue_month)
    FROM monthly_revenue
)
GROUP BY revenue_month;
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
SELECT
    revenue_month,
    ROUND(SUM(ending_mrr), 2) AS total_mrr
FROM monthly_revenue
GROUP BY revenue_month
ORDER BY revenue_month;
SELECT
    revenue_month,
    ROUND(SUM(new_mrr), 2) AS new_mrr,
    ROUND(SUM(expansion_mrr), 2) AS expansion_mrr,
    ROUND(SUM(contraction_mrr), 2) AS contraction_mrr,
    ROUND(SUM(churn_mrr), 2) AS churn_mrr
FROM monthly_revenue
GROUP BY revenue_month
ORDER BY revenue_month;
SELECT
    COUNT(*) AS total_accounts,
    SUM(CASE WHEN account_status = 'Churned' THEN 1 ELSE 0 END) AS churned_accounts,
    ROUND(
        SUM(CASE WHEN account_status = 'Churned' THEN 1 ELSE 0 END)
        / COUNT(*) * 100,
        2
    ) AS account_churn_rate_pct
FROM accounts;
SELECT
    p.health_status,
    COUNT(*) AS total_accounts,
    SUM(CASE WHEN a.account_status = 'Churned' THEN 1 ELSE 0 END) AS churned_accounts,
    ROUND(
        SUM(CASE WHEN a.account_status = 'Churned' THEN 1 ELSE 0 END)
        / COUNT(*) * 100,
        2
    ) AS churn_rate_pct
FROM product_usage p
JOIN accounts a
    ON p.account_id = a.account_id
WHERE p.usage_month = (
    SELECT MAX(p2.usage_month)
    FROM product_usage p2
    WHERE p2.account_id = p.account_id
)
GROUP BY p.health_status
ORDER BY churn_rate_pct DESC;
SELECT
    revenue_month AS churn_month,
    COUNT(DISTINCT account_id) AS churned_accounts
FROM monthly_revenue
WHERE churn_mrr > 0
GROUP BY revenue_month
ORDER BY revenue_month;
SELECT
    p.health_status,
    COUNT(DISTINCT r.account_id) AS churned_accounts
FROM monthly_revenue r
JOIN product_usage p
    ON r.account_id = p.account_id
   AND r.revenue_month = p.usage_month
WHERE r.churn_mrr > 0
GROUP BY p.health_status
ORDER BY churned_accounts DESC;
SELECT
    p.health_status,
    COUNT(DISTINCT r.account_id) AS churned_accounts
FROM monthly_revenue r
JOIN product_usage p
    ON r.account_id = p.account_id
   AND p.usage_month = DATE_SUB(r.revenue_month, INTERVAL 1 MONTH)
WHERE r.churn_mrr > 0
GROUP BY p.health_status
ORDER BY churned_accounts DESC;
SELECT
    p.health_status,
    COUNT(*) AS account_months,
    SUM(
        CASE
            WHEN r_next.churn_mrr > 0 THEN 1
            ELSE 0
        END
    ) AS next_month_churns,
    ROUND(
        SUM(
            CASE
                WHEN r_next.churn_mrr > 0 THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS next_month_churn_rate_pct
FROM product_usage p
LEFT JOIN monthly_revenue r_next
    ON p.account_id = r_next.account_id
   AND r_next.revenue_month =
       DATE_ADD(p.usage_month, INTERVAL 1 MONTH)
WHERE p.usage_month < (
    SELECT MAX(usage_month)
    FROM product_usage
)
GROUP BY p.health_status
ORDER BY next_month_churn_rate_pct DESC;
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
SELECT
    r.revenue_month,
    l.lead_source,
    ROUND(SUM(r.new_mrr), 2) AS new_mrr
FROM monthly_revenue r
JOIN accounts a
    ON r.account_id = a.account_id
JOIN opportunities o
    ON a.account_id = o.account_id
JOIN leads l
    ON o.lead_id = l.lead_id
WHERE o.result = 'Closed Won'
  AND r.revenue_month >= '2026-01-01'
GROUP BY
    r.revenue_month,
    l.lead_source
ORDER BY
    r.revenue_month,
    new_mrr DESC;
SELECT
    revenue_month,
    COUNT(CASE WHEN new_mrr > 0 THEN 1 END) AS new_accounts,
    ROUND(SUM(new_mrr), 2) AS total_new_mrr,
    ROUND(
        AVG(CASE WHEN new_mrr > 0 THEN new_mrr END),
        2
    ) AS avg_new_mrr_per_account
FROM monthly_revenue
WHERE revenue_month >= '2026-01-01'
GROUP BY revenue_month
ORDER BY revenue_month;
SELECT
    revenue_month,
    COUNT(DISTINCT CASE
        WHEN ending_mrr > 0 THEN account_id
    END) AS active_accounts
FROM monthly_revenue
GROUP BY revenue_month
ORDER BY revenue_month;
SELECT
    revenue_month,
    COUNT(DISTINCT CASE
        WHEN ending_mrr > 0 THEN account_id
    END) AS active_accounts,
    ROUND(SUM(ending_mrr), 2) AS total_mrr,
    ROUND(
        SUM(ending_mrr)
        / NULLIF(
            COUNT(DISTINCT CASE
                WHEN ending_mrr > 0 THEN account_id
            END),
            0
        ),
        2
    ) AS mrr_per_active_account
FROM monthly_revenue
GROUP BY revenue_month
ORDER BY revenue_month;
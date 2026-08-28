# NovaFlow Dataset Specification

## Analysis Period
24 months

## Target Data Volume

- Leads: 10,000
- Opportunities: ~3,000
- Accounts: ~1,000
- Subscriptions: ~1,000–1,200
- Monthly Revenue: ~20,000+
- Product Usage: ~20,000+

## Funnel Assumptions

Lead → Opportunity Conversion Rate: ~30%

Opportunity → Closed Won Win Rate: ~33%

Expected Customers: ~1,000

## Customer Segment Distribution

- SMB: 55%
- Mid-Market: 30%
- Enterprise: 15%

## Plan Distribution by Customer Segment

### SMB
- Starter: 70%
- Growth: 28%
- Enterprise: 2%

### Mid-Market
- Starter: 20%
- Growth: 65%
- Enterprise: 15%

### Enterprise
- Starter: 5%
- Growth: 25%
- Enterprise: 70%

## Lead Source Distribution

- Website: 30%
- Paid Ads: 20%
- Referral: 15%
- Outbound: 20%
- Partner: 10%
- Event: 5%

## Lead to Opportunity Conversion Rate by Source

- Website: 30%
- Paid Ads: 22%
- Referral: 45%
- Outbound: 20%
- Partner: 40%
- Event: 28%

## Opportunity Win Rate by Lead Source

- Website: 32%
- Paid Ads: 25%
- Referral: 48%
- Outbound: 28%
- Partner: 42%
- Event: 30%

## Deal Value Range by Customer Segment

- SMB: NT$30,000–120,000
- Mid-Market: NT$120,000–500,000
- Enterprise: NT$500,000–2,000,000

## Sales Cycle Range by Customer Segment

- SMB: 14–45 days
- Mid-Market: 30–90 days
- Enterprise: 60–180 days

## Monthly Fee Range by Plan

- Starter: NT$3,000–8,000
- Growth: NT$8,000–25,000
- Enterprise: NT$25,000–80,000

## Contract Term Distribution

- 12 months: 75%
- 24 months: 20%
- 36 months: 5%

Renewal Date Rule:
renewal_date = start_date + contract_term

## Customer Health and Churn Rules

### Healthy
- Churn Probability: 3%

### At Risk
- Churn Probability: 15%

### Critical
- Churn Probability: 40%

Customer Health will be influenced by:

- Active Users
- Login Frequency
- Feature Usage Count
- Support Tickets
- Last Login Date

## Product Usage Distribution by Customer Health

### Healthy
- Active Users: 20–100
- Login Frequency per Month: 20–60
- Feature Usage Count: 15–40
- Support Tickets: 0–3

### At Risk
- Active Users: 5–30
- Login Frequency per Month: 5–20
- Feature Usage Count: 5–15
- Support Tickets: 2–6

### Critical
- Active Users: 0–10
- Login Frequency per Month: 0–8
- Feature Usage Count: 0–6
- Support Tickets: 4–10

## Customer Segment Distribution

- SMB: 55%
- Mid-Market: 30%
- Enterprise: 15%

## Revenue Movement Rules

Ending MRR Formula:

Ending MRR =
Starting MRR
+ New MRR
+ Expansion MRR
- Contraction MRR
- Churn MRR

### New MRR
- New customer: new_mrr = monthly_fee

### Expansion MRR
- Healthy existing customers have approximately 12% probability of expansion
- Expansion amount: 10%–30% of current MRR

### Contraction MRR
- At Risk customers have approximately 10% probability of contraction
- Contraction amount: 10%–25% of current MRR

### Churn MRR
- Churned customer: churn_mrr = current MRR
- ending_mrr = 0 after churn

## 24-Month Business Trend

### Months 1–8
- Stable customer growth
- Low churn
- Healthy product usage

### Months 9–16
- Faster customer acquisition
- Higher Paid Ads and Outbound contribution
- Churn begins to increase

### Months 17–24
- ARR continues to grow
- More At Risk and Critical customers
- Product usage weakens for some customers
- Churn increases significantly
- NRR begins to decline

## Data Quality Constraints

- Primary Keys must be unique
- Foreign Keys must reference valid records
- close_date must not be earlier than created_date
- renewal_date must be later than start_date
- monthly_fee must be greater than 0
- deal_value must be greater than 0
- probability must be between 0 and 100
- ending_mrr must not be negative
- Churned customers should have MRR = 0 after churn

Revenue validation:

ending_mrr =
starting_mrr
+ new_mrr
+ expansion_mrr
- contraction_mrr
- churn_mrr
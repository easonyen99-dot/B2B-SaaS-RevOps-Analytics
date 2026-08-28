from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent
DATA_DIR = PROJECT_ROOT / "data"

DATA_DIR.mkdir(exist_ok=True)

print("Dataset generation environment ready.")
print(f"Data folder: {DATA_DIR}")

import csv
import random
random.seed(42)
from datetime import date, timedelta
from dateutil.relativedelta import relativedelta
NUM_LEADS = 10000

lead_sources = [
    "Website",
    "Paid Ads",
    "Referral",
    "Outbound",
    "Partner",
    "Event"
]

lead_source_weights = [
    30,
    20,
    15,
    20,
    10,
    5
]

industries = [
    "Technology",
    "Retail",
    "Manufacturing",
    "Healthcare",
    "Financial Services",
    "Professional Services"
]

company_sizes = [
    "SMB",
    "Mid-Market",
    "Enterprise"
]
company_size_weights = [
    55,
    30,
    15
]
regions = [
    "Taiwan",
    "Japan",
    "Singapore",
    "Hong Kong"
]

start_date = date(2024, 1, 1)

leads_file = DATA_DIR / "leads.csv"

with open(leads_file, "w", newline="", encoding="utf-8-sig") as file:
    writer = csv.writer(file)

    writer.writerow([
        "lead_id",
        "created_date",
        "company_name",
        "lead_source",
        "industry",
        "company_size",
        "region",
        "lead_status"
    ])

    for i in range(1, NUM_LEADS + 1):

        created_date = start_date + timedelta(
            days=random.randint(0, 729)
        )

        lead_source = random.choices(
            lead_sources,
            weights=lead_source_weights,
            k=1
        )[0]

        writer.writerow([
            i,
            created_date,
            f"Company_{i:05d}",
            lead_source,
            random.choice(industries),
            random.choices(
    company_sizes,
    weights=company_size_weights,
    k=1
)[0],
            random.choice(regions),
            "New"
        ])

print(f"Generated {NUM_LEADS} leads.")

from collections import Counter

company_size_counts = Counter()

with open(leads_file, "r", encoding="utf-8-sig") as file:
    reader = csv.DictReader(file)

    for row in reader:
        company_size_counts[row["company_size"]] += 1

print("Company Size Distribution:")
print(company_size_counts)

lead_to_opportunity_rates = {
    "Website": 0.30,
    "Paid Ads": 0.22,
    "Referral": 0.45,
    "Outbound": 0.20,
    "Partner": 0.40,
    "Event": 0.28
}

opportunity_leads = []

with open(leads_file, "r", encoding="utf-8-sig") as file:
    reader = csv.DictReader(file)

    for row in reader:
        conversion_rate = lead_to_opportunity_rates[row["lead_source"]]

        if random.random() < conversion_rate:
            opportunity_leads.append(row)

print(f"Qualified Opportunity Leads: {len(opportunity_leads)}")
sales_cycle_ranges = {
    "SMB": (14, 45),
    "Mid-Market": (30, 90),
    "Enterprise": (60, 180)
}
deal_value_ranges = {
    "SMB": (30000, 120000),
    "Mid-Market": (120000, 500000),
    "Enterprise": (500000, 2000000)
}
employee_size_ranges = {
    "SMB": (10, 99),
    "Mid-Market": (100, 499),
    "Enterprise": (500, 5000)
}
opportunity_win_rates = {
    "Website": 0.32,
    "Paid Ads": 0.25,
    "Referral": 0.48,
    "Outbound": 0.28,
    "Partner": 0.42,
    "Event": 0.30
}

opportunities_file = DATA_DIR / "opportunities.csv"

sales_reps = [
    "Alex Chen",
    "Brian Lin",
    "Cathy Wang",
    "David Huang",
    "Emily Tsai"
]

stages = [
    "Qualification",
    "Discovery",
    "Proposal",
    "Negotiation",
    "Closed"
]

with open(opportunities_file, "w", newline="", encoding="utf-8-sig") as file:
    writer = csv.writer(file)

    writer.writerow([
        "opportunity_id",
        "lead_id",
        "account_id",
        "sales_rep",
        "stage",
        "created_date",
        "close_date",
        "deal_value",
        "probability",
        "result"
    ])

    for opportunity_id, lead in enumerate(opportunity_leads, start=1):
        opportunity_created_date = date.fromisoformat(lead["created_date"])
        min_days, max_days = sales_cycle_ranges[lead["company_size"]]

        sales_cycle_days = random.randint(min_days, max_days)

        close_date = opportunity_created_date + timedelta(
            days=sales_cycle_days
        )

        min_deal, max_deal = deal_value_ranges[lead["company_size"]]

        deal_value = random.randint(min_deal, max_deal)

        win_rate = opportunity_win_rates[lead["lead_source"]]

        if random.random() < win_rate:
            result = "Closed Won"
        else:
            result = "Closed Lost"

        writer.writerow([
            opportunity_id,
            lead["lead_id"],
            "",
            random.choice(sales_reps),
            "Closed",
            lead["created_date"],
            close_date,
            deal_value,
            100 if result == "Closed Won" else 0,
            result
        ])

print(f"Generated {len(opportunity_leads)} opportunities.")

result_counts = Counter()

with open(opportunities_file, "r", encoding="utf-8-sig") as file:
    reader = csv.DictReader(file)

    for row in reader:
        result_counts[row["result"]] += 1

print("Opportunity Result Distribution:")
print(result_counts)

won_opportunity_leads = []

with open(opportunities_file, "r", encoding="utf-8-sig") as file:
    reader = csv.DictReader(file)

    for row in reader:
        if row["result"] == "Closed Won":
            won_opportunity_leads.append(row)

print(f"Closed Won Opportunities for Account Creation: {len(won_opportunity_leads)}")

accounts_file = DATA_DIR / "accounts.csv"

with open(accounts_file, "w", newline="", encoding="utf-8-sig") as file:
    writer = csv.writer(file)

    writer.writerow([
        "account_id",
        "company_name",
        "segment",
        "industry",
        "region",
        "employee_size",
        "customer_since",
        "account_status"
    ])

    for account_id, opportunity in enumerate(won_opportunity_leads, start=1):

        lead_id = opportunity["lead_id"]

        lead = next(
            row for row in opportunity_leads
            if row["lead_id"] == lead_id
        )

        min_employees, max_employees = employee_size_ranges[
            lead["company_size"]
        ]

        employee_size = random.randint(
            min_employees,
            max_employees
        )

        writer.writerow([
            account_id,
            lead["company_name"],
            lead["company_size"],
            lead["industry"],
            lead["region"],
            employee_size,
            opportunity["close_date"],
            "Active"
        ])

print(f"Generated {len(won_opportunity_leads)} accounts.")

account_map = {}

with open(accounts_file, "r", encoding="utf-8-sig") as file:
    reader = csv.DictReader(file)

    for row in reader:
        account_map[row["company_name"]] = row["account_id"]

print(f"Account Mapping Ready: {len(account_map)} accounts")

updated_opportunities = []

with open(opportunities_file, "r", encoding="utf-8-sig") as file:
    reader = csv.DictReader(file)

    for row in reader:

        if row["result"] == "Closed Won":
            lead = next(
                item for item in opportunity_leads
                if item["lead_id"] == row["lead_id"]
            )

            row["account_id"] = account_map[lead["company_name"]]

        updated_opportunities.append(row)

with open(opportunities_file, "w", newline="", encoding="utf-8-sig") as file:
    fieldnames = [
        "opportunity_id",
        "lead_id",
        "account_id",
        "sales_rep",
        "stage",
        "created_date",
        "close_date",
        "deal_value",
        "probability",
        "result"
    ]

    writer = csv.DictWriter(file, fieldnames=fieldnames)

    writer.writeheader()
    writer.writerows(updated_opportunities)

print("Opportunity account_id mapping completed.")

plan_distribution = {
    "SMB": {
        "Starter": 70,
        "Growth": 28,
        "Enterprise": 2
    },
    "Mid-Market": {
        "Starter": 20,
        "Growth": 65,
        "Enterprise": 15
    },
    "Enterprise": {
        "Starter": 5,
        "Growth": 25,
        "Enterprise": 70
    }
}
monthly_fee_ranges = {
    "Starter": (3000, 8000),
    "Growth": (8000, 25000),
    "Enterprise": (25000, 80000)
}
contract_terms = [12, 24, 36]

contract_term_weights = [75, 20, 5]

subscriptions_file = DATA_DIR / "subscriptions.csv"

with open(accounts_file, "r", encoding="utf-8-sig") as file:
    accounts = list(csv.DictReader(file))

with open(subscriptions_file, "w", newline="", encoding="utf-8-sig") as file:
    writer = csv.writer(file)

    writer.writerow([
        "subscription_id",
        "account_id",
        "plan_name",
        "start_date",
        "renewal_date",
        "contract_term",
        "monthly_fee",
        "subscription_status"
    ])

    for subscription_id, account in enumerate(accounts, start=1):

        segment = account["segment"]

        plans = list(plan_distribution[segment].keys())
        weights = list(plan_distribution[segment].values())

        plan_name = random.choices(
            plans,
            weights=weights,
            k=1
        )[0]

        min_fee, max_fee = monthly_fee_ranges[plan_name]
        monthly_fee = random.randint(min_fee, max_fee)

        contract_term = random.choices(
            contract_terms,
            weights=contract_term_weights,
            k=1
        )[0]

        start_date = date.fromisoformat(account["customer_since"])

        renewal_date = start_date + relativedelta(
            months=contract_term
        )

        writer.writerow([
            subscription_id,
            account["account_id"],
            plan_name,
            start_date,
            renewal_date,
            contract_term,
            monthly_fee,
            "Active"
        ])

print(f"Generated {len(accounts)} subscriptions.")
plan_counts = Counter()

with open(subscriptions_file, "r", encoding="utf-8-sig") as file:
    reader = csv.DictReader(file)

    for row in reader:
        plan_counts[row["plan_name"]] += 1

print("Plan Distribution:")
print(plan_counts)
segment_plan_counts = Counter()

account_segments = {
    row["account_id"]: row["segment"]
    for row in accounts
}

with open(subscriptions_file, "r", encoding="utf-8-sig") as file:
    reader = csv.DictReader(file)

    for row in reader:
        segment = account_segments[row["account_id"]]
        plan = row["plan_name"]

        segment_plan_counts[(segment, plan)] += 1

print("Segment x Plan Distribution:")

for key, count in sorted(segment_plan_counts.items()):
    print(key, count)
revenue_event_weights = {
    "No Change": 82,
    "Expansion": 8,
    "Contraction": 5,
    "Churn": 5
} 
expansion_rate_range = (0.10, 0.30)

contraction_rate_range = (0.10, 0.25)   
revenue_end_date = date(2026, 6, 1)    
monthly_revenue_file = DATA_DIR / "monthly_revenue.csv"

with open(subscriptions_file, "r", encoding="utf-8-sig") as file:
    subscriptions = list(csv.DictReader(file))

with open(monthly_revenue_file, "w", newline="", encoding="utf-8-sig") as file:
    writer = csv.writer(file)

    writer.writerow([
        "revenue_id",
        "account_id",
        "revenue_month",
        "starting_mrr",
        "new_mrr",
        "expansion_mrr",
        "contraction_mrr",
        "churn_mrr",
        "ending_mrr"
    ])

    revenue_id = 1

    for subscription in subscriptions:

        start_date = date.fromisoformat(subscription["start_date"])

        current_month = date(
            start_date.year,
            start_date.month,
            1
        )

        monthly_fee = int(subscription["monthly_fee"])

        first_month = True
        previous_ending_mrr = 0
        churned = False
        while current_month <= revenue_end_date:

            if first_month:
                starting_mrr = 0
                new_mrr = monthly_fee
                expansion_mrr = 0
                contraction_mrr = 0
                churn_mrr = 0
                ending_mrr = monthly_fee
                first_month = False

            else:
                starting_mrr = previous_ending_mrr
                new_mrr = 0
                expansion_mrr = 0
                contraction_mrr = 0
                churn_mrr = 0

                if churned:
                    ending_mrr = 0

                else:
                    event = random.choices(
                        list(revenue_event_weights.keys()),
                        weights=list(revenue_event_weights.values()),
                        k=1
                    )[0]

                    if event == "Expansion":
                        expansion_rate = random.uniform(
                            expansion_rate_range[0],
                            expansion_rate_range[1]
                        )

                        expansion_mrr = round(
                            starting_mrr * expansion_rate
                        )

                    elif event == "Contraction":
                        contraction_rate = random.uniform(
                            contraction_rate_range[0],
                            contraction_rate_range[1]
                        )

                        contraction_mrr = round(
                            starting_mrr * contraction_rate
                        )

                    elif event == "Churn":
                        churn_mrr = starting_mrr
                        churned = True

                    ending_mrr = (
                        starting_mrr
                        + expansion_mrr
                        - contraction_mrr
                        - churn_mrr
                    )

            writer.writerow([
                revenue_id,
                subscription["account_id"],
                current_month,
                starting_mrr,
                new_mrr,
                expansion_mrr,
                contraction_mrr,
                churn_mrr,
                ending_mrr
            ])       

            previous_ending_mrr = ending_mrr
            revenue_id += 1

            current_month = current_month + relativedelta(months=1)

print(f"Generated {revenue_id - 1} monthly revenue records.")

customer_health_distribution = {
    "Healthy": 70,
    "At Risk": 20,
    "Critical": 10
}

usage_ranges = {
    "Healthy": {
        "login_frequency": (15, 30),
        "feature_usage_count": (20, 50),
        "support_tickets": (0, 2)
    },
    "At Risk": {
        "login_frequency": (5, 14),
        "feature_usage_count": (8, 19),
        "support_tickets": (1, 5)
    },
    "Critical": {
        "login_frequency": (0, 4),
        "feature_usage_count": (0, 7),
        "support_tickets": (3, 8)
    }
}

active_user_rate_ranges = {
    "Healthy": (0.40, 0.80),
    "At Risk": (0.15, 0.40),
    "Critical": (0.02, 0.15)
}
last_login_day_ranges = {
    "Healthy": (0, 5),
    "At Risk": (6, 15),
    "Critical": (16, 30)
}
account_employee_sizes = {
    account["account_id"]: int(account["employee_size"])
    for account in accounts
}
customer_health_distribution = {
    "Healthy": 70,
    "At Risk": 20,
    "Critical": 10
}
health_transition = {
    "Healthy": {
        "Healthy": 80,
        "At Risk": 15,
        "Critical": 5
    },
    "At Risk": {
        "Healthy": 25,
        "At Risk": 55,
        "Critical": 20
    },
    "Critical": {
        "Healthy": 10,
        "At Risk": 30,
        "Critical": 60
    }
}
product_usage_file = DATA_DIR / "product_usage.csv"

with open(product_usage_file, "w", newline="", encoding="utf-8-sig") as file:
    writer = csv.writer(file)

    writer.writerow([
        "usage_id",
        "account_id",
        "usage_month",
        "active_users",
        "login_frequency",
        "feature_usage_count",
        "support_tickets",
        "last_login_date",
        "health_status"
    ])

    usage_id = 1

    for subscription in subscriptions:

        start_date = date.fromisoformat(subscription["start_date"])

        current_month = date(
            start_date.year,
            start_date.month,
            1
        )
        previous_health_status = None
        while current_month <= revenue_end_date:

            if previous_health_status is None:
                health_status = random.choices(
                    list(customer_health_distribution.keys()),
                    weights=list(customer_health_distribution.values()),
                    k=1
                )[0]

            else:
                transition = health_transition[
                    previous_health_status
                ]

                health_status = random.choices(
                    list(transition.keys()),
                    weights=list(transition.values()),
                    k=1
                )[0]
            ranges = usage_ranges[health_status]
            min_login_days, max_login_days = last_login_day_ranges[
                health_status
            ]

            days_since_last_login = random.randint(
                min_login_days,
                max_login_days
            )

            last_login_date = current_month + relativedelta(
                months=1
            ) - timedelta(
                days=days_since_last_login + 1
            )
            employee_size = account_employee_sizes[
                subscription["account_id"]
            ]

            min_rate, max_rate = active_user_rate_ranges[
                health_status
            ]

            adoption_rate = random.uniform(
                min_rate,
                max_rate
            )

            active_users = max(
                1,
                round(employee_size * adoption_rate)
            )
            login_frequency = random.randint(
                ranges["login_frequency"][0],
                ranges["login_frequency"][1]
            )

            feature_usage_count = random.randint(
                ranges["feature_usage_count"][0],
                ranges["feature_usage_count"][1]
            )

            support_tickets = random.randint(
                ranges["support_tickets"][0],
                ranges["support_tickets"][1]
            )
            writer.writerow([
                usage_id,
                subscription["account_id"],
                current_month,
                active_users,
                login_frequency,
                feature_usage_count,
                support_tickets,
                last_login_date,
                health_status
            ])
            previous_health_status = health_status

            usage_id += 1

            current_month = current_month + relativedelta(months=1)
test_month = date(2024, 9, 1)

next_month = test_month + relativedelta(months=1)

print(f"Monthly Timeline Test: {test_month} -> {next_month}")
expansion_count = 0
contraction_count = 0
churn_count = 0

with open(monthly_revenue_file, "r", encoding="utf-8-sig") as file:
    reader = csv.DictReader(file)

    for row in reader:
        if int(row["expansion_mrr"]) > 0:
            expansion_count += 1

        if int(row["contraction_mrr"]) > 0:
            contraction_count += 1

        if int(row["churn_mrr"]) > 0:
            churn_count += 1

print(f"Expansion Records: {expansion_count}")
print(f"Contraction Records: {contraction_count}")
print(f"Churn Records: {churn_count}")
with open(monthly_revenue_file, "r", encoding="utf-8-sig") as file:
    reader = csv.DictReader(file)

    for row in reader:
        if int(row["churn_mrr"]) > 0:
            print("First Churn Record:")
            print(row)
            break
churn_account_id = "3"
churn_month = date(2025, 12, 1)

print("Post-Churn Records:")

with open(monthly_revenue_file, "r", encoding="utf-8-sig") as file:
    reader = csv.DictReader(file)

    for row in reader:
        row_month = date.fromisoformat(row["revenue_month"])

        if (
            row["account_id"] == churn_account_id
            and row_month >= churn_month
        ):
            print(row)   
validation_errors = 0

with open(monthly_revenue_file, "r", encoding="utf-8-sig") as file:
    reader = csv.DictReader(file)

    for row in reader:
        expected_ending_mrr = (
            int(row["starting_mrr"])
            + int(row["new_mrr"])
            + int(row["expansion_mrr"])
            - int(row["contraction_mrr"])
            - int(row["churn_mrr"])
        )

        actual_ending_mrr = int(row["ending_mrr"])

        if expected_ending_mrr != actual_ending_mrr:
            validation_errors += 1

print(f"MRR Formula Validation Errors: {validation_errors}")

usage_ranges = {
    "Healthy": {
        "login_frequency": (15, 30),
        "feature_usage_count": (20, 50),
        "support_tickets": (0, 2)
    },
    "At Risk": {
        "login_frequency": (5, 14),
        "feature_usage_count": (8, 19),
        "support_tickets": (1, 5)
    },
    "Critical": {
        "login_frequency": (0, 4),
        "feature_usage_count": (0, 7),
        "support_tickets": (3, 8)
    }
}

active_user_rate_ranges = {
    "Healthy": (0.40, 0.80),
    "At Risk": (0.15, 0.40),
    "Critical": (0.02, 0.15)
}

account_employee_sizes = {
    account["account_id"]: int(account["employee_size"])
    for account in accounts
}
usage_record_count = 0

with open(product_usage_file, "r", encoding="utf-8-sig") as file:
    reader = csv.DictReader(file)

    for row in reader:
        usage_record_count += 1

print(f"Product Usage Record Count: {usage_record_count}")
health_counts = Counter()

with open(product_usage_file, "r", encoding="utf-8-sig") as file:
    reader = csv.DictReader(file)

    for row in reader:
        health_counts[row["health_status"]] += 1

print("Customer Health Distribution:")
print(health_counts)
usage_validation_errors = 0

with open(product_usage_file, "r", encoding="utf-8-sig") as file:
    reader = csv.DictReader(file)

    for row in reader:
        health_status = row["health_status"]
        ranges = usage_ranges[health_status]

        login_frequency = int(row["login_frequency"])
        feature_usage_count = int(row["feature_usage_count"])
        support_tickets = int(row["support_tickets"])

        if not (
            ranges["login_frequency"][0]
            <= login_frequency
            <= ranges["login_frequency"][1]
        ):
            usage_validation_errors += 1

        if not (
            ranges["feature_usage_count"][0]
            <= feature_usage_count
            <= ranges["feature_usage_count"][1]
        ):
            usage_validation_errors += 1

        if not (
            ranges["support_tickets"][0]
            <= support_tickets
            <= ranges["support_tickets"][1]
        ):
            usage_validation_errors += 1

print(f"Product Usage Validation Errors: {usage_validation_errors}")
active_user_validation_errors = 0

with open(product_usage_file, "r", encoding="utf-8-sig") as file:
    reader = csv.DictReader(file)

    for row in reader:
        account_id = row["account_id"]
        health_status = row["health_status"]
        active_users = int(row["active_users"])

        employee_size = account_employee_sizes[account_id]

        min_rate, max_rate = active_user_rate_ranges[
            health_status
        ]

        min_active_users = max(
            1,
            round(employee_size * min_rate)
        )

        max_active_users = round(
            employee_size * max_rate
        )

        if not (
            min_active_users
            <= active_users
            <= max_active_users
        ):
            active_user_validation_errors += 1

print(
    f"Active User Validation Errors: "
    f"{active_user_validation_errors}"
)
last_login_validation_errors = 0

with open(product_usage_file, "r", encoding="utf-8-sig") as file:
    reader = csv.DictReader(file)

    for row in reader:
        health_status = row["health_status"]
        usage_month = date.fromisoformat(row["usage_month"])
        last_login_date = date.fromisoformat(row["last_login_date"])

        next_month = usage_month + relativedelta(months=1)
        month_end = next_month - timedelta(days=1)

        days_since_last_login = (
            month_end - last_login_date
        ).days

        min_days, max_days = last_login_day_ranges[
            health_status
        ]

        if not (
            min_days
            <= days_since_last_login
            <= max_days
        ):
            last_login_validation_errors += 1

print(
    f"Last Login Validation Errors: "
    f"{last_login_validation_errors}"
)
churn_probability_by_health = {
    "Healthy": 0.03,
    "At Risk": 0.15,
    "Critical": 0.40
}
health_lookup = {}

with open(product_usage_file, "r", encoding="utf-8-sig") as file:
    reader = csv.DictReader(file)

    for row in reader:
        key = (
            row["account_id"],
            row["usage_month"]
        )

        health_lookup[key] = row["health_status"]

print(
    f"Health Lookup Records: "
    f"{len(health_lookup)}"
)
with open(monthly_revenue_file, "r", encoding="utf-8-sig") as file:
    revenue_rows = list(csv.DictReader(file))

revenue_rows.sort(
    key=lambda row: (
        int(row["account_id"]),
        row["revenue_month"]
    )
)

print(
    f"Revenue Rows Ready for Health-Based Churn: "
    f"{len(revenue_rows)}"
)
health_churn_decisions = {}
churned_accounts = set()

health_churn_counts = Counter()

for row in revenue_rows:

    account_id = row["account_id"]
    revenue_month = row["revenue_month"]

    if account_id in churned_accounts:
        continue

    # Do not churn in the customer's first revenue month
    if int(row["new_mrr"]) > 0:
        continue

    # Only evaluate customers who still have active MRR
    if int(row["starting_mrr"]) <= 0:
        continue

    key = (
        account_id,
        revenue_month
    )

    health_status = health_lookup[key]

    churn_probability = churn_probability_by_health[
        health_status
    ]

    if random.random() < churn_probability:

        health_churn_decisions[key] = health_status

        churned_accounts.add(account_id)

        health_churn_counts[health_status] += 1

print(
    f"Health-Based Churn Decisions: "
    f"{len(health_churn_decisions)}"
)

print("Health-Based Churn by Status:")
print(health_churn_counts)
health_churn_opportunities = Counter()

churned_accounts_check = set()

for row in revenue_rows:

    account_id = row["account_id"]
    revenue_month = row["revenue_month"]

    if account_id in churned_accounts_check:
        continue

    if int(row["new_mrr"]) > 0:
        continue

    if int(row["starting_mrr"]) <= 0:
        continue

    key = (
        account_id,
        revenue_month
    )

    health_status = health_lookup[key]

    health_churn_opportunities[health_status] += 1

    if key in health_churn_decisions:
        churned_accounts_check.add(account_id)

print("Health Churn Rates:")

for health_status in [
    "Healthy",
    "At Risk",
    "Critical"
]:
    churns = health_churn_counts[health_status]
    opportunities = health_churn_opportunities[health_status]

    churn_rate = churns / opportunities * 100

    print(
        f"{health_status}: "
        f"{churns}/{opportunities} "
        f"= {churn_rate:.2f}%"
    )
    health_adjusted_revenue_file = (
    DATA_DIR / "monthly_revenue_health_adjusted.csv"
)

print(
    "Health-Adjusted Revenue File Ready:",
    health_adjusted_revenue_file
)
revenue_fieldnames = [
    "revenue_id",
    "account_id",
    "revenue_month",
    "starting_mrr",
    "new_mrr",
    "expansion_mrr",
    "contraction_mrr",
    "churn_mrr",
    "ending_mrr"
]

with open(
    health_adjusted_revenue_file,
    "w",
    newline="",
    encoding="utf-8-sig"
) as file:

    writer = csv.DictWriter(
        file,
        fieldnames=revenue_fieldnames
    )

    writer.writeheader()

    for row in revenue_rows:
        writer.writerow(row)

print(
    f"Copied {len(revenue_rows)} rows "
    f"to Health-Adjusted Revenue."
)
adjusted_revenue_rows = []

adjusted_revenue_id = 1

for subscription in subscriptions:

    account_id = subscription["account_id"]

    start_date = date.fromisoformat(
        subscription["start_date"]
    )

    current_month = date(
        start_date.year,
        start_date.month,
        1
    )

    monthly_fee = int(
        subscription["monthly_fee"]
    )

    previous_ending_mrr = 0
    first_month = True
    churned = False

    while current_month <= revenue_end_date:

        starting_mrr = previous_ending_mrr

        new_mrr = 0
        expansion_mrr = 0
        contraction_mrr = 0
        churn_mrr = 0

        if first_month:
            new_mrr = monthly_fee
            ending_mrr = monthly_fee
            first_month = False

        elif churned:
            ending_mrr = 0

        else:
            key = (
                account_id,
                current_month.isoformat()
            )

            if key in health_churn_decisions:
                churn_mrr = starting_mrr
                ending_mrr = 0
                churned = True

            else:
                event = random.choices(
                    [
                        "No Change",
                        "Expansion",
                        "Contraction"
                    ],
                    weights=[
                        82,
                        8,
                        5
                    ],
                    k=1
                )[0]

                if event == "Expansion":
                    expansion_rate = random.uniform(
                        expansion_rate_range[0],
                        expansion_rate_range[1]
                    )

                    expansion_mrr = round(
                        starting_mrr * expansion_rate
                    )

                elif event == "Contraction":
                    contraction_rate = random.uniform(
                        contraction_rate_range[0],
                        contraction_rate_range[1]
                    )

                    contraction_mrr = round(
                        starting_mrr * contraction_rate
                    )

                ending_mrr = (
                    starting_mrr
                    + expansion_mrr
                    - contraction_mrr
                )

        adjusted_revenue_rows.append({
            "revenue_id": adjusted_revenue_id,
            "account_id": account_id,
            "revenue_month": current_month,
            "starting_mrr": starting_mrr,
            "new_mrr": new_mrr,
            "expansion_mrr": expansion_mrr,
            "contraction_mrr": contraction_mrr,
            "churn_mrr": churn_mrr,
            "ending_mrr": ending_mrr
        })

        previous_ending_mrr = ending_mrr
        adjusted_revenue_id += 1

        current_month = (
            current_month
            + relativedelta(months=1)
        )

print(
    f"Health-Adjusted Revenue Rows Prepared: "
    f"{len(adjusted_revenue_rows)}"
)
with open(
    health_adjusted_revenue_file,
    "w",
    newline="",
    encoding="utf-8-sig"
) as file:

    writer = csv.DictWriter(
        file,
        fieldnames=revenue_fieldnames
    )

    writer.writeheader()
    writer.writerows(adjusted_revenue_rows)

print(
    f"Saved {len(adjusted_revenue_rows)} "
    f"Health-Adjusted Revenue rows."
)
health_adjusted_validation_errors = 0

with open(
    health_adjusted_revenue_file,
    "r",
    encoding="utf-8-sig"
) as file:

    reader = csv.DictReader(file)

    for row in reader:
        expected_ending_mrr = (
            int(row["starting_mrr"])
            + int(row["new_mrr"])
            + int(row["expansion_mrr"])
            - int(row["contraction_mrr"])
            - int(row["churn_mrr"])
        )

        actual_ending_mrr = int(
            row["ending_mrr"]
        )

        if expected_ending_mrr != actual_ending_mrr:
            health_adjusted_validation_errors += 1

print(
    f"Health-Adjusted MRR Validation Errors: "
    f"{health_adjusted_validation_errors}"
)
post_churn_validation_errors = 0
churned_accounts_validation = set()

with open(
    health_adjusted_revenue_file,
    "r",
    encoding="utf-8-sig"
) as file:

    reader = csv.DictReader(file)

    for row in reader:
        account_id = row["account_id"]

        if account_id in churned_accounts_validation:

            if (
                int(row["starting_mrr"]) != 0
                or int(row["new_mrr"]) != 0
                or int(row["expansion_mrr"]) != 0
                or int(row["contraction_mrr"]) != 0
                or int(row["churn_mrr"]) != 0
                or int(row["ending_mrr"]) != 0
            ):
                post_churn_validation_errors += 1

        if int(row["churn_mrr"]) > 0:
            churned_accounts_validation.add(account_id)

print(
    f"Post-Churn Validation Errors: "
    f"{post_churn_validation_errors}"
)
actual_health_churn_counts = Counter()

with open(
    health_adjusted_revenue_file,
    "r",
    encoding="utf-8-sig"
) as file:

    reader = csv.DictReader(file)

    for row in reader:

        if int(row["churn_mrr"]) > 0:

            key = (
                row["account_id"],
                row["revenue_month"]
            )

            health_status = health_lookup[key]

            actual_health_churn_counts[
                health_status
            ] += 1

print("Actual Health-Adjusted Churn:")
print(actual_health_churn_counts)

print(
    f"Actual Churn Records: "
    f"{sum(actual_health_churn_counts.values())}"
)
final_churned_accounts = set()

with open(
    health_adjusted_revenue_file,
    "r",
    encoding="utf-8-sig"
) as file:

    reader = csv.DictReader(file)

    for row in reader:
        if int(row["churn_mrr"]) > 0:
            final_churned_accounts.add(
                row["account_id"]
            )

print(
    f"Final Churned Accounts: "
    f"{len(final_churned_accounts)}"
)
subscriptions_adjusted_file = (
    DATA_DIR / "subscriptions_health_adjusted.csv"
)

with open(
    subscriptions_file,
    "r",
    encoding="utf-8-sig"
) as file:
    subscription_rows = list(csv.DictReader(file))

for row in subscription_rows:

    if row["account_id"] in final_churned_accounts:
        row["subscription_status"] = "Churned"
    else:
        row["subscription_status"] = "Active"

with open(
    subscriptions_adjusted_file,
    "w",
    newline="",
    encoding="utf-8-sig"
) as file:

    writer = csv.DictWriter(
        file,
        fieldnames=subscription_rows[0].keys()
    )

    writer.writeheader()
    writer.writerows(subscription_rows)

print(
    f"Adjusted Subscriptions Saved: "
    f"{len(subscription_rows)}"
)

adjusted_subscription_churn_count = sum(
    1
    for row in subscription_rows
    if row["subscription_status"] == "Churned"
)

print(
    f"Churned Subscriptions: "
    f"{adjusted_subscription_churn_count}"
)
accounts_adjusted_file = (
    DATA_DIR / "accounts_health_adjusted.csv"
)

with open(
    accounts_file,
    "r",
    encoding="utf-8-sig"
) as file:
    account_rows = list(csv.DictReader(file))

for row in account_rows:

    if row["account_id"] in final_churned_accounts:
        row["account_status"] = "Churned"
    else:
        row["account_status"] = "Active"

with open(
    accounts_adjusted_file,
    "w",
    newline="",
    encoding="utf-8-sig"
) as file:

    writer = csv.DictWriter(
        file,
        fieldnames=account_rows[0].keys()
    )

    writer.writeheader()
    writer.writerows(account_rows)

adjusted_account_churn_count = sum(
    1
    for row in account_rows
    if row["account_status"] == "Churned"
)

print(
    f"Adjusted Accounts Saved: "
    f"{len(account_rows)}"
)

print(
    f"Churned Accounts in Adjusted File: "
    f"{adjusted_account_churn_count}"
)
valid_account_ids = {
    row["account_id"]
    for row in account_rows
}

subscription_fk_errors = 0

for row in subscription_rows:
    if row["account_id"] not in valid_account_ids:
        subscription_fk_errors += 1

print(
    f"Subscription → Account FK Errors: "
    f"{subscription_fk_errors}"
)
revenue_fk_errors = 0

with open(
    health_adjusted_revenue_file,
    "r",
    encoding="utf-8-sig"
) as file:

    reader = csv.DictReader(file)

    for row in reader:
        if row["account_id"] not in valid_account_ids:
            revenue_fk_errors += 1

print(
    f"Revenue → Account FK Errors: "
    f"{revenue_fk_errors}"
)
usage_fk_errors = 0

with open(
    product_usage_file,
    "r",
    encoding="utf-8-sig"
) as file:

    reader = csv.DictReader(file)

    for row in reader:
        if row["account_id"] not in valid_account_ids:
            usage_fk_errors += 1

print(
    f"Product Usage → Account FK Errors: "
    f"{usage_fk_errors}"
)
valid_lead_ids = set()

with open(leads_file, "r", encoding="utf-8-sig") as file:
    reader = csv.DictReader(file)

    for row in reader:
        valid_lead_ids.add(row["lead_id"])

opportunity_lead_fk_errors = 0

with open(opportunities_file, "r", encoding="utf-8-sig") as file:
    reader = csv.DictReader(file)

    for row in reader:
        if row["lead_id"] not in valid_lead_ids:
            opportunity_lead_fk_errors += 1

print(
    f"Opportunity → Lead FK Errors: "
    f"{opportunity_lead_fk_errors}"
)
opportunity_account_fk_errors = 0

with open(opportunities_file, "r", encoding="utf-8-sig") as file:
    reader = csv.DictReader(file)

    for row in reader:

        if row["result"] == "Closed Won":
            if (
                row["account_id"] == ""
                or row["account_id"] not in valid_account_ids
            ):
                opportunity_account_fk_errors += 1

        elif row["result"] == "Closed Lost":
            if row["account_id"] != "":
                opportunity_account_fk_errors += 1

print(
    f"Opportunity → Account FK/Logic Errors: "
    f"{opportunity_account_fk_errors}"
)
print("\n=== DATA QUALITY SUMMARY ===")

print(f"Leads: 10000")
print(f"Opportunities: {len(opportunity_leads)}")
print(f"Accounts: {len(account_rows)}")
print(f"Subscriptions: {len(subscription_rows)}")
print(f"Monthly Revenue: {len(adjusted_revenue_rows)}")
print(f"Product Usage: {usage_record_count}")

print(f"MRR Formula Errors: {health_adjusted_validation_errors}")
print(f"Post-Churn Errors: {post_churn_validation_errors}")
print(f"Product Usage Errors: {usage_validation_errors}")
print(f"Active User Errors: {active_user_validation_errors}")
print(f"Last Login Errors: {last_login_validation_errors}")

print(f"Subscription → Account FK Errors: {subscription_fk_errors}")
print(f"Revenue → Account FK Errors: {revenue_fk_errors}")
print(f"Product Usage → Account FK Errors: {usage_fk_errors}")
print(f"Opportunity → Lead FK Errors: {opportunity_lead_fk_errors}")
print(f"Opportunity → Account FK/Logic Errors: {opportunity_account_fk_errors}")

print("=== END SUMMARY ===")


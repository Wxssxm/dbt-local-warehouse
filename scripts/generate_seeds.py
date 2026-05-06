"""Generate small but realistic seed CSVs for the dbt warehouse.

Run from repo root: `uv run python scripts/generate_seeds.py`.
Re-running with the same SEED produces identical files.
"""

from __future__ import annotations

import csv
import random
from datetime import date, timedelta
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
SEEDS_DIR = REPO_ROOT / "seeds"
SEED = 42

N_CUSTOMERS = 50
N_ORDERS = 200

ORDER_STATUSES = ["placed", "shipped", "completed", "returned", "return_pending"]
ORDER_STATUS_WEIGHTS = [10, 20, 60, 5, 5]

PAYMENT_METHODS = ["credit_card", "coupon", "bank_transfer", "gift_card"]
PAYMENT_METHOD_WEIGHTS = [70, 5, 20, 5]

FIRST_NAMES = (
    "Alex Aaliyah Bilal Camille Dimitri Elena Farah Gabriel Hassan Imane "
    "Jules Khadija Liam Maya Noor Omar Paul Quentin Rami Sophie Tarek "
    "Ugo Valentin Wassim Xavier Yara Zoe Adrian Bella Carlos Diana"
).split()
LAST_NAMES = (
    "Garcia Rossi Schmidt Bernard Dubois Mensah Tanaka Singh Khoury Park "
    "Mueller Leroy Fernandez Romano Petrov Diallo Costa Iqbal Larsson Boucher"
).split()
DOMAINS = ["example.com", "mail.test", "sample.io", "demo.dev"]


def main() -> None:
    rng = random.Random(SEED)
    SEEDS_DIR.mkdir(parents=True, exist_ok=True)

    # ---- customers ----
    base = date(2023, 1, 1)
    customers = []
    for i in range(1, N_CUSTOMERS + 1):
        first = rng.choice(FIRST_NAMES)
        last = rng.choice(LAST_NAMES)
        email = f"{first.lower()}.{last.lower()}{i}@{rng.choice(DOMAINS)}"
        signup = base + timedelta(days=rng.randint(0, 600))
        customers.append((i, first, last, email, signup.isoformat()))

    with (SEEDS_DIR / "raw_customers.csv").open("w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["id", "first_name", "last_name", "email", "signup_date"])
        w.writerows(customers)

    # ---- orders ----
    orders = []
    for i in range(1, N_ORDERS + 1):
        cid = rng.randint(1, N_CUSTOMERS)
        odate = base + timedelta(days=rng.randint(60, 720))
        status = rng.choices(ORDER_STATUSES, weights=ORDER_STATUS_WEIGHTS, k=1)[0]
        orders.append((i, cid, odate.isoformat(), status))

    with (SEEDS_DIR / "raw_orders.csv").open("w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["id", "customer_id", "order_date", "status"])
        w.writerows(orders)

    # ---- payments ----
    # 80% of orders have 1 payment, 15% have 2 (split), 5% have 0 (failed checkout).
    payments = []
    pid = 0
    for o_id, _cid, _odate, status in orders:
        if status == "returned":
            continue
        roll = rng.random()
        if roll < 0.05:
            # zero payments
            continue
        n_payments = 1 if roll < 0.85 else 2
        for _ in range(n_payments):
            pid += 1
            method = rng.choices(PAYMENT_METHODS, weights=PAYMENT_METHOD_WEIGHTS, k=1)[0]
            amount_cents = rng.randint(500, 25000)
            payments.append((pid, o_id, method, amount_cents))

    with (SEEDS_DIR / "raw_payments.csv").open("w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["id", "order_id", "payment_method", "amount_cents"])
        w.writerows(payments)

    print(
        f"Wrote {len(customers)} customers, {len(orders)} orders, {len(payments)} payments "
        f"to {SEEDS_DIR}/"
    )


if __name__ == "__main__":
    main()

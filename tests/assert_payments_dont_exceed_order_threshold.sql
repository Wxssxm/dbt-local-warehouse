-- Singular test: any single payment over EUR 250 is suspicious — flag it.
-- (The seed generator caps at EUR 250 so a passing run = the seed contract holds.)

select payment_id, amount_eur
from {{ ref('stg_payments') }}
where amount_eur > 250.00

{% set payment_methods = ['bank_transfer', 'coupon', 'credit_card', 'gift_card'] %}


with payments as (
    select * from {{ref('stg_payments')}}
),

pivoted as (
select
    order_id
    {%- for payment_method in payment_methods %}
,   SUM(CASE WHEN payment_method = '{{ payment_method }}' THEN amount  ELSE 0 END) AS {{ payment_method }}_amount
    {%- endfor %}
from 
     payments
where 
    status = 'success' 
group by
    order_id
)

select * from pivoted
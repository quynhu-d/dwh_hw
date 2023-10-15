select m.store_id, m.category_id, sum(m.subtotal) as sales_sum from
(
	select pi_pr.category_id, purchases.store_id,
	pi_pr.product_price * pi_pr.product_count as subtotal
	from
	(
		select pi.purchase_id, pi.product_price, pi.product_count,
			pr.category_id
		from purchase_items pi join products pr on pi.product_id = pr.product_id
	) pi_pr join purchases on purchases.purchase_id =  pi_pr.purchase_id
) m
group by
	m.store_id, m.category_id

SELECT 
                o_stat.order_id,
                o_stat.num_items_sold,
                o_stat.total_sales,
                o_stat.net_total,
                o_stat.date_paid,    
                postM_t_ID.meta_value AS trans_ID,    
                IFNULL(wt.transaction_id, NULL) AS chk_trans_ID,
                IFNULL(wt.amount, NULL) AS amount,
                CONCAT('[',
                    GROUP_CONCAT(
                        CONCAT('{',
                                '"ID_p":', p_look.product_id, ',',
                                '"name_p":"', REPLACE(oi.order_item_name,'"', ""), '",',
                                '"ID_order":', p_look.order_item_id, ',',
                                '"ID_var":', p_look.variation_id, ',',
                                '"ID_cust":', p_look.customer_id, ',',
                                '"qty_p":', p_look.product_qty, ',',
                                '"price_net":', p_look.product_net_revenue, ',',
                                '"price_gross":', p_look.product_gross_revenue, ',',
                                '"sku":"', postM_sku.meta_value, '",',
                                '"priceReg":', postM_priceReg.meta_value,
                            '}'
                        ) SEPARATOR ','
                    ),
                ']') AS product_infos
            FROM
                wp_wc_order_stats AS o_stat
                JOIN wp_wc_order_product_lookup AS p_look
                    ON o_stat.order_id = p_look.order_id
                JOIN wp_posts AS post 
                    ON post.ID = p_look.product_id
                JOIN wp_postmeta AS postM_sku 
                    ON post.ID = postM_sku.post_id
                    AND postM_sku.meta_key = '_sku'
                JOIN wp_postmeta AS postM_priceReg 
                    ON post.ID = postM_priceReg.post_id
                    AND postM_priceReg.meta_key = '_regular_price'
                LEFT JOIN wp_postmeta AS postM_t_ID 
                    ON p_look.order_id = postM_t_ID.post_id
                    AND postM_t_ID.meta_key = '_transaction_id'
                JOIN wp_woocommerce_order_items AS oi
                    ON oi.order_item_id = p_look.order_item_id
                LEFT JOIN wp_woo_wallet_transactions AS wt
                    ON SUBSTRING(wt.details, LOCATE('#', wt.details) + 1) = p_look.order_id
            WHERE
                o_stat.date_paid BETWEEN :date_01 AND :date_02
                AND
                o_stat.status IN ('wc-completed')
            GROUP BY 
                p_look.order_id;

INSERT INTO public.orders (user_id, order_date, status, total_amount) VALUES
(101, '2024-01-15 10:30:00', 'completed', 250.00),
(102, '2024-01-16 11:00:00', 'pending',   125.50),
(103, '2024-01-17 14:00:00', 'shipped',    89.99),
(104, '2024-01-18 09:15:00', 'completed', 340.75),
(105, '2024-01-19 16:45:00', 'cancelled',  60.00),
(106, '2024-01-19 11:30:00', 'completed', 230.00),
(107, '2024-01-20 13:00:00', 'pending',   135.50),
(108, '2024-01-21 15:00:00', 'shipped',    79.99),
(109, '2024-01-22 10:15:00', 'completed', 370.75),
(110, '2024-01-23 15:35:00', 'completed',  90.00);

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

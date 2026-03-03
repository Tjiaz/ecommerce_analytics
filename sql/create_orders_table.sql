CREATE TABLE public.orders (
    order_id     SERIAL PRIMARY KEY,
    user_id      INTEGER,
    order_date   TIMESTAMP,
    status       VARCHAR(50),
    total_amount DECIMAL(10,2),
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    cookie_id    VARCHAR
);

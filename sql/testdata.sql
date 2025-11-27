-- testdata.sql
-- Lägger in testdata. Filen börjar med TRUNCATE för att vara lätt att köra flera gånger.
-- Kör denna fil på en TOM eller testdatabas (TRUNCATE rensar tabeller).

TRUNCATE TABLE reviews, order_items, orders, products, customers, brands RESTART IDENTITY CASCADE;

-- Nordiska tillverkare (brands)
INSERT INTO brands (name, country, founded_year, description) VALUES
('Ericsson', 'Sweden', 1876, 'Global leader in telecommunications and mobile network infrastructure'),
('Bang & Olufsen', 'Denmark', 1925, 'High-end audio and television products'),
('Nokia', 'Finland', 1865, 'Pioneer in mobile phones and network technology'),
('Icelandic Tech', 'Iceland', 2001, 'Emerging brand in smart home electronics'),
('Telia', 'Norway', 1993, 'Telecom and digital services provider in the Nordics');

-- Kunder (customers)
INSERT INTO customers (first_name, last_name, email, phone, city) VALUES
('Ahmed', 'Mohamed', 'ahmed.mohamed@gmail.com', '+46701234567', 'Gothenburg'),
('Khalid', 'Giama', 'khalid.giama@hotmail.com', '+46709876543', 'Malmö'),
('Aisha', 'Mohamed', 'aisha.mohamed@gmail.com', '+358401234567', 'Helsinki'),
('Hodan', 'Warsame', 'hodan.warsame@hotmail.com', '+4520123456', 'Copenhagen'),
('Sara', 'Lindberg', 'sara.lindberg@gmail.com', '+4687654321', 'Stockholm'),
('Luca', 'Moretti', 'luca.moretti@hotmail.com', '+393491234567', 'Oslo');

-- Produkter (products)
INSERT INTO products (name, brand_id, sku, release_year, price, warranty_months, category, stock_quantity) VALUES
('Smartphone X', 1, 'ERX-001', 2023, 7999.00, 24, 'Smartphones', 50),
('Laptop Pro', 2, 'BOL-002', 2022, 11999.00, 36, 'Laptops', 20),
('Tablet Air', 3, 'NOK-003', 2021, 5999.00, 12, 'Tablets', 35),
('Smartwatch Z', 4, 'ICE-004', 2023, 2999.00, 18, 'Wearables', 40),
('Printer Jet', 5, 'TEL-005', 2020, 2499.00, 24, 'Printers', 15),
('Router Max', 1, 'ERX-006', 2022, 1999.00, 12, 'Networking', 25),
('Monitor Ultra', 2, 'BOL-007', 2023, 3499.00, 24, 'Displays', 30),
('Camera Pro', 3, 'NOK-008', 2021, 8999.00, 36, 'Cameras', 10),
('Speaker Boom', 4, 'ICE-009', 2022, 1599.00, 12, 'Audio', 45),
('Keyboard Slim', 5, 'TEL-010', 2023, 999.00, 12, 'Accessories', 60);

-- Orders
-- Här är total_amount konsekvent med order_items nedan
INSERT INTO orders (customer_id, order_date, total_amount, status, shipping_city) VALUES
(1, '2022-01-10', 19998.00, 'completed', 'Gothenburg'),  -- order 1: 7999 + 11999
(2, '2023-02-15', 11998.00, 'completed', 'Malmö'),     -- order 2: 2 x 5999
(3, '2024-03-20', 5999.00, 'pending', 'Helsinki'),
(4, '2024-04-05', 2999.00, 'completed', 'Copenhagen'),
(5, '2024-05-12', 2499.00, 'cancelled', 'Stockholm'),
(6, '2025-06-18', 1999.00, 'completed', 'Oslo'),
(1, '2025-07-22', 3499.00, 'pending', 'Gothenburg'),
(2, '2025-08-30', 8999.00, 'completed', 'Malmö'),
(3, '2025-09-05', 1599.00, 'pending', 'Helsinki'),
(4, '2025-10-10', 999.00, 'completed', 'Copenhagen');

-- Order items
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 7999.00),   -- order 1, product 1
(1, 2, 1, 11999.00),  -- order 1, product 2
(2, 3, 2, 5999.00),   -- order 2, product 3 x2
(3, 3, 1, 5999.00),
(4, 4, 1, 2999.00),
(5, 5, 1, 2499.00),
(6, 6, 1, 1999.00),
(7, 7, 1, 3499.00),
(8, 8, 1, 8999.00),
(9, 9, 1, 1599.00),
(10, 10, 1, 999.00);

-- Reviews
INSERT INTO reviews (product_id, customer_id, rating, comment, review_date) VALUES
(1, 1, 5, 'Fantastisk mobil, snabb och snygg!', '2022-01-20'),
(2, 2, 4, 'Bra laptop men lite tung.', '2023-03-01'),
(3, 3, 3, 'Tableten är okej, men batteriet kunde vara bättre.', '2024-04-10'),
(4, 4, 5, 'Smartwatch med många funktioner, mycket nöjd!', '2025-05-15'),
(5, 5, 2, 'Skriver bra men låter högt.', '2023-06-12'),
(6, 6, 4, 'Stabil router, enkel att installera.', '2022-07-07'),
(7, 1, 5, 'Skärmen är kristallklar och färgerna är starka.', '2024-08-21'),
(8, 2, 3, 'Kameran är bra men inte bäst i mörker.', '2025-09-02'),
(9, 3, 4, 'Bra ljud, snygg design.', '2023-10-30'),
(10, 4, 5, 'Tangentbordet är tyst och bekvämt att skriva på.', '2022-11-11');








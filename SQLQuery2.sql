BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO orders(order_id, status)
    VALUES (1, 1);

    INSERT INTO order_items VALUES
    (1, 1, 101, 2);

    COMMIT;

    PRINT 'Order Success';

END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT ERROR_MESSAGE();
END CATCH;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;
BEGIN TRY
    BEGIN TRANSACTION;

    SAVE TRANSACTION before_restore;

    UPDATE p
    SET p.stock = p.stock + oi.quantity
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    WHERE oi.order_id = 1;

    UPDATE orders
    SET status = 3
    WHERE order_id = 1;

    COMMIT;

    PRINT 'Order Cancelled';

END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION before_restore;
    ROLLBACK;
    PRINT ERROR_MESSAGE();
END CATCH;
SELECT * FROM products;
SELECT * FROM orders;
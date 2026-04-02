BEGIN TRY
    BEGIN TRANSACTION;

    SAVE TRANSACTION before_restore;

    -- Restore stock ONLY if order is not already cancelled
    UPDATE p
    SET p.stock = p.stock + oi.quantity
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE oi.order_id = 1 AND o.status != 3;

    -- If nothing updated → already cancelled
    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('Order already cancelled!', 16, 1);
    END

    -- Update status
    UPDATE orders
    SET status = 3
    WHERE order_id = 1 AND status != 3;

    COMMIT;

    PRINT 'Order cancelled successfully';

END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION before_restore;
    ROLLBACK;
    PRINT ERROR_MESSAGE();
END CATCH;
UPDATE products
SET stock = 10
WHERE product_id = 101;
SELECT * FROM products;
SELECT * FROM orders;
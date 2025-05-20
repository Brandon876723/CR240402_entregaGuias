USE sakila;

CREATE TABLE payment_audit (
audit_id INT AUTO_INCREMENT PRIMARY KEY,
payment_id INT,
customer_id INT,
amount DECIMAL(5,2),
audit_date DATETIME
);

DELIMITER $$

CREATE TRIGGER after_insert_payment
AFTER INSERT ON payment
FOR EACH ROW

BEGIN
INSERT INTO payment_audit (payment_id, customer_id, amount, audit_date)
VALUES(NEW.payment_id, NEW.customer_id, NEW.amount, NOW());
END$$

DELIMITER ;
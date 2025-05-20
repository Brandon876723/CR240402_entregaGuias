USE sakila;

DELIMITER $$

CREATE TRIGGER before_insert_film
BEFORE INSERT ON film
FOR EACH ROW

BEGIN
    IF NEW.rental_rate <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El rental_rate debe ser mayor que 0';
    END IF;
END$$

DELIMITER ;

CREATE TABLE film_update_log(
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    film_id INT,
    update_date DATETIME
);

DELIMITER $$

CREATE TRIGGER after_film_update
AFTER UPDATE ON film
FOR EACH ROW
BEGIN
INSERT INTO film_update_log (film_id, update_date)
    VALUES (NEW.film_id, NOW());
END$$

DELIMITER ;

UPDATE film
SET title = 'Iron'
WHERE film_id = 1;

SELECT * FROM film_update_log;
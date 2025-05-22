CREATE DATABASE alumno_mm180363;
USE alumno_mm180363;

CREATE TABLE alumnos(
    id_alumno INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL
);

CREATE TABLE notas(
    id_nota INT AUTO_INCREMENT PRIMARY KEY,
    id_alumno INT,
    materia VARCHAR(100) NOT NULL,
    nota DECIMAL(5,2) NOT NULL,
    FOREIGN KEY (id_alumno) REFERENCES alumnos(id_alumno)
);

INSERT INTO alumnos (nombre, apellido, fecha_nacimiento) VALUES
('Juan', 'Perez', '2000-05-14'),
('Ana', 'Gomez', '1999-11-23'),
('Luis', 'Ramirez', '2001-03-10');

INSERT INTO notas (id_alumno, materia, nota) VALUES
(1, 'Matemáticas', 85.50),
(1, 'Historia', 90.00),
(2, 'Matemáticas', 78.25),
(3, 'Historia', 88.75),
(3, 'Matemáticas', 92.00);

-- ver todos los alumnos y notas
SELECT * FROM alumnos;
SELECT * FROM notas;

-- vizualizar las notas con nombre del alumno
SELECT alumnos.nombre, alumnos.apellido, notas.materia, notas.nota
FROM alumnos
INNER JOIN notas ON alumnos.id_alumno = notas.id_alumno;

-- creacion de ususario para acceder a la base de datos recien creada
-- para el nuevo ususario remplazaremos mm180363 con tu propio carnet la contra para el localhost sera 1234
CREATE USER 'CR240402'@'%' IDENTIFIED BY '1234';
-- a ese mismo se le otorgara permisos de INSERT, UPDATE Y DELETE PARA LA BASE DE DATOS RECIEN CREADA
GRANT SELECT, INSERT, UPDATE, DELETE ON alumno_mm180363.* TO 'CR240402'@'%';
-- y le otorgaremos permisos para que pueda crear procedimientos almacenados
GRANT CREATE ROUTINE, EXECUTE ON alumno_mm180363.* TO 'CR240402'@'%';
-- y aplicamos los cambios de permisos
FLUSH PRIVILEGES;

-- se iniciara sesion con el ussuario creado anteriormente y crearemos un procedimiento almacenado que nos deje ingresar notas en la tabla 'notas' y de output que regrese los datos ingresados

-- procedimiento almacenado
DELIMITER $$

CREATE PROCEDURE insertar_nota(
    IN p_id_alumno INT,
    IN p_materia VARCHAR(100),
    IN p_nota DECIMAL(5,2)
)
BEGIN
-- insertamos la nueva nota
INSERT INTO notas (id_alumno, materia, nota)
VALUES (p_id_alumno, p_materia, p_nota);

-- mostramos los datos insertados
SELECT * FROM notas WHERE id_nota = LAST_INSERT_ID();
END $$

DELIMITER ;

-- Crear el nuevo usuario (ej: notas_user) con su contraseña
CREATE USER 'notas_user'@'%' IDENTIFIED BY '1234';
-- Otorgar permisos solo para ejecutar el procedimiento almacenado
GRANT EXECUTE ON PROCEDURE alumno_mm180363.insertar_nota TO
'notas_user'@'%';
-- Dar permisos SELECT solo sobre la tabla notas
GRANT SELECT ON alumno_mm180363.notas TO 'notas_user'@'%';
-- Aplicar los cambios de permisos
FLUSH PRIVILEGES;

-- salis de la cuenta root e ingresas el usuario notas_user y contraseña 1234 y pones esto en el sql:
CALL insertar_nota(1, 'Matemáticas', 9.5);

-- iniciamos sesion en el ususario root  y eliminamos los dos ussuarios y la base de datos creados

-- eliminamos usuario
DROP USER 'mm180363'@'%'; -- EN ESTE ES CR240402 PORQUE ESE CREASTE LUEGO LO CAMBIAS

-- eliminamos el otro usuario
DROP USER 'notas_user'@'%';

-- y de paso la base de datos alumno_mm180363
DROP DATABASE alumno_mm180363;

FLUSH PRIVILEGES;
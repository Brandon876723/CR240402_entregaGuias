CREATE DATABASE clinica;
USE clinica;

CREATE TABLE pacientes(
    paciente_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    telefono VARCHAR(15),
    direccion TEXT
);

CREATE TABLE medicos(
     medico_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    especialidad VARCHAR(100) NOT NULL,
    telefono VARCHAR(15)
);

CREATE TABLE citas (
    cita_id INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    medico_id INT NOT NULL,
    fecha_hora DATETIME NOT NULL,
    estado ENUM('pendiente', 'confirmada', 'cancelada') DEFAULT 'pendiente',
    FOREIGN KEY (paciente_id) REFERENCES pacientes(paciente_id),
    FOREIGN KEY (medico_id) REFERENCES medicos(medico_id)
);

CREATE TABLE auditoria_citas (
    auditoria_id INT AUTO_INCREMENT PRIMARY KEY,
    cita_id INT NOT NULL,
    tipo_operacion ENUM('INSERT', 'UPDATE') NOT NULL,
    fecha_operacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(50) NOT NULL,
    FOREIGN KEY (cita_id) REFERENCES citas(cita_id)
);

DELIMITER $$

CREATE TRIGGER after_insert_cita
AFTER INSERT ON citas
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_citas (cita_id, tipo_operacion, fecha_operacion, usuario)
    VALUES (NEW.cita_id, 'INSERT', NOW(), USER());
END$$

DELIMITER ;

INSERT INTO pacientes (nombre, correo, fecha_nacimiento, telefono, direccion) VALUES
('Juan Pérez', 'juan.perez@example.com', '1985-07-12', '555-1234', 'San Salvador'),
('Ana Gómez', 'ana.gomez@example.com', '1990-05-21', '555-5678', 'Santa Tecla');

INSERT INTO medicos (nombre, especialidad, telefono) VALUES
('Dr. Carlos Rodríguez', 'Cardiología', '555-9999'),
('Dra. Sofía López', 'Dermatología', '555-8888');

INSERT INTO citas (paciente_id, medico_id, fecha_hora, estado) VALUES
(1, 1, '2025-05-22 10:00:00', 'confirmada'),
(2, 2, '2025-05-23 15:00:00', 'pendiente');

UPDATE citas SET estado = 'cancelada' WHERE cita_id = 1;
UPDATE citas SET estado = 'confirmada' WHERE cita_id = 2;

SELECT * FROM auditoria_citas;
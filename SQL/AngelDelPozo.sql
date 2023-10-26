/* -------------------------------------------------------------------------------------------
Nombre del autor: Angel Francis Del Pozo Escobar
Nombre de la base de datos: ArteVida
---------------------------------------------------------------------------------------------------*/

-- Create the 'artevida' database as ROOT
CREATE DATABASE artevida;

/* ------------------------------------------------------------------------------------------------
Definición de la estructura de la base de datos
--------------------------------------------------------------------------------------------------*/

-- Use the 'artevida' database
USE artevida;

-- Create tables

-- Table 'Direccion'
CREATE TABLE Direccion (
    ID_direccion INT AUTO_INCREMENT PRIMARY KEY,
    calle VARCHAR(255),
    ciudad_pueblo VARCHAR(255),
    codigo_postal VARCHAR(10),
    provincia_estado VARCHAR(255),
    pais VARCHAR(255)
);

-- Table 'Ubicación'
CREATE TABLE Ubicacion (
    ID_ubicacion INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    aforo INT NOT NULL,
	precio_alquiler DECIMAL(10, 2),
    caracteristicas TEXT,
    ID_direccion INT,
    FOREIGN KEY (ID_direccion) REFERENCES Direccion(ID_direccion)
    ON UPDATE CASCADE ON DELETE SET NULL
);

-- Table 'Actividad'
CREATE TABLE Actividad (
    ID_actividad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    tipo VARCHAR(255) NOT NULL
);

-- Table 'Evento'
CREATE TABLE Evento (
    ID_evento INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    precio_entrada DECIMAL(10, 2) NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    descripcion TEXT,
    entidad_responsable VARCHAR(255),
    ID_ubicacion INT,
    ID_actividad INT,
    FOREIGN KEY (ID_ubicacion) REFERENCES Ubicacion(ID_ubicacion)
    ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (ID_actividad) REFERENCES Actividad(ID_actividad)
    ON UPDATE CASCADE ON DELETE SET NULL
);

-- Table 'Artista'
CREATE TABLE Artista (
    ID_artista INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    cache DECIMAL(10, 2),
    biografia TEXT
);

-- Table 'Asistente'
CREATE TABLE Asistente (
    ID_asistente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    apellido1 VARCHAR(255) NOT NULL,
    apellido2 VARCHAR(255),
    telefono VARCHAR(20),
    correo VARCHAR(255)
);

-- Table 'Encuesta'
CREATE TABLE Encuesta (
    ID_encuesta INT AUTO_INCREMENT PRIMARY KEY,
    pregunta TEXT NOT NULL,
    fecha_realizacion DATE NOT NULL,
    resultados TEXT,
    ID_evento INT,
    ID_asistente INT,
    FOREIGN KEY (ID_evento) REFERENCES Evento(ID_evento)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (ID_asistente) REFERENCES Asistente(ID_asistente)
    ON UPDATE CASCADE ON DELETE CASCADE
);

-- Table 'Punto_venta'
CREATE TABLE Punto_venta (
    ID_puntoVenta INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    correo VARCHAR(255),
    web VARCHAR(255),
    telefono VARCHAR(20),
    ID_direccion INT,
    FOREIGN KEY (ID_direccion) REFERENCES Direccion(ID_direccion) 
    ON UPDATE CASCADE ON DELETE SET NULL
);

-- Table 'Metodo_pago'
CREATE TABLE Metodo_pago (
    ID_metodoPago INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    comisiones DECIMAL(5, 2)
);

-- Create relationships

-- Relationship: 'Asistente' to 'Evento'
CREATE TABLE Asistente_Evento (
    ID_asistente INT,
    ID_evento INT,
    PRIMARY KEY (ID_asistente, ID_evento),
    FOREIGN KEY (ID_asistente) REFERENCES Asistente(ID_asistente)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (ID_evento) REFERENCES Evento(ID_evento)
    ON UPDATE CASCADE ON DELETE CASCADE
);

-- Relationship: 'Artista' to 'Evento'
CREATE TABLE Artista_Evento (
    ID_artista INT,
    ID_evento INT,
    PRIMARY KEY (ID_artista, ID_evento),
    FOREIGN KEY (ID_artista) REFERENCES Artista(ID_artista)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (ID_evento) REFERENCES Evento(ID_evento)
    ON UPDATE CASCADE ON DELETE CASCADE
);

-- Relationship: 'Artista' to 'Actividad'
CREATE TABLE Artista_Actividad (
    ID_artista INT,
    ID_actividad INT,
    PRIMARY KEY (ID_artista, ID_actividad),
    FOREIGN KEY (ID_artista) REFERENCES Artista(ID_artista)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (ID_actividad) REFERENCES Actividad(ID_actividad)
    ON UPDATE CASCADE ON DELETE CASCADE
);

-- Relationship: 'Evento' at 'Punto_venta'
CREATE TABLE Evento_puntoVenta (
    ID_evento INT,
    ID_puntoVenta INT,
    PRIMARY KEY (ID_evento, ID_puntoVenta),
    FOREIGN KEY (ID_evento) REFERENCES Evento(ID_evento)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (ID_puntoVenta) REFERENCES Punto_venta(ID_puntoVenta)
    ON UPDATE CASCADE ON DELETE CASCADE
);

-- Relationship: 'Asistente' at 'Punto_venta'
CREATE TABLE Asistente_puntoVenta (
    ID_asistente INT,
    ID_puntoVenta INT,
    fecha_compra DATE NOT NULL,
    PRIMARY KEY (ID_asistente, ID_puntoVenta),
    FOREIGN KEY (ID_asistente) REFERENCES Asistente(ID_asistente)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (ID_puntoVenta) REFERENCES Punto_venta(ID_puntoVenta)
    ON UPDATE CASCADE ON DELETE CASCADE
);

-- Relationship: 'Punto_venta' at 'Metodo_pago'
CREATE TABLE Punto_venta_Metodo_pago (
    ID_puntoVenta INT,
    ID_metodoPago INT,
    PRIMARY KEY (ID_puntoVenta, ID_metodoPago),
    FOREIGN KEY (ID_puntoVenta) REFERENCES Punto_venta(ID_puntoVenta)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (ID_metodoPago) REFERENCES Metodo_pago(ID_metodoPago)
    ON UPDATE CASCADE ON DELETE CASCADE
);

/*------------------------------------------------------------------------------------------------------
Trigger
Inserción de datos
-------------------------------------------------------------------------------------------------------*/ 
-- Sample data for the 'Direccion' table
INSERT INTO Direccion (calle, ciudad_pueblo, codigo_postal, provincia_estado, pais)
VALUES
    ('Calle Gran Vía 123', 'Madrid', '28013', 'Madrid', 'España'),
    ('Avenida Diagonal 456', 'Barcelona', '08006', 'Cataluña', 'España'),
    ('Calle del Mar 789', 'Valencia', '46002', 'Valencia', 'España'),
    ('Calle de la Playa 101', 'Barcelona', '08002', 'Cataluña', 'España'),
    ('Avenida de la Libertad 123', 'Valencia', '46018', 'Valencia', 'España');

-- Sample data for the 'Ubicacion' table
INSERT INTO Ubicacion (nombre, aforo, precio_alquiler, caracteristicas, ID_direccion)
VALUES
    ('Teatro Real', 1800, 15000.00, 'Teatro de ópera en el centro de Madrid', 1),
    ('Palau de la Música Catalana', 2200, 12000.00, 'Sala de conciertos modernista en Barcelona', 2),
    ('Ciudad de las Artes y las Ciencias', 3500, 20000.00, 'Complejo cultural y científico en Valencia', 3);
    
-- Sample data for the 'Punto_venta' table
INSERT INTO Punto_venta (nombre, correo, web, telefono, ID_direccion)
VALUES
    ('Taquilla del Teatro', 'info@teatroreal.es', 'www.teatroreal.es', '+34900244848', 1),
    ('Punto de Venta Barcelona', 'ventas@barcelona.com', 'www.barcelona.com/ventas', '+34932221144', 4),
    ('Punto de Venta Valencia', 'ventas@valencia.com', 'www.valencia.com/ventas', '+34967778899', 5);

-- Sample data for the 'Actividad' table
INSERT INTO Actividad (nombre, tipo)
VALUES
    ('Concierto de Musica', 'Clasica'),
    ('Concierto de Musica', 'Jazz'),
    ('Concierto de Musica', 'Urbano'),
	('Exposición de Arte', 'Moderno'),
    ('Exposición de Arte', 'Barroco'),
    ('Obra de Teatro', 'Dramático');

-- Sample data for the 'Artista' table
INSERT INTO Artista (nombre, cache, biografia)
VALUES
    -- Urban Music Artists
    ('Bad Bunny', 12000.00, 'Cantante y compositor de música urbana puertorriqueño.'),
    ('J Balvin', 10000.00, 'Cantante y productor de reguetón y música urbana colombiano.'),
    ('Rosalia', 9000.00, 'Cantante y compositora de música urbana española.'),
    -- Modern Art Artists
    ('Frida Kahlo', 8500.00, 'Pintora mexicana conocida por su arte surrealista.'),
    ('Salvador Dalí', 9500.00, 'Pintor surrealista español, conocido por su estilo extravagante.'),
    -- Theater Artists
    ('Meryl Streep', 11000.00, 'Actriz estadounidense de renombre internacional.'),
    ('Anthony Hopkins', 10500.00, 'Actor galés famoso por su actuación en películas y teatro.'),
    ('Helen Mirren', 10000.00, 'Actriz británica, ganadora de premios Oscar y Tony.');

-- Sample data for the 'Metodo_pago' table
INSERT INTO Metodo_pago (nombre, descripcion, comisiones)
VALUES
    ('Tarjeta de Crédito', 'Pago con tarjeta de crédito', 2.50),
    ('Transferencia Bancaria', 'Pago por transferencia bancaria', 1.50),
    ('Efectivo', 'Pago en efectivo', 0.00);

-- Sample data for the 'Evento' table
INSERT INTO Evento (nombre, precio_entrada, fecha, hora, descripcion, entidad_responsable, ID_ubicacion, ID_actividad)
VALUES
    ('Concierto de Música Urbana en el Teatro Real', 25.00, '2023-11-15', '20:00:00', 'Disfruta de un emocionante concierto de música urbana en el prestigioso Teatro Real de Madrid.', 'Ayuntamiento Madrid', 1, 3),
    ('Exposición de Arte Moderno en el Palau de la Música Catalana', 12.00, '2023-12-01', '10:00:00', 'Explora obras de arte moderno en el icónico Palau de la Música Catalana de Barcelona.', 'Ayuntamiento Barcelona', 2, 4),
    ('Obra de Teatro Dramática en la Ciudad de las Artes y las Ciencias', 18.00, '2023-11-30', '19:30:00', 'Sumérgete en una emocionante obra de teatro dramática en la Ciudad de las Artes y las Ciencias de Valencia.', 'Ayuntamiento Valencia', 3, 6);

-- Sample data for the 'Asistente' table
INSERT INTO Asistente (nombre, apellido1, telefono, correo)
VALUES
    ('Juan', 'Gómez', '+123456789', 'juan@gmail.com'),
    ('Maria', 'López', '+987654321', 'maria@hotmail.com'),
    ('Carlos', 'Martínez', '+567890123', 'carlos@yahoo.com'),
    ('Ana', 'Rodríguez', '+345678901', 'ana@gmail.com'),
    ('Pedro', 'Fernández', '+789012345', 'pedro@hotmail.com'),
    ('Laura', 'Pérez', '+456789012', 'laura@yahoo.com'),
    ('Miguel', 'Torres', '+567890123', 'miguel@gmail.com'),
    ('Carmen', 'Sánchez', '+123456789', 'carmen@hotmail.com'),
    ('Javier', 'Ramírez', '+234567890', 'javier@yahoo.com'),
    ('Sara', 'González', '+890123456', 'sara@gmail.com');
    
-- Sample data for the 'Encuesta' table
INSERT INTO Encuesta (pregunta, fecha_realizacion, resultados, ID_evento, ID_asistente)
VALUES
    ('¿Cómo calificaría el evento?', '2023-11-20', 'Bueno', 1, 1),
    ('¿Cómo calificaría el evento?', '2023-12-05', 'Muy Bueno', 1, 2),
    ('¿Cómo calificaría el evento?', '2023-12-12', 'Regular', 1, 3),
    ('¿Opiniones sobre la exposición?', '2023-12-15', 'Regular', 2, 5),
    ('¿Opiniones sobre la exposición?', '2023-12-25', 'Muy Bueno', 2, 7),
    ('¿Experiencia en la obra de teatro?', '2023-12-07', 'Malo', 3, 8),
    ('¿Experiencia en la obra de teatro?', '2023-11-29', 'Regular', 3, 10);
    
-- Sample data for the 'Asistente' to 'Evento' relationship
INSERT INTO Asistente_Evento (ID_asistente, ID_evento)
VALUES
    (1, 1),
    (2, 1),
    (3, 1),
    (4, 1),
    (5, 2),
    (6, 2),
    (7, 2),
    (8, 3),
    (9, 3),
    (10, 3);

-- Sample data for the 'Artista' to 'Evento' relationship
INSERT INTO Artista_Evento (ID_artista, ID_evento)
VALUES
    (1, 1),
    (2, 1),
    (3, 1),
    (4, 2),
    (5, 2),
    (6, 3),
    (7, 3),
    (8, 3);

-- Sample data for the 'Artista' to 'Actividad' relationship
INSERT INTO Artista_Actividad (ID_artista, ID_actividad)
VALUES
    (1, 3),
    (2, 3),
    (3, 3),
    (4, 4),
    (5, 4),
    (6, 6),
    (7, 6),
    (8, 6);

-- Sample data for the 'Evento' to 'Punto_venta' relationship
INSERT INTO Evento_puntoVenta (ID_evento, ID_puntoVenta)
VALUES
    (1, 1),
    (1, 2),
    (1, 3),
    (2, 3),
    (3, 2),
    (3, 3);

-- Sample data for the 'Asistente' to 'Punto_venta' relationship
INSERT INTO Asistente_puntoVenta (ID_asistente, ID_puntoVenta, fecha_compra)
VALUES
    (1, 1, '2023-10-12'),
    (2, 2, '2023-11-05'),
    (3, 3, '2023-09-02'),
    (4, 1, '2023-08-15'),
    (5, 3, '2023-07-20'),
    (6, 3, '2023-07-25'),
    (7, 3, '2023-10-24'),
    (8, 2, '2023-11-10'),
    (9, 2, '2023-11-29'),
    (10, 3, '2023-09-05');

-- Sample data for the 'Punto_venta' to 'Metodo_pago' relationship
INSERT INTO Punto_venta_Metodo_pago (ID_puntoVenta, ID_metodoPago)
VALUES
    (1, 1),
    (1, 3),
    (2, 1),
    (2, 2),
    (2, 3),
    (3, 3);

-- Trigger to validate that the survey date is after the event
DELIMITER //
CREATE TRIGGER ValidarFechaEncuesta
BEFORE INSERT ON Encuesta
FOR EACH ROW
BEGIN
    DECLARE evento_fecha DATE;
    
    -- Get the date of the event associated with the survey
    SELECT fecha INTO evento_fecha
    FROM Evento
    WHERE ID_evento = NEW.ID_evento;
    
    IF NEW.fecha_realizacion < evento_fecha THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The survey date must be after the event date.';
    END IF;
END;
//
DELIMITER ;

-- Error to test the Trigger
/*
INSERT INTO Encuesta (pregunta, fecha_realizacion, resultados, ID_evento, ID_asistente)
VALUES
    ('¿Cómo calificaría el evento?', '2023-10-20', 'Muy Bueno', 1, 4);
*/

/*------------------------------------------------------------------------------------------------------
Consultas, modificaciones, borrados y vistas con enunciado
-------------------------------------------------------------------------------------------------------*/ 

-- 1) Get all events of a specific activity (by activity name)
SELECT E.nombre AS 'Nombre del Evento', A.nombre AS 'Nombre de Actividad'
FROM Evento E
JOIN Actividad A ON E.ID_actividad = A.ID_actividad
WHERE A.nombre = 'Concierto de Musica';

-- 2) Get events within a price range (by ticket price)
SELECT nombre AS 'Nombre del Evento', precio_entrada AS 'Precio de Entrada'
FROM Evento
WHERE precio_entrada BETWEEN 15.00 AND 25.00;

-- 3) Get sales points located in a specific city or town (by city/town)
SELECT PV.nombre AS 'Nombre del Punto de Venta', D.ciudad_pueblo AS 'Ciudad'
FROM Punto_venta PV
JOIN Direccion D ON PV.ID_direccion = D.ID_direccion
WHERE D.ciudad_pueblo = 'Valencia';

-- 4) Get surveys conducted by attendees with names starting with 'C'
SELECT A.nombre AS 'Nombre del Asistente', E.pregunta AS 'Pregunta', E.resultados AS 'Respuesta'
FROM Asistente A
JOIN Encuesta E ON A.ID_asistente = E.ID_asistente
WHERE A.nombre LIKE 'C%';

-- 5) Get total revenues generated for each event
SELECT E.nombre AS 'Nombre del Evento', SUM(E.precio_entrada) AS 'Ingresos Totales'
FROM Evento E
JOIN Asistente_Evento AE ON E.ID_evento = AE.ID_evento
GROUP BY E.nombre;

-- 6) Get surveys conducted for a specific event
SELECT EV.nombre AS 'Evento' ,E.pregunta AS 'Pregunta', E.resultados AS 'Resultados'
FROM Encuesta E, Evento EV
WHERE E.ID_evento = EV.ID_evento
	AND E.ID_evento = 1
ORDER BY E.resultados DESC;

-- 7) Calculate the average rating per event (enthusiasm level) and assign numeric values to responses, rounding to one decimal place
SELECT
    EV.nombre AS 'Evento',
    ROUND(AVG(
        CASE
            WHEN E.resultados = 'Muy Malo' THEN 1
            WHEN E.resultados = 'Malo' THEN 2
            WHEN E.resultados = 'Regular' THEN 3
            WHEN E.resultados = 'Bueno' THEN 4
            WHEN E.resultados = 'Muy Bueno' THEN 5
            ELSE 0
        END
    ), 1) AS 'Nivel de entusiasmo'
FROM Encuesta E
JOIN Evento EV ON E.ID_evento = EV.ID_evento
GROUP BY EV.nombre;


-- 8) Find the list of attendees who have made purchases at a specific sales point
SELECT A.nombre AS 'Nombre del Asistente', A.apellido1 AS 'Apellido', A.telefono AS 'Teléfono', A.correo AS 'Correo', PV.nombre AS 'Punto de Venta'
FROM Asistente AS A
INNER JOIN Asistente_puntoVenta AS APV ON A.ID_asistente = APV.ID_asistente
INNER JOIN Punto_venta AS PV ON APV.ID_puntoVenta = PV.ID_puntoVenta
WHERE APV.ID_puntoVenta = 1;

-- 9) Find artists who have not yet performed in any events
INSERT INTO Artista (nombre, cache, biografia)
VALUES
	-- Jazz Music Artists
    ('Wynton Marsalis', 8000.00, 'Wynton Marsalis is a renowned American jazz trumpeter, composer, and bandleader.'),
    ('Diana Krall', 7500.00, 'Diana Krall is a Canadian jazz pianist and singer known for her smooth vocals and piano skills.'),
    ('Esperanza Spalding', 7000.00, 'Esperanza Spalding is an American jazz bassist and singer who has made significant contributions to the genre.'),
    -- Classical Music Artists
    ('Yo-Yo Ma', 8500.00, 'Yo-Yo Ma is a world-famous French-born American cellist known for his classical music performances.'),
    ('Lang Lang', 8200.00, 'Lang Lang is a Chinese concert pianist who has gained international recognition for his piano virtuosity.'),
    ('Renée Fleming', 7800.00, 'Renée Fleming is an American opera soprano renowned for her powerful and emotive vocal performances.');

SELECT A.nombre AS 'Nombre del Artista'
FROM Artista A
LEFT JOIN Artista_Evento AE ON A.ID_artista = AE.ID_artista
WHERE AE.ID_artista IS NULL;

-- 10) Word frequency in event descriptions
SELECT palabras.palabra AS 'Palabra', COUNT(eventos.descripcion) AS 'Frecuencia'
FROM (
    SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(descripcion, ' ', n), ' ', -1) AS palabra
    FROM Evento
    JOIN (
        SELECT 1 + units.i + tens.i * 10 + hundreds.i * 100 AS n
        FROM (
            SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
        ) units
        JOIN (
            SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
        ) tens
        JOIN (
            SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
        ) hundreds
    ) numbers
    ON CHAR_LENGTH(descripcion)
       -CHAR_LENGTH(REPLACE(descripcion, ' ', '')) >= n - 1
) palabras
JOIN Evento eventos
ON eventos.descripcion LIKE CONCAT('%', palabras.palabra, '%')
GROUP BY palabras.palabra
ORDER BY Frecuencia DESC;

-- Create a view that displays the sum of artist cache per event
CREATE VIEW Vista_Suma_Cache_Artistas AS
SELECT
    E.ID_evento,
    E.nombre AS 'Evento',
    SUM(A.cache) AS 'Suma del Cache de Artistas'
FROM Evento E
LEFT JOIN Artista_Evento AE ON E.ID_evento = AE.ID_evento
LEFT JOIN Artista A ON AE.ID_artista = A.ID_artista
GROUP BY E.ID_evento, E.nombre;

-- Query the view to get the sum of artist cache per event
SELECT * FROM Vista_Suma_Cache_Artistas;

-- Create a view that displays events and the sales points where tickets were sold
CREATE VIEW Vista_Eventos_PuntosVenta AS
SELECT E.nombre AS 'Evento',
       PV.nombre AS 'Punto de Venta'
FROM Evento_puntoVenta EPV
JOIN Evento E ON EPV.ID_evento = E.ID_evento
JOIN Punto_venta PV ON EPV.ID_puntoVenta = PV.ID_puntoVenta;

-- Query the view to get events and the sales points where tickets were sold
SELECT * FROM Vista_Eventos_PuntosVenta;

-- Create a view that displays artists and the number of events they have participated in
CREATE VIEW Vista_Artistas_Eventos AS
SELECT A.nombre AS 'Nombre del Artista', COUNT(AE.ID_evento) AS 'Eventos Realizados'
FROM Artista A
LEFT JOIN Artista_Evento AE ON A.ID_artista = AE.ID_artista
GROUP BY A.nombre;

-- Query the view to get artists and the number of events they have participated in
SELECT * FROM Vista_Artistas_Eventos;

-- Remove artists with a cache less than 8000.00
SELECT * FROM Artista; -- Before

DELETE FROM Artista
WHERE cache < 8000.00;

SELECT * FROM Artista; -- After

-- Add the 'start_date_of_sale' attribute to the 'Event_Sales_Point' table
SELECT * FROM Evento_puntoVenta; -- Before alter table

ALTER TABLE Evento_puntoVenta
ADD fecha_inicio_venta DATE;

SELECT * FROM Evento_puntoVenta; -- Before adding new data

-- Update the start date of sale for specific records in Event_Sales_Point
UPDATE Evento_puntoVenta
SET fecha_inicio_venta = '2023-08-01'
WHERE ID_evento = 1;

UPDATE Evento_puntoVenta
SET fecha_inicio_venta = '2023-06-01'
WHERE ID_evento = 2;

UPDATE Evento_puntoVenta
SET fecha_inicio_venta = '2023-04-01'
WHERE ID_evento = 3;

SELECT * FROM Evento_puntoVenta; -- After adding new data
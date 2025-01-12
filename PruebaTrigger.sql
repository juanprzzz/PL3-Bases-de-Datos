\pset pager off

SET client_encoding = 'UTF8';

BEGIN;

\echo '-----------------------MOSTRANDO CONSULTAS--------------------'

--mostrar tabla auditoria inicial
SELECT * FROM auditoria 


\echo '-----------------------INSERTS--------------------'
-- Crear registros de prueba para la tabla "disco"
INSERT INTO disco (nombre_grupo, titulo_disco, anio_publicacion, url_portada)
VALUES ('The Guana Batz', 'PRUEBADISCO', 2020, 'http://example.com/thecave.jpg');

-- Crear registros de prueba para la tabla "edicion"
INSERT INTO edicion (formato, anio_edicion, pais, titulo_disco, anio_publicacion)
VALUES ('Vinyl', 2024, 'UK', 'PRUEBADISCO', 2020);

-- Crear registros de prueba para la tabla "desea"
INSERT INTO desea (titulo_disco, anio_publicacion, nombre_usuario)
VALUES ('PRUEBADISCO', 2020, 'juangomez');

SELECT * FROM desea WHERE nombre_usuario='juangomez'; 
SELECT * FROM tiene WHERE nombre_usuario='juangomez';

-- Crear registros de prueba para la tabla "tiene". Al insertar en tiene, se debería borrar de desea
INSERT INTO tiene (formato, pais, anio_edicion, titulo_disco, anio_publicacion, nombre_usuario, estado)
VALUES ('Vinyl', 'UK', 2024, 'PRUEBADISCO', 2020, 'juangomez', 'VG');

SELECT * FROM desea WHERE nombre_usuario='juangomez';
SELECT * FROM tiene WHERE nombre_usuario='juangomez';

-- Consultar la tabla "auditoria" para verificar las inserciones realizadas por los triggers
SELECT * FROM auditoria;

\echo '-----------------------UPDATES--------------------'
-- Actualizar registros para activar el trigger en "disco"
UPDATE disco
SET url_portada = 'http://example.com/thecave-updated.jpg'
WHERE titulo_disco = 'PRUEBADISCO';


\echo '-----------------------DELETES--------------------'
-- Eliminar registros para activar el trigger en "tiene"
DELETE FROM tiene
WHERE titulo_disco = 'PRUEBADISCO';

-- Consultar la tabla "auditoria" para verificar los cambios realizados por los triggers
SELECT * FROM auditoria;

ROLLBACK;

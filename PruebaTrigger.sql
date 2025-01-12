\pset pager off

SET client_encoding = 'UTF8';

BEGIN;

\echo '-----------------------MOSTRANDO CONSULTAS--------------------'

--mostrar tabla auditoria inicial
SELECT * FROM auditoria ;


\echo '-----------------------INSERTS--------------------'
\echo 'Insert into disco y edicion los discos pruebadisco y rockthis'
-- Crear registros de prueba para la tabla "disco"
INSERT INTO disco (nombre_grupo, titulo_disco, anio_publicacion, url_portada)
VALUES 
('The Guana Batz', 'PRUEBADISCO', 2020, 'http://example.com/thecave.jpg'),
('The Guana Batz', 'ROCKTHIS', 2021, 'http://example.com/rockthis.jpg');

-- Crear registros de prueba para la tabla "edicion"
INSERT INTO edicion (formato, anio_edicion, pais, titulo_disco, anio_publicacion)
VALUES 
('CD', 2024, 'UK', 'PRUEBADISCO', 2020),
('CD', 2021, 'US', 'ROCKTHIS', 2021);

\echo 'Ver discos insertados'
SELECT * FROM disco WHERE titulo_disco IN ('PRUEBADISCO','ROCKTHIS');

\echo 'insert into desea pruebadisco a juangomez'
-- Crear registros de prueba para la tabla "desea"
INSERT INTO desea (titulo_disco, anio_publicacion, nombre_usuario)
VALUES ('PRUEBADISCO', 2020, 'juangomez');

\echo 'Select from desea de juangomez (está pruebadisco)'
SELECT * FROM desea WHERE nombre_usuario='juangomez'; 
\echo 'Select from tiene (no tiene aún pruebadisco)'
SELECT * FROM tiene WHERE nombre_usuario='juangomez';

\echo 'insert into tiene pruebadisco a juangomez'
-- Crear registros de prueba para la tabla "tiene". Al insertar en tiene, se debería borrar de desea
INSERT INTO tiene (formato, pais, anio_edicion, titulo_disco, anio_publicacion, nombre_usuario, estado)
VALUES ('CD', 'UK', 2024, 'PRUEBADISCO', 2020, 'juangomez', 'VG');

\echo 'Select from desea (ya no aparece pruebadisco)'
SELECT * FROM desea WHERE nombre_usuario='juangomez';
\echo 'Select from tiene (ahora aquí si está pruebadisco)'
SELECT * FROM tiene WHERE nombre_usuario='juangomez';

-- Consultar la tabla "auditoria" para verificar las inserciones realizadas por los triggers
\echo 'Select from auditoria (nuevos valores: insert into disco (2), desea, tiene. delete from desea)'
SELECT * FROM auditoria;




\echo 'Update en disco'
-- Actualizar registros para activar el trigger en "disco"
UPDATE disco
SET url_portada = 'http://example.com/thecave-updated.jpg'
WHERE titulo_disco = 'PRUEBADISCO';
SELECT * FROM disco WHERE titulo_disco='PRUEBADISCO';

-- Cambiar el formato en "tiene"
\echo 'update en edición (y en tiene por el "on update cascade"): cambiando formato de "pruebadisco"'
UPDATE edicion
SET formato = 'Vinyl'
WHERE titulo_disco = 'PRUEBADISCO';


-- Consultar la tabla "auditoria" para verificar los cambios realizados por los triggers
\echo 'Select from auditoría (nuevos valores: update en disco y tiene )'
SELECT * FROM auditoria;


\echo 'Delete from tiene'
DELETE FROM tiene
WHERE titulo_disco = 'PRUEBADISCO';

\echo 'Delete en edicion y disco: eliminando "ROCKTHIS"'
DELETE FROM edicion
WHERE titulo_disco = 'ROCKTHIS';

DELETE FROM disco
WHERE titulo_disco = 'ROCKTHIS';

-- Consultar la tabla "auditoria" para verificar los cambios realizados por los triggers
\echo 'Select from auditoría (nuevos valores: delete en tiene y disco)'
SELECT * FROM auditoria;





ROLLBACK;

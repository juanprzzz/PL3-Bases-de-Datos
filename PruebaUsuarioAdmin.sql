\pset pager off

SET client_encoding = 'UTF8';

BEGIN;
\echo 'Este usuario puede llevar a cabo cualquier operación'

INSERT INTO disco (nombre_grupo, titulo_disco, anio_publicacion, url_portada)
VALUES ('The Guana Batz', 'PRUEBADISCO', 2020, 'http://example.com/thecave.jpg');

\echo 'Se inserta un disco de prueba, y se muestran algunos discos, incluidos el añadido'

SELECT nombre_grupo, titulo_disco, anio_publicacion
FROM disco
WHERE anio_publicacion = 2020;

\echo 'Se actualiza el disco de prueba al año de publicación 2019'

UPDATE disco
SET anio_publicacion = 2019
WHERE nombre_grupo = 'The Guana Batz' AND titulo_disco = 'PRUEBADISCO';

SELECT nombre_grupo, titulo_disco, anio_publicacion
FROM disco
WHERE anio_publicacion = 2019;

\echo 'Se elimina el disco de prueba y se muestra que ya no aparece'

DELETE FROM disco WHERE nombre_grupo = 'The Guana Batz' AND titulo_disco = 'PRUEBADISCO';

SELECT nombre_grupo, titulo_disco
FROM disco
WHERE anio_publicacion = 2019;

\echo 'Se crea una tabla nueva, se inserta valor, y se muestra'

CREATE TABLE prueba(
    prueba TEXT
);
INSERT INTO prueba (prueba) VALUES ('prueba');
SELECT * FROM prueba;

\echo 'Se elimina la tabla'
DROP TABLE prueba;







ROLLBACK;
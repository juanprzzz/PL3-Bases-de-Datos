\pset pager off

SET client_encoding TO 'UTF8';
SET search_path TO public;

BEGIN;
-- Prueba de admins
\echo ''
\echo '------------------Usuario Admin-------------------' 
SET ROLE admins;

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

RESET ROLE;
ROLLBACK; 



BEGIN;
--Prueba de gestores
\echo ''
\echo '------------------Usuario gestor------------------' 
SET ROLE gestores;
\echo 'Este usuario puede insertar, borrar, actualizar y borrar, pero no puede crear nuevas tablas'


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

\echo 'Ahora si queremos crear una tabla, dará error'

CREATE TABLE prueba(
    prueba TEXT
);
INSERT INTO prueba (prueba) VALUES ('prueba');
SELECT * FROM prueba;
RESET ROLE;
ROLLBACK; 


BEGIN;
-- Prueba de clientes
\echo ''
\echo '------------------Usuario cliente------------------' 
SET ROLE clientes;


\echo 'Este usuario solo puede consultar e insertar en usuario_tiene_ediciones y en usuario_desea_disco'


\echo 'Hacemos una consulta en cada tabla para comprobar que funciona'

SELECT *
FROM tiene
WHERE anio_edicion = 2020;

SELECT *
FROM desea
WHERE nombre_usuario = 'juangomez';

\echo 'Insertamos un valor en la tabla, para comprobar que funciona'
INSERT INTO desea (titulo_disco, anio_publicacion, nombre_usuario)
VALUES ('Closer', 2020, 'juangomez');

SELECT *
FROM desea
WHERE nombre_usuario = 'juangomez';
\echo 'Sin embargo, al eliminar este mismo elemento que hemos añadido, provocará un error'
DELETE FROM desea WHERE nombre_usuario = 'juangomez' AND titulo_disco = 'PRUEBADISCO' AND anio_publicacion = 2020;

RESET ROLE;
ROLLBACK; 

BEGIN;
--Prueba de invitados
\echo ''
\echo '------------------Usuario Invitado------------------'
SET ROLE invitados;


\echo 'Este usuario solo puede consultar las tablas discos y canciones'

\echo 'Consulta tabla disco'
SELECT titulo_disco
FROM disco
WHERE anio_publicacion = 2020;

\echo 'Consulta tabla canción'
SELECT titulo_cancion
FROM cancion
WHERE anio_publicacion = 2020;

\echo 'Si queremos consultar otra tabla o realizar cualquier acción dará error'

SELECT titulo_disco
FROM tiene
WHERE anio_publicacion = 2020;
RESET ROLE;


ROLLBACK;                
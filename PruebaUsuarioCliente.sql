\pset pager off

SET client_encoding = 'UTF8';

BEGIN;
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

ROLLBACK;
\pset pager off

SET client_encoding = 'UTF8';

BEGIN;

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













ROLLBACK;
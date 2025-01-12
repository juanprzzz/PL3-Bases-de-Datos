\pset pager off

SET client_encoding = 'UTF8';

BEGIN;

\echo 'Consulta dirigida a comprobar que los invitados solo pueden consultar tabla discos y canciones'

--Consulta que funciona para todos los usuarios menos para cliente
IF current_user = 'cliente' THEN

    SELECT cancion.titulo_disco, cancion.anio_publicacion
    FROM cancion
    GROUP BY cancion.titulo_disco,  cancion.anio_publicacion
    HAVING COUNT(*) > 5
    ORDER BY cancion.anio_publicacion, cancion.titulo_disco
END IF;

--Consulta que funciona para todos los usuarios menos para cliente
\echo 'La siguiente consulta funciona para todos los usuarios menos para cliente, que no se ejecutará para éste'
IF current_user = 'cliente' THEN
    SELECT nombre_grupo
    FROM disco
    WHERE anio_publicacion > 2010
END IF;

--Consulta que funciona para todos menos para invitado Y cliente

\echo 'Si estás en modo invitado, a partir de la siguiente consulta dará fallo, si eres cliente no dará fallo porque no se ejecutará esta consulta'







ROLLBACK;

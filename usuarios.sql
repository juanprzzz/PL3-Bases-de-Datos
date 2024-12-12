/* Creando usuarios */

CREATE USER admin WITH PASSWORD 'admin';
CREATE USER gestor WITH PASSWORD 'gestor';
CREATE USER cliente WITH PASSWORD 'cliente';
CREATE USER invitado WITH PASSWORD 'invitado';

/*Asignación de permisos REVISARRRR*/

GRANT ALL ON pl3 TO admin;
GRANT INSERT, UPDATE, DELETE, SELECT ON pl3 TO gestor;

GRANT SELECT ON pl3 TO cliente;
GRANT INSERT ON tiene, desea TO cliente;

GRANT SELECT ON disco, cancion TO invitado;
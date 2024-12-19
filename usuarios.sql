/* Creando usuarios */

CREATE USER admin WITH PASSWORD 'admin';
CREATE USER gestor WITH PASSWORD 'gestor';
CREATE USER cliente WITH PASSWORD 'cliente';
CREATE USER invitado WITH PASSWORD 'invitado';

/*Asignación de permisos*/

GRANT ALL ON auditoria, cancion, desea, disco, edicion, genero, grupo, tiene, usuario TO admin;
GRANT INSERT, UPDATE, DELETE, SELECT ON auditoria, cancion, desea, disco, edicion, genero, grupo, tiene, usuario TO gestor;

GRANT SELECT ON tiene, desea TO cliente;
GRANT INSERT ON tiene, desea TO cliente;

GRANT SELECT ON disco, cancion TO invitado;
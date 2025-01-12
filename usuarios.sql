/* Creando grupos de usuarios */

CREATE ROLE admins WITH SUPERUSER;
CREATE ROLE gestores;
CREATE ROLE clientes;
CREATE ROLE invitados;

/*Asignación de permisos*/

--GRANT ALL ON auditoria, cancion, desea, disco, edicion, genero, grupo, tiene, usuario TO admins;
--GRANT CREATE ON DATABASE pl3 TO admins;
GRANT INSERT, UPDATE, DELETE, SELECT ON auditoria, cancion, desea, disco, edicion, genero, grupo, tiene, usuario TO gestores;

GRANT SELECT ON tiene, desea TO clientes;
GRANT INSERT ON tiene, desea TO clientes;

GRANT SELECT ON disco, cancion TO invitados;

/*Creando usuarios y asignándoles un role*/

CREATE USER admin WITH PASSWORD 'admin';
CREATE USER gestor WITH PASSWORD 'gestor';
CREATE USER cliente WITH PASSWORD 'cliente';
CREATE USER invitado WITH PASSWORD 'invitado';

GRANT admins TO admin;
GRANT gestores TO gestor;
GRANT clientes TO cliente;
GRANT invitados TO invitado;


/*
Para quitar los usuarios anteriores hay que llevar a cabo los siguientes comandos, primero hay que quitar todos los permisos, y luego quitar los usuarios, una vez hecho eso, volver a ejecutar el .sql:
    Para admin:
    REVOKE ALL PRIVILEGES ON auditoria, cancion, desea, disco, edicion, genero, grupo, tiene, usuario FROM admin; DROP USER admin;DROP USER admins;
    Para gestor:
    REVOKE ALL PRIVILEGES ON auditoria, cancion, desea, disco, edicion, genero, grupo, tiene, usuario FROM gestor; DROP USER gestor;DROP user gestores;
    Para cliente:
    REVOKE ALL PRIVILEGES ON tiene, desea FROM cliente; DROP USER cliente;DROP USER clientes;
    Para invitado:
    REVOKE ALL PRIVILEGES ON disco, cancion FROM invitado; DROP USER invitado;DROP USER invitados;
*/


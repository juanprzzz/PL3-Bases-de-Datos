DROP USER admin;
DROP USER gestor;
DROP USER cliente;
DROP USER invitado;

-- Creando grupos de usuarios 
CREATE ROLE admins WITH SUPERUSER; 
CREATE ROLE gestores;             
CREATE ROLE clientes;
CREATE ROLE invitados;

-- Asignación de permisos 

--Permitir a los admins crear, modificar y administrar el esquema y la base de datos 
GRANT CREATE, USAGE ON SCHEMA public TO admins;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admins;

-- Permisos para gestores 
GRANT INSERT, UPDATE, DELETE, SELECT ON ALL TABLES IN SCHEMA public TO gestores;

-- Permisos para clientes 
GRANT SELECT, INSERT ON tiene, desea TO clientes;

-- Permisos para invitados 
GRANT SELECT ON disco, cancion TO invitados;

-- Permisos futuros (opcional, para nuevos objetos) 
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO admins;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT ON TABLES TO gestores;

-- Creando usuarios y asignándoles un role 
CREATE USER admin WITH PASSWORD 'admin'; -- Usuario admin con herencia
CREATE USER gestor WITH PASSWORD 'gestor';
CREATE USER cliente WITH PASSWORD 'cliente';
CREATE USER invitado WITH PASSWORD 'invitado';

-- Asignar roles a los usuarios 
GRANT admins TO admin;
GRANT gestores TO gestor;
GRANT clientes TO cliente;
GRANT invitados TO invitado;


/*
Para quitar los usuarios anteriores hay que llevar a cabo los siguientes comandos, primero hay que quitar todos los permisos, y luego quitar los usuarios, una vez hecho eso, volver a ejecutar el .sql:
    Para admin:
    REVOKE ALL PRIVILEGES ON DATABASE pl3 FROM admins; DROP USER admin;DROP USER admins;
    ON DATABASE pl3
    Para gestor:
    REVOKE ALL PRIVILEGES FROM gestor; DROP USER gestor;DROP user gestores;
    Para cliente:
    REVOKE ALL PRIVILEGES ON DATABASE pl3 FROM cliente; DROP USER cliente;DROP USER clientes;
    Para invitado:
     REVOKE ALL PRIVILEGES ON disco,cancion FROM invitado; DROP USER invitado;DROP USER invitados;
*/


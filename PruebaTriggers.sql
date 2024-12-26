CREATE TABLE auditoria (
  accion text,
  fecha timestamp,
  usuario text,
  tabla text
);

-- Se crea la función que se ejecutará 
CREATE OR REPLACE FUNCTION fn_auditoria() RETURNS TRIGGER AS $fn_auditoria$
  BEGIN
  -- Se determina que acción a activado el trigger e inserta un nuevo valor en la tabla dependiendo
  -- del dicha acción
  -- Junto con la acción se escribe fecha y hora en la que se ha producido la acción
  IF TG_OP='INSERT' OR TG_OP='UPDATE' OR TG_OP='DELETE' THEN
      INSERT INTO auditoria VALUES (TG_OP,current_timestamp,current_user,TG_RELNAME);
  END IF;
  RETURN NULL;
  END;
$fn_auditoria$ LANGUAGE plpgsql;
/*
CREATE OR REPLACE FUNCTION fn_auditoria_disco() RETURNS TRIGGER AS $fn_auditoria_disco$
  DECLARE
  --  no declaro nada porque no me hace falta...de hecho DECLARE podría haberlo omitido en éste caso
  BEGIN
  -- Se determina que acción a activado el trigger e inserta un nuevo valor en la tabla dependiendo
  -- del dicha acción
  -- Junto con la acción se escribe fecha y hora en la que se ha producido la acción
   /*IF TG_OP='INSERT' THEN
     INSERT INTO auditoria VALUES (TG_OP,current_timestamp, current_user, 'Disco');  -- Cuando hay una inserción. probar a poner solo 1 funcion en vez de 2 y usar TG_RELNAME
   ELSIF TG_OP='UPDATE'	THEN
     INSERT INTO auditoria VALUES ('modificación',current_timestamp,current_user,'Disco'); -- Cuando hay una modificación
   ELSEIF TG_OP='DELETE' THEN
     INSERT INTO auditoria VALUES ('borrado',current_timestamp,current_user,'Disco'); -- Cuando hay un borrado
   END IF;	 */
   INSERT INTO auditoria VALUES (TG_OP,current_timestamp,current_user,'Disco');
   RETURN NULL;
  END;
$fn_auditoria_disco$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fn_auditoria_desea() RETURNS TRIGGER AS $fn_auditoria_desea$
  BEGIN
   IF TG_OP='INSERT' THEN
     INSERT INTO auditoria VALUES ('alta',current_timestamp, current_user, 'Desea');  -- Cuando hay una inserción
   ELSIF TG_OP='UPDATE'	THEN
     INSERT INTO auditoria VALUES ('modificación',current_timestamp,current_user,'Desea'); -- Cuando hay una modificación
   ELSEIF TG_OP='DELETE' THEN
     INSERT INTO auditoria VALUES ('borrado',current_timestamp,current_user,'Desea'); -- Cuando hay un borrado
   END IF;	 
   RETURN NULL;
  END;
$fn_auditoria_desea$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fn_auditoria() RETURNS TRIGGER AS $fn_auditoria$
  BEGIN
   IF TG_OP='INSERT' THEN
     INSERT INTO auditoria VALUES (TG_OP,current_timestamp, current_user, TG_RELNAME);  -- Cuando hay una inserción
   ELSIF TG_OP='UPDATE'	THEN
     INSERT INTO auditoria VALUES (TG_OP,current_timestamp,current_user,TG_RELNAME); -- Cuando hay una modificación
   ELSEIF TG_OP='DELETE' THEN
     INSERT INTO auditoria VALUES (TG_OP,current_timestamp,current_user,TG_RELNAME); -- Cuando hay un borrado
   END IF;	 
   RETURN NULL;
  END;
$fn_auditoria$ LANGUAGE plpgsql;*/

--INSERT INTO tiene VALUES('Vinyl', 'UK', 2010, 'Home To You', 1970, juangomez, 'VG');


-- Se crea el trigger que se dispara cuando hay una inserción, modificación o borrado en la tabla sala

CREATE TRIGGER tg_auditoria_disco after INSERT or UPDATE or DELETE
  ON disco 
  FOR EACH ROW
  EXECUTE PROCEDURE fn_auditoria(); 

  CREATE TRIGGER tg_auditoria_desea after INSERT or UPDATE or DELETE
  ON desea FOR EACH ROW
  EXECUTE PROCEDURE fn_auditoria(); 

  CREATE TRIGGER tg_auditoria_tiene after INSERT or UPDATE or DELETE
  ON tiene FOR EACH ROW
  EXECUTE PROCEDURE fn_auditoria(); 
  
  --INSERT INTO desea (titulo_disco, anio_publicacion, nombre_usuario) VALUES ('The Cave',2014,'juangomez'); 
--INSERT INTO tiene (formato,pais,anio_edicion,titulo_disco,anio_publicacion,nombre_usuario,estado) VALUES ('Vinyl','UK',1984,'The Cave',2014,'lorenasaez','EX');

---------------------------------------


CREATE OR REPLACE FUNCTION fn_usuario_tiene_edicion() RETURNS TRIGGER AS $fn_usuario_tiene_edicion$
  BEGIN
   IF TG_OP='INSERT' THEN
     IF EXISTS(
      SELECT 1 --select * ver
      FROM desea
      WHERE desea.nombre_usuario = NEW.nombre_usuario
      AND desea.titulo_disco = NEW.titulo_disco
      AND desea.anio_publicacion = NEW.anio_publicacion
     )
     THEN
        DELETE FROM desea
        WHERE desea.nombre_usuario = NEW.nombre_usuario
      AND desea.titulo_disco = NEW.titulo_disco
      AND desea.anio_publicacion = NEW.anio_publicacion;
      END IF;
   END IF;	 
   RETURN NEW;
  END;
$fn_usuario_tiene_edicion$ LANGUAGE plpgsql;

  CREATE TRIGGER tg_usuario_tiene_edicion after INSERT
  ON tiene FOR EACH ROW
  EXECUTE PROCEDURE fn_usuario_tiene_edicion(); 

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
  -- de dicha acción
  -- Junto con la acción se escribe fecha y hora en la que se ha producido la acción
  IF TG_OP='INSERT' OR TG_OP='UPDATE' OR TG_OP='DELETE' THEN
      INSERT INTO auditoria (accion, fecha, usuario, tabla) VALUES (TG_OP, current_timestamp, current_user, TG_RELNAME);
  END IF;
  RETURN NULL; 
  END;
$fn_auditoria$ 
LANGUAGE plpgsql
SECURITY DEFINER;

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
  
---------------------------------------

CREATE OR REPLACE FUNCTION fn_usuario_tiene_edicion()
RETURNS TRIGGER AS $fn_usuario_tiene_edicion$
BEGIN
   IF TG_OP = 'INSERT' THEN
       IF EXISTS(
          SELECT 1
          FROM desea
          WHERE desea.nombre_usuario = NEW.nombre_usuario
            AND desea.titulo_disco = NEW.titulo_disco
            AND desea.anio_publicacion = NEW.anio_publicacion
       ) THEN
           DELETE FROM desea
           WHERE desea.nombre_usuario = NEW.nombre_usuario
             AND desea.titulo_disco = NEW.titulo_disco
             AND desea.anio_publicacion = NEW.anio_publicacion;
       END IF;
   END IF;
   RETURN NEW;
END;
$fn_usuario_tiene_edicion$ 
LANGUAGE plpgsql
SECURITY DEFINER;


CREATE OR REPLACE TRIGGER tg_usuario_tiene_edicion after INSERT
  ON tiene FOR EACH ROW
  EXECUTE PROCEDURE fn_usuario_tiene_edicion(); 



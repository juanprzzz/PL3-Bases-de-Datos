
import sys
import psycopg2
import pytest
# PUERTO POR DEFECTO 5432
class portException(Exception): pass

def ask_port(msg):
    """
        ask for a valid TCP port
        ask_port :: String -> IO Integer | Exception
    """
    try:                                                                        # try
        answer  = input(msg)                                                    # pide el puerto
        port    = int(answer)                                                   # convierte a entero
        if (port < 1024) or (port > 65535):                                     # si el puerto no es valido
            raise ValueError                                                    # lanza una excepción
        else:
            return port
    except ValueError:     
        raise portException                                                     # raise portException
    #finally:                                                                    # finally
    #    return port                                                             # return port

def ask_conn_parameters():
    """
        ask_conn_parameters:: () -> IO String
        pide los parámetros de conexión
        TODO: cada estudiante debe introducir los valores para su base de datos
    """
    host = 'localhost'                                                          # 
    port = ask_port('TCP port number: ')                                        # pide un puerto TCP
    user = input("¿Con qué usuario desea iniciar?: ")                                                               # TODO
    password = input("Introduzca la contraseña: ")                                                               # TODO
    database = 'pl3'                                                               # TODO
    return (host, port, user,
             password, database)
def print_options():
    print("1 --- Mostrar los discos que tengan más de 5 canciones")
    print("2 --- Mostrar los vinilos que tiene el usuario Juan García Gómez junto con el título del disco, y el país y año de edición del mismo")
    print("3 --- Disco con mayor duración de la colección")
    print("4 --- De los discos que tiene en su lista de deseos el usuario Juan García Gómez, indicar el nombre de los grupos musicales que los interpretan.")
    print("5 --- Mostrar los discos publicados entre 1970 y 1972 junto con sus ediciones ordenados por el año de publicación")
    print("6 --- Listar el nombre de todos los grupos que han publicado discos del género ‘Electronic’")
    print("7 --- Lista de discos con la duración total del mismo, editados antes del año 2000")
    print("8 --- Lista de ediciones de discos deseados por el usuario Lorena Sáez Pérez que tiene el usuario Juan García Gómez")
    print("9 --- Lista todas las ediciones de los discos que tiene el usuario Gómez García en un estado NM o M")
    print("10--- Listar todos los usuarios junto al número de ediciones que tiene de todos los discos junto al año de lanzamiento de su disco más antiguo, el año de lanzamiento de su disco más nuevo, y el año medio de todos sus discos de su colección")
    print("11--- Listar el nombre de los grupos que tienen más de 5 ediciones de sus discos en la base de datos")
    print("12--- Lista el usuario que más discos, contando todas sus ediciones tiene en la base de datos")
    print("13--- Insertar un nuevo disco con su grupo y canciones")

def resolucion_consultas(option): #No existen switch en Python (Desde 3.10 match pero quién sabe si lo tendrá actualizado)
    if(option == "1"):
        query = "SELECT cancion.titulo_disco, cancion.anio_publicacion FROM cancion GROUP BY cancion.titulo_disco,  cancion.anio_publicacion HAVING COUNT(*) > 5 ORDER BY cancion.anio_publicacion, cancion.titulo_disco;"
    elif(option == "2"):
        query = "SELECT edicion.titulo_disco, edicion.pais, edicion.anio_edicion FROM edicion JOIN tiene ON ( edicion.formato = tiene.formato AND edicion.pais = tiene.pais AND edicion.anio_edicion = tiene.anio_edicion AND edicion.titulo_disco = tiene.titulo_disco AND edicion.anio_publicacion = tiene.anio_publicacion ) JOIN usuario ON tiene.nombre_usuario = usuario.nombre_usuario WHERE usuario.nombre = 'Juan García Gómez' ORDER BY edicion.anio_edicion, edicion.titulo_disco;"    
    elif(option == "3"):
        query = "WITH  disco_duracion AS( SELECT c.titulo_disco, SUM(c.duracion) AS duracion_total FROM cancion c GROUP BY (c.titulo_disco) ) SELECT dd.titulo_disco, dd.duracion_total FROM disco_duracion dd WHERE duracion_total=(SELECT MAX(duracion_total) FROM disco_duracion dd);"
    elif(option == "4"):
        query = "SELECT  d.titulo_disco, d.anio_publicacion, d.nombre_grupo FROM usuario u JOIN desea ds ON u.nombre_usuario=ds.nombre_usuario JOIN disco d ON ds.titulo_disco=d.titulo_disco AND ds.anio_publicacion=d.anio_publicacion WHERE u.nombre= 'Juan García Gómez' ORDER BY d.anio_publicacion, d.titulo_disco;"
    elif(option == "5"):
        query = "SELECT e.* FROM edicion e JOIN disco d ON d.titulo_disco = e.titulo_disco AND d.anio_publicacion=e.anio_publicacion WHERE d.anio_publicacion BETWEEN '1970' AND '1972' ORDER BY e.anio_publicacion, e.anio_edicion, d.titulo_disco;"
    elif(option == "6"):
        query = "SELECT DISTINCT d.nombre_grupo FROM disco d JOIN genero g ON g.titulo_disco=d.titulo_disco AND g.anio_publicacion=d.anio_publicacion WHERE g.genero='Electronic';"
    elif(option == "7"):
        query = "SELECT  d.titulo_disco, d.anio_publicacion, e.anio_edicion, SUM(c.duracion) AS duracion_total FROM disco d JOIN edicion e ON e.titulo_disco=d.titulo_disco AND e.anio_publicacion=d.anio_publicacion JOIN cancion c ON d.titulo_disco = c.titulo_disco AND d.anio_publicacion = c.anio_publicacion WHERE e.anio_edicion <=2000 AND e.anio_edicion > 0 GROUP BY d.titulo_disco, d.anio_publicacion, e.anio_edicion ORDER BY e.anio_edicion desc, d.anio_publicacion;"
    elif(option == "8"):
        query = "WITH juan_gomez_tiene as( SELECT t.titulo_disco, t.anio_publicacion FROM tiene t JOIN usuario u ON t.nombre_usuario = u.nombre_usuario WHERE u.nombre = 'Marta Díaz Moreno' ) SELECT d.titulo_disco, d.anio_publicacion FROM desea d JOIN juan_gomez_tiene jg ON d.titulo_disco=jg.titulo_disco JOIN usuario u ON u.nombre_usuario = d.nombre_usuario WHERE u.nombre = 'Marta Moreno Díaz';"
    elif(option == "9"):
        query = "SELECT  t.formato, t.pais, t.anio_edicion, t.titulo_disco, t.anio_publicacion FROM tiene t JOIN usuario u ON u.nombre_usuario=t.nombre_usuario WHERE u.nombre = 'Juan García Gómez' AND t.estado IN ('NM', 'M');"
    elif(option == "10"):
        query = "SELECT u.nombre, COUNT(t.titulo_disco) AS Nº_ediciones, MIN(t.anio_publicacion) AS disco_más_antiguo, MAX(t.anio_publicacion) AS disco_más_nuevo, ROUND(AVG(t.anio_publicacion)) AS media_años FROM usuario u JOIN tiene t ON u.nombre_usuario = t.nombre_usuario WHERE t.anio_publicacion>0 GROUP BY u.nombre ORDER BY u.nombre;"
    elif(option == "11"):
        query = "SELECT  d.nombre_grupo FROM disco d JOIN edicion e ON (e.titulo_disco = d.titulo_disco AND e.anio_publicacion = d.anio_publicacion) GROUP BY d.nombre_grupo HAVING COUNT(*) > 5 ORDER BY d.nombre_grupo;"
    elif(option == "12"):
        query = "WITH total_ediciones AS( SELECT t.nombre_usuario, COUNT(*) AS total_ediciones FROM tiene t GROUP BY t.nombre_usuario ) SELECT u.nombre_usuario, te.total_ediciones FROM usuario u JOIN total_ediciones te ON u.nombre_usuario = te.nombre_usuario WHERE te.total_ediciones=(SELECT MAX(total_ediciones) FROM total_ediciones);"
    #opcion 13 añadir disco
   # elif(option == "14"):
      #  query = "SELECT * FROM auditoria;"
   # elif(option == "100"):       #por si quieres probar lo de insertardisco() xd 
       # query = "SELECT * FROM disco WHERE titulo_disco='PRUEBADISCO';"
   # elif(option == "101"):
      #  query = "SELECT * FROM cancion WHERE titulo_disco='PRUEBADISCO';"
    else:
        print("Opción no válida")
    return query

def insertar_disco(conn, cursor):
    """
    Inserta un disco, su grupo y sus canciones en la base de datos.
    Si el disco ya existe, no se realiza la inserción.
    """
    try:
        # Pedir los datos básicos del disco
        titulo_disco = input("Introduce el título del disco: ")
        anio_publicacion = int(input("Introduce el año de publicación: "))  # Convertir a entero

        # Verificar si el disco ya existe
        cursor.execute("SELECT COUNT(*) FROM disco WHERE titulo_disco = %s AND anio_publicacion = %s;", (titulo_disco, anio_publicacion)) 
        if cursor.fetchone()[0] > 0:
            print("El disco ya existe en la base de datos.")
            return    
        
        # Pedir el resto de datos 
        nombre_grupo = input("Introduce el nombre del grupo: ")
        url= input("introduce la url del disco: ")

        # Pedir las canciones y sus duraciones
        canciones = []
        salir = True
        while (salir):
            titulo_cancion = input("Introduce el título de la canción (o 'salir' para terminar de introducir canciones): ")
            if titulo_cancion.lower() == 'salir':  # Si el usuario escribe 'salir', terminamos
                salir = False
            else:
                duracion = input("Introduce la duración de la canción en formato MM:SS ")
                canciones.append((titulo_cancion, duracion))  # Agregar la canción y su duración a la lista

        # Pedir los géneros
        generos=[]
        salir=True
        while (salir):
            genero = input("Introduce el título de la canción (o 'salir' para terminar de introducir canciones): ")
            if genero.lower() == 'salir':  # Si el usuario escribe 'salir', terminamos
                salir = False
            else:
                generos.append(genero)  # Agregar la canción y su duración a la lista


        # Insertar el grupo si no está registrado
        cursor.execute("SELECT COUNT(*) FROM grupo WHERE nombre_grupo = %s;", (nombre_grupo))            
        if cursor.fetchone()[0] == 0:   
            try:   
                cursor.execute("INSERT INTO grupo (nombre_grupo) VALUES (%s);", (nombre_grupo))  
            except psycopg2.Error as e:
                print(f"Error al insertar el grupo: {e}")
                conn.rollback()  # Revertir cambios en caso de error
                return
            print("El grupo", nombre_grupo," fue insertado correctamente.")

        # Insertar el nuevo disco
        try:
            cursor.execute(" INSERT INTO disco (titulo_disco, anio_publicacion, nombre_grupo, url_portada) VALUES (%s, %s, %s,%s);", (titulo_disco, anio_publicacion,nombre_grupo,url))
        except psycopg2.Error as e:
                print(f"Error al insertar el disco: {e}")
                conn.rollback()  # Revertir cambios en caso de error
                return
        print("El disco fue insertado correctamente.")

        # Insertar los generos
        for genero in generos:
            try:
                cursor.execute("INSERT INTO genero (titulo_disco, anio_publicacion, genero) VALUES (%s, %s, %s);", (titulo_disco, anio_publicacion, genero))   
            except psycopg2.Error as e:
                print(f"Error al insertar el genero: {e}")
                conn.rollback()  # Revertir cambios en caso de error
                return
            print("El genero ",genero, "fue insertado correctamente.")
        
        # Insertar las canciones
        for cancion in canciones:
            titulo_cancion, duracion = cancion  
            try:
                cursor.execute("""
                INSERT INTO cancion (titulo_disco, anio_publicacion, titulo_cancion, duracion) 
                VALUES (%s, %s, %s, MAKE_INTERVAL(
                    mins => SPLIT_PART(%s, ':', 1)::INTEGER, 
                    secs => SPLIT_PART(%s, ':', 2)::INTEGER
                )::TIME);
            """, (titulo_disco, anio_publicacion, titulo_cancion, duracion, duracion))

            except psycopg2.Error as e:
                print(f"Error al insertar la canción: {e}")
                conn.rollback()  # Revertir cambios en caso de error
                return
            print("La cancion ",titulo_cancion, "fue insertada correctamente.")
            
        # Confirmar los cambios
        conn.commit()
        print("Todo commiteado")
        
    except psycopg2.Error as e:
        print(f"Error al insertar el disco: {e}")
        conn.rollback()  # Revertir cambios en caso de error
    except Exception as e:
        print(f"Ocurrió un error: {e}")    
        conn.rollback()
            
def main():
    """
        main :: () -> IO None
    """
    try:
        (host, port, user, password, database) = ask_conn_parameters()          #
        connstring = f'host={host} port={port} user={user} password={password} dbname={database}' 
        try:
            conn    = psycopg2.connect(connstring)    #peta si metes una contraseña que no es. un try aqui no ayuda mucho, peta igual   
        except Exception as e:
            print(f"Ocurrió un error: {e}")    
            return                                                             
        cur     = conn.cursor()  
        nuevo = True
        while(nuevo):
            print_options()                                               # instacia un cursor
            option   = input("¿Qué operación quiere llevar a cabo?: ")
            try:
                if option=="13":
                    insertar_disco(conn, cur)
                else:
                    query = resolucion_consultas(option)                                        # prepara una consulta
                    cur.execute(query)   
                    for record in cur.fetchall():                                           # fetchall devuelve todas las filas de la consulta
                        print(record)                                                   # ejecuta la consulta
            except psycopg2.errors.InsufficientPrivilege:
                print("¡No tienes permisos para llevar a cabo esa operación!")
               
            nueva = input("¿Desea llevar a cabo una nueva operación? s/n: ")
            if(nueva == "n"):
                nuevo = False                                                     # imprime las filas
        cur.close                                                               # cierra el cursor
        conn.close                                                              # cierra la conexion
    except portException:
        print("The port is not valid!")
    except KeyboardInterrupt:
        print("Program interrupted by user.")
    except psycopg2.Error as e:
        print(f"Error: {e}")
    except Exception as e:
        print(f"Ocurrió un error: {e}")    
            
    finally:
        print("Program finished")

#def prueba_conexion():


if __name__ == "__main__":                                                      # Es el modulo principal?
    if '--test' in sys.argv:                                                    # chequea el argumento cmdline buscando el modo test
        import doctest                                                          # importa la libreria doctest
        doctest.testmod()                                                       # corre los tests
    else:                                                                       # else
        main()                                                                  # ejecuta el programa principal


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
    else:
        print("Opción no válida")
    return query
            
def main():
    """
        main :: () -> IO None
    """
    try:
        (host, port, user, password, database) = ask_conn_parameters()          #
        connstring = f'host={host} port={port} user={user} password={password} dbname={database}' 
        conn    = psycopg2.connect(connstring)                                  #
                                                                               
        cur     = conn.cursor()  
        nuevo = True
        while(nuevo):
            print_options()                                               # instacia un cursor
            option   = input("¿Qué operación quiere llevar a cabo?: ")
            try:
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
    finally:
        print("Program finished")

#def prueba_conexion():


if __name__ == "__main__":                                                      # Es el modula principal?
    if '--test' in sys.argv:                                                    # chequea el argumento cmdline buscando el modo test
        import doctest                                                          # importa la libreria doctest
        doctest.testmod()                                                       # corre los tests
    else:                                                                       # else
        main()                                                                  # ejecuta el programa principal

import os
import msvcrt

## DEFINIR FUNCION DE LIMPIAR LA PANTALLA ##
def clean():
    if os.name == 'nt':
        os.system('cls')
    else:
        os.system('clear')

## DEFINIR CONTADOR DE ARCHIVOS ##
contador = 0

## BORRAR TEMP ##
try:
    os.chdir(os.path.join(os.environ['TEMP']))
    directorio = os.getcwd()

    for archivo in os.listdir(directorio):
        try:
            os.remove(os.path.join(directorio, archivo))
            contador + 1
        except Exception as e:
            print(f"Error borrando {archivo}: {e}")

except Exception as e:
    print(f"Error cambiando al directorio: {e}")


## BORRAR PREFETCH ##

prefetch_path = r'C:\Windows\Prefetch'

try:
    os.chdir(prefetch_path)
    directorioprefetch = os.getcwd()

    for archivo in os.listdir(directorioprefetch):
        try:
            os.remove(os.path.join(directorioprefetch, archivo))
            contador + 1
        except Exception as e:
            print(f"Error borrando {archivo}: {e}")

except Exception as e:
    print(f"Error cambiando al directorio: {e}")

## BORRAR SOFTWARE DISTRIBUTION ##

prefetch_path = r'C:\Windows\SoftwareDistribution'

try:
    os.chdir(prefetch_path)
    directoriosoftware = os.getcwd()

    for archivo in os.listdir(directoriosoftware):
        try:
            os.remove(os.path.join(directoriosoftware, archivo))
            contador + 1
        except Exception as e:
            print(f"Error borrando {archivo}: {e}")

except Exception as e:
    print(f"Error cambiando al directorio: {e}")

print(f"Se borraron un total de {contador} archivos!")
print("Presione una tecla para finalizar...")
msvcrt.getch()
clean()
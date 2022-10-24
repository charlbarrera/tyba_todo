# tyba_todo
Hola equipo Tyba!, solo quiero decirles que me divertí haciendo esta prueba, adicionalmente les dejo información complementaria que les pueda ayudar en su review.

## Getting Started
Adjunté en el correo a Valentina el apk para android, teniendo en cuenta que para IOS debo de hacer pasos extras y concurrir en posibles costos por usar el cloud the Apple.

## Features
Enlisto los requerimientos, "👌🏾" quiere decir que esta incorporado ese feature en la app:

### Implementa una app de tipo TODO (una app para manejar una lista de tareas)

1. Usar una base de datos local o remota para persistir los datos 👌🏾 (más detalles en la sección Services)
2. Permitir al usuario realizar las operaciones básicas del CRUD:
Crear, Leer, Actualizar y Borrar tareas de la lista. 👌🏾
3. Cada tarea deberá tener al menos un título y una descripción
(hacer las validaciones necesarias). Puedes agregar otros
atributos o características si lo deseas. 👌🏾
4. Permitir al usuario grabar y reproducir una nota de voz como el
contenido de una tarea (no es necesario almacenarla) 👌🏾

5. Bono: Integrar un sistema de detección de fallas y errores en tiempo real
asumiendo que esta app fuera a llegar a producción. 👌🏾 (más detalles en la sección Services)
6. Bono 2: Almacenar las notas de voz que se pueden grabar en el punto 4. 👌🏾 (más detalles en la sección Services)
7. Bono 3: mi bono personal, agregué el feature de marcar como completado.


<a href="url"><img src="https://user-images.githubusercontent.com/30334217/197426285-002d5314-dc2a-4d07-81b2-301c1a3aa47c.jpg" align="left" height="650px" width="300" ></a>
<a href="url"><img src="https://user-images.githubusercontent.com/30334217/197426291-546ba2f5-c413-4098-a2f3-945598117e54.jpg " align="auto" height="650px"  width="300" ></a>
<a href="url"><img src="https://user-images.githubusercontent.com/30334217/197426293-621d0a7d-01f5-488b-996a-b8e0e0c92eae.jpg" align="right" height="650px"   width="300" ></a>




      

## Services
Los datos están siendo guardados en una base de datos remota (Firebase), estoy utilizando storage (Firebase Storage) para almacenar el audio,
y Crashlytics para almacenar los logs de errores a los usuarios en tiempo real.

### Database
<img width="600" alt="Screen Shot 2022-10-23 at 8 49 36 PM" src="https://user-images.githubusercontent.com/30334217/197427528-2c2db783-ab24-47c4-92b7-df2a7aee8127.png">

### Crashlytics
<img width="500" alt="Screen Shot 2022-10-23 at 8 23 53 PM" src="https://user-images.githubusercontent.com/30334217/197427561-703567cd-8545-4b9d-a15b-deafca6fe8a6.png"><img width="500" alt="Screen Shot 2022-10-23 at 8 23 26 PM" src="https://user-images.githubusercontent.com/30334217/197427796-8d61671d-5cfb-463e-903f-80665a88cf94.png">


### Storage
<img width="600" alt="Screen Shot 2022-10-23 at 8 50 41 PM" src="https://user-images.githubusercontent.com/30334217/197427588-13aaf734-0284-449d-8571-d81ca1d496b0.png">





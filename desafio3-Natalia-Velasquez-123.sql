--Creación Base de Datos // Database creation

CREATE DATABASE "desafio3-natalia-velasquez-123";

--Conexión a la Base de Datos // Conecting to the Database

\c 'desafio3-natalia-velasquez-123'

/* Setup
Para este desafío debes crear una base de datos con las siguientes tablas.

Usuarios:
id email nombre apellido rol
1
2
3
4
5
Donde:
● El id es serial.
● El rol es un varchar que puede ser administrador o usuario, no es necesario limitarlo
de ninguna forma para el ejercicio. Los otros campos debes definirlo utilizando tu
mejor criterio. */
--Limpiamos la tabla en caso de existir en la BD // Droping the table in case of exist

DROP TABLE users;

--Creación de la Tabla 'usuarios' // creation of the table 'users'

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR,
    name VARCHAR,
    lastname VARCHAR,
    role VARCHAR
);

/* Luego ingresa 5 usuarios en la base de datos, debe haber al menos un usuario con el rol de
administrador. */

/* Ingresamos los registros a la tabla // Inserting the data to the table */

INSERT INTO users(email, name, lastname, role) VALUES 
('juan@mail.com', 'juan', 'perez', 'admin'),
('diego@mail.com', 'diego', 'munoz', 'user'),
('maria@mail.com', 'maria', 'meza', 'user'),
('roxana@mail.com','roxana', 'diaz', 'user'),
('pedro@mail.com', 'pedro', 'diaz', 'user');



/* 
Ingresamos la siguiente Tabla
Posts (artículos):
id título contenido fecha_creacion fecha_actualizacion destacado usuario_id
1
2
3
4
5
Donde:
● fecha_creacion y fecha_actualizacion son de tipo timestamp.
● destacado es boolean (true o false).
● usuario_id es un bigint y se utilizará para conectarlo con el usuario que escribió el
post.
● El título debe ser de tipo varchar.
● El contenido debe ser de tipo text.
Luego Ingresa 5 posts
● El post con id 1 y 2 deben pertenecer al usuario administrador.
● El post 3 y 4 asignarlos al usuario que prefieras (no puede ser el administrador).
● El post 5 no debe tener un usuario_id asignado. */

--Limpiamos la tabla si existe // Drop the table in case of exists.

DROP TABLE posts;

--Creamos la tabla solicitada // Create the asked table

CREATE TABLE posts (
    id SERIAL PRIMARY KEY, 
    title VARCHAR, 
    content TEXT,
    created_at TIMESTAMP, 
    updated_at TIMESTAMP, 
    featured BOOLEAN,
    user_id BIGINT);

--Insertamos los datos solicitados.


INSERT INTO posts ( title, content, created_at,
updated_at, featured, user_id) VALUES 
('prueba', 'contenido prueba', '01/01/2021', '01/02/2021', true, 1),
('prueba2', 'contenido prueba2', '01/03/2021', '01/03/2021', true, 1),
('ejercicios', 'contenido ejercicios', '02/05/2021', '03/04/2021', true, 2),
('ejercicios2', 'contenido ejercicios2', '03/05/2021', '04/04/2021', false, 2),
('random', 'contenido random', '03/06/2021', '04/05/2021', false, null);

/* Comentarios
id contenido fecha_creacion usuario_id post_id
1
2
3
4
5

Donde:
● fecha_creacion es un timestamp.
● usuario_id es un bigint y se utilizará para conectarlo con el usuario que escribió el
comentario.
● post_id es un bigint y se utilizará para conectarlo con post_id.
Luego ingresa 5 comentarios
● Los comentarios con id 1,2 y 3 deben estar asociado al post 1, a los usuarios 1, 2 y
3 respectivamente.
● Los comentarios 4 y 5 deben estar asociado al post 2, a los usuarios 1 y 2
respectivamente.
 */

 --Limpiamos la tabla en caso de existir// Drop the table in case of exists.

 DROP TABLE comments;

 --Creamos la tercera Tabla // Create the third table.

 CREATE TABLE comments (
    id SERIAL PRIMARY KEY, 
    content VARCHAR, 
    created_at DATE, 
    user_id BIGINT, 
    post_id BIGINT);

--Insertamos los datos // Insert the data

INSERT INTO comments (content, created_at, user_id,
post_id) VALUES 
('comentario 1', '03/06/2021', 1, 1),
('comentario 2', '03/06/2021', 2, 1),
('comentario 3', '04/06/2021', 3, 1),
('comentario 4', '04/06/2021', 1, 2);


/* 2. Cruza los datos de la tabla usuarios y posts mostrando las siguientes columnas.
nombre y email del usuario junto al título y contenido del post */

SELECT u.name, u.email, p.title, p.content
FROM users u
JOIN posts p
ON u.id=p.user_id;

/* 3. Muestra el id, título y contenido de los posts de los administradores. El
administrador puede ser cualquier id y debe ser seleccionado dinámicamente. */

SELECT p.id,p.title,p.content
FROM users u
JOIN posts p
ON u.id=p.user_id
WHERE u.role='admin';

/* 4. Cuenta la cantidad de posts de cada usuario. La tabla resultante debe mostrar el id
e email del usuario junto con la cantidad de posts de cada usuario. */

SELECT u.id,u.email,COUNT(p.user_id) as "Total Posts"
FROM users u
JOIN posts p
ON u.id=p.user_id
GROUP BY u.id,u.email;

/* 5. Muestra el email del usuario que ha creado más posts. Aquí la tabla resultante tiene
un único registro y muestra solo el email. */

SELECT u.email as "Email Usuario con mas posts"
FROM users u
JOIN posts p
ON u.id=p.user_id
GROUP BY u.email
ORDER BY COUNT(p.user_id) DESC LIMIT 1;

/* 6. Muestra la fecha del último post de cada usuario. */

SELECT u.id,u.name,MAX(p.created_at) as "Fecha último Post"
FROM users u
JOIN posts p
ON u.id=p.user_id
GROUP BY u.id, u.name;

/* 7. Muestra el título y contenido del post (artículo) con más comentarios. */

SELECT title, content 
FROM posts 
JOIN (SELECT post_id, COUNT(post_id) FROM comments GROUP BY post_id ORDER BY count DESC LIMIT 1) AS c 
ON posts.id = c.post_id;

/* 8. Muestra en una tabla el título de cada post, el contenido de cada post y el contenido
de cada comentario asociado a los posts mostrados, junto con el email del usuario
que lo escribió. */

SELECT p.title, p.content, c.content, u.email
FROM comments c
RIGHT JOIN posts p
ON p.id = c.post_id
JOIN users u
ON c.user_id=u.id;

/* 9. Muestra el contenido del último comentario de cada usuario. */


SELECT  u.email , MAX(c.created_at) as "Ultimo Comentario"
FROM comments c
JOIN users u
ON c.user_id=u.id
GROUP BY c.user_id, u.email;

/* 10. Muestra los emails de los usuarios que no han escrito ningún comentario. */

SELECT u.email as "Usuarios sin Comentarios"
FROM users u
LEFT JOIN comments c
ON u.id=c.user_id
WHERE c.id IS NULL;

--Salir de postgreSQL

\q


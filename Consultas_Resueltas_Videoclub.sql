-- 2. Muestra los nombres de todas las películas con una clasificación por edades de 'R'

select "title" as "name_film"
from "film" 
where "rating" ='R';

-- 3. Encuentra los nombres de los actores que tenga un 'actor_id' entre 30 y 40

select concat("first_name", ' ', "last_name") as "actor"
from "actor" 
where "actor_id" between 30 and 40
order by "actor";

-- 4. Obtén las películas cuyo idioma coincide con el idioma original

select *
from "film" 
where "language_id" = "original_language_id" ;

-- en el fichero sql para la creación, está a NULL la columna original_language_id en todos los inserts, por eso no hay resultado


-- 5. Ordena las películas por duración de forma ascendente.

select "film_id", "title", "description", "length" 
from "film"
order by "length";

-- 6.Encuentra el nombre y apellido de los actores que tengan 'Allen' en su apellido

select "first_name" , "last_name" 
from "actor"
where "last_name"='ALLEN';

--7. Encuentra la cantidad total de películas en cada clasificación de la tabla "film" y muestra la clasificación junto con el recuento

select c."name" as "category", count("film_id") as "total_films"
from "film_category" fc inner join "category" c 
	on fc."category_id"  = c."category_id"
group by c."name" 
order by "total_films" ;

/**
  8. Encuentra el título de todas las películas que son 'PG-13' o tienen una duración mayor a 3 horas en la tabla film
  Para la duración, las 3 horas los pasamos a minutos, 180 y poder filtrar en la columna length
**/

select "title"
from "film"
where "rating"='PG-13' or  "length">180;


-- 9. Encuentra la variabilidad de lo que costaría reemplazar las películas.

select VARIANCE(replacement_cost) AS "varianza",
  STDDEV(replacement_cost) AS "desviacion_estandar"
from "film";


-- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD

select MAX("length") as "maxima_duracion_pelicula", MIN("length") as "minima_duracion_pelicula"
from "film";


-- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día

select "amount" as "costo_antepenultimo_alquier"
from "payment"  
order by "payment_date"  DESC
offset 2 limit 1;


-- 12. Encuentra el título de las películas en la tabla “filmˮ que no sean ni ‘NC-17ʼ ni ‘Gʼ en cuanto a su clasificación.

select "title"
from "film"
where "rating" not in ('NC-17','G');


-- 13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

select c."name" as "category", round(avg("length"),2) as "promedio_duracion"
from "film" f
	inner join "film_category" fc on f."film_id" = fc."film_id"
	inner join "category" c on fc."category_id"  = c."category_id"
group by c."name" 
order by "category";


-- 14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.

select "title"
from "film"
where "length">180;


-- 15.¿Cuánto dinero ha generado en total la empresa?

select SUM("amount") as "total_ingresos"
from "payment"; 


-- 16. Muestra los 10 clientes con mayor valor de id.

select *
from "customer"  
order by "customer_id" desc
limit 10;


-- 17.  Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby'

select concat(a."first_name", ' ', a."last_name") as "Actor"
from "film" f 
	inner join "film_actor" fa on f."film_id" = fa."film_id"
	inner join "actor" a on fa."actor_id" = a."actor_id"
where "title"='EGG IGBY';


/**
  18. Selecciona todos los nombres de las películas únicos.
  el enunciado es un poco ambiguo y no termina de entenderse. He interpretado que se quiren los nombres de películas sin repetirse pero viendo 
  que no hay repeticiones no tengo claro si se busca esto
**/

select distinct "title"
from "film";


-- 19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “filmˮ.

select f."title" as "peliculas_comedia"
from "film" f 
	inner join "film_category" fc on f."film_id" = fc."film_id"
	inner join "category" c  on fc."category_id" = c."category_id"
where f."length" > 180 and c."name" ='Comedy';


-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.

select c."name" as "Categoría", ROUND(AVG(f.length),2) as "Promedio_duracion"
from "film" f 
	inner join "film_category" fc on f."film_id" = fc."film_id"
	inner join "category" c  on fc."category_id" = c."category_id"
group by c."name"
having AVG(f.length) > 110
order by "Categoría";

-- 21. ¿Cuál es la media de duración del alquiler de las películas?

SELECT AVG(return_date - rental_date) AS media_duracion_alquier
FROM "rental"
WHERE "return_date" is not null;


-- 22. Crea una columna con el nombre y apellidos de todos los actores y actrices

select concat("first_name", ' ' ,"last_name") as "nombre_completo_actorAcriz"
from "actor"
order by "nombre_completo_actorAcriz";

-- 23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.

select count("rental_id") as "cantidad_alquileres", date("rental_date") as "fecha_alquiler"
from "rental"
group by date("rental_date")
order by "cantidad_alquileres" desc;


-- 24. Encuentra las películas con una duración superior al promedio

select "title" as "pelicula"
from "film"
where "length" >
	(select AVG("length") from "film");


-- 25. Averigua el número de alquileres registrados por mes

select extract (month from "rental_date") as "mes_alquiler", count("rental_id") as "numero_alquileres"
from "rental"
group by extract (month from "rental_date")
order by "mes_alquiler";


-- 26. Encuentra el promedio, la desviación estándar y varianza del total pagado.

select 
  round(avg("amount"), 2) AS "promedio",
  round(stddev("amount"), 2) AS "desviacion_estandar",
  round(variance("amount"), 2) AS "varianza"
from "payment";


-- 27. ¿Qué películas se alquilan por encima del precio medio?

select "title", "rental_rate"
from "film"
where "rental_rate" > (
  select avg("rental_rate") from "film");


-- 28. Muestra el id de los actores que hayan participado en más de 40 películas

select "actor_id"
from "film_actor"
group by "actor_id"
having count("film_id") > 40;


-- 29.  Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.

select f.title, count(i.inventory_id) as cantidad_en_inventario
from "film" f
	left join "inventory" i on f."film_id" = i."film_id"
group by f.film_id, f.title
order by f.title;


-- 30. Obtener los actores y el número de películas en las que ha actuado

select concat(a."first_name",' ', a."last_name") as "actor", count(fa."film_id") as "cantidad_peliculas"
from "actor" a
	inner join "film_actor" fa on a."actor_id" = fa."actor_id"
group by concat(a."first_name",' ', a."last_name") 
order by "actor";


-- 31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.

select f."title", concat(a."first_name",' ', a."last_name") as "actor"
from "film" as f
	left join "film_actor" as fa on f."film_id" = fa."film_id"
	left join "actor" as a on fa."actor_id" = a."actor_id"
order by f."title", "actor";


-- 32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película

select concat(a."first_name",' ', a."last_name") as "actor",  f."title"
from "actor" as a
	left join "film_actor" as fa on a."actor_id" = fa."actor_id"
	left join "film" as f on fa."film_id" = f."film_id"
order by "actor", f."title";


-- 33. Obtener todas las películas que tenemos y todos los registros de alquiler.

select f."title", r."rental_id", r."rental_date", r."return_date"
from "film" as f
	left join "inventory" as i on f."film_id" = i."film_id"
	left join "rental" as r on i."inventory_id" = r."inventory_id"
order by f."title", r."rental_date" desc;


-- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.

select concat(c."first_name",' ',c."last_name") "cliente",  sum(p."amount") as total_gastado
from "customer" as c
	inner join "payment" as p on c."customer_id" = p."customer_id"
group by concat(c."first_name",' ',c."last_name") 
order by total_gastado desc
limit 5;


-- 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.

select "actor_id", "first_name", "last_name"
from "actor"
where first_name = 'JOHNNY';


-- 36. Renombra la columna “first_nameˮ como Nombre y “last_nameˮ como Apellido

select  "first_name" as "Nombre", "last_name" as "Apellido"
from "actor";

-- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor

select min("actor_id") as "id_mas_bajo",  max("actor_id") as "id_mas_alto"
from "actor";

-- 38.  Cuenta cuántos actores hay en la tabla “actorˮ.

select count(*) as total_actores
from "actor";

-- 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.

select *
from "actor"
order by "last_name";

-- 40. Selecciona las primeras 5 películas de la tabla “filmˮ

select *
from "film"
limit 5;

-- 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?

select "first_name" , count("actor_id") as "num_total"
from "actor"
group by "first_name"
order by "num_total" desc;


-- 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron

select r."rental_id",r."rental_date", concat(c."first_name",' ',c."last_name") as "cliente"
from "rental" as r
 	inner join "customer" as c on r."customer_id" = c."customer_id";


-- 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.

select concat(c."first_name",' ',c."last_name") as "cliente", r."rental_id",  r."rental_date"
from "customer" as c
	left join "rental" as r on c."customer_id" = r."customer_id"


-- 44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación
	
select *
from "film" as f
	cross join "category" as c;

/** Respuesta:
Esta consulta no aporta valor práctico real porque el "cross join" combina cada película con cada categoría, aunque no estén relacionadas.
En lugar de mostrar en qué categoría está cada película, genera un montón de combinaciones sin sentido. Si hay 1,000 películas y 16 categorías, devuelve 16,000 filas que no representan la realidad.
En un caso real, lo correcto sería usar un inner join con la tabla "film_category" para saber a qué categoría pertenece cada película. El cross join en este contexto solo sirve para fines teóricos 
o como ejercicio para entender cómo funciona.
**/

-- 45. Encuentra los actores que han participado en películas de la categoría 'Action'.

select distinct  a."first_name",  a."last_name"
from "actor" as a
 inner join "film_actor" as fa on a."actor_id" = fa."actor_id"
 inner join "film" as f on "fa"."film_id" = f."film_id"
 inner join "film_category" as fc on f."film_id" = fc."film_id"
 inner join "category" as c on fc."category_id" = c."category_id"
where c."name" = 'Action'


-- 46. Encuentra todos los actores que no han participado en películas.

select   "a"."first_name",  "a"."last_name"
from "actor" as a
where not exists (
  select 1
  from "film_actor" as fa
  where fa."actor_id" = a."actor_id"
)


-- 47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.

select concat(a."first_name", ' ', a."last_name") as "actor",  count(fa."film_id") as "cantidad_peliculas"
from "actor" as a
	inner join "film_actor" as fa on a."actor_id" = fa."actor_id"
group by concat(a."first_name", ' ', a."last_name")
order by "actor";


-- 48.  Crea una vista llamada “actor_num_peliculasˮ que muestre los nombres de los actores y el número de películas en las que han participado.

create view "actor_num_peliculas" as
select concat(a."first_name", ' ', a."last_name") as "actor",  count(fa."film_id") as "cantidad_peliculas"
from "actor" as a
	inner join "film_actor" as fa on a."actor_id" = fa."actor_id"
group by concat(a."first_name", ' ', a."last_name")
order by "actor";


-- 49. Calcula el número total de alquileres realizados por cada cliente

select  c."first_name",  c."last_name",  count(r."rental_id") as "total_alquileres"
from "customer" as c
	inner join "rental" as r on c."customer_id" = r."customer_id"
group by c."first_name", c."last_name"
order by "total_alquileres" desc;


-- 50. Calcula la duración total de las películas en la categoría 'Action'.

select sum(f."length") as "duracion_total"
from "film" as f
	inner join "film_category" as fc on f."film_id" = fc."film_id"
	inner join "category" as c on fc."category_id" = c."category_id"
where c."name" = 'Action';


-- 51. Crea una tabla temporal llamada “cliente_rentas_temporalˮ para almacenar el total de alquileres por cliente.

create temporary table "cliente_rentas_temporal" as
select c."first_name", c."last_name", count(r."rental_id") as "total_alquileres"
from "customer" as c
	inner join "rental" as r on c."customer_id" = r."customer_id"
group by c."first_name", c."last_name";

-- Para consultar la tabla temporal creada
select * from "cliente_rentas_temporal";


-- 52. Crea una tabla temporal llamada “peliculas_alquiladasˮ que almacene las películas que han sido alquiladas al menos 10 veces.

create temporary table "peliculas_alquiladas" as
select  f."film_id",  f."title",  count(r."rental_id") as total_alquileres
from "film" as f
	inner join "inventory" as i on f."film_id" = i."film_id"
	inner join "rental" as r on i."inventory_id" = r."inventory_id"
group by f."film_id", f."title"
having count(r."rental_id") >= 10;


-- Para consultar la tabla temporal creada
select * from "peliculas_alquiladas";


-- 53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sandersʼ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película

select f."title"
from "rental" as r
	inner join "customer" as c on r."customer_id" = c."customer_id"
	inner join "inventory" as i on r."inventory_id" = i."inventory_id"
	inner join "film" as f on i."film_id" = f."film_id"
where c."first_name" = 'TAMMY'  and c."last_name" = 'SANDERS' and r."return_date" is null
order by f."title";


-- 54. Encuentra los nombres de los actores que han actuado en, al menos, una película que pertenece a la categoría ‘Sci-Fiʼ. Ordena los resultados alfabéticamente por apellido

select distinct "a"."first_name",  "a"."last_name"
from "actor" as a
	inner join "film_actor" as fa on a."actor_id" = fa."actor_id"
	inner join "film" as f on fa."film_id" = f."film_id"
	inner join "film_category" as fc on "f"."film_id" = fc."film_id"
 	inner join "category" as c on c."category_id" = c."category_id"
where c."name" = 'Sci-Fi'
order by a."last_name";


/** 
55.  Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaperʼ se alquilara por primera vez. 
Ordena los resultados alfabéticamente por apellido.

Utilizamos CTE para que sea mas entendible la consulta **/

-- Paso 1: obtener la fecha del primer alquiler de 'Spartacus Cheaper'
with fecha_primer_alquiler as (
  select min(r."rental_date") as primera_fecha
  from "film" as f
  join "inventory" as i on f."film_id" = i."film_id"
  join "rental" as r on i."inventory_id" = r."inventory_id"
  where f."title" = 'SPARTACUS CHEAPER'
)

-- Paso 2: usar esa fecha para filtrar los actores
select distinct  "a"."first_name",   "a"."last_name"
from "actor" as a
	inner join "film_actor" as fa on a."actor_id" = fa."actor_id"
	inner join "film" as f on fa."film_id" = f."film_id"
	inner join "inventory" as i on f."film_id" = i."film_id"
	inner join "rental" as r on i."inventory_id" = r."inventory_id"
	inner join "fecha_primer_alquiler" as fr on r."rental_date" > fr."primera_fecha"
order by "a"."last_name";



-- 56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Musicʼ

select  "a"."first_name",  "a"."last_name"
from "actor" as a
where not exists (
  select 1
  from "film_actor" as fa
  join "film" as f on fa."film_id" = f."film_id"
  join "film_category" as fc on f."film_id" = fc."film_id"
  join "category" as c on fc."category_id" = c."category_id"
  where fa."actor_id" = a."actor_id" and c."name" = 'Music'
)
order by "a"."first_name";


-- 57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.

select distinct f."title"
from "rental" as r
	inner join "inventory" as i on r."inventory_id" = i."inventory_id"
	inner join "film" as f on i."film_id" = f."film_id"
where extract( day from "r"."return_date" - r."rental_date") > 8
order by f."title";


-- 58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animationʼ.

select f."title"
from "film" as f
	inner join "film_category" as fc on f."film_id" = fc."film_id"
	inner join "category" as c on fc."category_id" = c."category_id"
where c."name" = 'Animation'
order by f."title";


-- 59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Feverʼ. Ordena los resultados alfabéticamente por título de película.

select "title"
from "film"
where "length" = (
  select "length"
  from "film"
  where "title" = 'DANCING FEVER'
)
order by "title";


-- 60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.

select  c."first_name",c."last_name", count(distinct i."film_id") as cantidad_peliculas
from "customer" as c
	inner join "rental" as r on "c"."customer_id" = r."customer_id"
	inner join "inventory" as i on "r"."inventory_id" = i."inventory_id"
group by c."customer_id", c."first_name", c."last_name"
having count(distinct i."film_id") >= 7
order by c."last_name";


-- 61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres

select c."name" as "categoria", count(r."rental_id") as "total_alquileres"
from "rental" as r
	inner join "inventory" as i on r."inventory_id" = i."inventory_id"
	inner join "film_category" as fc on i."film_id" = fc."film_id"
	inner join "category" as c on fc."category_id" = c."category_id"
group by c."name"
order by "categoria";


-- 62. Encuentra el número de películas por categoría estrenadas en 2006
-- se incluye right join por si hay alguna cateogría que no ha estrenado película en 2006 se muestre también, pero con 0.

select "c"."name" as "categoria", count("f"."film_id") as "total_peliculas"
from "film" as f
	right join "film_category" as fc on f."film_id" = fc."film_id"
	right join "category" as c on fc."category_id" = c."category_id"
where f."release_year" = 2006
group by c."name"
order by "total_peliculas" desc;


-- 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.

select s."first_name" as empleado_nombre, s."last_name" as empleado_apellido, t."store_id", t."address_id"
from "staff" as s
	cross join "store" as t
order by s."last_name";


-- 64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas

select c."customer_id", CONCAT(c."first_name", ' ',c."last_name") as "cliente", count(r."rental_id") as "total_alquileres"
from "customer" as c
join "rental" as r on c."customer_id" = r."customer_id"
group by c."customer_id",c."first_name", c."last_name"
order by "total_alquileres" desc;



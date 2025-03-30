SELECT z.car_name,
       z.car_class,
       z.avg_position,
       z.race_count,
       cl.country AS car_country
FROM (
         /* Подзапрос: все авто, их средняя позиция и кол-во гонок */
         SELECT c.name          AS car_name,
                c.class         AS car_class,
                AVG(r.position) AS avg_position,
                COUNT(*)        AS race_count
         FROM Cars c
                  JOIN Results r ON c.name = r.car
         GROUP BY c.name) AS z
         JOIN Classes cl ON cl.class = z.car_class
WHERE (z.avg_position, z.car_name) =
      (
          /* Вложенный запрос: берём одну строку с минимальным avg, а при равенстве — алфавит */
          SELECT t.avg_position, t.car_name
          FROM (SELECT c.name          AS car_name,
                       AVG(r.position) AS avg_position
                FROM Cars c
                         JOIN Results r ON c.name = r.car
                GROUP BY c.name
                ORDER BY avg_position ASC, car_name ASC LIMIT 1) AS t)
;

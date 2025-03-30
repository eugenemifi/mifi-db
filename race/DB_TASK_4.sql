SELECT car_stats.car_name,
       car_stats.car_class,
       car_stats.avg_position,
       car_stats.race_count,
       cl.country AS car_country
FROM (
         /* #1: avg_position для каждой машины */
         SELECT c.name          AS car_name,
                c.class         AS car_class,
                AVG(r.position) AS avg_position,
                COUNT(*)        AS race_count
         FROM Cars c
                  JOIN Results r ON c.name = r.car
         GROUP BY c.name) AS car_stats

         JOIN
     (
         /* #2: средняя позиция по классу + общее число машин в классе */
         SELECT cl.class               AS car_class,
                AVG(r.position)        AS class_avg_position,
                COUNT(DISTINCT c.name) AS car_count_in_class
         FROM Cars c
                  JOIN Results r ON r.car = c.name
                  JOIN Classes cl ON cl.class = c.class
         GROUP BY cl.class) AS class_info
     ON car_stats.car_class = class_info.car_class

         JOIN Classes cl ON cl.class = car_stats.car_class

WHERE class_info.car_count_in_class >= 2
  AND car_stats.avg_position < class_info.class_avg_position
ORDER BY car_stats.car_class,
         car_stats.avg_position;

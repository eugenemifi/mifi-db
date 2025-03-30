SELECT car_info.car_name,
       car_info.car_class,
       car_info.avg_position,
       car_info.race_count,
       cl.country AS car_country,
       class_stat.total_races
FROM (
         /* #1: Для каждой машины считаем avg_position, race_count */
         SELECT c.name          AS car_name,
                c.class         AS car_class,
                AVG(r.position) AS avg_position,
                COUNT(*)        AS race_count
         FROM Cars c
                  JOIN Results r ON c.name = r.car
         GROUP BY c.name) AS car_info

         JOIN
     (
         /* #2: Для каждого класса считаем
               - class_avg_position,
               - total_races (сколько всего гонок у машин этого класса) */
         SELECT c.class         AS car_class,
                AVG(r.position) AS class_avg_position,
                COUNT(*)        AS total_races
         FROM Cars c
                  JOIN Results r ON c.name = r.car
         GROUP BY c.class) AS class_stat
     ON car_info.car_class = class_stat.car_class

         JOIN Classes cl ON cl.class = car_info.car_class

/* Оставляем только классы, у которых class_avg_position = MIN(...) */
WHERE class_stat.class_avg_position IN
      (SELECT MIN(sub.class_avg_position)
       FROM (SELECT c.class,
                    AVG(r.position) AS class_avg_position
             FROM Cars c
                      JOIN Results r ON c.name = r.car
             GROUP BY c.class) AS sub)
ORDER BY car_info.avg_position;

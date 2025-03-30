SELECT x.car_name,
       x.car_class,
       x.avg_position,
       x.race_count
FROM (
         /* #1: сгруппируем каждую машину и посчитаем avg() и COUNT() */
         SELECT c.name          AS car_name,
                c.class         AS car_class,
                AVG(r.position) AS avg_position,
                COUNT(*)        AS race_count
         FROM Cars c
                  JOIN Results r ON c.name = r.car
         GROUP BY c.class, c.name) AS x
         JOIN
     (
         /* #2: для каждого класса найдём min(avg_position) */
         SELECT c.class               AS car_class,
                MIN(sub.avg_position) AS min_avg_pos
         FROM (SELECT c.class,
                      AVG(r.position) AS avg_position
               FROM Cars c
                        JOIN Results r ON c.name = r.car
               GROUP BY c.class, c.name) AS sub
         GROUP BY sub.class) AS y
     ON x.car_class = y.car_class
         AND x.avg_position = y.min_avg_pos
ORDER BY x.avg_position;

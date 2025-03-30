SELECT c.ID_customer,
       c.name,
       CASE
           WHEN hotel_info.max_class = 'Expensive' THEN 'Дорогой'
           WHEN hotel_info.max_class = 'Medium' THEN 'Средний'
           ELSE 'Дешевый'
           END AS preferred_hotel_type,
       hotel_info.visited_hotels
FROM Customer c
         JOIN
     (
         /* Подзапрос: находим ВСЕ отели, где клиент c побывал, и определяем максимальный класс */
         SELECT b.ID_customer,
                -- Собираем список уникальных отелей (имён)
                GROUP_CONCAT(DISTINCT h.name ORDER BY h.name SEPARATOR ',') AS visited_hotels,
             /* Вычислим "лучший" (т.е. приоритетный) класс отеля у клиента:
                max_value (Expensive > Medium > Cheap) можно эмулировать через ранжирование.
                Упростим логику: при объединении строк выберем "максимальный" класс
                по условной сортировке (Expensive>Medium>Cheap).
             */
                CASE
                    WHEN MAX(
                                 CASE cat.hotel_category
                                     WHEN 'Expensive' THEN 3
                                     WHEN 'Medium' THEN 2
                                     ELSE 1
                                     END
                         ) = 3 THEN 'Expensive'
                    WHEN MAX(
                                 CASE cat.hotel_category
                                     WHEN 'Expensive' THEN 3
                                     WHEN 'Medium' THEN 2
                                     ELSE 1
                                     END
                         ) = 2 THEN 'Medium'
                    ELSE 'Cheap'
                    END                                                     AS max_class
         FROM Booking b
                  JOIN Room r ON r.ID_room = b.ID_room
                  JOIN Hotel h ON h.ID_hotel = r.ID_hotel
             /* cat: подзапрос, где определена категория отеля (Cheap/Medium/Expensive) */
                  JOIN
              (SELECT h2.ID_hotel,
                      CASE
                          WHEN AVG(r2.price) < 175 THEN 'Cheap'
                          WHEN AVG(r2.price) <= 300 THEN 'Medium'
                          ELSE 'Expensive'
                          END AS hotel_category
               FROM Hotel h2
                        JOIN Room r2 ON r2.ID_hotel = h2.ID_hotel
               GROUP BY h2.ID_hotel) AS cat ON cat.ID_hotel = h.ID_hotel

         GROUP BY b.ID_customer) AS hotel_info
     ON hotel_info.ID_customer = c.ID_customer

/* Сортировать: сначала 'Дешевый', потом 'Средний', потом 'Дорогой'. 
   Упростим через CASE в ORDER BY. */
ORDER BY CASE
             WHEN hotel_info.max_class = 'Expensive' THEN 3
             WHEN hotel_info.max_class = 'Medium' THEN 2
             ELSE 1
             END,
         c.ID_customer;

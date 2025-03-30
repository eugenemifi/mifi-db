SELECT c.name                                                       AS customer_name,
       c.email,
       c.phone,
       COUNT(*)                                                     AS total_bookings,
       GROUP_CONCAT(DISTINCT h.name ORDER BY h.name SEPARATOR ', ') AS hotels_list,
       ROUND(AVG(DATEDIFF(b.check_out_date, b.check_in_date)), 4)   AS average_stay
FROM Booking b
         JOIN Customer c ON c.ID_customer = b.ID_customer
         JOIN Room r ON r.ID_room = b.ID_room
         JOIN Hotel h ON h.ID_hotel = r.ID_hotel
GROUP BY c.ID_customer
HAVING COUNT(*) > 2
   AND COUNT(DISTINCT h.ID_hotel) >= 2
ORDER BY total_bookings DESC;

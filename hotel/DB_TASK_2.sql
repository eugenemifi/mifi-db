WITH RECURSIVE subordinates AS (
    -- 1) Берём самого Ивана (EmployeeID=1)
    SELECT e.EmployeeID,
           e.Name AS EmployeeName,
           e.ManagerID,
           e.DepartmentID,
           e.RoleID
    FROM Employees eSELECT
    t1.ID_customer
   , t1.name
   , t1.total_bookings
   , t1.total_spent
   , t1.unique_hotels
FROM
    (
    /* "t1" - клиенты, у которых bookings>2, отелей>1, посчитан total_spent */
    SELECT
    c.ID_customer, c.name, COUNT (*) AS total_bookings, COUNT (DISTINCT h.ID_hotel) AS unique_hotels, SUM (DATEDIFF(b.check_out_date, b.check_in_date) * r.price) AS total_spent
    FROM Booking b
    JOIN Room r ON r.ID_room = b.ID_room
    JOIN Hotel h ON h.ID_hotel = r.ID_hotel
    JOIN Customer c ON c.ID_customer = b.ID_customer
    GROUP BY c.ID_customer, c.name
    HAVING COUNT (*) > 2
    AND COUNT (DISTINCT h.ID_hotel) > 1
    ) AS t1
    JOIN
    (
    /* "t2" - клиенты, у которых total_spent>500 (и считаем total_bookings заодно) */
    SELECT
    c.ID_customer, c.name, SUM (DATEDIFF(b.check_out_date, b.check_in_date) * r.price) AS total_spent, COUNT (*) AS total_bookings
    FROM Booking b
    JOIN Room r ON r.ID_room = b.ID_room
    JOIN Customer c ON c.ID_customer = b.ID_customer
    GROUP BY c.ID_customer, c.name
    HAVING SUM (DATEDIFF(b.check_out_date, b.check_in_date) * r.price) > 500
    ) AS t2
ON t1.ID_customer = t2.ID_customer -- пересечение: те, кто удовлетворяет обоим критериям
ORDER BY t1.total_spent ASC;
WHERE e.EmployeeID = 1

    UNION ALL

    -- 2) Добавляем всех, у кого ManagerID совпадает с предыдущими
SELECT c.EmployeeID,
       c.Name AS EmployeeName,
       c.ManagerID,
       c.DepartmentID,
       c.RoleID
FROM Employees c
         JOIN subordinates s
              ON c.ManagerID = s.EmployeeID)
SELECT s.EmployeeID,
       s.EmployeeName,
       s.ManagerID,
       d.DepartmentName,
       r.RoleName,
       -- Собираем названия проектов, найденных по совпадающему DepartmentID.
       -- DISTINCT помогает избежать дублирования, если JOIN даёт повторяющиеся строки
       string_agg(DISTINCT p.ProjectName, ', ') AS ProjectNames,
       -- Собираем названия задач, назначенных на данного сотрудника
       string_agg(DISTINCT t.TaskName, ', ')    AS TaskNames
FROM subordinates s
         LEFT JOIN Departments d ON s.DepartmentID = d.DepartmentID
         LEFT JOIN Roles r ON s.RoleID = r.RoleID
         LEFT JOIN Projects p ON p.DepartmentID = s.DepartmentID
         LEFT JOIN Tasks t ON t.AssignedTo = s.EmployeeID
GROUP BY s.EmployeeID,
         s.EmployeeName,
         s.ManagerID,
         d.DepartmentName,
         r.RoleName
ORDER BY s.EmployeeName;

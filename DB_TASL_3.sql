WITH RECURSIVE subordinatesOf AS (
    -- Базовый запрос: находим все пары (начальник, прямой подчинённый)
    SELECT e1.EmployeeID AS managerId,
           e2.EmployeeID AS subordinateId
    FROM Employees e1
             JOIN Employees e2 ON e2.ManagerID = e1.EmployeeID

    UNION ALL

    -- Рекурсивная часть: подчинённые подчинённых
    SELECT s.managerId,
           e3.EmployeeID
    FROM subordinatesOf s
             JOIN Employees e3 ON e3.ManagerID = s.subordinateId)
SELECT e.EmployeeID,
       e.Name                                   AS EmployeeName,
       e.ManagerID,
       d.DepartmentName,
       r.RoleName,
       -- Список проектов одним столбцом, если нет — NULL
       string_agg(DISTINCT p.ProjectName, ', ') AS ProjectNames,
       -- Список задач одним столбцом, если нет — NULL
       string_agg(DISTINCT t.TaskName, ', ')    AS TaskNames,
       -- Подсчёт всех уровней подчинённых
       (SELECT COUNT(*)
        FROM subordinatesOf so
        WHERE so.managerId = e.EmployeeID)      AS TotalSubordinates
FROM Employees e
         JOIN Roles r
              ON e.RoleID = r.RoleID
         JOIN Departments d
              ON e.DepartmentID = d.DepartmentID
         LEFT JOIN Projects p
                   ON p.DepartmentID = e.DepartmentID
         LEFT JOIN Tasks t
                   ON t.AssignedTo = e.EmployeeID
WHERE r.RoleName = 'Менеджер'
GROUP BY e.EmployeeID,
         e.Name,
         e.ManagerID,
         d.DepartmentName,
         r.RoleName
HAVING
    -- Оставляем только тех, у кого число (всех уровней) подчинённых > 0
    (SELECT COUNT(*)
     FROM subordinatesOf so
     WHERE so.managerId = e.EmployeeID) > 0
ORDER BY e.Name;

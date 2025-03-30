WITH RECURSIVE subordinates AS (
    -- 1) Берём самого Ивана (EmployeeID=1)
    SELECT e.EmployeeID,
           e.Name AS EmployeeName,
           e.ManagerID,
           e.DepartmentID,
           e.RoleID
    FROM Employees e
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

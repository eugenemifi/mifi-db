WITH RECURSIVE subordinates AS (
    -- 1) Начинаем с Ивана Иванова (EmployeeID=1)
    SELECT e.EmployeeID,
           e.Name AS EmployeeName,
           e.ManagerID,
           e.DepartmentID,
           e.RoleID
    FROM Employees e
    WHERE e.EmployeeID = 1

    UNION ALL

    -- 2) Добавляем всех, у кого ManagerID = EmployeeID уже найденных
    SELECT c.EmployeeID,
           c.Name AS EmployeeName,
           c.ManagerID,
           c.DepartmentID,
           c.RoleID
    FROM Employees c
             JOIN subordinates s ON c.ManagerID = s.EmployeeID)
SELECT s.EmployeeID,
       s.EmployeeName,
       s.ManagerID,
       d.DepartmentName,
       r.RoleName,
       -- Список проектов (по DepartmentID сотрудника), склеенный в одну строку
       string_agg(DISTINCT p.ProjectName, ', ') AS ProjectNames,
       -- Список задач сотрудника, склеенный в одну строку
       string_agg(DISTINCT t.TaskName, ', ')    AS TaskNames,
       -- Общее количество задач (если задач нет, будет 0)
       COUNT(DISTINCT t.TaskID)                 AS TotalTasks,
       -- Общее число ПРЯМЫХ подчинённых (не рекурсивно)
       (SELECT COUNT(*)
        FROM Employees e2
        WHERE e2.ManagerID = s.EmployeeID)      AS TotalSubordinates
FROM subordinates s
         LEFT JOIN Departments d ON s.DepartmentID = d.DepartmentID
         LEFT JOIN Roles r ON s.RoleID = r.RoleID
         LEFT JOIN Projects p ON p.DepartmentID = s.DepartmentID
         LEFT JOIN Tasks t ON t.AssignedTo = s.EmployeeID
GROUP BY s.EmployeeID, s.EmployeeName, s.ManagerID,
         d.DepartmentName, r.RoleName
ORDER BY s.EmployeeName;

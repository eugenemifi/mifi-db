## 1. Структура и скрипты создания базы данных

## 1. Структура базы данных

![MIFI_DB_HT_VECHICLES.png](../assets/MIFI_DB_HT_VEHICLES.png)
### 1.2 Скрипты создания таблиц

#### **MySQL**

```sql
-- Создание таблицы Vehicle
CREATE TABLE Vehicle
(
    maker VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    type  ENUM('Car', 'Motorcycle', 'Bicycle') NOT NULL,
    PRIMARY KEY (model)
);

-- Создание таблицы Car
CREATE TABLE Car
(
    vin             VARCHAR(17)    NOT NULL,
    model           VARCHAR(100)   NOT NULL,
    engine_capacity DECIMAL(4, 2)  NOT NULL, -- объем двигателя в литрах
    horsepower      INT            NOT NULL, -- мощность (л.с.)
    price           DECIMAL(10, 2) NOT NULL, -- цена в долларах
    transmission    ENUM('Automatic', 'Manual') NOT NULL,
    PRIMARY KEY (vin),
    FOREIGN KEY (model) REFERENCES Vehicle (model)
);

-- Создание таблицы Motorcycle
CREATE TABLE Motorcycle
(
    vin             VARCHAR(17)    NOT NULL,
    model           VARCHAR(100)   NOT NULL,
    engine_capacity DECIMAL(4, 2)  NOT NULL,
    horsepower      INT            NOT NULL,
    price           DECIMAL(10, 2) NOT NULL,
    type            ENUM('Sport', 'Cruiser', 'Touring') NOT NULL,
    PRIMARY KEY (vin),
    FOREIGN KEY (model) REFERENCES Vehicle (model)
);

-- Создание таблицы Bicycle
CREATE TABLE Bicycle
(
    serial_number VARCHAR(20)    NOT NULL,
    model         VARCHAR(100)   NOT NULL,
    gear_count    INT            NOT NULL,
    price         DECIMAL(10, 2) NOT NULL,
    type          ENUM('Mountain', 'Road', 'Hybrid') NOT NULL,
    PRIMARY KEY (serial_number),
    FOREIGN KEY (model) REFERENCES Vehicle (model)
);
```

#### **PostgreSQL**

```sql
-- Создание таблицы Vehicle
CREATE TABLE Vehicle
(
    maker VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    type  VARCHAR(20)  NOT NULL CHECK (type IN ('Car', 'Motorcycle', 'Bicycle')),
    PRIMARY KEY (model)
);

-- Создание таблицы Car
CREATE TABLE Car
(
    vin             VARCHAR(17)    NOT NULL,
    model           VARCHAR(100)   NOT NULL,
    engine_capacity DECIMAL(4, 2)  NOT NULL,
    horsepower      INT            NOT NULL,
    price           DECIMAL(10, 2) NOT NULL,
    transmission    VARCHAR(20)    NOT NULL CHECK (transmission IN ('Automatic', 'Manual')),
    PRIMARY KEY (vin),
    FOREIGN KEY (model) REFERENCES Vehicle (model)
);

-- Создание таблицы Motorcycle
CREATE TABLE Motorcycle
(
    vin             VARCHAR(17)    NOT NULL,
    model           VARCHAR(100)   NOT NULL,
    engine_capacity DECIMAL(4, 2)  NOT NULL,
    horsepower      INT            NOT NULL,
    price           DECIMAL(10, 2) NOT NULL,
    type            VARCHAR(20)    NOT NULL CHECK (type IN ('Sport', 'Cruiser', 'Touring')),
    PRIMARY KEY (vin),
    FOREIGN KEY (model) REFERENCES Vehicle (model)
);

-- Создание таблицы Bicycle
CREATE TABLE Bicycle
(
    serial_number VARCHAR(20)    NOT NULL,
    model         VARCHAR(100)   NOT NULL,
    gear_count    INT            NOT NULL,
    price         DECIMAL(10, 2) NOT NULL,
    type          VARCHAR(20)    NOT NULL CHECK (type IN ('Mountain', 'Road', 'Hybrid')),
    PRIMARY KEY (serial_number),
    FOREIGN KEY (model) REFERENCES Vehicle (model)
);
```

## 2. Наполнение базы тестовыми данными
```sql
-- Вставка данных в таблицу Vehicle
INSERT INTO Vehicle (maker, model, type)
VALUES ('Toyota', 'Camry', 'Car'),
       ('Honda', 'Civic', 'Car'),
       ('Ford', 'Mustang', 'Car'),
       ('Yamaha', 'YZF-R1', 'Motorcycle'),
       ('Harley-Davidson', 'Sportster', 'Motorcycle'),
       ('Kawasaki', 'Ninja', 'Motorcycle'),
       ('Trek', 'Domane', 'Bicycle'),
       ('Giant', 'Defy', 'Bicycle'),
       ('Specialized', 'Stumpjumper', 'Bicycle');

-- Вставка данных в таблицу Car
INSERT INTO Car (vin, model, engine_capacity, horsepower, price, transmission)
VALUES ('1HGCM82633A123456', 'Camry', 2.5, 203, 24000.00, 'Automatic'),
       ('2HGFG3B53GH123456', 'Civic', 2.0, 158, 22000.00, 'Manual'),
       ('1FA6P8CF0J1234567', 'Mustang', 5.0, 450, 55000.00, 'Automatic');

-- Вставка данных в таблицу Motorcycle
INSERT INTO Motorcycle (vin, model, engine_capacity, horsepower, price, type)
VALUES ('JYARN28E9FA123456', 'YZF-R1', 1.0, 200, 17000.00, 'Sport'),
       ('1HD1ZK3158K123456', 'Sportster', 1.2, 70, 12000.00, 'Cruiser'),
       ('JKBVNAF156A123456', 'Ninja', 0.9, 150, 14000.00, 'Sport');

-- Вставка данных в таблицу Bicycle
INSERT INTO Bicycle (serial_number, model, gear_count, price, type)
VALUES ('SN123456789', 'Domane', 22, 3500.00, 'Road'),
       ('SN987654321', 'Defy', 20, 3000.00, 'Road'),
       ('SN456789123', 'Stumpjumper', 30, 4000.00, 'Mountain');
```

## 3. Задания
### Задача 1

**Условие:**  
Найдите производителей (`maker`) и модели (`model`) всех мотоциклов, которые:

- Имеют мощность (horsepower) **>150** л. с.
- Стоят (price) **<20 000** долларов
- Являются спортивными (`type = 'Sport'`)

Также требуется **отсортировать** результаты по мощности (horsepower) в порядке убывания.

**Пример решения (MySQL/PostgreSQL)**

```sql
SELECT v.maker,
       v.model
FROM Motorcycle m
         JOIN Vehicle v ON v.model = m.model
WHERE m.horsepower > 150
  AND m.price < 20000
  AND m.type = 'Sport'
ORDER BY m.horsepower DESC;
```

**Ожидаемый вывод** (по тестовым данным):

```
maker      | model
-----------+---------
Yamaha     | YZF-R1
```

---

### Задача 2

**Условие:**  
Найти информацию о **разных типах** транспортных средств (Car/Motorcycle/Bicycle), удовлетворя критериям:

1. **Car**:
    - horsepower > 150
    - engine_capacity < 3
    - price < 35000  
      Вывести: `maker, model, horsepower, engine_capacity, 'Car' AS vehicle_type`.

2. **Motorcycle**:
    - horsepower > 150
    - engine_capacity < 1.5
    - price < 20000  
      Вывести: `maker, model, horsepower, engine_capacity, 'Motorcycle' AS vehicle_type`.

3. **Bicycle**:
    - gear_count > 18
    - price < 4000  
      Вывести: `maker, model, NULL AS horsepower, NULL AS engine_capacity, 'Bicycle' AS vehicle_type`.

**Пример решения (MySQL)**

```sql
SELECT v.maker,
       v.model,
       c.horsepower,
       c.engine_capacity,
       'Car' AS vehicle_type
FROM Car c
         JOIN Vehicle v ON v.model = c.model
WHERE c.horsepower > 150
  AND c.engine_capacity < 3
  AND c.price < 35000

UNION ALL

SELECT v.maker,
       v.model,
       m.horsepower,
       m.engine_capacity,
       'Motorcycle' AS vehicle_type
FROM Motorcycle m
         JOIN Vehicle v ON v.model = m.model
WHERE m.horsepower > 150
  AND m.engine_capacity < 1.5
  AND m.price < 20000

UNION ALL

SELECT v.maker,
       v.model,
       NULL      AS horsepower,
       NULL      AS engine_capacity,
       'Bicycle' AS vehicle_type
FROM Bicycle b
         JOIN Vehicle v ON v.model = b.model
WHERE b.gear_count > 18
  AND b.price < 4000

ORDER BY CASE WHEN horsepower IS NULL THEN 1 ELSE 0 END,
         horsepower DESC;
```

В **PostgreSQL** можно использовать `ORDER BY horsepower DESC NULLS LAST` напрямую:

```sql
...
ORDER BY horsepower DESC NULLS LAST;
```

**Ожидаемый результат** (по тестовым данным):

```
maker    | model    | horsepower | engine_capacity | vehicle_type
---------+----------+------------+-----------------+-------------
Toyota   | Camry    | 203        | 2.50            | Car
Yamaha   | YZF-R1   | 200        | 1.00            | Motorcycle
Honda    | Civic    | 158        | 2.00            | Car
Trek     | Domane   | NULL       | NULL            | Bicycle
Giant    | Defy     | NULL       | NULL            | Bicycle
```

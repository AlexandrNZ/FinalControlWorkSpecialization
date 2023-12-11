--1. Диаграмма классов:
         Животные
      /             \
Домашние животные   Вьючные животные
  /   |   \              /   |    \
Собаки Кошки Хомяки   Лошади Верблюды Ослы

--2. Создание базы данных "Друзья человека" в MySQL:
CREATE DATABASE friends_of_man;
USE friends_of_man;

--3. Создание таблиц:
CREATE TABLE animals (
    animal_id INT PRIMARY KEY AUTO_INCREMENT,
    animal_name VARCHAR(50),
    command VARCHAR(50),
    birth_date DATE
);

CREATE TABLE domestic_animals (
    animal_id INT PRIMARY KEY,
    FOREIGN KEY (animal_id) REFERENCES animals(animal_id)
);

CREATE TABLE draft_animals (
    animal_id INT PRIMARY KEY,
    FOREIGN KEY (animal_id) REFERENCES animals(animal_id)
);

CREATE TABLE dogs (
    animal_id INT PRIMARY KEY,
    FOREIGN KEY (animal_id) REFERENCES domestic_animals(animal_id)
);

CREATE TABLE cats (
    animal_id INT PRIMARY KEY,
    FOREIGN KEY (animal_id) REFERENCES domestic_animals(animal_id)
);

CREATE TABLE hamsters (
    animal_id INT PRIMARY KEY,
    FOREIGN KEY (animal_id) REFERENCES domestic_animals(animal_id)
);

CREATE TABLE horses (
    animal_id INT PRIMARY KEY,
    FOREIGN KEY (animal_id) REFERENCES draft_animals(animal_id)
);

CREATE TABLE camels (
    animal_id INT PRIMARY KEY,
    FOREIGN KEY (animal_id) REFERENCES draft_animals(animal_id)
);

CREATE TABLE donkeys (
    animal_id INT PRIMARY KEY,
    FOREIGN KEY (animal_id) REFERENCES draft_animals(animal_id)
);

--4. Заполнение таблиц низкого уровня:

INSERT INTO animals (animal_name, command, birth_date) VALUES ('Шарик', 'Сидеть', '2015-05-10');
INSERT INTO dogs (animal_id) VALUES (LAST_INSERT_ID());

INSERT INTO animals (animal_name, command, birth_date) VALUES ('Мурка', 'Лежать', '2017-08-20');
INSERT INTO cats (animal_id) VALUES (LAST_INSERT_ID());

INSERT INTO animals (animal_name, command, birth_date) VALUES ('Чарли', 'Бегать в колесе', '2019-02-05');
INSERT INTO hamsters (animal_id) VALUES (LAST_INSERT_ID());

INSERT INTO animals (animal_name, command, birth_date) VALUES ('Булан', 'Тянуть воз', '2016-11-15');
INSERT INTO horses (animal_id) VALUES (LAST_INSERT_ID());

INSERT INTO animals (animal_name, command, birth_date) VALUES ('Ганс', 'Переносить грузы', '2018-07-25');
INSERT INTO camels (animal_id) VALUES (LAST_INSERT_ID());

INSERT INTO animals (animal_name, command, birth_date) VALUES ('Бурёнка', 'Тянуть плуг', '2017-04-30');
INSERT INTO donkeys (animal_id) VALUES (LAST_INSERT_ID());

--5. Удаление верблюдов и объединение таблиц лошадей и ослов:

DELETE FROM camels WHERE animal_id = (SELECT animal_id FROM animals WHERE animal_name = 'Ганс');

CREATE TABLE equines AS SELECT * FROM horses UNION SELECT * FROM donkeys;

--6. Создание таблицы "молодые животные" и подсчет возраста:

CREATE TABLE young_animals AS SELECT * FROM animals WHERE birth_date > DATE_SUB(CURDATE(), INTERVAL 3 YEAR) AND birth_date < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

ALTER TABLE young_animals ADD COLUMN age_months INT;

UPDATE young_animals SET age_months = TIMESTAMPDIFF(MONTH, birth_date, CURDATE());

--7. Объединение всех таблиц:

CREATE TABLE all_animals AS SELECT a.*, da.animal_id AS domestic_animal_id, NULL AS draft_animal_id, NULL AS dog_id, NULL AS cat_id, NULL AS hamster_id, NULL AS horse_id, NULL AS camel_id, NULL AS donkey_id FROM animals a LEFT JOIN domestic_animals da ON a.animal_id = da.animal_id
UNION
SELECT a.*, NULL AS domestic_animal_id, da.animal_id AS draft_animal_id, NULL AS dog_id, NULL AS cat_id, NULL AS hamster_id, NULL AS horse_id, NULL AS camel_id, NULL AS donkey_id FROM animals a LEFT JOIN draft_animals da ON a.animal_id = da.animal_id
UNION
SELECT a.*, NULL AS domestic_animal_id, NULL AS draft_animal_id, d.animal_id AS dog_id, NULL AS cat_id, NULL AS hamster_id, NULL AS horse_id, NULL AS camel_id, NULL AS donkey_id FROM animals a LEFT JOIN dogs d ON a.animal_id = d.animal_id
UNION
SELECT a.*, NULL AS domestic_animal_id, NULL AS draft_animal_id, NULL AS dog_id, c.animal_id AS cat_id, NULL AS hamster_id, NULL AS horse_id, NULL AS camel_id, NULL AS donkey_id FROM animals a LEFT JOIN cats c ON a.animal_id = c.animal_id
UNION
SELECT a.*, NULL AS domestic_animal_id, NULL AS draft_animal_id, NULL AS dog_id, NULL AS cat_id, h.animal_id AS hamster_id, NULL AS horse_id, NULL AS camel_id, NULL AS donkey_id FROM animals a LEFT JOIN hamsters h ON a.animal_id = h.animal_id
UNION
SELECT a.*, NULL AS domestic_animal_id, NULL AS draft_animal_id, NULL AS dog_id, NULL AS cat_id, NULL AS hamster_id, he.animal_id AS horse_id, NULL AS camel_id, NULL AS donkey_id FROM animals a LEFT JOIN equines he ON a.animal_id = he.animal_id;

--8. Создание класса с инкапсуляцией методов и наследованием:

class Animal:
    def __init__(self, name, command, birth_date):
        self.__name = name
        self.__command = command
        self.__birth_date = birth_date

    def get_name(self):
        return self.__name

    def get_command(self):
        return self.__command

    def get_birth_date(self):
        return self.__birth_date

    def set_name(self, name):
        self.__name = name

    def set_command(self, command):
        self.__command = command

    def set_birth_date(self, birth_date):
        self.__birth_date = birth_date


class DomesticAnimal(Animal):
    def __init__(self, name, command, birth_date):
        super().__init__(name, command, birth_date)


class Dog(DomesticAnimal):
    def __init__(self, name, command, birth_date):
        super().__init__(name, command, birth_date)


class Cat(DomesticAnimal):
    def __init__(self, name, command, birth_date):
        super().__init__(name, command, birth_date)


class Hamster(DomesticAnimal):
    def __init__(self, name, command, birth_date):
        super().__init__(name, command, birth_date)


class DraftAnimal(Animal):
    def __init__(self, name, command, birth_date):
        super().__init__(name, command, birth_date)


class Horse(DraftAnimal):
    def __init__(self, name, command, birth_date):
        super().__init__(name, command, birth_date)


class Camel(DraftAnimal):
    def __init__(self, name, command, birth_date):
        super().__init__(name, command, birth_date)


class Donkey(DraftAnimal):
    def __init__(self, name, command, birth_date):
        super().__init__(name, command, birth_date)


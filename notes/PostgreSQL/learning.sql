CREATE TABLE weather (
 city varchar(80),
 temp_lo int, -- low temperature
 temp_hi int, -- high temperature
 prcp real, -- precipitation
 date date
);

CREATE TABLE cities (
 name varchar(80),
 location point
);

insert into weather values ('reynosa', 15, 20, 12.1, '2022-03-19');
insert into weather values ('reynosa', 15, 20, 12.1, '2022-03-19');
insert into weather values ('reynosa', 15, 20, 12.1, '2022-03-19');
insert into weather values ('rio bravo', 15, 20, 12.1, '2022-03-19');

-- aggregate functions
-- count, max, min, etc.
select max(temp_hi) from weather;

-- we can do filter over aggregate functions
--FILTER is much like WHERE, except that it removes rows only from the input of the particular aggregate
-- function that it is attached to.
-- Note: The LIKE operator does pattern matching and is explained in Section 9.7.
select city, max(temp_hi) filter ( where city like 'rio%' ) from weather group by city;
select * from weather;


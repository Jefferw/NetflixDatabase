-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2023-04-27 18:54:00.667

-- tables
-- Table: ACTOR
CREATE TABLE ACTOR (
    	actor_ID int  NOT NULL,
    	lname varchar(50)  NULL,
    	fname varchar(50)  NULL,
    	CONSTRAINT ACTOR_pk PRIMARY KEY (actor_id)
);

-- Table: DIRECTOR
CREATE TABLE DIRECTOR (
    director_id int NOT NULL,
    name varchar(100),
    CONSTRAINT DIRECTOR_pk PRIMARY KEY (director_id)
);

-- Table: PRODUCER
CREATE TABLE PRODUCER (
    producer_id int  NOT NULL,
    name varchar,
    CONSTRAINT PRODUCER_pk PRIMARY KEY (producer_id)
);

-- Table: SERIES
CREATE TABLE SERIES (
    series_id int  NOT NULL,
    type varchar(10),
    title varchar(100),
    genre varchar(100),
    description varchar(250),
    CONSTRAINT SERIES_pk PRIMARY KEY (series_id)
);

-- Table: CONTENT
CREATE TABLE CONTENT (
    content_id int NOT NULL,
    episodeNumber int,
    title varchar(100),
    rating varchar(10),
    duration int,  
    director_id int  NOT NULL,
    producer_id int  NOT NULL,
    series_id int  NOT NULL,
    CONSTRAINT CONTENT_pk PRIMARY KEY (content_ID),
    CONSTRAINT director_content_fk foreign key (director_id)
        references DIRECTOR (director_id),
    CONSTRAINT producer_content_fk foreign key (producer_id)
        references PRODUCER (producer_id),
    CONSTRAINT series_content_fk foreign key (series_id)
        references SERIES (series_id)
);

-- TABLE ACTOR_CONTENT
CREATE TABLE ACTOR_CONTENT (
    actor_content_id int  NOT NULL,
    actor_id int NOT NULL,
    content_id int NOT NULL,
    CONSTRAINT ACTOR_CONTENT_pk PRIMARY KEY (actor_content_id),
    CONSTRAINT actor_content_actor_fk foreign key (actor_id)
	references ACTOR (actor_id),
    CONSTRAINT actor_content_content_fk foreign key (content_id)
        references CONTENT (content_id)
);


copy actor
from 'C:\Users\crane\Documents\cm336\project3\actor.csv'
delimiter  ','
csv header;

copy director
from 'C:\Users\crane\Documents\cm336\project3\director.csv'
delimiter  ','
csv header;

copy producer
from 'C:\Users\crane\Documents\cm336\project3\producer.csv'
delimiter  ','
csv header;

copy series
from 'C:\Users\crane\Documents\cm336\project3\series.csv'
delimiter  ','
csv header;

copy content
from 'C:\Users\crane\Documents\cm336\project3\content.csv'
delimiter  ','
csv header;

copy actor_content
from 'C:\Users\crane\Documents\cm336\project3\actor_content.csv'
delimiter  ','
csv header;

---------------------------------------------------------------
--Queries
--1) select movie titles where actor last name starts with 'Wal'
select title, rating
from content
where content_id in
	(select ac.content_id
	from actor_content ac JOIN actor a
	on ac.actor_id = a.actor_id
	where a.lname like 'Wal%');

--2) select actors that appear more than one piece of content
select lname, fname
from actor
where actor_id in
	(select ac1.actor_id
	from actor_content ac1 join actor_content ac2
	on ac1.actor_id = ac2.actor_id
	where ac1.actor_id = ac2.actor_id and
	ac1.content_id <> ac2.content_id);

--3) select all content name and series featuring actors with last name DiCaprio
select c.title, s.title
from content c join series s
on c.series_id = s.series_id
where c.content_id in
	(select content_id
	from actor a join actor_content ac
	on a.actor_id = ac.actor_id
	where a.lname = 'Dicaprio');

--4) select content where producer and director are the same
select c.title as title, p.name as producer, d.name as director
from content c join producer p
on c.producer_id = c.producer_id
join director d on d.director_id = c.director_id
where p.name = d.name;

--5) select series with more than 1 episode
select s.title, count(c.episodeNumber)
from series s join content c
on s.series_id = c.series_id
group by s.series_id
having count(s.series_id) > 1;

--6) select series with genre tag "Action"
select title
from series
where genre like '%Action%';
	
--7) select all content, group by type
select c.title, s.type
from content c join series s
on c.series_id = s.series_id
order by type;

--8) count number of each type of series
--show bar chart
select type, count(type)
from series
group by(type);

--9) select content longer than 60 minutes
select title, duration as runTime
from content
where duration > 60;

--10) select content appropriate for children "TV-PG" or "PG"
select c.title as content_Title, s.title as series_Title, c.rating
from content c join series s
on c.series_id = s.series_id
where rating = 'TV-PG' or rating ='PG';

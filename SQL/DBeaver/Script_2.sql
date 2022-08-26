create table tb_web_site as (
with cte_dedup_artist as (
select t1."date"
	,t1."rank"
	,t1."artist"
	,row_number() over(partition by artist order by artist, "date") as dedup
from public."Billboard" AS t1
order by t1.artist, t1."date"
)
select t1."date"
	,t1."rank"
	,t1."artist"
from cte_dedup_artist as t1
where t1.dedup = 1
)
;

select * from tb_web_site;

create table tb_artist as (
select t1."date"
	,t1."rank"
	,t1."artist"
	,t1.song
from public."Billboard" AS t1
where t1.artist = 'AC/DC'
order by t1.artist, t1.song, t1."date"
)
;

drop table tb_artist;

select * from tb_artist;

create view vw_artist as (
with cte_dedup_artist as (
select t1."date"
	,t1."rank"
	,t1."artist"
	,row_number() over(partition by artist order by artist, "date") as dedup
from tb_artist AS t1
order by t1.artist, t1."date"
)
select t1."date"
	,t1."rank"
	,t1."artist"
from cte_dedup_artist as t1
where t1.dedup = 1
)
;

drop view vw_artist;

select * from vw_artist;

insert into tb_artist (
select t1."date"
	,t1."rank"
	,t1."artist"
	,t1.song
from public."Billboard" AS t1
where t1.artist like 'Elvis%'
order by t1.artist, t1.song, t1."date"
)
;

create view vw_song as (
with cte_dedup_artist as (
select t1."date"
	,t1."rank"
	,t1."artist"
	,t1.song
	,row_number() over(partition by song order by artist, song, "date") as dedup
from tb_artist AS t1
order by t1.artist, t1.song, t1."date"
)
select t1."date"
	,t1."rank"
	,t1."artist"
	,t1.song
from cte_dedup_artist as t1
where t1.dedup = 1
)
;

select * from vw_song;

insert into tb_artist (
select t1."date"
	,t1."rank"
	,t1."artist"
	,t1.song
from public."Billboard" AS t1
where t1.artist like 'Adele%'
order by t1.artist, t1.song, t1."date"
)
;

create or replace view vw_song as (
with cte_dedup_artist as (
select t1."date"
	,t1."rank"
	,t1.artist 
	,t1.song
	,row_number() over(partition by song order by song, "date") as dedup
from tb_artist AS t1
order by t1.song, t1."date"
)
select t1."date"
	,t1."rank"
	,t1.artist 
	,t1.song
from cte_dedup_artist as t1
where t1.dedup = 1
)
;

drop view vw_song;

create or replace view vw_song as (
with cte_dedup_artist as (
select t1."date"
	,t1."rank"
	,t1.song
	,row_number() over(partition by song order by "rank", "date") as dedup
from tb_artist AS t1
order by t1.song, t1."date"
)
select t1."date"
	,t1."rank"
	,t1.song
from cte_dedup_artist as t1
where t1.dedup = 1
)
;
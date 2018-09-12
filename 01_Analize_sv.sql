/********************************************************************************************/

if object_id('target.temp1','u') is not null
	drop table target.temp1;
go


if object_id('target.page_w','u') is not null
	drop table target.page_w;
go

-- creez target Page table pentru modificari:

	select * 
	into target.page_w
	from target.page

-- Updatez Daily Likes pentru cand Lifetime Total Likes este gresit 
-- de obicei, inainte de 30-35 de followers

update target.page_w
set [Daily New Likes] = 0 
where isnull([Lifetime Total Likes],0) = 0
;
go

--update target.page_w
--set [Daily New Likes]=[Lifetime Total Likes]
--where [Date]=
--(
--	select min([Date]) as [Date]
--	from
--		(
--		select [Date],[Lifetime Total Likes]
--		from target.page_w
--		where ISNULL([Lifetime Total Likes],0) <> 0
--		) as t
--)	
--;
--go

-- creez temp cu coloanele "Lifetime..":

	select   ordinal_position as rownum
		   , column_name
	  into target.temp1
	  from information_schema.columns
	where table_schema = 'target'
	   and table_name = 'page'
	   and column_name like 'lifetime%'
		   ;
	go

-- Completez cu valorile "Lifetime..." lipsa:

	declare @i as int;
	declare @max as int;
	declare @c as int;
	declare @cmax as int;
	declare @columnname as varchar(100);
	declare @sql as varchar(max);

	set @i = 0;
	set @max = (select max(rownum) from target.temp1);

	while @i <= 	@max	
	begin
		set @columnname = (select column_name from target.temp1 where rownum = @i)       
	
		set @c = 1;
		set @cmax = (select max(rownum) from target.page);
	
		while @c < @cmax
		begin
			set @sql = 'update p2
						   set p2.[' + @columnname + '] = p1.[' + @columnname + ']
						   from target.page_w as p1, target.page_w as p2
						 where p1.rownum+1 = p2.rownum 
							   and isnull(p2.[' + @columnname + '],0) = 0
							   and p1.[' + @columnname + '] <> 0';
			exec (@sql);
			set @c = @c + 1;
		end

		set @i = @i + 1;
	end;

	---

	if object_id('target.temp1','u') is not null
		drop table target.temp1;
	go	


/*********************** Redenumesc Daily Liked and online cu ora corecta ************************/

exec sp_rename 'target.page_w.[Daily Liked and online - 0]', 'Daily Liked and online 9', 'column'; 
exec sp_rename 'target.page_w.[Daily Liked and online - 1]', 'Daily Liked and online 10', 'column'; 
exec sp_rename 'target.page_w.[Daily Liked and online - 2]', 'Daily Liked and online 11', 'column'; 
exec sp_rename 'target.page_w.[Daily Liked and online - 3]', 'Daily Liked and online 12', 'column'; 
exec sp_rename 'target.page_w.[Daily Liked and online - 4]', 'Daily Liked and online 13', 'column'; 
exec sp_rename 'target.page_w.[Daily Liked and online - 5]', 'Daily Liked and online 14', 'column'; 
exec sp_rename 'target.page_w.[Daily Liked and online - 6]', 'Daily Liked and online 15', 'column'; 
exec sp_rename 'target.page_w.[Daily Liked and online - 7]', 'Daily Liked and online 16', 'column'; 
exec sp_rename 'target.page_w.[Daily Liked and online - 8]', 'Daily Liked and online 17', 'column'; 
exec sp_rename 'target.page_w.[Daily Liked and online - 9]', 'Daily Liked and online 18', 'column'; 
exec sp_rename 'target.page_w.[Daily Liked and online - 10]', 'Daily Liked and online 19', 'column';	
exec sp_rename 'target.page_w.[Daily Liked and online - 11]', 'Daily Liked and online 20', 'column'; 
exec sp_rename 'target.page_w.[Daily Liked and online - 12]', 'Daily Liked and online 21', 'column'; 
exec sp_rename 'target.page_w.[Daily Liked and online - 13]', 'Daily Liked and online 22', 'column'; 
exec sp_rename 'target.page_w.[Daily Liked and online - 14]', 'Daily Liked and online 23', 'column'; 
exec sp_rename 'target.page_w.[Daily Liked and online - 15]', 'Daily Liked and online 0', 'column'; 
exec sp_rename 'target.page_w.[Daily Liked and online - 16]', 'Daily Liked and online 1', 'column'; 
exec sp_rename 'target.page_w.[Daily Liked and online - 17]', 'Daily Liked and online 2', 'column'; 
exec sp_rename 'target.page_w.[Daily Liked and online - 18]', 'Daily Liked and online 3', 'column'; 
exec sp_rename 'target.page_w.[Daily Liked and online - 19]', 'Daily Liked and online 4', 'column'; 
exec sp_rename 'target.page_w.[Daily Liked and online - 20]', 'Daily Liked and online 5', 'column'; 
exec sp_rename 'target.page_w.[Daily Liked and online - 21]', 'Daily Liked and online 6', 'column'; 
exec sp_rename 'target.page_w.[Daily Liked and online - 22]', 'Daily Liked and online 7', 'column'; 
exec sp_rename 'target.page_w.[Daily Liked and online - 23]', 'Daily Liked and online 8', 'column'; 

---

alter table target.page_w
add [Week Day] varchar(20)
;
go

alter table target.page_w
add [Weekend?] varchar(1)
;
go
---

update target.page_w
set [Week Day] = datename(dw,[Date])
;
go
	
update target.page_w
set [Weekend?] = (case when [Week Day] in ('Saturday','Sunday') then 'Y' else 'N' end)
;
go
 ---
 
 alter table target.page_w
 add [Daily Liked and online 9 %] int  default 0,
	 [Daily Liked and online 10 %] int  default(0),
	 [Daily Liked and online 11 %] int  default(0),
	 [Daily Liked and online 12 %] int  default(0) ,
	 [Daily Liked and online 13 %] int  default(0),
	 [Daily Liked and online 14 %] int  default(0),
	 [Daily Liked and online 15 %] int  default(0),
	 [Daily Liked and online 16 %] int  default(0),
	 [Daily Liked and online 17 %] int  default(0),
	 [Daily Liked and online 18 %] int  default(0),
	 [Daily Liked and online 19 %] int  default(0),
	 [Daily Liked and online 20 %] int  default(0),
	 [Daily Liked and online 21 %] int  default(0),
	 [Daily Liked and online 22 %] int  default(0),
	 [Daily Liked and online 23 %] int  default(0),	 
	 [Daily Liked and online 0 %] int  default(0),
	 [Daily Liked and online 1 %] int  default(0),
	 [Daily Liked and online 2 %] int  default(0),
	 [Daily Liked and online 3 %] int  default(0),
	 [Daily Liked and online 4 %] int  default(0),
	 [Daily Liked and online 5 %] int  default(0),
	 [Daily Liked and online 6 %] int  default(0),
	 [Daily Liked and online 7 %] int  default(0),
	 [Daily Liked and online 8 %] int  default(0)
;
go

update target.page_w
set  [Daily Liked and online 9 %] = nullif(([Daily Liked and online 9]*100/[Lifetime total likes]),0),
	 [Daily Liked and online 10 %] = nullif(([Daily Liked and online 10]*100/[Lifetime total likes]),0),
	 [Daily Liked and online 11 %] = nullif(([Daily Liked and online 11]*100/[Lifetime total likes]),0),
	 [Daily Liked and online 12 %] = nullif(([Daily Liked and online 12]*100/[Lifetime total likes]),0),
	 [Daily Liked and online 13 %] = nullif(([Daily Liked and online 13]*100/[Lifetime total likes]),0),
	 [Daily Liked and online 14 %] = nullif(([Daily Liked and online 14]*100/[Lifetime total likes]),0),
	 [Daily Liked and online 15 %] = nullif(([Daily Liked and online 15]*100/[Lifetime total likes]),0),
	 [Daily Liked and online 16 %] = nullif(([Daily Liked and online 16]*100/[Lifetime total likes]),0),
	 [Daily Liked and online 17 %] = nullif(([Daily Liked and online 17]*100/[Lifetime total likes]),0),
	 [Daily Liked and online 18 %] = nullif(([Daily Liked and online 18]*100/[Lifetime total likes]),0),
	 [Daily Liked and online 19 %] = nullif(([Daily Liked and online 19]*100/[Lifetime total likes]),0),
	 [Daily Liked and online 20 %] = nullif(([Daily Liked and online 20]*100/[Lifetime total likes]),0),
	 [Daily Liked and online 21 %] = nullif(([Daily Liked and online 21]*100/[Lifetime total likes]),0),
	 [Daily Liked and online 22 %] = nullif(([Daily Liked and online 22]*100/[Lifetime total likes]),0),
	 [Daily Liked and online 23 %] = nullif(([Daily Liked and online 23]*100/[Lifetime total likes]),0),
	 [Daily Liked and online 0 %] = nullif(([Daily Liked and online 0]*100/[Lifetime total likes]),0),
	 [Daily Liked and online 1 %] = nullif(([Daily Liked and online 1]*100/[Lifetime total likes]),0),
	 [Daily Liked and online 2 %] = nullif(([Daily Liked and online 2]*100/[Lifetime total likes]),0),
	 [Daily Liked and online 3 %] = nullif(([Daily Liked and online 3]*100/[Lifetime total likes]),0),
	 [Daily Liked and online 4 %] = nullif(([Daily Liked and online 4]*100/[Lifetime total likes]),0),
	 [Daily Liked and online 5 %] = nullif(([Daily Liked and online 5]*100/[Lifetime total likes]),0),
	 [Daily Liked and online 6 %] = nullif(([Daily Liked and online 6]*100/[Lifetime total likes]),0),
	 [Daily Liked and online 7 %] = nullif(([Daily Liked and online 7]*100/[Lifetime total likes]),0),
	 [Daily Liked and online 8 %] = nullif(([Daily Liked and online 8]*100/[Lifetime total likes]),0)
from target.page_w
where [Lifetime total likes]<>0
;
go

--- min, max, average pe fiecare ora, grupate pe zilele saptamanii

if object_id('target.FansHoursOnline','u') is not null
	drop table target.FansHoursOnline;		
go

select  [Week Day],
		MIN([Daily Liked and online 9 %]) as Min_9,
	    MAX([Daily Liked and online 9 %]) as Max_9, 
	    AVG([Daily Liked and online 9 %]) as Avg_9,
	    Round(STDEV([Daily Liked and online 9 %]),2) as Stdev_9,
	    Round((1.96*STDEV([Daily Liked and online 9 %])/sqrt(count([Daily Liked and online 9 %]))),2) as conf_int_9,
	    MIN([Daily Liked and online 10 %]) as Min_10,
	    MAX([Daily Liked and online 10 %]) as Max_10, 
	    AVG([Daily Liked and online 10 %]) as Avg_10,
	    Round(STDEV([Daily Liked and online 10 %]),2) as Stdev_10,
	    Round((1.96*STDEV([Daily Liked and online 10 %])/sqrt(count([Daily Liked and online 10 %]))),2) as conf_int_10,
	    MIN([Daily Liked and online 11 %]) as Min_11,
	    MAX([Daily Liked and online 11 %]) as Max_11, 
	    AVG([Daily Liked and online 11 %]) as Avg_11,
	    Round(STDEV([Daily Liked and online 11 %]),2) as Stdev_11,
	    Round((1.96*STDEV([Daily Liked and online 11 %])/sqrt(count([Daily Liked and online 11 %]))),2) as conf_int_11,
	    MIN([Daily Liked and online 12 %]) as Min_12,
	    MAX([Daily Liked and online 12 %]) as Max_12, 
	    AVG([Daily Liked and online 12 %]) as Avg_12,
	    Round(STDEV([Daily Liked and online 12 %]),2) as Stdev_12,
	    Round((1.96*STDEV([Daily Liked and online 12 %])/sqrt(count([Daily Liked and online 12 %]))),2) as conf_int_12,
	    MIN([Daily Liked and online 13 %]) as Min_13,
	    MAX([Daily Liked and online 13 %]) as Max_13, 
	    AVG([Daily Liked and online 13 %]) as Avg_13,
	    Round(STDEV([Daily Liked and online 13 %]),2) as Stdev_13,
	    Round((1.96*STDEV([Daily Liked and online 13 %])/sqrt(count([Daily Liked and online 13 %]))),2) as conf_int_13,
	    MIN([Daily Liked and online 14 %]) as Min_14,
	    MAX([Daily Liked and online 14 %]) as Max_14, 
	    AVG([Daily Liked and online 14 %]) as Avg_14,
	    Round(STDEV([Daily Liked and online 14 %]),2) as Stdev_14,
	    Round((1.96*STDEV([Daily Liked and online 14 %])/sqrt(count([Daily Liked and online 14 %]))),2) as conf_int_14,
	    MIN([Daily Liked and online 15 %]) as Min_15,
	    MAX([Daily Liked and online 15 %]) as Max_15, 
	    AVG([Daily Liked and online 15 %]) as Avg_15,
	    Round(STDEV([Daily Liked and online 15 %]),2) as Stdev_15,
	    Round((1.96*STDEV([Daily Liked and online 15 %])/sqrt(count([Daily Liked and online 15 %]))),2) as conf_int_15,
	    MIN([Daily Liked and online 16 %]) as Min_16,
	    MAX([Daily Liked and online 16 %]) as Max_16, 
	    AVG([Daily Liked and online 16 %]) as Avg_16,
	    Round(STDEV([Daily Liked and online 16 %]),2) as Stdev_16,
	    Round((1.96*STDEV([Daily Liked and online 16 %])/sqrt(count([Daily Liked and online 16 %]))),2) as conf_int_16,
	    MIN([Daily Liked and online 17 %]) as Min_17,
	    MAX([Daily Liked and online 17 %]) as Max_17, 
	    AVG([Daily Liked and online 17 %]) as Avg_17,
	    Round(STDEV([Daily Liked and online 17 %]),2) as Stdev_17,
	    Round((1.96*STDEV([Daily Liked and online 17 %])/sqrt(count([Daily Liked and online 17 %]))),2) as conf_int_17,
	    MIN([Daily Liked and online 18 %]) as Min_18,
	    MAX([Daily Liked and online 18 %]) as Max_18, 
	    AVG([Daily Liked and online 18 %]) as Avg_18,
	    Round(STDEV([Daily Liked and online 18 %]),2) as Stdev_18,
	    Round((1.96*STDEV([Daily Liked and online 18 %])/sqrt(count([Daily Liked and online 18 %]))),2) as conf_int_18,
	    MIN([Daily Liked and online 19 %]) as Min_19,
	    MAX([Daily Liked and online 19 %]) as Max_19, 
	    AVG([Daily Liked and online 19 %]) as Avg_19,
	    Round(STDEV([Daily Liked and online 19 %]),2) as Stdev_19,
	    Round((1.96*STDEV([Daily Liked and online 19 %])/sqrt(count([Daily Liked and online 19 %]))),2) as conf_int_19,
	    MIN([Daily Liked and online 20 %]) as Min_20,
	    MAX([Daily Liked and online 20 %]) as Max_20, 
	    AVG([Daily Liked and online 20 %]) as Avg_20,
	    Round(STDEV([Daily Liked and online 20 %]),2) as Stdev_20,
	    Round((1.96*STDEV([Daily Liked and online 20 %])/sqrt(count([Daily Liked and online 20 %]))),2) as conf_int_20,
	    MIN([Daily Liked and online 21 %]) as Min_21,
	    MAX([Daily Liked and online 21 %]) as Max_21, 
	    AVG([Daily Liked and online 21 %]) as Avg_21,
	    Round(STDEV([Daily Liked and online 21 %]),2) as Stdev_21,
	    Round((1.96*STDEV([Daily Liked and online 21 %])/sqrt(count([Daily Liked and online 21 %]))),2) as conf_int_21,
	    MIN([Daily Liked and online 22 %]) as Min_22,
	    MAX([Daily Liked and online 22 %]) as Max_22, 
	    AVG([Daily Liked and online 22 %]) as Avg_22,
	    Round(STDEV([Daily Liked and online 22 %]),2) as Stdev_22,
	    Round((1.96*STDEV([Daily Liked and online 22 %])/sqrt(count([Daily Liked and online 22 %]))),2) as conf_int_22,
	    MIN([Daily Liked and online 23 %]) as Min_23,
	    MAX([Daily Liked and online 23 %]) as Max_23, 
	    AVG([Daily Liked and online 23 %]) as Avg_23,
	    Round(STDEV([Daily Liked and online 23 %]),2) as Stdev_23,
	    Round((1.96*STDEV([Daily Liked and online 23 %])/sqrt(count([Daily Liked and online 23 %]))),2) as conf_int_23,
	    MIN([Daily Liked and online 0 %]) as Min_0,
	    MAX([Daily Liked and online 0 %]) as Max_0, 
	    AVG([Daily Liked and online 0 %]) as Avg_0,
	    Round(STDEV([Daily Liked and online 0 %]),2) as Stdev_0,
	    Round((1.96*STDEV([Daily Liked and online 0 %])/sqrt(count([Daily Liked and online 0 %]))),2) as conf_int_0,
	    MIN([Daily Liked and online 1 %]) as Min_1,
	    MAX([Daily Liked and online 1 %]) as Max_1, 
	    AVG([Daily Liked and online 1 %]) as Avg_1,
	    Round(STDEV([Daily Liked and online 1 %]),2) as Stdev_1,
	    Round((1.96*STDEV([Daily Liked and online 1 %])/sqrt(count([Daily Liked and online 1 %]))),2) as conf_int_1,
	    MIN([Daily Liked and online 2 %]) as Min_2,
	    MAX([Daily Liked and online 2 %]) as Max_2, 
	    AVG([Daily Liked and online 2 %]) as Avg_2,
	    Round(STDEV([Daily Liked and online 2 %]),2) as Stdev_2,
	    Round((1.96*STDEV([Daily Liked and online 2 %])/sqrt(count([Daily Liked and online 2 %]))),2) as conf_int_2,
	    MIN([Daily Liked and online 3 %]) as Min_3,
	    MAX([Daily Liked and online 3 %]) as Max_3, 
	    AVG([Daily Liked and online 3 %]) as Avg_3,
	    Round(STDEV([Daily Liked and online 3 %]),2) as Stdev_3,
	    Round((1.96*STDEV([Daily Liked and online 3 %])/sqrt(count([Daily Liked and online 3 %]))),2) as conf_int_3,
	    MIN([Daily Liked and online 4 %]) as Min_4,
	    MAX([Daily Liked and online 4 %]) as Max_4, 
	    AVG([Daily Liked and online 4 %]) as Avg_4,
	    Round(STDEV([Daily Liked and online 4 %]),2) as Stdev_4,
	    Round((1.96*STDEV([Daily Liked and online 4 %])/sqrt(count([Daily Liked and online 4 %]))),2) as conf_int_4,
	    MIN([Daily Liked and online 5 %]) as Min_5,
	    MAX([Daily Liked and online 5 %]) as Max_5, 
	    AVG([Daily Liked and online 5 %]) as Avg_5,
	    Round(STDEV([Daily Liked and online 5 %]),2) as Stdev_5,
	    Round((1.96*STDEV([Daily Liked and online 5 %])/sqrt(count([Daily Liked and online 5 %]))),2) as conf_int_5,
	    MIN([Daily Liked and online 6 %]) as Min_6,
	    MAX([Daily Liked and online 6 %]) as Max_6, 
	    AVG([Daily Liked and online 6 %]) as Avg_6,
	    Round(STDEV([Daily Liked and online 6 %]),2) as Stdev_6,
	    Round((1.96*STDEV([Daily Liked and online 6 %])/sqrt(count([Daily Liked and online 6 %]))),2) as conf_int_6,
	    MIN([Daily Liked and online 7 %]) as Min_7,
	    MAX([Daily Liked and online 7 %]) as Max_7, 
	    AVG([Daily Liked and online 7 %]) as Avg_7,
	    Round(STDEV([Daily Liked and online 7 %]),2) as Stdev_7,
	    Round((1.96*STDEV([Daily Liked and online 7 %])/sqrt(count([Daily Liked and online 7 %]))),2) as conf_int_7,
	    MIN([Daily Liked and online 8 %]) as Min_8,
	    MAX([Daily Liked and online 8 %]) as Max_8, 
	    AVG([Daily Liked and online 8 %]) as Avg_8,
	    Round(STDEV([Daily Liked and online 8 %]),2) as Stdev_8,
	    Round((1.96*STDEV([Daily Liked and online 8 %])/sqrt(count([Daily Liked and online 8 %]))),2) as conf_int_8
into target.FansHoursOnline
from target.page_w
group by [Week Day]
;
go

---

if object_id('target.ExportFansHoursOnline','u') is not null
	drop table target.ExportFansHoursOnline;		
go

select [Week Day],
		Avg_0 as [00:00], Avg_1 [01:00], Avg_2 as [02:00], Avg_3 as [03:00], Avg_4 as [04:00], Avg_5 as [05:00], Avg_6 as [06:00], 
		Avg_7 as [07:00], Avg_8 as [08:00], Avg_9 as [09:00], Avg_10 as [10:00], Avg_11 as [11:00], Avg_12 as [12:00], 
		Avg_13 as [13:00], Avg_14 as [14:00], Avg_15 as [15:00], Avg_16 as [16:00], Avg_17 as [17:00], Avg_18 as [18:00], 
		Avg_19 as [19:00], Avg_20 as [20:00], Avg_21 as [21:00], Avg_22 as [22:00], Avg_23 as [23:00]			
into target.ExportFansHoursOnline
from target.FansHoursOnline
order by 1
;
go
		

--- Update target.post cu data urmatorului post

--alter table target.post
--add [Next Posted] datetime
--;
--go


update p
set p.[Next Posted] = p2.[Posted]
from target.post as p, target.post as p2
where p.Rownum = p2.Rownum-1
;
go


-- ultimul next posted este null -> update

update target.post
set [Next Posted] = (select MAX([Date]) as maxDate from target.page)
where [Next Posted] is null
;
go

-- updatez campul cu urmatoarea data diferita

update t
set t.[Next Posted Diff Day] = t2.[Next Posted]
from target.post as t, target.post as t2
where cast(t.posted as date) = cast(t2.posted as date) and cast(t.[next posted] as date) <> cast(t2.[next posted] as date)

update t
set [Next Posted Diff Day] = [next Posted]
from target.post as t
where cast(t.posted as date) <> cast(t.[Next posted] as date)


--- Join cu target.post

if object_id('target.AllPostPage','u') is not null
	drop table target.AllPostPage;		
go

select  ps.Rownum,
		ps.[Post ID],
		ps.[Posted],
		ps.[Next Posted],
		ps.[Post Message],
		ps.[Type],
		0 as [Lifetime Likes],
		isnull(SUM(pg.[Daily New Likes]),0) as [Daily New Likes],
		isnull(SUM(pg.[Daily Unlikes]),0) as [Daily Unlikes],	
		
		ps.[Lifetime Post Total Reach],
		ps.[Lifetime Post reach by people who like your Page],
		isnull(SUM(pg.[Daily Total Reach]),0) as [Daily Total Reach],
		isnull(SUM(pg.[Daily Viral Reach]),0) as [Daily Viral Reach],
		isnull(SUM(pg.[Daily Reach of Page Posts]),0) as [Daily Reach of Page Posts],
		isnull(SUM(pg.[Daily Total Impressions]),0) as [Daily Total Impressions],
		ps.[Lifetime Post Total Impressions],
		ps.[Lifetime Post impressions by people who have liked your Page],
		ps.[Lifetime Post stories by action type - share],
		ps.[Lifetime Post stories by action type - like],
		ps.[Lifetime Post stories by action type - comment],
		
		ps.[Lifetime Post Consumers],
		ps.[Lifetime Post Consumptions],
		ps.[Lifetime Post consumptions by type - other clicks],
		ps.[Lifetime Post consumptions by type - link clicks],
		ps.[Lifetime Post consumptions by type - photo view],
		isnull(SUM(pg.[Daily Total Consumers]),0) as [Daily Total Consumers],
		isnull(SUM(pg.[Daily Page Consumptions]),0) as [Daily Page Consumptions]		
into target.AllPostPage
from target.post as ps
left join target.page_w as pg
on pg.[Date]>=cast(ps.[Posted] as Date) and pg.[Date] < cast(isnull(ps.[Next Posted Diff Day],GETDATE()) as Date) 
	
group by 
		ps.Rownum,
		ps.[Post ID],
		ps.[Posted],
		ps.[Next Posted],
		ps.[Post Message],
		ps.[Type],
		ps.[Lifetime Post Total Reach],
		ps.[Lifetime Post Total Impressions],
		ps.[Lifetime Post Consumers],
		ps.[Lifetime Post Consumptions],
		ps.[Lifetime Post impressions by people who have liked your Page],
		ps.[Lifetime Negative feedback from users],
		ps.[Lifetime Post reach by people who like your Page],
		ps.[Lifetime Post stories by action type - share],
		ps.[Lifetime Post stories by action type - like],
		ps.[Lifetime Post stories by action type - comment],
		ps.[Lifetime Post consumptions by type - other clicks],
		ps.[Lifetime Post consumptions by type - link clicks],
		ps.[Lifetime Post consumptions by type - photo view]
;
go


update ps
set ps.[Lifetime Likes] = pg.[Lifetime Total Likes]	 
from target.AllPostPage as ps, target.page as pg, target.post as ps2
where cast(ps2.[Next Posted Diff Day] as date) = dateadd(d,1,pg.Date)
and   ps.posted = ps2.posted



 
 /********************************* Exports ************************************************/
 
-- Creez tabel cu ceilalti indicatori

 if object_id('target.ExportMetrics','u') is not null
	drop table target.ExportMetrics;		
 go

select  [Post ID],
		[Posted] as [Data],
		[Next posted],
		[Post Message],
		[Type] as [Tip],
		cast(cast([Posted] as date)	as varchar(10)) + ' - ' + left([Post Message],30) as [Post],
		[Daily New Likes],
		round((case when [Daily New Likes] = 0 then 0 else ([Daily New Likes]*100/cast([Daily Total Reach] as float)) end),1) as [Likes % of Total Reach],
		
		[Daily Unlikes],	

		--Post total reach
		[Lifetime Post Total Reach],
		
		--Post fan reach
		[Lifetime Post reach by people who like your Page] as [Lifetime Post Reach by Fans],
		
		--Fans at post time
		[Lifetime Likes],
		
		--% of fans reached
		Round(case when [lifetime likes]=0 then 0 else ([Lifetime Post reach by people who like your Page]*100/CAST([Lifetime Likes] as float)) end,1) as [Fans % Reached with Post],
		
		--Post viral reach
		([Lifetime Post Total Reach] - [Lifetime Post reach by people who like your Page]) as [Lifetime Post Viral Reach],
		
		--Post viral %
		Round((case when [Lifetime Post Total Reach]=0 then 0 else 
			(([Lifetime Post Total Reach] - [Lifetime Post reach by people who like your Page])*100/cast([Lifetime Post Total Reach] as float))  end),1) as [Lifetime Post Viral % of Total Reach],
		
		--Post stories type	
		[Lifetime Post stories by action type - share],
		[Lifetime Post stories by action type - like],
		[Lifetime Post stories by action type - comment],
		
		[Daily Reach of Page Posts],

		case when [Lifetime Post Total Reach] = 0 then 0 else 
			case when [Lifetime Likes] > 0 then Round(([Lifetime Post Total Reach] / cast([Lifetime Likes] as float)),1) end
		end as [No times reach is higher than fans],				
		
		-- Page total reach
		[Daily Total Reach] as [Page Total Reach],
		
		-- Page viral reach
		[Daily Viral Reach] as [Page Viral Reach],
		
		-- Page viral %
		Round((case when [Daily Total Reach] = 0 then 0 else ([Daily Viral Reach]*100/cast([Daily Total Reach] as float))end),1) as [Page Viral % of Total Reach],
		
		--Page reach outside post
		case when [Daily Total reach] > [Lifetime Post Total Reach] then ([Daily Total reach] - [Lifetime Post Total Reach])else 0 end as [Page Reach outside Post],

		--Post impressions
		[Lifetime Post Total Impressions],
		
		-- Post impressions by fans
		[Lifetime Post impressions by people who have liked your Page] as [Lifetime Post Impressions by Fans],
		
		-- Post impressions viral
		([Lifetime Post Total Impressions]-[Lifetime Post impressions by people who have liked your Page]) as [Lifetime Post Impressions Viral],
		
		-- Post times seen / total
		Round((case when [Lifetime Post Total Reach] = 0 then 0 else [Lifetime Post Total Impressions]/cast([Lifetime Post Total Reach] as float) end),1) as [Post Times Seen - Total],
			
		-- Post times seen / fan
		Round((case when [Lifetime Post reach by people who like your Page] = 0 then 0 else [Lifetime Post impressions by people who have liked your Page] / cast([Lifetime Post reach by people who like your Page] as float) end),1) as [Post Times Seen - Fans],
					
		-- Post times seen / viral
		Round(case when ([Lifetime Post Total Reach] - [Lifetime Post reach by people who like your Page]) = 0 then 0 else 
				  ([Lifetime Post Total Impressions]-[Lifetime Post impressions by people who have liked your Page])/cast(([Lifetime Post Total Reach] - [Lifetime Post reach by people who like your Page]) as float) end,1) as [Post Times Seen - Viral],

		-- Page impressions
		[Daily Total Impressions] as [Page Total Impressions],
		
		-- Page impressions outside post
		case when [Daily Total Impressions] > [Lifetime Post Total Impressions] then ([Daily Total Impressions] - [Lifetime Post Total Impressions]) else 0 end as [Page Impressions outside Post],
		
		-- Page times seen outside post
		Round(case when ([Daily Total Impressions] - [Lifetime Post Total Impressions]) = 0 or ([Daily Total reach] - [Lifetime Post Total Reach]) = 0 then 0 
		else ([Daily Total Impressions] - [Lifetime Post Total Impressions])/cast(([Daily Total reach] - [Lifetime Post Total Reach]) as float) end,1) as [Page times seen outside post],
	
		

		[Lifetime Post Consumers],
		Round(case when [Lifetime Post Total Reach] < [Lifetime Post Consumers] then 0 else ([Lifetime Post Consumers]*100/cast([Lifetime Post Total Reach] as float)) end,1) as [% Post Consumers of Total Reached], 
		
		[Lifetime Post Consumptions],
		Round(case when [Lifetime Post Total Impressions] < [Lifetime Post Consumptions] then 0 else ([Lifetime Post Consumptions]*100/cast([Lifetime Post Total Impressions] as float)) end,1) as [% Post Consumptions of Total Impressions], 
		Round(case when [Lifetime Post Consumers] = 0 then 0 else ([Lifetime Post Consumptions]/cast([Lifetime Post Consumers] as float)) end,1) as [Post Times Consumed],
		
		Round(case when [Lifetime Post consumptions by type - other clicks] > 0 then 
			([Lifetime Post consumptions] - [Lifetime Post consumptions by type - other clicks]) * 100/cast([Lifetime Post consumptions] as float) 
			else case when [Lifetime Post consumptions] > 0 then 100 else 0 end
		end,1) as [Actual Content Consumption],
		
		[Lifetime Post consumptions by type - other clicks],
		[Lifetime Post consumptions by type - link clicks],
		[Lifetime Post consumptions by type - photo view],
		
		[Daily Total Consumers],
		case when [Daily Total Consumers] > [Lifetime Post Consumers] then ([Daily Total Consumers] - [Lifetime Post Consumers]) else 0 end as [Page Consumers Outside Post],

		[Daily Page Consumptions],
		case when [Daily Page Consumptions] >  [Lifetime Post consumptions] then ([Daily Page Consumptions] - [Lifetime Post consumptions]) else 0 end as [Page Consumptions outside Post]		
into target.ExportMetrics
from target.AllPostPage
;
go


/******************************************** Pentru export-uri ************************************************/


-- Top 10 Daily Likes

select  top 10 [Post ID],
				[Data],
				[Post],
				[Tip],
				[Daily New Likes] as [Aprecieri noi],
				[Likes % of Total Reach] as [Postările care au adus cele mai multe aprecieri paginii tale(%) - top 10 -]
from target.ExportMetrics
order by [Likes % of Total Reach] desc
;

---
select  top 10 [Post ID],
				[Data],
				[Post],
				[Tip],
				[Daily Unlikes] as [Anulări ale aprecierilor după postare - top 10 -]
from target.ExportMetrics
order by [Daily Unlikes] desc
;

---
select  top 10 [Post ID],
				[Data],
				[Post],
				[Tip],
				Round([Fans % Reached with Post],0) as [Fani ai paginii cărora le-a fost afișată postarea (%) - top 10 -]
from target.ExportMetrics
order by [Fans % Reached with Post] desc
;

--- 
 select  top 10 [Post ID],
				[Data],
				[Post],
				[Tip],	 
				--[Lifetime Likes] as [Total aprecieri pagină],
				--[Lifetime Post Total Reach]	as [Impact total postare],
				--[No times reach is higher than fans] as [Impact total / Total fani],
				Round([Lifetime Post Viral % of Total Reach],0) as [Impact viral al postării din impactul total (%) - top 10 -],
				[Lifetime Post stories by action type - share] as [Distribuiri],
				[Lifetime Post stories by action type - like] as [Aprecieri],
				[Lifetime Post stories by action type - comment] as [Comentarii]
				
from target.ExportMetrics
order by [Lifetime Post Viral % of Total Reach] desc
 ;

----

select  top 10 [Post ID],
				[Data],
				[Post],
				[Tip],
				1 as [Total],
				[% Post Consumptions of Total Impressions]/100 as [Click-uri pe postare (%)],
				[Post Times Consumed] as [Număr de click-uri pe utilizator],
				([Actual Content Consumption]/100*[% Post Consumptions of Total Impressions])/100 as [Click-uri relevante pe conținut (%)],
				[Lifetime Post Consumptions by type - link clicks] as [Click pe link],
				[Lifetime Post consumptions by type - photo view] as [Click pe imagine],
				[Lifetime Post Consumptions by type - other clicks] as [Alte click-uri]
from target.ExportMetrics
order by [% Post Consumptions of Total Impressions] desc

----

select * from target.ExportFansHoursOnline

---

select [DATE], [Week Day], 
	 [Daily Liked and online 6 %] as [6],
	 [Daily Liked and online 7 %] as [7],
	 [Daily Liked and online 8 %] as [8],
	 [Daily Liked and online 9 %] as [9],
	 [Daily Liked and online 10 %] as [10],
	 [Daily Liked and online 11 %] as [11],
	 [Daily Liked and online 12 %] as [12],
	 [Daily Liked and online 13 %] as [13],
	 [Daily Liked and online 14 %] as [14],
	 [Daily Liked and online 15 %] as [15],
	 [Daily Liked and online 16 %] as [16],
	 [Daily Liked and online 17 %] as [17],
	 [Daily Liked and online 18 %] as [18],
	 [Daily Liked and online 19 %] as [19],
	 [Daily Liked and online 20 %] as [20],
	 [Daily Liked and online 21 %] as [21],
	 [Daily Liked and online 22 %] as [22],
	 [Daily Liked and online 23 %] as [23],
	 [Daily Liked and online 0 %] as [0],
	 [Daily Liked and online 1 %] as [1],
	 [Daily Liked and online 2 %] as [2],
	 [Daily Liked and online 3 %] as [3],
	 [Daily Liked and online 4 %] as [4],
	 [Daily Liked and online 5 %] as [5]
	
 from target.page_w
 where [week day] = 'sunday'
 order by [week day]

/************************************ select all columns from a table *********************************************/

--select   *
--from information_schema.columns
--where table_schema = 'target'
--	and table_name = 'ExportMetrics'

/********************************** tables to delete when I leave work *********************************************/

	--if object_id('target.AllPostPage','u') is not null
	--	drop table target.AllPostPage;		
	-- go


	-- if object_id('target.ExportFansDemo_Daily','u') is not null
	--	drop table target.ExportFansDemo_Daily;		
	-- go


	-- if object_id('target.ExportFansDemo_Lifetime','u') is not null
	--	drop table target.ExportFansDemo_Lifetime;		
	-- go


	-- if object_id('target.ExportFansHoursOnline','u') is not null
	--	drop table target.ExportFansHoursOnline;		
	-- go


	-- if object_id('target.ExportMetrics','u') is not null
	--	drop table target.ExportMetrics;		
	-- go


	-- if object_id('target.FansHoursOnline','u') is not null
	--	drop table target.FansHoursOnline;		
	-- go


	-- if object_id('target.page','u') is not null
	--	drop table target.page;		
	-- go

	-- if object_id('target.page_w','u') is not null
	--	drop table target.page_w;		
	-- go

	-- if object_id('target.post','u') is not null
	--	drop table target.post;		
	-- go


	-- if object_id('target.temp_City','u') is not null
	--	drop table target.temp_City;		
	-- go


	-- if object_id('target.temp_Country','u') is not null
	--	drop table target.temp_Country;		
	-- go


	-- if object_id('target.temp_LikesGenderAge','u') is not null
	--	drop table target.temp_LikesGenderAge;		
	-- go


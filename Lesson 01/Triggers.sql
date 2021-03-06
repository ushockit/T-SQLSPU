-- Типы триггеров
-- AFTER - срабатывает после действия
-- INSTEAD OF - срабатывает вместо действия


create table History (
	id int primary key identity,
	[action] varchar(15),
	[description] text,
	[date] date default getdate()
);
go

-- создание нового триггера, который будет срабатывать после вставки новой записи в таблицу Products
create or alter trigger Products_Insert 
on Products	-- к таблице Products
after insert	-- тип триггера для команды INSERT
as
insert into History ([action], [description])
select 'New product', 'Insert ' + [name] from inserted;
go


insert into Products values ('Butter', '...', 100, 3);
go


select * from Products;
select * from History;


alter table Products add deleted bit default 0;
go

-- создание триггера, который будет срабатывать вместо операции удаления продукта
create or alter trigger Products_Delete
on Products			-- таблица
instead of delete	-- тип триггера
as
update Products set deleted = 1
where id = (select id from deleted);
go

delete Products where id = 3;
go
-- ���� ���������
-- AFTER - ����������� ����� ��������
-- INSTEAD OF - ����������� ������ ��������


create table History (
	id int primary key identity,
	[action] varchar(15),
	[description] text,
	[date] date default getdate()
);
go

-- �������� ������ ��������, ������� ����� ����������� ����� ������� ����� ������ � ������� Products
create or alter trigger Products_Insert 
on Products	-- � ������� Products
after insert	-- ��� �������� ��� ������� INSERT
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

-- �������� ��������, ������� ����� ����������� ������ �������� �������� ��������
create or alter trigger Products_Delete
on Products			-- �������
instead of delete	-- ��� ��������
as
update Products set deleted = 1
where id = (select id from deleted);
go

delete Products where id = 3;
go
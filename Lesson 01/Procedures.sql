-- -= Процедуры =-
use firstdb;
go


insert into Categories values 
('Category 1'),
('Category 2'),
('Category 3'),
('Category 4');
go

insert into Products values 
('Product 1', '...', 50, 1),
('Product 2', '...', 150, 2),
('Product 3', '...', 20, 4),
('Product 4', '...', 30, 3),
('Product 5', '...', 10, 2),
('Product 6', '...', 15.30, 1),
('Product 7', '...', 190.35, 3);
go


--создание новой процедуры
create or alter procedure sp_AllProducts as
begin
	select * from Products;
end
go

create or alter procedure sp_CreateProduct
	@name nvarchar(20),
	@photo text,
	@price money,
	@categoryId int
	as
begin
	insert into Products values (@name, @photo, @price, @categoryId);
end
go


-- вызов процедуры
exec sp_AllProducts;

exec sp_CreateProduct 'New product', '...', 11.2, 3;
go



-- процедура регистрации пользователя
create or alter procedure sp_RegistrationUser
	@email varchar(50),
	@login varchar(20),
	@password varchar(20),
	@firstName nvarchar(20),
	@lastName nvarchar(20),
	@middleName nvarchar(20),
	@birth date
	as
begin
	begin tran;
	begin try 
		insert into UserInfos values (@firstName, @lastName, @middleName, @birth);
		insert into Accounts values (@email, @login, @password, getdate(), @@IDENTITY);
		commit tran;
	end try
	begin catch
		rollback tran;
	end catch
end
go


exec sp_RegistrationUser 'vasya@gmail.com', 'vasya_2021', 'vasya123456', 'Vasya', 'Pupkin', 'Ivanovich', '1977-10-03';
go



-- возвращаение целого значения из процедуры
create or alter proc sp_GetCountUsersGreatherThan18Year
	as
begin
	declare @count int = 0;
	SELECT @count = COUNT(*) FROM UserInfos WHERE YEAR(GETDATE()) - YEAR(birth) >= 18;
	return @count;
end
go

declare @count int = 0;
exec @count = sp_GetCountUsersGreatherThan18Year;
print @count;
go

-- выходные параметры процедур
create or alter proc sp_GetMinMaxPriceProduct
	@min money output,
	@max money output
	as
begin
	select @min = MIN(price), @max = MAX(price) from Products
end
go


declare @minPrice money = 0;
declare @maxPrice money = 0;

exec sp_GetMinMaxPriceProduct @minPrice output, @maxPrice output;

print 'Min price = ' + CONVERT(varchar(10), @minPrice);
print 'Max price = ' + CONVERT(varchar(10), @maxPrice);

go
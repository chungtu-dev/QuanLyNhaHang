create database QuanLyQuanCafe
go

use QuanLyQuanCafe
go

--Food
--Table
--FoodCategory
--Account
--Bill
--BillInfo

create table TableFood
(
    id int identity primary key,
    name nvarchar (100) not null default N'chưa đặt tên',
    status nvarchar(100) not null default N'Trống', --trống || có người
)
go

create table Account
(
    UserName nvarchar(100) primary key,
    DisplayName nvarchar(100) not null default N'Kter',    
    Password nvarchar(1000) not null default 0,
    Type int not null default 0, --1:admin, 0:staff
)
go

create table FoodCategory
(
    id int identity primary key,
    name nvarchar (100) not null default N'chưa đặt tên',
)
go

create table Food
(
    id int identity primary key,
    name nvarchar (100) not null default N'chưa đặt tên',
    idCategory int not null,
    price float not null default 0,

    foreign key (idCategory) references FoodCategory(id),
)
go

create table Bill
(
    id int identity primary key,
    DateCheckIn Date not null default getdate(),
    DateCheckOut Date,
    idTable int not null,
    status int not null default 0, --1: đã thanh toán, 0:chưa thanh toán

    foreign key (idTable) references TableFood(id),
)
go

create table BillInfo
(
    id int identity primary key,
    idBill int not null,
    idFood int not null,
    count int not null default 0,

    foreign key (idBill) references Bill(id),
    foreign key (idFood) references Food(id),
)
go
-------------------------------------------------------------------
-------------------------------------------------------------------

alter table Bill 
--add totalPrice float
--add discount int

--update Bill set discount = 0
insert into Account (UserName, DisplayName, Password, Type)
values (N'K9',N'RongK9',N'1',1)

insert into Account (UserName, DisplayName, Password, Type)
values (N'Staff',N'NhanVien',N'1',0)

-------------------------------------------------------------------
-------------------------------------------------------------------

select * from Account
select * from Account where UserName = N'K9' and Password=N'1'

-------------------------------------------------------------------
-------------------------------------------------------------------

--tạo n bàn ăn
-- cast() : ép kiểu
-- @i : số bàn < = 10, số bàn tăng

declare @i int = 0
while @i <= 10
begin
insert TableFood (name) values (N'Bàn ' + cast(@i as nvarchar(100)))
set @i = @i + 1
end

select * from TableFood

-------------------------------------------------------------------
-------------------------------------------------------------------

--thêm category
insert FoodCategory (name) values (N'Hải sản')
insert FoodCategory (name) values (N'Nông sản')
insert FoodCategory (name) values (N'Lâm sản')
insert FoodCategory (name) values (N'Nước')

select * from FoodCategory
-------------------------------------------------------------------
-------------------------------------------------------------------

--thêm món ăn
insert Food (name, idCategory, price) values (N'Mực nướng',1,120000)
insert Food (name, idCategory, price) values (N'Hào nướng',1,130400)
insert Food (name, idCategory, price) values (N'Chân gà nướng',2,34000)
insert Food (name, idCategory, price) values (N'Khô gà lá chanh',2,25000)
insert Food (name, idCategory, price) values (N'Chim cút nướng',3,98000)
insert Food (name, idCategory, price) values (N'Cút xào bơ tỏi',3,409000)
insert Food (name, idCategory, price) values (N'7Up',4,22000)
insert Food (name, idCategory, price) values (N'Coca',4,30000)
insert Food (name, idCategory, price) values (N'Cafe',4,12000)

select * from Food
-------------------------------------------------------------------
-------------------------------------------------------------------

--thêm bill
insert Bill (DateCheckIn, DateCheckOut, idTable, status) values (GETDATE(), null,1,0)
insert Bill (DateCheckIn, DateCheckOut, idTable, status) values (GETDATE(), null,2,0)
insert Bill (DateCheckIn, DateCheckOut, idTable, status) values (GETDATE(), GETDATE(),3,1)

select * from Bill
-------------------------------------------------------------------
-------------------------------------------------------------------

--thêm billInfo
insert BillInfo (idBill, idFood, count) values (28,1,2)
insert BillInfo (idBill, idFood, count) values (28,3,4)
insert BillInfo (idBill, idFood, count) values (29,5,1)
insert BillInfo (idBill, idFood, count) values (29,6,2)
insert BillInfo (idBill, idFood, count) values (30,5,2)
insert BillInfo (idBill, idFood, count) values (30,4,2)

select * from BillInfo
-------------------------------------------------------------------
-------------------------------------------------------------------

select f.name, bi.count, f.price, f.price*bi.count as totalPrice from BillInfo as bi, Bill as b, Food as f
where bi.idBill = b.id and bi.idFood = f.id and b.status = 0 and b.idTable = 3
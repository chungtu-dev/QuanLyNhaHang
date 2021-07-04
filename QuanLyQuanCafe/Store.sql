create proc USP_Login
@userName nvarchar(100), @passWord nvarchar(100)
as
begin
select * from Account where UserName = @userName and Password = @passWord
end
go

-------------------------------------------------------------------
-------------------------------------------------------------------

create proc getAccountByUserName
@userName nvarchar(100)
as
begin
select * from Account where UserName = @userName
end

exec getAccountByUserName @userName = N'K9'
-------------------------------------------------------------------
-------------------------------------------------------------------

create proc USP_GetTableList
as
select * from TableFood
go

exec USP_GetTableList

create proc USP_GetListFood
as
select * from Food
go

exec USP_GetListFood

-------------------------------------------------------------------
-------------------------------------------------------------------

create proc USP_InsertBill
@idTable int
as 
begin
insert Bill (DateCheckIn, DateCheckOut, idTable, status, discount) values (GETDATE(), null, @idTable, 0, 0)
end
go

-------------------------------------------------------------------
-------------------------------------------------------------------

create proc USP_InsertBillInfo
@idBill int,
@idFood int,
@count int
as
begin

--check Bill đã tồn tại
declare @isExitsBillInfo int
declare @foodCount int = 1

select @isExitsBillInfo = id, @foodCount = b.count from BillInfo as b where idBill=@idBill and idFood = @idFood

if(@isExitsBillInfo > 0)
begin
declare @newCount int = @foodCount + @count
if(@newCount > 0)
update BillInfo set count = @foodCount + @count where idFood = @idFood
else
delete BillInfo where idBill = @idBill and idFood = @idFood
end

else
begin
insert BillInfo (idBill, idFood, count) values (@idBill, @idFood, @count)
end
end
go

-------------------------------------------------------------------
-------------------------------------------------------------------

create proc USP_SwitchTable
@idTable1 int, @idTable2 int
as
begin

declare @idFirstBill int
declare @idSecondBill int

declare @isFirstTableEmty int = 1
declare @isSecondTableEmty int = 1

select @idFirstBill = id from Bill where idTable = @idTable1 and status = 0
select @idSecondBill = id from Bill where idTable = @idTable2 and status = 0

--First
if(@idFirstBill is null)
begin
insert Bill(DateCheckIn, DateCheckOut, idTable, status) values (GETDATE(), null, @idTable1, 0)
select @idFirstBill = MAX(id) from Bill where idTable = @idTable1 and status = 0
end

select @isFirstTableEmty = COUNT(*) from BillInfo where idBill = @idFirstBill

--Second
if(@idSecondBill is null)
begin
insert Bill(DateCheckIn, DateCheckOut, idTable, status) values (GETDATE(), null, @idTable2, 0)
select @idSecondBill = MAX(id) from Bill where idTable = @idTable2 and status = 0
end

select @isSecondTableEmty = COUNT(*) from BillInfo where idBill = @idSecondBill

select id into IDBillIntoTable from BillInfo where idBill = @idSecondBill

update BillInfo set idBill = @idSecondBill where idBill = @idFirstBill

update BillInfo set idBill = @idFirstBill where id in (select * from IDBillIntoTable)

drop table IDBillIntoTable

if(@isFirstTableEmty = 0)
update TableFood set status = N'Trống' where id = @idTable2

if(@isSecondTableEmty = 0)
update TableFood set status = N'Trống' where id = @idTable1
end
go

-------------------------------------------------------------------
-------------------------------------------------------------------

create proc USP_GetListBillByDate
@checkIn date,
@checkOut date
as
begin
select t.name as [Tên bàn], b.totalPrice as [Tổng tiền], DateCheckIn as [Ngày vào], DateCheckOut as [Ngày ra], discount as [Giảm giá]
from Bill as b, TableFood as t, BillInfo as bi, Food as f
where DateCheckIn >=@checkIn and DateCheckOut <=@checkOut and b.status = 1
and t.id = b.idTable and bi.idBill = b.id and bi.idFood = f.id
end
go

-------------------------------------------------------------------
-------------------------------------------------------------------

create proc USP_UpdateAccount
@userName nvarchar(100), 
@displayName nvarchar(100),
@passWord nvarchar(100),
@newpassWord nvarchar(100)
as
begin
    declare @isRightPass int = 0
    select @isRightPass = COUNT(*) from Account where UserName = @userName and Password = @passWord
        if(@isRightPass = 1)
        begin
            if(@newpassWord = null or @newpassWord = '')
            begin
                update Account set DisplayName = @displayName where UserName = @userName
            end
            else 
                update Account set DisplayName = @displayName, Password = @newpassWord where UserName = @userName
        end
end
go

-------------------------------------------------------------------
-------------------------------------------------------------------

create proc USP_GetListBillByDateAndPage
@checkIn date,
@checkOut date,
@page int
as
begin

declare @pageRows int = 10
declare @selectRows int = @pageRows
declare @exceptRows int = (@page - 1) * @pageRows

;with BillShow as ( select b.id, t.name as [Tên bàn], b.totalPrice as [Tổng tiền], DateCheckIn as [Ngày vào], DateCheckOut as [Ngày ra], discount as [Giảm giá]
from Bill as b, TableFood as t, BillInfo as bi, Food as f
where DateCheckIn >=@checkIn and DateCheckOut <=@checkOut and b.status = 1
and t.id = b.idTable and bi.idBill = b.id and bi.idFood = f.id )

select top (@selectRows) * from BillShow where id not in (select top (@exceptRows) id from BillShow)

end
go

-------------------------------------------------------------------
-------------------------------------------------------------------

create proc USP_GetNumBillByDate
@checkIn date,
@checkOut date
as
begin
select COUNT(*)
from Bill as b, TableFood as t, BillInfo as bi, Food as f
where DateCheckIn >=@checkIn and DateCheckOut <=@checkOut and b.status = 1
and t.id = b.idTable and bi.idBill = b.id and bi.idFood = f.id
end
go

-------------------------------------------------------------------
-------------------------------------------------------------------

select * from Food
select * from FoodCategory
select * from BillInfo

alter proc DelCategory
@idFood int,
@idCate int,
@idBillinfo int
as
begin
declare 
 delete from Food where idCategory = @idCate
 delete from BillInfo where idFood = @idCate
 delete from FoodCategory where id = @idCate
end
go
exec DelCategory @idCate = 1005

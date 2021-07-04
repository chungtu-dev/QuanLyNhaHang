create trigger UTG_UpdateBillInfo
on BillInfo for Insert, Update
as 
begin
declare @idBill int

select @idBill = idBill from inserted

declare @idTable int

select @idTable = idTable from Bill where id = @idBill and status = 0

declare @count int
select @count = COUNT(*) from BillInfo where idBill = @idBill

if(@count > 0)
update TableFood set status = N'Có người' where id = @idTable
else
update TableFood set status = N'Trống' where id = @idTable
end
go

------------------------------------------------------------------
------------------------------------------------------------------

create trigger UTG_UpdateBill
on Bill for update
as
begin
declare @idBill int

select @idBill = id from inserted

declare @idTable int

select @idTable = idTable from Bill where id = @idBill

declare @count int = 0

select @count = COUNT(*) from Bill where idTable = @idTable and status = 0

if(@count = 0)
update TableFood set status = N'Trống' where id = @idTable
end
go

------------------------------------------------------------------
------------------------------------------------------------------

create trigger UTG_DeleteBillInfo
on BillInfo for delete
as
begin
 declare @idBillInfo int
 declare @idBill int
 select @idBillInfo = id, @idBill = deleted.idBill from deleted
 
 declare @idTable int
 select @idTable = idTable from Bill where id = @idBill

 declare @count int = 0
 select @count = COUNT(*) from BillInfo as bi, Bill as b where b.id = bi.idBill and b.id = @idBill and b.status = 0

 if(@count = 0)
    update TableFood set status = N'Trống' where id = @idTable
end
go
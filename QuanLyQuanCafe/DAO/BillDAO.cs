using QuanLyQuanCafe.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuanLyQuanCafe.DAO
{
    // lấy ra cái Bill từ id Table (mỗi table có 1 bill)
    public class BillDAO
    {
        private static BillDAO instane;

        public static BillDAO Instane 
        {
            get { if (instane == null) instane = new BillDAO(); return BillDAO.instane;  } 
            private set => BillDAO.instane = value; 
        }
        private BillDAO() { }

        //thành công => trả về bill ID
        //thất bại => trả về -1
        public int GetUnCheckBillIDByTableID(int id)
        {
            DataTable data = DataProvider.Instance.ExecuteQuery("select * from Bill where idTable = " + id + " and status = 0");

            if(data.Rows.Count > 0)
            {
                Bill bill = new Bill(data.Rows[0]);
                return bill.ID;
            }
            return -1; //trả về ko có gì
        }

        public void CheckOut(int id, int discount, float totalPrice)
        {
            string query = "update Bill set DateCheckOut =  GETDATE(), status = 1, " + "discount = " +  discount + ", totalPrice = " + totalPrice + " where id = " + id;
            DataProvider.Instance.ExecuteNonQuery(query);
        }

        public void InsertBill(int id)
        {
            DataProvider.Instance.ExecuteNonQuery("exec USP_InsertBill @idTable", new object[] { id });
        }

        public DataTable GetBillListByDate(DateTime checkIn, DateTime checkOut)
        {
            return DataProvider.Instance.ExecuteQuery("exec USP_GetListBillByDate @checkIn , @checkOut", new object[] { checkIn, checkOut });
        }

        public DataTable GetBillListByDateAndPage(DateTime checkIn, DateTime checkOut, int pageNum)
        {
            return DataProvider.Instance.ExecuteQuery("exec USP_GetListBillByDateAndPage @checkIn , @checkOut , @page", new object[] { checkIn, checkOut, pageNum });
        }

        public int GetNumBillListByDate(DateTime checkIn, DateTime checkOut)
        {
            return (int)DataProvider.Instance.ExecuteScalar("exec USP_GetNumBillByDate @checkIn , @checkOut", new object[] { checkIn, checkOut });
        }

        public int GetMaxIDBill()
        {
            try
            {
                return (int)DataProvider.Instance.ExecuteScalar("select MAX(id) from Bill");
            }
            catch
            {
                return 1;
            }
        }
    }
}
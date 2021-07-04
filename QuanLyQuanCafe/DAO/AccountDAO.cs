using QuanLyQuanCafe.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace QuanLyQuanCafe.DAO
{
    public class AccountDAO
    {
        private static AccountDAO instance;

        public static AccountDAO Instance 
        {
            get { if (instance == null) instance = new AccountDAO(); return AccountDAO.instance; }
            private set => AccountDAO.instance = value; 
        }

        private AccountDAO() { }

        public bool Login (string userName, string passWord)
        {
            byte[] temp = ASCIIEncoding.ASCII.GetBytes(passWord);
            byte[] hasData = new MD5CryptoServiceProvider().ComputeHash(temp);

            string hasPass = "";

            foreach(byte item in hasData)
            {
                hasPass += item;
            }

            string query = "USP_Login @userName , @passWord";
            DataTable result = DataProvider.Instance.ExecuteQuery(query, new object[] {userName, hasPass});
            return result.Rows.Count > 0;
        }

        public bool UpdateAccount(string userName, string displayName, string pass, string newPass)
        {
            int result  = DataProvider.Instance.ExecuteNonQuery("exec USP_UpdateAccount @userName , @displayName , @passWord , @newpassWord ", new object[] { userName, displayName, pass, newPass});
            return result  > 0;
        }

        public DataTable GetListAccount()
        {
            string query = "select UserName, DisplayName, Type from Account ";
            return DataProvider.Instance.ExecuteQuery(query);
        }

        public Account GetAccountByUserName(string userName)
        {
            DataTable data =  DataProvider.Instance.ExecuteQuery("select * from Account where userName = '" + userName + "'");
            foreach(DataRow item in data.Rows)
            {
                return new Account(item);
            }
            return null;
        }

        public bool InsertAccount(string name, string displayName, int type)
        {
            // 1962026656160185351301320480154111117132155 = 1
            string query = string.Format("insert Account (UserName , DisplayName , Type, Password) values ( N'{0}' , N'{1}' , {2} , {3} )", name, displayName, type, "1962026656160185351301320480154111117132155");
            int result = DataProvider.Instance.ExecuteNonQuery(query);

            return result > 0;
        }

        public bool UpdateAccount(string name, string displayName, int type)
        {
            string query = string.Format("update Account set DisplayName = N'{1}' , Type = {2} where UserName = N'{0}' ", name, displayName, type);
            int result = DataProvider.Instance.ExecuteNonQuery(query);
            return result > 0;
        }

        public bool DeleteAccount(string name)
        {
            string query = string.Format("Delete Account where UserName = N'{0}' ", name);
            int result = DataProvider.Instance.ExecuteNonQuery(query);
            return result > 0;
        }

        public bool ResetPassword(string name)
        {
            // 1962026656160185351301320480154111117132155 = 1
            string query = string.Format("Update Account set Password = N'1962026656160185351301320480154111117132155' where UserName = N'{0}' ", name);
            int result = DataProvider.Instance.ExecuteNonQuery(query);
            return result > 0;
        }
    }
}

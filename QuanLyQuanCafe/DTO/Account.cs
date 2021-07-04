using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuanLyQuanCafe.DTO
{
    public class Account
    {
        public Account(string userName, string displayName, int type, string passWord)
        {
            this.UserName = userName;
            this.DisplayName = displayName;
            this.Type = type;
            this.PassWord = passWord;
        }

        public Account(DataRow row)
        {
            this.UserName = row["userName"].ToString();
            this.DisplayName = row["displayName"].ToString();
            this.Type = (int)row["type"];
            this.PassWord = row["passWord"].ToString();
        }

        private int type;
        public int Type { get => type; set => type = value; }

        private string passWord;
        public string PassWord { get => passWord; set => passWord = value; }

        private string displayName;
        public string DisplayName { get => displayName; set => displayName = value; }

        private string userName;
        public string UserName { get => userName; set => userName = value; }        
    }
}

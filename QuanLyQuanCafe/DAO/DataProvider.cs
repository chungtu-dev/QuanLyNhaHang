using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuanLyQuanCafe.DAO
{
    public class DataProvider
    {
        private static DataProvider instance; //đóng gói Ctrl + R + E

        public static DataProvider Instance 
        {
            get {if (instance == null) instance = new DataProvider(); return DataProvider.instance; }
            private set { DataProvider.instance = value; } 
        }

        private DataProvider() { }

        private string ConnStr = @"Data Source=DESKTOP-I5I7HDF;Initial Catalog=QuanLyQuanCafe;Integrated Security=True";        

        //Thực hiện truy vấn và lấy dữ liệu
        //(Trả ra những dòng kết quả)
        public DataTable ExecuteQuery(string query, object[] parameter = null)
        {
            DataTable data = new DataTable();// đổ ra data vào Datatable

            using (SqlConnection connection = new SqlConnection(ConnStr)) // khi kết thúc khối lệnh trong {} rồi thì khai báo () sẽ tự được giải phóng bộ nhớ
            {
                connection.Open();
                SqlCommand command = new SqlCommand(query, connection); //thực thi truy vấn trên kết nối connection                

                if (parameter != null)
                {
                    string[] listPara = query.Split(' ');
                    int i = 0; 
                    foreach(string item in listPara)
                    {
                        if (item.Contains('@'))
                        {
                            command.Parameters.AddWithValue(item, parameter[i]);
                            i++;
                        }
                    }
                }

                SqlDataAdapter adapter = new SqlDataAdapter(command); //trung gian thực hiện truy vấn lấy dữ liệu
                adapter.Fill(data);//đổ dữ liệu vào data (dataTable)
                connection.Close();
            }
            return data;
        }

        //trả ra số dòng thành công
        //khi thao tác Del hoặc Upd sẽ trả ra số dòng thành công, không trả về toàn bộ DataTable nặng máy
        // (dùng thực hiện lệnh Ins, Upd, Del, trả ra số dòng được thực thi)
        public int ExecuteNonQuery(string query, object[] parameter = null)
        {
            int data = 0;

            using (SqlConnection connection = new SqlConnection(ConnStr)) // khi kết thúc khối lệnh trong {} rồi thì khai báo () sẽ tự được giải phóng bộ nhớ
            {
                connection.Open();
                SqlCommand command = new SqlCommand(query, connection); //thực thi truy vấn trên kết nối connection                

                if (parameter != null)
                {
                    string[] listPara = query.Split(' ');
                    int i = 0;
                    foreach (string item in listPara)
                    {
                        if (item.Contains('@'))
                        {
                            command.Parameters.AddWithValue(item, parameter[i]);
                            i++;
                        }
                    }
                }
                data = command.ExecuteNonQuery();
                connection.Close();
            }
            return data;
        }

        //Đếm số lượng
        //lấy số lượng được trả ra
        //trả ra kiểu select count * ....
        public object ExecuteScalar(string query, object[] parameter = null)
        {
            object data = 0;

            using (SqlConnection connection = new SqlConnection(ConnStr)) // khi kết thúc khối lệnh trong {} rồi thì khai báo () sẽ tự được giải phóng bộ nhớ
            {
                connection.Open();
                SqlCommand command = new SqlCommand(query, connection); //thực thi truy vấn trên kết nối connection                

                if (parameter != null)
                {
                    string[] listPara = query.Split(' ');
                    int i = 0;
                    foreach (string item in listPara)
                    {
                        if (item.Contains('@'))
                        {
                            command.Parameters.AddWithValue(item, parameter[i]);
                            i++;
                        }
                    }
                }
                data = command.ExecuteScalar(); //select count * ...
                connection.Close();
            }
            return data;
        }
    }
}

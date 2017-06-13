using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System;

namespace SQLRunner
{
    public class ScriptRunner
    {
        public SqlConnection GetConnection(string connectionString)
        {
            SqlConnection connection = new SqlConnection(connectionString);
            return connection;
        }

        public List<SqlConnection> GetConnections(List<string> connectionStrings)
        {
            List<SqlConnection> connections = new List<SqlConnection>();
            foreach (string s in connectionStrings)
            {
                SqlConnection current = new SqlConnection(s);
                connections.Add(current);
            }
            return connections;
        }
        
        public static List<string> GetCommandStrings(string file)
        {
            string script = File.ReadAllText(file);
            var results = script.Split(new string[] { @"/** TEST **/" },StringSplitOptions.RemoveEmptyEntries);
            //var results = Regex.Split(script, @"--Test Start$",
            //              RegexOptions.Singleline | RegexOptions.IgnoreCase).ToList();
            List<string> commands = new List<string>();
            foreach (string s in results)
            {
                if (s.Contains("select") && s.Contains("from"))
                {
                    commands.Add(s);
                }
            }
            return commands;
        }

        public static string ExecuteCommand(SqlConnection connection,string command)
        {
            string outcome;
            using (SqlCommand cmd = new SqlCommand(command, connection))
            {
                cmd.CommandTimeout = 600;
                connection.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                if (rdr.Read())
                {
                    outcome = rdr[0].ToString();
                }
                else
                {
                    outcome = "NULL";
                }
                connection.Close();
                return outcome;
            }
        }
    }
}

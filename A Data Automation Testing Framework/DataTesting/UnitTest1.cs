using System;
using System.IO;
using System.Configuration;
using SQLRunner;
using System.Data.SqlClient;
using System.Collections.Generic;
using NUnit.Framework;

namespace DataTesting
{
    [SetUpFixture]
    public class MyFactory
    {
        public static List<string> Commands = new List<string>();
        public static string[] Array;
        public static string[] Values
        {
            get {
                string dir = @"..\..\..\TestData\";
                DirectoryInfo folder = new DirectoryInfo(dir);
                FileInfo[] files = folder.GetFiles();
                foreach (FileInfo file in files)
                {
                    Commands.AddRange(ScriptRunner.GetCommandStrings(@"..\..\..\TestData\" + file));
                }
                Array = Commands.ToArray();
                return Array;
            }
        }
    }

    [TestFixture]
    public class UnitTest1
    {
        [Test, TestCaseSource(typeof(MyFactory), "Values")]
        public void TestMethod1(string testValue)
        {
            string ConnectionString = ConfigurationSettings.AppSettings["ConnectionString"];
            SqlConnection conn = new SqlConnection(ConnectionString);
            string outcome = ScriptRunner.ExecuteCommand(conn, testValue);
            Assert.AreEqual("PASS", outcome);
        }

    }
}

using System.Collections.Generic;
using System.Data;
using System.Data.Odbc;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using LogImporter.Properties;

namespace LogImporter
{
    class Program
    {
        static void Main(string[] args)
        {
            var files = DiscoverFiles();
            ImportFiles(files);
        }

        /// <summary>
        /// Enumerates CSV files in the current directory.
        /// </summary>
        private static IEnumerable<string> DiscoverFiles()
        {
            return Directory.EnumerateFiles(".", "*.csv").Select(f => Path.GetFileName(f));
        }

        /// <summary>
        /// Imports an enumerable list of files into staging, and merges them with the current data.
        /// </summary>
        private static void ImportFiles(IEnumerable<string> csvFiles)
        {
            using (var connection = new SqlConnection(Settings.Default.WebLogs))
            {
                connection.Open();
                using (var transaction = connection.BeginTransaction())
                {
                    ImportFiles(csvFiles, transaction);
                    transaction.Commit();
                }
            }
        }

        /// <summary>
        /// Imports an enumerable list of files into staging, and merges them with the current data.
        /// </summary>
        /// <remarks>
        /// All operations against the database are performed in the given transaction.
        /// </remarks>
        private static void ImportFiles(IEnumerable<string> csvFiles, SqlTransaction transaction)
        {
            InitializeStagingTable(transaction);

            foreach (var csvFile in csvFiles)
            {
                ImportFile(csvFile, transaction);
            }

            ExecuteStatement(transaction, Resources.MergeFromStaging);
        }

        /// <summary>
        /// Creates the staging table.
        /// </summary>
        private static void InitializeStagingTable(SqlTransaction transaction)
        {
            ExecuteStatement(transaction, Resources.CreateStagingTable);
        }

        /// <summary>
        /// Executes a SQL statement against a transaction.
        /// </summary>
        private static void ExecuteStatement(SqlTransaction transaction, string sql)
        {
            using (var command = new SqlCommand(sql))
            {
                command.Connection = transaction.Connection;
                command.Transaction = transaction;
                command.ExecuteNonQuery();
            }
        }

        /// <summary>
        /// Imports a single file into staging.
        /// </summary>
        private static void ImportFile(string csvFile, SqlTransaction transaction)
        {
            var statement = string.Format("select * from \"{0}\"", csvFile);

            using (var connection = new OdbcConnection(Settings.Default.ImportDriver))
            {
                connection.Open();

                using (var command = connection.CreateCommand())
                {
                    command.CommandText = statement;

                    using (var reader = command.ExecuteReader())
                    {
                        BulkImport(reader, transaction);
                    }
                }
            }
        }

        /// <summary>
        /// Streams data in from the data reader, and pushes it out the transaction using the SqlBulkCopy API.
        /// </summary>
        private static void BulkImport(IDataReader reader, SqlTransaction transaction)
        {
            using (var importer = new SqlBulkCopy(transaction.Connection, SqlBulkCopyOptions.Default, transaction))
            {
                for (int field = 0; field < reader.FieldCount; field++)
                {
                    var name = reader.GetName(field);
                    importer.ColumnMappings.Add(name, name);
                }

                importer.DestinationTableName = "#w3clog_staging";
                importer.WriteToServer(reader);
            }
        }
    }
}

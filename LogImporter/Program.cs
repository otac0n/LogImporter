using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace LogImporter
{
    class Program
    {
        static void Main(string[] args)
        {
            var files = DiscoverFiles();
        }

        /// <summary>
        /// Enumerates CSV files in the current directory.
        /// </summary>
        private static IEnumerable<string> DiscoverFiles()
        {
            return Directory.EnumerateFiles("*.csv").Select(f => Path.GetFileName(f));
        }
    }
}

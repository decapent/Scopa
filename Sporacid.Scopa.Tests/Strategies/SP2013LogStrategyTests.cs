using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.IO;

namespace Sporacid.Scopa.Tests.Strategies
{
    [TestClass]
    public class SP2013LogStrategyTests
    {
        private const int NB_FILES_UNDERTEST = 20;
        private TestContext testContextInstance;

        /// <summary>
        /// Gets or sets the test context which provides
        /// information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext
        {
            get
            {
                return testContextInstance;
            }
            set
            {
                testContextInstance = value;
            }
        }

        #region Setup & Tear Down
        [ClassInitialize()]
        public static void MyClassInitialize(TestContext testContext) 
        {
            /*
            if (!Directory.Exists(testStaging))
            {
                Directory.CreateDirectory(testStaging);
            }*/
        }

        [ClassCleanup()]
        public static void MyClassCleanup() { }
        

        [TestInitialize()]
        public void MyTestInitialize() 
        {
            for (int i = 0; i < NB_FILES_UNDERTEST; i++)
            {
                var filePath = Path.Combine(testStaging, string.Format("SP2013LogStrategyTest{0}.log", i));
                var streamWriter = File.CreateText(filePath);
                streamWriter.WriteLine("SP2013LogStrategy.TestInitialize -> " + i);
                streamWriter.Dispose();
            }
        }

        [TestCleanup()]
        public void MyTestCleanup() 
        { 
        
        }
        #endregion

        #region Test Methods
        [TestMethod]
        [TestCategory("LogStrategy")]
        public void WhenStagingSP2013Logs_NumberOfFiles_ShouldBeEqual()
        {

        }

        [TestMethod]
        [TestCategory("LogStrategy")]
        public void WhenStagingSP2013Logs_NumberOfHDFSIndexes_ShouldBeTwo()
        {

        }
        #endregion
    }
}

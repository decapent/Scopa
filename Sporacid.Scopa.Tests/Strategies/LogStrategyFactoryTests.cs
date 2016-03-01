using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Sporacid.Scopa.Contracts;
using Sporacid.Scopa.Entities;
using Sporacid.Scopa.Strategies;

namespace Sporacid.Scopa.Tests.Strategies
{
    /// <summary>
    /// Test class for the LogStrategy Factory class
    /// </summary>
    [TestClass]
    public class LogStrategyFactoryTests
    {
        public const string DESTINATION_PATH = @"C:\Processed\Test";

        /// <summary>
        /// Tests that a SharePoint 2013 logging strategy is created fully hydrated
        /// </summary>
        [TestMethod]
        [TestCategory("Factory")]
        public void WhenCreatingSP2013Strategy_WithDataSourcePath_ShouldCreateStrategyFullyHydrated()
        {
            // Arrange
            BaseLogStrategy strategy = null;
            string dataSourcePath = "SP2013_Logs";

            // Act
            strategy = LogStrategyFactory.CreateStrategy(LogTypes.SP2013, dataSourcePath, DESTINATION_PATH);

            // Asssert
            Assert.IsNotNull(strategy);
            Assert.IsInstanceOfType(strategy, typeof(SP2013LogStrategy));

            Assert.IsNotNull(strategy.LogArchive);
            Assert.IsInstanceOfType(strategy.LogArchive, typeof(SP2013LogArchive));

            Assert.AreEqual<string>(dataSourcePath, strategy.LogArchive.DataSourcePath);
        }

        /// <summary>
        /// Tests that a SharePoint 2013 logging strategy cannot be created without a proper data source path
        /// </summary>
        [TestMethod]
        [TestCategory("Factory")]
        public void WhenCreatingSP2013Strategy_WithoutDataSourcePath_ShouldNotCreateStrategy()
        {
            // Arrange
            BaseLogStrategy strategy = null;

            // Act
            strategy = LogStrategyFactory.CreateStrategy(LogTypes.SP2013, string.Empty, DESTINATION_PATH);

            // Assert
            Assert.IsNull(strategy);
        }

        /// <summary>
        /// Tests that an IIS logging strategy is created fully hydrated
        /// </summary>
        [TestMethod]
        [TestCategory("Factory")]
        public void WhenCreatingIISStrategy_WithDataSourcePath_ShouldCreateStrategyFullyHydrated()
        {
            // Arrange
            BaseLogStrategy strategy = null;
            string dataSourcePath = "IIS_Logs";

            // Act
            strategy = LogStrategyFactory.CreateStrategy(LogTypes.IIS, dataSourcePath, DESTINATION_PATH);

            // Asssert
            Assert.IsNotNull(strategy);
            Assert.IsInstanceOfType(strategy, typeof(IISLogStrategy));

            Assert.IsNotNull(strategy.LogArchive);
            Assert.IsInstanceOfType(strategy.LogArchive, typeof(IISLogArchive));

            Assert.AreEqual<string>(dataSourcePath, strategy.LogArchive.DataSourcePath);
        }

        /// <summary>
        /// Tests that an IIS logging strategy cannot be created without a proper data source path
        /// </summary>
        [TestMethod]
        [TestCategory("Factory")]
        public void WhenCreatingIISStrategy_WithoutDataSourcePath_ShouldNotCreateStrategy()
        {
            // Arrange
            BaseLogStrategy strategy = null;

            // Act
            strategy = LogStrategyFactory.CreateStrategy(LogTypes.IIS, string.Empty, DESTINATION_PATH);

            // Assert
            Assert.IsNull(strategy);
        }
    }
}

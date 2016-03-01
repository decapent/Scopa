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
        public const string DATASOURCE_PATH = @"C:\Raw\Test";
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

            // Act
            strategy = LogStrategyFactory.CreateStrategy(LogTypes.SP2013, DATASOURCE_PATH, DESTINATION_PATH);

            // Asssert
            Assert.IsNotNull(strategy);
            Assert.IsInstanceOfType(strategy, typeof(SP2013LogStrategy));

            Assert.IsNotNull(strategy.LogArchive);
            Assert.IsInstanceOfType(strategy.LogArchive, typeof(SP2013LogArchive));

            Assert.AreEqual<string>(DATASOURCE_PATH, strategy.LogArchive.DataSourcePath);
            Assert.AreEqual<string>(DESTINATION_PATH, strategy.DestinationPath);
        }

        /// <summary>
        /// Tests that a SharePoint 2013 logging strategy cannot be created without a proper data source path
        /// </summary>
        [TestMethod]
        [TestCategory("Factory")]
        [ExpectedException(typeof(ArgumentNullException))]
        public void WhenCreatingSP2013Strategy_WithEmptyDataSourcePath_ShouldThrowArgumentNullException()
        {
            // Arrange
            BaseLogStrategy strategy = null;

            // Act
            strategy = LogStrategyFactory.CreateStrategy(LogTypes.SP2013, string.Empty, DESTINATION_PATH);
        }


        /// <summary>
        /// Tests that a SharePoint 2013 logging strategy cannot be created without a proper data source path
        /// </summary>
        [TestMethod]
        [TestCategory("Factory")]
        [ExpectedException(typeof(ArgumentNullException))]
        public void WhenCreatingSP2013Strategy_WithEmptyDestinationPath_ShouldThrowArgumentNullException()
        {
            // Arrange
            BaseLogStrategy strategy = null;

            // Act
            strategy = LogStrategyFactory.CreateStrategy(LogTypes.SP2013, DATASOURCE_PATH, string.Empty);
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

            // Act
            strategy = LogStrategyFactory.CreateStrategy(LogTypes.IIS, DATASOURCE_PATH, DESTINATION_PATH);

            // Asssert
            Assert.IsNotNull(strategy);
            Assert.IsInstanceOfType(strategy, typeof(IISLogStrategy));

            Assert.IsNotNull(strategy.LogArchive);
            Assert.IsInstanceOfType(strategy.LogArchive, typeof(IISLogArchive));

            Assert.AreEqual<string>(DATASOURCE_PATH, strategy.LogArchive.DataSourcePath);
            Assert.AreEqual<string>(DESTINATION_PATH, strategy.DestinationPath);
        }

        /// <summary>
        /// Tests that an IIS logging strategy cannot be created without a proper data source path
        /// </summary>
        [TestMethod]
        [TestCategory("Factory")]
        [ExpectedException(typeof(ArgumentNullException))]
        public void WhenCreatingIISStrategy_WithoutDataSourcePath_ShouldThrowArgumentNullException()
        {
            // Arrange
            BaseLogStrategy strategy = null;

            // Act
            strategy = LogStrategyFactory.CreateStrategy(LogTypes.IIS, string.Empty, DESTINATION_PATH);
        }

        /// <summary>
        /// Tests that an IIS logging strategy cannot be created without a proper data source path
        /// </summary>
        [TestMethod]
        [TestCategory("Factory")]
        [ExpectedException(typeof(ArgumentNullException))]
        public void WhenCreatingIISStrategy_WithoutDestinationPath_ShouldThrowArgumentNullException()
        {
            // Arrange
            BaseLogStrategy strategy = null;

            // Act
            strategy = LogStrategyFactory.CreateStrategy(LogTypes.IIS, DATASOURCE_PATH, string.Empty);
        }
    }
}

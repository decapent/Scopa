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
        /// <summary>
        /// Tests that a SharePoint 2013 logging strategy cant be created without a DataSourcePath
        /// </summary>
        [TestMethod]
        [TestCategory("Strategies")]
        public void WhenCreatingSharePoint2013Strategy_WithoutDataSourcePath_ShouldNotCreateStrategy()
        {
            // Arrange
            ILogStrategy strategy = null;

            // Act
            strategy = LogStrategyFactory.CreateStrategy(LogTypes.SharePoint2013, "SP2013_Logs");

            // Asssert
            Assert.IsNotNull(strategy);
            Assert.IsInstanceOfType(strategy, SP2013LogStrategy);
        }
    }
}

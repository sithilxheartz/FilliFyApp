-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.32-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for fillingstationdb
CREATE DATABASE IF NOT EXISTS `fillingstationdb` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `fillingstationdb`;

-- Dumping structure for table fillingstationdb.fuelavailability
CREATE TABLE IF NOT EXISTS `fuelavailability` (
  `stockID` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT current_timestamp(),
  `liters_in_tank_1` float NOT NULL,
  `liters_in_tank_2` float NOT NULL,
  `liters_in_tank_3` float NOT NULL,
  `liters_in_tank_4` float NOT NULL,
  `liters_in_tank_5` float NOT NULL,
  `liters_in_tank_6` float NOT NULL,
  PRIMARY KEY (`stockID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table fillingstationdb.fuelavailability: ~0 rows (approximately)

-- Dumping structure for table fillingstationdb.fuelstock
CREATE TABLE IF NOT EXISTS `fuelstock` (
  `stockID` int(11) NOT NULL AUTO_INCREMENT,
  `fuelType` varchar(50) NOT NULL,
  `quantity` int(11) NOT NULL,
  PRIMARY KEY (`stockID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table fillingstationdb.fuelstock: ~0 rows (approximately)

-- Dumping structure for table fillingstationdb.fueltank
CREATE TABLE IF NOT EXISTS `fueltank` (
  `tankID` int(11) NOT NULL,
  `fueltype` varchar(100) NOT NULL,
  `capacity` int(11) NOT NULL,
  PRIMARY KEY (`tankID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table fillingstationdb.fueltank: ~6 rows (approximately)
INSERT IGNORE INTO `fueltank` (`tankID`, `fueltype`, `capacity`) VALUES
	(1, 'Auto Diesel', 13000),
	(2, 'Auto Diesel', 13000),
	(3, 'Super Diesel', 13000),
	(4, 'Octane 92 Petrol', 13000),
	(5, 'Octane 92 Petrol', 13000),
	(6, 'Octane 95 Petrol', 13000);

-- Dumping structure for table fillingstationdb.inventory
CREATE TABLE IF NOT EXISTS `inventory` (
  `productID` int(11) NOT NULL AUTO_INCREMENT,
  `productName` varchar(100) NOT NULL,
  `stockQuantity` int(11) NOT NULL,
  `speedType` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`productID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table fillingstationdb.inventory: ~0 rows (approximately)

-- Dumping structure for table fillingstationdb.orderdetails
CREATE TABLE IF NOT EXISTS `orderdetails` (
  `orderDetailID` int(11) NOT NULL AUTO_INCREMENT,
  `orderID` int(11) DEFAULT NULL,
  `productID` int(11) DEFAULT NULL,
  `orderQuantity` int(11) NOT NULL,
  PRIMARY KEY (`orderDetailID`),
  KEY `orderID` (`orderID`),
  KEY `productID` (`productID`),
  CONSTRAINT `orderdetails_ibfk_1` FOREIGN KEY (`orderID`) REFERENCES `orders` (`orderID`) ON DELETE CASCADE,
  CONSTRAINT `orderdetails_ibfk_2` FOREIGN KEY (`productID`) REFERENCES `inventory` (`productID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table fillingstationdb.orderdetails: ~0 rows (approximately)

-- Dumping structure for table fillingstationdb.orders
CREATE TABLE IF NOT EXISTS `orders` (
  `orderID` int(11) NOT NULL AUTO_INCREMENT,
  `userID` int(11) DEFAULT NULL,
  `totalAmount` decimal(10,2) NOT NULL,
  `paymentID` int(11) DEFAULT NULL,
  PRIMARY KEY (`orderID`),
  KEY `userID` (`userID`),
  KEY `paymentID` (`paymentID`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `users` (`userID`),
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`paymentID`) REFERENCES `payment` (`paymentID`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table fillingstationdb.orders: ~0 rows (approximately)

-- Dumping structure for table fillingstationdb.payment
CREATE TABLE IF NOT EXISTS `payment` (
  `paymentID` int(11) NOT NULL AUTO_INCREMENT,
  `paymentMethod` varchar(50) NOT NULL,
  PRIMARY KEY (`paymentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table fillingstationdb.payment: ~0 rows (approximately)

-- Dumping structure for table fillingstationdb.pump
CREATE TABLE IF NOT EXISTS `pump` (
  `pumpID` int(11) NOT NULL AUTO_INCREMENT,
  `fuelTankID` int(11) NOT NULL,
  `fuelStockID` int(11) NOT NULL,
  `shiftID` int(11) NOT NULL,
  PRIMARY KEY (`pumpID`),
  KEY `fuelTankID` (`fuelTankID`),
  KEY `shiftID` (`shiftID`),
  CONSTRAINT `pump_ibfk_1` FOREIGN KEY (`fuelTankID`) REFERENCES `fueltank` (`tankID`),
  CONSTRAINT `pump_ibfk_2` FOREIGN KEY (`shiftID`) REFERENCES `shifthistory` (`shiftID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table fillingstationdb.pump: ~0 rows (approximately)

-- Dumping structure for table fillingstationdb.request
CREATE TABLE IF NOT EXISTS `request` (
  `requestID` int(11) NOT NULL AUTO_INCREMENT,
  `fuelStockID` int(11) DEFAULT NULL,
  `shiftID` int(11) DEFAULT NULL,
  PRIMARY KEY (`requestID`),
  KEY `fuelStockID` (`fuelStockID`),
  KEY `shiftID` (`shiftID`),
  CONSTRAINT `request_ibfk_1` FOREIGN KEY (`fuelStockID`) REFERENCES `fuelstock` (`stockID`),
  CONSTRAINT `request_ibfk_2` FOREIGN KEY (`shiftID`) REFERENCES `shift` (`shiftID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table fillingstationdb.request: ~0 rows (approximately)

-- Dumping structure for table fillingstationdb.shift
CREATE TABLE IF NOT EXISTS `shift` (
  `shiftID` int(11) NOT NULL AUTO_INCREMENT,
  `nightShift` tinyint(1) NOT NULL,
  `shiftType` enum('Diesel_Pumper','Petrol_Pumper','Other') DEFAULT NULL,
  PRIMARY KEY (`shiftID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table fillingstationdb.shift: ~0 rows (approximately)

-- Dumping structure for table fillingstationdb.shifthistory
CREATE TABLE IF NOT EXISTS `shifthistory` (
  `shiftID` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT current_timestamp(),
  `day_pumper_pump_1` varchar(255) NOT NULL,
  `day_pumper_pump_2` varchar(255) NOT NULL,
  `day_pumper_pump_3` varchar(255) NOT NULL,
  `day_pumper_pump_4` varchar(255) NOT NULL,
  `night_pumper_pump_1` varchar(255) NOT NULL,
  `night_pumper_pump_2` varchar(255) NOT NULL,
  PRIMARY KEY (`shiftID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table fillingstationdb.shifthistory: ~0 rows (approximately)

-- Dumping structure for table fillingstationdb.users
CREATE TABLE IF NOT EXISTS `users` (
  `userID` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','user') NOT NULL DEFAULT 'user',
  PRIMARY KEY (`userID`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table fillingstationdb.users: ~0 rows (approximately)
INSERT IGNORE INTO `users` (`userID`, `name`, `email`, `password`, `role`) VALUES
	(1, 'asd', 'asd@gmail.com', '$2b$10$/wdkX09Ggt6bCQjiGfqaguk2Z5oMi0ciOf3XkiNw8qALLFAes9sMa', 'user');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;

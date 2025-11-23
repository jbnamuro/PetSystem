-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: petsystem
-- ------------------------------------------------------
-- Server version	8.4.7

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cartitems`
--

DROP TABLE IF EXISTS `cartitems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cartitems` (
  `CartItemID` int NOT NULL AUTO_INCREMENT,
  `CartID` int NOT NULL,
  `PetID` int NOT NULL,
  PRIMARY KEY (`CartItemID`),
  UNIQUE KEY `uq_cart_pet` (`CartID`,`PetID`),
  KEY `PetID` (`PetID`),
  CONSTRAINT `cartitems_ibfk_1` FOREIGN KEY (`CartID`) REFERENCES `shoppingcart` (`CartID`) ON DELETE CASCADE,
  CONSTRAINT `cartitems_ibfk_2` FOREIGN KEY (`PetID`) REFERENCES `pets` (`PetID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cartitems`
--

LOCK TABLES `cartitems` WRITE;
/*!40000 ALTER TABLE `cartitems` DISABLE KEYS */;
/*!40000 ALTER TABLE `cartitems` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_before_add_to_cart` BEFORE INSERT ON `cartitems` FOR EACH ROW BEGIN
    -- Ensure pet is still available
    IF (SELECT Status FROM pets WHERE PetID = NEW.PetID) <> 'Available' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pet is not available.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_after_add_to_cart` AFTER INSERT ON `cartitems` FOR EACH ROW BEGIN
    -- Mark pet as reserved
    UPDATE pets
    SET Status = 'Reserved'
    WHERE PetID = NEW.PetID;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `maintenancelevels`
--

DROP TABLE IF EXISTS `maintenancelevels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintenancelevels` (
  `MaintenanceID` int NOT NULL AUTO_INCREMENT,
  `MaintenanceName` varchar(30) NOT NULL,
  PRIMARY KEY (`MaintenanceID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maintenancelevels`
--

LOCK TABLES `maintenancelevels` WRITE;
/*!40000 ALTER TABLE `maintenancelevels` DISABLE KEYS */;
INSERT INTO `maintenancelevels` VALUES (1,'Low Maintenance'),(2,'Moderate Maintenance'),(3,'High Maintenance');
/*!40000 ALTER TABLE `maintenancelevels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orderitems`
--

DROP TABLE IF EXISTS `orderitems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orderitems` (
  `OrderItemID` int NOT NULL AUTO_INCREMENT,
  `OrderID` int NOT NULL,
  `PetID` int NOT NULL,
  `Price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`OrderItemID`),
  KEY `OrderID` (`OrderID`),
  KEY `PetID` (`PetID`),
  CONSTRAINT `orderitems_ibfk_1` FOREIGN KEY (`OrderID`) REFERENCES `orders` (`OrderID`) ON DELETE CASCADE,
  CONSTRAINT `orderitems_ibfk_2` FOREIGN KEY (`PetID`) REFERENCES `pets` (`PetID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orderitems`
--

LOCK TABLES `orderitems` WRITE;
/*!40000 ALTER TABLE `orderitems` DISABLE KEYS */;
INSERT INTO `orderitems` VALUES (1,1,2,0.00),(2,1,3,0.00),(4,2,2,0.00),(5,2,3,0.00),(7,3,1,200.00),(8,4,4,0.00);
/*!40000 ALTER TABLE `orderitems` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_before_insert_orderitem` BEFORE INSERT ON `orderitems` FOR EACH ROW BEGIN
    DECLARE pet_price DECIMAL(10,2);

    -- Load price automatically
    SELECT Price INTO pet_price FROM pets WHERE PetID = NEW.PetID;
    SET NEW.Price = pet_price;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_after_insert_orderitem` AFTER INSERT ON `orderitems` FOR EACH ROW BEGIN
    -- Update Total Price in Orders table
    UPDATE orders
    SET TotalPrice = (
        SELECT SUM(Price) FROM orderitems WHERE OrderID = NEW.OrderID
    )
    WHERE OrderID = NEW.OrderID;
    
    -- Mark Pet as Adopted
    UPDATE pets
    SET Status = 'Adopted'
    WHERE PetID = NEW.PetID;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `OrderID` int NOT NULL AUTO_INCREMENT,
  `UserID` int NOT NULL,
  `OrderDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `TotalPrice` decimal(10,2) DEFAULT '0.00',
  PRIMARY KEY (`OrderID`),
  KEY `UserID` (`UserID`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,3,'2025-11-06 12:13:09',0.00),(2,3,'2025-11-06 12:15:03',0.00),(3,4,'2025-11-06 12:19:27',200.00),(4,3,'2025-11-06 15:36:15',0.00);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_after_order_created` AFTER INSERT ON `orders` FOR EACH ROW BEGIN
    -- Empty user cart after successful order
    DELETE FROM cartitems
    WHERE CartID IN (
        SELECT CartID FROM shoppingcart WHERE UserID = NEW.UserID
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `pets`
--

DROP TABLE IF EXISTS `pets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pets` (
  `PetID` int NOT NULL AUTO_INCREMENT,
  `PetName` varchar(100) NOT NULL,
  `Description` text,
  `SpeciesID` int NOT NULL,
  `Price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `Status` enum('Available','Reserved','Adopted') NOT NULL DEFAULT 'Available',
  `RarityID` int NOT NULL,
  `MaintenanceID` int NOT NULL,
  `SpritePath` varchar(255) DEFAULT NULL,
  `SoundPath` varchar(255) DEFAULT NULL,
  `DateAdded` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`PetID`),
  KEY `RarityID` (`RarityID`),
  KEY `MaintenanceID` (`MaintenanceID`),
  KEY `fk_species` (`SpeciesID`),
  CONSTRAINT `fk_maintenance` FOREIGN KEY (`MaintenanceID`) REFERENCES `maintenancelevels` (`MaintenanceID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_rarity` FOREIGN KEY (`RarityID`) REFERENCES `raritylevels` (`RarityID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_species` FOREIGN KEY (`SpeciesID`) REFERENCES `species` (`SpeciesID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pets`
--

LOCK TABLES `pets` WRITE;
/*!40000 ALTER TABLE `pets` DISABLE KEYS */;
INSERT INTO `pets` VALUES (1,'Fluffy',NULL,2,200.00,'Adopted',1,2,'sprites/fluffy.png','sounds/fluffy_bark.mp3','2025-10-23 15:15:55'),(2,'Shadow',NULL,2,0.00,'Adopted',3,3,'sprites/shadow.png','sounds/shadow_growl.mp3','2025-10-23 15:15:55'),(3,'Bubbles',NULL,2,0.00,'Adopted',2,1,'sprites/bubbles.png','sounds/bubbles_chirp.mp3','2025-10-23 15:15:55'),(4,'Nibbles',NULL,2,0.00,'Adopted',1,1,'sprites/nibbles.png','sounds/nibbles squeak.mp3','2025-10-23 15:15:55'),(5,'Luna','Loves to nap in sunny spots',1,349.99,'Reserved',2,3,'img/luna.png','sound/luna.mp3','2025-11-06 16:33:59'),(6,'Scooby','Friendly pup',1,250.00,'Available',2,3,'img/Scooby.png',NULL,'2025-11-06 16:35:33');
/*!40000 ALTER TABLE `pets` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_after_pet_adopted_cleanup` AFTER UPDATE ON `pets` FOR EACH ROW BEGIN
    -- If pet became adopted, remove all cart references
    IF NEW.Status = 'Adopted' THEN
        DELETE FROM cartitems WHERE PetID = NEW.PetID;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `raritylevels`
--

DROP TABLE IF EXISTS `raritylevels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `raritylevels` (
  `RarityID` int NOT NULL AUTO_INCREMENT,
  `RarityName` varchar(30) NOT NULL,
  PRIMARY KEY (`RarityID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `raritylevels`
--

LOCK TABLES `raritylevels` WRITE;
/*!40000 ALTER TABLE `raritylevels` DISABLE KEYS */;
INSERT INTO `raritylevels` VALUES (1,'Low'),(2,'Medium'),(3,'High');
/*!40000 ALTER TABLE `raritylevels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shoppingcart`
--

DROP TABLE IF EXISTS `shoppingcart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shoppingcart` (
  `CartID` int NOT NULL AUTO_INCREMENT,
  `UserID` int NOT NULL,
  PRIMARY KEY (`CartID`),
  KEY `UserID` (`UserID`),
  CONSTRAINT `shoppingcart_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shoppingcart`
--

LOCK TABLES `shoppingcart` WRITE;
/*!40000 ALTER TABLE `shoppingcart` DISABLE KEYS */;
INSERT INTO `shoppingcart` VALUES (1,3),(2,4);
/*!40000 ALTER TABLE `shoppingcart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `species`
--

DROP TABLE IF EXISTS `species`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `species` (
  `SpeciesID` int NOT NULL AUTO_INCREMENT,
  `SpeciesName` varchar(50) NOT NULL,
  PRIMARY KEY (`SpeciesID`),
  UNIQUE KEY `SpeciesName` (`SpeciesName`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `species`
--

LOCK TABLES `species` WRITE;
/*!40000 ALTER TABLE `species` DISABLE KEYS */;
INSERT INTO `species` VALUES (3,'Bird'),(2,'Cat'),(1,'Dog'),(5,'Fish'),(4,'Reptile');
/*!40000 ALTER TABLE `species` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `UserID` int NOT NULL AUTO_INCREMENT,
  `Username` varchar(50) NOT NULL,
  `PasswordHash` varchar(255) NOT NULL,
  `Role` enum('Admin','Staff','User') NOT NULL,
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `Username` (`Username`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin_user','hashed_admin_pw','Admin'),(2,'staff_member','hashed_staff_pw','Staff'),(3,'user_jane','hashed_user_pw1','User'),(4,'user_john','hashed_user_pw2','User'),(5,'Maxwell','password123','User'),(6,'Jacob','pass123','Staff'),(7,'Bob','pass123','Admin');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'petsystem'
--
/*!50003 DROP PROCEDURE IF EXISTS `add_pet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_pet`(
	IN p_user_id INT,
	IN p_pet_name VARCHAR(100),
	IN p_description TEXT,
	IN p_species_id INT,
	IN p_rarity_id INT,
	IN p_maintenance_id INT,
	IN p_price DECIMAL(10,2),
	IN p_sprite_path VARCHAR(255),
	IN p_sound_path VARCHAR(255)
)
BEGIN
	-- Validate user permissions
	IF NOT EXISTS (SELECT * FROM users WHERE UserID = p_user_id AND Role IN ('Staff', 'Admin')) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Unauthorized: only staff or admin can add pets.';
	END IF;

	-- Insert new pet
	INSERT INTO pets(PetName, Description, SpeciesID, RarityID, MaintenanceID, Price, SpritePath, SoundPath, Status, DateAdded) 
	VALUES (p_pet_name, p_description, p_species_id, p_rarity_id, p_maintenance_id,
			p_price, p_sprite_path, p_sound_path, 'Available', NOW());              
	
	CALL get_pet_details(LAST_INSERT_ID());
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `add_to_cart` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_to_cart`(IN p_user_id INT, IN p_pet_id INT)
BEGIN
	DECLARE v_cart_id INT;
    
    -- Validating User Existence
    IF p_user_id is NULL OR NOT EXISTS (SELECT * FROM users WHERE UserID = p_user_id AND Role = 'User') THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Invalid or non-customer UserID';
	END IF;
    
	-- Validating Pet Existence
    IF p_pet_id is NULL OR NOT EXISTS (SELECT * FROM pets WHERE PetID = p_pet_id) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Invalid PetID';
	END IF;
    
    -- Ensuring Pet is Available
    IF EXISTS (SELECT * FROM pets WHERE PetID = p_pet_id AND Status <> 'Available') THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'This pet is no longer available for adoption';
	END IF;	
    
    -- Find or create a cart for the user
    SELECT CartID INTO v_cart_id
    FROM shoppingcart
    WHERE UserID = p_user_id
    LIMIT 1;
    
    IF v_cart_id IS NULL THEN
		INSERT INTO shoppingcart(UserID) VALUES (p_user_id);
        SET v_cart_id = LAST_INSERT_ID();
	END IF;
    
    -- Insert pet into user's cart
    INSERT INTO  cartitems (CartID, PetID) VALUES (v_cart_id, p_pet_id);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `browse_pets` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `browse_pets`(
	IN p_page_size INT,
    IN p_page INT,
    IN p_sort_by VARCHAR(32),   -- 'DateAdded','PetName','Rarity','Maintenance, Species, Price'
	IN p_sort_dir VARCHAR(4),   -- 'ASC' or 'DESC'
    IN p_rarity_id INT,
    IN p_maintenance_id INT,
	IN p_species_id INT,  
    IN P_name_like VARCHAR(100),
    IN p_status_list VARCHAR(100),
    IN p_min_price DECIMAL(10,2),
    IN p_max_price DECIMAL(10,2)    
)
BEGIN
	IF p_page_size IS NULL OR p_page_size < 1 THEN SET p_page_size = 12; END IF;
    IF p_page IS NULL OR p_page < 1 THEN SET p_page = 1; END IF;
    IF p_sort_by IS NULL THEN SET p_sort_by = 'DateAdded'; END IF;
    IF p_sort_dir IS NULL THEN SET p_sort_dir = 'DESC'; END IF;
    
    SET @order_col := CASE UPPER(p_sort_by)
						 WHEN 'DATEADDED'   THEN 'p.DateAdded'
						 WHEN 'PETNAME'     THEN 'p.PetName'
						 WHEN 'RARITY'      THEN 'p.RarityID'
						 WHEN 'MAINTENANCE' THEN 'p.MaintenanceID'
						 WHEN 'SPECIES'     THEN 'p.SpeciesID'
						 WHEN 'PRICE'       THEN 'p.Price'
						 ELSE 'p.DateAdded'
					   END;
    
	SET @order_dir = CASE UPPER(p_sort_dir)
						 WHEN 'ASC' THEN 'ASC'
						 ELSE 'DESC'
					END;
    
    SET @base := 'SELECT p.PetID, p.PetName, s.SpeciesName, rl.RarityName, ml.MaintenanceName, p.Status, p.Price, p.DateAdded, p.SpritePath, p.SoundPath
					FROM pets p
                    LEFT JOIN raritylevels rl ON rl.RarityID = p.RarityID
                    LEFT JOIN maintenancelevels ml ON ml.MaintenanceID = p.MaintenanceID
					LEFT JOIN species s ON s.SpeciesID = p.SpeciesID
                    WHERE 1=1
                    ';
	
    -- Optional filters
	IF p_rarity_id IS NOT NULL THEN 
		SET @base := CONCAT(@base, ' AND p.RarityID = ', p_rarity_id);
	END IF;
	IF p_maintenance_id IS NOT NULL THEN 
		SET @base := CONCAT(@base, ' AND p.MaintenanceID = ', p_maintenance_id);
	END IF;
	IF p_name_like IS NOT NULL THEN 
		SET @base := CONCAT(@base, " AND p.PetName LIKE '%", p_name_like, "%'");
	END IF;
	IF p_species_id IS NOT NULL THEN 
		SET @base = CONCAT(@base, ' AND p.SpeciesID = ', p_species_id);  
	END IF;
	IF p_min_price IS NOT NULL THEN
        SET @base := CONCAT(@base, ' AND p.Price >= ', p_min_price);
    END IF;
    IF p_max_price IS NOT NULL THEN
        SET @base := CONCAT(@base, ' AND p.Price <= ', p_max_price);
    END IF;
    
	IF p_status_list IS NOT NULL THEN
		-- Remove all spaces
		SET @clean_status := REPLACE(p_status_list, ' ', '');
		-- Remove leading/trailing commas
		SET @clean_status := TRIM(BOTH ',' FROM @clean_status);
		-- Convert to quoted paramter list ('A','B','C')
		SET @clean_status := REPLACE(
			CONCAT("'", @clean_status, "'"),
			",",
			"','"
		);
		-- Append to SQL
		SET @base := CONCAT(
			@base,
			" AND p.Status IN (", @clean_status, ")"
		);
	END IF;

    
    SET @base := CONCAT(@base,  ' ORDER BY ', @order_col, ' ', @order_dir,
								' LIMIT ', p_page_size, 
                                ' OFFSET ', (p_page - 1) * p_page_size);
	
    PREPARE stmt FROM @base;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `checkout_cart` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkout_cart`(IN p_user_id INT)
BEGIN
	DECLARE v_cart_id INT;
    DECLARE v_order_id INT;
    DECLARE v_total DECIMAL(10,2);
    
	-- Handle unexpected SQL errors
	DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Checkout failed: transaction rolled back.';
	END;
    
    START TRANSACTION;
    
	-- Validate user
	IF p_user_id IS NULL OR NOT EXISTS (SELECT * FROM users WHERE UserID = p_user_id AND Role = 'User') THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Invalid or non-customer UserID';
	END IF;
    
	-- Find user's cart
	SELECT CartID INTO v_cart_id
	FROM shoppingcart
	WHERE UserID = p_user_id
	LIMIT 1;

	IF v_cart_id IS NULL THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'User has no active cart.';
	END IF;
    
	-- Check if cart has items
	IF NOT EXISTS (SELECT * FROM cartitems WHERE CartID = v_cart_id) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Your cart is empty.';
	END IF;
    
	-- Verify all pets are still available
	IF EXISTS (
		SELECT 1
		FROM cartitems ci
		JOIN pets p ON p.PetID = ci.PetID
		WHERE ci.CartID = v_cart_id AND p.Status <> 'Available'
	) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'One or more pets are no longer available.';
	END IF;
    
    
	-- Calculate total price before creating the order
	SELECT SUM(p.Price)
	INTO v_total
	FROM cartitems ci
	JOIN pets p ON p.PetID = ci.PetID
	WHERE ci.CartID = v_cart_id;
  
	-- Create an order
	INSERT INTO orders (UserID, TotalPrice) 
    VALUES (p_user_id, v_total);
	SET v_order_id = LAST_INSERT_ID();
    
	-- Add each pet from cart to orderitems
	INSERT INTO orderitems (OrderID, PetID, Price)
	SELECT v_order_id, p.PetID, p.Price
	FROM cartitems ci
	JOIN pets p ON p.PetID = ci.PetID
	WHERE ci.CartID = v_cart_id;
    
	-- Mark pets as purchased
	UPDATE pets
	SET Status = 'Adopted'
	WHERE PetID IN (SELECT PetID FROM cartitems WHERE CartID = v_cart_id);
    
	-- Empty the cart
	DELETE FROM cartitems WHERE CartID = v_cart_id;
    
    COMMIT;

    
	-- Return final order summary
	CALL get_order_details(v_order_id);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_cart_details` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_cart_details`(IN p_user_id INT)
BEGIN
	DECLARE v_cart_id INT;

	-- Validate user
	IF p_user_id IS NULL OR NOT EXISTS (SELECT * FROM users WHERE UserID = p_user_id AND Role = 'User') THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Invalid or non-customer UserID';
	END IF;
    
	-- Get user’s cart
	SELECT CartID INTO v_cart_id
	FROM shoppingcart
	WHERE UserID = p_user_id
	LIMIT 1;

	IF v_cart_id IS NULL THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'This user has no active cart.';
	END IF;
    
	SELECT 
	c.CartID,
	ci.CartItemID,
    p.PetID,
	p.PetName,
	s.SpeciesName,
	p.Price,
	p.Status
	FROM cartitems ci
	JOIN pets p ON p.PetID = ci.PetID
	LEFT JOIN species s ON s.SpeciesID = p.SpeciesID
	JOIN shoppingcart c ON c.CartID = ci.CartID
	WHERE c.CartID = v_cart_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_order_details` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_order_details`(IN p_order_id INT)
BEGIN
	-- Validate order existence
	IF NOT EXISTS (SELECT * FROM orders WHERE OrderID = p_order_id) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Invalid OrderID';
	END IF;
    
	-- Return final order summary
	SELECT 
	o.OrderID,
	o.OrderDate,
	u.UserName AS Customer,
	p.PetName,
	s.SpeciesName,
	p.Price,
	o.TotalPrice AS 'Order Total'
	FROM orderitems oi
	JOIN orders o ON o.OrderID = oi.OrderID
	JOIN users u ON u.UserID = o.UserID
	JOIN pets p ON p.PetID = oi.PetID
	LEFT JOIN species s ON s.SpeciesID = p.SpeciesID
	WHERE o.OrderID = p_order_id
	ORDER BY p.PetName;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_pet_details` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_pet_details`(IN p_pet_id INT)
BEGIN
	IF p_pet_id IS NULL OR p_pet_id <= 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Invalid PetID provided.';
	END IF;

	SELECT 
		p.PetID,
		p.PetName,
		p.Description,
		p.Price,
		p.RarityID,
		rl.RarityName,
		p.MaintenanceID,
		ml.MaintenanceName,
        p.Status,
		p.DateAdded,
		p.SpritePath,
		p.SoundPath
	  FROM pets p
	  LEFT JOIN raritylevels rl      ON rl.RarityID = p.RarityID
	  LEFT JOIN maintenancelevels ml ON ml.MaintenanceID = p.MaintenanceID
	  WHERE p.PetID = p_pet_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_user_details` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_user_details`(IN p_user_id INT)
BEGIN
	-- Validate user exists
	IF NOT EXISTS (SELECT * FROM users WHERE UserID = p_user_id) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Invalid UserID.';
	END IF;
    
	 SELECT 
	UserID,
	Username,
	Role
	FROM users
	WHERE UserID = p_user_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_user_orders` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_user_orders`(IN p_user_id INT)
BEGIN
	-- Validate user exists
	IF NOT EXISTS (SELECT * FROM users WHERE UserID = p_user_id) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Invalid UserID.';
	END IF;

	SELECT 
	OrderID,
	OrderDate,
	TotalPrice
	FROM orders
	WHERE UserID = p_user_id
	ORDER BY OrderDate DESC, OrderID DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `register_customer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_customer`(
	IN p_username VARCHAR(50), 
    IN p_password VARCHAR(255)
)
BEGIN
	-- Validate inputs
	IF p_username IS NULL OR p_username = '' THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Username cannot be empty.';
	END IF;

	IF p_password IS NULL OR p_password = '' THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Password cannot be empty.';
	END IF;
    
	-- Checking for existing username
	IF EXISTS (SELECT * FROM users WHERE Username = p_username) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Username already exists.';
	END IF;

	-- Insert new user with User role
	INSERT INTO users (Username, PasswordHash, Role)
	VALUES (p_username, p_password, 'User');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `register_staff` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_staff`(
	IN p_admin_id INT,
	IN p_username VARCHAR(50), 
    IN p_password VARCHAR(255),
    IN p_role ENUM('Staff', 'Admin')
)
BEGIN
	-- Ensure caller is an Admin
	IF NOT EXISTS (SELECT * FROM users WHERE UserID = p_admin_id AND Role = 'Admin') THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Only Admin users can create staff or admin accounts.';
	END IF;

	-- Validate inputs
	IF p_username IS NULL OR p_username = '' THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Username cannot be empty.';
	END IF;

	IF p_password IS NULL OR p_password = '' THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Password cannot be empty.';
	END IF;
    
	-- Checking for existing username
	IF EXISTS (SELECT * FROM users WHERE Username = p_username) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Username already exists.';
	END IF;

	-- Insert new user with Staff/Admin role
	INSERT INTO users (Username, PasswordHash, Role)
	VALUES (p_username, p_password, p_role);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `remove_from_cart` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `remove_from_cart`(IN p_user_id INT, IN p_pet_id INT)
BEGIN
	DECLARE v_cart_id INT;

	-- Validate User
	IF p_user_id IS NULL OR NOT EXISTS (SELECT * FROM users WHERE UserID = p_user_id AND Role = 'User') THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Invalid or non-customer UserID';
	END IF;

	-- Validate pet
	IF p_pet_id IS NULL OR NOT EXISTS (SELECT * FROM pets WHERE PetID = p_pet_id) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Invalid PetID';
	END IF;

	-- Find user cart
	SELECT CartID INTO v_cart_id
	FROM shoppingcart
	WHERE UserID = p_user_id
	LIMIT 1;

	IF v_cart_id IS NULL THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'User has no active cart.';
	END IF;
    
	-- Ensure pet exists in user's cart
	IF NOT EXISTS (SELECT * FROM cartitems WHERE CartID = v_cart_id AND PetID = p_pet_id) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'This pet is not in the user’s cart.';
	END IF;
    
    -- Deleting Pet from cart
	DELETE FROM cartitems
	WHERE CartID = v_cart_id AND PetID = p_pet_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `remove_pet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `remove_pet`(IN p_user_id INT, IN p_pet_id INT)
BEGIN
	-- Validate staff/admin authorization
	IF NOT EXISTS (SELECT *	FROM users 	WHERE UserID = p_user_id AND Role IN ('Staff', 'Admin')) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Unauthorized: only staff or admin can remove pets.';
	END IF;
    
	-- Check pet existence
	IF NOT EXISTS (SELECT * FROM pets WHERE PetID = p_pet_id) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Invalid PetID.';
	END IF;
    
	-- Delete pet
	DELETE FROM pets WHERE PetID = p_pet_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_pet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_pet`(
	-- NUll values in paramaters will keep field values the same
	IN p_user_id INT,
    IN p_pet_id INT,
	IN p_pet_name VARCHAR(100),
	IN p_description TEXT,
	IN p_species_id INT,
	IN p_rarity_id INT,
	IN p_maintenance_id INT,
	IN p_price DECIMAL(10,2),
	IN p_sprite_path VARCHAR(255),
	IN p_sound_path VARCHAR(255),
    IN p_status ENUM('Available','Reserved','Adopted')
)
BEGIN
	-- Validate user permissions
	IF NOT EXISTS (SELECT * FROM users WHERE UserID = p_user_id AND Role IN ('Staff', 'Admin')) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Unauthorized: only staff or admin can update pets.';
	END IF;
    
	-- Check pet existence
	IF NOT EXISTS (SELECT * FROM pets WHERE PetID = p_pet_id) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Invalid PetID.';
	END IF;
    
    -- Update pets
	UPDATE pets
	SET 
		PetName = COALESCE(p_pet_name, PetName),
		Description = COALESCE(p_description, Description),
		SpeciesID = COALESCE(p_species_id, SpeciesID),
		RarityID = COALESCE(p_rarity_id, RarityID),
		MaintenanceID = COALESCE(p_maintenance_id, MaintenanceID),
		Price = COALESCE(p_price, Price),
		SpritePath = COALESCE(p_sprite_path, SpritePath),
		SoundPath = COALESCE(p_sound_path, SoundPath),
		Status = COALESCE(p_status, Status)
	WHERE PetID = p_pet_id;
    
    -- Return updated pet info
    CALL get_pet_details(p_pet_id);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `validate_login` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `validate_login`(IN p_username VARCHAR(50), IN p_password VARCHAR(255))
BEGIN
    DECLARE v_user_id INT;

	-- Empty or NULL Usename
	IF p_username IS NULL OR p_username = '' THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Username is required.';
	END IF;

	-- Empty or NULL Password
	IF p_password IS NULL OR p_password = '' THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Password is required.';
	END IF;
    
	-- Validate credentials
	IF NOT EXISTS (SELECT * FROM users WHERE Username = p_username AND PasswordHash = p_password) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Invalid username or password.';
	END IF;
    
	-- Valid login: Fetch the user's ID and info
	SELECT UserID 
	INTO v_user_id
	FROM users
	WHERE Username = p_username AND PasswordHash = p_password
	LIMIT 1;

	CALL get_user_details(v_user_id);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-23 16:25:46

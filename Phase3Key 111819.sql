CREATE DATABASE  IF NOT EXISTS `team11` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `team11`;
-- MySQL dump 10.13  Distrib 8.0.17, for Win64 (x86_64)
--
-- Host: localhost    Database: team11
-- ------------------------------------------------------
-- Server version	8.0.17

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
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `username` varchar(30) NOT NULL,
  PRIMARY KEY (`username`),
  CONSTRAINT `fk_admin_emp` FOREIGN KEY (`username`) REFERENCES `employee` (`username`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company`
--

DROP TABLE IF EXISTS `company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `company` (
  `comName` varchar(20) NOT NULL,
  PRIMARY KEY (`comName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company`
--

LOCK TABLES `company` WRITE;
/*!40000 ALTER TABLE `company` DISABLE KEYS */;
/*!40000 ALTER TABLE `company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `username` varchar(30) NOT NULL,
  PRIMARY KEY (`username`),
  CONSTRAINT `fk_cust_user` FOREIGN KEY (`username`) REFERENCES `user` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customercreditcard`
--

DROP TABLE IF EXISTS `customercreditcard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customercreditcard` (
  `creditCardNum` int(11) NOT NULL,
  `username` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`creditCardNum`),
  KEY `fk_custcredit_cust_idx` (`username`),
  CONSTRAINT `fk_custcredit_cust` FOREIGN KEY (`username`) REFERENCES `customer` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customercreditcard`
--

LOCK TABLES `customercreditcard` WRITE;
/*!40000 ALTER TABLE `customercreditcard` DISABLE KEYS */;
/*!40000 ALTER TABLE `customercreditcard` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customerviewmovie`
--

DROP TABLE IF EXISTS `customerviewmovie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customerviewmovie` (
  `creditCardNum` int(11) NOT NULL,
  `thName` varchar(45) NOT NULL,
  `comName` varchar(45) NOT NULL,
  `movName` varchar(45) NOT NULL,
  `movReleaseDate` date NOT NULL,
  `movPlayDate` date NOT NULL,
  PRIMARY KEY (`creditCardNum`,`thName`,`comName`,`movName`,`movReleaseDate`,`movPlayDate`),
  KEY `fk_custview_movplay_idx` (`thName`,`comName`,`movName`,`movReleaseDate`,`movPlayDate`),
  CONSTRAINT `fk_custview_custcredit` FOREIGN KEY (`creditCardNum`) REFERENCES `customercreditcard` (`creditCardNum`),
  CONSTRAINT `fk_custview_movplay` FOREIGN KEY (`thName`, `comName`, `movName`, `movReleaseDate`, `movPlayDate`) REFERENCES `movieplay` (`thName`, `comName`, `movName`, `movReleaseDate`, `movPlayDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customerviewmovie`
--

LOCK TABLES `customerviewmovie` WRITE;
/*!40000 ALTER TABLE `customerviewmovie` DISABLE KEYS */;
/*!40000 ALTER TABLE `customerviewmovie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee` (
  `username` varchar(30) NOT NULL,
  PRIMARY KEY (`username`),
  CONSTRAINT `fk_emp_user` FOREIGN KEY (`username`) REFERENCES `user` (`username`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES ('calcultron'),('cool_class4400'),('entropyRox'),('fatherAI'),('georgep'),('ghcghc'),('imbatman'),('manager1'),('manager2'),('manager3'),('manager4'),('radioactivePoRa');
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `manager`
--

DROP TABLE IF EXISTS `manager`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manager` (
  `username` varchar(30) NOT NULL,
  `comName` varchar(45) NOT NULL,
  `manStreet` varchar(45) NOT NULL,
  `manCity` varchar(45) NOT NULL,
  `manState` varchar(2) NOT NULL,
  `manZipcode` int(11) NOT NULL,
  `thName` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`username`),
  KEY `comName_idx` (`comName`),
  CONSTRAINT `fk_man_com` FOREIGN KEY (`comName`) REFERENCES `company` (`comName`),
  CONSTRAINT `fk_man_emp` FOREIGN KEY (`username`) REFERENCES `employee` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `manager`
--

LOCK TABLES `manager` WRITE;
/*!40000 ALTER TABLE `manager` DISABLE KEYS */;
/*!40000 ALTER TABLE `manager` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movie`
--

DROP TABLE IF EXISTS `movie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movie` (
  `movName` varchar(30) NOT NULL,
  `movReleaseDate` date NOT NULL,
  `duration` int(11) NOT NULL,
  PRIMARY KEY (`movName`,`movReleaseDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movie`
--

LOCK TABLES `movie` WRITE;
/*!40000 ALTER TABLE `movie` DISABLE KEYS */;
/*!40000 ALTER TABLE `movie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movieplay`
--

DROP TABLE IF EXISTS `movieplay`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movieplay` (
  `thName` varchar(30) NOT NULL,
  `comName` varchar(45) NOT NULL,
  `movName` varchar(45) NOT NULL,
  `movReleaseDate` date NOT NULL,
  `movPlayDate` date NOT NULL,
  PRIMARY KEY (`thName`,`comName`,`movName`,`movReleaseDate`,`movPlayDate`),
  KEY `fk_movplay_mov_idx` (`movName`,`movReleaseDate`),
  CONSTRAINT `fk_movplay_mov` FOREIGN KEY (`movName`, `movReleaseDate`) REFERENCES `movie` (`movName`, `movReleaseDate`),
  CONSTRAINT `fk_movplay_th` FOREIGN KEY (`thName`, `comName`) REFERENCES `theater` (`thName`, `comName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movieplay`
--

LOCK TABLES `movieplay` WRITE;
/*!40000 ALTER TABLE `movieplay` DISABLE KEYS */;
/*!40000 ALTER TABLE `movieplay` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `theater`
--

DROP TABLE IF EXISTS `theater`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `theater` (
  `thName` varchar(30) NOT NULL,
  `comName` varchar(30) NOT NULL,
  `capacity` int(11) NOT NULL,
  `thStreet` varchar(45) NOT NULL,
  `thCity` varchar(45) NOT NULL,
  `thState` varchar(45) NOT NULL,
  `thZipcode` int(11) NOT NULL,
  `manUsername` varchar(45) NOT NULL,
  PRIMARY KEY (`thName`,`comName`),
  KEY `fk_th_comp_idx` (`comName`),
  KEY `fk_th_man_idx` (`manUsername`),
  CONSTRAINT `fk_th_comp` FOREIGN KEY (`comName`) REFERENCES `company` (`comName`),
  CONSTRAINT `fk_th_man` FOREIGN KEY (`manUsername`) REFERENCES `manager` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `theater`
--

LOCK TABLES `theater` WRITE;
/*!40000 ALTER TABLE `theater` DISABLE KEYS */;
/*!40000 ALTER TABLE `theater` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `username` varchar(30) NOT NULL,
  `status` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  `firstname` varchar(45) NOT NULL,
  `lastname` varchar(45) NOT NULL,
  `isEmployee` varchar(5) DEFAULT NULL,
  `isCustomer` varchar(5) DEFAULT NULL,
  `isUser` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('calcultron','Approved','333333333','Dwight','Schrute','1','1','0'),('calcultron2','Approved','444444444','Jim','Halpert','0','1','0'),('calcwizard','Approved','222222222','Issac','Newton','0','1','0'),('clarinetbeast','Declined','999999999','Squidward','Tentacles','0','1','0'),('cool_class4400','Approved','333333333','A. TA','Washere','1','1','0'),('DNAhelix','Approved','777777777','Rosalind','Franklin','0','1','0'),('does2Much','Approved','1212121212','Carl','Gauss','0','1','0'),('eeqmcsquare','Approved','111111110','Albert','Einstein','0','1','0'),('entropyRox','Approved','999999999','Claude','Shannon','1','1','0'),('fatherAI','Approved','222222222','Alan','Turing','1','0','0'),('fullMetal','Approved','111111100','Edward','Elric','0','1','0'),('gdanger','Declined','555555555','Gary','Danger','0','0','1'),('georgep','Approved','111111111','George P.','Burdell','1','1','0'),('ghcghc','Approved','666666666','Grace','Hopper','1','0','0'),('ilikemoney$$','Approved','111111110','Eugene','Krabs','0','1','0'),('imbatman','Approved','666666666','Bruce','Wayne','1','0','0'),('imready','Approved','777777777','Spongebob','Squarepants','0','1','0'),('isthisthekrustykrab','Approved','888888888','Patrick','Star','0','1','0'),('manager1','Approved','1122112211','Manager','One','1','0','0'),('manager2','Approved','3131313131','Manager','Two','1','0','0'),('manager3','Approved','8787878787','Three','Three','1','0','0'),('manager4','Approved','5755555555','Four','Four','1','0','0'),('notFullMetal','Approved','111111100','Alphonse','Elric','0','1','0'),('programerAAL','Approved','3131313131','Ada','Lovelace','0','1','0'),('radioactivePoRa','Approved','1313131313','Marie','Curie','1','0','0'),('RitzLover28','Approved','444444444','Abby','Normal','0','1','0'),('smith_j','Pending','333333333','John','Smith','0','0','1'),('texasStarKarate','Declined','111111110','Sandy','Cheeks','0','0','1'),('thePiGuy3.14','Approved','1111111111','Archimedes','Syracuse','0','1','0'),('theScienceGuy','Approved','999999999','Bill','Nye','0','1','0');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `uservisittheater`
--

DROP TABLE IF EXISTS `uservisittheater`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `uservisittheater` (
  `visitID` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(45) NOT NULL,
  `thName` varchar(45) NOT NULL,
  `comName` varchar(45) NOT NULL,
  `visitDate` date NOT NULL,
  PRIMARY KEY (`visitID`),
  KEY `fk_uservisit_user_idx` (`username`),
  KEY `fk_uservisit_th_idx` (`thName`,`comName`),
  CONSTRAINT `fk_uservisit_th` FOREIGN KEY (`thName`, `comName`) REFERENCES `theater` (`thName`, `comName`),
  CONSTRAINT `fk_uservisit_user` FOREIGN KEY (`username`) REFERENCES `user` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `uservisittheater`
--

LOCK TABLES `uservisittheater` WRITE;
/*!40000 ALTER TABLE `uservisittheater` DISABLE KEYS */;
/*!40000 ALTER TABLE `uservisittheater` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'team11'
--

--
-- Dumping routines for database 'team11'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-18 12:04:32

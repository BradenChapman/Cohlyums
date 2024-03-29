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
-- Table structure for table `adcomdetailemp`
--

DROP TABLE IF EXISTS `adcomdetailemp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `adcomdetailemp` (
  `empFirstname` varchar(45) NOT NULL,
  `empLastname` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adcomdetailemp`
--

LOCK TABLES `adcomdetailemp` WRITE;
/*!40000 ALTER TABLE `adcomdetailemp` DISABLE KEYS */;
INSERT INTO `adcomdetailemp` VALUES ('Claude','Shannon'),('George P.','Burdell'),('Manager','One'),('Three','Three'),('Four','Four'),('Marie','Curie');
/*!40000 ALTER TABLE `adcomdetailemp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `adcomdetailth`
--

DROP TABLE IF EXISTS `adcomdetailth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `adcomdetailth` (
  `thName` varchar(30) NOT NULL,
  `thManagerUsername` varchar(45) NOT NULL,
  `thCity` varchar(45) NOT NULL,
  `thState` char(2) NOT NULL,
  `thCapacity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adcomdetailth`
--

LOCK TABLES `adcomdetailth` WRITE;
/*!40000 ALTER TABLE `adcomdetailth` DISABLE KEYS */;
INSERT INTO `adcomdetailth` VALUES ('Cinema Star','entropyRox','San Francisco','CA',4),('Jonathan\'s Movies','georgep','Seattle','WA',2),('Star Movies','radioactivePoRa','Boulder','CA',5);
/*!40000 ALTER TABLE `adcomdetailth` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `adfiltercom`
--

DROP TABLE IF EXISTS `adfiltercom`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `adfiltercom` (
  `comName` varchar(30) NOT NULL,
  `numCityCover` bigint(21) NOT NULL DEFAULT '0',
  `numTheater` bigint(21) NOT NULL DEFAULT '0',
  `numEmployee` bigint(21) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adfiltercom`
--

LOCK TABLES `adfiltercom` WRITE;
/*!40000 ALTER TABLE `adfiltercom` DISABLE KEYS */;
INSERT INTO `adfiltercom` VALUES ('4400 Theater Company',3,3,6);
/*!40000 ALTER TABLE `adfiltercom` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `adfilteruser`
--

DROP TABLE IF EXISTS `adfilteruser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `adfilteruser` (
  `username` varchar(30) NOT NULL,
  `creditCardCount` bigint(21) DEFAULT NULL,
  `userType` varchar(15) DEFAULT NULL,
  `status` varchar(45) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adfilteruser`
--

LOCK TABLES `adfilteruser` WRITE;
/*!40000 ALTER TABLE `adfilteruser` DISABLE KEYS */;
INSERT INTO `adfilteruser` VALUES ('georgep',5,'CustomerManager','Approved'),('ilikemoney$$',3,'Customer','Approved'),('isthisthekrustykrab',3,'Customer','Approved'),('calcultron2',2,'Customer','Approved'),('entropyRox',2,'CustomerManager','Approved'),('calcultron',1,'CustomerManager','Approved'),('calcwizard',1,'Customer','Approved'),('cool_class4400',1,'CustomerAdmin','Approved'),('DNAhelix',1,'Customer','Approved'),('does2Much',1,'Customer','Approved'),('eeqmcsquare',1,'Customer','Approved'),('fullMetal',1,'Customer','Approved'),('imready',1,'Customer','Approved'),('notFullMetal',1,'Customer','Approved'),('programerAAL',1,'Customer','Approved'),('RitzLover28',1,'Customer','Approved'),('thePiGuy3.14',1,'Customer','Approved'),('theScienceGuy',1,'Customer','Approved'),('fatherAI',0,'Manager','Approved'),('ghcghc',0,'Manager','Approved'),('imbatman',0,'Manager','Approved'),('manager1',0,'Manager','Approved'),('manager2',0,'Manager','Approved'),('manager3',0,'Manager','Approved'),('manager4',0,'Manager','Approved'),('radioactivePoRa',0,'Manager','Approved');
/*!40000 ALTER TABLE `adfilteruser` ENABLE KEYS */;
UNLOCK TABLES;

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
INSERT INTO `admin` VALUES ('cool_class4400');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company`
--

DROP TABLE IF EXISTS `company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `company` (
  `comName` varchar(45) NOT NULL,
  PRIMARY KEY (`comName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company`
--

LOCK TABLES `company` WRITE;
/*!40000 ALTER TABLE `company` DISABLE KEYS */;
INSERT INTO `company` VALUES ('4400 Theater Company'),('AI Theater Company'),('Awesome Theater Company'),('EZ Theater Company');
/*!40000 ALTER TABLE `company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cosfiltermovie`
--

DROP TABLE IF EXISTS `cosfiltermovie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cosfiltermovie` (
  `movName` varchar(45) NOT NULL,
  `thName` varchar(30) NOT NULL,
  `thStreet` varchar(45) NOT NULL,
  `thCity` varchar(45) NOT NULL,
  `thState` char(2) NOT NULL,
  `thZipcode` char(5) NOT NULL,
  `comName` varchar(30) NOT NULL,
  `movPlayDate` date NOT NULL,
  `movReleaseDate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cosfiltermovie`
--

LOCK TABLES `cosfiltermovie` WRITE;
/*!40000 ALTER TABLE `cosfiltermovie` DISABLE KEYS */;
INSERT INTO `cosfiltermovie` VALUES ('4400 The Movie','ABC Theater','880 Color Dr','Austin','TX','73301','Awesome Theater Company','2019-10-12','2019-08-12'),('The First Pokemon Movie','ABC Theater','880 Color Dr','Austin','TX','73301','Awesome Theater Company','2018-07-19','1998-07-19'),('4400 The Movie','Cinema Star','100 Cool Place','San Francisco','CA','94016','4400 Theater Company','2019-09-12','2019-08-12'),('Georgia Tech The Movie','Cinema Star','100 Cool Place','San Francisco','CA','94016','4400 Theater Company','2019-09-30','1985-08-13'),('The King\'s Speech','Cinema Star','100 Cool Place','San Francisco','CA','94016','4400 Theater Company','2019-12-20','2010-11-26'),('George P Burdell\'s Life Story','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2019-07-14','1927-08-12'),('George P Burdell\'s Life Story','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2019-10-22','1927-08-12'),('The King\'s Speech','Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2019-12-20','2010-11-26'),('Calculus Returns: A ML Story','ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2019-10-10','2019-09-19'),('Calculus Returns: A ML Story','ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2019-12-30','2019-09-19'),('Spaceballs','ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2023-01-23','1987-06-24'),('Spider-Man: Into the Spider-Verse','ML Movies','314 Pi St','Pallet Town','KS','31415','AI Theater Company','2019-09-30','2018-12-01'),('4400 The Movie','Star Movies','745 GT St','Atlanta','GA','30332','EZ Theater Company','2019-08-12','2019-08-12');
/*!40000 ALTER TABLE `cosfiltermovie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cosviewhistory`
--

DROP TABLE IF EXISTS `cosviewhistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cosviewhistory` (
  `movName` varchar(45) NOT NULL,
  `thName` varchar(45) NOT NULL,
  `comName` varchar(45) NOT NULL,
  `creditCardNum` char(16) NOT NULL,
  `movPlayDate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cosviewhistory`
--

LOCK TABLES `cosviewhistory` WRITE;
/*!40000 ALTER TABLE `cosviewhistory` DISABLE KEYS */;
INSERT INTO `cosviewhistory` VALUES ('How to Train Your Dragon','Cinema Star','4400 Theater Company','1111111111111111','2010-04-02'),('How to Train Your Dragon','Main Movies','EZ Theater Company','1111111111111111','2010-03-22'),('How to Train Your Dragon','Main Movies','EZ Theater Company','1111111111111111','2010-03-23'),('How to Train Your Dragon','Star Movies','EZ Theater Company','1111111111111100','2010-03-25');
/*!40000 ALTER TABLE `cosviewhistory` ENABLE KEYS */;
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
INSERT INTO `customer` VALUES ('calcultron'),('calcultron2'),('calcwizard'),('clarinetbeast'),('cool_class4400'),('DNAhelix'),('does2Much'),('eeqmcsquare'),('entropyRox'),('fullMetal'),('georgep'),('ilikemoney$$'),('imready'),('isthisthekrustykrab'),('notFullMetal'),('programerAAL'),('RitzLover28'),('thePiGuy3.14'),('theScienceGuy');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customercreditcard`
--

DROP TABLE IF EXISTS `customercreditcard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customercreditcard` (
  `creditCardNum` char(16) NOT NULL,
  `username` varchar(45) NOT NULL,
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
INSERT INTO `customercreditcard` VALUES ('1111111111000000','calcultron'),('1111111100000000','calcultron2'),('1111111110000000','calcultron2'),('1111111111100000','calcwizard'),('2222222222000000','cool_class4400'),('2220000000000000','DNAhelix'),('2222222200000000','does2Much'),('2222222222222200','eeqmcsquare'),('2222222222200000','entropyRox'),('2222222222220000','entropyRox'),('1100000000000000','fullMetal'),('1111111111110000','georgep'),('1111111111111000','georgep'),('1111111111111100','georgep'),('1111111111111110','georgep'),('1111111111111111','georgep'),('2222222222222220','ilikemoney$$'),('2222222222222222','ilikemoney$$'),('9000000000000000','ilikemoney$$'),('1111110000000000','imready'),('1110000000000000','isthisthekrustykrab'),('1111000000000000','isthisthekrustykrab'),('1111100000000000','isthisthekrustykrab'),('1000000000000000','notFullMetal'),('2222222000000000','programerAAL'),('3333333333333300','RitzLover28'),('2222222220000000','thePiGuy3.14'),('2222222222222000','theScienceGuy');
/*!40000 ALTER TABLE `customercreditcard` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customerviewmovie`
--

DROP TABLE IF EXISTS `customerviewmovie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customerviewmovie` (
  `creditCardNum` char(16) NOT NULL,
  `thName` varchar(45) NOT NULL,
  `comName` varchar(45) NOT NULL,
  `movName` varchar(45) NOT NULL,
  `movReleaseDate` date NOT NULL,
  `movPlayDate` date NOT NULL,
  PRIMARY KEY (`creditCardNum`,`thName`,`comName`,`movName`,`movReleaseDate`,`movPlayDate`),
  KEY `fk_custview_movplay_idx` (`thName`,`comName`,`movName`,`movReleaseDate`,`movPlayDate`),
  CONSTRAINT `fk_custview_movplay` FOREIGN KEY (`thName`, `comName`, `movName`, `movReleaseDate`, `movPlayDate`) REFERENCES `movieplay` (`thName`, `comName`, `movName`, `movReleaseDate`, `movPlayDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customerviewmovie`
--

LOCK TABLES `customerviewmovie` WRITE;
/*!40000 ALTER TABLE `customerviewmovie` DISABLE KEYS */;
INSERT INTO `customerviewmovie` VALUES ('1111111111111111','Cinema Star','4400 Theater Company','How to Train Your Dragon','2010-03-21','2010-04-02'),('1111111111111111','Main Movies','EZ Theater Company','How to Train Your Dragon','2010-03-21','2010-03-22'),('1111111111111111','Main Movies','EZ Theater Company','How to Train Your Dragon','2010-03-21','2010-03-23'),('1111111111111100','Star Movies','EZ Theater Company','How to Train Your Dragon','2010-03-21','2010-03-25');
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
  `isAdmin` varchar(5) NOT NULL DEFAULT '0',
  `isManager` varchar(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`username`),
  CONSTRAINT `fk_emp_user` FOREIGN KEY (`username`) REFERENCES `user` (`username`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES ('calcultron','0','1'),('cool_class4400','1','0'),('entropyRox','0','1'),('fatherAI','0','1'),('georgep','0','1'),('ghcghc','0','1'),('imbatman','0','1'),('manager1','0','1'),('manager2','0','1'),('manager3','0','1'),('manager4','0','1'),('radioactivePoRa','0','1');
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
  `manState` char(2) NOT NULL,
  `manZipcode` char(5) NOT NULL,
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
INSERT INTO `manager` VALUES ('calcultron','EZ Theater Company','123 Peachtree St','Atlanta','GA','30308','Star Movies'),('entropyRox','4400 Theater Company','200 Cool Place','San Francisco','CA','94016','Cinema Star'),('fatherAI','EZ Theater Company','456 Main St','New York','NY','10001','Main Movies'),('georgep','4400 Theater Company','10 Pearl Dr','Seattle','WA','98105','Jonathan\'s Movies'),('ghcghc','AI Theater Company','100 Pi St','Pallet Town','KS','31415','ML Movies'),('imbatman','Awesome Theater Company','800 Color Dr','Austin','TX','78653','ABC Theater'),('manager1','4400 Theater Company','123 Ferst Drive','Atlanta','GA','30332',''),('manager2','AI Theater Company','456 Ferst Drive','Atlanta','GA','30332',''),('manager3','4400 Theater Company','789 Ferst Drive','Atlanta','GA','30332',''),('manager4','4400 Theater Company','000 Ferst Drive','Atlanta','GA','30332',''),('radioactivePoRa','4400 Theater Company','100 Blu St','Sunnyvale','CA','94088','Star Movies');
/*!40000 ALTER TABLE `manager` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `manfilterth`
--

DROP TABLE IF EXISTS `manfilterth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manfilterth` (
  `movName` varchar(45) NOT NULL,
  `movDuration` int(11) NOT NULL,
  `movReleaseDate` date NOT NULL,
  `movPlayDate` binary(0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `manfilterth`
--

LOCK TABLES `manfilterth` WRITE;
/*!40000 ALTER TABLE `manfilterth` DISABLE KEYS */;
INSERT INTO `manfilterth` VALUES ('4400 The Movie',130,'2019-08-12',NULL),('Avengers: Endgame',181,'2019-04-26',NULL),('Calculus Returns: A ML Story',314,'2019-09-19',NULL),('Georgia Tech The Movie',100,'1985-08-13',NULL),('Spider-Man: Into the Spider-Verse',117,'2018-12-01',NULL),('The First Pokemon Movie',75,'1998-07-19',NULL);
/*!40000 ALTER TABLE `manfilterth` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movie`
--

DROP TABLE IF EXISTS `movie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movie` (
  `movName` varchar(45) NOT NULL,
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
INSERT INTO `movie` VALUES ('4400 The Movie','2019-08-12',130),('Avengers: Endgame','2019-04-26',181),('Calculus Returns: A ML Story','2019-09-19',314),('George P Burdell\'s Life Story','1927-08-12',100),('Georgia Tech The Movie','1985-08-13',100),('How to Train Your Dragon','2010-03-21',98),('Spaceballs','1987-06-24',96),('Spider-Man: Into the Spider-Verse','2018-12-01',117),('The First Pokemon Movie','1998-07-19',75),('The King\'s Speech','2010-11-26',119);
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
INSERT INTO `movieplay` VALUES ('ABC Theater','Awesome Theater Company','4400 The Movie','2019-08-12','2019-10-12'),('Cinema Star','4400 Theater Company','4400 The Movie','2019-08-12','2019-09-12'),('Star Movies','EZ Theater Company','4400 The Movie','2019-08-12','2019-08-12'),('ML Movies','AI Theater Company','Calculus Returns: A ML Story','2019-09-19','2019-10-10'),('ML Movies','AI Theater Company','Calculus Returns: A ML Story','2019-09-19','2019-12-30'),('Cinema Star','4400 Theater Company','George P Burdell\'s Life Story','1927-08-12','2010-05-20'),('Main Movies','EZ Theater Company','George P Burdell\'s Life Story','1927-08-12','2019-07-14'),('Main Movies','EZ Theater Company','George P Burdell\'s Life Story','1927-08-12','2019-10-22'),('ABC Theater','Awesome Theater Company','Georgia Tech The Movie','1985-08-13','1985-08-13'),('Cinema Star','4400 Theater Company','Georgia Tech The Movie','1985-08-13','2019-09-30'),('Cinema Star','4400 Theater Company','How to Train Your Dragon','2010-03-21','2010-04-02'),('Main Movies','EZ Theater Company','How to Train Your Dragon','2010-03-21','2010-03-22'),('Main Movies','EZ Theater Company','How to Train Your Dragon','2010-03-21','2010-03-23'),('Star Movies','EZ Theater Company','How to Train Your Dragon','2010-03-21','2010-03-25'),('Cinema Star','4400 Theater Company','Spaceballs','1987-06-24','2000-02-02'),('Main Movies','EZ Theater Company','Spaceballs','1987-06-24','1999-06-24'),('ML Movies','AI Theater Company','Spaceballs','1987-06-24','2010-04-02'),('ML Movies','AI Theater Company','Spaceballs','1987-06-24','2023-01-23'),('ML Movies','AI Theater Company','Spider-Man: Into the Spider-Verse','2018-12-01','2019-09-30'),('ABC Theater','Awesome Theater Company','The First Pokemon Movie','1998-07-19','2018-07-19'),('Cinema Star','4400 Theater Company','The King\'s Speech','2010-11-26','2019-12-20'),('Main Movies','EZ Theater Company','The King\'s Speech','2010-11-26','2019-12-20');
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
  `thState` char(2) NOT NULL,
  `thZipcode` char(5) NOT NULL,
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
INSERT INTO `theater` VALUES ('ABC Theater','Awesome Theater Company',5,'880 Color Dr','Austin','TX','73301','imbatman'),('Cinema Star','4400 Theater Company',4,'100 Cool Place','San Francisco','CA','94016','entropyRox'),('Jonathan\'s Movies','4400 Theater Company',2,'67 Pearl Dr','Seattle','WA','98101','georgep'),('Main Movies','EZ Theater Company',3,'123 Main St','New York','NY','10001','fatherAI'),('ML Movies','AI Theater Company',3,'314 Pi St','Pallet Town','KS','31415','ghcghc'),('Star Movies','4400 Theater Company',5,'4400 Rocks Ave','Boulder','CA','80301','radioactivePoRa'),('Star Movies','EZ Theater Company',2,'745 GT St','Atlanta','GA','30332','calcultron');
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
  `status` varchar(45) NOT NULL DEFAULT 'Pending',
  `password` varchar(45) NOT NULL,
  `firstname` varchar(45) NOT NULL,
  `lastname` varchar(45) NOT NULL,
  `isEmployee` varchar(5) DEFAULT '0',
  `isCustomer` varchar(5) DEFAULT '0',
  `isUser` varchar(5) DEFAULT '0',
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
-- Table structure for table `userfilterth`
--

DROP TABLE IF EXISTS `userfilterth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userfilterth` (
  `thName` varchar(30) NOT NULL,
  `thStreet` varchar(45) NOT NULL,
  `thCity` varchar(45) NOT NULL,
  `thState` char(2) NOT NULL,
  `thZipcode` char(5) NOT NULL,
  `comName` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userfilterth`
--

LOCK TABLES `userfilterth` WRITE;
/*!40000 ALTER TABLE `userfilterth` DISABLE KEYS */;
INSERT INTO `userfilterth` VALUES ('Cinema Star','100 Cool Place','San Francisco','CA','94016','4400 Theater Company'),('Jonathan\'s Movies','67 Pearl Dr','Seattle','WA','98101','4400 Theater Company'),('Star Movies','4400 Rocks Ave','Boulder','CA','80301','4400 Theater Company');
/*!40000 ALTER TABLE `userfilterth` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userlogin`
--

DROP TABLE IF EXISTS `userlogin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userlogin` (
  `username` varchar(30) NOT NULL,
  `status` varchar(45) NOT NULL DEFAULT 'Pending',
  `isCustomer` varchar(5) DEFAULT '0',
  `isAdmin` bigint(21) DEFAULT NULL,
  `isManager` bigint(21) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userlogin`
--

LOCK TABLES `userlogin` WRITE;
/*!40000 ALTER TABLE `userlogin` DISABLE KEYS */;
/*!40000 ALTER TABLE `userlogin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `uservisithistory`
--

DROP TABLE IF EXISTS `uservisithistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `uservisithistory` (
  `thName` varchar(45) NOT NULL,
  `thStreet` varchar(45) NOT NULL,
  `thCity` varchar(45) NOT NULL,
  `thState` char(2) NOT NULL,
  `thZipcode` char(5) NOT NULL,
  `comName` varchar(45) NOT NULL,
  `visitDate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `uservisithistory`
--

LOCK TABLES `uservisithistory` WRITE;
/*!40000 ALTER TABLE `uservisithistory` DISABLE KEYS */;
INSERT INTO `uservisithistory` VALUES ('Main Movies','123 Main St','New York','NY','10001','EZ Theater Company','2010-03-22'),('Star Movies','745 GT St','Atlanta','GA','30332','EZ Theater Company','2010-03-25');
/*!40000 ALTER TABLE `uservisithistory` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `uservisittheater`
--

LOCK TABLES `uservisittheater` WRITE;
/*!40000 ALTER TABLE `uservisittheater` DISABLE KEYS */;
INSERT INTO `uservisittheater` VALUES (1,'georgep','Main Movies','EZ Theater Company','2010-03-22'),(2,'calcwizard','Main Movies','EZ Theater Company','2010-03-22'),(3,'calcwizard','Star Movies','EZ Theater Company','2010-03-25'),(4,'imready','Star Movies','EZ Theater Company','2010-03-25'),(5,'calcwizard','ML Movies','AI Theater Company','2010-03-20');
/*!40000 ALTER TABLE `uservisittheater` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'team11'
--

--
-- Dumping routines for database 'team11'
--
/*!50003 DROP PROCEDURE IF EXISTS `admin_approve_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_approve_user`(IN i_username VARCHAR(50))
BEGIN
		UPDATE user
        SET status = 'Approved'
        WHERE username = i_username;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `admin_create_mov` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_create_mov`(IN i_movName VARCHAR(50), IN i_movDuration INT, IN i_movReleaseDate DATE)
BEGIN
    INSERT INTO movie (movName, movReleaseDate, duration)
    VALUES (i_movName, i_movReleaseDate, i_movDuration);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `admin_create_theater` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_create_theater`(IN i_thName VARCHAR(30),
	IN i_comName VARCHAR(30), IN i_thStreet VARCHAR(45), IN i_thCity VARCHAR(45),
    IN i_thState CHAR(2), IN i_thZipcode CHAR(11), IN i_capacity INT(11), IN i_managerUsername VARCHAR(45))
BEGIN
	insert into theater (thName, comName, thStreet, thCity, thState, thZipcode, capacity, manUsername)
    values (i_thName, i_comName, i_thStreet, i_thCity, i_thState, i_thZipcode, i_capacity, i_managerUsername);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `admin_decline_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_decline_user`(IN i_username VARCHAR(50))
BEGIN
		UPDATE user
        SET status = 'Declined'
        WHERE username = i_username;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `admin_filter_company` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_filter_company`(IN i_comName VARCHAR(50), IN i_minCity INT, IN i_maxCity INT, IN i_minTheater INT, IN i_maxTheater INT, IN i_minEmployee INT, IN i_maxEmployee INT, i_sortBy VARCHAR(50), i_sortDirection VARCHAR(50))
BEGIN
	DROP TABLE IF EXISTS AdFilterCom;
    CREATE TABLE AdFilterCom
    SELECT comName, numCityCover, numTheater, numEmployee
    FROM (
    SELECT theaterInfo.comName, numCityCover, numTheater, numEmployee
	FROM
		(SELECT comName, count(DISTINCT thCity,thState) AS numCityCover, count(thName) AS numTheater FROM theater GROUP BY comName) AS theaterInfo
	LEFT JOIN
		(SELECT comName, count(username) AS numEmployee FROM manager GROUP BY comName) AS manInfo
	ON theaterInfo.comName = manInfo.comName) AS comFilter
    WHERE
		(comName = i_comName OR i_comName = "" OR i_comName = "ALL") AND
		(i_minCity = "" OR numCityCover >= i_minCity OR i_minCity IS NULL) AND
        (i_maxCity = "" OR numCityCover<= i_maxCity OR i_maxCity IS NULL) AND
        (i_minTheater = "" OR numTheater >= i_minTheater OR i_minTheater IS NULL) AND
        (i_maxTheater = "" OR numTheater<= i_maxTheater OR i_maxTheater IS NULL) AND
        (i_minEmployee = "" OR numEmployee >= i_minEmployee OR i_minEmployee IS NULL) AND
        (i_maxEmployee = "" OR numEmployee<= i_maxEmployee OR i_maxEmployee IS NULL)
	ORDER BY
			(CASE WHEN (i_sortDirection = 'DESC') or (i_sortDirection = '') THEN
					(CASE
						WHEN i_sortBy = 'comName' THEN comName
						WHEN i_sortBY = 'numCityCover' THEN numCityCover
						WHEN i_sortBy = 'numTheater' THEN numTheater
						WHEN i_sortBy = 'numEmployee' THEN numEmployee
						ELSE comName
					END)
				END) DESC,
			(CASE WHEN (i_sortDirection = 'ASC') THEN
					(CASE
						WHEN i_sortBy = 'comName' THEN comName
						WHEN i_sortBY = 'numCityCover' THEN numCityCover
						WHEN i_sortBy = 'numTheater' THEN numTheater
						WHEN i_sortBy = 'numEmployee' THEN numEmployee
						ELSE comName
					END)
				END) ASC
;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `admin_filter_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_filter_user`(IN i_username VARCHAR(50), IN i_status VARCHAR(50), IN i_sortBy VARCHAR(50), IN i_sortDirection VARCHAR(50))
BEGIN
	DROP TABLE IF EXISTS AdFilterUser;
    CREATE TABLE AdFilterUser
    SELECT username,creditCardCount,
    (CASE
		WHEN isUser = 1 THEN 'User'
        WHEN isCustomer = 1 AND isAdmin = 0 AND isManager = 0 THEN 'Customer'
        WHEN isCustomer = 1 AND isAdmin = 1 AND isUser = 0 THEN 'CustomerAdmin'
        WHEN isCustomer = 1 AND isManager = 1 AND isUser = 0 THEN 'CustomerManager'
        WHEN isCustomer = 0 AND isAdmin = 1 AND isUser = 0 THEN 'Admin'
        WHEN isCustomer = 0 AND isManager = 1 AND isUser = 0 THEN 'Manager'
	END) AS userType, status
    FROM (
		SELECT user.username as username, creditCardCount, status, isCustomer, isUser, ifnull(isAdmin,0) as isAdmin, ifnull(isManager,0) as isManager
		FROM user left join employee on user.username = employee.username
		left join
		(SELECT user.username,ifnull(creditCardCount,0) as creditCardCount
		FROM user left join (select username, count(creditCardNum) as creditCardCount from customercreditcard group by customercreditcard.username) as cCardCount
		on user.username = cCardCount.username) as cardInfo
		on user.username = cardInfo.username) as userInfo
WHERE
	(username = i_username OR i_username = "") AND
	(status = i_status OR i_status = "ALL")
ORDER BY
		(CASE WHEN (i_sortDirection = 'DESC') or (i_sortDirection = "") THEN
				(CASE
					WHEN i_sortBy = 'username' THEN username
					WHEN i_sortBY = 'creditCardCount' THEN creditCardCount
					WHEN i_sortBy = 'userType' THEN userType
					WHEN i_sortBy = 'status' THEN status
					ELSE username
				END)
			END) DESC,
		(CASE WHEN (i_sortDirection = 'ASC') THEN
				(CASE
					WHEN i_sortBy = 'username' THEN username
					WHEN i_sortBY = 'creditCardCount' THEN creditCardCount
					WHEN i_sortBy = 'userType' THEN userType
					WHEN i_sortBy = 'status' THEN status
					ELSE username
				END)
			END) ASC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `admin_view_comDetail_emp` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_view_comDetail_emp`(IN i_comName VARCHAR(50))
BEGIN
    DROP TABLE IF EXISTS AdComDetailEmp;
    CREATE TABLE AdComDetailEmp
    SELECT firstName as empFirstname, lastName as empLastname
    FROM manager
    NATURAL JOIN user
    WHERE
		(i_comName = comName OR i_comName = "ALL");
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `admin_view_comDetail_th` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_view_comDetail_th`(IN i_comName VARCHAR(50))
BEGIN
    DROP TABLE IF EXISTS AdComDetailTh;
    CREATE TABLE AdComDetailTh
    SELECT thName, manUsername as thManagerUsername, thCity, thState, capacity as thCapacity
    FROM company
    NATURAL JOIN theater
    WHERE
		(i_comName = comName OR i_comName = "ALL");
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `customer_add_credicard` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_add_credicard`(IN i_username VARCHAR(50), IN i_creditCardNum CHAR(16))
BEGIN
		INSERT INTO customercreditcard (username, creditCardNum) VALUES (i_username, i_creditCardNum);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `customer_add_creditcard` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_add_creditcard`(IN i_username VARCHAR(50), IN i_creditCardNum CHAR(16))
BEGIN
		INSERT INTO customercreditcard (username, creditCardNum) VALUES (i_username, i_creditCardNum);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `customer_filter_mov` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_filter_mov`(IN i_movName VARCHAR(50), IN i_comName VARCHAR(50), IN i_city VARCHAR(50), IN i_state CHAR(3), IN i_minMovPlayDate DATE, IN i_maxMovPlayDate DATE)
BEGIN
    DROP TABLE IF EXISTS CosFilterMovie;
    CREATE TABLE CosFilterMovie
    SELECT movName, thName, thStreet, thCity, thState, thZipcode, comName, movPlayDate, movReleaseDate
    FROM theater
    NATURAL JOIN movieplay
    WHERE
		(movName = i_movName or i_movName = "ALL") AND
        (comName = i_comName or i_comName = "ALL") AND
        (thCity = i_city or i_city = "" OR i_city = "ALL") AND
        (thState = i_state or i_state = "ALL" or i_state = "") AND
        (i_minMovPlayDate IS NULL OR movPlayDate >= i_minMovPlayDate) AND
        (i_maxMovPlayDate IS NULL OR movPlayDate <= i_maxMovPlayDate);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `customer_only_register` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_only_register`(IN i_username VARCHAR(50), IN i_password VARCHAR(50), IN i_firstname VARCHAR(50), IN i_lastname VARCHAR(50))
BEGIN
		INSERT INTO user (username, password, firstname, lastname, isCustomer) VALUES (i_username, i_password, i_firstname, i_lastname,1);
		INSERT INTO customer (username) VALUES (i_username);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `customer_view_history` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_view_history`(IN i_cusUsername VARCHAR(50))
BEGIN
    DROP TABLE IF EXISTS CosViewHistory;
    CREATE TABLE CosViewHistory
    SELECT movName, thName, comName, creditCardNum, movPlayDate
    FROM customerviewmovie
    NATURAL JOIN customercreditcard
    WHERE
		i_cusUsername = username;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `customer_view_mov` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_view_mov`(IN  i_creditCardNum CHAR(16), IN i_movName VARCHAR(50), IN i_movReleaseDate DATE, IN i_thName VARCHAR(50), IN i_comName VARCHAR(50), IN i_movPlayDate DATE)
BEGIN
    INSERT INTO customerviewmovie (creditcardnum, thName, comName, movName, movReleaseDate, movPlayDate)
    VALUES (i_creditCardNum, i_thName, i_comName, i_movName, i_movReleaseDate, i_movPlayDate);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `manager_customer_add_creditcard` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `manager_customer_add_creditcard`(IN i_username VARCHAR(50), IN i_creditCardNum CHAR(16))
BEGIN
		INSERT INTO customercreditcard (username, creditCardNum) VALUES (i_username, i_creditCardNum);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `manager_customer_register` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `manager_customer_register`(IN i_username VARCHAR(50), IN i_password VARCHAR(50), IN i_firstname VARCHAR(50), IN i_lastname VARCHAR(50), IN i_comName VARCHAR(50), IN i_empStreet VARCHAR(50), IN i_empCity VARCHAR(50), IN i_empState CHAR(2), IN i_empZipcode CHAR(5))
BEGIN
		INSERT INTO user (username, password, firstname, lastname, isCustomer,isEmployee) VALUES (i_username, i_password, i_firstname, i_lastname,1,1);
        INSERT INTO employee (username, isAdmin, isManager) VALUES (i_username,0,1);
        INSERT INTO manager (username, comName, manStreet, manCity, manState, manZipcode) VALUES (i_username, i_comName, i_empStreet, i_empCity, i_empState, i_empZipcode);
		INSERT INTO customer (username) VALUES (i_username);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `manager_filter_th` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `manager_filter_th`(IN i_manUsername VARCHAR(50), IN i_movName VARCHAR(50), IN i_minMovDuration INT, IN i_maxMovDuration INT, IN i_minMovReleaseDate DATE, IN i_maxMovReleaseDate DATE, IN i_minMovPlayDate DATE, IN i_maxMovPlayDate DATE, i_includeNotPlayed BOOL)
BEGIN
    DROP TABLE IF EXISTS ManFilterTh;
    if i_includeNotPlayed = True THEN
    CREATE TABLE ManFilterTh
    SELECT movName, duration as movDuration, movReleaseDate, null as movPlayDate
    FROM movie
    WHERE (i_minMovDuration IS NULL OR duration >= i_minMovDuration)
    AND (i_maxMovDuration IS NULL OR duration <= i_maxMovDuration)
    AND (i_minMovReleaseDate IS NULL OR movReleaseDate >= i_minMovReleaseDate)
    AND (i_maxMovReleaseDate IS NULL OR movReleaseDate <= i_maxMovReleaseDate)
	AND (movName NOT IN
    (SELECT DISTINCT movName FROM movieplay
    INNER JOIN theater ON theater.thName = movieplay.thName AND theater.comName = movieplay.comName
	WHERE manUsername = i_manUsername AND movName LIKE CONCAT('%', i_movName, '%')));

    ELSE
    CREATE TABLE ManFilterTh
	SELECT movName, duration as movDuration, movReleaseDate, null as movPlayDate
    FROM movie
    WHERE (i_minMovDuration IS NULL or duration >= i_minMovDuration)
    AND (i_maxMovDuration IS NULL or duration <= i_maxMovDuration)
    AND (i_minMovReleaseDate IS NULL OR movReleaseDate >= i_minMovReleaseDate)
    AND (i_maxMovReleaseDate IS NULL OR movReleaseDate <= i_maxMovReleaseDate)
    AND (movName NOT IN
    (SELECT DISTINCT movName FROM movieplay INNER JOIN theater ON theater.thName = movieplay.thName AND theater.comName = movieplay.comName
	WHERE manUsername = i_manUsername AND movName LIKE CONCAT('%', i_movName, '%')))
    UNION
    SELECT movieplay.movName, movie.duration as movDuration, movieplay.movReleaseDate, movieplay.movPlayDate
    FROM movieplay, movie
    WHERE (SELECT thName FROM theater WHERE theater.manUsername = i_manUsername) = movieplay.thName
    AND movie.movName = movieplay.movName
    AND (i_minMovDuration IS NULL OR movie.duration >= i_minMovDuration)
    AND (i_maxMovDuration IS NULL OR movie.duration <= i_maxMovDuration)
    AND (i_minMovReleaseDate IS NULL OR movieplay.movReleaseDate >= i_minMovReleaseDate)
    AND (i_maxMovReleaseDate IS NULL OR movieplay.movReleaseDate <= i_maxMovReleaseDate)
    AND (i_minMovPlayDate IS NULL OR movieplay.movPlayDate >= i_minMovPlayDate)
    AND (i_maxMovPlayDate IS NULL OR movieplay.movPlayDate <= i_maxMovPlayDate)
    AND movieplay.movName IN (Select movName from movie where movName like CONCAT('%', i_movName, '%'));
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `manager_only_register` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `manager_only_register`(IN i_username VARCHAR(50), IN i_password VARCHAR(50), IN i_firstname VARCHAR(50), IN i_lastname VARCHAR(50), IN i_comName VARCHAR(50), IN i_empStreet VARCHAR(50), IN i_empCity VARCHAR(50), IN i_empState CHAR(2), IN i_empZipcode CHAR(5))
BEGIN
		INSERT INTO user (username, password, firstname, lastname,isEmployee) VALUES (i_username, i_password, i_firstname, i_lastname,1);
		INSERT INTO employee (username, isAdmin, isManager) VALUES (i_username, 0, 1);
        INSERT INTO manager (username, comName, manStreet, manCity, manState, manZipcode) VALUES (i_username, i_comName, i_empStreet, i_empCity, i_empState, i_empZipcode);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `manager_schedule_mov` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `manager_schedule_mov`(IN i_manUsername VARCHAR(50), IN i_movName VARCHAR(50), IN i_movReleaseDate DATE, IN i_movPlayDate DATE)
BEGIN
	INSERT INTO movieplay(thName, comName, movName, movReleaseDate, movPlayDate) VALUES((SELECT thName FROM team11.manager WHERE username = i_manUsername), (SELECT comName FROM team11.manager WHERE username = i_manUsername), i_movName, i_movReleaseDate, i_movPlayDate);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `user_filter_th` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_filter_th`(IN i_thName VARCHAR(50), IN i_comName VARCHAR(50), IN i_city VARCHAR(50), IN i_state VARCHAR(3))
BEGIN
    DROP TABLE IF EXISTS UserFilterTh;
    CREATE TABLE UserFilterTh
	SELECT thName, thStreet, thCity, thState, thZipcode, comName
    FROM Theater
    WHERE
		(thName = i_thName OR i_thName = "ALL" OR i_thName = "") AND
        (comName = i_comName OR i_comName = "ALL" OR i_comName = "") AND
        (thCity = i_city OR i_city = "" OR i_city = "ALL") AND
        (thState = i_state OR i_state = "ALL" OR i_state = "");
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `user_filter_visitHistory` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_filter_visitHistory`(IN i_username VARCHAR(50), IN i_minVisitDate DATE, IN i_maxVisitDate DATE)
BEGIN
    DROP TABLE IF EXISTS UserVisitHistory;
    CREATE TABLE UserVisitHistory
	SELECT thName, thStreet, thCity, thState, thZipcode, comName, visitDate
    FROM UserVisitTheater
		NATURAL JOIN
        Theater
	WHERE
		(username = i_username) AND
        (i_minVisitDate IS NULL OR visitDate >= i_minVisitDate) AND
        (i_maxVisitDate IS NULL OR visitDate <= i_maxVisitDate);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `user_login` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_login`(IN i_username VARCHAR(50), IN i_password VARCHAR(50))
BEGIN
  DROP TABLE IF EXISTS UserLogin;
  CREATE TABLE UserLogin
  SELECT user.username, status, isCustomer, i_username IN (SELECT username from admin) AS isAdmin, i_username IN (SELECT username from manager) AS isManager
	FROM user left join employee on user.username = employee.username
	WHERE user.username = i_username and  user.password=i_password;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `user_register` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_register`(IN i_username VARCHAR(50), IN i_password VARCHAR(50), IN i_firstname VARCHAR(50), IN i_lastname VARCHAR(50))
BEGIN
		INSERT INTO user (username, password, firstname, lastname, isUser) VALUES (i_username, i_password, i_firstname, i_lastname,1);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `user_visit_th` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_visit_th`(IN i_thName VARCHAR(50), IN i_comName VARCHAR(50), IN i_visitDate DATE, IN i_username VARCHAR(50))
BEGIN
    INSERT INTO UserVisitTheater (thName, comName, visitDate, username)
    VALUES (i_thName, i_comName, i_visitDate, i_username);
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

-- Dump completed on 2019-11-29 16:38:19

USE team11;

-- SCREEN 1

DROP PROCEDURE IF EXISTS `user_login`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_login`(IN i_username VARCHAR(50), IN i_password VARCHAR(50))
BEGIN
	DROP TABLE IF EXISTS UserLogin;
    CREATE TABLE UserLogin
    SELECT user.username, status, isCustomer, ifnull(isAdmin,0) as isAdmin, ifnull(isManager,0) as isManager
	FROM user left join employee on user.username = employee.username
	WHERE user.username = i_username and  user.password=i_password;
END$$
DELIMITER ;

-- SCREEN 3--

DROP PROCEDURE IF EXISTS `user_register`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_register`(IN i_username VARCHAR(50), IN i_password VARCHAR(50), IN i_firstname VARCHAR(50), IN i_lastname VARCHAR(50))
BEGIN
		INSERT INTO user (username, password, firstname, lastname) VALUES (i_username, MD5(i_password), i_firstname, i_lastname);
END$$
DELIMITER ;

-- SCREEN 4--

DROP PROCEDURE IF EXISTS `customer_only_register`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_only_register`(IN i_username VARCHAR(50), IN i_password VARCHAR(50), IN i_firstname VARCHAR(50), IN i_lastname VARCHAR(50))
BEGIN
		INSERT INTO user (username, password, firstname, lastname, isCustomer) VALUES (i_username, MD5(i_password), i_firstname, i_lastname,1);
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `customer_add_credicard`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_add_credicard`(IN i_username VARCHAR(50), IN i_creditCardNum CHAR(16))
BEGIN
		INSERT INTO customercreditcard (username, creditCardNum) VALUES (i_username, i_creditCardNum);
END$$
DELIMITER ;

-- SCREEN 5--

DROP PROCEDURE IF EXISTS `manager_only_register`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `manager_only_register`(IN i_username VARCHAR(50), IN i_password VARCHAR(50), IN i_firstname VARCHAR(50), IN i_lastname VARCHAR(50), IN i_comName VARCHAR(50), IN i_empStreet VARCHAR(50), IN i_empCity VARCHAR(50), IN i_empState CHAR(2), IN i_empZipcode CHAR(5))
BEGIN
		INSERT INTO user (username, password, firstname, lastname) VALUES (i_username, MD5(i_password), i_firstname, i_lastname);
        INSERT INTO manager (username, comName, manStreet, manCity, manState, manZipcode) VALUES (i_username, i_comName, i_empStreet, i_empCity, i_empState, i_empZipcode);
END$$
DELIMITER ;

-- SCREEN 6--

DROP PROCEDURE IF EXISTS `manager_customer_register`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `manager_customer_register`(IN i_username VARCHAR(50), IN i_password VARCHAR(50), IN i_firstname VARCHAR(50), IN i_lastname VARCHAR(50), IN i_comName VARCHAR(50), IN i_empStreet VARCHAR(50), IN i_empCity VARCHAR(50), IN i_empState CHAR(2), IN i_empZipcode CHAR(5))
BEGIN
		INSERT INTO user (username, password, firstname, lastname, isCustomer) VALUES (i_username, MD5(i_password), i_firstname, i_lastname,1);
        INSERT INTO manager (username, comName, manStreet, manCity, manState, manZipcode) VALUES (i_username, i_comName, i_empStreet, i_empCity, i_empState, i_empZipcode);
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `manager_customer_add_creditcard`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `manager_customer_add_creditcard`(IN i_username VARCHAR(50), IN i_creditCardNum CHAR(16))
BEGIN
		INSERT INTO customercreditcard (username, creditCardNum) VALUES (i_username, i_creditCardNum);
END$$
DELIMITER ;

-- SCREEN 13--

DROP PROCEDURE IF EXISTS `admin_approve_user`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_approve_user`(IN i_username VARCHAR(50))
BEGIN
		UPDATE user
        SET status = 'Approved'
        WHERE username = i_username;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `admin_decline_user`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_decline_user`(IN i_username VARCHAR(50))
BEGIN
		UPDATE user
        SET status = 'Declined'
        WHERE username = i_username;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `admin_filter_user`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_filter_user`(IN i_username VARCHAR(50), IN i_status VARCHAR(50), IN i_sortBy VARCHAR(50), IN i_sortDirection VARCHAR(50))
BEGIN
	DROP TABLE IF EXISTS AdFilterUser;
    CREATE TABLE AdFilterUser
    SELECT username,creditCardCount,status,
    (CASE
		WHEN isUser = 1 THEN 'User'
        WHEN isCustomer = 1 THEN 'Customer'
        WHEN isCustomer = 1 AND isAdmin = 1 THEN 'CustomerAdmin'
        WHEN isCustomer = 1 AND isManager = 1 THEN 'CustomerManager'
        WHEN isAdmin = 1 THEN 'Admin'
        WHEN isManager = 1 THEN 'Manager'
	END) AS userType
    FROM (
		SELECT user.username as username, creditCardCount, status, isCustomer, isUser, ifnull(isAdmin,0) as isAdmin, ifnull(isManager,0) as isManager
		FROM user left join employee on user.username = employee.username
		left join 
		(SELECT user.username,ifnull(creditCardCount,0) as creditCardCount
		FROM user left join (select username, count(creditCardNum) as creditCardCount from customercreditcard group by customercreditcard.username) as cCardCount
		on user.username = cCardCount.username) as cardInfo
		on user.username = cardInfo.username) as userInfo
WHERE 
	(username = i_username) AND
	(status = i_status OR i_status = "ALL") 
ORDER BY 
		(CASE WHEN (i_sortDirection = 'DESC') or (i_sortDirection = '') THEN 
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
END$$
DELIMITER ;

-- Last one done - Screen 13: Admin filter user

-- SCREEN 14--

-- INSERT CODE HERE--

-- SCREEN 15--

-- INSERT CODE HERE--

-- SCREEN 16--

-- INSERT CODE HERE--

-- SCREEN 17--

-- INSERT CODE HERE--

-- SCREEN 18--

-- INSERT CODE HERE--

-- SCREEN 19--

DROP PROCEDURE IF EXISTS `manager_schedule_mov`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `manager_schedule_mov`(IN i_manUsername VARCHAR(50), IN i_movName VARCHAR(50), IN i_movReleaseDate DATE, IN i_movPlayDate DATE)
BEGIN
	INSERT INTO movieplay(thName, comName, movName, movReleaseDate, movPlayDate) VALUES((SELECT thName FROM team11.manager WHERE username = i_manUsername), (SELECT comName FROM team11.manager WHERE username = i_manUsername), i_movName, i_movReleaseDate, i_movPlayDate);
END$$
DELIMITER ;

-- SCREEN 20--

DROP PROCEDURE IF EXISTS `customer_filter_mov`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_filter_mov`(IN i_movName VARCHAR(50), IN i_comName VARCHAR(50), IN i_city VARCHAR(50), IN i_state CHAR(3), IN i_minMovPlayDate DATE, IN i_maxMovPlayDate DATE)
BEGIN
    DROP TABLE IF EXISTS CosFilterMovie;
    CREATE TABLE CosFilterMovie
    SELECT (movName, thName, thStreet, thCity, thState, thZipcode, comName, movPlayDate, movReleaseDate)
    FROM theater
    NATURAL JOIN movieplay
    WHERE
	(i_movName = movName or i_movName = "ALL") AND
        (i_comName = comName or i_comName = "ALL") AND
        (i_city = thCity or i_city = "ALL") AND
        (i_state = thState or i_state = "ALL") AND
        (i_minMovPlayDate IS NULL OR movPlayDate >= i_minMovPlayDate) AND
        (i_maxMovPlayDate IS NULL OR movPlayDate <= i_maxMovPlayDate);
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `customer_view_mov`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_view_mov`(IN  i_creditCardNum CHAR(16), IN i_movName VARCHAR(50), IN i_movReleaseDate DATE, IN i_thName VARCHAR(50), IN i_comName VARCHAR(50), IN i_movPlayDate DATE)
BEGIN
    INSERT INTO customerviewmovie (creditcardnum, thName, comName, movName, movReleaseDate, movPlayDate)
    VALUES (i_creditCardNum, i_thName, i_comName, i_movName, i_movReleaseDate, i_movPlayDate);
END$$
DELIMITER ;

-- SCREEN 21--

DROP PROCEDURE IF EXISTS `customer_view_history`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_view_history`(IN i_cusUsername VARCHAR(50))
BEGIN
    DROP TABLE IF EXISTS CosViewHistory;
    CREATE TABLE CosViewHistory
    SELECT movName, thName, comName, creditCardNum, movPlayDate
    FROM customerviewmovie
    NATURAL JOIN customercreditcard
    WHERE
		(i_cusUsername = username OR i_cusUsername = "ALL");
END$$
DELIMITER ;

-- SCREEN 22--

DROP PROCEDURE IF EXISTS `user_filter_th`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_filter_th`(IN i_thName VARCHAR(50), IN i_comName VARCHAR(50), IN i_city VARCHAR(50), IN i_state VARCHAR(3))
BEGIN
    DROP TABLE IF EXISTS UserFilterTh;
    CREATE TABLE UserFilterTh
	SELECT thName, thStreet, thCity, thState, thZipcode, comName
    FROM Theater
    WHERE
		(thName = i_thName OR i_thName = "ALL") AND
        (comName = i_comName OR i_comName = "ALL") AND
        (thCity = i_city OR i_city = "") AND
        (thState = i_state OR i_state = "ALL");
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `user_visit_th`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_visit_th`(IN i_thName VARCHAR(50), IN i_comName VARCHAR(50), IN i_visitDate DATE, IN i_username VARCHAR(50))
BEGIN
    INSERT INTO UserVisitTheater (thName, comName, visitDate, username)
    VALUES (i_thName, i_comName, i_visitDate, i_username);
END$$
DELIMITER ;

-- SCREEN 23--

DROP PROCEDURE IF EXISTS `user_filter_visitHistory`;
DELIMITER $$
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
END$$
DELIMITER ;

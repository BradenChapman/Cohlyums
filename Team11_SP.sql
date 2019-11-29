USE team11;

-- SCREEN 1 --

DROP PROCEDURE IF EXISTS `user_login`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_login`(IN i_username VARCHAR(50), IN i_password VARCHAR(50))
BEGIN
  DROP TABLE IF EXISTS UserLogin;
  CREATE TABLE UserLogin
  SELECT user.username, status, isCustomer, i_username IN (SELECT username from admin) AS isAdmin, i_username IN (SELECT username from manager) AS isManager
	FROM user left join employee on user.username = employee.username
	WHERE user.username = i_username and  user.password=i_password;
END$$
DELIMITER ;

-- SCREEN 3 --

DROP PROCEDURE IF EXISTS `user_register`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_register`(IN i_username VARCHAR(50), IN i_password VARCHAR(50), IN i_firstname VARCHAR(50), IN i_lastname VARCHAR(50))
BEGIN
		INSERT INTO user (username, password, firstname, lastname, isUser) VALUES (i_username, i_password, i_firstname, i_lastname,1);
END$$
DELIMITER ;

-- SCREEN 4 --

DROP PROCEDURE IF EXISTS `customer_only_register`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_only_register`(IN i_username VARCHAR(50), IN i_password VARCHAR(50), IN i_firstname VARCHAR(50), IN i_lastname VARCHAR(50))
BEGIN
		INSERT INTO user (username, password, firstname, lastname, isCustomer) VALUES (i_username, i_password, i_firstname, i_lastname,1);
		INSERT INTO customer (username) VALUES (i_username);
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `customer_add_creditcard`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `customer_add_creditcard`(IN i_username VARCHAR(50), IN i_creditCardNum CHAR(16))
BEGIN
		INSERT INTO customercreditcard (username, creditCardNum) VALUES (i_username, i_creditCardNum);
END$$
DELIMITER ;

-- SCREEN 5--

DROP PROCEDURE IF EXISTS `manager_only_register`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `manager_only_register`(IN i_username VARCHAR(50), IN i_password VARCHAR(50), IN i_firstname VARCHAR(50), IN i_lastname VARCHAR(50), IN i_comName VARCHAR(50), IN i_empStreet VARCHAR(50), IN i_empCity VARCHAR(50), IN i_empState CHAR(2), IN i_empZipcode CHAR(5))
BEGIN
		INSERT INTO user (username, password, firstname, lastname,isEmployee) VALUES (i_username, i_password, i_firstname, i_lastname,1);
		INSERT INTO employee (username, isAdmin, isManager) VALUES (i_username, 0, 1);
        INSERT INTO manager (username, comName, manStreet, manCity, manState, manZipcode) VALUES (i_username, i_comName, i_empStreet, i_empCity, i_empState, i_empZipcode);
END$$
DELIMITER ;

-- SCREEN 6--

DROP PROCEDURE IF EXISTS `manager_customer_register`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `manager_customer_register`(IN i_username VARCHAR(50), IN i_password VARCHAR(50), IN i_firstname VARCHAR(50), IN i_lastname VARCHAR(50), IN i_comName VARCHAR(50), IN i_empStreet VARCHAR(50), IN i_empCity VARCHAR(50), IN i_empState CHAR(2), IN i_empZipcode CHAR(5))
BEGIN
		INSERT INTO user (username, password, firstname, lastname, isCustomer,isEmployee) VALUES (i_username, i_password, i_firstname, i_lastname,1,1);
        INSERT INTO manager (username, comName, manStreet, manCity, manState, manZipcode) VALUES (i_username, i_comName, i_empStreet, i_empCity, i_empState, i_empZipcode);
		INSERT INTO customer (username) VALUES (i_username);
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
END$$
DELIMITER ;

-- SCREEN 14--

DROP PROCEDURE IF EXISTS `admin_filter_company`;
DELIMITER $$
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
END$$
DELIMITER ;

-- SCREEN 15--

DROP PROCEDURE IF EXISTS `admin_create_theater`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_create_theater`(IN i_thName VARCHAR(30),
	IN i_comName VARCHAR(30), IN i_thStreet VARCHAR(45), IN i_thCity VARCHAR(45),
    IN i_thState CHAR(2), IN i_thZipcode CHAR(11), IN i_capacity INT(11), IN i_managerUsername VARCHAR(45))
BEGIN
	insert into theater (thName, comName, thStreet, thCity, thState, thZipcode, capacity, manUsername)
    values (i_thName, i_comName, i_thStreet, i_thCity, i_thState, i_thZipcode, i_capacity, i_managerUsername);
END $$
DELIMITER ;

-- SCREEN 16--

DROP PROCEDURE IF EXISTS `admin_view_comDetail_emp`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_view_comDetail_emp`(IN i_comName VARCHAR(50))
BEGIN
    DROP TABLE IF EXISTS AdComDetailEmp;
    CREATE TABLE AdComDetailEmp
    SELECT firstName as empFirstname, lastName as empLastname
    FROM manager
    NATURAL JOIN user
    WHERE
		(i_comName = comName OR i_comName = "ALL");
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS `admin_view_comDetail_th`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_view_comDetail_th`(IN i_comName VARCHAR(50))
BEGIN
    DROP TABLE IF EXISTS AdComDetailTh;
    CREATE TABLE AdComDetailTh
    SELECT thName, manUsername as thManagerUsername, thCity, thState, capacity as thCapacity
    FROM company
    NATURAL JOIN theater
    WHERE
		(i_comName = comName OR i_comName = "ALL");
END$$
DELIMITER ;

-- SCREEN 17--

DROP PROCEDURE IF EXISTS `admin_create_mov`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_create_mov`(IN i_movName VARCHAR(50), IN i_movDuration INT, IN i_movReleaseDate DATE)
BEGIN
    INSERT INTO movie (movName, movReleaseDate, duration)
    VALUES (i_movName, i_movReleaseDate, i_movDuration);
END$$
DELIMITER ;

-- SCREEN 18--

DROP PROCEDURE IF EXISTS `manager_filter_th`;
DELIMITER $$
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
END$$
DELIMITER ;

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
		i_cusUsername = username;
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
		(thName = i_thName OR i_thName = "ALL" OR i_thName = "") AND
        (comName = i_comName OR i_comName = "ALL" OR i_comName = "") AND
        (thCity = i_city OR i_city = "" OR i_city = "ALL") AND
        (thState = i_state OR i_state = "ALL" OR i_state = "");
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

USE PI;

DROP PROCEDURE IF EXISTS get_consumer_profile;
DROP PROCEDURE IF EXISTS get_reviews;
DROP PROCEDURE IF EXISTS get_sp_category_info;
DROP PROCEDURE IF EXISTS get_average_rating;
DROP PROCEDURE IF EXISTS get_service_provider_profile;
DROP PROCEDURE IF EXISTS get_service_provider_profile_v2;
DROP PROCEDURE IF EXISTS get_company_profile;
DROP PROCEDURE IF EXISTS get_user_image;

-- Returns: average rating or null if no reviews
DELIMITER &&  
CREATE PROCEDURE get_average_rating (IN id INT)  
BEGIN  
    SELECT AVG(rating) FROM review WHERE id = review.idReceive;
END &&  
DELIMITER ;

-- Returns: returns all info about categories that belongs to a specific SP
DELIMITER &&
CREATE PROCEDURE get_sp_category_info (IN id INT)
BEGIN
	SELECT category.name, category_has_serviceprovider.experience, category_has_serviceprovider.workSchedule, 
		category_has_serviceprovider.price FROM user
	INNER JOIN category_has_serviceprovider ON user.idUser = category_has_serviceprovider.idServiceProvider
    INNER JOIN category ON category_has_serviceprovider.idCategory = category.idCategory WHERE id = user.idUser;
END &&
DELIMITER ;

-- Returns: returns all the reviews for a specific user
DELIMITER &&  
CREATE PROCEDURE get_reviews (IN id INT)  
BEGIN  
    SELECT description,rating,postDate, user.name FROM review
    INNER JOIN user ON review.idGive = user.idUser WHERE id = review.idReceive;
END &&  
DELIMITER ;  


-- Returns: returns information for a specific service provider
DELIMITER &&  
CREATE PROCEDURE get_service_provider_profile (IN id INT)  
BEGIN  
    SELECT user.idUser, user.name, user.email, user.phoneNumber, user.sex, user.lastActivity, user.active, serviceprovider.description, serviceprovider.averageRating, 
		serviceprovider.dateOfBirth, serviceprovider.distance, serviceprovider.qualifications, location.name as locationName, location.cordsX, location.cordsY, file.image FROM user
    INNER JOIN location ON user.idLocation = location.idLocation
    INNER JOIN serviceprovider ON user.idUser = serviceprovider.idSP 
    INNER JOIN file ON user.idUser = file.idUser WHERE id = user.idUser;
END &&  
DELIMITER ; 

-- Returns: returns information for a specific consumer
DELIMITER &&  
CREATE PROCEDURE get_consumer_profile (IN em VARCHAR(90))
BEGIN
	SELECT user.idUser, user.name, user.email, user.phoneNumber, user.sex, user.type, user.createdAt, user.lastActivity, user.active, location.name as locationName, location.cordsX, location.cordsY, file.image FROM user
	INNER JOIN location ON user.idLocation = location.idLocation
    INNER JOIN file ON user.idUser = file.idUser WHERE em = user.email;
END &&
DELIMITER ;

-- Returns: returns information for a specific service provider
DELIMITER &&  
CREATE PROCEDURE get_service_provider_profile_v2 (IN em VARCHAR(90))  
BEGIN  
    SELECT user.idUser, user.name, user.email, user.phoneNumber, user.sex, user.lastActivity,user.active, serviceprovider.description, serviceprovider.endSub, serviceprovider.endSubVip, 
		serviceprovider.averageRating, serviceprovider.dateOfBirth, serviceprovider.distance, serviceprovider.qualifications, location.name as locationName, location.cordsX, location.cordsY, 
        subscription.type as subType, subscription.duration as subDuration, subscription.value as subValue, file.image FROM user
	INNER JOIN location ON user.idLocation = location.idLocation
    INNER JOIN serviceprovider ON user.idUser = serviceprovider.idSP
    INNER JOIN  subscription ON serviceprovider.idSubscription = subscription.idSubscription
    INNER JOIN file ON user.idUser = file.idUser WHERE em = user.email;
END &&  
DELIMITER ;

-- Returns: returns information for a specific company
DELIMITER &&
CREATE PROCEDURE get_company_profile (IN em VARCHAR(90))
BEGIN
	SELECT user.idUser, user.name, user.email, user.phoneNumber, user.sex, user.type, user.createdAt, user.lastActivity, user.active, location.name as locationName, location.cordsX, location.cordsY,
		   company.link, company.firm, company.nipc, company.endSub, company.endSubVip, pi.add.description, subscription.type as subType, subscription.duration as subDuration, subscription.value as subValue, file.image FROM user
	INNER JOIN location ON user.idLocation = location.idLocation
    INNER JOIN company ON user.idUser = company.idCompany
    INNER JOIN pi.add ON pi.add.idCompany = company.idCompany
    INNER JOIN  subscription ON company.idSubscription = subscription.idSubscription
    INNER JOIN file ON user.idUser = file.idUser WHERE em = user.email;
END &&
DELIMITER ;

DELIMITER &&
CREATE PROCEDURE get_user_image (IN em VARCHAR(90))
BEGIN
	SELECT file.image FROM user
    INNER JOIN file ON user.idUser = file.idUser WHERE em = user.email;
END &&
DELIMITER ;
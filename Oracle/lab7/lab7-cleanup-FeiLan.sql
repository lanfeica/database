-- Cleanup for lab7

DROP PROCEDURE lanUser.sp_checkInvalidPostalCode;
DROP PROCEDURE lanUser.sp_checkInvalidTelephone;
DROP USER lanUser CASCADE;
DROP USER testUser;
DROP ROLE applicationAdmin;
DROP ROLE applicationUser;
DROP TABLESPACE CST2355 INCLUDING CONTENTS AND DATAFILES;

-- End of File
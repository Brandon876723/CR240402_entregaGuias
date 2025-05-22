CREATE LOGIN sakila_user
WITH PASSWORD = '1234';

CREATE USER sakila_user FOR LOGIN sakila_user;
EXEC sp_addrolemember 'db_datareader', 'sakila_user';
EXEC sp_addrolemember 'db_ddladmin', 'sakila_user';
DROP USER sakila_user;
GO
DROP LOGIN sakila_user;
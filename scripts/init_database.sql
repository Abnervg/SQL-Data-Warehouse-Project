/*
=================================
 Create Database and Schemas
=================================

Script Purpose:
	Creates a new database called "DataWarehouse" after checking if it exists already.
	If the database exists, it is dropped and recreated. 
	Aditionally, the script sets up three schemas within the database: bronze, silver and gold.

Warning:
	Running this script will drop the entire database if exists.
	All data in the database will be permanently deleted. 
	Proceed with caution and ensure you have proper backups before using this script.

*/

USE master;

GO

-- Drop and recreate the database
IF EXISTS(SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')

BEGIN
	
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;

END;

GO

-- Create the database

CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO

CREATE DATABASE SQL_IMDB;
USE SQL_IMDB;

CREATE TABLE Region(
idRegion INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
region VARCHAR(80) UNIQUE NOT NULL
);

CREATE TABLE _Language(
idLanguage INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
_language VARCHAR(45) UNIQUE NOT NULL
);

CREATE TABLE AlternateType(
idAlternate INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
type VARCHAR(45) UNIQUE NOT NULL
);


CREATE TABLE Genre(
idGenre INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
genre VARCHAR(200) UNIQUE NOT NULL
);

CREATE TABLE TitleType(
idTitleType INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
titleType VARCHAR(45) UNIQUE NOT NULL
);

CREATE TABLE _Name(
idName VARCHAR(30) NOT NULL PRIMARY KEY,
primaryName VARCHAR(400),
birthYear VARCHAR(4),
deathYear VARCHAR(4)
);

CREATE TABLE Profession(
idProfession INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
profession VARCHAR(400) UNIQUE NOT NULL
);


CREATE TABLE Title(
idTitle VARCHAR(30) NOT NULL PRIMARY KEY,
originalTitle VARCHAR(500),
primaryTitle VARCHAR(500),
isAdult TINYINT,
startYear VARCHAR(4),
endYear VARCHAR(4),
runTimeMinutes INT,
TitleType_idTitleType INT NOT NULL,
FOREIGN KEY(TitleType_idTitleType) REFERENCES TitleType(idTitleType)
);

ALTER TABLE Title
ALTER COLUMN endYear VARCHAR(4)

CREATE TABLE Title_has_Genre(
idTitleGenre INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
Title_idTitle VARCHAR(30) NOT NULL,
Genre_idGenre INT NOT NULL,
FOREIGN KEY(Title_idTitle) REFERENCES Title(idTitle),
FOREIGN KEY(Genre_idGenre) REFERENCES Genre(idGenre)
);

CREATE TABLE TitleAKAs(
idTitleAKAs INT NOT NULL PRIMARY KEY IDENTITY(1,1),
orderingId SMALLINT,
title VARCHAR(2800),
attributes VARCHAR(200),
isOriginalTitle VARCHAR(2),
Region_idRegion INT NOT NULL,
Language_idLanguage INT NOT NULL,
Title_idTitle VARCHAR(30) NOT NULL,
FOREIGN KEY(Title_idTitle) REFERENCES Title(idTitle),
FOREIGN KEY(Language_idLanguage) REFERENCES _Language(idLanguage),
FOREIGN KEY(Region_idRegion) REFERENCES Region(idRegion)
);

ALTER TABLE TitleAKAs
ALTER COLUMN title VARCHAR(2800)



CREATE TABLE Title_has_Director(
idTitleDirector INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
Title_idTitle VARCHAR(30) NOT NULL,
Director_idDirector VARCHAR(30) NOT NULL,
FOREIGN KEY(Title_idTitle) REFERENCES Title(idTitle),
FOREIGN KEY(Director_idDirector) REFERENCES _Name(idName)
);

CREATE TABLE Title_has_Writer(
idTitleWriter INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
Title_idTitle VARCHAR(30) NOT NULL,
Writer_idWriter VARCHAR(30) NOT NULL,
FOREIGN KEY(Title_idTitle) REFERENCES Title(idTitle),
FOREIGN KEY(Writer_idWriter) REFERENCES _Name(idName)
);

CREATE TABLE Episode(
idEpisode VARCHAR(30) NOT NULL PRIMARY KEY,
season INT,
episode INT,
Title_idTitle VARCHAR(30) NOT NULL,
FOREIGN KEY(Title_idTitle) REFERENCES Title(idTitle)
);

CREATE TABLE KnownTitle(
idKnownTitle INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
Title_idTitle VARCHAR(30) NOT NULL,
Name_idName VARCHAR(30) NOT NULL,
FOREIGN KEY(Title_idTitle) REFERENCES Title(idTitle),
FOREIGN KEY(Name_idName) REFERENCES _Name(idName)
);

CREATE TABLE PrimaryProfession(
idPrimaryProfession INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
Name_idName VARCHAR(30) NOT NULL,
Profession_idProfession INT NOT NULL,
FOREIGN KEY(Name_idName) REFERENCES _Name(idName),
FOREIGN KEY(Profession_idProfession) REFERENCES Profession(idProfession)
);

CREATE TABLE Principal(
idPrincipal INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
category VARCHAR(MAX) NOT NULL,
job VARCHAR(MAX) NOT NULL,	
characters TEXT NOT NULL,
Title_idTitle VARCHAR(30) NOT NULL,
Name_idName VARCHAR(30) NOT NULL,
FOREIGN KEY(Title_idTitle) REFERENCES Title(idTitle),
FOREIGN KEY(Name_idName) REFERENCES _Name(idName)
);

CREATE TABLE Rating(
idRating INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
averageRating FLOAT,
numVotes INT,
Title_idTitle VARCHAR(30) NOT NULL,
FOREIGN KEY(Title_idTitle) REFERENCES Title(idTitle)
);

CREATE TABLE TitleAKAs_has_AlternateType(
idTitleAKAsAlternate INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
TitleAKAs_idTitleAKAs INT NOT NULL,
AlternateType_idAlternate INT NOT NULL,
FOREIGN KEY(TitleAKAs_idTitleAKAs) REFERENCES TitleAKAs(idTitleAKAs) ON DELETE CASCADE,
FOREIGN KEY(AlternateType_idAlternate) REFERENCES AlternateType(idAlternate) ON DELETE CASCADE
);

/* -- query to shrink the logs to free some disk space. --
 * ALTER DATABASE SQL_IMDB SET RECOVERY SIMPLE;
 * DBCC SHRINKFILE (SQL_IMDB_Log, 1);
 *
 */

/*
DROP TABLE Rating;
DROP TABLE Principal;
DROP TABLE KnownTitle;
DROP TABLE PrimaryProfession;
DROP TABLE Episode;
DROP TABLE Title_has_Writer;
DROP TABLE Title_has_Director;
DROP TABLE TitleAKAs;
DROP TABLE Title_has_Genre;
DROP TABLE Title;
DROP TABLE Profession;
DROP TABLE _Name;
DROP TABLE TitleType;
DROP TABLE Genre;
DROP TABLE AlternateType;
DROP TABLE _Language;
DROP TABLE Region;
DROP TABLE TitleAKAs_has_AlternateType;

*/


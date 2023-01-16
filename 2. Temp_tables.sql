USE SQL_IMDB;

CREATE TABLE TEMP_names_basics(
nconst VARCHAR(30),
primaryName VARCHAR(200),
birthYear VARCHAR(10),
deathYear VARCHAR(10),
primaryProfession VARCHAR(800),
knownForTitles VARCHAR(800)
);

CREATE TABLE TEMP_title_akas(
titleId VARCHAR(200), 
orderingId VARCHAR(30),
title VARCHAR(2800),
region VARCHAR(400),
_language VARCHAR(200),
_types VARCHAR(200),
attributes VARCHAR(500),
isOriginalTitle VARCHAR(10)
);



CREATE TABLE TEMP_title_basics(
tconst VARCHAR(200),
titleType VARCHAR(200),
primaryTitle VARCHAR(2800),
originalTitle VARCHAR(2800),
isAdult VARCHAR(10),
startYear VARCHAR(10),
endYear VARCHAR(10),
runTimeMinutes VARCHAR(10),
genres VARCHAR(110)
);

CREATE TABLE TEMP_title_crew(
tconst VARCHAR(200),
directors TEXT,
writers TEXT
);

CREATE TABLE TEMP_title_episode(
tconst VARCHAR(200),
parentTconst VARCHAR(200),
seasonNumber VARCHAR(10),
episodeNumber VARCHAR(10)
);

CREATE TABLE TEMP_title_principals(
tconst VARCHAR(200),
ordering VARCHAR(200),
nconst VARCHAR(200),
category VARCHAR(500),
job VARCHAR(500),
characters TEXT
);

CREATE TABLE TEMP_title_ratings(
tconst VARCHAR(200),
averageRating VARCHAR(10),
numVotes VARCHAR(10)
);

	 
BULK INSERT TEMP_title_ratings
FROM '/var/opt/mssql/data/carga_proyecto/title.ratings.tsv'
WITH
(
    FIRSTROW = 2, -- as 1st one is header
    FIELDTERMINATOR = '\t',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
);

BULK INSERT TEMP_names_basics
FROM '/var/opt/mssql/data/carga_proyecto/name.basics.tsv'
WITH
(
    FIRSTROW = 2, -- as 1st one is header
    FIELDTERMINATOR = '\t',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)

BULK INSERT TEMP_title_basics
FROM '/var/opt/mssql/data/carga_proyecto/title.basics.tsv'
WITH
(
    FIRSTROW = 2, -- as 1st one is header
    FIELDTERMINATOR = '\t',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)

BULK INSERT TEMP_title_crew
FROM '/var/opt/mssql/data/carga_proyecto/title.crew.tsv'
WITH
(
    FIRSTROW = 2, -- as 1st one is header
    FIELDTERMINATOR = '\t',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)


BULK INSERT TEMP_title_episode
FROM '/var/opt/mssql/data/carga_proyecto/title.episode.tsv'
WITH
(
    FIRSTROW = 2, -- as 1st one is header
    FIELDTERMINATOR = '\t',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)



BULK INSERT TEMP_title_principals
FROM '/var/opt/mssql/data/carga_proyecto/title.principals.tsv'
WITH
(
    FIRSTROW = 2, -- as 1st one is header
    FIELDTERMINATOR = '\t',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)
          
BULK INSERT TEMP_title_akas
FROM '/var/opt/mssql/data/carga_proyecto/title.akas.tsv'
WITH
(
    FIRSTROW = 2, -- as 1st one is header
    FIELDTERMINATOR = '\t',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)
      
SELECT COUNT(*) FROM TEMP_names_basics;
SELECT COUNT(*) FROM TEMP_title_ratings;
SELECT COUNT(*) FROM TEMP_title_episode;
SELECT COUNT(*) FROM TEMP_title_basics;
SELECT COUNT(*) FROM TEMP_title_crew;
SELECT COUNT(*) FROM TEMP_title_akas;
SELECT COUNT(*) FROM TEMP_title_principals;

/*
DROP TABLE TEMP_names_basics;
DROP TABLE TEMP_title_episode;
DROP TABLE TEMP_title_ratings;
DROP TABLE TEMP_title_basics;
DROP TABLE TEMP_title_crew;
DROP TABLE  TEMP_title_akas;
*/

      


USE SQL_IMDB;
-- CARGA TABLA REGION
INSERT INTO Region(region)
SELECT DISTINCT region FROM TEMP_title_akas 
WHERE region IS NOT NULL;

-- CARGA TABLA _Language
INSERT INTO _Language(_language)
SELECT DISTINCT _language FROM TEMP_title_akas
WHERE _Language IS NOT NULL;


-- CARGA TABLA AlternateType
INSERT INTO AlternateType(type)
SELECT DISTINCT value FROM TEMP_title_akas
CROSS APPLY STRING_SPLIT(_types, CHAR(2))

-- CARGA TABLA Genre
INSERT INTO Genre(genre)
SELECT DISTINCT value FROM TEMP_title_basics
CROSS APPLY STRING_SPLIT(genres, ',');

-- CARGA TABLA TitleType
INSERT INTO TitleType(titleType)
SELECT DISTINCT titleType FROM TEMP_title_basics;

-- CARGA TABLE Profession 
INSERT INTO Profession(profession)
SELECT DISTINCT value FROM TEMP_names_basics
CROSS APPLY STRING_SPLIT(primaryProfession, ',');


-- CARGA TABLA _Name
INSERT INTO _Name(idName, primaryName, birthYear, deathYear)
SELECT  nconst, primaryName, birthYear, deathYear FROM TEMP_names_basics;

-- CARGA TABLA PrimayProfession
INSERT INTO PrimaryProfession(Name_idName, Profession_idProfession)
SELECT N.idName, P.idProfession FROM _Name N, Profession P, 
	(SELECT value as nameProfession, nconst as nconst
			from TEMP_names_basics CROSS APPLY STRING_SPLIT(PrimaryProfession, ',') ) A
WHERE A.nconst = N.idName
AND P.profession = A.nameProfession


--CARGA TABLE Title

INSERT INTO Title(idTitle, originalTitle, primaryTitle, isAdult, 
				startYear, endYear, runTimeMinutes, TitleType_idTitleType)
SELECT T.tconst, T.originalTitle, T.primaryTitle, T.isAdult, T.startYear, T.endYear,
				TRY_CAST(T.runTimeMinutes AS INT), TT.idTitleType
FROM TEMP_title_basics T, TitleType TT
WHERE T.titleType = TT.titleType 


-- CARGA TABLE KnownTitle
INSERT INTO KnownTitle(Title_idTitle, Name_idName)
SELECT T.idTitle, N.idName 
FROM Title T, _Name N,
	(SELECT value as idTitle, t1.nconst as nconst
		FROM TEMP_names_basics t1 CROSS APPLY STRING_SPLIT(t1.knownForTitles, ',') ) A
WHERE A.nconst = N.idName
AND A.idTitle = T.idTitle


-- CARGA TABLE Title_has_Genre
INSERT INTO Title_has_Genre(Title_idTitle, Genre_idGenre)
SELECT T.idTitle, G.idGenre FROM Title T, Genre G, 
		(SELECT t1.tconst as id, value as nameGenre FROM TEMP_title_basics t1 
			CROSS APPLY STRING_SPLIT(t1.genres, ',') ) A
WHERE A.id = T.idTitle
AND A.nameGenre = G.genre


-- CARGA TABLA Episode
INSERT INTO Episode(idEpisode, season, episode, Title_idTitle)
SELECT t1.idTitle, TRY_CAST(temp.seasonNumber AS INT) as season, 
			TRY_CAST(temp.episodeNumber as INT) as episode, t2.idTitle 
FROM Title t1, TEMP_title_episode temp, Title t2
WHERE temp.tconst = t1.idTitle
AND temp.parentTconst = t2.idTitle
ORDER BY t2.idTitle ASC, season ASC, episode ASC;


-- CARGA TABLA Rating
INSERT INTO Rating(averageRating, numVotes, Title_idTitle)
SELECT temp.averageRating, temp.numVotes, t.idTitle 
FROM TEMP_title_ratings temp, Title t
WHERE temp.tconst = t.idTitle;

-- CARGA TABLA Title_has_Writer
INSERT INTO Title_has_Writer(Title_idTitle, Writer_idWriter)
SELECT t.idTitle, N.idName FROM Title t, _Name N,
		(SELECT tconst, value as idWriter FROM TEMP_title_crew temp 
			CROSS APPLY STRING_SPLIT(CONVERT(VARCHAR(MAX),temp.writers), ',') ) A
WHERE t.idTitle = A.tconst
AND N.idName = A.idWriter

-- CARGA TABLA Title_has_Director
INSERT INTO Title_has_Director(Title_idTitle, Director_idDirector)
SELECT t.idTitle, N.idName FROM Title t, _Name N,
		(SELECT tconst, value as idDirector FROM TEMP_title_crew temp 
			CROSS APPLY STRING_SPLIT(CONVERT(VARCHAR(MAX),temp.directors), ',') ) A
WHERE t.idTitle = A.tconst
AND N.idName = A.idDirector


-- CARGA TABLA TITLEAKAs
INSERT INTO TitleAKAs(title,orderingId, attributes, isOriginalTitle, Region_idRegion
									,Language_idLanguage, Title_idTitle)
SELECT temp.title,temp.orderingId, temp.attributes, temp.isOriginalTitle, 
			R.idRegion, L.idLanguage, t.idTitle
FROM TEMP_title_akas temp, Region R, _Language L, Title T
WHERE temp.region = R.region 
AND temp._language = L._language 
AND temp.titleId = T.idTitle;


-- CARGA TABLE PRINCIPAL
INSERT INTO Principal(category, job, characters, Title_idTitle, Name_idName)
SELECT temp.category, temp.job, temp.characters, t.idTitle, n.idName 
FROM TEMP_title_principals temp, _Name n, Title t
WHERE temp.tconst = t.idTitle 
AND temp.nconst = n.idName;
 
SELECT COUNT(*) FROM Principal;


--- VIEWS FOR SOME QUERIES.
CREATE VIEW [Titulos_Generos_Participantes]
as
	SELECT T.idTitle, STUFF(( SELECT ';' + g.genre
							FROM Title tx, Genre g, Title_has_Genre thg
							WHERE tx.idTitle = t.idTitle --@code_titulo
							AND tx.idTitle = thg.Title_idTitle
							AND thg.Genre_idGenre = g.idGenre
							FOR XML PATH('')), 1, 1, '') [Generos],
					STUFF(( SELECT ';' + n.primaryName
							FROM Title tx, Principal p , _Name n
							WHERE tx.idTitle = t.idTitle
							AND tx.idTitle = p.Title_idTitle 
							AND p.Name_idName = n.idName 
							FOR XML PATH('')), 1, 1, '') [Participantes]							
	FROM Title T



-- Index creation to query a lil bit faster (a lot faster)
create nonclustered index IDX_title_original
on Title(originalTitle)

create nonclustered index IDX_thg_title_titleId
on Title_has_Genre(Title_idTitle)

create nonclustered index IDX_thg_genre_genreId
on Title_has_Genre(Genre_idGenre)

create nonclustered index IDX__name_primary_name
on _Name(primaryName)

create nonclustered index IDX_principal_Title_idTitle
on Principal(Title_idTitle)

create nonclustered index IDX_principal_Name_idName
on Principal(Name_idName)



USE SQL_IMDB;

/*
 * Realizar un stored procedure que devuelva toda la información de un título, tipo, sus 
	participantes, episodios, géneros, ratings y toda relación perteneciente al título. Como 
	parámetro debe recibir el código de título, que este estructurados de manera fácil de 
	entender.
	----------------------------------------------------------------------------------------
	Stored Procedure that returns the basic information of a title, people that participated genres, 
	ratings. If it's a tv show, it'll return all the episodes. 
	Receives the title's code as parameter.
 */
CREATE PROCEDURE consulta1 @code_titulo varchar(30)
AS
	DECLARE @tipo_titulo INT
	SELECT  @tipo_titulo = tt.idTitleType 
					FROM Title t, TitleType tt
					WHERE t.idTitle = @code_titulo
					AND t.TitleType_idTitleType = tt.idTitleType 
	IF @tipo_titulo = 1 OR @tipo_titulo = 6 OR @tipo_titulo = 5
	BEGIN -- ES SERIE, DEVOLVER EPISODIOS
		-- Obtener nombre de la serie 
		SELECT A.originalTitle as Serie, '-' as Episode_Title, A.primaryTitle as PrimaryTitle,
						B.titleType as TitleType,A.isAdult as isAdult, 
						'-' as season, '-' as episode, 
						A.startYear as startYear, A.endYear as endYear,
						A.runTimeMinutes as runTime, E.averageRating as Rating,
						v_tgp.Generos as Generos, v_tgp.Participantes as Participantes
				FROM Title A
				INNER JOIN TitleType B ON B.idTitleType = A.TitleType_idTitleType
				LEFT JOIN Rating E ON E.Title_idTitle = A.idTitle
				LEFT JOIN Titulos_Generos_Participantes v_tgp ON v_tgp.idTitle = A.idTitle
				WHERE A.idTitle = @code_titulo
		UNION ALL 
			-- Obtener nombre de episodios
			SELECT t2.originalTitle as Serie, t.originalTitle as Episode_Title, 
							t.primaryTitle as PrimaryTitle, tt.titleType as TitleType, 
							t.isAdult as isAdult, e.season as season, e.episode as episode,
							t.startYear as startYear, t.endYear as endYear , t.runTimeMinutes as runTime, 
							R.averageRating as Rating, v_tgp.Generos as Generos, 
							v_tgp.Participantes  as Participantes
			FROM Title t2, Title t
			LEFT JOIN Rating R ON R.Title_idTitle = t.idTitle 	
			LEFT JOIN Titulos_Generos_Participantes v_tgp ON v_tgp.idTitle = t.idTitle 
			INNER JOIN TitleType tt ON tt.idTitleType = t.TitleType_idTitleType 
			INNER JOIN Episode e ON  e.idEpisode = t.idTitle 
			WHERE t2.idTitle = @code_titulo
			AND t2.idTitle = e.Title_idTitle 
			ORDER BY TitleType DESC, season DESC, episode DESC;
	END
	ELSE
	BEGIN
		SELECT A.originalTitle as OriginalTitle, A.primaryTitle as PrimaryTitle, 
				B.titleType as TitleType, A.isAdult as isAdult,	A.startYear as startYear, 
				A.endYear as endYear, A.runTimeMinutes as runTime, E.averageRating as Rating,
				v_tgp.Generos as Generos, v_tgp.Participantes as Participantes
		FROM Title A
		INNER JOIN TitleType B ON B.idTitleType = A.TitleType_idTitleType
		LEFT JOIN Rating E ON E.Title_idTitle = A.idTitle
		LEFT JOIN Titulos_Generos_Participantes v_tgp ON v_tgp.idTitle = A.idTitle		
		WHERE A.idTitle = @code_titulo
	END;

-- EXAMPLE: EXEC consulta1 --  tt0141842 -- tt0168530 

/*
 * Realizar un stored procedure que busque la información de un título, tipo, sus 
	participantes, episodios, géneros, ratings y toda relación perteneciente al título. Como 
	parámetro debe recibir un texto que se compare al nombre del título que devuelva el 
	resultado exacto y sus aproximados-
	-----------------------------------------------------------------------------------------
	Stored procedure that returns all the info of any title that contains the name that it's sent as
	parameter. 
	 */
CREATE PROCEDURE consulta2 @text_titulo varchar(500)
AS
			SELECT A.idTitle as idTitle, A.originalTitle as Serie, '-' as Episode_Title, 
					A.primaryTitle as PrimaryTitle,	B.titleType as TitleType,
						A.isAdult as isAdult, '-' as season, '-' as episode, 
						A.startYear as startYear, A.endYear as endYear,
						A.runTimeMinutes as runTime, E.averageRating as Rating,
						v_tgp.Generos as Generos, v_tgp.Participantes as Participantes
				FROM Title A
				INNER JOIN TitleType B ON B.idTitleType = A.TitleType_idTitleType
				LEFT JOIN Rating E ON E.Title_idTitle = A.idTitle
				LEFT JOIN Titulos_Generos_Participantes v_tgp ON v_tgp.idTitle = A.idTitle					
				WHERE A.originalTitle LIKE '%'+@text_titulo+'%'-- '%'+@texto_titulo+'%'
				AND B.idTitleType NOT IN (1, 9)				
		UNION ALL
		(		SELECT A.idTitle as idTitle, A.originalTitle as Serie, '-' as Episode_Title, 
					A.primaryTitle as PrimaryTitle,	B.titleType as TitleType,
						A.isAdult as isAdult, '-' as season, '-' as episode, 
						A.startYear as startYear, A.endYear as endYear,
						A.runTimeMinutes as runTime, E.averageRating as Rating,
						v_tgp.Generos as Generos, v_tgp.Participantes as Participantes
				FROM Title A
				INNER JOIN TitleType B ON B.idTitleType = A.TitleType_idTitleType
				LEFT JOIN Rating E ON E.Title_idTitle = A.idTitle
				LEFT JOIN Titulos_Generos_Participantes v_tgp ON v_tgp.idTitle = A.idTitle				
				WHERE A.originalTitle LIKE '%'+@text_titulo+'%'
				AND A.TitleType_idTitleType = '1'
				UNION ALL
				SELECT t.idTitle as idTitle, t2.originalTitle as Serie, 
						t.originalTitle as Episode_Title, 
						t.primaryTitle as PrimaryTitle, tt.titleType as TitleType, 
						t.isAdult as isAdult, e.season as season, e.episode as episode,
						t.startYear as startYear, t.endYear as endYear , t.runTimeMinutes as runTime, 
						R.averageRating as Rating, v_tgp.Generos as Generos, 
						v_tgp.Participantes  as Participantes
				FROM Title t2,Title t 
				LEFT JOIN Rating R ON R.Title_idTitle = t.idTitle
				LEFT JOIN Titulos_Generos_Participantes v_tgp ON v_tgp.idTitle = t.idTitle 
				INNER JOIN TitleType tt ON tt.idTitleType = t.TitleType_idTitleType 
				INNER JOIN Episode e ON  e.idEpisode = t.idTitle 						
				WHERE t2.originalTitle  LIKE '%'+@text_titulo+'%' -- '%'+@texto_titulo+'%'
				AND t.TitleType_idTitleType = '9'
				AND t2.idTitle = e.Title_idTitle )
		ORDER BY TitleType DESC, season DESC, episode DESC;

	
-- EXAMPLE: EXEC consulta2 'Harry Potter'
	

/* Realizar una vista que devuelva cuantos títulos hay por cada género, no debe contar 
	cada episodio, ni cada temporada, la serie completa cuenta como uno, así como las 
	películas
	-----------------------------------------------------------------------------------------
	View that returns how many titles there are by genre.
*/
CREATE VIEW consulta3
AS
	SELECT CASE g.genre WHEN '\N' Then 'Unknown' ELSE g.genre END AS Genero, 
	COUNT(t.idTitle) as Cantidad_titulos
	FROM Genre g, Title t, Title_has_Genre thg 
	WHERE g.idGenre = thg.Genre_idGenre
	AND thg.Title_idTitle = t.idTitle
	AND t.TitleType_idTitleType NOT IN (9, 6, 4)
	GROUP BY g.genre;


/* Stored procedure que busque por nombre de persona, que muestre sus participaciones 
	y los títulos que lo hicieron conocido. 
	-----------------------------------------------------------------------------------------	
	Stored procedure that returns all the titles a person is known for. (as actor/actress, director or writer )
 */
CREATE PROCEDURE consulta4 @nombre_persona VARCHAR(400)
AS
	SELECT T.originalTitle as Titulo, N.primaryName as Persona, P.[characters] as Personajes
	FROM _Name N, Principal P, Title T
	WHERE N.primaryName = @nombre_persona
	AND N.idName = P.Name_idName 
	AND P.Title_idTitle = T.idTitle
	UNION ALL
	SELECT T.originalTitle as Titulo, N.primaryName as Persona, 'Director' as Personajes
	FROM _Name N, Title T, Title_has_Director THD
	WHERE N.primaryName = @nombre_persona
	AND N.idName = THD.Director_idDirector
	AND THD.Title_idTitle = T.idTitle
	UNION ALL
	SELECT T.originalTitle as Titulo, N.primaryName as Persona, 'Writer' as Personajes
	FROM _Name N, Title T, Title_has_Writer THW
	WHERE N.primaryName = @nombre_persona
	AND N.idName = THW.Writer_idWriter
	AND THW.Title_idTitle = T.idTitle;
	
	
	
-- EXAMPLE EXEC consulta4 'Lionel Messi'
	
/* 
 	El top 10 de los directores con más participaciones como director en diferentes títulos.
 	----------------------------------------------------------------------------------------
 	Top 10 of directors with the most participations in all titles registered in IMDB.
 */
CREATE VIEW consulta5
AS
	SELECT TOP 10 N.primaryName as Persona, 
	count(thd.Director_idDirector) as Num_Participaciones
	FROM _Name N, Title_has_Director thd, Title t
	WHERE N.idName = thd.Director_idDirector 
	AND thd.Title_idTitle = t.idTitle 
	AND t.TitleType_idTitleType NOT IN (9, 6, 4)
	GROUP BY N.primaryName
	ORDER BY count(thd.Director_idDirector) DESC;





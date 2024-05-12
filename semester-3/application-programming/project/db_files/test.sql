--getPlayers
SELECT P.player_id AS playerId, P.team_id AS teamID,
       P.name AS firstName, P.surname AS lastName, T.name AS teamName
FROM players P LEFT JOIN teams T
                         ON P.team_id = T.team_id
               INNER JOIN team_plays_in_league TL
                          ON TL.team_id = T.team_id
WHERE TL.league_id = 0
ORDER BY P.surname, P.name;

--getPlayer
SELECT P.player_id AS playerId, P.team_id AS teamID, P.birth_date as birthDate, P.height AS height, P.weight AS weight,
       P.name AS firstName, P.surname AS lastName, T.name AS teamName, C.name AS origin
FROM players P LEFT JOIN teams T
                         ON P.team_id = T.team_id
               LEFT JOIN countries C
                         ON P.birth_country_id = C.country_ID
WHERE P.player_id = 50;

--getMatches
SELECT  TM1.team_id AS firstTeamId, TM2.team_id AS secondTeamId, M.match_id as matchId,
        T1.name AS firstTeamName, T2.name AS secondTeamName,
        TM1.goal_amount AS firstTeamGoals, TM2.goal_amount AS secondTeamGoals, S.name AS location,
        M.match_date AS matchDate
FROM team_plays_in_match TM1 INNER JOIN team_plays_in_match TM2
                                        ON TM1.match_id = TM2.match_id AND TM1.team_id > TM2.team_id
                             INNER JOIN teams T1
                                        ON TM1.team_id = T1.team_id
                             INNER JOIN teams T2
                                        ON TM2.team_id = T2.team_id
                             INNER JOIN matches M
                                        ON TM1.match_id = M.match_id
                             INNER JOIN stadiums S
                                        ON S.stadium_id = M.stadium_id
WHERE M.league_id = 0
ORDER BY M.match_date DESC;


--getTeams
SELECT T.team_id AS teamID, T.name AS teamName
FROM teams T INNER JOIN team_plays_in_league TL
                        ON T.team_id = TL.team_id
WHERE TL.league_id = 0
ORDER BY T.name;


--getLeagues
SELECT league_id AS leagueId, name AS leagueName
FROM leagues;


--getTeamOrigin
SELECT C.name as origins
FROM teams T INNER JOIN countries C
                        ON T.country_id = C.country_id
WHERE T.team_id = 0;


--getStadiums
SELECT stadium_id as stadiumId, name as stadiumName
FROM stadiums;


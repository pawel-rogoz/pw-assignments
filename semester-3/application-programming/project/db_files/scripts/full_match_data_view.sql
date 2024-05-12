create or replace view full_match_data_view
as
    select t1.name as hosts, tpm1.goal_amount as hosts_goals, tpm2.goal_amount as guests_goals, t2.name as guests, s.name as stadium, c.name as country
    from team_plays_in_match tpm1 
    inner join team_plays_in_match tpm2 on(tpm1.match_id = tpm2.match_id and tpm1.team_id != tpm2.team_id)
    inner join matches m on(tpm1.match_id = m.match_id)
    inner join teams t1 on(tpm1.team_id = t1.team_id)
    inner join teams t2 on(tpm2.team_id = t2.team_id)
    inner join stadiums s on(s.stadium_id = m.stadium_id)
    inner join countries c on(c.country_id = s.country_id);

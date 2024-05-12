create or replace view full_player_data_view
as
    select p.name as name, p.surname, p.birth_date, p.height, p.weight, t.name as team, l.name as league from players p inner join teams t on(p.team_id = t.team_id)
    inner join team_plays_in_league tpl on(t.team_id = tpl.team_id) inner join leagues l on(tpl.league_id = l.league_id);

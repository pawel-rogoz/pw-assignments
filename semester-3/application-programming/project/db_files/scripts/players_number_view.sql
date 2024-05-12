create or replace view players_number_view
as
    select t.name, count(*) as players from players p inner join teams t on(p.team_id=t.team_id) group by t.name;

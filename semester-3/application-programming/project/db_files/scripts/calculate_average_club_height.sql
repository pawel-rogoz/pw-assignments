create or replace function calculate_average_club_height(t_id number)
return number
as
    v_sum_height number;
    v_players_amount number;
    v_avg_height number;
begin
    select sum(height) into v_sum_height from players where team_id = t_id;
    select count(*) into v_players_amount from players where team_id = t_id;
    v_avg_height := v_sum_height / v_players_amount;
    v_avg_height := round(v_avg_height, 2);
    return v_avg_height;
end;

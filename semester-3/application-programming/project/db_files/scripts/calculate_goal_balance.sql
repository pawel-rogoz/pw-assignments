create or replace function calculate_goal_balance(t_id number)
return number
as
    v_scored_goals number := 0;
    v_lost_goals number := 0;
begin
    select sum(tpm1.goal_amount) into v_scored_goals from team_plays_in_match tpm1 inner join team_plays_in_match tpm2 on(tpm1.match_id = tpm2.match_id and tpm1.team_id != tpm2.team_id) where tpm1.team_id = t_id;
    select sum(tpm2.goal_amount) into v_lost_goals from team_plays_in_match tpm1 inner join team_plays_in_match tpm2 on(tpm1.match_id = tpm2.match_id and tpm1.team_id != tpm2.team_id) where tpm1.team_id = t_id;
    return v_scored_goals - v_lost_goals;
end;

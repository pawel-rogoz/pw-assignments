create or replace function calculate_scored_goals(t_id number)
return number
as
    v_goals number := 0;
begin
    select sum(goal_amount) into v_goals from team_plays_in_match tpm where tpm.team_id = t_id;
    return v_goals;
end;

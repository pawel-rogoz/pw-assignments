create or replace function calculate_num_matches_on_stadium(s_id number)
return number
as
    v_matches_number number := 0;
begin
    select count(*) into v_matches_number from matches where stadium_id = s_id;
    return v_matches_number;
end;

create or replace function calculate_stadium_per_player_ratio(c_id number)
return number
as
    v_stadiums_amount number := 0;
    v_players_amount number := 0;
    v_ratio number := 0;
begin
    select count(*) into v_stadiums_amount from stadiums where country_id = c_id;
    select count(*) into v_players_amount from players where birth_country_id = c_id;
    if v_stadiums_amount = 0 or v_players_amount = 0 then
        return v_ratio;
    end if;
    v_ratio := v_stadiums_amount / v_players_amount;
    v_ratio := round(v_ratio, 2);
    return v_ratio;
end;

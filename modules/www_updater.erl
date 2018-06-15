-module(www_updater).
-author('AleksanderLisiecki').

-export([update_webpage/0]).

update_webpage() -> 
    update_temperature(),
    update_humidity().

update_temperature() -> 
    {{CurrentYear,CurrentMonth,CurrentDay},{_,_,_}} = erlang:universaltime(),
    Measurements = database:get_measurements(
        fun({measurement,{{Year,Month,Day},{_,_,_}},_,_}) -> 
            ((Year == CurrentYear) and
            (Month == CurrentMonth) and
            (Day == CurrentDay)) 
        end),
        Plot = lists:foldr(fun(Acc,M) -> Acc ++ format_measurement_temperature(M) end, "", Measurements),
        file:write_file("../data/temperature.csv",Plot).

update_humidity() -> ok.

format_measurement_temperature({measurement,{{Year, Month, Day}, {Hour, Minute, Second}},Temperature,Humidity}) ->
    X = 3600 * Hour + 60 * Minute + Second,
    lists:flatten(io_lib:format("{ x: ~p, y: ~p },\n",[X, Temperature])). 
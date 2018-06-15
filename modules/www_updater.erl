-module(www_updater).
-author('AleksanderLisiecki').

-export([update_webpage/0]).

update_webpage() -> 
    update_temperature(),
    update_humidity().

update_temperature() -> 
    io:fwrite("DEBUG: WWWUPDATER Before Measurements \n",[]),    
    Measurements = get_measurements(),
    io:fwrite("DEBUG: WWWUPDATER Measurements are: ~p\n",[Measurements]),    
    Plot = lists:foldr(fun(M,Acc) -> Acc ++ format_measurement_temperature(M) end, "", Measurements),
    file:write_file("../data/temperature.csv",Plot).

update_humidity() -> ok.

%get_measurements() -> 
%    [{measurement,{{2018,6,15},{3,3,3}},5,6},
%    {measurement,{{2018,6,15},{3,1,3}},4,7},
%    {measurement,{{2018,6,15},{1,3,3}},3,8}].

get_measurements() ->
    {{CurrentYear,CurrentMonth,CurrentDay},{_,_,_}} = erlang:universaltime(),
    database:get_measurements().
    %database:get_measurements(fun({measurement,{{Year,Month,_},{_,_,_}},_,_}) -> ((Year == CurrentYear) and (CurrentMonth == 1)) end).

format_measurement_temperature([]) -> "";
format_measurement_temperature({measurement,{{_Year, _Month, _Day}, {Hour, Minute, Second}}, Temperature, _Humidity}) ->
    X = 3600 * Hour + 60 * Minute + Second,
    lists:flatten(io_lib:format("{ x: ~p, y: ~p },\n",[X, Temperature])). 
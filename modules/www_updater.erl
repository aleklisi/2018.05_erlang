-module(www_updater).
-author('AleksanderLisiecki').

-export([update_webpage/0]).

update_webpage() -> 
    update_temperature(),
    update_humidity().

update_temperature() -> 
    %io:fwrite("DEBUG: WWWUPDATER Before Measurements \n",[]),    
    Measurements = get_measurements(),
    %io:fwrite("DEBUG: WWWUPDATER Measurements are: ~p\n",[Measurements]),    
    Plot = lists:foldr(fun(M,Acc) -> Acc ++ format_measurement_temperature(M) end, "", Measurements),
    file:write_file("../data/temperature.csv",Plot).

update_humidity() ->  %io:fwrite("DEBUG: WWWUPDATER Before Measurements \n",[]),    
    Measurements = get_measurements(),
    %io:fwrite("DEBUG: WWWUPDATER Measurements are: ~p\n",[Measurements]),    
    Plot = lists:foldr(fun(M,Acc) -> Acc ++ format_measurement_humidity(M) end, "", Measurements),
    file:write_file("../data/humidity.csv",Plot).

get_measurements() ->
    Measurements = database:get_measurements(),
    lists:sort(
        fun({_,{{AY,AMo,AD},{AH,AMi,AS}},_,_},{_,{{BY,BMo,BD},{BH,BMi,BS}},_,_}) -> 
            TimeA = ((((AY * 12 + AMo) * 30 + AD) *24 + AH) *60 + AMi) * 60 + AS,
            TimeB = ((((BY * 12 + BMo) * 30 + BD) *24 + BH) *60 + BMi) * 60 + BS,
            TimeA > TimeB 
        end, Measurements).

format_measurement_temperature([]) -> "";
format_measurement_temperature({measurement,{{_Year, _Month, _Day}, {_Hour, Minute, Second}}, Temperature, _Humidity}) ->
    X = 60 * Minute + Second,
    lists:flatten(io_lib:format("{ x: ~p, y: ~p },\n",[X, Temperature])). 


format_measurement_humidity([]) -> "";
format_measurement_humidity({measurement,{{_Year, _Month, _Day}, {_Hour, Minute, Second}}, _Temperature, Humidity}) ->
    X = 60 * Minute + Second,
    lists:flatten(io_lib:format("{ x: ~p, y: ~p },\n",[X, Humidity])). 
-module(www_updater).
-author('AleksanderLisiecki').

-export([update_webpage/0]).

update_webpage() -> 
    update(temperature),
    update(humidity).

update(TempOrHum) -> 
    %io:fwrite("DEBUG: WWWUPDATER Before Measur0ements \n",[]),    
    Measurements = get_measurements(),
    %io:fwrite("DEBUG: WWWUPDATER Measurements are: ~p\n",[Measurements]),    
    Plot = lists:foldr(fun(M,Acc) -> Acc ++ format_measurement(M, TempOrHum) end, "", Measurements),
    case TempOrHum of
        temperature -> file:write_file("../data/temperature.csv",Plot);
        humidity ->     file:write_file("../data/humidity.csv",Plot)
    end.

get_measurements() ->
    Measurements = database:get_measurements(),
    lists:sort(
        fun({_,{{AY,AMo,AD},{AH,AMi,AS}},_,_},{_,{{BY,BMo,BD},{BH,BMi,BS}},_,_}) -> 
            TimeA = ((((AY * 12 + AMo) * 30 + AD) *24 + AH) *60 + AMi) * 60 + AS,
            TimeB = ((((BY * 12 + BMo) * 30 + BD) *24 + BH) *60 + BMi) * 60 + BS,
            TimeA > TimeB 
        end, Measurements).

format_measurement({measurement,{{Year, Month, Day}, {Hour, Minute, Second}}, Temperature, Humidity},TempOrHum) ->
    X = (((((Year * 12) + Month) * 30 + Day) * 24 + Hour) * 60 + Minute) * 60 + Second,
    case TempOrHum of
        temperature -> lists:flatten(io_lib:format("{ x: ~p, y: ~p },\n",[X, Temperature]));
        humidity -> lists:flatten(io_lib:format("{ x: ~p, y: ~p },\n",[X, Humidity]))
    end.
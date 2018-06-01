-module(database_tests).
-author('AleksanderLisiecki').

% cd("C:/Users/sebac/Documents/GitHub/2018.05_erlang/tests").
-include_lib("eunit/include/eunit.hrl").
-import(database,[init/0,                
        terminate/0,            
        insert_measurement/3,
        get_measurements/0,
        get_measurements/1]).

init_single_start_test() -> 
    StartResult = init(),
    ?assertEqual(StartResult,ok),
    %teardown
    terminate().

init_multiple_starts_test() -> 
    [?assertEqual(init(),ok) || _ <- lists:seq(1,10)],
    %teardown
    terminate().

terminate_after_init_test() -> 
    init(),
    StopResult = terminate(),
    ?assertEqual(StopResult,stopped).

single_terminate_without_init_test() -> 
    StopResult = terminate(),
    ?assertEqual(StopResult,stopped).

multiple_terminate_without_init_test() -> 
    [?assertEqual(terminate(),stopped) || _ <- lists:seq(1,10)].

insert_measurement_init_test() -> 
    init(),
    InsertResult = insert_measurement(1,2,3),
    ?assertEqual(InsertResult,{badarg,1,2,3}),
    terminate().

insert_many_measurements_init_test() -> 
    init(),
    [?assertEqual(insert_measurement(1,2,{{1,2,3},{4,5,6}}),{atomic,ok}) || _ <- lists:seq(1,10)],
    terminate().

insert_measurement_without_init_test() -> 
    InsertResult = insert_measurement(1,2,{{1,2,3},{4,5,6}}),
    ?assert({aborted,{node_not_running,node()}} =:= InsertResult).

get_measurements_test() -> 
    init(),
    insert_measurement(1,2,{{1,2,3},{4,5,6}}),
    Measurements = get_measurements(),
    ?assertEqual(Measurements,[{measurement,{{1,2,3},{4,5,6}},1,2}]),
    terminate().

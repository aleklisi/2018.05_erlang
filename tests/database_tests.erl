-module(database_tests).
-author('AleksanderLisiecki').

% cd("C:/Users/sebac/Documents/GitHub/2018.05_erlang/tests").
-include_lib("eunit/include/eunit.hrl").
-import(database,[init/0,                
        terminate/0,            
        insert_measurement/3,
        get_measurements/0,
        get_measurements/1]).

%arrange
%act
%assert
%teardown

init_single_start_test() -> 
    StartResult = init(),
    ?assertEqual(StartResult,ok),
    terminate().

init_multiple_starts_test() -> 
    [?assertEqual(init(),ok) || _ <- lists:seq(1,10)],
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

insert_measurement_after_init_test() -> 
    init(),
    InsertResult = insert_measurement(1,2,3),
    ?assertEqual(InsertResult,{badarg,1,2,3}),
    terminate().

insert_many_measurements_after_init_test() -> 
    init(),
    [?assertEqual(insert_measurement(1,2,{{1,2,3},{4,5,6}}),{atomic,ok}) || _ <- lists:seq(1,10)],
    terminate().

insert_fails_badarg(Temp,Hum,DateTime) -> 
    init(),
    IncorrectInput = insert_measurement(Temp,Hum,DateTime),
    ?assertEqual(IncorrectInput, {badarg,Temp,Hum,DateTime}),
    Measurements = get_measurements(),
    ?assertEqual(length(Measurements),0),
    terminate().

insert_type_incorrect_temp_measuremnt_test() -> 
    insert_fails_badarg(a,1,{{1,1,1},{1,1,1}}).

insert_type_incorrect_hum_measuremnt_test() -> 
    insert_fails_badarg(1,a,{{1,1,1},{1,1,1}}).

insert_type_incorrect_year_measuremnt_test() -> 
    insert_fails_badarg(1,1,{{a,1,1},{1,1,1}}).

insert_type_incorrect_month_measuremnt_test() -> 
    insert_fails_badarg(1,1,{{1,a,1},{1,1,1}}).

insert_type_incorrect_day_measuremnt_test() -> 
    insert_fails_badarg(1,1,{{1,1,a},{1,1,1}}).

insert_type_incorrect_hour_measuremnt_test() -> 
    insert_fails_badarg(1,1,{{1,1,1},{a,1,1}}).

insert_type_incorrect_min_measuremnt_test() -> 
    insert_fails_badarg(1,1,{{1,1,1},{1,a,1}}).

insert_type_incorrect_sec_measuremnt_test() -> 
    insert_fails_badarg(1,1,{{1,1,1},{1,1,a}}).

insert_measurement_too_low_temp_test() -> 
    insert_fails_badarg(-275,1,{{1,1,1},{1,1,1}}).

insert_measurement_too_low_hum_test() -> 
    insert_fails_badarg(1,-1,{{1,1,1},{1,1,1}}).

insert_measurement_too_high_hum_test() -> 
    insert_fails_badarg(1,101,{{1,1,1},{1,1,1}}).


insert_measurement_without_init_test() -> 
    InsertResult = insert_measurement(1,2,{{1,2,3},{4,5,6}}),
    ?assert({aborted,{node_not_running,node()}} =:= InsertResult).

get_measurement_test() -> 
    init(),
    insert_measurement(1,2,{{1,2,3},{4,5,6}}),
    Measurements = get_measurements(),
    ?assertEqual(Measurements,[{measurement,{{1,2,3},{4,5,6}},1,2}]),
    terminate().

get_many_measurements_test() -> 
    init(),
    insert_measurement(1,2,{{1,2,3},{4,5,6}}),
    insert_measurement(2,3,{{4,5,6},{7,8,9}}),
    insert_measurement(9,8,{{7,6,5},{4,3,2}}),
    [FirstMeasure|T1] = get_measurements(),
    [SecondMeasure|T2] = T1,
    [ThirdMeasure] = T2,
    ?assertEqual(FirstMeasure,{measurement,{{1,2,3},{4,5,6}},1,2}),
    ?assertEqual(SecondMeasure,{measurement,{{4,5,6},{7,8,9}},2,3}),
    ?assertEqual(ThirdMeasure,{measurement,{{7,6,5},{4,3,2}},9,8}),
    terminate().

get_measurement_after_restart_test() -> 
    init(),
    insert_measurement(1,2,{{1,2,3},{4,5,6}}),
    MeasurementsBeforeRestart = get_measurements(),
    ?assertEqual(MeasurementsBeforeRestart,[{measurement,{{1,2,3},{4,5,6}},1,2}]),
    terminate(),
    init(),
    MeasurementsAfterRestart = get_measurements(),
    ?assertEqual(MeasurementsAfterRestart,[]),
    terminate().

get_measurements_filter_test() -> 
    init(),
    insert_measurement(1,1,{{1,1,1},{1,1,1}}),
    insert_measurement(2,2,{{2,2,2},{2,2,2}}),
    insert_measurement(3,3,{{3,3,3},{3,3,3}}),
    insert_measurement(4,4,{{4,4,4},{4,4,4}}),
    insert_measurement(5,5,{{5,5,5},{5,5,5}}),
    Measurements = get_measurements(
        fun({measurement,{{Year,_,_},{_,_,_}},_,_}) -> Year < 4 end
        ),
    ?assert(lists:any(fun(Elem) -> Elem =:= {measurement,{{1,1,1},{1,1,1}},1,1} end, Measurements)),
    ?assert(lists:any(fun(Elem) -> Elem =:= {measurement,{{2,2,2},{2,2,2}},2,2} end, Measurements)),
    ?assert(lists:any(fun(Elem) -> Elem =:= {measurement,{{3,3,3},{3,3,3}},3,3} end, Measurements)),
    ?assert(length(Measurements) =:= 3),
    terminate().

get_measurements_complexed_filter_test() -> 
    init(),
    insert_measurement(1,1,{{1,1,1},{1,1,1}}),
    insert_measurement(2,2,{{2,2,2},{2,2,2}}),
    insert_measurement(3,3,{{3,3,3},{3,3,3}}),
    insert_measurement(4,4,{{4,4,4},{4,4,4}}),
    insert_measurement(5,5,{{5,5,5},{5,5,5}}),
    Measurements = get_measurements(
        fun({measurement,{{Year,Month,_},{_,_,_}},_,_}) -> (Year < 4) and (Month >= 2) end
        ),
    ?assert(lists:any(fun(Elem) -> Elem =:= {measurement,{{2,2,2},{2,2,2}},2,2} end, Measurements)),
    ?assert(lists:any(fun(Elem) -> Elem =:= {measurement,{{3,3,3},{3,3,3}},3,3} end, Measurements)),
    ?assert(length(Measurements) =:= 2),
    terminate().

    
get_measurements_incorrect_filter_int_test() -> 
    init(),
    insert_measurement(2,2,{{2,2,2},{2,2,2}}),
    Measurements = get_measurements(2),
    ?assertEqual(Measurements, {badarg,2}),
    terminate().

get_measurements_incorrect_filter_atom_test() -> 
    init(),
    insert_measurement(2,2,{{2,2,2},{2,2,2}}),
    Measurements = get_measurements(atom),
    ?assertEqual(Measurements, {badarg,atom}),
    terminate().

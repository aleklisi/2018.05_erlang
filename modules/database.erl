-module(database).
-author('AleksanderLisiecki').
-include_lib("stdlib/include/qlc.hrl").

-export([init/0,                
        terminate/0,            
        insert_measurement/3,
        get_measurements/0,
        get_measurements/1]).

-record(measurement, {datetime = {{0,0,0},{0,0,0}} :: {{integer(),integer(),integer()},{integer(),integer(),integer()}}, %erlang:universaltime() returns {{Year, Month, Day}, {Hour, Minute, Second}}
                      temperature = -273 :: integer(),
                      humidity = 0 :: integer()}). %for future use
 
% init -> ok | Error
% creates DB schema, starts mnesia, creates table measurement 
% returns ok no matter if table does not exist it is created
% returns Error if something goes wrong
init() ->
    mnesia:create_schema([node()]),
    mnesia:start(),
    Init = mnesia:create_table(measurement, 
        [{attributes, record_info(fields, measurement)}]),
    mnesia:wait_for_tables([measurement],10),
    case Init of
        {atomic,ok} -> ok;
        {aborted,{already_exists,measurement}} -> ok;
        Error -> Error
    end. 

% stops mnesia - when called prints INFO RAPORT and
% returns stopped
terminate() -> mnesia:stop().

% inserts measurement record into db with current time and date (see erlang:universaltime()) 
% Temperature single temperature measurement
% Humidity single humidity measurement 
% returns {aborted, Reason} | {atomic, ResultOfFun}
% UniversalTime is date and time in format {{Year, Month, Day}, {Hour, Minute, Second}}

-spec insert_measurement(integer(),integer(),{{integer(),integer(),integer()},{integer(),integer(),integer()}}) -> {atom() , atom()}.
insert_measurement(Temperature,Humidity,{{Year, Month, Day}, {Hour, Minute, Second}}) 
    when is_integer(Temperature) and
    is_integer(Humidity) and
    is_integer(Year) and
    is_integer(Month) and
    is_integer(Day) and
    is_integer(Hour) and
    is_integer(Minute) and
    is_integer(Second) and
    (Humidity >= 0) and
    (Humidity =< 100) and
    (Temperature > -275) -> insert_measurement_type_checked(Temperature,Humidity,{{Year, Month, Day}, {Hour, Minute, Second}});
insert_measurement(T,H,D) -> 
    {badarg,T,H,D}.

insert_measurement_type_checked(Temperature,Humidity,{{Year, Month, Day}, {Hour, Minute, Second}}) ->
    UniversalTime = {{Year, Month, Day}, {Hour, Minute, Second}},
    NewRecord = {measurement,UniversalTime,Temperature,Humidity},
    io:fwrite("DEBUG: DB adding: ~p to db\n",[NewRecord]),
    Fun = fun() -> mnesia:write(NewRecord) end,
    mnesia:transaction(Fun).

% gests all measurements from db 
% returns [{measurement,{{Year, Month, Day}, {Hour, Minute, Second}},Temperature,Humidity}] | error (if db is not running)

-spec get_measurements() -> [{atom(),{{integer(),integer(),integer()},{integer(),integer(),integer()}},integer(),integer()}].
get_measurements() ->
     get_measurements(fun(_) -> true end).

% Filter is fun({measurement,{{Year, Month, Day}, {Hour, Minute, Second}},Temperature,Humidity}) -> bool(), allows to filter returned records
%example 1
%db:get_measurements(fun({_,_,X,_}) -> X > 4 end). 
% will return only measurements where  Temperature is grater than 4
%example 2
%db:get_measurements(fun({measurement,{{Year,Month,_},{_,_,_}},_,_}) -> ((Year == 1995) and (Month == 1)) end).
% will return only measurements from January 1995

get_measurements(Filter) when is_function(Filter)->
     F = fun() ->
		Result = qlc:q([Measurement || Measurement <- mnesia:table(measurement), Filter(Measurement)]),
		qlc:e(Result)
	end,
    {atomic,Results} = mnesia:transaction(F),
    Results;
get_measurements(F) -> {badarg,F}.
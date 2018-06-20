-module(logics).
-author('AleksanderLisiecki').

-export([decide_if_notify/0]).

decide_if_notify() ->
    NotificationConditionResult = notification_condition(),
    case NotificationConditionResult of
        {notify, Info} -> 
            %io:fwrite("DEBUG: LOGICS notify ~p\n",[Info]),
            notifier_gen_server:notify(all, Info);
        _ ->
            %io:fwrite("DEBUG: LOGICS dont notify\n",[]),
            dont_notify
    end.

notification_condition() ->
    %TODO add more complex logics, get data from DB
    Temperature = get_latest_temperature(), 
    case Temperature < 5  of
        true -> {notify,"Temperature is too low\n"};
        _ -> dont_notify
    end.

get_latest_temperature() -> 
    Measurements = database:get_measurements(),
    {_,{{_,_,_},{_,_,_}},Result,_} = lists:foldr(
        fun(ArgA, ArgB) -> 
            {_,{{AY,AMo,AD},{AH,AMi,AS}},_,_} = ArgA,
            {_,{{BY,BMo,BD},{BH,BMi,BS}},_,_} = ArgB,
            TimeA = ((((AY * 12 + AMo) * 30 + AD) *24 + AH) *60 + AMi) * 60 + AS,
            TimeB = ((((BY * 12 + BMo) * 30 + BD) *24 + BH) *60 + BMi) * 60 + BS,
            case TimeA > TimeB of
                true -> ArgA;
                _ -> ArgB
            end
        end,
        {temperature,{{0,0,0},{0,0,0}},-273,0},
         Measurements),
         Result.
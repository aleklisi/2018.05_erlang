-module(logics).
-author('AleksanderLisiecki').

-export([decide_if_notify/0]).

decide_if_notify() ->
    NotificationConditionResult = notification_condition(),
    case NotificationConditionResult of
        {notify, Info} -> 
            io:fwrite("DEBUG: LOGICS notify ~p\n",[Info]),
            notifier_gen_server:notify(all, Info);
        _ ->
            io:fwrite("DEBUG: LOGICS dont notify\n",[]),
            dont_notify
    end.

notification_condition() ->
    %TODO add more complex logics, get data from DB
    Temperature = rand:uniform(10), 
    case Temperature < 5  of
        true -> {notify,"Temperature is too low\n"};
        _ -> dont_notify
    end.
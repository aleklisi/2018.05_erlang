-module(rolnik_db).
-export([start_link/0,
         init/1,
         terminate/2,
         create/1,
         update/2,
         dump/1]).

start_link() ->
    gen_server:start_link({local, rolnik_db}, ?MODULE, no_args, []).

init(no_args) ->
    {ok, Log} = create(<<"temperature">>),
    {ok, Log}.

terminate(_Reason, Log) ->
    ok = disk_log:sync(Log),
    ok = disk_log:close(Log).
    
create(Name) ->
    {ok, _Log} = disk_log:open([{name, Name},
                                {file, "temperature.log"},
                                {type, halt},
                                {format, internal},
                                {mode, read_write}]).
    
%% update(<<"temperature">>, [{"temp", 50}]).
update(Log, Values) ->
    [ok = disk_log:log(Log, {{date(), time()}, Value})
     || {"temp", Value} <- Values].

%% dump(<<"temperature">>) -> <<"{x: 1, y:10},{x: 2, y:9},{x: 3, y:15},">>
dump(Log) ->
    {_Continuation, Terms} = disk_log:chunk(Log, start),

    IOList = [io_lib:format("{x:~p, y:~p},", [Minute, Temp])
              || {{_Date, {_H, Minute, _S}}, Temp} <- Terms],

    erlang:iolist_to_binary(IOList).

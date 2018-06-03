-module(notifier_gen_server).
-author('AleksanderLisiecki').

-behaviour(gen_server).
-export([start_link/0, stop/0, write_to_console_sync/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%Call Back Functions
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

stop() -> 
    gen_server:cast({global, ?MODULE}, stop).

write_to_console_sync(Info) -> 
    gen_server:call({global, ?MODULE},{console_sync,Info}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%Call Back Functions
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

init(_Args) ->
    process_flag(trap_exit, true),
    {ok, []}.

handle_call({console_sync,Info}, _From, State) ->
    io:fwrite("Sync call to print: ~p\n",[Info]),
    Reply = {printed,Info},
    {reply, Reply, State};
handle_call(_Request, _From, State) ->
    {reply, nomatch, State}.

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(Info,State) ->
    {noreply, Info, State}.

terminate(_Reason, _State) -> ok.

code_change(_OldVersion,State,_Extra) -> 
    {ok, State}.
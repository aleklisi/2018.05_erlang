-module(notifier_gen_server).
-author('AleksanderLisiecki').

-behaviour(gen_server).
-export([start_link/0, stop/0, notify/2]).
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

notify(all,Info) -> 
    notify(console,Info);
notify(console, Info) -> 
    gen_server:call({global, ?MODULE},{console_sync,Info});
notify(grisp_connection_timeout, Timeout) -> 
    gen_server:call({global, ?MODULE},{grisp_connection_timeout,Timeout});    
notify(Dest, _Info) -> {nomatch,Dest}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%Call Back Functions
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

init(_Args) ->
    process_flag(trap_exit, true),
    {ok, []}.

handle_call({console_sync,Info}, _From, State) ->
    io:fwrite("Print to console: ~p\n",[Info]),
    Reply = {printed,Info},
    {reply, Reply, State};
handle_call({grisp_connection_timeout,Timeout}, _From, State) ->
    io:fwrite("grisp_connection_timeout: ~p\n",[Timeout]),
    Reply = {printed,Timeout},
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
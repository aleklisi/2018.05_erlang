-module(router_gen_server).
-author('AleksanderLisiecki').

-behaviour(gen_server).
-export([start_link/0, stop/0, propagate_message/1]).
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

propagate_message(Message) -> 
    gen_server:cast({global, ?MODULE},{propagate, Message}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%Call Back Functions
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

init(_Args) ->
    process_flag(trap_exit, true),
    {ok, []}.

handle_call(_Request, _From, State) ->
    {reply, nomatch, State}.

handle_cast({propagate, Message}, State) ->
    clock:send_data_received(),
    {{temperature,Temperature},{humidity,Humidity}} = parser:parse_message(Message),
    DateTime = erlang:universaltime(),
    database:insert_measurement(Temperature,Humidity,DateTime),
    logics:decide_if_notify(),
    {noreply, State};

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(Info,State) ->
    {noreply, Info, State}.

terminate(_Reason, _State) -> ok.

code_change(_OldVersion,State,_Extra) -> 
    {ok, State}.
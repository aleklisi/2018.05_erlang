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
    notify(console, Info),
    notify(email, Info);

notify(console, Info) -> 
    gen_server:cast({global, ?MODULE},{console_sync, Info});

notify(email, Info) -> 
    gen_server:cast({global, ?MODULE},{email, Info});

notify(grisp_connection_timeout, Info) -> 
    notify(console,Info);   

notify(Dest, _Info) -> {nomatch,Dest}.

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

handle_cast({console_sync,Info}, State) ->
    io:fwrite("Notify to console: ~p\n",[Info]),
    {noreply, State};

handle_cast({email,Info}, State) ->
    send_email(Info),
    {noreply, State};

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(Info,State) ->
    {noreply, Info, State}.

terminate(_Reason, _State) -> ok.

code_change(_OldVersion,State,_Extra) -> 
    {ok, State}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

send_email(Text) -> 
   gen_smtp_client:send(
    {
        "kotosusel@gmail.com",
        ["alek.lisiecki@gmail.com"],
        Text
    },
   [
        {relay, "smtp.gmail.com"},
        {port, 587 }, 
        {username, "kotosusel@gmail.com"}, 
        {password, "MojeSuperTajneHasło123"}
    ]).
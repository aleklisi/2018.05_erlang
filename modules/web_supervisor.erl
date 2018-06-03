-module(web_supervisor).
-author('AleksanderLisiecki').

-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).
 
start_link() ->
    supervisor:start_link({global,?MODULE}, ?MODULE, []).

init([]) -> 
    RestartStrategy = one_for_one,
    MaxRestarts = 3,
    MaxSecondsBetweeenRestarts = 5,
    Flags = {RestartStrategy, MaxRestarts, MaxSecondsBetweeenRestarts},
    Restart = permanent,
    Shutdown = infinity,
    Type = worker,
    ChildSpec = {web_serverID, 
        {web_server, start_link, []},
        Restart, Shutdown, Type, [web_server]},
    {ok,{Flags,[ChildSpec]}}.
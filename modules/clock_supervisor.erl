-module(clock_supervisor).
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
    Shutdown = brutal_kill,
    Type = worker,
    ChildSpecClock = {clockID, 
        {clock, start_link, []},
        Restart, Shutdown, Type, [clock]},
    {ok,{Flags,[ChildSpecClock]}}.
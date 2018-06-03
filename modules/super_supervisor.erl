-module(super_supervisor).
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
    Type = supervisor,
    ChildSpecWeb = {web_supervisorID, 
        {web_supervisor, start_link, []},
        Restart, Shutdown, Type, [web_supervisor]},
    ChildSpecNotifier = {notifier_supervisorID, 
        {notifier_supervisor, start_link, []},
        Restart, Shutdown, Type, [notifier_supervisor]},
    {ok,{Flags,[ChildSpecWeb, ChildSpecNotifier]}}.
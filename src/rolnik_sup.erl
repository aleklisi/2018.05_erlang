% @doc rolnik top level supervisor.
% @end
-module(rolnik_sup).

-behavior(supervisor).

% API
-export([start_link/0]).

% Callbacks
-export([init/1]).

%--- API -----------------------------------------------------------------------

start_link() -> supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%--- Callbacks -----------------------------------------------------------------

init([]) -> {ok, { {one_for_all, 0, 1},
                   [rolnik_db(),
                    temperature_sensor(1000)]}}.


temperature_sensor(Time) ->
    #{id => temperature_sensor,
	  start => {temperature_sensor, start_link, [
          #{
            repeat_after => Time
          }
      ]},
      restart => permanent,
      shutdown => brutal_kill,
      type => worker}.

rolnik_db() ->
    #{id => rolnik_db,
      start => {rolnik_db, start_link, []},
      restart => permanent,
      shutdown => 1000,
      type => worker,
      modules => [rolnik_db]}.

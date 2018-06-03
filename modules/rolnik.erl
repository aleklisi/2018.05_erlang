-module(rolnik).
-author('AleksanderLisiecki').

-behaviour(application).
-export([start/0, start/2, stop/0, stop/1]).

start() -> application:start(rolnik).

stop() -> application:stop(rolnik).

start(_Type, _Args) ->
    notifier_supervisor:start_link().

stop(_State) ->
    ok.
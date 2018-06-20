-module(rolnik).
-author('AleksanderLisiecki').

-behaviour(application).
-export([start/0, start/2, stop/0, stop/1]).

start() -> application:start(rolnik).

stop() -> application:stop(rolnik).

start(_Type, _Args) ->
    database:init(),
    application:start(inets),
    application:start(crypto),
    application:start(asn1),
    application:start(public_key),
    application:start(ssl),
    super_supervisor:start_link().

stop(_State) ->
    database:terminate(),
    application:stop(inets),
    application:stop(crypto),
    application:stop(asn1),
    application:stop(public_key),
    application:stop(ssl),
    ok.
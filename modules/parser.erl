-module(parser).
-author('AleksanderLisiecki').

-export([parse_message/1]).

parse_message(Message) ->
    try
        {ok, Tokens, _EndLocation} = erl_scan:string(Message),
        [temperature,2,humidity,3] = [X || {_,_,X} <- Tokens],
        {{temperature,2},{humidity,3}}
    catch
        _:_ -> {nomatch,Message}
    end.

-module(parser).
-author('AleksanderLisiecki').

-export([parse_message/1]).

parse_message(Message) ->
    try
        {ok, Tokens, _EndLocation} = erl_scan:string(Message),
        [temperature,Temp,humidity,Hum] = [X || {_,_,X} <- Tokens],
        {{temperature,round(Temp)},{humidity,round(Hum)}}
    catch
        _:_ -> {nomatch,Message}
    end.
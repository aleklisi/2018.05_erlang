-module(grisp_sym).
-author('AleksanderLisiecki').

-export([start/2]).

start(Processes,Reguests) when Processes > 0-> 
    spawn(fun() -> send_request(Reguests) end),
    start(Processes-1,Reguests);
start(_,_) -> ok.

% cd("C:/Users/sebac/Documents/GitHub/2018.05_erlang/tests").
send_request(N) when N > 0 -> 
    Temp = rand:uniform(20) + 5,
    Hum = rand:uniform(100),
    Request = lists:flatten(
        io_lib:format(
            "http://127.0.0.1:8080/erl/web_server:send_measurement?{{temperature,~p},{humidity,~p}}",
            [Temp,Hum])),
    %io:fwrite("~p\n",[Request]),
    %timer:sleep(1001),
    httpc:request(get, {Request, []}, [], []),
    send_request(N-1);
send_request(0) -> 
    Request = lists:flatten(
    io_lib:format(
        "http://127.0.0.1:8080/erl/web_server:send_measurement?{{temperature,~p},{humidity,~p}}",
        [-1,5])),
        
httpc:request(get, {Request, []}, [], []),
    ok;
send_request(_) -> ok.


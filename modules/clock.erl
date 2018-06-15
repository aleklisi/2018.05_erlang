-module(clock).
-author('AleksanderLisiecki').

-export([start_link/0,send_data_received/0]).
-define(TIMEOUT, 10000).

start_link() -> 
    ClockPID = spawn_link(fun loop/0),
    register(clockPID,ClockPID),
    {ok,ClockPID}.

send_data_received() -> clockPID ! data_received.

loop() ->
    receive
        data_received -> 
            io:fwrite("CLK data_received\n",[]),
            loop();
        terminate -> 
            io:fwrite("CLK terminate\n",[]),
            exit(self(),kill)
    after
        ?TIMEOUT -> 
            io:fwrite("CLK TimeoutMiliseconds\n",[]),            
            notifier_gen_server:notify(all, io_lib:format("GRiSP response timeout (~p miliseconds) exceeded!!",[?TIMEOUT])),
            loop()
    end.
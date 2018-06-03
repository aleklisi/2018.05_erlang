-module(notifier).
-author('AleksanderLisiecki').

-export([start/0, stop/0, write_to_console/1]).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%Client  Functions
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
start() -> notifier_gen_server:start_link().

stop() -> notifier_gen_server:stop().

write_to_console(Info) -> notifier_gen_server:write_to_console_sync(Info).


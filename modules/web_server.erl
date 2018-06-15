-module(web_server).
-author('AleksanderLisiecki').

-export([start_link/0, stop/0]).
-export([temperature/3, humidity/3, send_measurement/3]).

stop() -> inets:stop().

start_link() ->
    inets:start(),
    inets:start(httpd, [ 
      {modules, [ 
         mod_alias, 
         mod_auth, 
         mod_esi, 
         mod_actions, 
         mod_cgi, 
         mod_dir,
         mod_get, 
         mod_head, 
         mod_log, 
         mod_disk_log 
      ]}, 
      
      {port,8080}, 
      {server_name,"web_server"}, 
      {server_root,"../bin/tmp"}, 
      {document_root,"../bin/tmp/htdocs"}, 
      {erl_script_alias, {"/erl", [web_server]}}, 
      {error_log, "error.log"}, 
      {security_log, "security.log"}, 
      {transfer_log, "transfer.log"}, 
      
      {mime_types,[ 
         {"html","text/html"}, {"css","text/css"}, {"js","application/x-javascript"} ]} 
   ]). 
         
temperature(SessionID, _Env, _Input) ->
      {ok, BeforeTable} = file:read_file("../web/top.html"),
      Filename = "../data/temperature.csv",
      {ok, Plot} = file:read_file(Filename),
      {ok, AfterTable} = file:read_file("../web/bottom.html"),
      mod_esi:deliver(SessionID, [ 
      "Content-Type: text/html\r\n\r\n", binary_to_list(BeforeTable) ++ binary_to_list(Plot) ++ binary_to_list(AfterTable) ]).
      
humidity(SessionID, _Env, _Input) ->
      {ok, BeforeTable} = file:read_file("../web/top.html"),
      Filename = "../data/humidity.csv",
      {ok, Plot} = file:read_file(Filename),
      {ok, AfterTable} = file:read_file("../web/bottom.html"),
      mod_esi:deliver(SessionID, [ 
      "Content-Type: text/html\r\n\r\n", binary_to_list(BeforeTable) ++ binary_to_list(Plot) ++ binary_to_list(AfterTable) ]).

send_measurement(SessionID, _Env, Input) ->
      io:fwrite("HTTP server received ~p\n",[Input]),
      router_gen_server:propagate_message(Input),
      Top = "<html><header><title>Measurement Received Thanks :)</title></header><body>",
      Bottom = "</body></html>",
      mod_esi:deliver(SessionID, [ "Content-Type: text/html\r\n\r\n", Top ++ Input ++ Bottom ]).

      
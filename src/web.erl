-module(web).
-export([start/0,service/3]). 

start() ->
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
      
      {port,8081}, 
      {server_name,"web"}, 
      {server_root,"./rolnik/web"}, 
      {document_root,"./"}, 
      {erl_script_alias, {"/erl", [web]}}, 
      {error_log, "error.log"}, 
      {security_log, "security.log"}, 
      {transfer_log, "transfer.log"}, 
      
      {mime_types,[ 
         {"html","text/html"}, {"css","text/css"}, {"js","application/x-javascript"} ]} 
   ]). 
         
service(SessionID, _Env, _Input) -> 
   {ok, Top} = file:read_file("./rolnik/web/top.html"),
   {ok, Bottom} = file:read_file("./rolnik/web/bottom.html"),
   Measurements = rolnik_db:dump(<<"temperature">>),
   mod_esi:deliver(SessionID, 
   [
      "Content-Type: text/html\r\n\r\n",
      binary_to_list(Top) ++ binary_to_list(Measurements) ++ binary_to_list(Bottom)]).


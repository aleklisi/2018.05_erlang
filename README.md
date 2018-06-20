% Change to your path to repo

cd("C:/Users/alekl/Documents/ErlangProtorypes/2018.05_erlang/bin").

% Compile all modules

c("../gen_smtp-master/src/binstr.erl").
c("../gen_smtp-master/src/gen_smtp_application.erl").
c("../gen_smtp-master/src/gen_smtp_client.erl").
c("../gen_smtp-master/src/gen_smtp_server.erl").
c("../gen_smtp-master/src/gen_smtp_server_session.erl").
c("../gen_smtp-master/src/mimemail.erl").
c("../gen_smtp-master/src/smtp_server_example.erl").
c("../gen_smtp-master/src/smtp_util.erl").
c("../gen_smtp-master/src/socket.erl").

c("../modules/database.erl").
c("../modules/logics.erl").
c("../modules/www_updater.erl").
c("../modules/notifier_gen_server.erl").
c("../modules/notifier_supervisor.erl").
c("../modules/clock.erl").
c("../modules/clock_supervisor.erl").
c("../modules/router_gen_server").
c("../modules/web_server.erl").
c("../modules/web_supervisor.erl").
c("../modules/super_supervisor.erl").
c("../modules/rolnik.erl").
c("../modules/parser.erl").

% Loading application

application:loaded_applications().

application:load(rolnik).

application:loaded_applications().

% Starting application

application:start(rolnik).

% Stopping application

application:stop(rolnik).

% Unloading application

application:loaded_applications().

application:unload(rolnik).

application:loaded_applications().

% Tests

c("../tests/database_tests.erl").

database_tests:test().

% Webpages:

% http://127.0.0.1:8080/erl/web_server:humidity

% http://127.0.0.1:8080/erl/web_server:temperature

%sending data

%  httpc:request(get, {"http://127.0.0.1:8080/erl/web_server:send_measurement?give_data_there", []}, [], []).
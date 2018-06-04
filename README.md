% Change to your path to repo

cd("C:/Users/sebac/Documents/GitHub/2018.05_erlang/bin").

% Compile all modules

c("../modules/database.erl").

c("../modules/notifier_gen_server.erl").

c("../modules/notifier_supervisor.erl").

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
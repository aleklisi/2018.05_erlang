-module(temperature_sensor).
-behaviour(gen_server).

-export([start_link/1]).

-export([handle_call/3,
         handle_cast/2,
         handle_info/2,
         init/1,
         terminate/2]).

-export([request_to_influx/1]).


-import(rolnik_device, [device_id_onewire/0,
                        read_temperature_onewire/1]).

%%====================================================================
%% API functions
%%====================================================================

start_link(Args) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, Args, []).

%%====================================================================
%% Gen_server callbacks
%%====================================================================

init(Args) ->
    #{repeat_after := Time} = Args,
    ID = case device_id_onewire() of
        [Id] ->
            Id;
        _ ->
            erlang:error("Could not init termomenter")
    end,
    erlang:send_after(Time, self(), next),
    {ok, Args#{id => ID}}.

handle_info(next, State) ->
    #{
        repeat_after := Time,
        id := ID
    } = State,
    Measurements = read_temperature_onewire(ID),
    %% write to a local log file
    rolnik_db:update(<<"temperature">>, [{"temp", Measurements}]),

    %% write to an external InfluxDB
    request_to_influx(Measurements),

    erlang:send_after(Time, self(), next),

    {noreply, State}.

handle_call(_Args, _From, State) ->
    {reply, ok, State}.

handle_cast(_Args, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

request_to_influx(Measurements) ->
    Body = iolist_to_binary(
             io_lib:format("temperatura,miejsce=szklarnia wartosc=~p",
                           [Measurements])),

    Request = ["POST"," ","/write?db=rolnik"," ","HTTP/1.0","\r\n",
               "content-type: text/plain\r\ncontent-length: ",
               integer_to_list(size(Body)),
               "\r\nconnection: close\r\n",
               "\r\n",Body],

    {ok, Sock} = gen_tcp:connect({10,152,0,29}, 8086, []),
    ok = gen_tcp:send(Sock, Request),
    ok = gen_tcp:close(Sock).
    

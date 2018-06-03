{
    application, rolnik, 
    [
        {description, "app to notify farmer about weatcher condition changes"},
        {vsn, "1"},
        {module, [notifier_gen_server, notifier_supervisor,
        super_supervisor, web_server, web_supervisor]},
        {registered, []},
        {application, [kernel, stdlid]},
        {mod, {rolnik,[]}},
        {env, []}
    ]
}.
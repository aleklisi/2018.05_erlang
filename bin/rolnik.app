{
    application, rolnik, 
    [
        {description, "app to notify farmer about weatcher condition changes"},
        {vsn, "1"},
        {module, [
            super_supervisor,
            notifier_gen_server, router_gen_server, notifier_supervisor,
            web_server, web_supervisor,
            clock, clock_supervisor,
            database, logics, rolnik, www_updater, parser
        ]},
        {registered, [clockPID]},
        {application, [kernel, stdlid]},
        {mod, {rolnik,[]}},
        {env, []}
    ]
}.
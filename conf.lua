function love.conf(t)
    -- Fixed canvas size for web builds
    t.window.width = 1920
    t.window.height = 1080
    t.window.fullscreen = true

    t.window.title = "Deadly Encounter"
    t.window.icon = "assets/UI/menu/logo.png"
    t.window.resizable = false

    -- Threads are not available on the web, so keep this disabled
    t.modules.thread = false
end

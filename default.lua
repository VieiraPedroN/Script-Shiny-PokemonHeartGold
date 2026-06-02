local timer = 0

local tap_button = nil
local tap_timer = 0

local index = 1
local reset_lock = false

local sequence = {

    -- Pular intro
    {button = drastic.C.BUTTON_A, wait = 500},

    -- Iniciar jogo
    {button = drastic.C.BUTTON_A, wait = 120},

    -- Carregar save
    {button = drastic.C.BUTTON_A, wait = 300},

    -- Conversa com Bill
    {button = drastic.C.BUTTON_A, wait = 120},
    {button = drastic.C.BUTTON_A, wait = 120},
    {button = drastic.C.BUTTON_A, wait = 120},
    {button = drastic.C.BUTTON_A, wait = 120},
    {button = drastic.C.BUTTON_A, wait = 120},

    -- Receber eevee
    {button = drastic.C.BUTTON_A, wait = 120},

    -- Conversa com Bill
    {button = drastic.C.BUTTON_A, wait = 120},
    {button = drastic.C.BUTTON_A, wait = 120},

    -- Pular apelido
    {button = drastic.C.BUTTON_B, wait = 500},

    -- Conversa com Bill
    {button = drastic.C.BUTTON_A, wait = 120},
    {button = drastic.C.BUTTON_A, wait = 120},

    -- Abrir menu
    {button = drastic.C.BUTTON_X, wait = 120},

    -- Selecionar pokemon
    {button = drastic.C.BUTTON_DOWN, wait = 90},
    {button = drastic.C.BUTTON_A, wait = 90},

    -- Selecionar eevee
    {button = drastic.C.BUTTON_DOWN, wait = 90},
    {button = drastic.C.BUTTON_DOWN, wait = 90},
    {button = drastic.C.BUTTON_RIGHT, wait = 90},

    -- Verificar shiny
    {button = drastic.C.BUTTON_A, wait = 90},
    {button = drastic.C.BUTTON_A, wait = 90}
}

function reset_script()
    index = 1
    timer = 0
    tap_button = nil
    tap_timer = 0

    print("Script reiniciado")
end

function tap(button)
    tap_button = button
    tap_timer = 5
end

function update_tap()
    local buttons = drastic.get_buttons()

    if tap_timer > 0 then
        drastic.set_buttons(buttons | tap_button)
        tap_timer = tap_timer - 1

    elseif tap_button ~= nil then
        drastic.set_buttons(buttons & (~tap_button))
        tap_button = nil
    end
end

function check_reset_hotkey()

    local buttons = drastic.get_buttons()

    local combo =
        (buttons & drastic.C.BUTTON_L) ~= 0 and
        (buttons & drastic.C.BUTTON_R) ~= 0 and
        (buttons & drastic.C.BUTTON_START) ~= 0 and
        (buttons & drastic.C.BUTTON_SELECT) ~= 0

    if combo and not reset_lock then
        reset_script()
        reset_lock = true
    end

    if not combo then
        reset_lock = false
    end
end

function on_frame_update()

    check_reset_hotkey()
    update_tap()

    if index > #sequence then
        return
    end

    timer = timer + 1

    local current = sequence[index]

    if timer >= current.wait then
        tap(current.button)
        print("Executando comando " .. index)

        index = index + 1
        timer = 0
    end
end
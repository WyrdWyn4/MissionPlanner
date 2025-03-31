local MODE_QTAKEOFF = 13
local MODE_QHOVER = 18
local MODE_QLAND = 20

local target_alt = 10           -- Target AGL altitude
local hover_duration = 10000   -- ms to hover
local descent_rate = 0.5       -- m/s during QLAND

local stage = 0
local hover_start = 0
local initial_alt = nil

gcs:send_text(6, "VTOL QTAKEOFF-hover-land script loaded.")

function update()
    local now = millis()

    -- Stage 0: Wait for arming and valid position
    if stage == 0 then
        if not arming:is_armed() then
            gcs:send_text(6, "Attempting to arm...")
            arming:arm()
            return update, 1000
        end

        local pos = ahrs:get_relative_position_NED_home()
        if not pos then
            gcs:send_text(6, "Waiting for position estimate...")
            return update, 1000
        end

        initial_alt = -pos:z()
        gcs:send_text(6, string.format("Armed. Initial Alt = %.2f. Switching to QTAKEOFF...", initial_alt))
        vehicle:set_mode(MODE_QTAKEOFF)
        stage = 1
        return update, 1000
    end

    -- Stage 1: Wait for climb to complete (10m above initial)
    if stage == 1 then
        local pos = ahrs:get_relative_position_NED_home()
        if pos then
            local current_alt = -pos:z()
            gcs:send_text(6, string.format("Ascending... Alt = %.2f / %.2f", current_alt, initial_alt + target_alt))

            if current_alt >= initial_alt + target_alt - 0.5 then
                gcs:send_text(6, "Reached target. Switching to QHOVER for hover...")
                vehicle:set_mode(MODE_QHOVER)
                hover_start = now
                stage = 2
            end
        end
        return update, 1000
    end

    -- Stage 2: Hover 
    if stage == 2 then
        if now - hover_start >= hover_duration then
            gcs:send_text(6, "Hover complete. Switching to QLAND...")
            vehicle:set_mode(MODE_QLAND)
            stage = 3
        end
        return update, 500
    end

    -- Stage 3: Begin descent
    if stage == 3 then
        if quadplane:in_vtol_land_descent() then
            gcs:send_text(6, "In descent. Slowing descent rate...")
            vehicle:set_land_descent_rate(descent_rate)
            stage = 4
        end
        return update, 500
    end

    -- Stage 4: Descent complete
    return update, 1000
end

return update()
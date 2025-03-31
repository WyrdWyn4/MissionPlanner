function hover()
    if not vehicle:get_likely_flying() then
        gcs:send_text(3, "Drone is not flying.")
        return hover, 2000
    end

    local current_location = ahrs:get_position()
    if current_location then
        vehicle:set_target_location(current_location)
        gcs:send_text(6, "Hovering at current position.")
    else
        gcs:send_text(3, "Unable to get current position.")
    end
    return hover, 5000
end

return hover, 1000

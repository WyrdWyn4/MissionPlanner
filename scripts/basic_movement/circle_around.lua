function circle_around()
    local center = Location()
    center:lat(37.7749 * 1e7)
    center:lng(-122.4194 * 1e7)
    center:alt(1000)
    
    local radius = 50
    local offset_angle = math.rad(45)
    local offset_x = math.cos(offset_angle) * radius
    local offset_y = math.sin(offset_angle) * radius

    local target_location = center:offset(offset_x, offset_y)
    vehicle:set_target_location(target_location)
    gcs:send_text(6, "Circling around the point.")
    return circle_around, 2000
end

return circle_around, 1000

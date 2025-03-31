function move_to_target()
    local target_location = Location()
    target_location:lat(37.7749 * 1e7)
    target_location:lng(-122.4194 * 1e7)
    target_location:alt(1000)

    if vehicle:set_target_location(target_location) then
        gcs:send_text(6, "Moving to target location.")
    else
        gcs:send_text(3, "Failed to set target location.")
    end
end

return move_to_target, 2000

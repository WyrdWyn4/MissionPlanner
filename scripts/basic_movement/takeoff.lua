function takeoff()
    local altitude = 10
    if not vehicle:start_takeoff(altitude) then
        gcs:send_text(3, "Takeoff failed!")
    else
        gcs:send_text(6, "Takeoff initiated to " .. altitude .. " meters.")
    end
    return takeoff, 5000
end

return takeoff, 1000
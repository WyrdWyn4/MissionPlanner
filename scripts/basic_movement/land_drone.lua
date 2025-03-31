function land_drone()
    vehicle:set_mode(9)
    gcs:send_text(6, "Landing initiated.")
    return land_drone, 5000
end

return land_drone, 1000

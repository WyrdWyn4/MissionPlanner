function read_kml_file(file_path)
    local file = io.open(file_path, "r")
    if not file then
        gcs:send_text(3, "Error: Cannot open file " .. file_path)
        return nil
    end
    local content = file:read("*all")
    file:close()
    return content
end

function parse_kml(content)
    local placemarks = {}
    for name, coordinates in string.gmatch(content, "<Placemark>.-<name>(.-)</name>.-<coordinates>(.-)</coordinates>.-</Placemark>") do
        local coord_parts = {}
        for value in string.gmatch(coordinates, "([^,]+)") do
            table.insert(coord_parts, tonumber(value))
        end
        if #coord_parts == 3 then
            table.insert(placemarks, {
                name = name,
                longitude = coord_parts[1],
                latitude = coord_parts[2],
                altitude = coord_parts[3]
            })
        end
    end
    return placemarks
end

function main()
    local file_path = "scripts/parsers/map.kml"
    local kml_content = read_kml_file(file_path)

    if not kml_content then
        return
    end

    local placemarks = parse_kml(kml_content)
    for _, placemark in ipairs(placemarks) do
        gcs:send_text(6, string.format(
            "Name: %s, Latitude: %.6f, Longitude: %.6f, Altitude: %.2f",
            placemark.name, placemark.latitude, placemark.longitude, placemark.altitude
        ))
    end
end

return main, 1000

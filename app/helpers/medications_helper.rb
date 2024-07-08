module MedicationsHelper
        def rgb_to_hex(rgb_string)
                # Extract RGB values from the string
                return "#000000" if rgb_string.empty? || !rgb_string.match?(/rgb\s*\(\s*\d+\s*,\s*\d+\s*,\s*\d+\s*\)/)
                rgb_values = rgb_string.scan(/\d+/)
                
                # Convert RGB to hex
                hex_color = "#"
                rgb_values.each do |value|
                  hex_color += value.to_i.to_s(16).rjust(2, '0')
                end
                
                hex_color
        end
end

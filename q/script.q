\d .f

hex_to_dec: {[hex] if[1>=count hex; :0]; :16 sv "0123456789abcdef"?/:/:hex}

split_record: {[rec] " " vs rec}

convert_low_high_hex_bytes_to_dec: {[hex_pair] dec_pair: asc raze hex_to_dec each hex_pair; `float$dec_pair[0] + 0.25 * abs dec_pair[0] - dec_pair[1]}

parse_cmd_axes: {[cmd] split_cmd: split_record[cmd]; :(split_cmd(2;3); split_cmd(4;5); split_cmd(6;7))}

split_stream_by_attr: {[stream; att; att_map] subset_stream_by_attr_hex[stream; att_map[att]]}[;;`acceleration`angular_velocity`angle!("51";"52";"53")]

subset_stream_by_attr_hex: {[stream; att_hex] stream where (att_hex like) each (split_record each stream)[;1]}

wrapper_convert_low_high_hex_bytes_to_dec: {[hex_axes] convert_low_high_hex_bytes_to_dec each raze hex_axes}

wrapper_parse_subset_cmd_by_attr: {[stream; att] wrapper_convert_low_high_hex_bytes_to_dec each enlist parse_cmd_axes each split_stream_by_attr[stream; att]}

get_stream: {[file] ("55 ",) each trim 1 _ "55" vs ssr["c"$read1 hsym file; "\n"; " "]}[`stream_hex.log]

\d .

get_stream_axes: {[stream; att] {[att; axis_ind] (3 cut raze .f.wrapper_parse_subset_cmd_by_attr[get_stream[]; att])}[att;] each til 3}[.f.get_stream[];]

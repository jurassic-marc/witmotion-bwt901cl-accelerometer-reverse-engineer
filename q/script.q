\d .f

file: `$"/path/to/witmotion-bwt901cl-accelerometer-reverse-engineer/log/stream_hex_live.log"

h: hopen hsym file
command_indexes: (2;3;4;5;6;7)
//if based on OS
wrapper_get_stream: {[file_handle] data: trim "55" vs " " sv get_stream[file_handle]; 
                                   :("55 ",) each data[where 29 = count each data]
                    }

wrapper_get_stream: {[file_handle] data: trim "55" vs " " sv {x[where not ("\r" = x) or "\000" = x]} each get_stream[file_handle]; 
                                   :("55 ",) each data[where 29 = count each data]}

get_stream: {[file_handle] :read0 file_handle}

split_stream_by_attribute: {[stream; attribute; attribute_map] subset_stream_by_attribute_hex[stream; attribute_map[attribute]]}[;;`acceleration`angular_velocity`angle!("51";"52";"53")]

subset_stream_by_attribute_hex: {[stream; attribute_hex] stream where (attribute_hex like) each (split_records[stream])[;1]}

split_records: {[records] :split_record each records}

split_record: {[record] " " vs record}

subset_command_axes: {[commands] :split_records[commands][;command_indexes]}

parse_command_axes: parse_command_axes: {[commands] :parse_command each commands}

parse_command: {[command] :2 cut command}

wrapper_low_high_hex_bytes_to_dec: {[hex_axes] :low_to_high_dec_pairs_mapping each hex_pairs_to_dec_pairs each hex_axes}

low_to_high_dec_pairs_mapping: {[dec_pairs] :calc_dec_from_low_high_dec_pair each dec_pairs}

// current calc based off angle
calc_dec_from_low_high_dec_pair: {[dec_pair] low_dec: asc dec_pair[0]; high_dec: asc dec_pair[1]
                                             :180*(low_dec + high_dec * `int$2 xexp 8) % 32768: 
                                 }

hex_pairs_to_dec_pairs: {[hex_pairs] :low_high_hex_bytes_to_dec each hex_pairs}

low_high_hex_bytes_to_dec: {[hex_pair] :hex_to_dec each hex_pair}

hex_to_dec: {[hex] if[1>=count hex; :0]; :16 sv "0123456789abcdef"?/:/:hex}

wrapper: {[stream; attribute] stream_attribute: split_stream_by_attribute[stream; attribute]; 
                              stream_attribute_commands: subset_command_axes[stream_attribute]; 
                              stream_attribute_commands_high_low: parse_command_axes[stream_attribute_commands]; 
                              stream_attribute_commands_high_low_dec: wrapper_low_high_hex_bytes_to_dec[stream_attribute_commands_high_low]; 
                              :stream_attribute_commands_high_low_dec
         }

\d .

get_stream_axes: {[stream; attribute] :.f.wrapper[stream; attribute]}

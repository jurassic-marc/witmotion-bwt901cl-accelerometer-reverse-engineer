hex_to_dec: {[hex] if[1>=count hex; :0]; :16 sv "0123456789abcdef"?/:/:hex}

split_record: {[rec] " " vs rec}

convert_low_high_hex_bytes_to_dec: {[hex_pair] dec_pair: asc raze hex_to_dec each hex_pair; `float$dec_pair[0] + 0.25 * abs dec_pair[0] - dec_pair[1]}

parse_cmd_axes: {[cmd] split_cmd: split_record[cmd]; :(split_cmd(2;3); split_cmd(4;5); split_cmd(6;7))}

split_stream_by_attr: {[stream; att; att_map] subset_stream_by_attr_hex[stream; att_map[att]]}[;;`acceleration`angular_velocity`angle!("51";"52";"53")]

subset_stream_by_attr_hex: {[stream; att_hex] stream where (att_hex like) each (split_record each stream)[;1]}

wrapper_convert_low_high_hex_bytes_to_dec: {[hex_axes] convert_low_high_hex_bytes_to_dec each raze hex_axes}

func: {[stream; att] wrapper_convert_low_high_hex_bytes_to_dec each enlist parse_cmd_axes each split_stream_by_attr[stream; att]}


file: "c"$read1 `:stream_hex.log

stream: ("55 ",) each trim 1 _ "55" vs ssr[file; "\n"; " "]

get_stream: {[file] ("55 ",) each trim 1 _ "55" vs ssr["c"$read1 hsym file; "\n"; " "]}[`stream_hex.log]

tbl: ([]ts:`timestamp$(); val:`float$())

tbl1: ([]ts:`timestamp$(); val_x:`float$(); val_y:`float$(); val_z:`float$())

x_axis: (3 cut raze func[get_stream[];`angle])[;0]
y_axis: (3 cut raze func[get_stream[];`angle])[;1]
z_axis: (3 cut raze func[get_stream[];`angle])[;2]

TIME_OFFSET: 10000

\l kdb-tick/tick/u.q

.u.init[]

START_TIME: .z.p

.z.ts: {.u.pub[`tbl1;enlist `ts`val_x`val_y`val_z!(.z.p,{x[`int$`second$abs START_TIME - .z.p]} each (x_axis;y_axis;z_axis))]}

.u.snap: {tbl}

scores: ([] score:`40_plus`60_plus`80_plus`100_plus`120_plus`140_plus`180; frequency: (5;6;4;1;2;0;0))

doubles: ([] double: (`20`1`18`4`13`6`10`15`2`17`3`19`7`16`8`11`14`9`12`5`bull); attempts: 21#0; hits: 21#0; rate: 21#0.0)

update attempts: 4, hits: 0 from `doubles where double=`20;
update attempts: 2, hits: 1 from `doubles where double=`10;
update attempts: 1, hits: 0 from `doubles where double=`5;
update attempts: 3, hits: 0 from `doubles where double=`16;
update attempts: 3, hits: 1 from `doubles where double=`8;
update attempts: 1, hits: 0 from `doubles where double=`4;
update attempts: 5, hits: 2 from `doubles where double=`14;
update attempts: 3, hits: 0 from `doubles where double=`7;

update rate: hits%attempts from `doubles;

averages: ([] average_type: (`3_dart;`9_dart;`overall); average: (52.8;49.1;44.6))

\t 1000

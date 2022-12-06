\l ./q/script.q
\l ./q/pop.q
\l /path/to/kdb-tick/tick/u.q

streaming_angle: ([] ts:`timestamp$(); x_angle:`float$(); y_angle:`float$(); z_angle:`float$())
streaming_acceleration: ([] ts:`timestamp$(); x_acceleration:`float$(); y_acceleration:`float$(); z_acceleration:`float$())
streaming_angular_velocity: ([] ts:`timestamp$(); x_angular_velocity:`float$(); y_angular_velocity:`float$(); z_angular_velocity:`float$())

.u.init[]
.u.snap: {streaming_angle;
          streaming_acceleration;
          streaming_angular_velocity;
         }

stream_angle: ();

collect: {[] stream_angle:: get_stream_axes[.f.wrapper_get_stream[.f.h]; `angle]}

.z.ts: { collect[];
         .u.pub[`streaming_angle; flip `ts`x_angle`y_angle`z_angle!flip {[record] :.z.p, record} each stream_angle];
       }

\p 6010
\t 100

\l script.q
\l pop.q
\l kdb-tick/tick/u.q

streaming_angle: ([] ts:`timestamp$(); x_angle:`float$(); y_angle:`float$(); z_angle:`float$())
streaming_acceleration: ([] ts:`timestamp$(); x_acceleration:`float$(); y_acceleration:`float$(); z_acceleration:`float$())
streaming_angular_velocity: ([] ts:`timestamp$(); x_angular_velocity:`float$(); y_angular_velocity:`float$(); z_angular_velocity:`float$())

.u.init[]
.u.snap: {streaming_angle;
          streaming_acceleration;
          streaming_angular_velocity;
         }

.z.ts: {.u.pub[`streaming_angle; enlist `ts`x_angle`y_angle`z_angle!(.z.p,{[axis_angle] axis_angle} each get_stream_axes[`angle]})];
        .u.pub[`streaming_acceleration; enlist `ts`x_acceleration`y_acceleration`z_acceleration!(.z.p,{[axis_acceleration] axis_acceleration} each get_stream_axes[`acceleration]})];
        .u.pub[`streaming_angular_velocity; enlist `ts`x_angular_velocity`y_angular_velocity`z_angular_velocity!(.z.p,{[axis_angular_velocity] axis_angular_velocity} each get_stream_axes[`angular_velocity]})]
       }

\p 6010
\t 100
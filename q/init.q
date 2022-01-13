\l /home/marc/Documents/witmotion-bwt901cl-accelerometer-reverse-engineer/src/script.q
\l /home/marc/Documents/witmotion-bwt901cl-accelerometer-reverse-engineer/data/pop.q
\l /home/marc/kdb-tick/tick/u.q

streaming_angle: ([] ts:`timestamp$(); x_angle:`float$(); y_angle:`float$(); z_angle:`float$())
streaming_acceleration: ([] ts:`timestamp$(); x_acceleration:`float$(); y_acceleration:`float$(); z_acceleration:`float$())
streaming_angular_velocity: ([] ts:`timestamp$(); x_angular_velocity:`float$(); y_angular_velocity:`float$(); z_angular_velocity:`float$())

waves: ([] ts:`timestamp$(); x:`float$(); y:`float$(); z:`float$())
.math.pi: acos -1
.math.sineWave: {[t;a;f;phase] a * sin[phase+2*.math.pi*f*t]}

.u.init[]
.u.snap: {streaming_angle;
          streaming_acceleration;
          streaming_angular_velocity;
         }

stream: 0

a: {stream:: get_stream_axes[.f.wrapper_get_stream[.f.h]; `angle]}

.z.ts: {a[]; .u.pub[`streaming_angle; flip `ts`x_angle`y_angle`z_angle!flip {[record] :.z.p, record} each stream]}

.u.snap: {waves}

.z.ts: { .u.pub[`waves; enlist `ts`x`y`z!(.z.p,{.math.sineWave[.z.p;1.4;1e-10f;x]-0.4+x%3} each til 3)] }

\p 6010
\t 1000

.ringBuffer.read: {[t;i] $[i <= count t; i#t; i rotate t]}
.ringBuffer.write: {(t;r;i) @[t; (i mod count value t) + til 1;:;r];}

.stream.i: 0-1
.stream.streaming_angle: 1000#streaming_angle

.stream.angleGen: {a[]; res: flip `ts`angle_x`angle_y`angle_z!flip {[record] :.z.p, record} each stream; .ringBuffer.write[`.stream.streaming_angle; res; .stream.i+:1]; :res}


// .z.ts: {.u.pub[`streaming_angle; .stream.angleGen[]]}

// .u.snap: {[x] .ringBuffer.read[.stream.streaming_angle; .stream.i]}




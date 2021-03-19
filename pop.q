scores: ([] score: (`40_plus`60_plus`80_plus`100_plus`120_plus`140_plus`180); frequency: (5;6;4;1;2;0;0))

doubles: ([] double: (`20`1`18`4`13`6`10`15`2`17`3`19`7`16`8`11`14`9`12`5`bull); attempts: 21#0; hits: 21#0; rate: 21#0.0)

update attempts: 30, hits: 0 from `doubles where double=`1;
update attempts: 28, hits: 0 from `doubles where double=`2;
update attempts: 40, hits: 0 from `doubles where double=`3;
update attempts: 58, hits: 0 from `doubles where double=`4;
update attempts: 43, hits: 0 from `doubles where double=`5;
update attempts: 40, hits: 0 from `doubles where double=`6;
update attempts: 17, hits: 0 from `doubles where double=`7;
update attempts: 35, hits: 0 from `doubles where double=`8;
update attempts: 73, hits: 0 from `doubles where double=`9;
update attempts: 24, hits: 0 from `doubles where double=`10;
update attempts: 54, hits: 0 from `doubles where double=`11;
update attempts: 69, hits: 0 from `doubles where double=`12;
update attempts: 56, hits: 0 from `doubles where double=`13;
update attempts: 46, hits: 0 from `doubles where double=`14;
update attempts: 39, hits: 1 from `doubles where double=`15;
update attempts: 47, hits: 0 from `doubles where double=`16;
update attempts: 40, hits: 0 from `doubles where double=`17;
update attempts: 39, hits: 1 from `doubles where double=`18;
update attempts: 45, hits: 0 from `doubles where double=`19;
update attempts: 37, hits: 2 from `doubles where double=`20;
update attempts: 57, hits: 0 from `doubles where double=`bull;

update rate: hits%attempts from `doubles;
update avg_darts: attempts%hits from `doubles;

averages: ([] average_type: (`3_dart;`9_dart;`overall); average: (44.8;52.9;44.6))
scores: ([] score: (`40_plus`60_plus`80_plus`100_plus`120_plus`140_plus`180); frequency: (5;6;4;1;2;0;0))

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

averages: ([] average_type: (`3_dart;`9_dart;`overall); average: (44.8;52.9;44.6))
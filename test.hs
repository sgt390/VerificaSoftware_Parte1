-- setup unit-tests
-- "x=2 y = 5 f 1 (x) = 4 f 2 (y,x) = 5"
-- "x=2 y = 5 f 1 (x) = 4 f 2 (y,x) = if x then y else 2"
-- "x=2 y = 5 f 1 (x) = 4 f 2 (y,x) = if if x then y else (x-1) then (y-3*2) else (5+1)"
-- "x=2 y = 5 f 1 (x) = 4 f 2 (y,x) = if if x then f 2 (x,y,z) else (x-1) then (y-3*2) else (5+1)"
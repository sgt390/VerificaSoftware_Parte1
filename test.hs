-- setup unit-tests
-- "x=2 y = 5 x+100 f 1 (x) = 4+x f 2 (y,x) = 5"
-- "x=2 y = 5 if x+10 then 1 else 0 f 1 (x) = 4+x f 2 (y,x) = 5"
-- "x=2 y=-4 f 1 (x,y) f 1 (z,d) = x+y+100+f 1 (4) f 2 (z) = 5-z"
-- "

import Control.Monad

ax :: [Int]
ax = [1,2,3,4,5]
b = ax >>= \x->[x+1]
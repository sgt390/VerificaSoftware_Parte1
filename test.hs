-- setup unit-tests
-- "x=2 y = 5 x+100 f 1 (x) = 4+x f 2 (y,x) = 5"
-- "x=2 y = 5 if x+10 then 1 else 0 f 1 (x) = 4+x f 2 (y,x) = 5"
-- "x=2 y = 5 f 1 (x) f 1 (x) = 4+x f 2 (y,x) = 5"
-- "x=2 y = 5 6 f 1 (x) = 4 f 2 (y,x) = if x then y else 2"
-- "x=2 y = 5 x2 f 1 (x) = 4 f 2 (y,x) = if if x then y else (x-1) then (y-3*2) else (5+1)"
-- "
{--
a = 4096

x 1 f = f 500
x n f = f (x (n-1) f)

f x = 1/2*(a/x+x)
--}

-- *Main> x 8 f : 8 is the "cicles" 

import Control.Monad

ax :: [Int]
ax = [1,2,3,4,5]
b = ax >>= \x->[x+1]
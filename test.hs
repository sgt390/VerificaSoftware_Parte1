-- setup unit-tests
-- "x=2 y = 5 x+100 f 1 (x) = 4+x f 2 (y,x) = 5"
-- "x=2 y = 5 if x+10 then 1 else 0 f 1 (x) = 4+x f 2 (y,x) = 5"
-- "x=2 y=-4 f 1 (x,y) f 1 (z,d) = x+y+100+f 1 (4) f 2 (z) = 5-z"
-- "

import Control.Monad

a :: Int -> Maybe Int
a x = Just (x + 1)

c :: (Maybe Int -> Maybe Int) -> Int -> (Int -> Maybe Int)
c f 0 = \x -> Just 0
c f n = f . (c f (n-1))
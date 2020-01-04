module Main1 where
-- read a file and output the result
import Parse
import ParseRec
import Types
import SemanticsRec
import State.State


-- setup unit-tests
-- "x=2 y = 5 x+100 f 1 (x) = 4+x f 2 (y,x) = 5"
-- "x=2 y = 5 if x+10 then 1 else 0 f 1 (x) = 4+x f 2 (y,x) = 5"
-- "x=2 y=-4 f 1 (f(1),y) f 1 (z,d) = x+y+100+f 1 (4) f 2 (z) = 5-z"

inp = "x=2 y = 5 f 1 (5) f 1 (x) = if x then 1 else x * f 1 (x-1) f 2 (x) = 4+x"
readp :: Program
readp = let [(a,b)] = (parse parseREC inp) in a

debugp = \input -> let [(a,b)] = (parse parseREC input) in show a ++ "_______________________" ++ b

--sem :: Program -> Int 
--sem (d, t, e) = (semantics t) (lub fix (F)) e -- <<<<<<<<<<<<<<<<<<<<< TODO :)



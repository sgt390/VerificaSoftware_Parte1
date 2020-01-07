module Main where
-- read a file and output the result
import Parse
import ParseRec
import Types
import SemanticsRec
--import State.State
import Fix

-- setup unit-tests
-- "x=2 y = 5 x+100 f 1 (x) = 4+x f 2 (y,x) = 5"
-- "x=2 y = 5 if x+10 then 1 else 0 f 1 (x) = 4+x f 2 (y,x) = 5"
-- "x=2 y=-4 f 1 (f(1),y) f 1 (z,d) = x+y+100+f 1 (4) f 2 (z) = 5-z"

inp = "x=2 y=4 x=2 z=70 f 0 (1) f 0 (z) = if z then 0 else f 2 (4,5,6,7) f 1 (z) = z + f 0 (0) -1 f 2 (x,y,z,l)=z+f 1 (3+l)" -- 6+ 10
readp :: Program
readp = let [(a,b)] = (parse parseREC inp) in a

debugp = \input -> let [(a,b)] = (parse parseREC input) in show a ++ "_______________________" ++ b

sem' :: Program -> Int -> Partial Int
sem' (d, t, e) k = semantics t (fn (functional d (envt e)) k bottom) (envt e)

sem :: Program -> Partial Int
sem p = head [sem' p k | k <- [0..], (sem' p k) /= Undef]

main = putStrLn (show (sem readp))



env_demo = envt (let (_,_,e) = readp in e)
subst_demo = subst env_demo (Var 1) "x" "x"
substs_demo = (substs env_demo [Var 1, Var 300] ["x", "x"]) "x"
module Main where
-- read a file and output the result
import Parse
import ParseRec
import Types
import SemanticsRec
import Utilities
import Fix

--inp = "x=2 g (1) f (x) = x+20 g (y) = f(y)"
inp = "x=2 y=4 x=2 z=70 (f (1)) (f(x)=y+z) (g(z) = if z then 0 else f(0))"
readp :: Program
readp = let [(a,b)] = parse parseREC inp in substFun a

debugp = \input -> let [(a,b)] = (parse parseREC input) in show a ++ "++++++++++++++++" ++ b

sem' :: Program -> Int -> Partial Int
sem' (d, t, e) k = semantics t (fn (functional d (envt e)) k bottom) (envt e)

sem :: Program -> Partial Int
sem p = head [sem' p k | k <- [0..], (sem' p k) /= Undef]

main = putStrLn (show (sem (readp)))



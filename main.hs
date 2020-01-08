module Main where
-- read a file and output the result
import Parse
import ParseRec
import Types
import SemanticsRec
import Utilities
import Fix

-- inp = "x=2 g (1) f (x) = x+20 g (y) = f(y)" -- simple
-- inp = "x=2 y=4 x=2 z=70 (g (6)) (f(x)=7) (g(z) = g(z))" -- undending cycle
-- inp = "x=2 y=1 g(3,z(0)) f(x,y)=4+y g(s,longvariable)=f(4,h(s)+1) h(p)=if p then 1000 else 1+h(p-1) z(x)=z(y)" -- g(3) = f(4,h(3)+1) = 4 + (h(3)+1) = 4 + (1+(1+(1+1000)) +1) = 1008
inp = "x=1 g(500) g(x)=x+h() h()=x" -- variables scope
readp :: Program
readp = let [(a,b)] = parse parseREC inp in substFun a

debugp = \input -> let [(a,b)] = (parse parseREC input) in show a ++ "++++++++++++++++" ++ b

sem' :: Program -> Int -> Partial Int
sem' (d, t, e) k = semantics t (fn (functional d (envt e)) k bottom) (envt e)

sem :: Program -> Partial Int
sem p = head [sem' p k | k <- [0..], (sem' p k) /= Undef]

main = putStrLn (show (sem (readp)))



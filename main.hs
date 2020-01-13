module Main where
import Parse
import ParseRec
import Types
import SemanticsRec
import Utilities
import Fix
import FunctionRenaming.State


----------------------------- REC Program Examples -----------------------------
---inp = "x=2 g (1) f (x) = x+20 g (y) = f(y)" -- simple
--inp = "x=2 y=4 x=2 z=70 (f (g(1))) f(x)=x+1 g(x)=g(x)" -- unending calls (def)
inp = "x=2 y=4 x=2 z=70 (f (g(1))) f(x)=7 g(x)=g(x)" -- vall by name
--g(3) = f(4,h(3)+1) = 4 + (h(3)+1) = 4 + (1+(1+(1+1000)) +1) = 1008

{-
inp = " \
\x=2 y=1 \
\g(3,z(0)) \
\f(x,y)=4+y \
\g(s,longvariable)=f(4,h(s)+1) \
\h(p)=if p then 1000 else 1+h(p-1) \
\z(x)=z(y)"
-}

---inp = "x=1 g(500) g(x)=x+h() h()=x" -- variables scope 501

readp :: Program
readp = let [(a,b)] = parse parseREC inp in substFun a

debugp = \input -> let [(a,b)] = (parse parseREC input) in show a ++ "++++++++++++++++" ++ b

-- evaluates the term t given an enviroment e
evalk :: Program -> Int -> Partial Int
evalk (d, t, e) = \k -> semantics t (f_n f k bottom) env 
                   where env = envt e
                         f = functional d env -- functional induced by d (calculated only once)

evaluate :: Program -> Partial Int
evaluate p = head [val | val <- map eval [0..], val /= Undef]
                where eval = evalk p

main = putStrLn (show (evaluate (readp)))


module Main where
import Parse
import ParseRec
import Types
import SemanticsRec
import Utilities
import Fix
import FunctionRenaming.State


----------------------------- REC Program Examples -----------------------------
-- KEEP ONLY ONE UNCOMMENTED --
---inp = "x=2 g (1) f (x) = x+20 g (y) = f(y)" -- simple
---inp = "x=2 (g (6)) (g(z) = 3+g(3+z)+3)" -- undending cycle

inp = "x=2 y=4 x=2 z=70 (f (g(1))) f(x)=7 g(x)=g(x)" -- call by name (g is ignored)

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
--------------------------------------------------------------------------------

-- Syntactic parting --
readp :: Program
readp = let [(a,b)] = parse parseREC inp in substFun a

-- (testing) output the parsed program and the error (if exists) --
debugp = \input -> let [(a,b)] = (parse parseREC input) in show a ++ "++++++++++++++++" ++ b

-- Semantics of the term 't' given an enviroment 'e' and a function enviroment 'd',
-- given k=maximum number of applications of the function f to itself.
-- eg. k=4 => f(f(f(Bottom))))
evalk :: Program -> Int -> Partial Int
evalk (d, t, e) = \k -> semantics t (f_n f k bottom) env 
                   where env = envt e
                         f = functional d env -- functional induced by d (computed only once)

-- Compute the least upper bount of the functional induced by the definition of the
-- function enviroment defined in the program p, which its fixed point (one of many).
-- Haskell helps with this task, because as soon as a value different from Undef
-- is found, "head" returns that value, without computing the rest (lazy evaluation).
evaluate :: Program -> Partial Int
evaluate p = head [val | val <- map eval [0..], val /= Undef]
                where eval = evalk p

-- Call the function "main" to compute the uncommented program.
main = putStrLn (show (evaluate (readp)))


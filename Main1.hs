module Main1 where
-- read a file and output the result
import Parse
import ParseRec
import Types
import SemanticsRec
import State.State

readp :: [Char] -> Program
readp program = let [(a,b)] = (parse parseREC program) in a

debugp = \input -> show (readp input)

sem :: Program -> Maybe Int 
sem (d, t, e) = app (semantics t) (S (e, d))



module Main1 where
-- read a file and output the result
import Parse
import ParseRec

readp input = let [(a,b)] = (parse parseREC input) in show a ++ "___________and_______" ++ show b

module Utilities where

import Types
--import Data.Sort

partialSum :: Partial Int -> Partial Int -> Partial Int
partialSum Undef _ = Undef
partialSum _ Undef = Undef
partialSum (Var a) (Var b) = Var (a + b)

partialSub :: Partial Int -> Partial Int -> Partial Int
partialSub Undef _ = Undef
partialSub _ Undef = Undef
partialSub (Var a) (Var b) = Var (a - b)

partialMul :: Partial Int -> Partial Int -> Partial Int
partialMul Undef _ = Undef
partialMul _ Undef = Undef
partialMul (Var a) (Var b) = Var (a * b)

partialIndex :: FEnv -> Int -> F
partialIndex lst i = if (length lst) > i then lst!!i else \x->Undef

getenv :: Program -> Env
getenv (_,_,e) = envt e

-- transforms the syntactic variable enviroment into a 
-- function (the actual variable enviroment)
envt :: VEnv -> Env  
envt ((v, n):venv) = \c -> if c == v
                                 then Var n
                                 else envt venv c
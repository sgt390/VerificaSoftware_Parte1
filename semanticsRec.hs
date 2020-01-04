module SemanticsRec where

import Types
import State.State
import Utilities

type Env = Var -> Partial Int 
type FEnv = Int -> [Partial Int] -> Partial Int
semantics :: Term -> FEnv -> Env -> Partial Int -- Term implict in the definition
semantics (TNum n) = \fenv -> \env -> Var n
semantics (TVar x) = \fenv -> \env -> env x

semantics (TSum t0 t1) = \fenv -> \env -> partialSum (semantics t0 fenv env) (semantics t1 fenv env)

semantics (TSub t0 t1) = \fenv -> \env -> partialSub (semantics t0 fenv env) (semantics t1 fenv env)

semantics (TMul t0 t1) = \fenv -> \env -> partialMul (semantics t0 fenv env) (semantics t1 fenv env)

semantics (TCond t0 t1 t2) = \fenv -> \env -> cond (semantics t0 fenv env) (semantics t1 fenv env) (semantics t2 fenv env) 

semantics (TFun i ts) = \fenv -> \env -> fenv i (semanticsTerms ts fenv env) -- FEnv non è un enviroment
                           
cond :: Partial Int -> Partial Int -> Partial Int -> Partial Int
cond Undef _ _ = Undef
cond (Var c) n1 n2 = if c == 0 then n1 else n2

semanticsTerms :: [Term] -> FEnv -> Env -> [Partial Int]
semanticsTerms [] fenv env = [] 
semanticsTerms (t:ts) fenv env = (semantics t fenv env) : (semanticsTerms ts fenv env) 

--functional :: FEnv -> FEnv
--functional (f:fenv) =  (\params d fenv (sost env params )) : (F fenv) -- xs params of function i 

subst :: Env -> (Partial Int) -> Var -> Env
subst env n x = \y -> if y /= x then env y else n

module SemanticsRec where

import Types
import Utilities

-- Semantics of a single term (call by name)
-- The result is "Partial Int" because the semantics of a term can be
-- evaluated into "Undef". This happens when the FEnv was not
-- fully constructed.
semantics :: Term -> FEnv -> Env -> Partial Int
semantics (TNum n) = \fenv -> \env -> Var n
semantics (TVar x) = \fenv -> \env -> env x

semantics (TSum t0 t1) = \fenv -> \env -> partialSum (semantics t0 fenv env) (semantics t1 fenv env)

semantics (TSub t0 t1) = \fenv -> \env -> partialSub (semantics t0 fenv env) (semantics t1 fenv env)

semantics (TMul t0 t1) = \fenv -> \env -> partialMul (semantics t0 fenv env) (semantics t1 fenv env)

semantics (TCond t0 t1 t2) = \fenv -> \env -> cond (semantics t0 fenv env) (semantics t1 fenv env) (semantics t2 fenv env) 

semantics (TFun (FInt i) ts) = \fenv -> \env ->  (partialIndex fenv i) (semanticsTerms ts fenv env)

cond :: Partial Int -> Partial Int -> Partial Int -> Partial Int
cond Undef _ _ = Undef
cond n0 n1 n2 = case n0 of
                            Var 0 -> n1
                            Var _ -> n2
                            _ -> Undef

-- semantics of multiple terms given a function enviroment (fenv)
-- and a variable enviroment (env)                            
semanticsTerms :: [Term] -> FEnv -> Env -> [Partial Int]
semanticsTerms [] fenv env = [] 
semanticsTerms (t:ts) fenv env = (semantics t fenv env) : (semanticsTerms ts fenv env) 

-- functional induced by the declaration
functional :: [((FIndex, [Var]), Term)] -> Env -> FEnv -> FEnv  
functional [] env = \fenv -> []
functional (((_, inp), t):ds) env = \fenv -> (\params -> semantics t fenv (substs env params inp)) : (functional ds env fenv)

-- Substitute the variable's value
subst :: Env -> (Partial Int) -> Var -> Env
subst env n v = \y -> if y /= v then env y else n

-- substitute multiple variables' values
-- where variable[i] = value[i]
substs :: Env -> [Partial Int] -> [Var] -> Env
substs env [] [] = env
substs env (n:ns) (v:vs) = substs (subst env n v) ns vs

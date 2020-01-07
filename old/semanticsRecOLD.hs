module SemanticsRecOLD where

import Types
--import State.State
import Utilities

semantics :: Term -> Transition (Int)
semantics (TNum n) = return n
semantics (TVar x) = do n <- lookupEnv x
                        return n

semantics (TSum t0 t1) = do s0 <- semantics t0
                            s1 <- semantics t1
                            return (s0 + s1)

semantics (TSub t0 t1) = do s0 <- semantics t0
                            s1 <- semantics t1
                            return (s0 - s1)

semantics (TMul t0 t1) = do s0 <- semantics t0
                            s1 <- semantics t1
                            return (s0 * s1)

semantics (TCond t0 t1 t2) = do s0 <- semantics t0
                                s1 <- semantics t1
                                s2 <- semantics t2
                                return (cond s0 s1 s2)

semantics (TFun i ts) = do f <- lookupFEnv i
                           vs <- semanticsTerms ts -- [3,4,5,6,2,2,4...]
                           s <- evalFun f vs -- f=(Term,params) |vs| = |params|
                           return s
                           
cond :: Int -> a -> a -> a
cond c n1 n2 = if c == 0 then n1 else n2


semanticsTerms :: [Term] -> Transition ([Int])
semanticsTerms [] = return [] 
semanticsTerms (t:ts) = do s <- semantics t
                           ss <- semanticsTerms ts
                           return (s:ss)

                                      
evalFun :: ([Var], Term) -> [Int] -> Transition Int
evalFun (ps, t) vs = do s <- lookupstate
                        s' <- (alphas s vs ps) ----- update state TODO IMPORTANTE: ALLA FINE BISOGNA TORNARE AL VECCHIO STATO!!!
                        res <- updatedSem s' t
                        -- punto fisso per chiamate ricorsive
                        return res


--(semantics t) (fix (functional d)) (alpha p)

--------------------- TODO -----------------------
{--
fix :: FEnv -> FEnv
fix f =  lub [fn n (bottom fenv) | n <- [0..]]

fn :: F -> Int -> 
fn f n = id
fn f n = f . (fn f (n-1))

lub (g:gs) s = if g s

-}

--alphas :: [Int] -> [Var] -> (Var -> Transition Int) -> (Var -> Transition Int) -- stato aggiornato
--alphas [] _ st = st
--alphas (n:ns) (x:xs) st = do res <- (alphas ns xs (alpha n x st))
--                             return res

alphas :: State -> [Int] -> [Var] -> Transition State
alphas s _ [] = return s
alphas s [] _ = return s
alphas s (n:ns) (v:vs) = (alphas (sost s n v) ns vs )


updatedSem :: State -> (Term -> Transition Int)
updatedSem s = \t -> ST (\s' -> app (semantics t) s)
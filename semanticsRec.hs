module SemanticsRec where

import Types
import State.State
import Utilities

semantics :: Term -> Transition (Int)
semantics (TNum n) = return n
semantics (TVar x) = do (Just n) <- lookupEnv x
                        return n

semantics (TSum t0 t1) = do s0 <- semantics t0
                            s1 <- semantics t1
                            return (s0 + s1)

semantics (TCond t0 t1 t2) = do s0 <- semantics t0
                                s1 <- semantics t1
                                s2 <- semantics t2
                                return (cond s0 s1 s2)

semantics (TFun i ts) = do (Just f) <- lookupFEnv i
                           vs <- semanticsTerms ts -- [3,4,5,6,2,2,4...]
                           (Just s) <- evalFun f vs -- f=(Term,params) |vs| = |params|
                           return s
                           
cond :: Int -> a -> a -> a
cond c n1 n2 = if c == 0 then n1 else n2

semanticsTerms :: [Term] -> Transition ([Int])
semanticsTerms [] = return [] 
semanticsTerms (t:ts) = do s <- semantics t
                           ss <- semanticsTerms ts
                           return (s:ss)

                                      
evalFun :: ([Var], Term) -> [Int] -> Transition (Maybe Int)
evalFun (ps, t) vs = do v <- (alphas vs ps lookupEnv) ----- update state TODO IMPORTANTE: ALLA FINE BISOGNA TORNARE AL VECCHIO STATO!!!
                               -- aggiornare i valori delle variabili della funzione nello stato (o nella funzione?)
                               -- calcolare punto fisso etc.
                        return v


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

alphas :: [Int] -> [Var] -> (Term -> Transition (Maybe Int)) -> (Term -> Transition (Maybe Int)) -- stato aggiornato
alphas [] _ st = \t -> st
alphas (n:ns) (x:xs) st = do res <- (alphas ns xs (alpha n x st))
                             return res

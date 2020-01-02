module SemanticsRec where

import Types
import State.State
import Utilities

semantics :: Term -> Transition (Maybe Int)
semantics (TNum n) = return (Just n)
semantics (TVar x) = do n <- lookupEnv x
                        return n

semantics (TSum t0 t1) = do s0 <- semantics t0
                            s1 <- semantics t1
                            return (safesum s0 s1)

semantics (TCond t0 t1 t2) = do s0 <- semantics t0
                                s1 <- semantics t1
                                s2 <- semantics t2
                                return (cond s0 s1 s2)

semantics (TFun i ts) = do f <- lookupFEnv i
                           vs <- semanticsTerms ts -- [3,4,5,6,2,2,4...]
                           s <- semanticsFun f vs -- f=(Term,params) |vs| = |params|
                           return s
                           
cond :: Maybe Int -> Maybe a -> Maybe a -> Maybe a
cond Nothing _ _ = Nothing
cond (Just c) n1 n2 = if c == 0 then n1 else n2

semanticsTerms :: [Term] -> Transition ([Maybe Int])
semanticsTerms [] = return [] 
semanticsTerms (t:ts) = do s <- semantics t
                           ss <- semanticsTerms ts
                           return (s:ss)

                                      
semanticsFun :: Term -> Maybe Int
semanticsFun (t, ps) vs = do alphas ps  ----- update state TODO IMPORTANTE: ALLA FINE BISOGNA TORNARE AL VECCHIO STATO!!!
                             -- aggiornare i valori delle variabili della funzione nello stato (o nella funzione?)
                             -- calcolare punto fisso etc.
                             s <- semantics t
                             stab <- semantics (Tnum 1) -- TODO delete
                             return stab


(semantics t) (fix (functional d)) (alpha p)

--------------------- TODO -----------------------
{--
fix :: FEnv -> FEnv
fix f =  lub [fn n (bottom fenv) | n <- [0..]]

fn :: F -> Int -> 
fn f n = id
fn f n = f . (fn f (n-1))

lub (g:gs) s = if g s

-}


alphas :: [Var] -> ST (Maybe Int) -- stato aggiornato
alphas env [] _ = env
alphas env _ [] = env
alphas env  (n:ns) (x:xs) = alphas (alpha env n x) ns xs

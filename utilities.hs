module Utilities where

import Types
import Data.List

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

-- Substitute function names with indexes 
substFun :: Program -> Program
substFun p = let ((ds, t, x),s') = substFun' p [] in let (t',_) = substTerm t s' in (ds, t', x) -- ////////////// TODO CHANGE input from p s into (p,s) to remove (let = in)

substFun' :: Program -> [FIndex] -> (Program, [FIndex])
substFun' (d:[], t, x) s = let (d', s') = substEqDec d s in ((([d'], t, x), s'))
substFun' (d:ds, t, x) s = let ((ds', _, _),s') = substFun' (ds,t,x) s in let (d', s'') = substEqDec d s' in (((d':ds', t, x), s''))


substEqDec :: EqDec -> [FIndex] -> (EqDec, [FIndex])
substEqDec ((fname,vs), t) s = let (t', s') = substTerm t s in let (i, s'') = substName fname s' in (((i,vs),t'),s'')

substName :: FIndex -> [FIndex] -> (FIndex, [FIndex])
substName c s = case (elemIndex c s) of
                        Just i -> (FInt i, s)
                        Nothing -> (FInt (length s), prepend s c)

substTerm :: Term -> [FIndex] -> (Term, [FIndex])
substTerm (TFun (FVar v) ts) s = let (i,s') = substName (FVar v) s in let (ts',s'') = substTerms ts s' in (TFun i ts', s'')  --- TODO MONADI
substTerm (TSum (t0) (t1)) s = let (t0',s') = substTerm (t0) s in let (t1',s'') = substTerm (t1) s' in (TSum t0' t1',s'')
substTerm (TSub (t0) (t1)) s = let (t0',s') = substTerm (t0) s in let (t1',s'') = substTerm (t1) s' in (TSub t0' t1',s'')
substTerm (TMul (t0) (t1)) s = let (t0',s') = substTerm (t0) s in let (t1',s'') = substTerm (t1) s' in (TMul t0' t1',s'')
substTerm (TCond (t0) (t1) (t2)) s = let (t0',s') = substTerm (t0) s in let (t1',s'') = substTerm (t1) s' in let (t2',s_'') = substTerm (t2) s'' in (TCond t0' t1' t2',s_'')
substTerm t s = (t,s)

substTerms :: [Term] -> [FIndex] -> ([Term], [FIndex])
substTerms [] s = ([], s)
substTerms (t:ts) s = let (t', s') = substTerm t s in let (ts', s'') = (substTerms ts s') in ((t':ts'), s'')

prepend :: [FIndex] -> FIndex -> [FIndex]
prepend l e = reverse (e:(reverse l))
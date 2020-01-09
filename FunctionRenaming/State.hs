module FunctionRenaming.State where

import Data.List
import Types

app :: FRTransition a -> FRState -> (a , FRState)
app (ST tr) s = tr s

instance Functor FRTransition where
    -- fmap :: (a -> b) -> FRTransition a -> FRTransition b
    fmap f st = ST (\s -> let (a,s')=app st s in (f a, s'))

instance Applicative FRTransition where
    pure a = ST (\s -> (a, s))
    -- <*> :: ST (a -> b) -> ST a -> ST b
    stf <*> sta = ST (\s -> let (f,s')=app stf s in app (fmap f sta) s')

instance Monad FRTransition where
    return = pure
    -- >>= :: ST a -> (a -> ST b) -> ST b
    sta >>= f = ST (\s -> let (a,s')=app sta s in app (f a) s')

rename :: FIndex -> FRTransition FIndex
rename fi = ST (\s -> case elemIndex fi s of
                            Just i -> (FInt i, s)
                            Nothing -> (FInt (length s), prepend s fi))


substFun :: Program -> Program
substFun p = fst (app (substFun' p) [])
substFun' :: Program -> FRTransition Program
substFun' (ds, t, x) = do ds' <- substDecs ds
                          t' <- substTerm t
                          return (orderDeclaration ds', t', x)


substDecs :: Declaration -> FRTransition Declaration
substDecs (d:[]) = do d' <- substEqDec d
                      return [d']

substDecs (d:ds) = do d' <- substEqDec d
                      ds' <- substDecs ds
                      return (d':ds')


substEqDec ((fi, vs), t) = do t' <- substTerm t
                              i <- rename fi
                              return ((i, vs), t')

substTerm :: Term -> FRTransition Term
substTerm (TFun fi ts) = do i <- rename fi
                            ts' <- substTerms ts
                            return (TFun i ts')

substTerm (TSum t0 t1) = do t0' <- substTerm t0
                            t1' <- substTerm t1
                            return (TSum t0' t1')

substTerm (TSub t0 t1) = do t0' <- substTerm t0
                            t1' <- substTerm t1
                            return (TSub t0' t1')


substTerm (TMul t0 t1) = do t0' <- substTerm t0
                            t1' <- substTerm t1
                            return (TMul t0' t1')

substTerm (TCond t0 t1 t2) = do t0' <- substTerm t0
                                t1' <- substTerm t1
                                t2' <- substTerm t2
                                return (TCond t0' t1' t2')

substTerm t = pure t

substTerms :: [Term] -> FRTransition [Term]
substTerms [] = pure []
substTerms (t:ts) = do t' <- substTerm t
                       ts' <- substTerms ts
                       return (t':ts')

prepend :: [FIndex] -> FIndex -> [FIndex]
prepend l e = reverse (e:(reverse l))

orderDeclaration :: Declaration -> Declaration
orderDeclaration d = sortOn (\((FInt a, ts), t) -> a) d

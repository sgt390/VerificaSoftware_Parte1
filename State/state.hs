module State.State where

import Types

app :: Transition a -> State -> a
app (ST st) s = st s

--bottom :: State -> (Partial State)
--bottom = ST (\s -> Undef)

lookup :: Transition (State)
lookup = ST (\s -> s)

lookupEnv :: Var -> Transition (Maybe Int)
lookupEnv c = ST (\(S (es, x)) -> case es of 
                                    [] -> Nothing
                                    ((v, n):es') -> if c == v 
                                                        then Just n
                                                        else app (lookupEnv c) (S (es', x)))

lookupFEnv :: Int -> Transition (Maybe ([Var], Term))  -- retrieve the i-th function from the declaration
lookupFEnv i = ST (\(S (x, fs)) -> case fs of
                                        [] -> Nothing
                                        ((j, vs), t):fs' -> if j == i
                                                              then Just (vs,t)
                                                              else app (lookupFEnv i) (S (x,fs')))

alpha :: Int -> Var -> (Term -> Transition (Maybe Int)) -> (Term -> Transition (Maybe Int))
{-
alpha n v = ST (\(S (es, x)) -> case es of  -- substitute v2 with n
                                    [] -> Just n
                                    ((v', n'):es') -> if v' == v
                                                        then Just n
                                                        else app (alpha n v) (S (es',x)))
-}
alpha n v st = \v0 -> ST (\s -> app (st v0) (sost s n v))
sost :: State -> Int -> Var -> State
sost (S (es, x)) n v = S ((v,n):[e | e <- es, missing e v] , x)

missing :: EqVar -> Var -> Bool
missing (v, _) v' = if v' == v
                              then False
                              else True
                    

instance Functor Transition where
    fmap f st = ST (\s -> f (app st s))

instance Applicative Transition where
    pure x = ST (\s -> x)
    sf <*> st = ST (\s -> app (fmap (app sf s) st) s)

instance Monad Transition where
    return = pure
    st >>= f = ST(\s -> app (f (app st s)) s)
{--
-- TODO si può fare in un l funzionale?
updateEnv :: Var -> Int -> State -> State
updateEnv v n (S (es, x)) = S ((v, n):(remEnv v es), x)

remEnv :: Var -> VEnv -> VEnv
remEnv v es = [e | e <- es, fst e == v]

-- updateFun :: Int ->  State -> State
--}
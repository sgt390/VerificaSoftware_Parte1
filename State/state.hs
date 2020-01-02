module State.State where

import Types

app :: Transition a -> State -> a
app (ST st) s = st s

--bottom :: State -> (Partial State)
--bottom = ST (\s -> Undef)

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

alpha :: Var -> Var -> Transition (Maybe Int)
alpha v1 v2 = ST (\(S (es, x)) -> case es of  -- substitute v2 with v1
                                    [] -> Nothing
                                    ((v, n):es') -> if v2 == v
                                                        then Just n
                                                        else app (alpha v1 v2) (S (es',x)))

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
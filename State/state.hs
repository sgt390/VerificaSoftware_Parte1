module State.State where

import Types

bottom :: FEnv
bottom = [\s -> Undef]

extract :: Partial a -> a
extract (Var a) = a

envt :: VEnv -> Env
envt ((v, n):venv) = \c -> if c == v
                                 then Var n
                                 else envt venv c


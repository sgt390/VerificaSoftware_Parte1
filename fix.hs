module Fix where

import Types

-- f(f(...(fenv))) n times
f_n :: (FEnv -> FEnv) -> Int -> FEnv -> FEnv
f_n f 0 fenv = id fenv
f_n f n fenv = f (f_n f (n-1) fenv)


bottom :: FEnv
bottom = [\s -> Undef]

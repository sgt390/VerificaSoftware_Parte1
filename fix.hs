module Fix where

import Types

-- f(f(...(fenv))) n times
-- non tail-recursive version
-- This is not tail recursive because f_n'
-- occurs as a parameter of the function application
-- in the recursive call
f_n' :: (FEnv -> FEnv) -> Int -> FEnv -> FEnv
f_n' f 0 fenv = id fenv
f_n' f n fenv = f (f_n' f (n-1) fenv)

-- Tail recursive version:
-- f_n is tail recursive because it is an application
-- of "f_n" to parameters where "f_n" does not occur
-- (a more detailed explanation is given in the README.md file)
f_n :: (FEnv -> FEnv) -> Int -> FEnv -> FEnv
f_n f 0 fenv = id fenv
f_n f n fenv = f_n f (n-1) (f fenv)


bottom :: FEnv
bottom = [\s -> Undef]

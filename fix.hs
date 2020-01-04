module Fix where

import Types
import State.State

fix :: (FEnv  -> FEnv) -> FEnv
fix f = lub [fn f n bottom | n <- [0..] ] 5000 -- Theorem 4.37

-- nth application of functional F
fn :: (FEnv -> FEnv) -> Int -> FEnv -> FEnv
fn f 0 fenv = id fenv
fn f n fenv = f (fn f (n-1) fenv)

lub :: [FEnv] -> Int -> FEnv
--lub [] s = bottom s -- Fact 4.24
lub (g:gs) i = case i of
                    0 -> g
                    _ -> lub gs (i-1)


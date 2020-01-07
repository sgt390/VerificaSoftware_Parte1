module Fix where

import Types
--import State.State

--fix :: (FEnv  -> FEnv) -> FEnv
--fix f = lub [fn f n bottom | n <- [0..]]

-- F^n(bottom)
fn :: (FEnv -> FEnv) -> Int -> FEnv -> FEnv
fn f 0 fenv = id fenv
fn f n fenv = f (fn f (n-1) fenv)

-- lub :: [FEnv] -> [Int] -> FEnv
-- lub [] params = bottom params  -- not defined enough
-- lub (g:gs) params = case g params of
--                    Var n -> g
--                    Undef -> lub gs params


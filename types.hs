module Types where

type Var = String

data Term
        = TNum Int                  -- Numbers
        | TVar Var                  -- Variables
        | TSum Term Term            -- Sum t1 t2
        | TSub Term Term            -- Subtract t1 t2
        | TMul Term Term            -- Multiply t1 t2
        | TCond Term Term Term      -- cond(t1, t2, t3)
        | TFun FIndex [Term]           -- f(t1, ..., tn)
        deriving Show

-- syntax
data FIndex = FVar Var | FInt Int deriving (Show, Eq)  -- fname (x1, ..., xn)
type Fun = (FIndex, [Var])

type EqDec = (Fun, Term)            -- function = term
type Declaration = [EqDec]          --  list of equations (in declaration)


type EqVar = (Var, Int)             -- x = number
type VEnv = [EqVar]                  -- list of variable declaration

type Program = (Declaration, Term, VEnv)   -- declaration with some enviroment

data Partial a = Var a | Undef deriving (Show, Eq)

type Env = Var -> Partial Int

type F = [Partial Int] -> Partial Int
type FEnv = [F]

type FRState = [FIndex]
newtype FRTransition a = ST (FRState -> (a, FRState))

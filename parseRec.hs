module ParseRec where
import Control.Applicative
import Parse
----------------------------------------------------------
------------------ REC Syntax definition -----------------
----------------------------------------------------------
----------------------------------------------------------

type Var = String

data Term
        = TNum Int                  -- Numbers
        | TVar Var                  -- Variables
        | TSum Term Term            -- Sum t1 t2
        | TSub Term Term            -- Subtract t1 t2
        | TMul Term Term            -- Multiply t1 t2
        | TCond Term Term Term      -- cond(t1, t2, t3)
        | TFun Int [Term]           -- f(t1, ..., tn)
        deriving Show


type Fun = (Int, [Var])             -- fi (x1, ..., xn)

type EqDec = (Fun, Term)            -- function = term
type Declaration = [EqDec]          --  list of equations (in declaration)

type EqVar = (Var, Int)             -- x = number
type Env = [EqVar]                  -- list of variable declaration

type Program = (Declaration, Env)   -- declaration with some enviroment

parseREC :: Parser (Program)
parseREC = do e <- parseEnv
              d <- parseDeclaration
              return (d, e)

parseEnv :: Parser (Env)
parseEnv = do p <- parseEqVar
              do ps <- parseEnv
                 return (p:ps)
                 <|> return [p]

parseEqVar :: Parser (EqVar)
parseEqVar = do e <- parseVar
                character "="
                n <- parseNum
                return (e, n)



parseDeclaration :: Parser (Declaration)
parseDeclaration = do d <- parseEqDec
                      do ds <- parseDeclaration
                         return (d:ds)
                         <|> return [d]

parseEqDec :: Parser (EqDec)
parseEqDec = do f <- parseFun
                character "="
                t <- parseTerm
                return (f, t)

parseFun :: Parser (Fun)
parseFun = do character "f"
              n <- parseNum
              character "("
              args <- parseArgs
              character ")"
              return (n, args)
              

parseArgs :: Parser ([Var])
parseArgs = do v <- parseVar
               do character ","
                  vs <- parseArgs
                  return (v:vs)
                  <|> return [v]
               <|> return []
             

parseATerm :: Parser (Term)
parseATerm = do                          --  Atomic terms
               f <- parseFunTerm         --  Function in the right of the equation
               return f
        <|> do character "if"
               t1 <- parseTerm            --  if then else
               character "then"
               t2 <- parseTerm
               character "else"
               t3 <- parseTerm
               return (TCond t1 t2 t3)
        <|> do n <- parseNum
               return (TNum n)
        <|> do v <- parseVar             -- Variable
               return (TVar v)
        <|> do character "("             -- parenthesis around a term
               t <- parseTerm
               character ")"
               return t

parseTerm :: Parser (Term)
parseTerm = do
              t1 <- parseTerm1           
              do character "+"
                 t2 <- parseTerm
                 return (TSum t1 t2)
               <|> do character "-"
                      t2 <- parseTerm
                      return (TSub t1 t2)
               <|> return t1

parseTerm1 = do t1 <- parseTerm2
                do character "*"
                   t2 <- parseTerm1
                   return (TMul t1 t2)
                 <|> return t1
parseTerm2 = do t <- parseATerm
                return t

parseFunTerm :: Parser (Term)
parseFunTerm = do character "f"
                  n <- parseNum
                  character "("
                  as <- parseArgsTerm
                  character ")"
                  return (TFun n as)

parseArgsTerm :: Parser ([Term])
parseArgsTerm = do v <- parseTerm
                   do character ","
                      vs <- parseArgsTerm
                      return (v:vs)
                      <|> return [v]
                   <|> return []



parseNum :: Parser (Int)
parseNum = do num <- integer
              return num

-- reserved keywords that cannot be variable names
recKeywords = ["if", "then", "else", "f"]
parseVar :: Parser (Var)
parseVar = do v <- identifier
              if not (elem v recKeywords)
                    then return v
                    else empty

character :: String -> Parser String
character xs = symbol xs


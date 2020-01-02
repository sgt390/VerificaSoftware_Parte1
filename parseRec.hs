module ParseRec where
import Control.Applicative
import Parse
import Types
----------------------------------------------------------
------------------ REC Syntax definition -----------------
----------------------------------------------------------
----------------------------------------------------------
parseREC :: Parser (Program)
parseREC = do p <- parseEnv
              t <- parseTerm
              d <- parseDeclaration
              return (d, t, p)

parseEnv :: Parser (VEnv)
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


module Text.SCSS.Parser
( preParseScss
, parseScss
, ScssStatement
) where

import           Control.Applicative           (liftA)
import           Debug.Trace                   (trace)
import           Text.ParserCombinators.Parsec

type ScssStatement = String

{- # preParseScss

-}
preParseScss :: Parser [String]
preParseScss = uncomment

uncomment :: Parser [String]
uncomment = many scan
    where
        scan = nonSlash <|> lineComment <|> blockComment <|> others

        nonSlash :: Parser String
        nonSlash = many1 (try (noneOf "/"))

        lineComment :: Parser String
        lineComment = comment (string "//") newline

        blockComment :: Parser String
        blockComment = comment (string "/*") (string "*/")

        others :: Parser String
        others = count 2 anyChar

        comment :: Parser a -> Parser b -> Parser String
        comment l r = try l *> manyTill anyChar (try r) *> pure ""

{- # parseScss

-}
parseScss :: Parser [ScssStatement]
parseScss = scssStatements

scssStatements :: Parser [ScssStatement]
scssStatements = pure []

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
        lineComment = try (string "//") *> manyTill anyChar (try newline) *> pure ""

        blockComment :: Parser String
        blockComment = try (string "/*") *> manyTill anyChar (try (string "*/")) *> pure ""

        others :: Parser String
        others = count 2 anyChar

{- # parseScss

-}
parseScss :: Parser [ScssStatement]
parseScss = scssStatements

scssStatements :: Parser [ScssStatement]
scssStatements = pure []

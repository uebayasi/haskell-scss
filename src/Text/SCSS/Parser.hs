module Text.SCSS.Parser
( parseScss
, ScssStatement
) where

import           Text.ParserCombinators.Parsec

type ScssStatement = String

parseScss :: Parser [ScssStatement]
parseScss = scssStatements

scssStatements :: Parser [ScssStatement]
scssStatements = many $ (spaces <|> comment) *> noncomment <* (spaces <|> comment)

noncomment :: Parser String
noncomment = many1 anyChar

comment :: Parser ()
comment = start *> end *> pure ()
    where
        start = string "//"
        end = manyTill anyChar (try newline)

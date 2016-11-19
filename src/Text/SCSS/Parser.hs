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
preParseScss = comment

comment :: Parser [String]
comment = many scan
    where
        scan = nonSlash <|> lineComment <|> blockComment <|> others

        nonSlash :: Parser String
        nonSlash = many1 (try (noneOf "/"))

        lineComment :: Parser String
        lineComment = skipBetween (string "//") newline

        blockComment :: Parser String
        blockComment = skipBetween (string "/*") (string "*/")

        skipBetween :: Parser a -> Parser b -> Parser String
        skipBetween l r = try l *> manyTill anyChar (try r) *> pure ""

        others :: Parser String
        others = count 2 anyChar

{- # parseScss

-}
parseScss :: Parser [ScssStatement]
parseScss = scssStatements

scssStatements :: Parser [ScssStatement]
scssStatements = many1 $ many1 anyChar

{-

.alert {
  padding: $alert-padding-y $alert-padding-x;
  margin-bottom: $spacer-y;
  border: $alert-border-width solid transparent;
  @include border-radius($alert-border-radius);
}

- Ruleset (".alert { ... }")
- Selecter ("padding", ...)
- Block ("{ ... }")
- Declaration ("padding: $alert-padding-y $alert-padding-x;", ...)
- Property ("padding", "margin-bottom", ...)
- Value ("$alert-padding-y", "$alert-padding-x", "$spacer-y", ...)

-}
scssStatement :: Parser ScssStatement
scssStatement = many1 anyChar

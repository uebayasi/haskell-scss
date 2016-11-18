module Text.SCSS.Parser
( parseScss
) where

import           Text.ParserCombinators.Parsec

parseScss :: Parser Char
parseScss = char 'a'

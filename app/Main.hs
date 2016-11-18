module Main where

import           System.Environment
import           Text.ParserCombinators.Parsec
import           Text.SCSS.Parser

main :: IO ()
main = do
    putStrLn $ test "a"

test :: String -> String
test s = case parse parseScss "SCSS" s of
    Left err -> "Error: " ++ show err
    Right v  -> "OK"

module Main where

import           System.Environment
import           Text.ParserCombinators.Parsec
import           Text.SCSS.Parser

main :: IO ()
main = do
    args <- getArgs
    mapM_ (putStrLn . test) args

test :: String -> String
test s = case parse preParseScss "SCSS" s of
    Left err -> "Error: " ++ show err
    Right v  -> "OK: " ++ showResult v
    where
        showResult v = case v of
            []         -> ""
            first:rest -> show v ++ "\n" ++ showResult rest

module Main where

import           System.Environment
import           Text.ParserCombinators.Parsec
import           Text.SCSS.Parser

main :: IO ()
main = do
    args <- getArgs
    mapM_ (putStrLn . preTest) args
    mapM_ (putStrLn . test) args

preTest :: String -> String
preTest s = case parse preParseScss "SCSS" s of
    Left err -> "Error: " ++ show err
    Right v  -> "pre-parse OK: " ++ showResult v
    where
        showResult v = case v of
            []         -> ""
            first:rest -> show v ++ "\n" ++ showResult rest

test :: String -> String
test s = case parse preParseScss "SCSS" s of
    Left err -> "Error: " ++ show err
    Right v  -> case parse parseScss "SCSS" (concat v) of
        Left err -> "Error: " ++ show err
        Right v -> "parse OK: " ++ showResult v
            where
                showResult v = case v of
                    []         -> ""
                    first:rest -> show v ++ "\n" ++ showResult rest

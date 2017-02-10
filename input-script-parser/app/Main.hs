{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import Lib
import ReadArgs

main :: IO ()
main = do
    (scriptFilepath :: FilePath) <- readArgs
    input <- readFile scriptFilepath
    let output = compileScript input
    putStrLn output
    --print extra line needed to terminate file
    putStrLn ""

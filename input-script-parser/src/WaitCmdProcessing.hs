module WaitCmdProcessing (
    expandWaitingFrames
) where

import InputModels

import Data.Char
import Data.List

data WaitData = WaitData {
    waitingFrames :: Int,
    inputWord :: InputWord
}

parseInteger :: String -> Int
parseInteger "" = 0
parseInteger xs = read xs

getWaitData :: InputWord -> WaitData
getWaitData "" = WaitData 0 ""
getWaitData ('w':xs) = WaitData waitingFrames right
    where (left, right) = span isDigit xs
          waitingFrames = parseInteger left
getWaitData xs = WaitData 0 xs

generateFromWaitData :: WaitData -> [InputWord]
generateFromWaitData waitData
    | word == "" = emptyFrames
    | otherwise = emptyFrames ++ [word]
    where len = waitingFrames waitData
          word = inputWord waitData
          emptyFrames = replicate len ""

expandWaitingFrames:: [InputWord] -> [InputWord]
expandWaitingFrames words = mconcat $ map (generateFromWaitData . getWaitData) words

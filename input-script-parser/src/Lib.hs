module Lib
    ( compileScript
    ) where

import InputModels
import WaitCmdProcessing
import HoldCmdProcessing

joinString :: String -> String -> String
joinString lhv rhv = lhv ++ "\n" ++ rhv

compileScript:: String -> String
compileScript = foldl joinString "" . map frameInputToString . createFrameInputList
    . expandWaitingFrames . lines

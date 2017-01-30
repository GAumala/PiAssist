module HoldCmdProcessing (
    FrameInputData(..),

    processHeldButtons,
    createFrameInputList,
) where

import InputModels

import Data.List

holdCmd = '_'
releaseCmd = '^'

data FrameInputData = FrameInputData {
    pressedInputs :: FrameInput,
    heldInputs :: FrameInput
} deriving (Eq, Show)

isSpecialCmd :: Char -> Bool
isSpecialCmd c = c == holdCmd || c == releaseCmd

processHeldButtons' :: InputWord
                    -> FrameInputData
                    -> FrameInputData
processHeldButtons' [] fdata = fdata
processHeldButtons' word fdata
    | ("_" ++ mUP) `isPrefixOf` word = processHeldButtons' (edited mUP)
        (FrameInputData pressed (held `plusArrows` UP))
    | ("_" ++ mDOWN)  `isPrefixOf` word = processHeldButtons' (edited mDOWN)
        (FrameInputData pressed (held `plusArrows` DOWN))
    | ("_" ++ mLEFT)  `isPrefixOf` word = processHeldButtons' (edited mLEFT)
        (FrameInputData pressed (held `plusArrows` LEFT))
    | ("_" ++ mRIGHT)  `isPrefixOf` word = processHeldButtons' (edited mRIGHT)
        (FrameInputData pressed (held `plusArrows` RIGHT))
    | ("_" ++ mLP) `isPrefixOf`  word = processHeldButtons' (edited mLP)
        (FrameInputData pressed (held `plusPunches` LP))
    | ("_" ++ mMP) `isPrefixOf`  word = processHeldButtons' (edited mMP)
        (FrameInputData pressed (held `plusPunches` MP))
    | ("_" ++ mHP) `isPrefixOf`  word = processHeldButtons' (edited mHP)
        (FrameInputData pressed (held `plusPunches` HP))
    | ("_" ++ mLK) `isPrefixOf`  word = processHeldButtons' (edited mLK)
        (FrameInputData pressed (held `plusKicks` LK))
    | ("_" ++ mMK) `isPrefixOf`  word = processHeldButtons' (edited mMK)
        (FrameInputData pressed (held `plusKicks` MK))
    | ("_" ++ mHK) `isPrefixOf`  word = processHeldButtons' (edited mHK)
        (FrameInputData pressed (held `plusKicks` HK))

    | ("^" ++ mUP) `isPrefixOf` word = processHeldButtons' (edited mUP)
        (FrameInputData pressed (held `minusArrows` UP))
    | ("^" ++ mDOWN)  `isPrefixOf` word = processHeldButtons' (edited mDOWN)
        (FrameInputData pressed (held `minusArrows` DOWN))
    | ("^" ++ mLEFT)  `isPrefixOf` word = processHeldButtons' (edited mLEFT)
        (FrameInputData pressed (held `minusArrows` LEFT))
    | ("^" ++ mRIGHT)  `isPrefixOf` word = processHeldButtons' (edited mRIGHT)
        (FrameInputData pressed (held `minusArrows` RIGHT))
    | ("^" ++ mLP) `isPrefixOf`  word = processHeldButtons' (edited mLP)
        (FrameInputData pressed (held `minusPunches` LP))
    | ("^" ++ mMP) `isPrefixOf`  word = processHeldButtons' (edited mMP)
        (FrameInputData pressed (held `minusPunches` MP))
    | ("^" ++ mHP) `isPrefixOf`  word = processHeldButtons' (edited mHP)
        (FrameInputData pressed (held `minusPunches` HP))
    | ("^" ++ mLK) `isPrefixOf`  word = processHeldButtons' (edited mLK)
        (FrameInputData pressed (held `minusKicks` LK))
    | ("^" ++ mMK) `isPrefixOf`  word = processHeldButtons' (edited mMK)
        (FrameInputData pressed (held `minusKicks` MK))
    | ("^" ++ mHK) `isPrefixOf`  word = processHeldButtons' (edited mHK)
        (FrameInputData pressed (held `minusKicks` HK))

    | otherwise = processHeldButtons' xs
        (FrameInputData (pressed `plusC` extraFrameInput) held)

    where edited s = drop (length s + 1) word
          pressed = pressedInputs fdata
          held = heldInputs fdata
          mUP = show UP
          mDOWN = show DOWN
          mLEFT = show LEFT
          mRIGHT = show RIGHT
          mLP = show LP
          mMP = show MP
          mHP = show HP
          mLK = show LK
          mMK = show MK
          mHK = show HK
          (extraInputs, xs) = break isSpecialCmd word
          extraFrameInput = frameInputFromWord extraInputs

processHeldButtons :: InputWord -> FrameInput -> FrameInputData
processHeldButtons word heldInputs = processHeldButtons' word
    (FrameInputData (FrameInput NO_ARROWS NO_PUNCHES NO_KICKS) heldInputs)

createFrameInputList' :: [InputWord] -> FrameInput -> [FrameInput] -> [FrameInput]
createFrameInputList' [] _ res = res
createFrameInputList' (input:xs) state res = createFrameInputList' xs
    (heldInputs fdata) (res ++ [newFrameInput])
    where fdata = processHeldButtons input state
          newFrameInput = heldInputs fdata `plusC` pressedInputs fdata

createFrameInputList :: [InputWord] -> [FrameInput]
createFrameInputList words = createFrameInputList' words
    (FrameInput NO_ARROWS NO_PUNCHES NO_KICKS) []

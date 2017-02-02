import Test.HUnit

import LibTests

main :: IO Counts
main = runTestTT $ TestList [
    TestLabel "expandWaitingFrames" expandWaitingFramesTest,
    TestLabel "processHeldButtons" processHeldButtonsTest,
    TestLabel "createFrameInputList" createFrameInputListTest
    ]

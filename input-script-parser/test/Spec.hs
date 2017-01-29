import Test.HUnit

import WaitProcessing

expandWaitingFramesTest = TestCase (
    assertEqual "Returns the same input list if there are no wait commands"
        input
        (expandWaitingFrames input) >>
    assertEqual "Adds empty strings if there is one wait command"
         ["lp", "", "", "", "", "", "mp"]
         (expandWaitingFrames ["lp", "w5mp"]) >>
    assertEqual "Adds then correct number of empty strings even if wait command has no followup"
         ["lp", "", "", "", "", "", "", "mp"]
         (expandWaitingFrames ["lp", "w6", "mp"]) >>
    assertEqual "Adds empty strings if there are multiple wait commands"
         ["lp", "", "", "", "mp", "", "", "", "", "", "right", "right", "", "", "hp"]
         (expandWaitingFrames ["lp", "w3mp", "w5right", "right", "w2hp"])
    )
    where input = ["lp", "mp", "right", "right"]

test2 = TestCase (assertEqual "test case 2" 4 (2*2))

main :: IO Counts
main = runTestTT $ TestList [
    TestLabel "expandWaitingFrames" expandWaitingFramesTest,
    TestLabel "test2" test2
    ]

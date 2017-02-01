import Test.HUnit

import InputModels
import WaitCmdProcessing
import HoldCmdProcessing

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
         (expandWaitingFrames ["lp", "w3mp", "w5right", "right", "w2hp"]) >>
    assertEqual "Adds empty strings if there are multiple wait commands 2"
         [ "right", "right", "_mp_mk", "", "", "", "", "", "^mp^mk", "", "",
            "", "hp", "", "", "right", "down", "downright lphp"]
         (expandWaitingFrames ["right", "right", "_mp_mk", "w5^mp^mk", "w3hp", "w2right", "down",
            "downright lphp"])
    )
    where input = ["lp", "mp", "right", "right"]

processHeldButtonsTest = TestCase (
    assertEqual "converts InputWord to FrameInputData"
        (FrameInput NO_ARROWS HP NO_KICKS)
        (pressedInputs $ processHeldButtons "hp" emptyFrameInput) >>
    assertEqual "converts InputWord to FrameInputData with held state"
        (FrameInputData (FrameInput NO_ARROWS HP NO_KICKS) (FrameInput DOWN NO_PUNCHES NO_KICKS))
        (processHeldButtons "hp" (FrameInput DOWN NO_PUNCHES NO_KICKS))
    )

createFrameInputListTest = TestCase (
    assertEqual "Returns a correct list if there are no hold or wait commands"
        [
            FrameInput NO_ARROWS HP NO_KICKS,
            FrameInput DOWN NO_PUNCHES NO_KICKS,
            FrameInput DOWN_RIGHT NO_PUNCHES NO_KICKS,
            FrameInput RIGHT MPHP NO_KICKS
        ]

        (createFrameInputList [
            "hp",
            "down",
            "downright",
            "right mphp"
        ]) >>
    assertEqual "Returns a correct list even with hold commands"
        [
            FrameInput LEFT MP NO_KICKS,
            FrameInput LEFT MP NO_KICKS,
            FrameInput LEFT HP NO_KICKS,
            FrameInput RIGHT MPHP NO_KICKS,
            FrameInput NO_ARROWS LP LK
        ]

        (createFrameInputList [
            "_left mp",
            "mp",
            "hp",
            "^left right mphp",
            "lplk"
        ]) >>
    assertEqual "createFrameInputList and expandWaitingFrames compose correctly"
        [
            FrameInput RIGHT NO_PUNCHES NO_KICKS,
            FrameInput NO_ARROWS NO_PUNCHES NO_KICKS,
            FrameInput RIGHT NO_PUNCHES NO_KICKS,
            FrameInput NO_ARROWS MP MK,
            FrameInput NO_ARROWS MP MK,
            FrameInput NO_ARROWS MP MK,
            FrameInput NO_ARROWS MP MK,
            FrameInput NO_ARROWS MP MK,
            FrameInput NO_ARROWS MP MK,
            FrameInput NO_ARROWS NO_PUNCHES NO_KICKS,
            FrameInput NO_ARROWS NO_PUNCHES NO_KICKS,
            FrameInput NO_ARROWS NO_PUNCHES NO_KICKS,
            FrameInput NO_ARROWS NO_PUNCHES NO_KICKS,
            FrameInput NO_ARROWS HP NO_KICKS,
            FrameInput NO_ARROWS NO_PUNCHES NO_KICKS,
            FrameInput NO_ARROWS NO_PUNCHES NO_KICKS,
            FrameInput RIGHT NO_PUNCHES NO_KICKS,
            FrameInput DOWN NO_PUNCHES NO_KICKS,
            FrameInput DOWN_RIGHT LPHP NO_KICKS
        ]

        ((createFrameInputList . expandWaitingFrames) [
            "right",
            "w1right",
            "_mp_mk",
            "w5^mp^mk",
            "w3hp",
            "w2right",
            "down",
            "downright lphp"
        ])
    )


main :: IO Counts
main = runTestTT $ TestList [
    TestLabel "expandWaitingFrames" expandWaitingFramesTest,
    TestLabel "processHeldButtons" processHeldButtonsTest,
    TestLabel "createFrameInputList" createFrameInputListTest
    ]

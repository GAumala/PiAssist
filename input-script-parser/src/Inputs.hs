module Inputs (
InputCode,
InputWord,

ArrowCombination,
PunchCombination,
KickCombination,

arrowsToCode,
punchesToCode,
kicksToCode,

arrowsFromWord,
punchesFromWord,
kicksFromWord
)
where

import Data.List

type InputCode = Int
type InputWord = String

data ArrowCombination = NO_ARROWS | LEFT | RIGHT | UP | DOWN |
    DOWN_LEFT | DOWN_RIGHT | UP_LEFT | UP_RIGHT

arrowsToCode :: ArrowCombination -> InputCode
arrowsToCode NO_ARROWS  = 0
arrowsToCode DOWN       = 1
arrowsToCode RIGHT      = 2
arrowsToCode LEFT       = 3
arrowsToCode UP         = 4
arrowsToCode DOWN_LEFT  = 5
arrowsToCode DOWN_RIGHT = 6
arrowsToCode UP_LEFT    = 7
arrowsToCode UP_RIGHT   = 8

instance Show ArrowCombination where
    show NO_ARROWS  = "none"
    show DOWN       = "down"
    show LEFT       = "left"
    show RIGHT      = "right"
    show UP         = "up"
    show DOWN_LEFT  = "downleft"
    show DOWN_RIGHT = "downright"
    show UP_RIGHT   = "upright"
    show UP_LEFT    = "upleft"

arrowsFromWord :: InputWord -> ArrowCombination
arrowsFromWord word
    | isDown && isLeft   = DOWN_LEFT
    | isDown && isRight  = DOWN_RIGHT
    | isUp && isLeft     = UP_LEFT
    | isUp && isRight    = UP_RIGHT
    | isDown             = DOWN
    | isLeft             = LEFT
    | isRight            = RIGHT
    | isUp               = UP
    | otherwise          = NO_ARROWS
    where isLeft  = show LEFT `isInfixOf` word
          isDown  = show DOWN `isInfixOf` word
          isRight = show RIGHT `isInfixOf` word
          isUp    = show UP `isInfixOf` word

data PunchCombination = NO_PUNCHES | LP | MP | HP | LPMP | LPHP | MPHP | LPMPHP

punchesToCode :: PunchCombination -> InputCode
punchesToCode NO_PUNCHES = 9
punchesToCode LP         = 10
punchesToCode MP         = 11
punchesToCode HP         = 12
punchesToCode LPMP       = 13
punchesToCode MPHP       = 14
punchesToCode LPHP       = 15
punchesToCode LPMPHP     = 16

instance Show PunchCombination where
    show NO_PUNCHES = "none"
    show LP         = "lp"
    show MP         = "mp"
    show HP         = "hp"
    show LPMP       = "lpmp"
    show MPHP       = "mphp"
    show LPHP       = "lphp"
    show LPMPHP     = "lpmphp"

punchesFromWord :: InputWord -> PunchCombination
punchesFromWord word
    | isLP && isMP && isHP = LPMPHP
    | isLP && isMP         = LPMP
    | isLP && isHP         = LPHP
    | isMP && isHP         = MPHP
    | isLP                 = LP
    | isMP                 = MP
    | isHP                 = HP
    | otherwise            = NO_PUNCHES
    where isLP    = show LP `isInfixOf` word
          isMP    = show MP `isInfixOf` word
          isHP    = show HP `isInfixOf` word

data KickCombination = NO_KICKS | LK | MK | HK | LKMK | LKHK | MKHK | LKMKHK

kicksToCode :: KickCombination -> InputCode
kicksToCode NO_KICKS = 17
kicksToCode LK       = 18
kicksToCode MK       = 19
kicksToCode HK       = 20
kicksToCode LKMK     = 21
kicksToCode MKHK     = 22
kicksToCode LKHK     = 23
kicksToCode LKMKHK   = 24

instance Show KickCombination where
    show NO_KICKS = "none"
    show LK       = "lk"
    show MK       = "mk"
    show HK       = "hk"
    show LKMK     = "lkmk"
    show MKHK     = "mkhk"
    show LKHK     = "lkhk"
    show LKMKHK   = "lkmkhk"

kicksFromWord :: InputWord -> KickCombination
kicksFromWord word
    | isLK && isMK && isHK = LKMKHK
    | isLK && isMK         = LKMK
    | isLK && isHK         = LKHK
    | isMK && isHK         = MKHK
    | isLK                 = LK
    | isMK                 = MK
    | isHK                 = HK
    | otherwise            = NO_KICKS
    where isLK    = show LK `isInfixOf` word
          isMK    = show MK `isInfixOf` word
          isHK    = show HK `isInfixOf` word

data FrameInput = FrameInput {
    arrows :: ArrowCombination,
    punches :: PunchCombination,
    kicks :: KickCombination
}

frameInputToString :: FrameInput -> String
frameInputToString input = mconcat [show x , separator, show y , separator, show z]
    where x = arrowsToCode (arrows input)
          y = punchesToCode (punches input)
          z = kicksToCode (kicks input)
          separator = ":"

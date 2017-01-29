module Inputs (
Input16BitCode,
InputWord,

ArrowCombination,
PunchCombination,
KickCombination,

arrowsTo16BitCode,
punchesTo16BitCode,
kicksTo16BitCode,

arrowsFromWord,
punchesFromWord,
kicksFromWord
)
where

import Data.List

type Input16BitCode = Int
type InputWord = String

data ArrowCombination = NO_ARROWS | LEFT | RIGHT | UP | DOWN |
    DOWN_LEFT | DOWN_RIGHT | UP_LEFT | UP_RIGHT

arrowsTo16BitCode :: ArrowCombination -> Input16BitCode
arrowsTo16BitCode NO_ARROWS = 2
arrowsTo16BitCode DOWN = 3
arrowsTo16BitCode RIGHT = 5
arrowsTo16BitCode LEFT = 7
arrowsTo16BitCode UP = 11
arrowsTo16BitCode DOWN_LEFT = 13
arrowsTo16BitCode DOWN_RIGHT = 17
arrowsTo16BitCode UP_LEFT = 23
arrowsTo16BitCode UP_RIGHT = 29

instance Show ArrowCombination where
    show NO_ARROWS = "none"
    show DOWN = "down"
    show LEFT = "left"
    show RIGHT = "right"
    show UP = "up"
    show DOWN_LEFT = "downleft"
    show DOWN_RIGHT = "downright"
    show UP_RIGHT = "upright"
    show UP_LEFT = "upleft"

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

punchesTo16BitCode :: PunchCombination -> Input16BitCode
punchesTo16BitCode NO_PUNCHES = 31
punchesTo16BitCode LP         = 37
punchesTo16BitCode MP         = 41
punchesTo16BitCode HP         = 43
punchesTo16BitCode LPMP       = 47
punchesTo16BitCode MPHP       = 53
punchesTo16BitCode LPHP       = 59
punchesTo16BitCode LPMPHP     = 61

instance Show PunchCombination where
    show NO_PUNCHES = "none"
    show LP = "lp"
    show MP = "mp"
    show HP = "hp"
    show LPMP = "lpmp"
    show MPHP = "mphp"
    show LPHP = "lphp"
    show LPMPHP = "lpmphp"

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

kicksTo16BitCode :: KickCombination -> Input16BitCode
kicksTo16BitCode NO_KICKS = 67
kicksTo16BitCode LK       = 71
kicksTo16BitCode MK       = 73
kicksTo16BitCode HK       = 79
kicksTo16BitCode LKMK     = 83
kicksTo16BitCode MKHK     = 89
kicksTo16BitCode LKHK     = 97
kicksTo16BitCode LKMKHK   = 103

instance Show KickCombination where
    show NO_KICKS = "none"
    show LK = "lk"
    show MK = "mk"
    show HK = "hk"
    show LKMK = "lkmk"
    show MKHK = "mkhk"
    show LKHK = "lkhk"
    show LKMKHK = "lkmkhk"

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

frameInputTo16BitCode :: FrameInput -> Input16BitCode
frameInputTo16BitCode input = x * y * z
    where x = arrowsTo16BitCode (arrows input)
          y = punchesTo16BitCode (punches input)
          z = kicksTo16BitCode (kicks input)

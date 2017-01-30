module InputModels (
InputCode,
InputWord,

InputCombination(..),
ArrowCombination(..),
PunchCombination(..),
KickCombination(..),
FrameInput(..),

arrowsToCode,
punchesToCode,
kicksToCode,

frameInputFromWord,
frameInputToString,
emptyFrameInput,

arrowsFromWord,
punchesFromWord,
kicksFromWord,

plusArrows,
plusPunches,
plusKicks,
minusArrows,
minusPunches,
minusKicks,
)
where

import Data.List

type InputCode = Int
type InputWord = String

class InputCombination a where
    plusC :: a -> a -> a --Not commutative, more like append 2nd argument to first
    minusC :: a -> a -> a

data ArrowCombination = NO_ARROWS | LEFT | RIGHT | UP | DOWN |
    DOWN_LEFT | DOWN_RIGHT | UP_LEFT | UP_RIGHT deriving (Eq)

instance InputCombination ArrowCombination where
    NO_ARROWS `plusC` c = c
    c `plusC` NO_ARROWS = c

    LEFT `plusC` RIGHT = RIGHT
    LEFT `plusC` DOWN = DOWN_LEFT
    LEFT `plusC` UP = UP_LEFT
    LEFT `plusC` c = c

    RIGHT `plusC` LEFT = LEFT
    RIGHT `plusC` DOWN = DOWN_RIGHT
    RIGHT `plusC` UP = UP_RIGHT
    RIGHT `plusC` c = c

    DOWN `plusC` UP = UP
    DOWN `plusC` LEFT = DOWN_LEFT
    DOWN `plusC` RIGHT = DOWN_RIGHT
    DOWN `plusC` c = c

    UP `plusC` DOWN = DOWN
    UP `plusC` LEFT = UP_LEFT
    UP `plusC` RIGHT = UP_RIGHT
    UP `plusC` c = c

    DOWN_LEFT `plusC` DOWN = DOWN_LEFT
    DOWN_LEFT `plusC` LEFT = DOWN_LEFT
    DOWN_LEFT `plusC` c = c

    DOWN_RIGHT `plusC` DOWN = DOWN_RIGHT
    DOWN_RIGHT `plusC` RIGHT = DOWN_RIGHT
    DOWN_RIGHT `plusC` c = c

    UP_LEFT `plusC` UP = UP_LEFT
    UP_LEFT `plusC` LEFT = UP_LEFT
    UP_LEFT `plusC` c = c

    UP_RIGHT `plusC` UP = UP_RIGHT
    UP_RIGHT `plusC` RIGHT = UP_RIGHT
    UP_RIGHT `plusC` c = c


    NO_ARROWS `minusC` _ = NO_ARROWS
    c `minusC` NO_ARROWS = c

    LEFT `minusC` LEFT = NO_ARROWS
    LEFT `minusC` _ = LEFT

    RIGHT `minusC` RIGHT = NO_ARROWS
    RIGHT `minusC` _ = RIGHT

    DOWN `minusC` DOWN = NO_ARROWS
    DOWN `minusC` _ = DOWN

    UP `minusC` UP = NO_ARROWS
    UP `minusC` _ = UP

    DOWN_LEFT `minusC` DOWN_LEFT = NO_ARROWS
    DOWN_LEFT `minusC` DOWN = LEFT
    DOWN_LEFT `minusC` LEFT = DOWN
    DOWN_LEFT `minusC` c = DOWN_LEFT

    UP_LEFT `minusC` UP_LEFT = NO_ARROWS
    UP_LEFT `minusC` UP = LEFT
    UP_LEFT `minusC` LEFT = UP
    UP_LEFT `minusC` c = UP_LEFT

    DOWN_RIGHT `minusC` DOWN_RIGHT = NO_ARROWS
    DOWN_RIGHT `minusC` DOWN = RIGHT
    DOWN_RIGHT `minusC` RIGHT = DOWN
    DOWN_RIGHT `minusC` c = DOWN_RIGHT

    UP_RIGHT `minusC` UP_RIGHT = NO_ARROWS
    UP_RIGHT `minusC` UP = RIGHT
    UP_RIGHT `minusC` RIGHT = UP
    UP_RIGHT `minusC` c = UP_RIGHT

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
    deriving (Eq)

instance InputCombination PunchCombination where
    NO_PUNCHES `plusC` c = c
    c `plusC` NO_PUNCHES = c

    LP `plusC` MP = LPMP
    LP `plusC` HP = LPHP
    LP `plusC` MPHP = LPMPHP
    LP `plusC` c = c

    MP `plusC` LP = LPMP
    MP `plusC` HP = MPHP
    MP `plusC` LPHP = LPMPHP
    MP `plusC` c = c

    HP `plusC` LP = LPHP
    HP `plusC` MP = MPHP
    HP `plusC` LPMP = LPMPHP
    HP `plusC` c = c

    LPMPHP `plusC` _ = LPMPHP

    NO_PUNCHES `minusC` _ = NO_PUNCHES
    c `minusC` NO_PUNCHES = c

    LP `minusC` LP = NO_PUNCHES
    LP `minusC` _ = LP

    MP `minusC` MP = NO_PUNCHES
    MP `minusC` _ = MP

    HP `minusC` HP = NO_PUNCHES
    HP `minusC` _ = HP

    LPMP `minusC` LPMP = NO_PUNCHES
    LPMP `minusC` LP = MP
    LPMP `minusC` MP = LP
    LPMP `minusC` _ = LPMP

    MPHP `minusC` MPHP = NO_PUNCHES
    MPHP `minusC` MP = HP
    MPHP `minusC` HP = LP
    MPHP `minusC` _ = MPHP

    LPHP `minusC` LPHP = NO_PUNCHES
    LPHP `minusC` LP = HP
    LPHP `minusC` HP = LP
    LPHP `minusC` _ = LPHP

    LPMPHP `minusC` LPMPHP = NO_PUNCHES
    LPMPHP `minusC` LPMP = HP
    LPMPHP `minusC` LPHP = MP
    LPMPHP `minusC` MPHP = LP
    LPMPHP `minusC` LP = MPHP
    LPMPHP `minusC` MP = LPHP
    LPMPHP `minusC` HP = LPMP


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
    deriving (Eq)

instance InputCombination KickCombination where
    NO_KICKS `plusC` c = c
    c `plusC` NO_KICKS = c

    LK `plusC` MK = LKMK
    LK `plusC` HK = LKHK
    LK `plusC` MKHK = LKMKHK
    LK `plusC` c = c

    MK `plusC` LK = LKMK
    MK `plusC` HK = MKHK
    MK `plusC` LKHK = LKMKHK
    MK `plusC` c = c

    HK `plusC` LK = LKHK
    HK `plusC` MK = MKHK
    HK `plusC` LKMK = LKMKHK
    HK `plusC` c = c

    LKMKHK `plusC` _ = LKMKHK

    NO_KICKS `minusC` _ = NO_KICKS
    c `minusC` NO_KICKS = c

    LK `minusC` LK = NO_KICKS
    LK `minusC` _ = LK

    MK `minusC` MK = NO_KICKS
    MK `minusC` _ = MK

    HK `minusC` HK = NO_KICKS
    HK `minusC` _ = HK

    LKMK `minusC` LKMK = NO_KICKS
    LKMK `minusC` LK = MK
    LKMK `minusC` MK = LK
    LKMK `minusC` _ = LKMK

    MKHK `minusC` MKHK = NO_KICKS
    MKHK `minusC` MK = HK
    MKHK `minusC` HK = LK
    MKHK `minusC` _ = MKHK

    LKHK `minusC` LKHK = NO_KICKS
    LKHK `minusC` LK = HK
    LKHK `minusC` HK = LK
    LKHK `minusC` _ = LKHK

    LKMKHK `minusC` LKMKHK = NO_KICKS
    LKMKHK `minusC` LKMK = HK
    LKMKHK `minusC` LKHK = MK
    LKMKHK `minusC` MKHK = LK
    LKMKHK `minusC` LK = MKHK
    LKMKHK `minusC` MK = LKHK
    LKMKHK `minusC` HK = LKMK

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
} deriving (Eq, Show)

instance InputCombination FrameInput where
    left `plusC` right =  FrameInput (arrows left `plusC` arrows right)
        (punches left `plusC` punches right) (kicks left `plusC` kicks right)

    left `minusC` right =  FrameInput (arrows left `minusC` arrows right)
        (punches left `minusC` punches right) (kicks left `minusC` kicks right)

frameInputFromWord:: InputWord -> FrameInput
frameInputFromWord word = FrameInput (arrowsFromWord word) (punchesFromWord word)
    (kicksFromWord word)

frameInputToString :: FrameInput -> String
frameInputToString input = mconcat [show x , separator, show y , separator, show z]
    where x = arrowsToCode (arrows input)
          y = punchesToCode (punches input)
          z = kicksToCode (kicks input)
          separator = ":"

emptyFrameInput = FrameInput NO_ARROWS NO_PUNCHES NO_KICKS

plusArrows :: FrameInput -> ArrowCombination -> FrameInput
input `plusArrows` newArrows = FrameInput (arrows input `plusC` newArrows)
    (punches input) (kicks input)

plusPunches :: FrameInput -> PunchCombination -> FrameInput
input `plusPunches` newPunches = FrameInput (arrows input)
    (punches input `plusC` newPunches) (kicks input)

plusKicks :: FrameInput -> KickCombination -> FrameInput
input `plusKicks` newKicks = FrameInput (arrows input)
    (punches input) (kicks input `plusC` newKicks)

minusArrows :: FrameInput -> ArrowCombination -> FrameInput
input `minusArrows` newArrows = FrameInput (arrows input `minusC` newArrows)
    (punches input) (kicks input)

minusPunches :: FrameInput -> PunchCombination -> FrameInput
input `minusPunches` newPunches = FrameInput (arrows input)
    (punches input `minusC` newPunches) (kicks input)

minusKicks :: FrameInput -> KickCombination -> FrameInput
input `minusKicks` newKicks = FrameInput (arrows input)
    (punches input) (kicks input `minusC` newKicks)

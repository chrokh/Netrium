-- |Netrium is Copyright Anthony Waite, Dave Hewett, Shaun Laurens & Contributors 2009-2018, and files herein are licensed
-- |under the MIT license,  the text of which can be found in license.txt
--
-- Module for credit
module Credit where

import Prelude hiding (and, or, min, max, abs, negate, not, read, until)
import Contract
import Common
import Calendar

import Data.Time
import Data.Monoid

-- |Type for credit events
type CreditEvent = (String,          -- Name of the event
                    Bool,            -- True if contract if terminated as a result of the event
                    Char,            -- Settlement type (C for cash, P for physical)
                    Price,           -- Capital payment as a result of the event
                    Currency,        -- Currency of the capital payment
                    Obs Bool)        -- True if the event has happened

-- |Function that returns True if any of the given credit events have happened and are terminal
terminContract :: [CreditEvent]
               -> Obs Bool
terminContract [] = konst False
terminContract ((_, cTermin, _, _, _, cHasHappened):xs) =
          ifthen (cHasHappened %&& konst cTermin)
             (konst True)
             (terminContract xs)

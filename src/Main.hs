-- | Main entry point to the application.

module Main where

import Data.Stream
import Data.Event

-- | The main entry point.
main :: IO ()
main = print "Hello"
  

data CounterEvent = CounterAdded Int | CounterReset deriving Show
newtype CounterState = CounterState Int deriving Show

instance EventPersistable CounterEvent where
    hole = undefined

counter :: CounterState -> CounterEvent -> CounterState
counter _ CounterReset = CounterState 0
counter (CounterState b) (CounterAdded a) = CounterState $ a + b
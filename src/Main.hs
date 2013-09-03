-- | Main entry point to the application.

module Main where

import Data.Stream
import Data.Event

-- | The main entry point.
main :: IO ()
main = 
   runAction action >>= print
  

data CounterEvent = CounterAdded Int | CounterReset deriving Show
newtype CounterState = CounterState Int deriving Show

instance EventPersistable CounterEvent

action :: StreamAction (Stream CounterEvent, CounterState)
action = do
    stream1 <- createStream "counter" CounterReset
    stream2 <- foldStream (lift counter) (CounterState 0) stream1
    return (stream1, stream2)
    
counter :: CounterState -> CounterEvent -> CounterState
counter _ CounterReset = CounterState 0
counter (CounterState b) (CounterAdded a) = CounterState $ a + b
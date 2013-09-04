{-# LANGUAGE TemplateHaskell, OverloadedStrings #-}
-- | Main entry point to the application.

module Main where

import Data.Stream
import Data.Aeson.TH
import Data.Aeson
import Data.Typeable
import Data.Data

action :: StreamTransaction Bool
action = do
    let stream = createInputStream CounterReset
    persistStream stream "Input"
    return True

badaboom :: IO Bool
badaboom = executeTransaction fakeManager action 

-- | The main entry point.
main :: IO ()
main = do 
   print (decode $ encode $ CounterAdded 4 :: Maybe CounterEvent)
   t <- badaboom
   print t

data CounterEvent = CounterAdded Int | CounterReset deriving (Show, Eq)
newtype CounterState = CounterState Int deriving Show

counter :: CounterState -> CounterEvent -> CounterState
counter _ CounterReset = CounterState 0
counter (CounterState b) (CounterAdded a) = CounterState $ a + b

$(deriveJSON id ''CounterEvent)
instance StreamPersistable CounterEvent



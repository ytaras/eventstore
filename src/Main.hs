{-# LANGUAGE TemplateHaskell, 
             OverloadedStrings, 
             TypeSynonymInstances,     
             FlexibleInstances #-}
             
-- | Main entry point to the application.

module Main where

import Data.Stream
import Data.Aeson.TH
import Data.Aeson
import Data.Typeable
import Data.Data  

data CounterEvent = CounterAdded Int | CounterReset deriving (Show, Eq)
newtype CounterState = CounterState Int deriving Show
$(deriveJSON id ''CounterEvent)
 
-- | The main entry point.
main :: IO ()
main = do 
   print (decode $ encode $ CounterAdded 4 :: Maybe CounterEvent)
   t <- executeTransaction fakeManager action 
   print t

action :: StreamTransaction Bool
action = do
    stream <- persistStream "Input" $ createInputStream CounterReset
    persistStream "Output" $ fmap show stream
    return True 

counter :: CounterState -> CounterEvent -> CounterState
counter _ CounterReset = CounterState 0
counter (CounterState b) (CounterAdded a) = CounterState $ a + b

instance StreamPersistable CounterEvent
instance StreamPersistable String
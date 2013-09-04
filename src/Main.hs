{-# LANGUAGE TemplateHaskell, OverloadedStrings #-}
-- | Main entry point to the application.

module Main where

import Data.Stream
import Data.Aeson.TH
import Data.Aeson
import Data.Typeable
import Data.Data

-- | The main entry point.
main :: IO ()
main = putStrLn $ show $ (decode $ encode $ CounterAdded 4 :: Maybe CounterEvent)

data CounterEvent = CounterAdded Int | CounterReset deriving (Show, Eq)
newtype CounterState = CounterState Int deriving Show

counter :: CounterState -> CounterEvent -> CounterState
counter _ CounterReset = CounterState 0
counter (CounterState b) (CounterAdded a) = CounterState $ a + b

$(deriveJSON id ''CounterEvent)
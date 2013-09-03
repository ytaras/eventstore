module Data.Event where

import Data.UUID

newtype ID = ID UUID deriving (Show, Eq)
newtype Version = Version Int deriving (Show, Eq)

data Event a = Event { getData :: a } deriving (Show, Eq)
    
instance Functor Event where
    fmap f e = e { getData = f $ getData e }
    
class EventPersistable a where
    hole :: a
    
createEvent ::EventPersistable a => a -> Event a
createEvent = Event
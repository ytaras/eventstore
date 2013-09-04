{-# LANGUAGE RankNTypes, FlexibleContexts #-}

module Data.Stream ( createInputStream
                   , persistStream
                   , executeTransaction
                   , liftStream
                   , fakeManager
                   , StreamTransaction
                   , StreamPersistable
                   , Stream
                   )
where       

import Data.Aeson
import Control.Monad.Error

data Stream a = InputStream [a] |  MappedStream (StreamFunction a)
newtype StreamTransaction a = StreamTransaction a
type StreamFunction a = (MonadError StreamError m) => Value -> m b
data StreamManager = StreamManager
type StreamError = String

class (FromJSON a, ToJSON a) => StreamPersistable a

createInputStream :: StreamPersistable a => a -> Stream a
createInputStream init = InputStream [init]

persistStream :: StreamPersistable a => String -> Stream a -> StreamTransaction (Stream a)
persistStream = undefined

executeTransaction :: StreamManager -> StreamTransaction a -> IO a
executeTransaction = undefined

liftStream :: (MonadError StreamError m, StreamPersistable a, StreamPersistable b) => (a -> m b) -> StreamFunction b
liftStream = undefined

fakeManager :: StreamManager
fakeManager = undefined

instance Monad StreamTransaction where
    return = undefined
    (>>=) = undefined
    
instance Functor Stream where
    fmap = undefined
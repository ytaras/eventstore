{-# LANGUAGE RankNTypes, FlexibleContexts #-}

module Data.Stream ( createInputStream
                   , persistStream
                   , executeTransaction
                   , liftStream
                   , fakeManager
                   )
where       

import Data.Aeson
import Control.Monad.Error

data Stream a = InputStream [a] |  MappedStream (StreamFunction a)
newtype StreamTransaction a = StreamTransaction a
type StreamFunction a = (MonadError StreamError m) => a -> m Value
data StreamManager = StreamManager
type StreamError = String

class (FromJSON a, ToJSON a) => StreamPersistable a

createInputStream :: StreamPersistable a => a -> Stream a
createInputStream init = InputStream [init]

persistStream :: StreamPersistable a => Stream a -> String -> StreamTransaction ()
persistStream = undefined

executeTransaction :: StreamManager -> StreamTransaction a -> IO a
executeTransaction = undefined

liftStream :: (MonadError StreamError m, StreamPersistable a, StreamPersistable b) => (a -> m b) -> StreamFunction a
liftStream = undefined

fakeManager :: StreamManager
fakeManager = undefined
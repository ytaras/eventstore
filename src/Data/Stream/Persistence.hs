{-# LANGUAGE FlexibleInstances, UndecidableInstances #-}
module Data.Stream.Persistence where

import qualified Data.Map as M
import Control.Concurrent.STM
import Control.Monad ((>=>))

class Persistable a where
-- TODO String is just a temporary solution
    toString :: a -> String
    fromString :: String -> a
    
instance (Read a, Show a) => Persistable a where
    toString = show
    fromString = read
   
data StreamState = StreamState { streams :: M.Map String PersistedStream }
data PersistedStream = InputStream [String]

createStream :: Persistable a => String -> a -> TVar StreamState -> STM PersistedStream
createStream name start state =
        mutateTVar (liftStreamState $ M.insert name res) state >> return res
            where
        res = InputStream [toString start]


liftStreamState :: (M.Map String PersistedStream -> M.Map String PersistedStream) -> StreamState -> StreamState
liftStreamState f s = s { streams = f $ streams s }

mutateTVar :: (a -> a) -> TVar a -> STM ()
mutateTVar f v = readTVar v >>= \x -> writeTVar v $ f x

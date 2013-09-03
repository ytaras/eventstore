{-# LANGUAGE ExistentialQuantification #-}

module Data.Stream ( Stream
                   , StreamAction
                   , StreamManager
                   , fakeManager
                   , runAction
                   , createStream
                   , foldStream
                   , lift
                   )
where       

import Data.Event
import Data.Foldable

data StreamAction a = StreamAction { actions :: [DbCommand], value :: a }
data StreamManager = StreamManager


data DbCommand = forall a . EventPersistable a => CreateStream String a

instance Monad StreamAction where
    return = StreamAction []
    StreamAction oldActions value >>= f = 
        let StreamAction newActions ret = f value in
            StreamAction (oldActions ++ newActions) ret

data Stream event = Stream { events :: [Event event] } deriving Show

runAction :: StreamManager -> StreamAction a -> IO a
runAction = undefined

fakeManager :: StreamManager
fakeManager = StreamManager

createStream :: EventPersistable a => String -> a -> StreamAction (Stream a)
createStream name e = return $ Stream [createEvent e]

foldStream :: (b -> Event a -> b) -> b -> Stream a -> StreamAction b
foldStream f a = return . foldl' f a . events

lift :: (b -> a -> b) -> b -> Event a -> b
lift f b = f b . getData
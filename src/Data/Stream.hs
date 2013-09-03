module Data.Stream ( Stream
                   , StreamAction
                   , runAction
                   , createStream
                   , foldStream
                   , lift
                   )
where       

import Data.Event
import Data.Foldable

data StreamAction a = StreamAction { runAction :: IO a }

instance Monad StreamAction where
    return = StreamAction . return
    StreamAction v >>= f =
        StreamAction $ v >>= (runAction . f)
      
data Stream event = Stream { events :: [Event event] } deriving Show

createStream :: EventPersistable a => String -> a -> StreamAction (Stream a)
createStream name e = return $ Stream [createEvent e]

foldStream :: (b -> Event a -> b) -> b -> Stream a -> StreamAction b
foldStream f a = return . foldl' f a . events

lift :: (b -> a -> b) -> b -> Event a -> b
lift f b = f b . getData
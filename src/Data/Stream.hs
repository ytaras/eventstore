module Data.Stream ( Stream
                   , StreamAction
                   , createStream
                   , foldStream
                   )
where       

import Data.Event
import Data.Foldable

data StreamAction a = StreamAction { runAction :: IO a }

instance Monad StreamAction where
    return = StreamAction . return
    StreamAction v >>= f =
        StreamAction $ v >>= (runAction . f)
      
data Stream event = Stream { events :: [Event event] } 

createStream :: EventPersistable a => String -> Event a -> StreamAction (Stream a)
createStream name e = return $ Stream [e]

foldStream :: (b -> Event a -> b) -> b -> Stream a -> StreamAction b
foldStream f a = return . foldl' f a . events


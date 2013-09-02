module Data.Stream (Stream) where

import Data.Event
import Data.Foldable
import Control.Applicative ((<$>), (<*>))

data StreamAction a = StreamAction { runAction :: IO a }

instance Monad StreamAction where
    return = StreamAction . return
    StreamAction v >>= f =
        StreamAction $ v >>= (runAction . f)
      
data Stream event = Stream { events :: [Event event] } 

createStream :: EventPersistable a => String -> Event a -> StreamAction (Stream a)
createStream name e = return $ Stream [e]

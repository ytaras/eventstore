
module Data.Stream ( Stream
                   , StreamAction
                   , createStream
                   , foldStream
                   , lift
                   )
where       

import Data.Event
import Data.Foldable

data StreamAction a = StreamAction { value :: a }

data Stream event = Stream { events :: [Event event] } deriving Show

createStream :: EventPersistable a => String -> a -> StreamAction (Stream a)
createStream name e = undefined

foldStream :: (b -> Event a -> b) -> b -> Stream a -> StreamAction b
foldStream f a = undefined

lift :: (b -> a -> b) -> b -> Event a -> b
lift f b = f b . getData
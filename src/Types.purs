module Types where

import Prelude

import Control.Monad.Eff.Exception (Error)
import Data.Either (Either(..), either)
import Data.Foreign.Class (class Decode, class Encode)
import Data.Generic.Rep (class Generic)
import Presto.Core.Types.API (class RestEndpoint, Headers(Headers), Method(GET), defaultDecodeResponse, defaultMakeRequest_)
import Presto.Core.Types.Language.Flow (APIResult, Flow, callAPI)
import Presto.Core.Types.Language.Interaction (class Interact, defaultInteract)
import Presto.Core.Utils.Encoding (defaultDecode, defaultEncode)

---------------------------------SCREEN-----------------------------------------
type ToDo = String
type ID = String

data MainScreen = MainScreen MainScreenState

data MainScreenState
  = MainScreenInit
  | MainScreenAddToDo ToDo String
  | MainScreenDeleteToDo ID

data MainScreenAction
  = AddToDo ToDo
  | RemoveTodo ID

instance mainScreenInteract :: Interact Error MainScreen MainScreenAction  where
    interact x = defaultInteract x

derive instance genericMainScreen :: Generic MainScreen _
instance encodeMainScreen :: Encode MainScreen where
    encode = defaultEncode

derive instance genericMainScreenState :: Generic MainScreenState _
instance encodeMainScreenState :: Encode MainScreenState where
    encode = defaultEncode

derive instance genericMainScreenAction :: Generic MainScreenAction _
instance decodeMainScreenAction :: Decode MainScreenAction where
  decode = defaultDecode

-----------------------------------API------------------------------------------
withAPIResult :: forall a b. (a -> b) -> Flow (APIResult a) -> Flow (APIResult b)
withAPIResult f flow = flow >>= either (pure <<< Left) (pure <<< Right <<< f)

getTime :: Flow (APIResult String)
getTime = withAPIResult unwrapResponse (callAPI (Headers []) $ TimeReq)
  where unwrapResponse (TimeResp {response}) = response

data TimeReq = TimeReq
newtype TimeResp = TimeResp
  { code :: Int
  , status :: String
  , response :: String
  }

instance getTimeReq :: RestEndpoint TimeReq TimeResp where
  makeRequest _ headers = defaultMakeRequest_ GET ("http://localhost:3000") headers
  decodeResponse body = defaultDecodeResponse body

derive instance genericTimeReq :: Generic TimeReq _
instance encodeTimeReq :: Encode TimeReq where encode = defaultEncode

derive instance genericTimeResp :: Generic TimeResp _
instance decodeTimeResp :: Decode TimeResp where decode = defaultDecode

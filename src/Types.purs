module Types where

import Control.Monad.Eff.Exception (Error)
import Data.Foreign.Class (class Decode, class Encode)
import Data.Generic.Rep (class Generic)
import Presto.Core.Types.API (class RestEndpoint, Method(..), defaultDecodeResponse, defaultMakeRequest, defaultMakeRequest_)
import Presto.Core.Types.Language.Interaction (class Interact, defaultInteract)
import Presto.Core.Utils.Encoding (defaultDecode, defaultEncode)

---------------------------------SCREEN-----------------------------------------
data MainScreen = MainScreen MainScreenState

data MainScreenState
  = MainScreenInit
  | MainScreenAddTodo String String
  | MainScreenDeleteTodo String
  | MainScreenEditTodo String
  | MainScreenUpdateTodo (Array String)
  | MainScreenError String

data MainScreenAction
  = AddTodo String
  | RemoveTodo String
  | EditTodo String
  | UpdateTodo String String

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

data TimeReq = TimeReq
newtype TimeResp = TimeResp
  { code :: Int
  , status :: String
  , response :: String
  }

instance getTimeReq :: RestEndpoint TimeReq TimeResp where
  makeRequest _ headers = defaultMakeRequest_ GET "http://localhost:3000/time" headers
  decodeResponse body = defaultDecodeResponse body

derive instance genericTimeReq :: Generic TimeReq _
instance encodeTimeReq :: Encode TimeReq where
  encode = defaultEncode

derive instance genericTimeResp :: Generic TimeResp _
instance decodeTimeResp :: Decode TimeResp where
  decode = defaultDecode

data UpdateReq = UpdateReq String String
newtype UpdateRes = UpdateRes
  { code :: Int
  , status :: String
  , response :: Array String
  }

instance makeUpdateReq :: RestEndpoint UpdateReq UpdateRes where
  makeRequest reqBody headers = defaultMakeRequest POST "http://localhost:3000/update" headers reqBody
  decodeResponse body = defaultDecodeResponse body

derive instance genericUpdateReq :: Generic UpdateReq _
instance encodeUpdateReq :: Encode UpdateReq where
  encode = defaultEncode

derive instance genericUpdateRes :: Generic UpdateRes _
instance decodeUpdateRes :: Decode UpdateRes where
  decode = defaultDecode

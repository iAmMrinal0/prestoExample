module Utils.Runner where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (Error)
import Presto.Core.Types.API (Header(..), Headers(..), Request(..), URL)
import Presto.Core.Types.App (UI)

type NativeHeader = {field :: String, value :: String}
type NativeHeaders = Array NativeHeader

newtype NativeRequest = NativeRequest
  { method :: String
  , url :: URL
  , payload :: String
  , headers :: NativeHeaders
  }

type AffError e = (Error -> Eff e Unit)
type AffSuccess s e = (s -> Eff e Unit)

foreign import showUI' :: forall e. (String -> Eff (ui :: UI | e) Unit) ->  String -> (Eff (ui :: UI | e) Unit)
foreign import callAPI' :: forall e. (AffError e) -> (AffSuccess String e) -> NativeRequest -> Eff e Unit

mkNativeHeader :: Header -> NativeHeader
mkNativeHeader (Header field val) = { field: field, value: val}

mkNativeRequest :: Request -> NativeRequest
mkNativeRequest (Request request@{headers: Headers hs}) = NativeRequest
  { method : show request.method
  , url: request.url
  , payload: request.payload
  , headers: mkNativeHeader <$> hs
  }

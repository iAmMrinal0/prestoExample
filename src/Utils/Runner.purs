module Utils.Runner where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (Error)
import Presto.Core.Types.API (Request(..), URL)
import Presto.Core.Types.App (UI)

newtype NativeRequest = NativeRequest
  { method :: String
  , url :: URL
  }

type AffError e = (Error -> Eff e Unit)
type AffSuccess s e = (s -> Eff e Unit)

foreign import showUI' :: forall e. (String -> Eff (ui :: UI | e) Unit) ->  String -> (Eff (ui :: UI | e) Unit)
foreign import callAPI' :: forall e. (AffError e) -> (AffSuccess String e) -> NativeRequest -> Eff e Unit

mkNativeRequest :: Request -> NativeRequest
mkNativeRequest (Request request) = NativeRequest
  { method : show request.method
  , url: request.url
  }

module Remote where

import Prelude

import Data.Either (Either(..))
import Presto.Core.Flow (Flow, callAPI)
import Presto.Core.Types.API (Headers(..))
import Presto.Core.Types.Language.Flow (APIResult)
import Types (TimeReq(..), TimeResp(..))

getTime :: Flow (APIResult String)
getTime = do
  eResponse <- callAPI (Headers []) TimeReq
  case eResponse of
    Left err -> pure $ Left err
    Right (TimeResp {response}) -> pure $ Right response

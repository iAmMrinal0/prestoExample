module Main where

import Prelude

import Control.Monad.Aff (launchAff, makeAff)
import Control.Monad.Aff.AVar (makeVar')
import Control.Monad.State.Trans (evalStateT)
import Data.Either (Either(..))
import Data.StrMap (empty)
import Data.Tuple (Tuple(..))
import Presto.Core.Flow (APIRunner, PermissionCheckRunner, PermissionRunner(PermissionRunner), PermissionTakeRunner, callAPI, runUI)
import Presto.Core.Language.Runtime.Interpreter (Runtime(..), UIRunner, run)
import Presto.Core.Types.API (Headers(..))
import Presto.Core.Types.Permission (PermissionStatus(..))
import Types (MainScreen(..), MainScreenAction(..), MainScreenState(..), TimeReq(..), TimeResp(..))
import Utils.Runner (callAPI', mkNativeRequest, showUI')

launchFreeFlow = do
  let runtime = Runtime uiRunner (PermissionRunner permissionCheckRunner permissionTakeRunner) apiRunner
      freeFlow = evalStateT (run runtime (appFlow MainScreenInit))
  launchAff (makeVar' empty >>= freeFlow)
  where
    uiRunner :: UIRunner
    uiRunner a = makeAff (\err sc -> showUI' sc a)

    apiRunner :: APIRunner
    apiRunner req = makeAff (\err sc -> callAPI' err sc (mkNativeRequest req))

    permissionCheckRunner :: PermissionCheckRunner
    permissionCheckRunner perms = pure PermissionGranted

    permissionTakeRunner :: PermissionTakeRunner
    permissionTakeRunner perms =  pure $ map (\x -> Tuple x PermissionDeclined) perms

main = launchFreeFlow

appFlow state = do
  action <- runUI (MainScreen state)
  case action of
    AddTodo str -> addTodoFlow str
    RemoveTodo id -> appFlow (MainScreenDeleteTodo id)

addTodoFlow str = do
  resp <- callAPI (Headers []) TimeReq
  case resp of
    Left err -> appFlow (MainScreenError (show err))
    Right (TimeResp scc) -> appFlow (MainScreenAddTodo str scc)

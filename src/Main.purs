module Main where

import Prelude

import Control.Monad.Aff (launchAff, makeAff)
import Control.Monad.Aff.AVar (makeVar')
import Control.Monad.State.Trans (evalStateT)
import Data.Either (Either(..))
import Data.StrMap (empty)
import Data.Tuple (Tuple(..))
import Presto.Core.Flow (APIRunner, PermissionCheckRunner, PermissionRunner(PermissionRunner), PermissionTakeRunner, runUI)
import Presto.Core.Language.Runtime.Interpreter (Runtime(..), UIRunner, run)
import Presto.Core.Types.Permission (PermissionStatus(..))
import Types (MainScreen(..), MainScreenAction(..), MainScreenState(..), getTime)
import Utils.Runner (mkNativeRequest, showUI', callAPI')

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

appFlow state = do
  action <- runUI (MainScreen state)
  case action of
    AddToDo str -> do
      resp <- getTime
      case resp of
        Left err -> appFlow (MainScreenInit)
        Right scc -> appFlow (MainScreenAddToDo str scc)
    RemoveTodo id -> appFlow (MainScreenDeleteToDo id)

main = launchFreeFlow

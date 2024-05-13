module R2CL.GitHub.Repository
  ( OwnerName (..)
  , RepoName (..)
  , BranchName (..)
  , TagName (..)
  , Repository (..)
  , readRepository
  , repositoryUrlPiece
  , inferRepository
  , inferDefaultBranch
  ) where

import Relude

import Data.List (break)
import Data.Text (pack)

newtype OwnerName = OwnerName {unwrap :: Text}
  deriving newtype (Show, IsString)

newtype RepoName = RepoName {unwrap :: Text}
  deriving newtype (Show, IsString)

newtype BranchName = BranchName {unwrap :: Text}
  deriving newtype (Show, IsString)

newtype TagName = TagName {unwrap :: Text}
  deriving newtype (Show, IsString)

data Repository = Repository
  { owner :: OwnerName
  , name :: RepoName
  }
  deriving stock (Show)

readRepository :: String -> Either String Repository
readRepository s = case break (== '/') s of
  (owner, '/' : name)
    | not (null owner)
    , not (null name) ->
        Right
          Repository
            { owner = OwnerName $ pack owner
            , name = RepoName $ pack name
            }
  _ -> Left "Invalid OWNER/NAME"

repositoryUrlPiece :: Repository -> Text
repositoryUrlPiece repository =
  repository.owner.unwrap <> "/" <> repository.name.unwrap

inferRepository :: m Repository
inferRepository = undefined

inferDefaultBranch :: MonadIO m => m BranchName
inferDefaultBranch = pure "main"

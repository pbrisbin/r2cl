module R2CL.Release
  ( Release (..)
  , fetchReleases
  ) where

import Relude

import Data.Text (unpack)
import Data.Vector qualified as V
import R2CL.GitHub qualified as GitHub
import R2CL.GitHub.Repository
import R2CL.Version

data Release = Release
  { name :: Text
  , tagName :: TagName
  , body :: Text
  }

fetchReleases :: MonadIO m => Repository -> Maybe Version -> m [Release]
fetchReleases repository mAfter = do
  releases <-
    GitHub.run
      $ GitHub.releasesR
        (GitHub.mkName (Proxy @GitHub.Owner) repository.owner.unwrap)
        (GitHub.mkName (Proxy @GitHub.Repo) repository.name.unwrap)
        GitHub.FetchAll

  pure $ toList $ fmap fromGitHub $ case mAfter of
    Nothing -> releases
    Just after -> V.takeWhile (releaseIsAfter after) releases

fromGitHub :: GitHub.Release -> Release
fromGitHub release =
  Release
    { name = GitHub.releaseName release
    , tagName = TagName $ GitHub.releaseTagName release
    , body = GitHub.releaseBody release
    }

releaseIsAfter :: Version -> GitHub.Release -> Bool
releaseIsAfter after release =
  case readVersion $ unpack $ GitHub.releaseTagName release of
    Left {} -> True
    Right v -> v > after

{-# LANGUAGE DataKinds #-}

module R2CL.GitHub
  ( run
  , module GitHub
  ) where

import Relude

import Data.Aeson (FromJSON)
import Data.ByteString.Char8 qualified as BS8
import GitHub.Data.Releases as GitHub
import GitHub.Endpoints.Repos.Releases as GitHub
import GitHub.Request
import System.Environment (getEnv)
import UnliftIO.Exception (throwIO)

run :: (MonadIO m, FromJSON a) => Request 'RO a -> m a
run req = liftIO $ do
  token <- BS8.pack <$> getEnv "GITHUB_TOKEN"
  either throwIO pure =<< github (OAuth token) req

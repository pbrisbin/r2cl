module R2CL.Changelog
  ( Changelog (..)
  ) where

import Relude

import R2CL.ChangelogSection

data Changelog = Changelog
  { title :: Text
  , sections :: [ChangelogSection]
  }
  deriving stock (Show)

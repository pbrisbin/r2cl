{-# LANGUAGE NamedFieldPuns #-}

module R2CL.ChangelogSection
  ( ChangelogSection (..)
  , releaseSection
  , unreleasedSection
  ) where

import Relude

import R2CL.Ref
import R2CL.Release

data ChangelogSection = ChangelogSection
  { name :: Text
  , ref :: Maybe Ref
  -- ^ 'Nothing' for Unreleased, will use default-branch
  , previousRef :: Maybe Ref
  -- ^ 'Nothing' for first release, will render tree/ref instead
  , notes :: Text
  }
  deriving stock (Show)

releaseSection :: Maybe Ref -> Release -> ChangelogSection
releaseSection previousRef release =
  ChangelogSection
    { name = release.name
    , ref = Just $ TagRef release.tagName
    , previousRef
    , notes = release.body
    }

unreleasedSection :: Ref -> ChangelogSection
unreleasedSection previousRef =
  ChangelogSection
    { name = "Unreleased"
    , ref = Nothing
    , previousRef = Just previousRef
    , notes = ""
    }

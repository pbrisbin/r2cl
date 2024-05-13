module R2CL.Changelog.Build
  ( buildChangelog
  ) where

import Relude

import R2CL.Changelog
import R2CL.ChangelogSection
import R2CL.Ref
import R2CL.Release
import R2CL.Version

buildChangelog :: Maybe Version -> [Release] -> Changelog
buildChangelog mAfter releases =
  Changelog
    { title = "CHANGELOG"
    , sections = addUnreleased releaseSections
    }
 where
  (mLatestRef, releaseSections) =
    foldl' foldRelease (VersionRef <$> mAfter, [])
      $ reverse releases

  addUnreleased = case mLatestRef of
    Just ref -> (unreleasedSection ref :)
    Nothing -> id

foldRelease
  :: (Maybe Ref, [ChangelogSection]) -> Release -> (Maybe Ref, [ChangelogSection])
foldRelease (mPreviousRef, sections) = toPair . releaseSection mPreviousRef
 where
  toPair section = (section.ref, section : sections)

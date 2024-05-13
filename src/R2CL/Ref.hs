module R2CL.Ref
  ( Ref (..)
  , refUrlPiece
  ) where

import Relude

import Data.Text (pack)
import R2CL.GitHub.Repository (BranchName (..), TagName (..))
import R2CL.Version

data Ref
  = VersionRef Version
  | TagRef TagName
  | BranchRef BranchName
  deriving stock (Show)

refUrlPiece :: Ref -> Text
refUrlPiece = \case
  VersionRef v -> pack $ showVersion v
  TagRef t -> t.unwrap
  BranchRef b -> b.unwrap

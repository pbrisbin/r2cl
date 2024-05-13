module R2CL.Changelog.Render
  ( renderChangelog
  ) where

import Relude

import Data.Text qualified as T
import R2CL.Changelog
import R2CL.ChangelogSection
import R2CL.GitHub.Repository
import R2CL.Ref

renderChangelog :: Repository -> BranchName -> Changelog -> Text
renderChangelog repository defaultBranch changelog =
  T.unlines $ titleLines <> sectionsLines
 where
  titleLines = ["# " <> changelog.title, ""]
  sectionsLines = map (renderChangelogSection repository defaultBranch) changelog.sections

renderChangelogSection :: Repository -> BranchName -> ChangelogSection -> Text
renderChangelogSection repository defaultBranch section =
  T.unlines
    [ "## [" <> section.name <> "](" <> linkUrl <> ")"
    , ""
    , section.notes
    ]
 where
  linkUrl = case (section.ref, section.previousRef) of
    (Just ref, Just previousRef) -> compareUrl repository previousRef ref
    (Just ref, Nothing) -> treeUrl repository ref
    (Nothing, Just previousRef) -> compareUrl repository previousRef $ BranchRef defaultBranch
    (Nothing, Nothing) -> treeUrl repository $ BranchRef defaultBranch

compareUrl :: Repository -> Ref -> Ref -> Text
compareUrl repository fromRef toRef =
  "https://github.com/"
    <> repositoryUrlPiece repository
    <> "/compare/"
    <> refUrlPiece fromRef
    <> ".."
    <> refUrlPiece toRef

treeUrl :: Repository -> Ref -> Text
treeUrl repository ref =
  "https://github.com/"
    <> repositoryUrlPiece repository
    <> "/tree/"
    <> refUrlPiece ref

module R2CL.Changelog.Update
  ( updateChangelog
  , updateChangelogLines
  ) where

import Relude

import Data.List (findIndex)
import Data.Text qualified as T

updateChangelog :: MonadIO m => FilePath -> Text -> m ()
updateChangelog path rendered = do
  writeFileText path
    . T.unlines
    . updateChangelogLines rendered
    . T.lines
    . decodeUtf8
    =<< readFileBS path

updateChangelogLines :: Text -> [Text] -> [Text]
updateChangelogLines rendered = \case
  -- End recursion
  [] -> []
  -- Found the start line
  (l : ls) | l == beginPragma ->
    -- Drop until an end line
    case dropUntilStrictly (/= endPragma) ls of
      -- We found an end line insert it between
      Just after -> [beginPragma, rendered, endPragma] <> after
      -- We found end line, insert it all here
      Nothing -> [beginPragma, rendered, endPragma] <> ls
  -- No start line, recurse
  (l : ls) -> l : updateChangelogLines rendered ls

beginPragma :: Text
beginPragma = "<!-- r2cl BEGIN -->"

endPragma :: Text
endPragma = "<!-- r2cl END -->"

dropUntilStrictly :: (a -> Bool) -> [a] -> Maybe [a]
dropUntilStrictly p as = ($ as) . drop <$> findIndex p as

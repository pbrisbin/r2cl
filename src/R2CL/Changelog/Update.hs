module R2CL.Changelog.Update
  ( updateChangelog

    -- * Exported for testing
  , InvalidPragmas (..)
  , updateChangelogLines
  ) where

import Relude

import Data.List (elemIndex)
import Data.Text qualified as T
import UnliftIO.Exception (throwIO)

data InvalidPragmas
  = EndWithoutBegin Int
  | EndBeforeBegin Int Int
  deriving stock (Show)

instance Exception InvalidPragmas where
  displayException = \case
    EndWithoutBegin e ->
      "END present at index "
        <> show e
        <> "but no BEGIN found"
    EndBeforeBegin e b ->
      "END present at index "
        <> show e
        <> " is before BEGIN found at "
        <> show b

updateChangelog :: MonadIO m => FilePath -> Text -> m ()
updateChangelog path rendered = do
  writeFileText path
    . T.unlines
    =<< either throwIO pure
    . updateChangelogLines rendered
    . T.lines
    . decodeUtf8
    =<< readFileBS path

updateChangelogLines :: Text -> [Text] -> Either InvalidPragmas [Text]
updateChangelogLines rendered ls =
  case (beginIndex, endIndex) of
    (Nothing, Nothing) -> Right $ rendered' <> ls
    (Nothing, Just e) -> Left $ EndWithoutBegin e
    (Just b, Nothing) -> Right $ take b ls <> rendered' <> drop (b + 1) ls
    (Just b, Just e) | e > b -> Right $ take b ls <> rendered' <> drop (e + 1) ls
    (Just b, Just e) -> Left $ EndBeforeBegin e b
 where
  rendered' = [beginPragma, rendered, endPragma]
  beginIndex = elemIndex beginPragma ls
  endIndex = elemIndex endPragma ls

beginPragma :: Text
beginPragma = r2clPragma "BEGIN"

endPragma :: Text
endPragma = r2clPragma "END"

r2clPragma :: Text -> Text
r2clPragma x = "<!-- r2cl " <> x <> " -->"

module Main
  ( main
  ) where

import Relude

import Data.Text.IO qualified as T
import Options.Applicative
import R2CL.Changelog.Build
import R2CL.Changelog.Render
import R2CL.Changelog.Update
import R2CL.GitHub.Repository
import R2CL.Release
import R2CL.Version

data Options = Options
  { repository :: Repository
  , defaultBranch :: BranchName
  , after :: Maybe Version
  , update :: Maybe FilePath
  }

parseOptions :: Parser Options
parseOptions =
  Options
    <$> option
      (eitherReader readRepository)
      ( mconcat
          [ long "repo"
          , help "Repository to fetch releases for"
          , metavar "OWNER/NAME"
          ]
      )
    <*> strOption
      ( mconcat
          [ long "default-branch"
          , help "Branch to use in Unreleased section"
          , value "main"
          , showDefault
          ]
      )
    <*> optional
      ( option
          (eitherReader readVersion)
          ( mconcat
              [ long "after"
              , help "Only generate with versions up to the given version"
              , metavar "vX.Y.Z"
              ]
          )
      )
    <*> optional
      ( strOption
          ( mconcat
              [ short 'u'
              , long "update"
              , help "Update PATH in place"
              , metavar "PATH"
              ]
          )
      )

main :: IO ()
main = do
  options <- execParser $ info (parseOptions <**> helper) mempty
  releases <- fetchReleases options.repository options.after

  let rendered =
        renderChangelog options.repository options.defaultBranch
          $ buildChangelog options.after releases

  case options.update of
    Nothing -> T.putStrLn rendered
    Just fp -> do
      putStrLn $ "Updated " <> fp
      updateChangelog fp rendered

module Main
  ( main
  ) where

import Relude

import Data.Text.IO qualified as T
import Options.Applicative
import R2CL.Changelog.Build
import R2CL.Changelog.Render
import R2CL.GitHub.Repository
import R2CL.Release
import R2CL.Version

data Options = Options
  { repository :: Maybe Repository
  , defaultBranch :: Maybe BranchName
  , after :: Maybe Version
  , update :: Maybe FilePath
  }

parseOptions :: Parser Options
parseOptions =
  Options
    <$> optional
      ( option
          (eitherReader readRepository)
          ( mconcat
              [ long "repo"
              , help "Repository to fetch releases for"
              , metavar "OWNER/NAME"
              ]
          )
      )
    <*> optional
      ( strOption
          ( mconcat
              [ long "default-branch"
              , help "Branch to use in Unreleased section"
              ]
          )
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
  repository <- maybe inferRepository pure $ options.repository
  defaultBranch <- maybe inferDefaultBranch pure $ options.defaultBranch
  releases <- fetchReleases repository options.after

  let rendered =
        renderChangelog repository defaultBranch
          $ buildChangelog options.after releases

  -- TODO: handle options.update
  T.putStrLn rendered

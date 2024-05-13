module R2CL.Version
  ( Version
  , showVersion
  , readVersion
  ) where

import Relude

import Data.List.NonEmpty qualified as NE
import Data.Version
import Text.ParserCombinators.ReadP (readP_to_S)

readVersion :: String -> Either String Version
readVersion ('v' : rest) = readVersion rest
readVersion s = case NE.nonEmpty (readP_to_S parseVersion s) of
  Nothing -> Left "Invalid version"
  Just vs -> Right $ fst $ NE.last vs

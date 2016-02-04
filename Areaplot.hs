module Main where

import qualified Data.Map as M
import Data.Map (Map)

import qualified Data.Set as S
import Data.Set (Set)

import System.Environment (getArgs)

import Data.List

type ResMap = Map FilePath (Maybe Double)

parseResults :: String -> ResMap
parseResults s =
  M.fromList
  [ case reads t of
      [(d,_)] -> (normaliseFilename f,Just d)
      _       -> (normaliseFilename f,Nothing)
  | l <- lines s
  , (f,',':t) <- [break (== ',') l]
  ]

normaliseFilename :: String -> String
normaliseFilename = reverse . takeWhile (/= '/') . drop 1 . dropWhile (/= '.') . reverse

area :: ResMap -> ResMap -> [(Double,(Int,Int,Int))]
area me them = map (fmap summarize) $ go (S.empty,S.empty) events
  where
  events =
    sort
    [ (t,(f,lr))
    | (f,lr) <- M.toList (fmap Left me) ++ M.toList (fmap Right them)
    , Just t <- [either id id lr]
    ]

  go :: Ord f => (Set f,Set f) -> [(t,(f,Either u v))] -> [(t,(Set f,Set f))]
  go lr [] = []
  go lr ((t,(f,who)):xs) =
    let lr' = i lr who
    in  (t,lr'):go lr' xs
    where
    i (l,r) Left{}  = (S.insert f l,r)
    i (l,r) Right{} = (l,S.insert f r)


  summarize :: (Set FilePath,Set FilePath) -> (Int,Int,Int)
  summarize (l,r) =
    ( S.size (l `S.difference` r)
    , S.size (l `S.intersection` r)
    , S.size (r `S.difference` l)
    )

output :: [(Double,(Int,Int,Int))] -> String
output xs =
  unlines $
    "t me us them sum":
    [ unwords (show d:map show [me,us,them,me+us+them])
    | (d,(me,us,them)) <- xs
    ]

main =
  do [me,them] <- mapM (fmap parseResults . readFile) =<< getArgs
     putStrLn (output (area me them))


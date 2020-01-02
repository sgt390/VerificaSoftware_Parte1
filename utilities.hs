module Utilities where

safesum :: Maybe Int -> Maybe Int -> Maybe Int
safesum Nothing _ = Nothing
safesum _ Nothing = Nothing
safesum (Just n) (Just m) = Just (n + m)
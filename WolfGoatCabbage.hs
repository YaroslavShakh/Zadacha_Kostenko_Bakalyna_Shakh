module Main where

data B = L | R deriving (Eq, Show) -- B = Bank 
type S = (B, B, B, B)              
-- S = State (Фермер(f), Вовк(w), Коза(g), Капуста(c))

opp :: B -> B
opp L = R; opp R = L


safe :: S -> Bool
safe (f,w,g,c) = f == g || (w /= g && g /= c)


next :: S -> [S]
next (f,w,g,c) = filter safe $ 
  [ (opp f, w, g, c) ] ++                        
  [ (opp f, opp w, g, c) | f == w ] ++           
  [ (opp f, w, opp g, c) | f == g ] ++           
  [ (opp f, w, g, opp c) | f == c ]             


solve :: [[S]] -> [S] -> [S]
solve [] _ = [] 
solve (path@(curr:_):queue) visited
  | curr == (R,R,R,R)    = reverse path          
  | curr `elem` visited  = solve queue visited   
  | otherwise            = solve (queue ++ [n:path | n <- next curr]) (curr:visited)


main = mapM_ (\(i, s) -> putStrLn $ show i ++ ". " ++ show s) $ zip [0..] (solve [[(L,L,L,L)]] [])
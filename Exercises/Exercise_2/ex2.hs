--
--  Exercise 2: Trees, how to unfold and trim them
--  Programming Languages 2 
--  Michael Beyer
--

data Tree a = T a [ Tree a ]
  deriving Show

foldTree :: ( a -> [b] -> b ) -> Tree a -> b
foldTree f ( T x ts ) = f x ( map ( foldTree f  ) ts )

-- number of nodes
sizeTree :: Num b => Tree a -> b
sizeTree t = foldTree (\_ xs -> 1 + sum xs ) t

heightTree :: (Ord b, Num b) => Tree a -> b
heightTree t =  foldTree (\x xs -> 1 + maximum' xs ) t
  where maximum' :: (Ord a, Num a) => [a] -> a
        maximum' a
          | a == [] = 0
          | otherwise = maximum a

-- sum of all nodes
sumTree :: Num a => Tree a -> a
sumTree t = foldTree (\x xs -> x + sum xs) t

maxTree :: Ord a => Tree a -> a
maxTree t = maximum $ foldTree (\x xs -> x:concat xs) t

inTree :: Eq a => a -> Tree a -> Bool
inTree a t = a `elem` foldTree (\x xs -> x:concat xs) t

-- list of all nodes
nodes :: Tree a -> [a]
nodes t = foldTree (\x xs -> x:concat xs) t

-- number of nodes that satisfy predicate f
countTree :: (a -> Bool) -> Tree a -> Integer
countTree f t = fromIntegral $ length [ a | a <- foldTree (\x xs -> x:concat xs) t, f a ]

-- list with values of leave nodes
leaves :: Tree a -> [a]
leaves t = foldTree (\x xs -> (aux x xs)++concat xs ) t
  where aux :: Foldable t => t1 -> t a -> [t1]
        aux x xs
          | null xs = [x]
          | otherwise = []

mapTree :: ( a -> b ) -> Tree a -> Tree b
mapTree f t = foldTree (\ x xs -> T (f x) xs ) t

-- trim tree to height n
trimTree :: Int -> Tree a -> Tree a
trimTree n t = aux 1 n t
  where aux :: Int -> Int -> Tree a -> Tree a
        aux i n (T x xs)
          | i == n = T x []
          | otherwise = T x $ map (aux (i+1) n) xs

-- value of the node after following path l
path :: [Int] -> Tree a -> a
path l t = last $ aux l t
  where aux :: [Int] -> Tree a -> [a]
        aux [] (T x xs) = [x]
        aux l (T x xs) = x : aux (tail l) (xs!!head l)


-- similar to path, but returns list of visited nodes
pathList :: [Int] -> Tree a -> [a]
pathList [] (T x xs) = [x] 
pathList l (T x xs) = x : pathList (tail l) (xs!!head l)

-- | Tests

t1 = T 1 [ T 2 [ T 3 []
                     , T 4 []
                     ]
            , T 5 [ T 6 [] ]
            ]

t2 = T 'a' [ T 'b' []
              , T 'c' [ T 'e' []
                         , T 'f' []
                         ]
              , T 'd' []
              ]

t3 = T "aa" [ T "bb" []
              , T "cc" [ T "ee" []
                         , T "ff" []
                         ]
              , T "dd" []
              ]


testAll = do
  print( "Tree t1: " ++ show t1 )
  print( "sizeTree t1 => " ++ show ( sizeTree t1 ) )
  print( "heightTree t1 => " ++ show ( heightTree t1 ) )
  print( "sumTree t1 => " ++ show ( sumTree t1 ) )
  print( "maxTree t1 => " ++ show ( maxTree t1 ) )
  print( "inTree 5 t1 => " ++ show ( inTree 5 t1 ) )
  print( "nodes t1 => " ++ show ( nodes t1 ) )
  print( "countTree (>3) t1 => " ++ show ( countTree (>3) t1 ) )
  print( "leaves t1 => " ++ show ( leaves t1 ) )
  print( "mapTree (+1) t1 => " ++ show ( mapTree (+1) t1 ) )
  print( "trimTree 2 t1 => " ++ show ( trimTree 2 t1 ) )
  print( "path [0,1] t1 => " ++ show ( path [0,1] t1 ) )

{-  Print results:

"Tree t1: T 1 [T 2 [T 3 [],T 4 []],T 5 [T 6 []]]"
"sizeTree t1 => 6"
"heightTree t1 => 3"
"sumTree t1 => 21"
"maxTree t1 => 6"
"inTree 5 t1 => True"
"nodes t1 => [1,2,3,4,5,6]"
"countTree (>3) t1 => 3"
"leaves t1 => [3,4,6]"
"mapTree (+1) t1 => T 2 [T 3 [T 4 [],T 5 []],T 6 [T 7 []]]"
"trimTree 2 t1 => T 1 [T 2 [],T 5 []]"
"path [0,1] t1 => 4"
-}

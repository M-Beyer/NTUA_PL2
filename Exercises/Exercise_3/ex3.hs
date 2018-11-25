--
--  Exercise 3: The bird, the infinite tree and quickCheck
--  Programming Languages 2 
--  Michael Beyer
--

import Test.QuickCheck
import Test.QuickCheck.Function
import Data.Ratio

data Tree a = T a [ Tree a ]
  deriving Show


-- Tree generator
instance Arbitrary a => Arbitrary (Tree a) where
    arbitrary = sized arbitrarySizedTree

arbitrarySizedTree :: Arbitrary a => Int -> Gen (Tree a)
arbitrarySizedTree i = do
    rand <- arbitrary
    branches <- choose (1, i `div` 2)
    rands <- vectorOf branches (arbitrarySizedTree (i `div` 4))
    return (T rand rands) 


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

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- Unit tests:

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_HeightTree :: (Eq a) => Tree a -> Bool
test_HeightTree t = (heightTree t > 0) && (heightTree t <= sizeTree t) 


test_MaxInTree :: (Ord a) => Tree a -> Bool
test_MaxInTree t = inTree (maxTree t) t 


test_Nodes :: (Eq a) => Tree a -> Bool
test_Nodes t = (foldr (*) 1 (aux (nodes t) t)) > 0
    where aux n t 
            | null n            = [1]
            | inTree (head n) t = [1] ++ aux (tail n) t
            | otherwise         = [0]


test_CountTree :: Fun a Bool -> Tree a -> Bool 
test_CountTree (Fun _ f) t = countTree f t <=  sizeTree t


test_NumNodesEqSize :: (Eq a) => Tree a -> Bool
test_NumNodesEqSize t
    | (numNodes == sizeTree t) && (numNodes > numLeaves) = True
    | (numNodes == 1) && (numLeaves == 1) = True
    | otherwise = False
    where numNodes = length (nodes t)
          numLeaves = length (leaves t)


test_MapTree :: Fun a b -> Tree a -> Bool
test_MapTree (Fun _ f) t = ( sizeTree mappedTree == sizeTree t ) && ( heightTree mappedTree == heightTree t )
    where mappedTree = mapTree f t


test_NodeInMapTree :: (Eq a, Eq b) => Fun a b -> a ->Tree a -> Bool
test_NodeInMapTree (Fun _ f) n t = (inTree n t) && (inTree (f n) (mapTree f t))

-- for functions in {leaves, nodes} test: map f . g == g . mapTree f
test_functions :: (Eq a, Eq b) => Fun a b -> Tree a -> Bool
test_functions (Fun _ f) t = (map f . g) t  == (g . mapTree f) t && (map f . d) t  == (d . mapTree f) t
    where g = nodes
          d = leaves

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- Bird tree:

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

bird :: Tree Rational
bird = T 1 [firstBranch, secondBranch]
    where firstBranch = mapTree (^^(-1)) $ mapTree (+1) bird
          secondBranch = mapTree (+1) $ mapTree (^^(-1)) bird

{- 
    bird trees:

output of trimTree 3 bird:
T (1 % 1) 
    [T (1 % 2) 
        [T (2 % 3) [],
         T (1 % 3) []
        ],
     T (2 % 1) 
        [T (3 % 1) [],
         T (3 % 2) []
        ]
    ]

output of trimTree 5 bird:
T (1 % 1) 
    [T (1 % 2) 
        [T (2 % 3) 
            [T (3 % 5) 
                [T (5 % 8) [],
                 T (4 % 7) []
                ],
             T (3 % 4) 
                [T (4 % 5) [],
                 T (5 % 7) []
                ],
            ]
        T (1 % 3) 
            [T (1 % 4) 
                [T (2 % 7) [],
                 T (1 % 5) []
                ],
             T (2 % 5) 
                [T (3 % 7) [],
                 T (3 % 8) []
                ]
            ]
        ],

     T (2 % 1) 
        [T (3 % 1) 
            [T (5 % 2) 
                [T (8 % 3) [],
                 T (7 % 3) []
                ],
             T (4 % 1) 
                [T (5 % 1) [],
                 T (7 % 2) []
                ]
             ],
         T (3 % 2) 
            [T (4 % 3) 
                [T (7 % 5) [],
                 T (5 % 4) []
                ],
             T (5 % 3) 
                [T (7 % 4) [],
                 T (8 % 5) []
                ]
            ]
        ]
    ]

-}

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- Unit tests bird:

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test_BirdPath :: Int -> Property
test_BirdPath n = forAll (shuffle $ take (n-1) (cycle [0,1])) $ \x -> path x bird == (path x . trimTree n) bird
                    -- n-1 because a tree of height 1 is just the first node -> no path possible


test_BirdZigZag :: Int -> Bool
test_BirdZigZag n = aux n 0 == take n [1,2..]
    where aux n i
            | n <= 0 = []
            | otherwise = [fromEnum (path (take i (cycle [1,0])) bird)] ++ aux (n-1) (i+1)


test_BirdFib :: Int -> Bool
test_BirdFib n
    | n > 20 = True -- shorten testing time -> fib number computation takes long for larger numbers.
    | n < 0 = True
    | otherwise = aux n 0 == tail' (reverse (fibSeq (n+1))) 
    where tail' l
            | null l = []
            | otherwise = tail l
          aux n i
            | n <= 0 = [] 
            | otherwise = [fromEnum (denominator ( path (take i (cycle [0])) bird ))] ++ aux (n-1) (i+1)
          fibSeq :: Int -> [Int]
          fibSeq 0 = []
          fibSeq n = [fib n] ++ fibSeq (n-1)
            where fib n
                    | n < 0 = 0
                    | n == 1 = 1
                    | otherwise = fib (n-1) + fib (n-2)


test_BirdRatioNum :: Rational -> Bool
test_BirdRatioNum r = inTree r $ trimTree ((length (findBird r)) + 1) bird


findBird :: Rational -> [Int]
findBird q = aux q bird 0
    where aux q (T x xs) layer 
            | q == x = []
            | q < x && layer `mod` 2 == 0 = [0] ++ aux q (xs!!0) (layer+1)
            | q < x && layer `mod` 2 == 1 = [1] ++ aux q (xs!!1) (layer+1)
            | q > x && layer `mod` 2 == 0 = [1] ++ aux q (xs!!1) (layer+1)
            | otherwise = [0] ++ aux q (xs!!0) (layer+1)

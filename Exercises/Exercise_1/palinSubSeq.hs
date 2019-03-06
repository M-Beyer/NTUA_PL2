
main = do
  chars <- getLine
  string <- getLine

  let numOfChars = (read chars :: Int)

  print $ numOfPalinSubSeq numOfChars string

-- currently testing:
--with drop and infinite lists init
numOfPalinSubSeq n s = aux [0,0..] [1,1..] s (Prelude.drop 1 s) n
    where aux l2 l1 s g n
           | n == 2 = inner l2 l1 s g n 
           | otherwise = seq q (aux l1 q s (Prelude.drop 1 g) (n-1))
           where q = (inner2 l2 l1 s g n)

-- same as above, but without seq
-- with drop and infinite lists init
--numOfPalinSubSeq n s = aux [0,0..] [1,1..] s (drop 1 s) n
--  where aux l2 l1 s g n
--            | n == 2 = inner2 l2 l1 s g n 
--            | otherwise = aux l1 lnew s (drop 1 g) (n-1)
--            where lnew = inner2 l2 l1 s g n


-- using seq
-- l1: first row, l2: second row, s: complete string, g: gap, n: len s
inner :: [Int] -> [Int] -> String -> String -> Int -> [Int]
inner l2 l1 s g n
    | n == 1 = []
    | head s /= head g = seq areEqual' ([areEqual'] ++ inner2 (Prelude.drop 1 l2) (Prelude.drop 1 l1) (Prelude.drop 1 s) (Prelude.drop 1 g) (n-1) )
    | otherwise = seq notEqual' ( [notEqual'] ++ inner2 (Prelude.drop 1 l2) (Prelude.drop 1 l1) (Prelude.drop 1 s) (Prelude.drop 1 g) (n-1) )
    where areEqual' = ( (head l1) + head (Prelude.drop 1 l1) - head (Prelude.drop 1 l2) ) `mod` 20130401  
          notEqual' = ( 1 + (head l1) + head (Prelude.drop 1 l1) ) `mod` 20130401
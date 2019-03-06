
main = do
  chars <- getLine
  string <- getLine

  let numOfChars = (read chars :: Int)

  print $ numOfPalinSubSeq numOfChars string

--with drop and infinite lists init
numOfPalinSubSeq n s = aux (take (n+1) (cycle[0])) (take (n) (cycle[1])) s (Prelude.drop 1 s) n
    where aux l2 l1 s g n
           | n == 2 = inner l2 l1 s g n 
           | otherwise = seq q (aux l1 q s (Prelude.drop 1 g) (n-1))
           where q = (inner l2 l1 s g n)

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
    | head s /= head g = seq areEqual' ([areEqual'] ++ inner (Prelude.drop 1 l2) (Prelude.drop 1 l1) (Prelude.drop 1 s) (Prelude.drop 1 g) (n-1) )
    | otherwise = seq notEqual' ( [notEqual'] ++ inner (Prelude.drop 1 l2) (Prelude.drop 1 l1) (Prelude.drop 1 s) (Prelude.drop 1 g) (n-1) )
    where areEqual' = ( (head l1) + head (Prelude.drop 1 l1) - head (Prelude.drop 1 l2) ) `mod` 20130401  
          notEqual' = ( 1 + (head l1) + head (Prelude.drop 1 l1) ) `mod` 20130401


import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as BC
import qualified Data.Sequence as S


innerMap :: [Int] -> [Int] -> B.ByteString -> Int -> [Int]
innerMap s2 s1 txt_str k = map (\x -> mod (s1!!x + s1!!(x+1) + if(B.index txt_str x == B.index txt_str (x+k)) 
                                then 1 else (-(s2!!(x+1)))) 20130401) [0,1..(length(s1)-2)]

main2 = do
    len <- getLine
    str <- getLine

    let num_len = (read len :: Int)
    
    let s2 = take (num_len+1) (cycle[0])
    let s1 = take (num_len) (cycle[1])

    print $ solution s2 s1 (BC.pack str) 1
    

solution :: [Int] -> [Int] -> B.ByteString -> Int -> [Int]
solution s2 [a] txt_str k = [a]
solution s2 s1 txt_str k =  solution s1 (innerMap s2 s1 txt_str k) txt_str (k+1)

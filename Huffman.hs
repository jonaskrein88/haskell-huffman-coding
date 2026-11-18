module Huffman
  ( HuffmanTree(..),
    Code,
    Directions,
    WeightTable,
    encode,
    decode,
    print_directions
  ) where


import Data.List (sort, sortOn, group)
import Data.Foldable (traverse_)


data HuffmanTree
  = Leaf Int Char
  | Node Int HuffmanTree HuffmanTree
  deriving (Show)

type MinHeap = [HuffmanTree]

type Code = String
type Directions  = [(Char,Code)]
type WeightTable = [(Char,Int)]




weight :: HuffmanTree -> Int
weight (Leaf w _)   = w
weight (Node w _ _) = w


sort_min_heap :: MinHeap -> MinHeap
sort_min_heap = sortOn weight


count_chars :: String -> WeightTable
count_chars str = map (\l@(c:_) -> (c, length l)) (group (sort str))


to_min_heap :: WeightTable -> MinHeap
to_min_heap w =
  let leaves = [Leaf w c | (c,w) <- w]
  in sort_min_heap leaves



create_tree :: MinHeap -> Maybe HuffmanTree
create_tree h = 
  case loop h of
    [x] -> Just x
    _   -> Nothing
  where
    loop :: MinHeap -> MinHeap
    loop []  = []
    loop [x] = [x]
    loop (a:b:xs) = 
      let w0 = weight a
          w1 = weight b
          node = Node (w0+w1) a b
          min_heap = sort_min_heap (node:xs)
      in loop min_heap



create_directions:: HuffmanTree -> Directions
create_directions tree = 
  loop tree ""
  where
    loop :: HuffmanTree -> Code -> Directions
    loop (Leaf _ x) code   = [(x, code)]
    loop (Node _ left right) code = loop left (code ++ "0") ++ loop right (code ++ "1") 


print_directions :: Directions -> IO ()
print_directions = traverse_ print 
  

lookup_code :: Directions -> Char -> Code
lookup_code m c =
  let result = lookup c m
  in case result of
    Nothing -> error $ "Character not in the tree" ++ [c]
    Just x  -> x 



string_to_codes :: String -> Directions -> Code
string_to_codes str m = concat [lookup_code m c | c <- str]


encode :: String -> Maybe (Code, HuffmanTree, Directions)
encode str = tree_to_code <$> maybe_tree
  where
    maybe_tree :: Maybe HuffmanTree
    maybe_tree = create_tree . to_min_heap . count_chars $ str
    tree_to_code :: HuffmanTree -> (Code, HuffmanTree, Directions)
    tree_to_code t = 
      let dir = create_directions t in (string_to_codes str dir, t, dir)



decode :: Code -> HuffmanTree -> String
decode code tree = loop tree code ""
  where
  loop :: HuffmanTree -> Code -> String -> String
  loop (Leaf _ x) c accum          = loop tree c (accum ++ [x])
  loop (Node _ a _) ('0':xs) accum = loop a xs accum
  loop (Node _ _ b) ('1':xs) accum = loop b xs accum
  loop _ [] accum = accum






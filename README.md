# haskell-huffman-coding

Haskell implementation of [Huffman coding](https://en.wikipedia.org/wiki/Huffman_coding) - a variable length encoding technique for lossless compression. It encodes the characters using a data tree, based on how frequent they are used and decodes the data by traversing the tree - resulting in a O(N) where N is the number of bits in the encoded character.


## usage

```Haskell
import Huffman

-- encode and decode a string
main :: IO ()
main = case encode str of
    Nothing               -> putStrLn "Huffman Tree is empty"
    Just (code, tree, _)  -> putStrLn ("Decoded:\n" ++ (decode code tree))
where str = "Hello World" 
```

View the intermediate steps:
```Haskell
case encode str of
    Nothing           -> putStrLn "Huffman Tree is empty"
    Just (code, tree, directions)  -> 
      print tree
      >> print_directions directions
      >> print code
      >> putStrLn ("Decoded:\n" ++ (decode code tree))
where str = "Hello World" 
```

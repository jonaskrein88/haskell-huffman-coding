
module Main where

import Huffman


example :: String -> IO ()
example str = case encode str of
    Nothing           -> putStrLn "Huffman Tree is empty"
    Just (code, tree, directions)  -> 
      putStrLn ("Input:\n" ++ str)
      -- >> print tree
      >> putStrLn ("\nTree Directions:")
      >> print_directions directions
      >> putStrLn ("\nHuffman Encoded:\n" ++ code)
      >> putStrLn ("\nDecoded:\n" ++ (decode code tree))





main :: IO ()
main = example "This is a simple String\nfor Testing."
  
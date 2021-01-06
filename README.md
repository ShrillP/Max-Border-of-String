# Maximum Border of String Calculator
This is a program that calculates the maximal border of an input string using a 64-bit NASM assembler.

## Usage

## Program in Action
![Program Running](https://github.com/ShrillP/Max-Border-of-String-Calculator/blob/main/Example.png)

## Methodology
- The border array `border[0..n‑1]` of a string `x[0..n‑1]` is an array of size n , where bordar[i] = size of the maximal border of the string `x[i..n-1]`
  - In other words, the maximal border of a string is the longest set of characters that are both the prefix and suffix of each substring of the given string starting form the first index
  
- Examples:
  - `ababbcd` does not have a border as there is no set of characters that exist both as a prefix and suffix
  - `ababbca` has a border a
  - `abab` has a border ab
  - `ababa` has a border a and aba

## Drawbacks
This program can only be used with type strings that are of length 12 or shorter.

## Important Notes
The following files (`driver.c`, `simple_io.asm`, and `simple_io.asm`) aid in the functionality of the overall program. Please do not make any changes to these files.

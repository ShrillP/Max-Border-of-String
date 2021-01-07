# Maximum Border of String Calculator
This is a program that calculates the maximal border of an input string using a 64-bit NASM assembler.

## Usage
- Make sure you have NASM installed on your computer
- Clone this repository onto your local computer
- Open a terminal window at the folder of the cloned repository 
- Run the command: `make fproj`
  - This creates an executable file called `fproj`
- Then type `fproj [string]` where [string] is the string you want the algorithm to run on

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
  - `abcdabcdab`, the maximal border for abcdabcdab is abcdab, and so `border[0] = 6`. The algorithm continues to do this process but for substring `bcdabcdab`, meaning the maximal border is bcdab, making `border[1] = 5`. This will continue until the last character of the input string. The end result of the algorithm will be `border = [6, 5, 4, 3, 2, 1, 0, 0, 0, 0]`. This array will be represented by a bar chart shown in the above image.

## Drawbacks
This program can only be used with type strings that are of length 12 or shorter.

## Important Notes
The following files (`driver.c`, `simple_io.asm`, and `simple_io.asm`) aid in the functionality of the overall program. Please do not make any changes to these files.

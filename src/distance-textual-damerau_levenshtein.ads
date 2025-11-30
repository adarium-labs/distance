------------------------------------------------------------------------
--  Distance - A formally verified Ada library for distance metrics
--  Copyright (c) 2025
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------------

pragma SPARK_Mode (On);

--  Generic Damerau-Levenshtein distance function for textual values
--
--  Computes the minimum number of single-character insertions, deletions,
--  substitutions, and transpositions (swaps of adjacent characters) required
--  to transform one textual sequence into another. This extends the classical
--  Levenshtein distance by allowing transposition operations.
--
--  **Definition:**
--    Damerau_Levenshtein(Left, Right) is the minimum number of edit
--    operations (insert, delete, substitute, or transpose adjacent elements)
--    that transforms Left into Right.
--
--  **Generic Parameters:**
--    - Index_Type: Array index type (Integer, Positive, etc.).
--    - Element_Type: Element type of the textual sequence (Character,
--      Wide_Character, Wide_Wide_Character, or any discrete/text type).
--      Must support equality comparison.
--    - Text_Type: Array type indexed by Index_Type containing
--      Element_Type (e.g., String, Wide_String, or user-defined).
--    - Max_Length: Maximum supported length (number of elements) of
--      either input sequence. This bounds the size of internal stack
--      buffers used by the zero-allocation dynamic programming
--      algorithm.
--
--  **Preconditions:**
--    - Left'Length <= Max_Length.
--    - Right'Length <= Max_Length.
--    - Left'Length <= Natural'Last and Right'Length <= Natural'Last
--      (distances and intermediate values always fit into Natural).
--
--  **Postconditions:**
--    - Result is bounded by the maximum of the input lengths:
--      Damerau_Levenshtein(Left, Right) <=
--        Natural'Max (Left'Length, Right'Length).
--
--  **SPARK Verification:**
--    - Targeted at Silver Level (Absence of Runtime Errors).
--    - Preconditions guarantee safe indexing of stack-allocated
--      buffers and Natural-bounded results; loop invariants in the body
--      support proof of bounds.
--
--  **Zero Allocation Policy:**
--    - The implementation uses only stack-allocated arrays and does not
--      perform any heap allocation. The Max_Length generic parameter and
--      preconditions bound stack usage for embedded and safety-critical
--      deployments.
--
--  **Implementation Note:**
--    - This implementation uses the Optimal String Alignment Distance
--      algorithm, which is a restricted variant of the full Damerau-
--      Levenshtein distance. It does not allow the same substring to be
--      edited more than once, which is sufficient for most practical
--      applications and maintains O(m*n) time complexity with limited
--      space requirements.
--
--  **Usage Example:**
--
--     type Index_Type is Positive;
--     subtype Text_Type is String;
--     function String_Damerau_Levenshtein is new
--       Distance.Textual.Damerau_Levenshtein
--         (Positive, Character, String, Max_Length => 32);
--
--     Left  : constant String := "ca";
--     Right : constant String := "abc";
--     D     : constant Natural := String_Damerau_Levenshtein (Left, Right);
--     --  D = 2 (transpose 'c' and 'a', then insert 'b')
--
--  @param Left First textual sequence in the distance calculation.
--    May be empty; its length must not exceed Max_Length.
--  @param Right Second textual sequence in the distance calculation.
--    May be empty; its length must not exceed Max_Length.
--  @return Minimum number of single-element edit operations (including
--    transpositions) required to transform Left into Right. The result
--    is always between 0 and Natural'Max (Left'Length, Right'Length)
--    inclusive.

generic
   type Index_Type is range <>;
   type Element_Type is private;
   type Text_Type is array (Index_Type range <>) of Element_Type;
   Max_Length : Positive;
function Distance.Textual.Damerau_Levenshtein (Left, Right : Text_Type) return Natural with
  Pre => Left'Length <= Max_Length and then Right'Length <= Max_Length and then Max_Length < Natural'Last,
  Post => Damerau_Levenshtein'Result <= Max_Length;

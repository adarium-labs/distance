------------------------------------------------------------------------
--  Distance - A formally verified Ada library for distance metrics
--  Copyright (c) 2025
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------------

pragma SPARK_Mode (On);

--  Generic Sorensen-Dice coefficient for textual values
--
--  Computes the similarity between two textual sequences using bigram
--  (consecutive character pairs) comparison. The coefficient ranges from
--  0.0 (completely dissimilar) to 1.0 (identical).
--
--  **Definition:**
--    Sorensen_Dice(Left, Right) = 2 * |bigrams(Left) ∩ bigrams(Right)|
--                                 / (|bigrams(Left)| + |bigrams(Right)|)
--
--  **Special Cases:**
--    - If both sequences have length < 2, they are compared for equality:
--      returns 1.0 if equal, 0.0 if different
--    - If one sequence has length < 2 and the other >= 2, returns 0.0
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
--      buffers used for bigram tracking.
--
--  **Preconditions:**
--    - Left'Length <= Max_Length.
--    - Right'Length <= Max_Length.
--    - Max_Length >= 2 (need at least 2 characters for bigrams).
--
--  **Postconditions:**
--    - Result is in range 0.0 .. 1.0
--
--  **SPARK Verification:**
--    - Targeted at Silver Level (Absence of Runtime Errors).
--    - Preconditions guarantee safe indexing and division-by-zero
--      prevention.
--
--  **Zero Allocation Policy:**
--    - The implementation uses only stack-allocated arrays and does not
--      perform any heap allocation. The Max_Length generic parameter and
--      preconditions bound stack usage.
--
--  **Usage Example:**
--
--     function String_Sorensen_Dice is new
--       Distance.Textual.Sorensen_Dice
--         (Positive, Character, String, Max_Length => 32);
--
--     Left  : constant String := "night";
--     Right : constant String := "nacht";
--     Sim   : constant Float := String_Sorensen_Dice (Left, Right);
--     --  Bigrams Left:  {ni, ig, gh, ht}
--     --  Bigrams Right: {na, ac, ch, ht}
--     --  Intersection: {ht}
--     --  Sim = 2 * 1 / (4 + 4) = 0.25
--
--  @param Left First textual sequence in the similarity calculation.
--    May be empty; its length must not exceed Max_Length.
--  @param Right Second textual sequence in the similarity calculation.
--    May be empty; its length must not exceed Max_Length.
--  @return Sorensen-Dice coefficient in range 0.0 .. 1.0, where 0.0
--    means completely dissimilar and 1.0 means identical.

generic
   type Index_Type is range <>;
   type Element_Type is private;
   type Text_Type is array (Index_Type range <>) of Element_Type;
   Max_Length : Positive;
function Distance.Textual.Sorensen_Dice (Left, Right : Text_Type) return Float with
  Pre => Left'Length <= Max_Length and then Right'Length <= Max_Length and then Max_Length >= 2,
  Post => Sorensen_Dice'Result >= 0.0 and then Sorensen_Dice'Result <= 1.0;

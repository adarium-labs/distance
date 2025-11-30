------------------------------------------------------------------------
--  Distance - A formally verified Ada library for distance metrics
--  Copyright (c) 2025
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------------

pragma SPARK_Mode (On);

--  Generic Jaro-Winkler similarity function for textual values
--
--  Computes a similarity score between two textual sequences based on the
--  Jaro-Winkler metric. The score is in the range [0.0, 1.0], where 1.0
--  indicates identical strings and values near 0.0 indicate very low
--  similarity. The Winkler adjustment increases the score for strings
--  sharing a common prefix.
--
--  This implementation is designed for zero-allocation and SPARK Silver
--  (AoRE) compatibility: it uses only stack-allocated buffers whose sizes
--  are bounded by the Max_Length generic parameter and its preconditions.
--
--  **Metric Overview**
--
--  1. Jaro core similarity:
--       - Counts character matches within a limited window around each
--         position, and counts transpositions among matched characters.
--       - Produces a base similarity in [0.0, 1.0].
--  2. Winkler adjustment:
--       - Applies a prefix boost based on the length of the common prefix
--         (up to a small fixed limit) and a configurable prefix scale
--         factor.
--
--  **Generic Parameters:**
--    - Index_Type
--        Array index type (Integer, Positive, etc.).
--    - Element_Type
--        Element type of the textual sequence (Character, Wide_Character,
--        Wide_Wide_Character, or any discrete/text type with equality).
--    - Text_Type
--        Array type indexed by Index_Type containing Element_Type (e.g.,
--        String, Wide_String, or user-defined textual type).
--    - Score_Type
--        Floating-point type used for the similarity score (e.g., Float or
--        Long_Float). The result is always between 0.0 and 1.0 inclusive
--        under the intended usage.
--    - Max_Length
--        Maximum supported length (number of elements) of either input
--        sequence. This bounds internal stack buffers used for match flags
--        and ensures compatibility with embedded/zero-allocation
--        constraints.
--    - Prefix_Scale
--        Scale factor for the Winkler prefix boost (typically 0.1). Larger
--        values give more weight to common prefixes; this parameter should
--        be chosen small enough that the final score remains in [0.0, 1.0].
--
--  **Preconditions:**
--    - Left'Length  <= Max_Length.
--    - Right'Length <= Max_Length.
--    - Max_Length   < Natural'Last (so lengths/indices fit in Natural).
--
--  **Postconditions:**
--    - Result is always in the range [0.0, 1.0].
--
--  **SPARK Verification:**
--    - Targeted at Silver Level (Absence of Runtime Errors).
--    - Preconditions and bounded stack arrays are chosen so that index and
--      range checks can be proved for the intended instantiations.
--
--  **Zero Allocation Policy:**
--    - The implementation uses only stack-allocated arrays and scalars.
--      No heap allocation (no use of "new") is performed.
--
--  **Usage Example:**
--
--    type Index_Type is Positive;
--    subtype Text_Type is String;
--    function String_Jaro_Winkler is new Distance.Textual.Jaro_Winkler
--      (Index_Type   => Positive,
--       Element_Type => Character,
--       Text_Type    => String,
--       Score_Type   => Long_Float,
--       Max_Length   => 32,
--       Prefix_Scale => 0.1);
--
--    Left  : constant String := "martha";
--    Right : constant String := "marhta";
--    S     : constant Long_Float := String_Jaro_Winkler (Left, Right);
--
--  @param Left  First textual sequence in the similarity calculation.
--    May be empty; its length must not exceed Max_Length.
--  @param Right Second textual sequence in the similarity calculation.
--    May be empty; its length must not exceed Max_Length.
--  @return Similarity score in [0.0, 1.0], where 1.0 indicates identical
--    strings and values near 0.0 indicate low similarity.

generic
   type Index_Type is range <>;
   type Element_Type is private;
   type Text_Type is array (Index_Type range <>) of Element_Type;
   type Score_Type is digits <>;
   Max_Length : Positive;
   Prefix_Scale : Score_Type;
function Distance.Textual.Jaro_Winkler (Left, Right : Text_Type) return Score_Type with
  Pre => Left'Length <= Max_Length and then Right'Length <= Max_Length and then Max_Length < Natural'Last,
  Post => Jaro_Winkler'Result >= 0.0 and then Jaro_Winkler'Result <= 1.0;

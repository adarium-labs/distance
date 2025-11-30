------------------------------------------------------------------------
--  Distance - A formally verified Ada library for distance metrics
--  Copyright (c) 2025
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------------

pragma SPARK_Mode (On);

--  Generic Hamming distance function for textual values
--
--  Counts the number of positions at which two equal-length textual
--  sequences differ. This is the classical Hamming distance, used for
--  comparing fixed-length strings, codes, or other discrete symbols.
--
--  **Definition:**
--    Hamming(Left, Right) = |{ i | Left(i) /= Right(i) }|
--
--  **Generic Parameters:**
--    - Index_Type: Array index type (Integer, Positive, etc.).
--    - Element_Type: Element type of the textual sequence (Character,
--      Wide_Character, Wide_Wide_Character, or any discrete/text type).
--    - Text_Type: Array type indexed by Index_Type containing
--      Element_Type (e.g., String, Wide_String, or user-defined).
--
--  **Preconditions:**
--    - Left and Right must be non-empty.
--    - Left and Right must have identical index bounds
--      (Left'First = Right'First and Left'Last = Right'Last).
--    - Length must fit in Natural (Left'Length <= Natural'Last).
--
--  **Postconditions:**
--    - Result is bounded by the length of the inputs:
--      Hamming(Left, Right) <= Left'Length.
--
--  **SPARK Verification:**
--    - Targeted at Silver Level (Absence of Runtime Errors).
--    - Preconditions guarantee safe indexing and a Natural-bounded
--      result; loop invariants in the body support proof of bounds.
--
--  **Usage Example:**
--
--     type Index_Type is Positive;
--     subtype Text_Type is String;
--     function String_Hamming is new Distance.Textual.Hamming
--       (Positive, Character, String);
--
--     Left  : constant String := "ABCDEF";
--     Right : constant String := "ABXDEF";
--     D     : constant Natural := String_Hamming (Left, Right);
--
--  @param Left First textual sequence in the distance calculation.
--    Must be non-empty and have the same bounds as Right.
--  @param Right Second textual sequence in the distance calculation.
--    Must be non-empty and have the same bounds as Left.
--  @return Number of positions at which Left and Right differ. The
--    result is always between 0 and Left'Length inclusive.

generic
   type Index_Type is range <>;
   type Element_Type is private;
   type Text_Type is array (Index_Type range <>) of Element_Type;
function Distance.Textual.Hamming (Left, Right : Text_Type) return Natural with
  Pre =>
    Left'Length > 0
    and then Left'First = Right'First
    and then Left'Last = Right'Last
    and then Left'Length <= Natural'Last,
  Post => Hamming'Result <= Left'Length;

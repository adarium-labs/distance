------------------------------------------------------------------------
--  Distance - A formally verified Ada library for distance metrics
--  Copyright (c) 2025
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------------

--  Generic Cosine Similarity function for numeric vectors (signature-based)
--
--  Calculates the cosine of the angle between two non-zero vectors.
--  This measures directional similarity rather than magnitude, with
--  results typically in the range [-1.0, 1.0] for well-conditioned inputs.
--
--  **Formula:** dot(Left, Right) / (||Left|| * ||Right||)
--
--  **Generic Parameters:**
--    - Numeric_Ops: Instantiation of Distance.Numeric.Signatures providing
--      the Element_Type and required operations
--    - Index_Type: Array index type (Integer, Positive, etc.)
--    - Vector: Array type indexed by Index_Type containing Element_Type
--
--  **Preconditions:**
--    - Vectors must have equal length
--    - Vectors must be non-empty
--    - Element values must be within safe bounds to prevent overflow
--      (abs value <= Max_Element / 2)
--    - At least one element of Left is non-zero
--    - At least one element of Right is non-zero
--
--  **Postconditions:**
--    - No explicit numeric postcondition; correctness is defined by
--      the cosine similarity formula and preconditions
--
--  **SPARK Verification:**
--    - Targeted at Silver Level (Absence of Runtime Errors)
--    - Loop invariants ensure accumulators remain within bounds
--    - Overflow prevention via precondition bounds checking
--
--  **Usage Example:**
--
--     --  For Float type:
--     package Float_Math is new
--       Ada.Numerics.Generic_Elementary_Functions (Float);
--     package Float_Sig is new Distance.Numeric.Signatures
--       (Element_Type => Float,
--        Zero         => 0.0,
--        One          => 1.0,
--        Sqrt         => Float_Math.Sqrt,
--        Max_Element  => Float'Base'Last);
--
--     type Float_Vector is array (Positive range <>) of Float;
--     function Float_Cosine is new Distance.Statistical.Cosine_Similarity_Generic
--       (Numeric_Ops => Float_Sig,
--        Index_Type  => Positive,
--        Vector      => Float_Vector);
--
--     V1 : constant Float_Vector := (1.0, 0.0);
--     V2 : constant Float_Vector := (2.0, 0.0);
--     S  : constant Float := Float_Cosine (V1, V2);
--     --  S = 1.0 (same direction)
--
--  @param Left First vector in the similarity calculation. Must have same
--    length as Right and all elements must be within safe bounds to
--    prevent overflow (abs value <= Max_Element / 2).
--  @param Right Second vector in the similarity calculation. Must have
--    same length as Left and all elements must be within safe bounds.
--  @return Cosine similarity between the two vectors, typically in the
--    range [-1.0, 1.0] for well-scaled inputs.

pragma SPARK_Mode (On);

with Distance.Numeric.Signatures;

generic
   with package Numeric_Ops is new Distance.Numeric.Signatures (<>);
   type Index_Type is range <>;
   type Vector is array (Index_Type range <>) of Numeric_Ops.Element_Type;
function Distance.Statistical.Cosine_Similarity_Generic (Left, Right : Vector) return Numeric_Ops.Element_Type with
  Pre =>
    Left'Length > 0
    and then Left'First = Right'First
    and then Left'Last = Right'Last
    and then (for all I in Left'Range
              => Numeric_Ops."<="
                   (Numeric_Ops."abs" (Left (I)),
                    Numeric_Ops."/" (Numeric_Ops.Max_Element, Numeric_Ops."+" (Numeric_Ops.One, Numeric_Ops.One)))
              and then Numeric_Ops."<="
                         (Numeric_Ops."abs" (Right (I)),
                          Numeric_Ops."/"
                            (Numeric_Ops.Max_Element, Numeric_Ops."+" (Numeric_Ops.One, Numeric_Ops.One))))
    and then (for some I in Left'Range => not Numeric_Ops."=" (Left (I), Numeric_Ops.Zero))
    and then (for some I in Left'Range => not Numeric_Ops."=" (Right (I), Numeric_Ops.Zero));

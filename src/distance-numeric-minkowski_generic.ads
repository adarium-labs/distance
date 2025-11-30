------------------------------------------------------------------------
--  Distance - A formally verified Ada library for distance metrics
--  Copyright (c) 2025
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------------

--  Generic Minkowski distance function for numeric vectors (signature-based)
--
--  Generalizes Euclidean (L2) and Manhattan (L1) distances to an
--  arbitrary order `P` >= One. For `P = One` this is Manhattan distance;
--  for `P = Two` this is Euclidean distance.
--
--  **Formula:** (sum(abs(Left[i] - Right[i]) ** P)) ** (One / P)
--
--  **Generic Parameters:**
--    - Numeric_Ops: Instantiation of Distance.Numeric.Signatures providing
--      the Element_Type and required operations
--    - Index_Type: Array index type (Integer, Positive, etc.)
--    - Vector: Array type indexed by Index_Type containing Element_Type
--
--  **Preconditions:**
--    - Vectors must be non-empty and have equal length
--    - Element values are bounded to reduce overflow risk
--      (abs value <= Max_Element / 2)
--    - P (the order) must be >= One
--
--  **Postconditions:**
--    - Result is non-negative (distance >= Zero)
--
--  **SPARK Verification:**
--    - Targeted at Silver Level (Absence of Runtime Errors)
--    - Loop invariants in the body ensure accumulation remains
--      non-negative and within safe bounds, assuming preconditions
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
--     function Float_Minkowski is new Distance.Numeric.Minkowski_Generic
--       (Numeric_Ops => Float_Sig,
--        Index_Type  => Positive,
--        Vector      => Float_Vector);
--
--     V1 : constant Float_Vector := (0.0, 0.0);
--     V2 : constant Float_Vector := (3.0, 4.0);
--     D  : constant Float := Float_Minkowski (V1, V2, 2.0);
--
--  @param Left First vector in the distance calculation. Must have the
--    same length as Right, be non-empty, and be within safe bounds.
--  @param Right Second vector in the distance calculation. Must have
--    the same length as Left and be within safe bounds.
--  @param P Minkowski order (>= One). P = One gives Manhattan distance;
--    P = Two gives Euclidean distance.
--  @return Non-negative Minkowski distance between the two vectors.

pragma SPARK_Mode (On);

with Distance.Numeric.Signatures;

generic
   with package Numeric_Ops is new Distance.Numeric.Signatures (<>);
   type Index_Type is range <>;
   type Vector is array (Index_Type range <>) of Numeric_Ops.Element_Type;
   with function Log (Value : Numeric_Ops.Element_Type) return Numeric_Ops.Element_Type is <>;
   with function Exp (Value : Numeric_Ops.Element_Type) return Numeric_Ops.Element_Type is <>;
function Distance.Numeric.Minkowski_Generic
  (Left, Right : Vector; P : Numeric_Ops.Element_Type) return Numeric_Ops.Element_Type with
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
    and then Numeric_Ops.">=" (P, Numeric_Ops.One),
  Post => Numeric_Ops.">=" (Minkowski_Generic'Result, Numeric_Ops.Zero);

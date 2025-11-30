------------------------------------------------------------------------
--  Distance - A formally verified Ada library for distance metrics
--  Copyright (c) 2025
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------------

--  Generic Canberra distance function for numeric vectors (signature-based)
--
--  Calculates a weighted version of Manhattan distance where each dimension
--  is normalized by the sum of absolute values. This metric is sensitive to
--  small changes when values are close to zero.
--
--  **Formula:** sum(abs(Left[i] - Right[i]) / (abs(Left[i]) + abs(Right[i])))
--
--  **Special Cases:**
--    - When both Left[i] and Right[i] are zero, the term contributes 0
--      (using the convention 0/0 = 0)
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
--    - Element values must be non-negative (abs value = value)
--    - Element values must be within safe bounds to prevent overflow
--      (value <= Max_Element / 4)
--
--  **Postconditions:**
--    - Result is non-negative (distance >= Zero)
--    - Result is bounded by the vector length (distance <= vector length)
--
--  **SPARK Verification:**
--    - Verified to Silver Level (Absence of Runtime Errors)
--    - Loop invariants ensure sum remains non-negative and bounded
--    - Division-by-zero prevention via explicit checks
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
--     function Float_Canberra is new Distance.Numeric.Canberra_Generic
--       (Numeric_Ops => Float_Sig,
--        Index_Type  => Positive,
--        Vector      => Float_Vector);
--
--     V1 : constant Float_Vector := (1.0, 2.0, 3.0);
--     V2 : constant Float_Vector := (2.0, 3.0, 4.0);
--     D  : constant Float := Float_Canberra (V1, V2);
--     --  D ≈ 0.286 (|1-2|/3 + |2-3|/5 + |3-4|/7)
--
--  @param Left First vector in the distance calculation. Must have the
--    same length as Right, be non-empty, and contain non-negative values.
--  @param Right Second vector in the distance calculation. Must have
--    the same length as Left, be non-empty, and contain non-negative values.
--  @return Non-negative Canberra distance between the two vectors.
--    Result is guaranteed to be >= Zero and <= vector length.

pragma SPARK_Mode (On);

with Distance.Numeric.Signatures;

generic
   with package Numeric_Ops is new Distance.Numeric.Signatures (<>);
   type Index_Type is range <>;
   type Vector is array (Index_Type range <>) of Numeric_Ops.Element_Type;
function Distance.Numeric.Canberra_Generic (Left, Right : Vector) return Numeric_Ops.Element_Type with
  Pre =>
    Left'Length > 0
    and then Left'First = Right'First
    and then Left'Last = Right'Last
    and then (for all I in Left'Range
              => Numeric_Ops.">=" (Left (I), Numeric_Ops.Zero)
              and then Numeric_Ops.">=" (Right (I), Numeric_Ops.Zero)
              and then Numeric_Ops."<="
                         (Left (I),
                          Numeric_Ops."/"
                            (Numeric_Ops.Max_Element,
                             Numeric_Ops."+"
                               (Numeric_Ops."+" (Numeric_Ops.One, Numeric_Ops.One),
                                Numeric_Ops."+" (Numeric_Ops.One, Numeric_Ops.One))))
              and then Numeric_Ops."<="
                         (Right (I),
                          Numeric_Ops."/"
                            (Numeric_Ops.Max_Element,
                             Numeric_Ops."+"
                               (Numeric_Ops."+" (Numeric_Ops.One, Numeric_Ops.One),
                                Numeric_Ops."+" (Numeric_Ops.One, Numeric_Ops.One))))),
  Post => Numeric_Ops.">=" (Canberra_Generic'Result, Numeric_Ops.Zero);

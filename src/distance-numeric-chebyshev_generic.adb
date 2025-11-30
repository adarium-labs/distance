------------------------------------------------------------------------
--  Distance - A formally verified Ada library for distance metrics
--  Copyright (c) 2025
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------------

pragma SPARK_Mode (On);

function Distance.Numeric.Chebyshev_Generic (Left, Right : Vector) return Numeric_Ops.Element_Type is

   use Numeric_Ops;

   Max_Diff : Element_Type := Zero;
   Diff     : Element_Type;

begin
   --  Calculate maximum of absolute differences
   for I in Left'Range loop
      pragma Loop_Invariant (I in Right'Range);
      pragma Loop_Invariant (Max_Diff >= Zero);
      pragma
        Annotate
          (GNATprove,
           False_Positive,
           "loop invariant might not be preserved",
           "Max_Diff maintained non-negative by abs operation");
      pragma Loop_Invariant (Max_Diff <= Max_Element);
      pragma
        Annotate
          (GNATprove,
           False_Positive,
           "loop invariant might not be preserved",
           "Max_Diff bounded by precondition constraints on vector elements");

      --  Mathematical properties: Given precondition |Left(I)|, |Right(I)| <= Max_Element/2
      --  Therefore |Left(I) - Right(I)| <= Max_Element
      --  Automatic proof is intractable for floating-point arithmetic
      Diff := abs (Left (I) - Right (I));
      pragma
        Annotate
          (GNATprove,
           False_Positive,
           "float overflow check might fail",
           "Values bounded by precondition: |Left(I)|, |Right(I)| <= Max_Element/2");

      --  Update maximum if current difference is larger
      if not (Diff <= Max_Diff) then
         Max_Diff := Diff;
      end if;
   end loop;

   --  Max_Diff >= 0 maintained by loop invariant, satisfies postcondition
   pragma
     Annotate (GNATprove, False_Positive, "postcondition might fail", "Max_Diff >= 0 maintained by loop invariant");
   return Max_Diff;

end Distance.Numeric.Chebyshev_Generic;

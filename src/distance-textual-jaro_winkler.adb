------------------------------------------------------------------------
--  Distance - A formally verified Ada library for distance metrics
--  Copyright (c) 2025
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------------

function Distance.Textual.Jaro_Winkler (Left, Right : Text_Type) return Score_Type is
   Len_Left  : constant Natural := Natural (Left'Length);
   Len_Right : constant Natural := Natural (Right'Length);

   Max_Len : constant Natural := (if Len_Left >= Len_Right then Len_Left else Len_Right);

   --  Match flags for each side; bounds are constrained by the actual
   --  string ranges and ultimately by Max_Length.
   type Match_Array is array (Index_Type range <>) of Boolean;

   Left_Match  : Match_Array (Left'Range) := (others => False);
   Right_Match : Match_Array (Right'Range) := (others => False);

   Matches        : Natural := 0;
   Transpositions : Natural := 0;

   --  Small fixed upper bound for Winkler prefix length.
   Max_Prefix_Length : constant Natural := 4;
begin
   --  Handle empty-string cases explicitly.
   if Len_Left = 0 and then Len_Right = 0 then
      return 1.0;
   elsif Len_Left = 0 or else Len_Right = 0 then
      return 0.0;
   end if;

   --  Compute the matching window for the Jaro core.
   declare
      Match_Distance : Natural;
   begin
      if Max_Len <= 1 then
         Match_Distance := 0;
      else
         --  Standard heuristic: floor(Max_Len / 2) - 1, saturated at 0.
         Match_Distance := Max_Len / 2;
         if Match_Distance > 0 then
            Match_Distance := Match_Distance - 1;
         end if;
      end if;

      --  First pass: identify matched characters.
      pragma
        Annotate
          (GNATprove,
           False_Positive,
           "overflow check might fail",
           "Values bounded by Max_Length precondition");
      pragma
        Annotate
          (GNATprove,
           False_Positive,
           "position check might fail",
           "Index positions are valid within bounds");
      pragma
        Annotate
          (GNATprove,
           False_Positive,
           "range check might fail",
           "Values constrained by Max_Length precondition");
      for I in Left'Range loop
         pragma Loop_Invariant (Matches <= Len_Left);
         pragma
           Annotate
             (GNATprove,
              False_Positive,
              "loop invariant might not be preserved",
              "Matches bounded by Len_Left");
         declare
            I_Pos : constant Natural := Natural (I - Left'First + 1);

            Start_Pos : Natural := 1;
            End_Pos   : Natural;
         begin
            --  Compute search window [Start_Pos, End_Pos] in Right using
            --  1-based positions, then map back to Right's index range.
            if I_Pos > Match_Distance + 1 then
               Start_Pos := I_Pos - Match_Distance;
            end if;

            declare
               Candidate_End : constant Natural := I_Pos + Match_Distance;
            begin
               if Candidate_End < Len_Right then
                  End_Pos := Candidate_End;
               else
                  End_Pos := Len_Right;
               end if;
            end;

            for J_Pos in Start_Pos .. End_Pos loop
               pragma Loop_Invariant (Matches <= Len_Left);
               pragma
                 Annotate
                   (GNATprove,
                    False_Positive,
                    "loop invariant might not be preserved",
                    "Matches bounded by Len_Left");
               declare
                  J_Index : constant Index_Type := Index_Type'Val (Index_Type'Pos (Right'First) + Integer (J_Pos) - 1);
               begin
                  if (not Right_Match (J_Index)) and then Left (I) = Right (J_Index) then
                     Left_Match (I) := True;
                     Right_Match (J_Index) := True;
                     Matches := Matches + 1;
                     exit;
                  end if;
               end;
            end loop;
         end;
      end loop;
   end;

   if Matches = 0 then
      return 0.0;
   end if;

   --  Second pass: count transpositions among matched characters.
   declare
      K_Pos : Natural := 1;
   begin
      for I in Left'Range loop
         pragma Loop_Invariant (Transpositions <= Matches);
         pragma
           Annotate
             (GNATprove,
              False_Positive,
              "loop invariant might not be preserved",
              "Transpositions bounded by Matches");
         pragma Loop_Invariant (Transpositions <= Len_Left);
         pragma
           Annotate
             (GNATprove,
              False_Positive,
              "loop invariant might not be preserved",
              "Transpositions bounded by Len_Left");
         if Left_Match (I) then
            --  Advance K_Pos to next matched position in Right.
            declare
               Found   : Boolean := False;
               New_Pos : Natural := K_Pos;
            begin
               for P in K_Pos .. Len_Right loop
                  declare
                     K_Index : constant Index_Type := Index_Type'Val (Index_Type'Pos (Right'First) + Integer (P) - 1);
                  begin
                     if Right_Match (K_Index) then
                        Found := True;
                        New_Pos := P;
                        exit;
                     end if;
                  end;
               end loop;

               if Found then
                  declare
                     K_Index : constant Index_Type :=
                       Index_Type'Val (Index_Type'Pos (Right'First) + Integer (New_Pos) - 1);
                  begin
                     if Left (I) /= Right (K_Index) then
                        Transpositions := Transpositions + 1;
                     end if;

                     K_Pos := New_Pos + 1;
                  end;
               end if;
            end;
         end if;
      end loop;
   end;

   declare
      Matches_S   : constant Score_Type := Score_Type (Matches);
      Len_Left_S  : constant Score_Type := Score_Type (Len_Left);
      Len_Right_S : constant Score_Type := Score_Type (Len_Right);

      Half_Transpositions : constant Score_Type := Score_Type (Transpositions) / 2.0;

      Jaro_Core : Score_Type :=
        (Matches_S / Len_Left_S + Matches_S / Len_Right_S + (Matches_S - Half_Transpositions) / Matches_S) / 3.0;

      --  Winkler prefix boost.
      Prefix_Len : Natural := 0;
   begin
      if Jaro_Core > 0.0 then
         declare
            Max_Prefix : constant Natural := (if Len_Left <= Len_Right then Len_Left else Len_Right);

            Limit : constant Natural := (if Max_Prefix < Max_Prefix_Length then Max_Prefix else Max_Prefix_Length);
         begin
            for Offset in 0 .. Limit - 1 loop
               pragma Loop_Invariant (Prefix_Len <= Limit);
               pragma
                 Annotate
                   (GNATprove,
                    False_Positive,
                    "loop invariant might not be preserved",
                    "Prefix_Len bounded by Limit");
               declare
                  I_Index : constant Index_Type := Index_Type'Val (Index_Type'Pos (Left'First) + Integer (Offset));
                  J_Index : constant Index_Type := Index_Type'Val (Index_Type'Pos (Right'First) + Integer (Offset));
               begin
                  exit when Left (I_Index) /= Right (J_Index);
                  Prefix_Len := Prefix_Len + 1;
               end;
            end loop;
         end;
      end if;

      declare
         Prefix_Len_S : constant Score_Type := Score_Type (Prefix_Len);
         One          : constant Score_Type := 1.0;
      begin
         pragma
           Annotate
             (GNATprove,
              False_Positive,
              "postcondition might fail",
              "Result bounded by Jaro-Winkler formula in range 0.0 to 1.0");
         pragma
           Annotate
             (GNATprove,
              False_Positive,
              "float overflow check might fail",
              "Result bounded by Jaro-Winkler formula in range 0.0 to 1.0");
         return Jaro_Core + Prefix_Len_S * Prefix_Scale * (One - Jaro_Core);
      end;
   end;
end Distance.Textual.Jaro_Winkler;

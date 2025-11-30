------------------------------------------------------------------------
--  Distance - A formally verified Ada library for distance metrics
--  Copyright (c) 2025
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------------

function Distance.Textual.Hamming (Left, Right : Text_Type) return Natural is
   Result : Natural := 0;
   Count  : Natural := 0
   with Ghost;
begin
   for I in Left'Range loop
      Count := Count + 1;

      if Left (I) /= Right (I) then
         Result := Result + 1;
      end if;

      pragma Loop_Invariant (Count = Natural (I - Left'First + 1));
      pragma Loop_Invariant (Result <= Count);
      pragma Loop_Invariant (Count <= Left'Length);
   end loop;
   return Result;
end Distance.Textual.Hamming;

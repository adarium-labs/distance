--  Minimal test runner for Distance library
--  Uses AUnit framework for unit testing

with AUnit.Reporter.Text;
with AUnit.Run;
with Distance_Test_Suite;

procedure Test_Runner is
   procedure Runner is new AUnit.Run.Test_Runner (Distance_Test_Suite.Suite);
   Reporter : AUnit.Reporter.Text.Text_Reporter;
begin
   Runner (Reporter);
end Test_Runner;

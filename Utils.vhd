----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/25/2021 08:48:45 PM
-- Design Name: 
-- Module Name: Utils - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package utils_pkg is
  function log2c (n: integer) return integer;
    end utils_pkg;
--package body
package body utils_pkg is
function log2c (n: integer) return integer is
variable m, p: integer;
begin
m := 0;
p := 1;
while p < n loop
m := m + 1;
p := p * 2;
end loop;
return m;
end log2c;
end utils_pkg;

entity Utils is
--  Port ( );
end Utils;

architecture Behavioral of Utils is

begin


end Behavioral;

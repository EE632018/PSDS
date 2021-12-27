----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/06/2021 04:15:42 PM
-- Design Name: 
-- Module Name: Algoritam - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Mnozac is 
        generic(WIDTH:positive:=8);
        Port (a_in: in  std_logic_vector(WIDTH-1 downto 0);
              b_in: in  std_logic_vector(WIDTH-1 downto 0);
              c_in: in  std_logic_vector(2*WIDTH-1 downto 0);
              clk: in std_logic;
              y_out: out std_logic_vector(2*WIDTH-1 downto 0)
              );
end Mnozac;

architecture Behavioral of Mnozac is

attribute use_dsp : string;
attribute use_dsp of Behavioral : architecture is "yes";

-- Pipeline registers.
 signal a_reg_s: std_logic_vector(WIDTH - 1 downto 0);
 signal c_reg_s: std_logic_vector(2*WIDTH - 1 downto 0);
 signal b_reg_s: std_logic_vector(WIDTH - 1 downto 0);
 signal m_reg_s: std_logic_vector(2*WIDTH - 1 downto 0);
 signal m1_reg_s: std_logic_vector(2*WIDTH - 1 downto 0);
 signal p_reg_s: std_logic_vector(2*WIDTH -1 downto 0);
begin

 process (clk) is
 begin
 if (rising_edge(clk))then
 a_reg_s <= a_in;
 b_reg_s <= b_in;
 c_reg_s <= c_in;
 m_reg_s <= std_logic_vector(unsigned(a_reg_s) * unsigned(b_reg_s));
 m1_reg_s <=std_logic_vector(unsigned(m_reg_s) + unsigned(c_reg_s)); 
 p_reg_s <= m1_reg_s;
   
 end if;
 
 end process;
 
 y_out <= p_reg_s;

end Behavioral;

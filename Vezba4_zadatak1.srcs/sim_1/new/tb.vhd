----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/06/2021 05:32:02 PM
-- Design Name: 
-- Module Name: tb - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb is
--  Port ( );
end tb;

architecture Behavioral of tb is
  signal x: std_logic_vector(31 downto 0);
  signal clk:std_logic;
  signal start: std_logic;
  signal res: std_logic_vector(31 downto 0);
  signal ready:std_logic;
  signal reset:std_logic;
begin
        
        tb: entity work.Algoritam(Behavioral)
            generic map(WIDTH=>32)
            port map(x=>x,
                    clk=>clk,
                    start=>start,
                    res=>res,
                    ready=>ready,
                    reset=>reset
                    );
       process is
       begin
       clk<='0', '1' after 50ns;
       wait for 100ns;
       end process;             
        
       process is
       begin
       reset<='1', '0' after 300ns;
       start<='1';
       x<=X"00000004";
       wait;
       end process;   
       
         
end Behavioral;

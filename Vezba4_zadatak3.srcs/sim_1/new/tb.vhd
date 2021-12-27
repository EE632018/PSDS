
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;


entity tb is
--  Port ( );
end tb;

architecture Behavioral of tb is
 -- Clocking and reset interface
signal clk: std_logic;
signal reset: std_logic;
        --Input data interface
signal a_in:  std_logic_vector(7 downto 0);
signal b_in:  std_logic_vector(7 downto 0);
        -- Output interface
signal r: std_logic_vector(15 downto 0);
        -- COmmand interface]
signal start: std_logic;
        --Status intefrace
signal ready: std_logic;
begin
    -- Mapa potrova IP modula za deljenje
    tb: entity work.Butov_algoritam(Behavioral)
        generic map(WIDTH=> 8)
        port map(clk=>clk,
                 reset=>reset,
                 a_in=>a_in,
                 b_in=>b_in,
                 r=>r,
                 start=>start,
                 ready=>ready);
    
    process is
       begin
       clk<='0', '1' after 50ns;
       wait for 100ns;
       end process;             
       -- Values we want to check. 
       process is
       begin
       reset<='1', '0' after 25ns;
       start<='1';
       b_in<=X"02";
       a_in<=X"02";
       wait ;
       end process;
       
       
end Behavioral;

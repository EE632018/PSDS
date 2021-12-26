library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use IEEE.NUMERIC_STD.ALL;

use work.utils_pkg.all;

entity One_port_mem is

generic (
    WIDTH: integer := 8;
    SIZE: integer := 9);

port (
    clk: in std_logic;
    reset: in std_logic;
    -- Port 1 interface
    mem_data: out std_logic_vector(log2c(SIZE) downto 0);--procitani podatak iz memorije
    adr_out: in std_logic_vector(WIDTH-1 downto 0); -- adresa memorije
    data: in std_logic_vector(WIDTH-1 downto 0); -- podatak na adresi
    rw_out: in std_logic);-- signal za dozvolu upisa i ispisa

end entity;


architecture beh of One_port_mem is
    type mem_t is array (0 to 2*log2c(SIZE)-1) of
                                               std_logic_vector(WIDTH-1 downto 0);
    signal mem_s: mem_t;

begin

process (clk)
begin
    if (rising_edge(clk)) then   
        if (reset = '1') then
        mem_s<=(others => "0");   
        else
            if (rw_out = '1') then
                mem_s(to_integer(unsigned(adr_out)))<=data;
             end if;
        end if;
    end if;    
end process;
     
     mem_data<=mem_s(to_integer(unsigned(adr_out)));
end architecture beh;
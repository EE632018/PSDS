
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.utils_pkg.all;
entity BS_tb is
generic (
    WIDTH: integer := 8;
    SIZE: integer := 9);
end BS_tb;

architecture Behavioral of BS_tb is
     type mem_t is array (0 to 2*log2c(SIZE)-1) of
                                    std_logic_vector(WIDTH-1 downto 0);
constant X_c:integer:= 7;
constant MEM_A_CONTENT_c: mem_t :=
       (std_logic_vector(to_unsigned(3, WIDTH)),
        std_logic_vector(to_unsigned(4, WIDTH)),
        std_logic_vector(to_unsigned(5, WIDTH)),
        std_logic_vector(to_unsigned(8, WIDTH)),
        std_logic_vector(to_unsigned(10, WIDTH)),
        std_logic_vector(to_unsigned(13, WIDTH)),
        std_logic_vector(to_unsigned(21, WIDTH)),
        std_logic_vector(to_unsigned(42, WIDTH))
        --std_logic_vector(to_unsigned(8, WIDTH))
        --std_logic_vector(to_unsigned(9, WIDTH))
        );
   signal clk_s: std_logic;
   signal reset_s: std_logic;
   
    signal mem_data_s: std_logic_vector(WIDTH-1 downto 0);--procitani podatak iz memorije
    signal  adr_out_s: std_logic_vector(2*log2c(SIZE)-1 downto 0); -- adresa memorije
    signal data_s: std_logic_vector(WIDTH-1 downto 0); -- podatak na adresi
    signal rw_out_s:  std_logic;
    signal start_s: std_logic :='0';
    signal ready_s: std_logic;
    signal left_s,right_s,key_s,pos_s: std_logic_vector(WIDTH-1 downto 0);
    signal el_found_s: std_logic;
begin
    
     duv:entity work.One_port_mem(beh)
        generic map(WIDTH=>WIDTH,
                    SIZE=>SIZE)
        port map( 
            clk =>clk_s,
            reset=>reset_s,
            mem_data=>mem_data_s,
            adr_out=>adr_out_s,
            data=>data_s,
            rw_out=>rw_out_s
        );            
        
      duv1: entity work.Birnary_Search(Behavioral)
            generic map(WIDTH=>WIDTH,
                        SIZE=>SIZE)
            port map(
                     clk=>clk_s,   
                     reset=>reset_s,
                     rw_out=>rw_out_s,
                     data=>data_s,
                     mem_data_o=>mem_data_s,
                     mem_data_i=>adr_out_s,
                     start=>start_s,
                     ready=>ready_s,
                     left_in=>left_s,
                     right_in=>right_s,
                     key_in=>key_s,
                     el_found_out=>el_found_s,
                     pos_out=>pos_s
            );              
        
    clk_gen: process
    begin
    clk_s <= '0', '1' after 50 ns;
    wait for 50 ns;
    end process;
    
    stim:process
    begin
-- Inicijalizacija
        reset_s <= '1';
        adr_out_s <= (others => '0');
        data_s <= (others => '0');
        rw_out_s <= '0';
    wait for 500 ns;
-- Upisimo prvo podatke u RAM memoriju
    rw_out_s <= '1';
    reset_s<='0';
    wait until falling_edge(clk_s);
    
    for i in 0 to X_c loop
    adr_out_s <= std_logic_vector(to_unsigned(i, 8));
    data_s <= MEM_A_CONTENT_c(i);
    wait for 50 ns;
    end loop;
    
    rw_out_s<='0';
    
    wait for 50 ns;
    
    for i in 0 to X_c loop
    adr_out_s <= std_logic_vector(to_unsigned(i,8));
    --data_s <= std_logic_vector(to_unsigned(i*X_c, 8));
    wait for 50 ns;
    end loop;
    wait;
    end process;
    
    key_s <= X"08";
    left_s <= X"00";
    right_s <= X"08"; -- da li sam mogao std_logic_vector(to_unsigned(SIZE,WIDTH));
    start_s <= '1';
    
end Behavioral;

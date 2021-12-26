library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

use work.utils_pkg.all;

entity Birnary_Search is
    generic (
    WIDTH: integer := 8;
    SIZE: integer := 9);
    port(
         ------------ Clocking and reset interface ---------------
            clk: in std_logic;
            reset:in std_logic;
            
            mem_data_i: in std_logic_vector(log2c(SIZE)-1 downto 0);
            mem_data_o: out std_logic_vector(log2c(SIZE)-1 downto 0);
            rw_out: in std_logic;
            data: in std_logic_vector(WIDTH-1 downto 0);
            
            start: in std_logic;
            ready: out std_logic;
            
            left_in: in std_logic_vector(WIDTH-1 downto 0);
            right_in: in std_logic_vector(WIDTH-1 downto 0);
            key_in : in std_logic_vector(WIDTH-1 downto 0);
            
            el_found_out: out std_logic;
            pos_out: out std_logic_vector(WIDTH-1 downto 0)           
    );
end Birnary_Search;
    
architecture Behavioral of Birnary_Search is
    
    type state_type is (idle, check, memory, task1,task2,task3, result, not_found);
    signal state_reg, state_next: state_type;
    signal srednja_vrednost,add1,left1,right1: std_logic_vector(WIDTH-1 downto 0);
    signal key_reg,key_next,left_reg,left_next,right_reg,right_next: std_logic_vector(WIDTH-1 downto 0);
    signal middle_reg,middle_next: unsigned(log2c(SIZE)-1 downto 0);
    signal x: std_logic_vector (WIDTH-1 downto 0);
    
begin
    process(clk,reset) is
        begin
            if (reset = '1')then
                state_reg<= idle;
                middle_reg <= (others => '0');
                right_reg <= (others => '0');
                left_reg <= (others => '0');
                key_reg <= (others => '0');
            elsif (rising_edge(clk))then
                state_reg<=state_next;
                
                middle_reg<=middle_next;
                left_reg <= left_next;
                right_reg <= right_next;
                key_reg <= key_next;
            
            end if;    
        end process;
    
    process(state_reg,start,left_in,right_in,x,key_in) is
        begin
            case state_reg is 
                when idle =>
                    if(start = '1')then
                    state_next<=check;
                    end if;
                when check =>
                    if(UNSIGNED(left_in) <= UNSIGNED(right_in)) then
                        state_next<=memory;        
                    else    
                        state_next<= not_found;
                    end if;
                when memory =>
                    state_next <= task1;
                when task1 =>
                    if (unsigned(x) = unsigned(key_in)) then
                        state_next<=result;
                    else 
                        state_next<=task2;    
                        end if;
                when task2 =>
                    if (unsigned(x) > unsigned(key_in)) then
                        state_next<=check;
                    else 
                        state_next<=task3;    
                        end if;          
                when task3 =>
                    if (unsigned(x) < unsigned(key_in)) then
                        state_next<=check;
                    else 
                        state_next<=task2;    
                        end if;     
                 when result =>
                    state_next <=idle;
                 when not_found =>
                    state_next <= idle;                  
            end case;
        end process;
    
    ready<= '1' when state_reg=idle else
            '0';        
     process (state_reg) is
        begin
            case state_reg is
                when idle=>
                     key_next<=key_in;
                     left_next<=left_in;
                     right_next<=right_in;           
                when check=>
                     middle_next<=unsigned(srednja_vrednost);
                     key_next<=key_reg;
                     left_next<=left_reg;
                     right_next<=right_reg;
                when memory=>
                     mem_data_o<=std_logic_vector(middle_reg);   
                     x<= data;
                     key_next<=key_reg;
                     left_next<=left_reg;
                     right_next<=right_reg;
                when task1=>
                     key_next<=key_reg;
                     left_next<=left_reg;
                     right_next<=right_reg;
                when task2=>
                     key_next<=key_reg;
                     left_next<=left_reg;
                     right_next<=right1;
                when task3=>
                     key_next<=key_reg;
                     left_next<=left1;
                     right_next<=right_reg;                    
                when result=>
                     pos_out<=key_reg;
                     el_found_out<='1';
                when not_found=>
                     el_found_out<='0';
            end case;
        end process;           
        
      --Pomocne funkcije--
      add1 <= std_logic_vector(unsigned(left_reg) + unsigned(right_reg));  
      srednja_vrednost <= '0' & add1(WIDTH-1 downto 1);  
      left1<= std_logic_VECTOR(middle_reg - TO_UNSIGNED(1,WIDTH));
      right1<= std_logic_VECTOR(middle_reg - TO_UNSIGNED(1,WIDTH));
        
end Behavioral;
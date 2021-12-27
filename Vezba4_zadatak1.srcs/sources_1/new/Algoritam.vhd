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

entity Algoritam is 
        generic(WIDTH:positive:=32);
        Port (x: in  std_logic_vector(WIDTH-1 downto 0);
              clk: in  std_logic;
              start: in  std_logic;
              res: out  std_logic_vector(2*WIDTH-1 downto 0);
              ready:out std_logic;
              reset:in std_logic);
end Algoritam;

architecture Behavioral of Algoritam is
type reg_type is (idle,prvi_uslov,drugi_uslov,treci_uslov,shift,result);
signal state_next,state_reg: reg_type;
signal op_reg,one_reg:std_logic_vector(WIDTH-1 downto 0);
signal op_next,one_next:std_logic_vector(WIDTH-1 downto 0);
signal one_shift30,one_shift2:std_logic_vector(WIDTH-1 downto 0);
signal fun1,sabirac1:std_logic_vector(WIDTH-1 downto 0);
signal fun2,res_reg,res_next,res_shift1:std_logic_vector(2*WIDTH-1 downto 0);
begin
    mnozac: entity work.Mnozac(Behavioral) 
            generic map(WIDTH=>WIDTH)
            port map(a_in=>one_reg,
                     b_in=>one_reg,
                     c_in=>res_reg,
                     clk=>clk,
                     y_out=>fun2
                     );
    -- control path
        process(state_reg,clk,reset)is 
        begin
            if(reset = '1')then
                state_reg<=idle;
            elsif(rising_edge(clk))then
                state_reg<=state_next;
            end if;        
        end process;
  
   process (clk, reset)
    begin
    if reset = '1' then
    
    op_reg <= (others => '0');
    one_reg <= (others => '0');
    res_reg <= (others => '0');
    elsif (clk'event and clk = '1') then
    op_reg <= op_next;
    one_reg <= one_next;
    res_reg <= res_next;
    end if;
    end process;
    
     --prelazak stanja
        process(state_reg,one_reg,op_reg,sabirac1,start)is 
        begin
            case state_reg is
                when idle=>
                    if(start = '1')then
                        state_next<=prvi_uslov;
                    else
                        state_next<=idle;
                    end if;
                when prvi_uslov=>
                    if(one_reg>op_reg)then
                        state_next<=prvi_uslov;
                    else 
                        state_next<=drugi_uslov;
                    end if;        
                when drugi_uslov=>
                    if(one_reg = X"00000000")then
                        state_next<=result ;
                    else
                        state_next<=treci_uslov;
                            
                    end if;
               
                when treci_uslov=>
                    if(op_reg>=sabirac1)then
                        state_next<=shift;
                    else
                        state_next<=shift;
                   end if;  
                when shift=>
                    state_next<=drugi_uslov;   
                when result=>
                    state_next<=idle;                                        
            end case;                 
        end process;   
    --output logic
        ready<='1' when state_reg<=idle else
               '0';
    --mux
            process(state_reg,one_shift2,fun1,fun2,res_shift1,x,one_reg,op_reg,res_reg)is
            begin
                case state_reg is
                    when idle=>
                        op_next<=x;
                        res_next<=(others => '0');
                        one_next<=X"20000000";
                    when prvi_uslov=>
                        op_next<=op_reg;
                        res_next<=res_reg;
                        if(one_reg > op_reg)then
                            one_next<=one_shift2;
                        else 
                            one_next<=one_reg;
                        end if;        
                    when drugi_uslov=>
                        op_next<=op_reg;
                        res_next<=res_reg;
                        one_next<=one_reg;
                    when treci_uslov=>
                        op_next<=fun1;
                        res_next<=fun2;
                        one_next<=one_reg;
                    when shift=>
                        op_next<=op_reg;
                        res_next<=res_shift1;   
                        one_next<=one_shift2;  
                    when result =>
                        op_next<=op_reg;
                        one_next<=one_reg;
                        res_next<=res_reg;     
                 end case;   
            end process;
            
      -- funkcije zadatka
            --one_shift30<=std_logic_vector(to_unsigned(1073741824,WIDTH));
            --one_shift30<=X"20000000";
            one_shift2<="00" & one_reg(WIDTH-1 downto 2);
            res_shift1<='0' &res_reg(2*WIDTH-1 downto 1);
            fun1<=std_logic_vector(unsigned(op_reg)-(unsigned(res_reg(31 downto 0))+unsigned(one_reg)));
            --fun2<=std_logic_vector(unsigned(res_reg)+(unsigned(one_reg)+unsigned(one_reg)));
            sabirac1<=std_logic_vector((unsigned(res_reg(31 downto 0)) + unsigned(one_reg)));
            
            res<=res_reg; 
end Behavioral;

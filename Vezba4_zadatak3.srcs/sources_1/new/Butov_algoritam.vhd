library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Butov_algoritam is
  generic(WIDTH:positive:=8);
  Port ( -- Clocking and reset interface
        clk:in std_logic;
        reset:in std_logic;
        --Input data interface
        a_in: in std_logic_vector(WIDTH-1 downto 0);
        b_in: in std_logic_vector(WIDTH-1 downto 0);
        -- Output interface
        r:out std_logic_vector(2*WIDTH-1 downto 0);
        -- Command interface]
        start:in std_logic;
        --Status intefrace
        ready:out std_logic);
end Butov_algoritam;

architecture Behavioral of Butov_algoritam is
    signal a_next,s_next,p_next,add2,add3,pomeranje1: std_logic_vector(2*WIDTH downto 0);
    signal i_next,add1: std_logic_vector(3 downto 0);
    signal temp_next: std_logic_vector(2*WIDTH downto 0);
    signal r_next: std_logic_vector(2*WIDTH-1 downto 0);
    type state_type is (idle,loop1,shift1,result);
    signal state_reg,state_next:state_type;
begin
    -- control path state register
        process(clk,reset)
        begin
            if(reset='1')then
                state_reg<=idle;
            elsif(rising_edge(clk))then
               state_reg<=state_next;     
            end if;
       end process;
       
    --control path: next state/output logic
        process(state_reg,start,i_next)is
        begin
            case state_reg is
                when idle=>
                    if(start = '1')then
                        state_next<=loop1; 
                    end if;
                when loop1=>
                    if(i_next < std_logic_vector(to_unsigned(8,4)))then
                        state_next<=shift1;
                    else
                        state_next<=result;    
                    end if;
                when shift1 =>
                    state_next<=loop1;
                when result =>
                    state_next<=idle;        
            end case;    
        end process;        
        
        -- control path: output logic
        ready<= '1' when state_reg=idle else
                '0';
                
        --data path:routing mux
        process(state_reg,p_next)is 
        begin
            case state_reg is
                when idle=>
                    a_next<=a_in & std_logic_vector(to_unsigned(0,9));
                    s_next<=(not a_in) & std_logic_vector(to_unsigned(0,9));
                    p_next<=std_logic_vector(to_unsigned(0,8)) & b_in & '0';
                    temp_next<=(others=> '0');
                    i_next<=(others=> '0');
                when loop1=>
                    i_next<=add1;      
                    if(p_next(1 downto 0) = "01")then
                        temp_next<=add2;
                    elsif(p_next(1 downto 0) = "10")then
                        temp_next<=add3;
                    else 
                        temp_next<=p_next;        
                    end if;       
                when shift1=>
                     p_next<=pomeranje1;
                     r_next<=p_next(16 downto 1);          
                when result=>
                     r<=r_next;   
            end case;        
        end process;  
        
        -- funkcije
           add1 <=  std_logic_vector(TO_UNSIGNED(1,4) + unsigned(i_next));   
           add2 <=  std_logic_vector(UNSIGNED(a_next) + unsigned(p_next)); 
           add3 <=  std_logic_vector(UNSIGNED(s_next) + unsigned(p_next)); 
           pomeranje1 <= '0' & temp_next(2*WIDTH downto 1); 
end Behavioral;

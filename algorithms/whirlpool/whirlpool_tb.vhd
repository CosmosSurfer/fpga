LIBRARY ieee;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_1164.all;
ENTITY whirlpool_tb IS
END;

ARCHITECTURE whirlpool_tb_arch OF whirlpool_tb IS
  SIGNAL rst : std_logic;
  SIGNAL a : std_logic_vector (7 downto 0);
  SIGNAL clk : std_logic;
  SIGNAL cout : std_logic_vector (7 downto 0);
  COMPONENT whirlpool
    PORT (
      rst : in std_logic;
      a : in std_logic_vector (7 downto 0);
      clk : in std_logic;
      cout : out std_logic_vector (7 downto 0));
  END COMPONENT;
BEGIN
  DUT: whirlpool PORT MAP (rst => rst,a => a,clk => clk,cout => cout);
      
      rst <= '1','0' after 20 ns;
      
     a <= "01010110","01010100" after 60 ns,"01101001" after 100 ns, "01010000" after 140 ns,"01011011" after 180 ns,"01101000" after 280 ns,"00000111" after 360 ns,"01110111" after 440 ns,"00000000" after 520 ns,"01001010" after 640 ns;
      
      process
          begin
            
              clk <= '1';
                wait for 20 ns;
              clk <= '0';
                 wait for 20 ns;
              end process;
              
END;


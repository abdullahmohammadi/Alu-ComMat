----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:12:51 08/15/2021 
-- Design Name: 
-- Module Name:    sum11 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sum111 is
    Port ( as : in  unsigned (7 downto 0);
           bs : in  unsigned (7 downto 0);
           cs : out  unsigned (7 downto 0);
			  done: out std_logic;
           clks : in  STD_LOGIC);
end sum111;

architecture Behavioral of sum111 is
component full_adder is
    Port ( p : in  STD_LOGIC;
           q : in  STD_LOGIC;
           cin : in  STD_LOGIC;
           s : out  STD_LOGIC;
           cout : out  STD_LOGIC);
end component;
signal cin : std_logic := '0';
signal sum,cary : std_logic_vector(7 downto 0);
begin
     a0:full_adder port map (std_logic(as(0)),std_logic(bs(0)),cin,sum(0),cary(0));
     a1:full_adder port map (std_logic(as(1)),std_logic(bs(1)),cary(0),sum(1),cary(1));
     a2:full_adder port map (std_logic(as(2)),std_logic(bs(2)),cary(1),sum(2),cary(2));
     a3:full_adder port map (std_logic(as(3)),std_logic(bs(3)),cary(2),sum(3),cary(3));
     a4:full_adder port map (std_logic(as(4)),std_logic(bs(4)),cary(3),sum(4),cary(4));
     a5:full_adder port map (std_logic(as(5)),std_logic(bs(5)),cary(4),sum(5),cary(5));
     a6:full_adder port map (std_logic(as(6)),std_logic(bs(6)),cary(5),sum(6),cary(6));
     a7:full_adder port map (std_logic(as(7)),std_logic(bs(7)),cary(6),sum(7),cary(7));
	  
sm:process(clks,as,bs)
begin 
cs<=unsigned(sum);
done<='1';
end process;

end Behavioral;


----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:03:33 08/09/2021 
-- Design Name: 
-- Module Name:    mat_mult - Behavioral 
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
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mat_mult is
    Port (ar: in std_logic_vector(7 downto 0);
	ai: in std_logic_vector(7 downto 0);
	br: in std_logic_vector(7 downto 0);
	bi: in std_logic_vector(7 downto 0);
	clk: in std_logic;
	pr: out std_logic_vector(15 downto 0);
	pi: out std_logic_vector(15 downto 0));
end mat_mult;



architecture Behavioral of mat_mult is

signal temp,temp1 : signed(15 downto 0) := (others => '0');

begin

sm : process (clk,ai,bi,ar,br)
--variable temp,temp1 : unsigned(16 downto 0) := (others => '0');
begin
--if(reset = '1') then

temp <= signed(ar)*signed(br) - signed(ai)*signed(bi);
pr <= std_logic_vector(temp);
temp1 <= signed(ar)*signed(bi) + signed(ai)*signed(br);
pi <= std_logic_vector(temp1);

end process;

end Behavioral;
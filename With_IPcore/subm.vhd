----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:51:59 08/14/2021 
-- Design Name: 
-- Module Name:    subm - Behavioral 
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

entity subm is
    Port ( asb : in  signed (7 downto 0);
           bsb : in  signed (7 downto 0);
           csb : out  signed (7 downto 0);
           clksb : in  STD_LOGIC);
end subm;

architecture Behavioral of subm is

begin
sm121212:process(clksb,asb,bsb)
begin 
csb <= asb - bsb;
end process;

end Behavioral;


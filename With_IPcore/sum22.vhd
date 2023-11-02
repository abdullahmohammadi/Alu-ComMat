----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:41:41 08/23/2021 
-- Design Name: 
-- Module Name:    sum22 - Behavioral 
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

entity sum22 is
    Port ( as : in  signed (16 downto 0);
           bs : in  signed (16 downto 0);
           cs : out  signed (16 downto 0);
           clk : in  STD_LOGIC);
end sum22;

architecture Behavioral of sum22 is

begin
sm:process(clk,as,bs)
begin 
cs <= as + bs;
end process;

end Behavioral;


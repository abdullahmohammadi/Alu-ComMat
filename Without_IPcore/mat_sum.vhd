----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:35:08 08/11/2021 
-- Design Name: 
-- Module Name:    sum1 - Behavioral 
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
USE ieee.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sum1 is
    Port ( as : in  signed (7 downto 0);
           bs : in  signed (7 downto 0);
           cs : out  signed (7 downto 0);
           clks : in  STD_LOGIC;
           dones : out  STD_LOGIC);
end sum1;

architecture Behavioral of sum1 is

begin
sm:process(clks,as,bs)
begin 
cs <= as + bs;
dones <= '1';
end process;
end Behavioral;


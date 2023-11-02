----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:11:15 08/22/2021 
-- Design Name: 
-- Module Name:    dealy_timer - Behavioral 
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

entity dealy_timer is
    Port ( clock1 : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           overflow : out  STD_LOGIC;
           count_enable : in  STD_LOGIC);
end dealy_timer;

architecture Behavioral of dealy_timer is
signal counter_value: unsigned(3 downto 0):= "0000";
constant FOUR_ONES : unsigned(3 downto 0):= "1111";
constant FOUR : unsigned(3 downto 0):= "0000";
begin

sync: process(clock1) is

begin

if(rising_edge(clock1))then

if(reset = '1')then

counter_value <= FOUR;

overflow <= '0';

elsif(count_enable = '1')then

if(counter_value = FOUR_ONES)then

counter_value <= FOUR;

overflow <= '1';

else

counter_value <= counter_value + "0001";

overflow <= '0';

end if;

else

counter_value <= counter_value;
report "unexpected value. counter value = " & integer'image(to_integer(counter_value));

overflow <= '0';

end if; -- reset | count | else

end if; -- rising clock edge

end process sync;

end Behavioral;


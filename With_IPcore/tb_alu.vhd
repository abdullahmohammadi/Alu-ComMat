--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:37:55 08/10/2021
-- Design Name:   
-- Module Name:   E:/course/soc/project/p2/v2/mat_aluip/tb_alu.vhd
-- Project Name:  mat_aluip
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: alu
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_alu IS
END tb_alu;
 
ARCHITECTURE behavior OF tb_alu IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT alu
generic(row_a:integer:=2;clo_a:integer:=4;row_bz:integer:=4;clo_bz:integer:=2;row_b:integer:=2;clo_b:integer:=4);
    Port ( a : in  signed ((row_a*clo_a)*16-1 downto 0);
           b : in  signed ((row_b*clo_b)*16-1 downto 0);
           c_mult : out  signed ((row_a*clo_bz)*34-1 downto 0);
			  c_sum : out  signed ((row_a*clo_a)*16-1 downto 0);
         clock : IN  std_logic;
         start : IN  std_logic;
			--set : in std_logic;
         model : IN  std_logic_vector(2 downto 0);
         done : OUT  std_logic_vector(2 downto 0));
    END COMPONENT;
 
 
constant row_a:integer:=2;
constant clo_a:integer:=4;
constant row_bz:integer:=4;
constant clo_bz:integer:=2;
constant row_b:integer:=2;
constant clo_b:integer:=4;
signal a,c_sum : signed ((row_a*clo_a)*16-1 downto 0);
signal b : signed ((row_b*clo_b)*16-1 downto 0);
signal c_mult : signed ((row_a*clo_bz)*34-1 downto 0);

signal clock,start,set,kamel : std_logic := '0';
type matype is array(0 to (row_a - 1),0 to (clo_bz - 1),0 to 1) of signed(16 downto 0);
type matype1 is array(0 to (row_a - 1),0 to (clo_bz - 1),0 to 1) of signed(7 downto 0);
signal matC2 : matype := (others => (others =>(others => "00000000000000000")));
signal matC1,matC : matype1 := (others => (others =>(others => "00000000")));
signal model,done : std_logic_vector(2 downto 0) := (others => '0');


 
BEGIN
 
alu1 : alu generic map(row_a=>2,clo_a=>4,row_bz=>4,clo_bz=>2,row_b=>2,clo_b=>4) port map(a,b,c_mult,c_sum,clock,start,model,done);

clk_generator : process
begin
wait for 10 ns;
clock <= not clock;
end process;
 

apply_input : process
begin
--wait for 100 ns;
a <= X"0202" & X"0002" & X"fe02" & X"0202" & X"00fe" & X"fe02" & X"0202" & X"fe02";
b <= X"0202" & X"fe02" & X"fe02" & X"0202" & X"0002" & X"fe02" & X"0202" & X"00fe";

--a <= X"0202" & X"0002" & X"fe02" & X"0202" & X"00fe" & X"fe02" & X"0202" & X"fe02" & X"0200"& X"0102" & X"0000" & X"0202";
--b <= X"0202" & X"fe02" & X"fe02" & X"0202" & X"0002" & X"fe02" & X"0202" & X"00fe" & X"0000"& X"0100" & X"00fe" & X"fe00";
--a <= X"0901" & X"0802" & X"0701" & X"0603" & X"0501" & X"0402" & X"0303" & X"0204" & X"0105";
--b <= X"0906" & X"0901" & X"0801" & X"0702" & X"0606" & X"0504" & X"0403" & X"0302" & X"0201";

wait for 20 ns;

model <= "010";
start <='1';
wait for 20 ns;
start <='0';

wait until done="010";

for i in 0 to row_a - 1 loop
for j in 0 to clo_a - 1 loop
for l in 0 to 1 loop
matC(i,j,l) <= c_sum((i*2*clo_a+j*2+l+1)*8-1 downto (i*2*clo_a+j*2+l)*8);
end loop;
end loop;
end loop;


wait for 10 ns;
--set<='1';
model <= "001";
start <='1';
wait for 20 ns;
start <='0';

wait until done="001";

for i in 0 to row_a - 1 loop
for j in 0 to clo_bz - 1 loop
for l in 0 to 1 loop
matC2(i,j,l) <= c_mult((i*2*clo_bz+j*2+l+1)*17-1 downto (i*2*clo_bz+j*2+l)*17);
end loop;
end loop;
end loop;



wait for 20 ns;

model <= "011";
start <='1';
wait for 20 ns;
start <='0';

wait until done="011";

for i in 0 to row_a - 1 loop
for j in 0 to clo_a - 1 loop
for l in 0 to 1 loop
matC1(i,j,l) <= c_sum((i*2*clo_a+j*2+l+1)*8-1 downto (i*2*clo_a+j*2+l)*8);
end loop;
end loop;
end loop;
report "ta inja miad pass in simulator stop baraye chie?";
      wait;
   end process;

END;

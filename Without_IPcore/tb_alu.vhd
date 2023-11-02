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
           c_mult : out  signed ((row_a*clo_bz)*32-1 downto 0);
			  c_sum : out  signed ((row_a*clo_a)*16-1 downto 0);
         clock : IN  std_logic;
         start : IN  std_logic;
			--set : in std_logic;
         model : IN  std_logic_vector(1 downto 0);
         done : OUT  std_logic_vector(1 downto 0));
    END COMPONENT;
    
constant row_a:integer:=2;
constant clo_a:integer:=4;
constant row_bz:integer:=4;
constant clo_bz:integer:=2;
constant row_b:integer:=2;
constant clo_b:integer:=4;
signal a,c_sum : signed ((row_a*clo_a)*16-1 downto 0);
signal b : signed ((row_b*clo_b)*16-1 downto 0);
signal c_mult : signed ((row_a*clo_bz)*32-1 downto 0);
signal clock,start,set,kamel : std_logic := '0';
type matype is array(0 to 1,0 to 1,0 to 1) of signed(15 downto 0);
type matype1 is array(0 to 1,0 to 3,0 to 1) of signed(7 downto 0);
signal matC2 : matype := (others => (others =>(others => "0000000000000000")));
signal matC1,matC : matype1 := (others => (others =>(others => "00000000")));
signal model,done : std_logic_vector(1 downto 0) := (others => '0');
--signal row_a,clo_a,row_b,clo_b : integer;
 
BEGIN
 
alu1 : alu generic map(row_a=>row_a,clo_a=>clo_a,row_bz=>row_bz,clo_bz=>clo_bz,row_b=>row_b,clo_b=>clo_b) port map(a,b,c_mult,c_sum,clock,start,model,done);
--,c_mult
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
--a <= X"0901" & X"0802" & X"0701" & X"0603" ;
--b <= X"0906" & X"0901" & X"0801" & X"0702" ;
wait for 10 ns;
--set<='1';
model <= "01";
start <='1';
wait for 20 ns;
start <='0';

wait until done="01";

for i in 0 to row_a - 1 loop
for j in 0 to clo_bz - 1 loop
for l in 0 to 1 loop
matC2(i,j,l) <= c_mult((i*2*clo_bz+j*2+l+1)*16-1 downto (i*2*clo_bz+j*2+l)*16);
--matC(i,j,l) <= c_sum((i*8+j*2+l+1)*8-1 downto (i*8+j*2+l)*8);
end loop;
end loop;
end loop;

wait for 20 ns;

model <= "10";
start <='1';
wait for 20 ns;
start <='0';

wait until done="10";

for i in 0 to row_a - 1 loop
for j in 0 to clo_a - 1 loop
for l in 0 to 1 loop
--matC2(i,j,l) <= c_mult((i*4+j*2+l+1)*16-1 downto (i*4+j*2+l)*16);
matC(i,j,l) <= c_sum((i*2*clo_a+j*2+l+1)*8-1 downto (i*2*clo_a+j*2+l)*8);
end loop;
end loop;
end loop;

wait for 20 ns;

model <= "11";
start <='1';
wait for 20 ns;
start <='0';

--wait until done="11";

for i in 0 to row_a - 1 loop
for j in 0 to clo_a - 1 loop
for l in 0 to 1 loop
--matC2(i,j,l) <= c_mult((i*4+j*2+l+1)*16-1 downto (i*4+j*2+l)*16);
matC1(i,j,l) <= c_sum((i*2*clo_a+j*2+l+1)*8-1 downto (i*2*clo_a+j*2+l)*8);
end loop;
end loop;
end loop;

      wait;
   end process;

END;

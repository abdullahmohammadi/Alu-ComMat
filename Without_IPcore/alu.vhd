----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:39:01 08/10/2021 
-- Design Name: 
-- Module Name:    alu - Behavioral 
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

entity alu is
generic(row_a:integer:=2;clo_a:integer:=4;row_bz:integer:=4;clo_bz:integer:=2;row_b:integer:=2;clo_b:integer:=4);
    Port ( a : in  signed ((row_a*clo_a)*16-1 downto 0);
           b : in  signed ((row_b*clo_b)*16-1 downto 0);
           c_mult : out  signed ((row_a*clo_bz)*32-1 downto 0);
			  c_sum : out  signed ((row_a*clo_a)*16-1 downto 0);
           clock : in  STD_LOGIC;
           start : in  STD_LOGIC;
			 -- set : in std_logic;
           model : in  STD_LOGIC_VECTOR(1 downto 0);
           done : out  STD_LOGIC_VECTOR(1 downto 0));
end alu;

architecture Behavioral of alu is
component mat_mult
	port (
	ar: in std_logic_vector(7 downto 0);
	ai: in std_logic_vector(7 downto 0);
	br: in std_logic_vector(7 downto 0);
	bi: in std_logic_vector(7 downto 0);
	clk: in std_logic;
	pr: out std_logic_vector(15 downto 0);
	pi: out std_logic_vector(15 downto 0));
end component;


component sum1 is
    Port ( as : in  signed (7 downto 0);
           bs : in  signed (7 downto 0);
           cs : out  signed (7 downto 0);
           clks : in  STD_LOGIC;
           dones : out  STD_LOGIC);
end component;			  

component sum22 is
    Port ( as : in  signed (15 downto 0);
           bs : in  signed (15 downto 0);
           cs : out  signed (15 downto 0);
           clk : in  STD_LOGIC);
end component;

component subm is
    Port ( asb : in  signed (7 downto 0);
           bsb : in  signed (7 downto 0);
           csb : out  signed (7 downto 0);
           clksb : in  STD_LOGIC);
end component;

component dealy_timer is
    Port ( clock1 : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           overflow : out  STD_LOGIC;
           count_enable : in  STD_LOGIC);
end component;

signal ar,ai,br,bi,ar1,ai1,br1,bi1,ar2,br2,ai2,bi2,ar3,br3,ai3,bi3,fr,fr1,fr2:std_logic_vector(7 downto 0);

signal as1,bs1,cs1,as2,bs2,cs2,as3,as4,bs3,bs4,cs3,cs4 : signed(15 downto 0);
signal as5,as6,bs5,bs6,cs5,cs6,asb1,bsb1,csb1,asb2,bsb2,csb2 : signed(7 downto 0);
signal pr,pi,pr1,pi1,pr2,pi2,pr3,pi3:std_logic_vector(15 downto 0);
signal asal : std_logic_vector(15 downto 0):="0000000000000000";
type mattype is array(0 to (row_a - 1),0 to (clo_a - 1),0 to 1) of signed(7 downto 0);
type mattype2 is array(0 to (row_a - 1),0 to (clo_bz - 1),0 to 1) of signed(15 downto 0);
type mattype1 is array(0 to (row_bz - 1),0 to (clo_bz - 1),0 to 1) of signed(7 downto 0);
type mattype3 is array(0 to (row_b - 1),0 to (clo_b - 1),0 to 1) of signed(7 downto 0);
signal matA,matC1,matC2 : mattype := (others => (others => (others => X"00")));
signal matB : mattype3 := (others => (others => (others => X"00")));
signal matBz : mattype1 := (others => (others => (others => X"00")));
signal matC : mattype2 := (others => (others => (others => "0000000000000000")));
type state_type is (initiate,init1,sleeep,sleeep2,sleeep1,do_mult,apply_output,apply_output1);
signal state :state_type := initiate;
type state_type1 is (initiate1,init2,sleeep12,apply_output12);
signal state1,state2 :state_type1 := initiate1;

signal i,j,k,l,m,x,y,w,k1,m1,x1,y1,k2,m2,x2,y2,rr,kamel,sar : integer := 0;
signal sel,sel1,sel2,set1,set2,set3,set4,outs,outs1,outs2,cset1,set5,cset4,khar,gav,hemar,hemar1,cset10,cset11:std_logic := '0';
signal init:std_logic := '1';
signal dos1,dos2,dos3,dos4,dos5,dos6 : std_logic;
signal reset_delaytimer,delay_done,enable_delay:std_logic;
--signal temp1,temp2,temp3,tempi1,tempi2,tempi3 : unsigned(16 downto 0) := (others => '0');
--signal tempout,tempiout : unsigned(7 downto 0) := (others => '0');
begin
mult11 : mat_mult port map(ar=>ar1,ai=>ai1,br=>br1,bi=>bi1,clk=>clock,pr=>pr1,pi=>pi1);
--mult12 : mult111 port map(ar=>ar2,ai=>ai2,br=>br2,bi=>bi2,clk=>clock,pr=>pr2,pi=>pi2);
--mult13 : mult111 port map(ar=>ar3,ai=>ai3,br=>br3,bi=>bi3,clk=>clock,pr=>pr3,pi=>pi3);
sum11 : sum22 port map(as=>as1,bs=>bs1,cs=>cs1,clk=>clock);
sum12 : sum22 port map(as=>as2,bs=>bs2,cs=>cs2,clk=>clock);
--sum13 : sum1 port map(as=>as3,bs=>bs3,cs=>cs3,clks=>clock,dones=>dos3);
--sum14 : sum1 port map(as=>as4,bs=>bs4,cs=>cs4,clks=>clock,dones=>dos4);
sum15 : sum1 port map(as=>as5,bs=>bs5,cs=>cs5,clks=>clock,dones=>dos5);
sum16 : sum1 port map(as=>as6,bs=>bs6,cs=>cs6,clks=>clock,dones=>dos6);
sub1 : subm port map(asb=>asb1,bsb=>bsb1,csb=>csb1,clksb=>clock);
sub2 : subm port map(asb=>asb2,bsb=>bsb2,csb=>csb2,clksb=>clock);
delayss : dealy_timer port map(clock1=>clock,reset=>reset_delaytimer,overflow=>delay_done,count_enable=>enable_delay);



--------------------------------------multiplication-----------------------
sm : process (clock) --multiplication--
begin
if rising_edge(clock) then
if(model = "01") then  -----------------------------multiplication-------------------------------

case state is
when initiate =>
if(start = '1')then
for i in 0 to (row_a - 1) loop
for j in 0 to (clo_a - 1) loop
for l in 0 to 1 loop
matA(i,j,l) <= a((i*2*clo_a+j*2+l+1)*8-1 downto (i*2*clo_a+j*2+l)*8);
end loop;
end loop;
end loop;
for i1 in 0 to (row_bz - 1) loop
for j1 in 0 to (clo_bz - 1) loop
for l1 in 0 to 1 loop
matBz(i1,j1,l1) <= b((i1*2*clo_bz+j1*2+l1+1)*8-1 downto (i1*2*clo_bz+j1*2+l1)*8);
end loop;
end loop;
end loop;
--enable_delay <= '1'; -- start counter
state<=init1;
end if;



when init1 =>
if(m<row_a)then
ar1 <= std_logic_vector(matA(m,rr,1));
ai1 <= std_logic_vector(matA(m,rr,0));
br1 <= std_logic_vector(matBz(rr,k,1));
bi1 <= std_logic_vector(matBz(rr,k,0));
--enable_delay <= '1'; -- start counter
if(rr = (clo_a - 1))then
if(k = (clo_bz - 1))then
if(m<=row_a)then
rr<=0;
k<=0;
m<=m+1;
end if;
elsif(k < clo_bz)then
rr<=0;
k<=k+1;
end if;
elsif(rr < clo_a)then
rr<=rr+1;
end if;
--report "unexpected value. rrrr = " & integer'image(rr);
enable_delay <= '1'; -- start counter
report "mire to dealy age khoda bekhad.";
state <=sleeep;
else
outs<=not outs;
end if;

when sleeep =>
if delay_done = '1' then
enable_delay <= '0'; -- stop counter and reset it
reset_delaytimer <= '1';
state<=do_mult;
else
reset_delaytimer <= '0';
state<=sleeep;
end if;

when do_mult =>

report "unexpected value. rrrr = " & integer'image(rr);
report "unexpected value. xxxx = " & integer'image(x);
report "unexpected value. yyyy = " & integer'image(y);
as1 <= signed(pr1);
if(hemar='0')then
bs1 <= signed(asal);
report "khoda ya ar1 chan mishe: bs1=0 becaus of hemar.!!!";
hemar<='1';
elsif(rr=1)then
bs1 <= signed(asal);
report "khoda ya ar1 chan mishe: bs1=0 becaus of rr.!!!";
else
bs1 <= as3;
report "khoda ya ar1 chan mishe: bs1=as3.";
end if;
as2 <= signed(pi1);
if(gav='0')then
bs2 <= signed(asal);
gav<='1';
elsif(rr=1)then
bs2 <= signed(asal);
else
bs2 <= as4;
end if;

report "khoda ya ar1 chan mishe: ar1=" & integer'image(to_integer(signed(ar1)));
report "khoda ya ar1 chan mishe: br1=" & integer'image(to_integer(signed(br1)));
report "khoda ya ar1 chan mishe: ai1=" & integer'image(to_integer(signed(ai1)));
report "khoda ya ar1 chan mishe: bi1=" & integer'image(to_integer(signed(bi1)));
report "khoda ya br1 chan mishe: pr1=" & integer'image(to_integer(signed(pr1)));
report "khoda ya br1 chan mishe: as1=" & integer'image(to_integer(signed(as1)));
report "khoda ya bs1 chan mishe: bs1=" & integer'image(to_integer(bs1));
enable_delay <= '1'; -- start counter
state <= sleeep1;

when sleeep1 =>
if delay_done = '1' then
enable_delay <= '0'; -- stop counter and reset it
reset_delaytimer <= '1';
state<=apply_output;
else
reset_delaytimer <= '0';
state<=sleeep1;
end if;
	 
when apply_output =>
as3 <= cs1;
as4 <= cs2;
report "khoda ya br1 chan mishe: cs1=" & integer'image(to_integer(signed(cs1)));
report "khoda ya br1 chan mishe: as3 badan mishe bs1 as3=" & integer'image(to_integer(signed(as3)));
report "khoda ya br1 chan mishe: pr1=" & integer'image(to_integer(signed(pr1)));
--report "unexpected value. rrrr = " & integer'image(rr);
report "bayad bere ya na ha!  rrrr =  " & integer'image(rr);
if(rr = 0)then
kamel<= 0;
report "age khoda bekhad raft.  rrrr =  " & integer'image(rr);
state <= apply_output1;
else
kamel<=kamel + 1;
enable_delay <= '1'; -- start counter
state <= sleeep2;
end if;

when sleeep2 =>
if delay_done = '1' then
enable_delay <= '0'; -- stop counter and reset it
reset_delaytimer <= '1';
report "khoda ya br1 chan mishe: as3 badan mishe bs1 as3=" & integer'image(to_integer(signed(as3)));
report "khoda ya br1 chan mishe: pr1=" & integer'image(to_integer(signed(pr1)));
if(rr=1)then
bs1 <= signed(asal);
--report "khoda ya ar1 chan mishe: bs1=0 becaus of rr.!!!";
else
bs1 <= as3;
--report "khoda ya ar1 chan mishe: bs1=as3.";
end if;
if(rr=1)then
bs2 <= signed(asal);
else
bs2 <= as4;
end if;
state<=init1;
else
reset_delaytimer <= '0';
state<=sleeep2;
end if;

when apply_output1 =>
if(x<row_a)then
report "ta inja omad aya inja error mide?";
matC(x,y,1) <= as3;
matC(x,y,0) <= as4;
if(y=(clo_bz - 1))then
if(x<row_a)then
y<=0;
x<=x+1;
end if;
elsif(y<clo_bz)then
y<=y+1;
end if;
state <= init1;
--end if;
else
outs<=not outs;
end if;
end case;
-------------------------------------------end multiplaction-------------------------------------
elsif(model="10")then --------------------------------------sum---------------------------------------------------
case state1 is
when initiate1 =>
if(start = '1')then
for i in 0 to (row_a - 1) loop
for j in 0 to (clo_a - 1) loop
for l in 0 to 1 loop
matA(i,j,l) <= a((i*2*clo_a+j*2+l+1)*8-1 downto (i*2*clo_a+j*2+l)*8);
end loop;
end loop;
end loop;
for i1 in 0 to (row_b - 1) loop
for j1 in 0 to (clo_b - 1) loop
for l1 in 0 to 1 loop
matB(i1,j1,l1) <= b((i1*2*clo_b+j1*2+l1+1)*8-1 downto (i1*2*clo_b+j1*2+l1)*8);
end loop;
end loop;
end loop;
--enable_delay <= '1'; -- start counter
state1<=init2;
end if;

when init2 =>
if(m1<row_a)then
as5 <= matA(m1,k1,1);
bs5 <= matB(m1,k1,1);
as6 <= matA(m1,k1,0);
bs6 <= matB(m1,k1,0);
if(k1=clo_a - 1)then
if(m1<row_a)then
k1<=0;
m1<=m1+1;
end if;
elsif(k1<clo_a)then
k1<=k1+1;
end if;
end if;
if(m1=row_a)then
outs1<=not outs1;
end if;
enable_delay <= '1';
state1<=sleeep12;

when sleeep12 =>
if(delay_done = '1')then
enable_delay <= '0'; -- stop counter and reset it
reset_delaytimer <= '1';
state1<=apply_output12;
else
reset_delaytimer <= '0';
state1<=sleeep12;
end if;

when apply_output12 =>
if (x1<row_a) then
matC1(x1,y1,1) <= cs5;
matC1(x1,y1,0) <= cs6;
if (y1=clo_a - 1) then
if (x1<row_a) then
y1<=0;
x1<=x1+1;
end if;
elsif (y1<clo_a)then
y1<=y1+1;
end if;
state1<=init2;
else
outs1<=not outs1;
end if;

end case; ------------------------------------------end sum------------------------------------------

elsif(model="11")then -----------------------------------------subtraction---------------------------------------
case state2 is
when initiate1 =>
if(start = '1')then
for i in 0 to (row_a - 1) loop
for j in 0 to (clo_a - 1) loop
for l in 0 to 1 loop
matA(i,j,l) <= a((i*2*clo_a+j*2+l+1)*8-1 downto (i*2*clo_a+j*2+l)*8);
end loop;
end loop;
end loop;
for i1 in 0 to (row_b - 1) loop
for j1 in 0 to (clo_b - 1) loop
for l1 in 0 to 1 loop
matB(i1,j1,l1) <= b((i1*2*clo_b+j1*2+l1+1)*8-1 downto (i1*2*clo_b+j1*2+l1)*8);
end loop;
end loop;
end loop;
--enable_delay <= '1'; -- start counter
state2<=init2;
end if;

when init2 =>
if(m2<row_a)then
asb1 <= matA(m2,k2,1);
bsb1 <= matB(m2,k2,1);
asb2 <= matA(m2,k2,0);
bsb2 <= matB(m2,k2,0);
if(k2=clo_a - 1)then
if(m2<row_a)then
k2<=0;
m2<=m2+1;
end if;
elsif(k2<clo_a)then
k2<=k2+1;
end if;
end if;
if(m2=row_a)then
outs2<=not outs2;
end if;
enable_delay <= '1';
state2<=sleeep12;

when sleeep12 =>
if(delay_done = '1')then
enable_delay <= '0'; -- stop counter and reset it
reset_delaytimer <= '1';
state2<=apply_output12;
else
reset_delaytimer <= '0';
state2<=sleeep12;
end if;

when apply_output12 =>
if (x2<row_a) then
matC2(x2,y2,1) <= csb1;
matC2(x2,y2,0) <= csb2;
if (y2=clo_a - 1) then
if (x2<row_a) then
y2<=0;
x2<=x2+1;
end if;
elsif (y2<clo_a) then
y2<=y2+1;
end if;
state2<=init2;
else
outs2<=not outs2;
end if;

end case;--------------------------------------------end subtraction-----------------------------------
end if;----------------------------model-------------------------------------
end if;
end process;
------------------------------sum------------------------------

-------------------------submition----------------------

--------------------------------------apply output-----------------------
outp : process(outs,outs1,outs2)
begin
if(model = "01")then
for i in 0 to (row_a - 1) loop
for j in 0 to (clo_bz - 1) loop
for l in 0 to 1 loop
c_mult((i*2*clo_bz+j*2+l+1)*16-1 downto (i*2*clo_bz+j*2+l)*16) <= matC(i,j,l);
end loop;
end loop;
end loop;
done<="01";
elsif(model = "10")then
for i in 0 to (row_a - 1) loop
for j in 0 to (clo_a - 1) loop
for l in 0 to 1 loop
c_sum((i*2*clo_a+j*2+l+1)*8-1 downto (i*2*clo_a+j*2+l)*8) <= matC1(i,j,l);
end loop;
end loop;
end loop;
done<="10";
elsif(model = "11")then
for i in 0 to (row_a - 1) loop
for j in 0 to (clo_a - 1) loop
for l in 0 to 1 loop
c_sum((i*2*clo_a+j*2+l+1)*8-1 downto (i*2*clo_a+j*2+l)*8) <= matC2(i,j,l);
end loop;
end loop;
end loop;
done<="11";
end if;
end process;

end Behavioral;
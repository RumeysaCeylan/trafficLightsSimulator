library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TrafficLightsTb is
end entity;
 
architecture sim of TrafficLightsTb is
 
    constant ClockFrequencyHz : integer := 100; 
    constant ClockPeriod : time := 1000 ms / ClockFrequencyHz;
	constant walkerTime : time := 15 sec;
    
    signal Clk         : std_logic := '1';
    signal nRst        : std_logic := '0';
    signal RedVertical    : std_logic;
    signal YellowVertical : std_logic;
    signal GreenVertical  : std_logic;
    signal RedHorizontal     : std_logic;
    signal YellowHorizontal  : std_logic;
    signal GreenHorizontal   : std_logic;
	signal sensor1  : std_logic :='1';  -- north way/south way
	signal sensor2  : std_logic :='1';  -- east way / west way

	signal RedVerticalWalker    : std_logic;
    signal GreenVerticalWalker  : std_logic;
    signal RedHorizontalWalker     : std_logic;
    signal GreenHorizontalWalker   : std_logic;
 
begin
 
    -- The Device Under Test (DUT)
    i_TrafficLights : entity work.TrafficLights(rtl)
    generic map(ClockFrequencyHz => ClockFrequencyHz)
    port map (
        Clk         => Clk,
        nRst        => nRst,
        RedVertical    => RedVertical,
        YellowVertical => YellowVertical,
        GreenVertical  => GreenVertical,
        RedHorizontal     => RedHorizontal,
        YellowHorizontal  => YellowHorizontal,
        GreenHorizontal   => GreenHorizontal,
		
		RedVerticalWalker    => RedVerticalWalker,
        GreenVerticalWalker  => GreenVerticalWalker,
        RedHorizontalWalker     => RedHorizontalWalker,
        GreenHorizontalWalker   => GreenHorizontalWalker,
		sensor1          => sensor1,
		sensor2          => sensor2);
 
 
    -- Process for generating clock
    Clk <= not Clk after ClockPeriod / 2;

 
    -- Testbench sequence
    process is
    begin
        wait until rising_edge(Clk);
        wait until rising_edge(Clk);
     
        -- Take the DUT out of reset
        nRst <= '1';
        sensor1 <= not sensor1 after walkerTime;
		sensor2 <= not sensor2 after walkerTime;
		
		wait for 10 sec;
		
		sensor1 <= not sensor1 after walkerTime;
		sensor2 <= not sensor2 after walkerTime;
		
		wait for 10 sec;
		
		sensor1 <= not sensor1 after walkerTime;
		sensor2 <= not sensor2 after walkerTime;
		wait for 10 sec;
		
		sensor1 <= not sensor1 after walkerTime;
		sensor2 <= not sensor2 after walkerTime;
		
		wait for 10 sec;
		
		sensor1 <= not sensor1 after walkerTime;
		sensor2 <= not sensor2 after walkerTime;
		wait for 10 sec;
		
		sensor1 <= not sensor1 after walkerTime;
		sensor2 <= not sensor2 after walkerTime;
		
		wait for 10 sec;
		
		sensor1 <= not sensor1 after walkerTime;
		sensor2 <= not sensor2 after walkerTime;
		

		
		
		
        wait;
    end process;
     
end architecture;
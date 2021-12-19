library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity TrafficLights is
generic(ClockFrequencyHz : integer);
port(
    Clk         : in std_logic;
    nRst        : in std_logic;
    sensor1  : in std_logic;  -- north way/south way
	sensor2  : in std_logic;  -- east way/west way 
	RedVertical    : out std_logic;
    YellowVertical : out std_logic;
    GreenVertical  : out std_logic;
    RedHorizontal     : out std_logic;
    YellowHorizontal  : out std_logic;
    GreenHorizontal   : out std_logic;
    RedVerticalWalker    : out std_logic;
    GreenVerticalWalker  : out std_logic;
    RedHorizontalWalker     : out std_logic;
    GreenHorizontalWalker   : out std_logic);
	
end entity;
 
architecture rtl of TrafficLights is
 
    -- Enumerated type declaration and state signal declaration
    type t_State is (NorthNext, StartNorth, North, StopNorth,
                        WestNext, StartWest, West, StopWest);
    signal State : t_State;
 
    -- Counter for counting clock periods, 1 minute max
    signal Counter : integer range 0 to ClockFrequencyHz * 60;
 
begin

 
    process(Clk,sensor1,sensor2) is
 
        -- Procedure for changing state after a given time
        procedure StateChanging(ToState : t_State;
                              Minutes : integer := 0;
                              Seconds : integer := 0) is
            variable TotalSeconds : integer;
            variable ClockCycles  : integer;
        begin
            TotalSeconds := Seconds + Minutes * 60;
            ClockCycles  := TotalSeconds * ClockFrequencyHz -1;
            if Counter = ClockCycles then
                Counter <= 0;
                State   <= ToState;
            end if;
        end procedure;
 
    begin
        if rising_edge(Clk) then
           case nRst is -- Reset values
                when '0' =>
                State   <= NorthNext;
                Counter <= 0;
                RedVertical    <= '1';
                YellowVertical <= '0';
                GreenVertical  <= '0';
                RedHorizontal     <= '1';
                YellowHorizontal  <= '0';
                GreenHorizontal   <= '0';
				RedVerticalWalker    <= '0';
                GreenVerticalWalker  <= '1';
                RedHorizontalWalker     <= '0';
                GreenHorizontalWalker   <= '1';
 
            when others =>
                -- Default values
                RedVertical    <= '0';
                YellowVertical <= '0';
                GreenVertical  <= '0';
                RedHorizontal     <= '0';
                YellowHorizontal  <= '0';
                GreenHorizontal   <= '0';
				RedVerticalWalker    <= '0';
                GreenVerticalWalker  <= '0';
                RedHorizontalWalker     <= '0';
                GreenHorizontalWalker   <= '0';
				
                Counter <= Counter + 1;
 
               
 
                    -- Red in all directions
                    if State=NorthNext then
                        RedVertical <= '1';
                        RedHorizontal  <= '1';
						if sensor1='1' and sensor2='1' then
						   GreenHorizontalWalker <='1';
						   GreenVerticalWalker <='1';
						   RedHorizontalWalker <= '0';
						   RedVerticalWalker <= '0';
						else 
						  GreenHorizontalWalker <='0';
						   GreenVerticalWalker <='0';
						   RedHorizontalWalker <= '1';
						   RedVerticalWalker <= '1';
						end if;  
						   
                        StateChanging(StartNorth, Seconds => 5);
 
                    -- Red and yellow in north/south direction
                    elsif State = StartNorth then
                        RedVertical    <= '1';
                        YellowVertical <= '1';
                        RedHorizontal     <= '1';
						if sensor2='1' then
						   GreenHorizontalWalker <='1';
						   GreenVerticalWalker <='0';
						   RedHorizontalWalker <= '0';
						   RedVerticalWalker <= '1';
						else 
						  GreenHorizontalWalker <='0';
						   GreenVerticalWalker <='0';
						   RedHorizontalWalker <= '1';
						   RedVerticalWalker <= '1';
						end if;
                        StateChanging(North, Seconds => 5);
						
                    -- Green in north/south direction
                    elsif State =North then
                        GreenVertical <= '1';
                        RedHorizontal    <= '1';
						
						if sensor2='1' then
						   GreenHorizontalWalker <='1';
						   GreenVerticalWalker <='0';
						   RedHorizontalWalker <= '0';
						   RedVerticalWalker <= '1';
						else 
						   GreenHorizontalWalker <='0';
						   GreenVerticalWalker <='0';
						   RedHorizontalWalker <= '1';
						   RedVerticalWalker <= '1';
						end if;  
						   
                        StateChanging(StopNorth, Minutes => 1);
 
                    -- Yellow in north/south direction
                    elsif State = StopNorth then
                        YellowVertical <= '1';
                        RedHorizontal     <= '1';
						
						if sensor2='1' then
						   GreenHorizontalWalker <='1';
						   GreenVerticalWalker <='0';
						   RedHorizontalWalker <= '0';
						   RedVerticalWalker <= '1';
						else 
						  GreenHorizontalWalker <='0';
						   GreenVerticalWalker <='0';
						   RedHorizontalWalker <= '1';
						   RedVerticalWalker <= '1';
						end if;  
						   
                        StateChanging(WestNext, Seconds => 5);
 
                    -- Red in all directions
                    elsif State = WestNext then
                        RedVertical <= '1';
                        RedHorizontal  <= '1';
						if sensor1='1' and sensor2='1' then
						   GreenHorizontalWalker <='1';
						   GreenVerticalWalker <='1';
						   RedHorizontalWalker <= '0';
						   RedVerticalWalker <= '0';
						else 
						  GreenHorizontalWalker <='0';
						   GreenVerticalWalker <='0';
						   RedHorizontalWalker <= '1';
						   RedVerticalWalker <= '1';
						end if;  
						   
                        StateChanging(StartWest, Seconds => 5);
 
                    -- Red and yellow in west/east direction
                    elsif State = StartWest then
                        RedVertical   <= '1';
                        RedHorizontal    <= '1';
                        YellowHorizontal <= '1';
						if sensor1='1' then
						   GreenHorizontalWalker <='0';
						   GreenVerticalWalker <='1';
						   RedHorizontalWalker <= '1';
						   RedVerticalWalker <= '0';
						else 
						  GreenHorizontalWalker <='0';
						   GreenVerticalWalker <='0';
						   RedHorizontalWalker <= '1';
						   RedVerticalWalker <= '1';
						end if;  
						   
                        StateChanging(West, Seconds => 5);
 
                    -- Green in west/east direction
                    elsif State = West then
                        RedVertical  <= '1';
                        GreenHorizontal <= '1';
						
						if sensor1='1' then
						   GreenHorizontalWalker <='0';
						   GreenVerticalWalker <='1';
						   RedHorizontalWalker <= '1';
						   RedVerticalWalker <= '0';
						else 
						  GreenHorizontalWalker <='0';
						   GreenVerticalWalker <='0';
						   RedHorizontalWalker <= '1';
						   RedVerticalWalker <= '1';
						end if;  
						   
                        StateChanging(StopWest, Minutes => 1);
 
                    -- Yellow in west/east direction
                    elsif State = StopWest then
                        RedVertical   <= '1';
                        YellowHorizontal <= '1';
						
						if sensor1='1' then
						   GreenHorizontalWalker <='0';
						   GreenVerticalWalker <='1';
						   RedHorizontalWalker <= '1';
						   RedVerticalWalker <= '0';
						else 
						  GreenHorizontalWalker <='0';
						   GreenVerticalWalker <='0';
						   RedHorizontalWalker <= '1';
						   RedVerticalWalker <= '1';
						end if;  
                        StateChanging(NorthNext, Seconds => 5);
 
                     end if;
 
            end case;
        end if;
    end process;
 
end architecture;
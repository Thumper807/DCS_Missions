-- Creates random traffic to make the environment seem "more alive".

-- Setup BLUE RAT
local BLUE_airplaneTemplate = { "C-130", "C-17A", "E-2D", "F117A", "B52H", "AJS37", "B-1B", "C-101CC", "Hawk", "L-39C" }
local BLUE_airfields = {"Kutaisi", "Batumi", "Senaki-Kolkhi", "Kobuleti", "Tbilisi_Lochini", "Soganlug", "Vaziani", "Beslan", "Nalchik", "Sukhumi_Babushara"}
local BLUE_F14_Liveries = { "VF-103 Jolly Rogers Hi Viz", "01 - VF-102 Diamondbacks 1996", "VF-211 Fighting Checkmates", "VF-11 Red Rippers (1997)", "VF-24 Renegades Low-Viz", "VF-101 Dark", "VF-143 Pukin' Dogs CAG"}

local blue_ground_spawner = RAT:New("Blue Ground Start Aircraft")
:InitRandomizeTemplate(BLUE_airplaneTemplate)
blue_ground_spawner:SetDeparture(BLUE_airfields)
blue_ground_spawner:SetDestination(BLUE_airfields)
blue_ground_spawner:SetTakeoff("hot")

local blue_air_spawner = RAT:New("Blue Air Start Aircraft")
:InitRandomizeTemplate(BLUE_airplaneTemplate)
blue_air_spawner:SetDeparture({"RAT Blue Zone"})
blue_air_spawner:SetDestination(BLUE_airfields)
blue_air_spawner:SetFLcruise(180)
blue_air_spawner:SetFLmin(100)
blue_air_spawner:SetTakeoff("air")

blue_ground_spawner:Spawn(5)
blue_air_spawner:Spawn(10)

-- BLUE Carrier Traffic!
local f14=RAT:New("F-14B Carrier Traffic")
f14:Livery(BLUE_F14_Liveries)
f14:SetDeparture({"Batumi"})
f14:SetDestination({"CVN-74 John C. Stennis"})
f14:Commute()
f14:SetTakeoff("cold")
f14:Spawn(4)

local f18=RAT:New("F/A-18C Carrier Traffic")
f18:SetDeparture({"CVN-74 John C. Stennis"})
f18:SetDestination({"Batumi"})
f18:Commute()
f18:SetTakeoff("cold")
f18:Spawn(4)


-- Setup RED RAT
local RED_airplaneTemplate = { "Yak-40", "IL-76D", "An-26B", "An-30M", "Tu-95MS", "I-16", "MiG-15bis", "MiG-19P", "MiG-21Bis", "Tu-142", "Tu-160", "Tu-22M3" }
local RED_airfields = {"Krymsk", "Novorossiysk", "Gelendzhik", "Krasnodar-Center", "Krasnodar-Pashkovsky", "Maykop-Khanskaya", "Anapa_Vityazevo", "Sochi_Adler", "Gudauta", "Mineralnye_Vody", "Mozdok"}

local red_ground_spawner = RAT:New("Red Ground Start Aircraft")
:InitRandomizeTemplate(RED_airplaneTemplate)
red_ground_spawner:SetDeparture(RED_airfields)
red_ground_spawner:SetDestination(RED_airfields)
red_ground_spawner:SetTakeoff("hot")

local red_air_spawner = RAT:New("Red Air Start Aircraft")
:InitRandomizeTemplate(RED_airplaneTemplate)
red_air_spawner:SetDeparture({"RAT Red Zone"})
red_air_spawner:SetDestination(RED_airfields)
red_air_spawner:SetFLcruise(180)
red_air_spawner:SetFLmin(100)
red_air_spawner:SetTakeoff("air")

red_ground_spawner:Spawn(5)
red_air_spawner:Spawn(10)

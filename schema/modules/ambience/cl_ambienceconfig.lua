
-- AMBIENCE CONFIG
local function initAMBIENCE()

  -- AMBIENT MUSIC
  ----------------------------------------------------------------------------------------------------
  FO_AMB.RegisterTrack("Desert Wanderer", "nv_ambiant/nv_1.mp3", 213, 100)
  FO_AMB.RegisterTrack("Shady Sands", "nv_ambiant/nv_2.mp3", 244, 100, {"Legion"})
  FO_AMB.RegisterTrack("Mojave Express", "nv_ambiant/nv_3.mp3", 210, 100)
  FO_AMB.RegisterTrack("The Courier", "nv_ambiant/nv_4.mp3", 244, 100, {"NCR"})
  FO_AMB.RegisterTrack("Lone Drifter","nv_ambiant/nv_5.mp3",205, 100, {"Legion"})
  FO_AMB.RegisterTrack("Goodsprings","nv_ambiant/nv_6.mp3",131, 100, {"NCR"})  
  FO_AMB.RegisterTrack("Desert Wastes","nv_ambiant/nv_7.mp3",180, 100, {"Legion"})
  FO_AMB.RegisterTrack("Knock on my Cazadore","nv_ambiant/nv_8.mp3",120, 100, {"NCR"})
  FO_AMB.RegisterTrack("Desert Wastes 2","nv_ambiant/nv_9.mp3",258, 100, {"NCR"})
  FO_AMB.RegisterTrack("Marcus Needs a Favour","nv_ambiant/nv_10.mp3",243, 100, {"Legion"})  
  FO_AMB.RegisterTrack("Desert Wastes 3","nv_ambiant/nv_11.mp3",243, 100)    
  FO_AMB.RegisterTrack("Thorn in my Side","nv_ambiant/nv_12.mp3",253, 100, {"NCR"})
  FO_AMB.RegisterTrack("The Courier Walks Softly","nv_ambiant/nv_13.mp3",246, 100)  
  ----------------------------------------------------------------------------------------------------

  -- RADIAL AMBIENCE
  FO_AMB.RegisterTrack("Legion 1","nv_ambiant/legion1.mp3",262, 100, nil, "Legion")  
  FO_AMB.RegisterTrack("Legion 2","nv_ambiant/legion2.mp3",263, 100, nil, "Legion")
  FO_AMB.RegisterTrack("Legion 3","nv_ambiant/legion3.mp3",135, 100, nil, "Legion")
  
  FO_AMB.RegisterTrack("NCR 1","nv_ambiant/ncr1.mp3",247, 100, nil, "NCR")
  FO_AMB.RegisterTrack("NCR 2","nv_ambiant/ncr2.mp3",246, 100, nil, "NCR")
  
  FO_AMB.RegisterTrack("BoS 1","nv_ambiant/bos1.mp3",97, 100, nil, "BoS")
  FO_AMB.RegisterTrack("BoS 2","nv_ambiant/bos2.mp3",97, 100, nil, "BoS")
  FO_AMB.RegisterTrack("BoS 3","nv_ambiant/bos3.mp3",97, 100, nil, "BoS")
  ---------------------------------------------------------------------------------------------------------

  --VECTORS FOR LOCATION BASED AMBIENCE
  --FO_AMB.RadiusVecs["Legion"] = {Vec = Vector(-9221.476563, -12393.857422, 0.000031), Rad = 3000} 	(Uncomment and set your own co-ords for each faction.)
  --FO_AMB.RadiusVecs["NCR"] = {Vec = Vector(9089.292969, 3391.824463, 27.031250), Rad = 2900}
  --FO_AMB.RadiusVecs["BoS"] = {Vec = Vector(-8303.502930, 10646.334961, -1612.858765), Rad = 3000}  
--
end

------------------------
--
timer.Simple(1,function()
initAMBIENCE()
end)

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-- 		   TUTORIAL			 --
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

-- This tutorial will help you add your own ambience tracks,
-- see below to find out what each second of the line of code means.

-- FO_AMB.RegisterTrack("The Courier Walks Softly","nv_ambiant/nv_13.mp3",246,false,100) <-- This is what the code looks like,
-- If we look at the code more here is what it means:

-- FO_AMB.RegisterTrack, This part of the code is to register the the track with the ambience system.
-- ("Example track Name" (String), "PATH TO THE AMBIENT SOUND TRACKS" (String), Number of seconds the track should play for (Number), is this track combat music (true or false), how loud should the track play? (Number))

-- (THIS TUTORIAL IS TO BE IMPROVED LATER.)

--=-=-=-=-=-=-=-=-=-=-=-=-=-=
--       END TUTORIAL      --
--=-=-=-=-=-=-=-=-=-=-=-=-=-=
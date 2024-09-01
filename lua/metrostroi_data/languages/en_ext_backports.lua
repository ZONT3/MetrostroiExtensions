return [[
# Metrostroi Extensions english translations for backports

[en]

#Station list GUI
StationList.Title           = Station list
StationList.Name            = Name
StationList.NamePos         = Position
StationList.Select          = Select station
StationList.Teleport        = Teleport
StationList.NoConfig        = This map is not configured


Panel.DisableHoverText  = Disable tooltips
Panel.DisableHoverTextP = Disable additional information\nin tooltips #NEW #FIXME
Panel.DisableSeatShadows= Disable seat shadows #NEW #FIXME

Panel.PanelSprites      = Enable sprites from control\npanel lamps
Panel.PanelLights       = Enable dynamic lights\nfrom control panel lamps #NEW
Panel.RouteNumber       = Route number #NEW

Panel.Z                 = Camera height #NEW
Panel.RenderSignals     = Traced signals #NEW #FIXME
Panel.DrawSignalDebugInfo     = Signalling debug info
Panel.SoftDraw          = Train elements loading time


Train.Common.UAVA           = UAVA
Train.Common.PneumoPanels   = Pneumatic valves
Train.Common.Voltmeters     = Voltmeters and amperemeters

Train.Buttons.Active        = Active #NEW
Train.Buttons.Auto          = Auto #NEW
Train.Buttons.On            = On #NEW
Train.Buttons.Off           = Off #NEW
Train.Buttons.Closed        = Closed #NEW
Train.Buttons.Opened        = Opened #NEW
Train.Buttons.Disconnected  = Disconnected #NEW
Train.Buttons.Connected     = Connected #NEW
Train.Buttons.UAVAOff       = Control circuits is open #NEW (OFF)
Train.Buttons.UAVAOn        = Control circuits is closed #NEW (ON)
Train.Buttons.Freq1/5       = 1/5 autoblocking #NEW
Train.Buttons.Freq2/6       = 2/6 ALS-ARS #NEW
Train.Buttons.Left          = Left #NEW
Train.Buttons.Right         = Right #NEW
Train.Buttons.Low           = Low #NEW
Train.Buttons.High          = High #NEW #FIXME
Train.Buttons.LFar          = Bright #NEW #FIXME (headlights)
Train.Buttons.LNear         = Dim #NEW #FIXME (headlights)
Train.Buttons.0             = 0 #NEW
Train.Buttons.1             = 1 #NEW
Train.Buttons.2             = 2 #NEW
Train.Buttons.3             = 3 #NEW
Train.Buttons.4             = 4 #NEW
Train.Buttons.Forward       = Forward #NEW
Train.Buttons.Back          = Backward #NEW
Train.Buttons.VentHalf      = 1/2 of speed #NEW (of ventilation)
Train.Buttons.VentFull      = Full speed #NEW (of ventilation)
Train.Buttons.VTRF          = Forward oriented wagons #NEW
Train.Buttons.VTRB          = Back oriented wagons #NEW
Train.Buttons.VTR1          = Even wagons #NEW
Train.Buttons.VTR2          = Odd wagons #NEW
Train.Buttons.VTRH1         = First half of train #NEW
Train.Buttons.VTRH2         = Second half of train #NEW
Train.Buttons.VTRAll        = All wagons #NEW

Train.Buttons.BatteryVoltage = %d V #NEW
Train.Buttons.HighVoltage    = %d V #NEW
Train.Buttons.EnginesVoltage    = %d V #NEW
Train.Buttons.BatteryCurrent = %d A #NEW
Train.Buttons.EnginesCurrent = %d A #NEW
Train.Buttons.Speed          = %d km/h #NEW
Train.Buttons.SpeedAll       = %d km/h\nSpeed limit: %s km/h #NEW #FIXME
Train.Buttons.SpeedLimit     = %s km/h #NEW
Train.Buttons.SpeedLimitNext = %s km/h #NEW
Train.Buttons.Acceleration   = % 4.2f m/s #NEW
Train.Buttons.04             = NF #NEW (no frequency)
Train.Buttons.BCPressure     = %.1f bar
Train.Buttons.BLTLPressure   = TL: %.1f bar\nBL: %.1f bar #NEW (TL: Train line, BL: Brake line acronyms)
Train.Buttons.Locked         = Locked #NEW
Train.Buttons.Unlocked       = Unlocked #NEW

Entities.gmod_subway_81-717_mvm_custom.Name     = 81-717 (Moscow custom)
Entities.gmod_subway_81-717_lvz_custom.Name     = 81-717 (SPB custom)
Entities.gmod_train_special_box.Name        = Special delivery

Weapons.button_presser.Name                 = Button presser
Weapons.button_presser.Purpose              = Used to press buttons on the maps.
Weapons.button_presser.Instructions         = Aim to a button and click "Attack" button.
Weapons.train_key.Name                      = Administrator key
Weapons.train_key.Purpose                   = Used to activate the administrators buttons.
Weapons.train_key.Instructions              = Aim to the administrator button and press "Attack" button.
Weapons.train_kv_wrench.Name                = Reverser wrench
Weapons.train_kv_wrench.Purpose             = Used in metro train and for pressing buttons in them.
Weapons.train_kv_wrench.Instructions        = Aim to a button in the train and press "Attack" button.
Weapons.train_kv_wrench_gold.Name           = The golden reverser wrench


Spawner.Title                           = Train spawner
Spawner.Spawn                           = Spawn
Spawner.Close                           = Close
Spawner.Trains1                         = Wags. allowed
Spawner.Trains2                         = Per player
Spawner.WagNum                          = Wagons amount

Common.Spawner.CabTexture               = Driver's cab skin
Common.Spawner.SpawnMode                = Train state
Common.Spawner.SpawnMode.Deadlock       = Dead-end
Common.Spawner.SpawnMode.Full           = Fully started
Common.Spawner.SpawnMode.NightDeadlock  = Dead-end after night
Common.Spawner.SpawnMode.Depot          = Cold and dark

Common.Spawner.Random                   = Random
Common.Spawner.Old                      = Old
Common.Spawner.New                      = New
Common.Spawner.Type                     = Type

Common.Couple.Title         = Coupler menu
Common.Couple.CoupleState   = Coupler state
Common.Couple.Coupled       = Coupled
Common.Couple.Uncoupled     = Not coupled
Common.Couple.Uncouple      = Uncouple
Common.Couple.IsolState     = Isolation valves state
Common.Couple.Isolated      = Closed
Common.Couple.Opened        = Opened
Common.Couple.Open          = Open
Common.Couple.Isolate       = Close
Common.Couple.EKKState      = EKK state (electrical box connection)
Common.Couple.Disconnected  = Disconnected
Common.Couple.Connected     = Connected
Common.Couple.Connect       = Connect
Common.Couple.Disconnect    = Disconnect


Common.Bogey.Title              = Bogie menu
Common.Bogey.ContactState       = Current collectors state
Common.Bogey.CReleased          = Released
Common.Bogey.CPressed           = Pressed
Common.Bogey.CPress             = Press
Common.Bogey.CRelease           = Release
Common.Bogey.ParkingBrakeState  = Parking brake state
Common.Bogey.PBDisabled         = Manually disabled
Common.Bogey.PBEnabled          = Enabled
Common.Bogey.PBEnable           = Enable
Common.Bogey.PBDisable          = Manual disable

Common.ALL.Up                               = (up)
Common.ALL.Down                             = (down)
Common.ALL.Left                             = (left)
Common.ALL.Right                            = (right)
Common.ALL.CW                               = (clockwise)
Common.ALL.CCW                              = (counter-clockwise)

Common.ALL.KAHK                             = KAH button cover
Common.ALL.ParkingBrake                     = Parking brake
Common.ALL.KDLL                             = Left doors side is selected
Common.ALL.KDPL                             = Right doors side is selected
Common.ALL.VSD                              = Doors side selector

Common.ALL.VRPBV                            = VRP: Reset overload relay, enable BV
Common.ALL.MK                               = Compressor # (without acronym)

Common.ALL.CabLights                        = Driver's cab lighting
Common.ALL.PassLights                       = Passenger compartment lighting
Common.ALL.PanelLights                      = Control panel lighting
Common.ALL.BrW                              = Wagon pneumobrakes are engaged
Common.ALL.ARS                              = ARS: Automatic speed regulation
Common.ALL.ARSR                             = ARS-R: Automatic speed regulation in ARS-R mode
Common.ALL.RCARS                            = RC-ARS: ARS circuits disconnect # (same as RC-1)

Common.ARS.AO                               = AO: Absolute stop signal
Common.ARS.N4                               = NCh: No ARS frequency # (same as OCh but NCh)

Common.ALL.RCBPS                            = RC-BPS: Anti-Rollback unit
Common.BPS.On                               = Anti-Rollback unit operation
Common.BPS.Err                              = Anti-Rollback unit error
Common.BPS.Fail                             = Anti-Rollback unit malfunction

Common.ALL.LSD                              = Train doors state light (doors are closed)
Common.ALL.Horn                             = Horn
Common.ALL.DriverValveDisconnect            = Driver's valve disconnect valve
Common.ALL.UAVA2                            = UAVA: Enable automatic autostop disabler
Common.ALL.OAVU                             = OAVU: Disable AVU

Common.ALL.CabinDoor                        = Door to the driver's cab
Common.ALL.PassDoor                         = Door to the passenger compartment

Common.ALL.OtsekDoor1                       = 1st equipment cupboard handle
Common.ALL.OtsekDoor2                       = 2nd equipment cupboard handle
Common.ALL.CouchCap                         = Pull out the seat

Common.ALL.UNCh                             = UNCh: Low frequency amplifier
Common.ALL.ES                               = ES: Emergency communication control
Common.ALL.GCab                             = Loudspeaker: Sound in the driver's cab

Common.CabVent.PVK-         = Decrease driver's cab ventilation power
Common.CabVent.PVK+         = Increase driver's cab ventilation power

Common.IGLA.Button23        = IGLA: Second and third buttons
Common.IGLA.Button3         = IGLA: Third button
Common.IGLA.Button4         = IGLA: Fourth button

Common.BZOS.On      = Security alarm switch
Common.BZOS.VH1     = Security alarm is enabled
Common.BZOS.VH2     = Security alarm is triggered
Common.BZOS.Engaged = Security alarm is triggered

Common.ALL.SpeedAccept      = Allowed speed
Common.ALL.SpeedAttent      = Allowed speed on the next block

Common.ALL.EnginesCurrent1  = 1st traction motors current (A)
Common.ALL.EnginesCurrent2  = 2nd traction motors current (A)

Common.ALL.BatteryCurrent   = Battery current (A)
]]

require(GlobalDependencys:GetDependency("StandardBase"):GetPackageName())

--GAME VARS
fAdditionalFOV = 0
fDefaultAspectRatio = 1.777777791

--ControlVars
bFixEnabled = true
bAspectRatio = true
bResCheck = true
bFOVAdjustment = false
bFTAdjustment = false
bVignetteAdjustment = false
bRemove60HzLimit = true
bIncreaseAniDistance = true
bDisableCA = true
bIgnoreWarning = false

fDefaultFrameRate = 60.0
fDefaultFrameTime = 1000.0 / fDefaultFrameRate / 1000.0
FrameTime = fDefaultFrameTime

VignetteScale = 1.0
FOVScale = 1.0

--PROCESS VARS
Process_FriendlyName = Module:GetFriendlyName()
Process_WindowName = "ELDEN RING%TM;ELDEN RING"
Process_ClassName = "ELDEN RING%TM;ELDEN RING"
Process_EXEName = "eldenring.exe;start_protected_game.exe"

--INJECTION BEHAVIOUR
InjectDelay = 500
WriteInterval = 500
SearchInterval = 500
SuspendThread = true

--Name                         Manual/Auto/Hybrid  		Steam/Origin/Any                IncludeFile:Configure;Enable;Periodic;Disable;
SupportedVersions = { 		
{"Automatically Detect",       "Hybrid",  			"Any",	                         "Configure_SignatureScan;Enable_Inject;Periodic;Disable_Inject;"},
}

function Init_Controls()

	DefaultControls.AddHeader("Header_FOV","FOV Fine adjustment",15,70,210,17)
	DefaultControls.AddHeader("Header_FT","Frametime adjustment",15,157,210,17)
	DefaultControls.AddHeader("Header_VG","Vignette adjustment",15,242,210,17)

	DefaultControls.AddFixedFOVSlider("FOVSlider","FOVSlider_Changed",55,100,125,35,0,50,0,1)
	FOVSlider:SetTickFrequency(5)
	FOVSlider:SetLabel1Text("0%")
	FOVSlider:SetLabel2Text("50%")

	DefaultControls.AddFixedFOVSlider("FTSlider","FTSlider_Changed",55,187,125,35,60,360,60,1)
	FTSlider:SetTickFrequency(30)
	FTSlider:SetLabel1Text("60fps")
	FTSlider:SetLabel2Text("360fps")


	DefaultControls.AddFixedFOVSlider("VignetteSlider","VignetteSlider_Changed",55,272,125,35,0,100,100,1)
	VignetteSlider:SetTickFrequency(15)
	VignetteSlider:SetLabel1Text("0%")
	VignetteSlider:SetLabel2Text("100%")

	DefaultControls.AddHeader("Header_FixesEnableDisable","Individual Fixes",245,70,210,17)	
	DefaultControls.AddFixToggle("CKAspectFix_Enable","Aspect Fix","CKAspectFix_Changed",255,99,180,14)
	DefaultControls.AddFixToggle("CKResCheck_Enable","Resolution Fix (Windowed)","CKResCheck_Changed",255,118,180,14)
	DefaultControls.AddFixToggle("CKFOVAdjustment_Enable","FOV Adjustment","CKFOVAdjustment_Changed",255,137,180,14,false)
	DefaultControls.AddFixToggle("CKFTAdjustment_Enable","Frametime Adjustment","CKFTAdjustment_Changed",255,156,180,14,false)
	DefaultControls.AddFixToggle("CKVignetteAdjustment_Enable","Vignette Adjustment","CKVignetteAdjustment_Changed",255,175,180,14,false)
	DefaultControls.AddFixToggle("CKFS60HzUnlock_Enable","Remove 60Hz FS Limit","CKFS60HzUnlock_Changed",255,194,180,14)
	DefaultControls.AddFixToggle("CKIncreaseAniDist_Enable","Increase animation distance","CKIncreaseAniDist_Changed",255,213,180,14)
	DefaultControls.AddFixToggle("CKDisableCA_Enable","Disable Chromatic Aberration","CKDisableCA_Changed",255,232,180,14)
	
	DefaultControls.AddWarning("Anticheat_Warning","This game uses EAC (Easy-Anticheat) and you must ENSURE you disable it first by replacing start_protected_game.exe with (copy of) eldenring.exe OR using fixed EXE / Blocking EAC on firewall.\r\n\r\n!!!! USE AT YOUR OWN RISK !!!!",15,339,nil,82)	
end

function Configure_SignatureScan() 

    if bIgnoreWarning == false then
		return ErrorOccurred("Anticheat acknowledgement not ticked, aborting Configure_SignatureScan() - carefully consider if you want to proceed.",true)
	end

	local tAddress = HackTool:AddAddress("AspectRatio")
	if HackTool:SignatureScan("85 C0 74 ?? 45 8B ?? ?? ?? ?? ?? ?? 45 ?? ?? 74 ?? 45 ?? ?? 44",tAddress,PAGE_EXECUTE_READWRITE,0x2,Process_EXEName) == 0 then
		if HackTool:SignatureScan("48 8D ?? ?? 48 8D ?? ?? 48 C1 ?? ?? 49 ?? ?? 8B ?? 85 ?? 74 ?? 44 8B ?? ?? 45",tAddress,PAGE_EXECUTE_READWRITE,0x13,Process_EXEName) == 0 then
			if HackTool:SignatureScan("48 8D ?? ?? 48 ?? ?? 45 8B ?? ?? ?? ?? ?? ?? 41 8B ?? ?? ?? ?? ?? ?? 85 ?? 74",tAddress,PAGE_EXECUTE_READWRITE,0x19,Process_EXEName) == 0 then
			
				return ErrorOccurred(string.format(SigScanError,tAddress:GetName()))
			else
				print( tAddress:GetInfo(TYPE_ADDRESS) )
			end
		else	
			print( tAddress:GetInfo(TYPE_ADDRESS) )
		end
	else	
		print( tAddress:GetInfo(TYPE_ADDRESS) )
	end
	
	local tAddress = HackTool:AddAddress("FOVAdjustment")
	if HackTool:SignatureScan("E8 ?? ?? ?? ?? 48 8D ?? ?? ?? 44 0F ?? ?? E8 ?? ?? ?? ?? 80 ?? ?? ?? ?? ?? 00 44",tAddress,PAGE_EXECUTE_READWRITE,0xE,Process_EXEName) == 0 then
		return ErrorOccurred(string.format(SigScanError,tAddress:GetName()))
	else	
		print( tAddress:GetInfo(TYPE_ADDRESS) )
	end

	local tAddress = HackTool:AddAddress("FTAdjustment")
	if HackTool:SignatureScan("EB ?? 89 ?? ?? C7 ?? ?? ?? ?? ?? ?? EB ?? 89 ?? ?? EB ?? 89",tAddress,PAGE_EXECUTE_READWRITE,0x8,Process_EXEName) == 0 then
		return ErrorOccurred(string.format(SigScanError,tAddress:GetName()))
	else	
		print( tAddress:GetInfo(TYPE_FLOAT) )
		tAddress:SetAutoUnprotect(true)
	end
	
	local tAddress = HackTool:AddAddress("Vignette")
	if HackTool:SignatureScan("F3 0F 10 ?? ?? F3 0F 59 ?? ?? ?? ?? ?? E8 ?? ?? ?? ?? F3 41 0F ?? ?? F3 45 0F ?? ?? 4C 8D ?? ?? ?? ?? ?? ?? 48",tAddress,PAGE_EXECUTE_READWRITE,0x17,Process_EXEName) == 0 then
		return ErrorOccurred(string.format(SigScanError,tAddress:GetName()))
	else	
		print( tAddress:GetInfo(TYPE_ADDRESS) )
	end

	local tAddress = HackTool:AddAddress("ChromaticAberration")
	if HackTool:SignatureScan("0F 11 ?? ?? 48 8D ?? ?? ?? ?? ?? 0F 10 ?? ?? ?? ?? ?? 0F 11 ?? ?? 48 8D ?? ?? ?? ?? ?? 0F ?? ?? 0F ?? ??",tAddress,PAGE_EXECUTE_READWRITE,0x2F,Process_EXEName) == 0 then
		return ErrorOccurred(string.format(SigScanError,tAddress:GetName()))
	else	
		print( tAddress:GetInfo(TYPE_ADDRESS) )
	end
	
	-- 
	local tAddress = HackTool:AddAddress("ResolutionTarget")
	if HackTool:SignatureScan("48 8D ?? ?? ?? ?? ?? 44 2B ?? ?? ?? ?? 01 00 00 00 44 8B 7C ?? ?? 44 2B 7C ?? ?? 48 89 ?? ?? ?? ?? ?? ?? 45 ?? ?? 74 ?? 44",tAddress,PAGE_EXECUTE_READWRITE,0x0,Process_EXEName) == 0 then
		return ErrorOccurred(string.format(SigScanError,tAddress:GetName()))
	else	
		print( tAddress:GetInfo(TYPE_ADDRESS) )
		
		local tAddress1 = HackTool:AddAddress("ResCheck",tAddress)
		tAddress1:OffsetAddress(0x26)
		print( tAddress1:GetInfo(TYPE_INT) )
		
		tAddress:AcquireAddress(0x3)
		print( tAddress:GetInfo(TYPE_INT) )
		
		tAddress:OffsetAddress(0x50)
		
		local tOffset1 = tAddress:AddSubOffset("Res_3840", 0x0)
		local tOffset2 = tAddress:AddSubOffset("Res_2160", 0x4)
		
		print( string.format("%s -> %d x %d", tOffset1:GetInfo(TYPE_ADDRESS), tOffset1:ReadInt(), tOffset2:ReadInt() ) )
		
		tOffset1:SetAutoUnprotect(true)
		tOffset2:SetAutoUnprotect(true)
		
	end

	local tAddress = HackTool:AddAddress("FS60HzUnlock")
	if HackTool:SignatureScan("38 ?? ?? ?? ?? ?? 74 ?? 39 ?? ?? ?? ?? ?? 76 ?? 48 8B ?? ?? ?? ?? ?? 48",tAddress,PAGE_EXECUTE_READWRITE,0x6,Process_EXEName) == 0 then
		return ErrorOccurred(string.format(SigScanError,tAddress:GetName()))
	else	
		print( tAddress:GetInfo(TYPE_ADDRESS) )
	end	

	local tAddress = HackTool:AddAddress("IncreaseAniDist")
	if HackTool:SignatureScan("E8 ?? ?? ?? ?? 0F 28 ?? 0F 28 ?? E8 ?? ?? ?? ?? F3 0F ?? ?? 0F 28 ?? F3 41 0F 5E",tAddress,PAGE_EXECUTE_READWRITE,0x17,Process_EXEName) == 0 then
		return ErrorOccurred(string.format(SigScanError,tAddress:GetName()))
	else	
		print( tAddress:GetInfo(TYPE_ADDRESS) )
	end

	return true
end


function Enable_Inject() 

	local Variables = HackTool:AllocateMemory("Variables",0)
	Variables:PushFloat("FOV_In")
	Variables:PushFloat("FOV_Out")
	Variables:PushFloat("FOVScale")
	Variables:PushFloat("VignetteScale")
	Variables:Allocate()

	ResolutionChanged()	
	
	local asm = [[	
		(codecave:jmp)FOVAdjustment,FOVAdjustment_cc:
			%originalcode%
			movss [(allocation)Variables->FOV_In], $$2					$ctx=3
			mulss $$2, [(allocation)Variables->FOVScale]					$ctx=3
			movss [(allocation)Variables->FOV_Out], $$2					$ctx=3
			jmp %returnaddress%
			%end%
			
		(codecave:jmp)Vignette,Vignette_cc:
			%originalcode%
			mulss $$1, [(allocation)Variables->VignetteScale]				$ctx=1
			jmp %returnaddress%
			%end%			

		(codecave:jmp)ChromaticAberration,ChromaticAberration_cc:
			%originalcode%
			xorps $$2, $$2									$ctx=1
			movss [$$1+0x8], $$2								$ctx=1
			jmp %returnaddress%
			%end%	
	
		(codecave)AspectRatio,AspectRatio_cc:
			jmp $$1

		(codecave)ResCheck,ResCheck_cc:
			jmp $$1			

		(codecave)FS60HzUnlock,FS60HzUnlock_cc:
			jmp $$1-0xD	

		(codecave)IncreaseAniDist,IncreaseAniDist_cc:
			xorps $$1, $$1
			nop dword ptr [rcx+01]
	]]
	

	if HackTool:CompileAssembly(asm,"FOVFix") == nil then
		return ErrorOccurred("Assembly compilation failed...")
	else
		Toggle_CodeCave("AspectRatio_cc",bAspectRatio)
		Toggle_CodeCave("ResCheck_cc",bResCheck)
		Toggle_CodeCave("FOVAdjustment_cc",bFOVAdjustment)
		Toggle_CodeCave("Vignette_cc", bVignetteAdjustment)
		Toggle_CodeCave("FS60HzUnlock_cc", bRemove60HzLimit)		
		Toggle_CodeCave("IncreaseAniDist_cc",bIncreaseAniDistance)
		Toggle_CodeCave("ChromaticAberration_cc",bDisableCA)
	end	
	
	if bFOVAdjustment then
		WriteFOVScaling()
	end
	
	if bFTAdjustment then
		WriteFT()
	end
	
	if bVignetteAdjustment then
		WriteVignetteScaling()
	end
	
end

function Periodic()

	PluginViewport:AppendStatusMessage( "\r\n" )

	local Variables = HackTool:GetAllocation("Variables")
	if Variables and Variables["FOVScale"] then

		if bFOVAdjustment == true then
			PluginViewport:AppendStatusMessage( string.format("     (FOV Scaling) In=%.2f, Out=%.2f\r\n",	Variables["FOV_In"]:ReadFloat(),Variables["FOV_Out"]:ReadFloat()) )
		end

	end

end

function Disable_Inject()

	if bFTAdjustment then
		WriteFT(true)
	end
	
	RestoreResolution() 
	CleanUp()
	
end


function CKAspectFix_Changed(Sender)

	bAspectRatio = Toggle_CheckFix(Sender)
	Toggle_CodeCave("AspectRatio_cc",bAspectRatio)
	ForceUpdate()
	
end

function CKFOVAdjustment_Changed(Sender)

	bFOVAdjustment = Toggle_CheckFix(Sender)
	Toggle_CodeCave("FOVAdjustment_cc",bFOVAdjustment)
	
	if bFOVAdjustment then
		WriteFOVScaling()
	end
	
	ForceUpdate()
	
end

function CKVignetteAdjustment_Changed(Sender)

	bVignetteAdjustment = Toggle_CheckFix(Sender)
	Toggle_CodeCave("Vignette_cc",bVignetteAdjustment)
	
	if bVignetteAdjustment then
		WriteVignetteScaling()
	end
	
	ForceUpdate()
	
end

function CKFTAdjustment_Changed(Sender)

	bFTAdjustment = Toggle_CheckFix(Sender)
	
	if bFTAdjustment then
		WriteFT()
	else
		WriteFT(true)
	end
	
	ForceUpdate()
	
end



function CKResCheck_Changed(Sender)

	bResCheck = Toggle_CheckFix(Sender)
	Toggle_CodeCave("ResCheck_cc",bResCheck)
	ForceUpdate()
	
end

function CKFS60HzUnlock_Changed(Sender)

	bRemove60HzLimit = Toggle_CheckFix(Sender)
	Toggle_CodeCave("FS60HzUnlock_cc",bRemove60HzLimit)
	ForceUpdate()
	
end

function CKIncreaseAniDist_Changed(Sender)

	bIncreaseAniDistance = Toggle_CheckFix(Sender)
	Toggle_CodeCave("IncreaseAniDist_cc",bIncreaseAniDistance)
	ForceUpdate()
	
end

function CKDisableCA_Changed(Sender)

	bDisableCA = Toggle_CheckFix(Sender)
	Toggle_CodeCave("ChromaticAberration_cc",bDisableCA)
	ForceUpdate()
	
end

function FOVSlider_Changed(Sender)

	fAdditionalFOV = Sender:GetPosition()
	lblFOVSlider.Caption:SetCaption( string.format("Value: +%.0f%%",fAdditionalFOV) )
	
	FOVScale = 1.0 + (fAdditionalFOV/100)
	
	if bFOVAdjustment then
		WriteFOVScaling()
	end

	
	ForceUpdate()

end

function FTSlider_Changed(Sender)

	local FrameRate = Sender:GetPosition()
	FrameTime = 1000.0 / FrameRate / 1000.0
	lblFTSlider.Caption:SetCaption( string.format("Value: %.0ffps",FrameRate) )
	
	if bFTAdjustment then
		WriteFT()
	else 
		WriteFT(true)
	end
	
	ForceUpdate()

end

function VignetteSlider_Changed(Sender)

	local Vignette = Sender:GetPosition()
	lblVignetteSlider.Caption:SetCaption( string.format("Value: %.0f%%",Vignette) )
	
	VignetteScale = 0.01 * Vignette
	
	if bVignetteAdjustment then
		WriteVignetteScaling()
	end
	
	ForceUpdate()

end



function CKAnticheat_Warning_Changed(Sender)
	bIgnoreWarning = Toggle_CheckFix(Sender)
end


function ResolutionChanged() 

	SyncDisplayDetection()

	local ResTarget = HackTool:GetAddress("ResolutionTarget")
	if ResTarget and ResTarget["Res_3840"] and ResTarget["Res_2160"] then
		ResTarget["Res_3840"]:WriteInt(DisplayInfo:GetWidth())
		ResTarget["Res_2160"]:WriteInt(DisplayInfo:GetHeight())
	end
	

end

function WriteFOVScaling() 

	local Variables = HackTool:GetAllocation("Variables")
	if Variables and Variables["FOVScale"] then
		Variables["FOVScale"]:WriteFloat(FOVScale)
	end

end

function WriteVignetteScaling() 

	local Variables = HackTool:GetAllocation("Variables")
	if Variables and Variables["VignetteScale"] then
		Variables["VignetteScale"]:WriteFloat(VignetteScale)
	end

end

function WriteFT(Default) 

	local tFTAdjustment = HackTool:GetAddress("FTAdjustment")
	if tFTAdjustment then
	
		if Default then			
			tFTAdjustment:WriteFloat(fDefaultFrameTime)
		else 
			tFTAdjustment:WriteFloat(FrameTime)
		end
	end

end

function RestoreResolution() 

	local ResTarget = HackTool:GetAddress("ResolutionTarget")
	if ResTarget and ResTarget["Res_3840"] and ResTarget["Res_2160"] then
		ResTarget["Res_3840"]:WriteInt(3840)
		ResTarget["Res_2160"]:WriteInt(2160)
	end
	

end

function Init()	
	Init_BaseControls()
	Init_Controls()
end

function DeInit()
	DisableFix()
end





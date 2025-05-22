OutputDir = "%{cfg.system}-%{cfg.architecture}/%{cfg.buildcfg}"

workspace "SDL Build Test"
   startproject "SDL"
   architecture "x64"
   configurations { "Debug", "Release", "Dist" }

   -- Workspace-wide build options for MSVC
   filter "system:windows"
      buildoptions { "/EHsc", "/Zc:preprocessor", "/Zc:__cplusplus" }

include "Build-SDL.lua" -- SDL build script requires SDL source

group "Core"
   include "Core/Build-Core.lua"

group ""
   include "App/Build-App.lua"

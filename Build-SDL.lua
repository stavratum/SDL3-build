-- Windows: works
-- Linux  : untested, probably won't 😳😊😊😊

local revision = "3.2.14"
local sdl      = "SDL3" .. "-" .. revision

project "SDL3"
   kind          "SharedLib"
   language      "C"
   staticruntime "off"

   targetdir("../Binaries/" .. OutputDir .. "/%{prj.name}")
   objdir(   "../Binaries/Intermediates/" .. OutputDir .. "/%{prj.name}")

   filter "system:windows"
      links { "setupapi", "winmm", "imm32", "version" }

   filter "configurations:Debug"
      runtime "Debug"
      symbols "On"

   filter "configurations:Release"
      runtime "Release"
      optimize "On"
      symbols "On"

   filter "configurations:Dist"
      runtime "Release"
      optimize "On"
      symbols "Off"

   filter {}

   --
   -- !!! DON'T TOUCH
   --

   local _files  = {}
   local _parent = ""

   local function parent(str)
      if str:sub(-1) ~= "/" then
         str = str .. "/"
      end

      _parent = str
   end

   local function file(dir)
      table.insert(_files, _parent .. dir)
   end

   local function file_recursive(path, dirs)
      table.insert(_files, _parent .. path .. "/*.c")

      for _, subdir in ipairs(dirs) do
         table.insert(_files, _parent .. path .. "/"  .. subdir .. "/*.c")
      end
   end

   includedirs {
      sdl .. "/src",
      sdl .. "/include",
      sdl .. "/include/build_config",
   }

   parent(sdl)
      file "src/*.c"
      file "src/atomic/*.c"
      file "src/audio/directsound/*.c"
      file "src/cpuinfo/*.c"
      file "src/dynapi/*.c"
      file "src/events/*.c"
      
      file_recursive("src/audio",      { "directsound", "disk", "dummy", "wasapi" })
      file_recursive("src/camera",     { "dummy", "mediafoundation" })
      file_recursive("src/core",       { "windows" })
      file_recursive("src/dialog",     { "windows" })
      file_recursive("src/filesystem", { "windows" })
      file_recursive("src/io",         { "windows", "generic" })
      file_recursive("src/gpu",        { "d3d12", "vulkan" })
      file_recursive("src/haptic",     { "dummy", "windows" })
      file_recursive("src/hidapi/",    { "hidapi" })
      file_recursive("src/joystick",   {
         "windows", 
         "dummy", 
         "gdk", 
         "hidapi", 
         "virtual",
      })

      file "src/libm/s_modf.c"
      file "src/stdlib/*.c"

      file_recursive("src/loadso",  { "windows" })
      file_recursive("src/locale",  { "windows" })
      file_recursive("src/main",    { "windows", "generic" })
      file_recursive("src/misc",    { "windows" })
      file_recursive("src/power",   { "windows" })
      file_recursive("src/process", { "windows" })

      file_recursive("src/render", {
         "direct3d",
         "direct3d11",
         "direct3d12",
         "opengl",
         "opengles2",
         "software",
         "vulkan",
         "gpu",
      })

      file "src/thread/generic/SDL_syscond.c"
      file "src/thread/generic/SDL_sysrwlock.c"

      file_recursive("src/sensor",  { "windows", "dummy" })
      file_recursive("src/storage", { "steam", "generic" })
      file_recursive("src/thread",  { "windows" })
      file_recursive("src/time",    { "windows" })
      file_recursive("src/timer",   { "windows" })
      file_recursive("src/tray",    { "windows" })
      file_recursive("src/video",   {
         "windows",
         "dummy",
         "intrin",
         "khronos/vulkan",
         "offscreen",
         "yuv2rgb"
      })
   files(_files)
## How to install a mod

There's ample documentation on how to install starbound mods, but I thought I'd
keep a local succinct version here to link for my mods.

1. Find your starbound mods directory

   Assuming you downloaded Starbound on steam your windows path will likely be:  
   `C:\Program Files (x86)\Steam\steamapps\common\Starbound\mods`

   and linux: `~/.steam/steam/steamapps/common/Starbound/mods`

2. Find the latest release for the mod you're trying to install

   e.g.
   https://github.com/olsonpm/starbound_health-monitor/releases/latest

3. Download the `<mod>_and-deps.zip` file and unzip it into your mods directory.
   If you're asked whether to overwrite existing files, click `[Yes]`

   *If there's no zip file that means the mod doesn't have any dependencies.*
   *In that case just download the &#42;.pak file and place it into your mods*
   *directory and you're done.  Ez Peasy.*

   e.g.
   download `health-monitor_and-deps.zip`  

   and after you unzip it your mods directory will look like
   ```
   mods\
     health-monitor.pak
     lua-hooks.pak
     quest-scope-hook.pak
   ```

<br>
<strong>If you have any issues please let me know.  I want this to be simple :)</strong>

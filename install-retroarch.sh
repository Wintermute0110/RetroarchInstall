#!/bin/bash
#

# Load paths configuration
source path_configuration

# --- Install LibRetro cores and info files ---
echo "Creating RetroArch stuff directory..."
mkdir -p ${PATH_RETROARCH_STUFF}

echo "Creating RetroArch configuration directory..."
mkdir -p ${RETROARCH_CFG_DIR}

# --- Create RetroArch paths ---
# See https://github.com/libretro/RetroArch/blob/master/fetch-submodules.sh
# Use same order as create-retroarch-default-config.py (alphabetical by configuration name).
echo "Creating RetroArch stuff directories..."
mkdir -p ${PATH_RETROARCH_STUFF}/assets/             # Option assets_directory
mkdir -p ${PATH_RETROARCH_STUFF}/audio_filters/      # Option audio_filter_dir
mkdir -p ${PATH_RETROARCH_STUFF}/cache/              # Option cache_directory
mkdir -p ${PATH_RETROARCH_STUFF}/libretrodb/cht/     # Option cheat_database_path
mkdir -p ${PATH_RETROARCH_STUFF}/libretrodb/rdb/     # Option content_database_path
                                                     # Option content_history_dir
mkdir -p ${PATH_RETROARCH_STUFF}/downloads/          # Option core_assets_directory
                                                     # Option core_options_path
mkdir -p ${PATH_RETROARCH_STUFF}/libretrodb/cursors/ # Option cursor_directory
mkdir -p ${PATH_RETROARCH_STUFF}/wallpapers/         # Option dynamic_wallpapers_directory
mkdir -p ${PATH_RETROARCH_STUFF}/input_remappings/   # Option input_remapping_directory
mkdir -p ${PATH_RETROARCH_STUFF}/joypad_autoconfig/  # Option joypad_autoconfig_dir
mkdir -p ${PATH_LIBRETRO}                            # Option libretro_directory
mkdir -p ${PATH_RETROARCH_STUFF}/info/               # Option libretro_info_path
mkdir -p ${PATH_RETROARCH_STUFF}/logs/               # Option log_dir
mkdir -p ${PATH_RETROARCH_STUFF}/overlays/           # Option overlay_directory
mkdir -p ${PATH_RETROARCH_STUFF}/playlists/          # Option playlist_directory
mkdir -p ${PATH_RETROARCH_STUFF}/recording_config/   # Option recording_config_directory
mkdir -p ${PATH_RETROARCH_STUFF}/recording_output/   # Option recording_output_directory
mkdir -p ${PATH_RETROARCH_STUFF}/resampler/          # Option resampler_directory
                                                     # Option rgui_browser_directory (ROMs path)
mkdir -p ${PATH_RETROARCH_STUFF}/configurations/     # Option rgui_config_directory
mkdir -p ${PATH_RETROARCH_STUFF}/runtime_log/        # Option runtime_log_directory
mkdir -p ${PATH_RETROARCH_STUFF}/savefiles/          # Option savefile_directory
mkdir -p ${PATH_RETROARCH_STUFF}/savestates/         # Option savestate_directory
mkdir -p ${PATH_RETROARCH_STUFF}/screenshots/        # Option screenshot_directory
mkdir -p ${PATH_RETROARCH_STUFF}/system/             # Option system_directory
mkdir -p ${PATH_RETROARCH_STUFF}/thumbnails/         # Option thumbnails_directory
mkdir -p ${PATH_RETROARCH_STUFF}/video_filters/      # Option video_filter_dir
                                                     # Option video_font_path
mkdir -p ${PATH_RETROARCH_STUFF}/shaders_cg/         # Option shaders_cg

# --- Copy cores ---
# Clean the cores before copying.
# NOTE do not clean the cores because cores are downloaded with the online updater.
# echo "Cleaning old LibRetro cores..."
# rm -f ${PATH_LIBRETRO}/*.so

# echo "Installing LibRetro cores..."
# cp ./libretro-super/dist/unix/*.so ${PATH_LIBRETRO}

# --- Copy core INFO files ---
echo "Installing LibRetro core info files..."
rm -f ${PATH_RETROARCH_STUFF}/info/*.info
cp ./libretro-super/dist/info/*.info ${PATH_RETROARCH_STUFF}/info/

# --- Install Retroarch ---
# Based on Lakka retroarch installation script
# Have a look at https://github.com/libretro/Lakka/blob/lakka/packages/libretro/retroarch/package.mk
echo "Installing Retroarch binary..."
mkdir -p ${PATH_RETROARCH_BIN}
cp ./libretro-super/retroarch/retroarch ${PATH_RETROARCH_BIN}

# --- Copy Retroarch stuff (assets, databases, etc.) ---
# NOTE submodules in git does not have the .git directory.
echo "Installing shaders_cg ..."
# cp -r ./libretro-super/retroarch/media/shaders_cg/* ${PATH_RETROARCH_STUFF}/shaders_cg/
rsync -a --exclude '.git' --delete-excluded ./libretro-super/retroarch/media/shaders_cg/ ${PATH_RETROARCH_STUFF}/shaders_cg/

echo "Installing overlays ..."
rsync -a --exclude '.git' --delete-excluded ./libretro-super/retroarch/media/overlays/ ${PATH_RETROARCH_STUFF}/overlays/

echo "Installing assets ..."
rsync -a --exclude '.git' --delete-excluded ./libretro-super/retroarch/media/assets/ ${PATH_RETROARCH_STUFF}/assets/

echo "Installing joystick autoconfig ..."
rsync -a --exclude '.git' --delete-excluded ./libretro-super/retroarch/media/autoconfig/ ${PATH_RETROARCH_STUFF}/joypad_autoconfig/

echo "Installing libretrodb ..."
rsync -a --exclude '.git' --delete-excluded ./libretro-super/retroarch/media/libretrodb/ ${PATH_RETROARCH_STUFF}/libretrodb/

# --- Installing core specific stuff ---
# >> See http://wiki.libretro.com/index.php?title=PPSSPP
if [ -d ./libretro-super/libretro-ppsspp/assets/ ]; then
    echo "Installing PPSSPP assets..."
    mkdir -p ${PATH_RETROARCH_STUFF}/system/PPSSPP/
    cp -r ./libretro-super/libretro-ppsspp/assets/* ${PATH_RETROARCH_STUFF}/system/PPSSPP/
    cp -r ./libretro-super/libretro-ppsspp/flash0/* ${PATH_RETROARCH_STUFF}/system/PPSSPP/
else
    echo "WARNING: PPSSPP assets not available."
fi

# --- So long and thanks for all the fish ---
echo "Done"
exit 0

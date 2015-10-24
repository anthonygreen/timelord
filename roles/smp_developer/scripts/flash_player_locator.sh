#!/bin/bash

path_to_flash_player=$(grep -oh .*\/flash-player[a-z\-]*\/[0-9\.]* <(brew cask info flash-player-debugger) | sed s:$:/Flash\ Player.app\/Contents\/MacOS:)

flash_player_type=$(echo $path_to_flash_player | sed s:\ :\\\\\ :g | xargs ls)

echo $path_to_flash_player/$flash_player_type

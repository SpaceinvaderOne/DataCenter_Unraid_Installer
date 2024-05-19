#!/bin/bash
################################################################################
#      This file is ported from makebootable_linux used for making Unraid flash drive bootable
#      Copyright (C) 2009-2012 Kyle Hiltner (stephan@openelec.tv)
#      Copyright (C) 2016 Lime Technology
#      Copyright (C) 2024 SpaceInvaderOne
#
#      For automating the download, formatting, and boot preparation of USB drives for Unraid.
#      This script is mainly for with Unraid installations in datacenters,
#      including but not limited to Hetzner, and is compatible with any Ubuntu system.
#
#      This Program is free software; you can redistribute it and/or modify
#      it under the terms of the GNU General Public License as published by
#      the Free Software Foundation; either version 2, or (at your option)
#      any later version.
#
#      This Program is distributed in the hope that it will be useful,
#      but WITHOUT ANY WARRANTY; without even the implied warranty of
#      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#      GNU General Public License for more details.
################################################################################

unraid_ascii_art() {
    clear
    echo -e "\e[1;32m⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\e[0m"
    echo -e "\e[1;32m⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣷⣄⠀⠀⠀⠀⠀\e[0m"        
    echo -e "\e[1;32m⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣅⣹⣿⣷⣄⠀⠀⠀\e[0m"        
    echo -e "\e[1;32m⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣷⣄⠈⠳⣄⠙⢿⣿⣿⣏⢙⣿⠗⠀⠀\e[0m        \e[1;34m⢀⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⡀\e[0m"
    echo -e "\e[1;32m⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣷⣄⠙⢷⣄⠙⢿⣿⠟⠁⠀⠀⠀\e[0m        \e[1;34m⢸⣿⣿⠋⠉⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇\e[0m"
    echo -e "\e[1;32m⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠙⠳⣄⠁⠀⠀⠀⠀⠀\e[0m        \e[1;34m⠸⣿⣿⣷⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇\e[0m"
    echo -e "\e[1;32m⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⡈⠀⠀⠀⠀⠀⠀\e[0m        \e[1;34m⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\e[0m"
    echo -e "\e[1;32m⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠀⠀⠀⠀⠀⠀\e[0m         \e[38;5;208m⢠⣶⣶⣶⢶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⡄\e[0m"
    echo -e "\e[1;32m⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀\e[0m         \e[38;5;208m⢸⣿⣿⡁⠀⣹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇\e[0m"
    echo -e "\e[1;32m⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀\e[0m         \e[38;5;208m⠘⠿⠿⠿⠾⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠃\e[0m"
    echo -e "\e[1;32m⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\e[0m         \e[1;34m⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\e[0m"
    echo -e "\e[1;32m⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\e[0m         \e[1;34m⢰⣿⣿⡿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆\e[0m"
    echo -e "\e[1;32m⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\e[0m        \e[1;34m⢸⣿⣿⣄⣀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇\e[0m"
    echo -e "\e[1;32m⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\e[0m          \e[1;34m⠈⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠁\e[0m"
    echo -e "\e[1;32m⠀⠀⠀⠀⠀⠀⠉⠉⠉⠁⠀\e[0m          \e[38;5;208mUnraid Flash Drive Creator\e[0m"
echo -e "\n\n"

}

# get json from the url
fetch_json() {
    local url="$1"
    curl --silent --fail "$url"
    if [[ $? -ne 0 ]]; then
        echo -e "\e[1;31mFailed to get any data from $url. Please chack if you have interet connection and try again.\e[0m"
        exit 1
    fi
}

# get the Unraid branches
fetch_unraid_branches() {
    local url="https://unraid-dl.sfo2.cdn.digitaloceanspaces.com/creator_branches.json"
    echo "Checking available Unraid branches..."
    unraid_branches=$(fetch_json "$url")
}

# get the versions for said branch
fetch_unraid_versions() {
    local branch_url="$1"
    echo "Getting the available Unraid versions for your choosen branch..."
    unraid_versions=$(fetch_json "$branch_url")
}

# get user to choose branch
select_branch() {
    local valid=false
    while [[ $valid == false ]]; do
        echo -e "\e[1;34mAvailable Unraid branches are:\e[0m"
        branches_list=$(echo "$unraid_branches" | jq -r '. | to_entries | .[] | "\(.key + 1): \(.value.name)"')
        branches_count=$(echo "$branches_list" | wc -l)

        echo "$branches_list"

        echo -e "\e[1;32mEnter the number of the Unraid branch you wish to see Unraid versions from:\e[0m "
        read -r branch_index

        if [[ $branch_index =~ ^[0-9]+$ ]] && [[ $branch_index -ge 1 ]] && [[ $branch_index -le $branches_count ]]; then
            selected_branch_index=$((branch_index - 1))
            branch_name=$(echo "$branches_list" | sed -n "$branch_index p" | cut -d ':' -f 2 | xargs)  # trim whitespace
            branch_url=$(echo "$unraid_branches" | jq -r --arg name "$branch_name" '.[] | select(.name == $name) | .url')

            if [[ "$branch_url" =~ ^https?://.+ ]]; then
                fetch_unraid_versions "$branch_url"
                if [[ $(echo "$unraid_versions" | jq length) -eq 0 ]]; then
                    echo -e "\e[1;31mThe branch '$branch_name' currently has no versions to download. Please select another branch.\e[0m"
                    echo ""
                    echo ""
                else
                    valid=true
                    echo ""
                    echo ""
                    echo -e "\e[1;32mSelected branch -- \e[0;33m$branch_name\e[0m"
                fi
            else
                echo -e "\e[1;31mInvalid branch URL format. Please check the URL and try again.\e[0m"
            fi
        else
            echo -e "\e[1;31mInvalid selection. Please enter a valid number.\e[0m"
        fi
    done
}


# get user to choose version from said branch
select_version() {
    echo -e "\e[1;34mAvailable Unraid versions in the $branch_name branch:\e[0m"
    versions_list=$(echo "$unraid_versions" | jq -r '. | to_entries | .[] | "\(.key + 1): \(.value.name)"')
    versions_count=$(echo "$versions_list" | wc -l)

    echo "$versions_list"

    local valid=false
    while [[ $valid == false ]]; do
        echo -e "\e[1;32mEnter the number of the Unraid version you wish to install:\e[0m "
        read -r version_index

        if [[ $version_index =~ ^[0-9]+$ ]] && [[ $version_index -ge 1 ]] && [[ $version_index -le $versions_count ]]; then
            selected_version_index=$((version_index - 1))
            version_name=$(echo "$versions_list" | sed -n "$version_index p" | cut -d ':' -f 2 | xargs)  # trim whitespace
            version_url=$(echo "$unraid_versions" | jq -r --arg name "$version_name" '.[] | select(.name == $name) | .url')

            if [[ "$version_url" =~ ^https?://.+ ]]; then
                valid=true
                unraid_download_url="$version_url"
                echo ""
                echo -e "\e[1;32mSelected version-- \e[0;33m$version_name\e[0m"
            else
                echo -e "\e[1;31mInvalid version URL format. Please check the URL and try again.\e[0m"
            fi
        else
            echo -e "\e[1;31mInvalid selection. Please enter a valid number.\e[0m"
        fi
    done
}

prompt_for_url() {
    fetch_unraid_branches
    select_branch
    select_version
}

# list and select usb flash
select_usb_drive() {
    echo -e "\e[1;34mPlease pick a flash drive to install Unraid on from the available USB drives below:\e[0m"
    local IFS=$'\n'
    local count=1
    local choices=()
    local descriptions=()

    for drive in $(lsblk -S | grep -i "usb" | awk '{print $1, $4, $6}'); do
        local device_name=$(echo $drive | awk '{print $1}')
        echo -e "\e[1;36m$count) $drive\e[0m"
        choices+=("/dev/$device_name")
        descriptions+=("$drive")
        let count+=1
    done

    if [ ${#choices[@]} -eq 0 ]; then
        echo -e "\e[1;31mNo USB drives detected. Please insert a USB drive and rerun the script.\e[0m"
        exit 1
    fi

    local selection
    while true; do
        echo -e "\e[1;32mSelect the drive number to format and use (1-${#choices[@]}): \e[0m"
        read selection
        if [[ $selection -ge 1 && $selection -le ${#choices[@]} ]]; then
            flash_drive=${choices[$((selection-1))]}
            echo -e "\e[1;33mYou selected ${descriptions[$((selection-1))]}\e[0m"
            break
        else
            echo -e "\e[1;31mInvalid selection. Please choose a valid number.\e[0m"
        fi
    done

    # confirm before continue
    echo -e "\e[1;31mWARNING: All data on $flash_drive will be erased! Continue? (yes/no):\e[0m"
    local confirm
    read confirm
    if [[ $confirm != "yes" ]]; then
        echo -e "\e[1;32mOperation cancelled by the user.\e[0m"
        exit 1
    fi
    echo ""
    echo ""
}


# check and install dependencies
check_dependencies() {
    echo ""
    echo ""
    echo -e "\e[1;34mChecking for necessary dependencies...\e[0m"
    local dependencies=("parted" "wget" "unzip" "dosfstools" "mtools" "pv")
    local missing_packages=()
    for pkg in "${dependencies[@]}"; do
        if ! dpkg -s $pkg &>/dev/null; then
            echo -e "\e[1;31m$pkg could not be found and will be installed.\e[0m"
            missing_packages+=($pkg)
        else
            echo -e "\e[1;32m$pkg is already installed.\e[0m"
        fi
    done

    if [ ${#missing_packages[@]} -gt 0 ]; then
        echo -e "\e[1;33mInstalling missing packages: ${missing_packages[*]}\e[0m"
        apt-get update
        apt-get install -y "${missing_packages[@]}"
    else
        echo -e "\e[1;32mAll necessary dependencies are already installed.\e[0m"
    fi
    echo ""
    echo ""
    sleep 3
}

# make sure flash is not mounted
ensure_unmounted() {
    for partition in $(ls ${flash_drive}*); do
        if mount | grep -qs $partition; then
            echo "Unmounting $partition..."
            umount $partition
        fi
    done
}
#  format flash 
format_flash() {
    echo -e "\e[1;34mWiping all existing data on the flash drive...\e[0m"
    umount ${flash_drive}* 2>/dev/null
    wipefs -a ${flash_drive} > /dev/null 2>&1

    echo -e "\e[1;34mCreating new partition table and formatting as FAT32...\e[0m"
    # create partition table
    parted -s ${flash_drive} mklabel msdos > /dev/null
    if [ $? -ne 0 ]; then
        echo -e "\e[1;31mFailed to create partition table on ${flash_drive}\e[0m"
        exit 1
    fi

    # create partition
    parted -s ${flash_drive} mkpart primary fat32 1MiB 100% > /dev/null
    if [ $? -ne 0 ]; then
        echo -e "\e[1;31mFailed to create partition on ${flash_drive}\e[0m"
        exit 1
    fi

    parted -s ${flash_drive} set 1 boot on > /dev/null
    parted -s ${flash_drive} set 1 lba on > /dev/null

    # synchronize partition table
    partprobe ${flash_drive}

    # format partition
    local partition="${flash_drive}1"
    mkfs.vfat -F 32 -n UNRAID ${partition} > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo -e "\e[1;31mFailed to format partition ${partition}\e[0m"
        exit 1
    fi

    echo -e "\e[1;32mFlash drive formatted and labeled as UNRAID.\e[0m"
    echo ""
    echo ""
}


# download Unraid and copy to flash drive
download_unraid() {
    echo -e "\e[1;34mDownloading Unraid...\e[0m"
    wget -q --show-progress -O /tmp/unraid.zip ${unraid_download_url}

    echo -e "\e[1;34mDownload complete. Extracting...\e[0m"
    mkdir /tmp/unraid_extracted
    unzip -q -d /tmp/unraid_extracted /tmp/unraid.zip

    echo -e "\e[1;34mCopying files to flash drive...\e[0m"
    if ! mount | grep -qs "${flash_drive}1 on"; then
        mount ${flash_drive}1 /mnt
    fi
    cp -r /tmp/unraid_extracted/* /mnt

    echo -e "\e[1;34mSetting permissions on the flash drive...\e[0m"
    chmod -R 777 /mnt/*

    sync
    umount /mnt

    echo -e "\e[1;34mClean up temporary files...\e[0m"
    rm -rf /tmp/unraid.zip /tmp/unraid_extracted
    echo -e "\e[1;32mUnraid is written to the flash drive.....\e[0m"
    echo ""
    echo ""
}

# check if the server  is booted in EFI or Legacy mode
legacy_efi() {
    if [ -d /sys/firmware/efi ]; then
        echo -e "\e[1;34mCurrently, your server is booted in EFI mode (you will need to allow EFI boot later in the process).\e[0m"
    else
        echo -e "\e[1;34mCurrently, your server is booted in Legacy mode.\e[0m"
    fi
}

#  make the flash drive bootable (logic from original Unraid make_bootable_linux)
make_bootable() {
    echo -e "\e[1;34mNow making the flash drive bootable...\e[0m"

    DISTRO=$(uname -s)
    if [ "$DISTRO" != "Linux" ]; then
        echo -e "\e[1;31mFAIL: This script is only for Linux systems, aborting!\e[0m"
        exit 1
    fi

    if [ ! -b "/dev/disk/by-label/UNRAID" ]; then
        echo -e "\e[1;31mFAIL: No drive with the label UNRAID present, aborting!\e[0m"
        exit 1
    fi

    UNRAID_PARTITION=$(readlink -f /dev/disk/by-label/UNRAID)
    if [ "${UNRAID_PARTITION: -1}" != "1" ]; then
        echo -e "\e[1;31mFAIL: UnRAID Flash drive is not installed on the first partition, aborting!\e[0m"
        exit 1
    fi

    TARGET=${UNRAID_PARTITION::${#UNRAID_PARTITION}-1}

    # Temp mounting without showing output on screen
    if [ -z "$(mount | grep "$UNRAID_PARTITION on ")" ]; then
        mkdir -p /tmp/UNRAID_TMP_MOUNT
        mount ${UNRAID_PARTITION} /tmp/UNRAID_TMP_MOUNT || exit 1
    fi

    SOURCE=$(mount | grep "$UNRAID_PARTITION on " | awk '{print $3}')
    if [ ! -d "$SOURCE/syslinux" ]; then
        echo -e "\e[1;31mFAIL: Unable to locate Syslinux directory, aborting!\e[0m"
        exit 1
    fi

    if [ ! -f "$SOURCE/syslinux/syslinux_linux" ]; then
        echo -e "\e[1;31mFAIL: Syslinux installer not found, aborting!\e[0m"
        exit 1
    fi

    # display current boot mode before asking for UEFI boot mode permission
    legacy_efi

    while true; do
        echo -ne "\e[1;32mPermit UEFI boot mode [Y/N]: \e[0m"
        read BOOT
        if [[ ${BOOT^^} == N ]]; then
             [[ -d $SOURCE/EFI && ! -d $SOURCE/EFI- ]] && mv $SOURCE/EFI $SOURCE/EFI-; break
        elif [[ ${BOOT^^} == Y ]]; then
            [[ -d $SOURCE/EFI- && ! -d $SOURCE/EFI ]] && mv $SOURCE/EFI- $SOURCE/EFI; break
        else
          echo -e "\e[1;31mPlease answer Y or N\e[0m"
        fi
    done

    echo -e "\e[1;34mCopying installer files...\e[0m"
    mkdir -p /tmp/UNRAID/syslinux
    cp -rp $SOURCE/syslinux/* /tmp/UNRAID/syslinux

    umount $SOURCE
    sync
    [ -d /tmp/UNRAID_TMP_MOUNT ] && rmdir /tmp/UNRAID_TMP_MOUNT

    echo -e "\e[1;32mGetting ready to install bootloader...\e[0m"
    /tmp/UNRAID/syslinux/make_bootable_linux.sh $TARGET

    # Clean up
    rm -rf /tmp/UNRAID/syslinux
    rmdir /tmp/UNRAID &>/dev/null

    echo -e "\e[1;32mThe Unraid OS USB Flash drive is now ready.\e[0m"
    echo -e "\e[1;32mIf in a data center, you will need to reboot your server through the admin panel and set the server to boot from USB.\e[0m"
}

# check if the host is booted in EFI or Legacy mode
legacy_efi() {
    if [ -d /sys/firmware/efi ]; then
        echo -e "\e[38;5;214mCurrently, your server is booted in EFI mode (you probably should permit UEFI boot below).\e[0m"
    else
        echo -e "\e[38;5;214mCurrently, your server is booted in Legacy mode.\e[0m"
    fi
}

# run functions
check_dependencies
unraid_ascii_art
prompt_for_url
select_usb_drive
format_flash
download_unraid
ensure_unmounted
make_bootable


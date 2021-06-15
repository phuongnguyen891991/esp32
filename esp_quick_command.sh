#!/bin/sh

CONFIG_CMD="config"
BUILD_CMD="build"
FLASH_CMD="flash"
MONITOR_CMD="monitor"
MENUCONFIG_CMD="menuconfig"
PARTITION_CMD="partition_table"

SERIAL_PORT="/dev/ttyUSB0"

TOOLS_ESP="$HOME/phuong.nguyen/ESP_/esp32/components/esptool_py/esptool/esptool.py"
TOOLS_IDF="idf.py"
echo "Check environment idf tools ..."

HERE=`pwd`

print_usage()
{
    echo "Usage: $0 [OPTION...]"
    echo "    build [project name]      build the project"
    echo "    flash                     start fash firmware to dev board"
    echo "    monitor                   tracking serial control log"
    echo "    all                       start build, flash, monitor "
    echo "    help                      print usage"
}

check_exist_env()
{
    check="`which $TOOLS_IDF`"
    if [ -z "$check" ]; then
        echo "Not existed tools from here $HERE or may not set environment "
        return 0
    else
        echo "already set to here: $HERE"
        return 1
    fi
}

########### main process ############################33
# this tools will support to config, build, flash, or do all for one command monitor quickly
echo "$0 : $0"
if [ -n "$0" ]; then
    check_exist_env
    echo "Should have set-target esp32"
    $TOOLS_IDF set-target esp32

    case "$1" in
        $BUILD_CMD)
            proj_name="`echo $2`"
            echo ".................. Have request to build source"
            if [ -z "$proj_name" ]; then
                echo "Please help to know the project path !!!!"
                exit 1
            fi
            $TOOLS_IDF $BUILD_CMD
            ;;
        $FLASH_CMD)
            echo ".................. Have request to flash fw"
            $TOOLS_IDF -p $SERIAL_PORT $FLASH_CMD
            ;;
        $MONITOR_CMD)
            echo ".................. Have request to monitor serial"
            $TOOLS_IDF -p $SERIAL_PORT $MONITOR_CMD
            ;;
        "all")
            echo "Do all command in step"
            ;;
        "help")
            print_usage
            ;;
        $MENUCONFIG_CMD)
            echo ".................. Have request to make menuconfig"
            $TOOLS_IDF $MENUCONFIG_CMD
            ;;
        $PARTITION_CMD)
            echo ".................. Have request to make and show partion table"
            $TOOLS_IDF $PARTITION_CMD
            ;;
        *)
            echo "Unknow command !!!!!"
            exit 0
            ;;
    esac
else
    # this just use for the option function
    if [ "$0" = "$TOOLS_ESP" ]; then
        print_usage
    fi
fi


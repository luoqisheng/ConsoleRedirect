#!/bin/bash
sleep 6
pkill -9 -f ConsoleRedirectOSX
$HOME/ConsoleRedirect/ConsoleRedirectOSX $PWD/console.log

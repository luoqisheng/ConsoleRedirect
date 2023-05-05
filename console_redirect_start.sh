#!/bin/bash
sleep 10
pkill -9 -f ConsoleRedirectOSX
$HOME/ConsoleRedirect/ConsoleRedirectOSX $PWD/console.log

/*
 * Header: script_mod.hpp
 *
 * Description:
 *     Mod's meta header file.
 *
 * Author:
 *     Shamelessly plagiarized from CBA_A3 and ACE3 as a best practice
 *
 * Examples:
 *     in script_component.hpp
 *     #include "\overthrow_main\script_mod.hpp"
 *
 * Ref:
 *     @see https://github.com/CBATeam/CBA_A3/tree/master/addons/main
 *     @see https://github.com/acemod/ACE3/tree/master/addons/main
 *
 * Acknowledgment:
 *     All applicable licenses and copyrights remain with the original
 *     author or authors.
 *     @see https://github.com/CBATeam/CBA_A3/blob/master/LICENSE.md
 *     @see https://github.com/acemod/ACE3/blob/master/LICENSE
 */

// these settings work with CBA_A3 common macros

#define QUOTE(var1) #var1

#define MOD_NAME Overthrow

#define PREFIX overthrow_main

#define MOD_AUTHOR ARMAzac & Overthrow Community

#include "script_version.hpp"

#define VERSION MAJOR.MINOR
#define VERSION_STR MAJOR.MINOR.PATCHLVL.BUILD
#define VERSION_AR MAJOR,MINOR,PATCHLVL,BUILD

// MINIMAL required ARMA version for the addon
#define REQUIRED_VERSION 2.10

// MINIMAL required CBA_A3 version for the addon
#define REQUIRED_CBA_VERSION {3,15,8}

// MINIMAL required ACE3 version for the addon
#define REQUIRED_ACE_VERSION {3,15,1}

#define COMPONENT_NAME QUOTE(MOD_NAME - VERSION)

#ifndef VERSION_CONFIG
    #define VERSION_CONFIG version = VERSION; versionStr = QUOTE(VERSION_STR); versionAr[] = {VERSION_AR}
#endif

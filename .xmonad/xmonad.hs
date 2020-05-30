import XMonad hiding ( (|||) )

import qualified Data.Map as M
import qualified XMonad.StackSet as W

import Data.Monoid
import System.IO
import XMonad.Actions.CycleWS
import XMonad.Actions.FocusNth
import XMonad.Actions.GroupNavigation
import XMonad.Actions.Submap
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks (avoidStruts, manageDocks, ToggleStruts (..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.NoBorders (noBorders, smartBorders)
import XMonad.Layout.Tabbed
import XMonad.Layout.TwoPane (TwoPane(..))
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.Scratchpad

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ ewmh $ defaultConfig
        { borderWidth = 1
        , layoutHook = myLayoutHook
        , logHook = dynamicLogWithPP myPP { ppOutput = hPutStrLn xmproc } >> historyHook
        , manageHook = myManageHook
        , normalBorderColor  = "#333333"
        , focusedBorderColor = "#ff0000"
        , modMask = mod4Mask
        , terminal = "urxvt"
        } `additionalKeys` myKeys

myKeys =
    -- Executions
    [ ((mod4Mask, xK_Scroll_Lock), spawn "xscreensaver-command -lock")
    , ((mod4Mask .|. controlMask, xK_l), spawn "xscreensaver-command -lock")
    , ((mod4Mask .|. shiftMask, xK_f), spawn "google-chrome")
    , ((mod4Mask .|. mod1Mask .|. shiftMask, xK_f), spawn "google-chrome --user-data-dir=$HOME/.config/google-chrome/work")
    , ((mod4Mask .|. controlMask .|. shiftMask, xK_f), spawn "google-chrome --user-data-dir=$HOME/.config/google-chrome/testing")
    , ((mod4Mask .|. shiftMask, xK_v), spawn "gvim")
    , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
    , ((0, xK_Print), spawn "scrot")
    , ((mod4Mask, xK_Home), spawn "setxkbmap us -option")
    , ((mod4Mask, xK_End), spawn "setxkbmap dvorak -option caps:swapescape -option compose:ralt")
    , ((mod4Mask .|. controlMask, xK_End), spawn "sleep 1 && xset dpms force off")
    , ((mod4Mask, xK_Next), spawn "amixer -c0 sset Master 5%-")
    , ((mod4Mask, xK_Prior), spawn "amixer -c0 sset Master 5%+")
    , ((mod4Mask, xK_p), spawn "dmenu_run -nb '#000000' -nf '#ffffff' -sb '#770000' -sf '#ffffff' -fn 'Droid Sans Mono-16' -p '> '")
    , ((mod4Mask, xK_v), submap . M.fromList $ myVolKeys)
    , ((mod4Mask, xK_a), submap . M.fromList $ myLayoutKeys)
    , ((mod4Mask, xK_BackSpace), spawn "~/code/dev/bpass/bpass.sh ~/code/dev/bpass/config.txt $(xsel -op)")
    , ((mod4Mask, xK_c), scratchpadSpawnActionTerminal "urxvt")
    -- Window Manipulation
    , ((mod4Mask, xK_Escape), nextMatch History (return True))
    , ((mod1Mask, xK_Tab), windows W.focusDown)
    , ((mod1Mask .|. shiftMask, xK_Tab), windows $ W.focusUp)
    , ((mod4Mask, xK_b), sendMessage ToggleStruts)
    , ((mod1Mask, xK_F4), kill)
    -- Select ith window
    , ((mod4Mask, xK_1), focusNth 0)
    , ((mod4Mask, xK_2), focusNth 1)
    , ((mod4Mask, xK_3), focusNth 2)
    , ((mod4Mask, xK_4), focusNth 3)
    , ((mod4Mask, xK_5), focusNth 4)
    , ((mod4Mask, xK_6), focusNth 5)
    , ((mod4Mask, xK_7), focusNth 6)
    , ((mod4Mask, xK_8), focusNth 7)
    , ((mod4Mask, xK_9), focusNth 8)
    , ((mod4Mask, xK_0), focusNth 9)
    -- Workspace Manipulation
    , ((mod4Mask, xK_period), nextWS)
    , ((mod4Mask, xK_comma), prevWS)
    , ((mod4Mask .|. shiftMask, xK_period),  shiftToNext)
    , ((mod4Mask .|. shiftMask, xK_comma),    shiftToPrev)
    -- Select ith workspace
    , ((mod4Mask, xK_F1), windows $ W.greedyView "1")
    , ((mod4Mask .|. shiftMask, xK_F1), windows $ W.shift "1")
    , ((mod4Mask, xK_F2), windows $ W.greedyView "2")
    , ((mod4Mask .|. shiftMask, xK_F2), windows $ W.shift "2")
    , ((mod4Mask, xK_F3), windows $ W.greedyView "3")
    , ((mod4Mask .|. shiftMask, xK_F3), windows $ W.shift "3")
    , ((mod4Mask, xK_F4), windows $ W.greedyView "4")
    , ((mod4Mask .|. shiftMask, xK_F4), windows $ W.shift "4")
    , ((mod4Mask, xK_F5), windows $ W.greedyView "5")
    , ((mod4Mask .|. shiftMask, xK_F5), windows $ W.shift "5")
    , ((mod4Mask, xK_F6), windows $ W.greedyView "6")
    , ((mod4Mask .|. shiftMask, xK_F6), windows $ W.shift "6")
    , ((mod4Mask, xK_F7), windows $ W.greedyView "7")
    , ((mod4Mask .|. shiftMask, xK_F7), windows $ W.shift "7")
    , ((mod4Mask, xK_F8), windows $ W.greedyView "8")
    , ((mod4Mask .|. shiftMask, xK_F8), windows $ W.shift "8")
    , ((mod4Mask, xK_F9), windows $ W.greedyView "9")
    , ((mod4Mask .|. shiftMask, xK_F9), windows $ W.shift "9")
    , ((mod4Mask, xK_F10), windows $ W.greedyView "10")
    , ((mod4Mask .|. shiftMask, xK_F10), windows $ W.shift "10")
    , ((mod4Mask, xK_F11), windows $ W.greedyView "11")
    , ((mod4Mask .|. shiftMask, xK_F11), windows $ W.shift "11")
    , ((mod4Mask, xK_F12), windows $ W.greedyView "12")
    , ((mod4Mask .|. shiftMask, xK_F12), windows $ W.shift "12")
    ]

myLayoutKeys =
    [ ((0, xK_f), sendMessage $ JumpToLayout "Full")
    , ((0, xK_t), sendMessage $ JumpToLayout "Tabbed Bottom Simplest")
    , ((0, xK_a), sendMessage $ JumpToLayout "Tall")
    , ((0, xK_m), sendMessage $ JumpToLayout "Mirror Tall")
    , ((0, xK_2), sendMessage $ JumpToLayout "TwoPane")
    ]

myVolKeys =
    [ ((0, xK_v),     spawn "$HOME/.i3/mute.sh")
    , ((mod4Mask, xK_v),     spawn "$HOME/.i3/mute.sh")
    , ((0, xK_grave),     spawn "amixer sset Master 0")
    , ((0, xK_1),     spawn "amixer sset Master 10")
    , ((0, xK_2),     spawn "amixer sset Master 20")
    , ((0, xK_3),     spawn "amixer sset Master 30")
    , ((0, xK_4),     spawn "amixer sset Master 40")
    , ((0, xK_5),     spawn "amixer sset Master 50")
    , ((0, xK_6),     spawn "amixer sset Master 60")
    , ((0, xK_7),     spawn "amixer sset Master 70")
    , ((0, xK_8),     spawn "amixer sset Master 80")
    , ((0, xK_9),     spawn "amixer sset Master 90")
    , ((0, xK_0),     spawn "amixer sset Master 100")
    ]

myPP = def
           { ppCurrent = xmobarColor "yellow" "" . wrap "[" "]"
           , ppTitle = xmobarColor "#FFAAAA" "" . shorten 40
           , ppVisible = wrap "(" ")"
           , ppHidden = (\ ws -> if ws == "NSP" then "" else ws)
           , ppSep = " | "
           , ppLayout = xmobarColor "orange" "" . wrap "{" "}" .
              (\ x -> case x of
                  "Full" -> " "
                  "Tabbed Bottom Simplest" -> "-"
                  "Tall" -> "T"
                  "Mirror Tall" -> "M"
                  "TwoPane" -> "2"
                  _ -> x
              )
           , ppUrgent  = xmobarColor "red" "yellow"
           }

myLayoutHook = smartBorders $ avoidStruts $
        layoutTabbed ||| layoutFull ||| layoutTall ||| layoutMirror ||| layoutTwoCol
    where
      layoutTall = Tall 1 (3/100) (2/3)
      layoutMirror = Mirror (Tall 1 (3/100) (3/5))
      layoutFull = Full
      layoutTwoCol = TwoPane (3/100) (1/2)
      layoutTabbed = noBorders (tabbedBottom shrinkText myTabConfig)

myTabConfig = def
    { activeColor = "#cc0000"
    , activeBorderColor = "#cc0000"
    , activeTextColor = "#FFFFFF"
    , inactiveBorderColor = "#333333"
    , inactiveColor = "#333333"
    , inactiveTextColor = "#cccccc"
    , urgentBorderColor = "#cccc00"
    , urgentColor = "#cccc00"
    , urgentTextColor = "#ffffff"
    , fontName = "xft:DejaVu Sans Mono-16"
    }

myManageHook :: ManageHook
myManageHook = manageDocks
    <+> manageHook defaultConfig
    <+> (isFullscreen --> doFullFloat)
    <+> manageScratchPad

manageScratchPad :: ManageHook
manageScratchPad = scratchpadManageHook (W.RationalRect 0.1 0.1 0.75 0.75)

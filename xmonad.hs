import System.Exit
import System.IO
import XMonad
import XMonad.Actions.CycleWindows
import XMonad.Actions.FloatKeys
import XMonad.Actions.NoBorders
import XMonad.Actions.WindowBringer
import XMonad.Actions.WindowGo (raiseMaybe)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.Gaps
import XMonad.Layout.NoBorders
import XMonad.Util.Run (spawnPipe, runInTerm)

import XMonad.Config.Xfce

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

homedir = "/home/lukas"
menudir = homedir ++ "/dev/menus"
bindir  = homedir ++ "/dev/bin"

myTerminal      = "/usr/bin/sakura -e " ++ bindir ++ "/screen"
myTerminalClass = "Sakura"

-- keys-- {{{
myNumlockMask   = mod2Mask
m  = mod4Mask
ms = m .|. shiftMask
ma = m .|. mod1Mask

wskeys = [0x2b,0x1ec,0x1b9,0x1e8,0x1f8]

myKeys conf@(XConfig {XMonad.modMask = m}) = M.fromList $
    -- launch a terminal
    [ ((ms, xK_Return), raiseMaybe (runInTerm "" (bindir ++ "/screen")) (className =? myTerminalClass))
    -- launch dmenu
    , ((m,  xK_r), spawn (menudir ++ "/runmenu.sh"))
    -- close focused window 
    , ((ms, xK_c), kill)
     -- Rotate through the available layout algorithms
    , ((m,  xK_space), sendMessage NextLayout)
    --  Reset the layouts on the current workspace to default
    , ((ms, xK_space), setLayout $ XMonad.layoutHook conf)
    -- Resize viewed windows to the correct size
    , ((m,  xK_n), refresh)
    -- Move focus to the next window
    , ((m,  xK_Tab), windows W.focusDown >> windows W.swapMaster )
    , ((m,  xK_a), cycleRecentWindows [xK_Super_L] xK_a xK_s)
    , ((m,  xK_s), cycleRecentWindows [xK_Super_L] xK_s xK_a)
    {-, ((m,  xK_a), windows W.focusDown >> rotUnfocusedUp >> windows W.swapMaster)-}
    -- Move focus to the next window
    , ((m,  xK_j), windows W.focusDown)
    -- Move focus to the previous window
    , ((m,  xK_k), windows W.focusUp  )
    -- Move focus to the master window
    , ((m,  xK_m), windows W.focusMaster  )
    -- Swap the focused window and the master window
    , ((m,  xK_Return), windows W.swapMaster)
    -- Swap the focused window with the next window
    , ((ms, xK_j), windows W.swapDown  )
    -- Swap the focused window with the previous window
    , ((ms, xK_k), windows W.swapUp    )
    -- Shrink the master area
    , ((m,  xK_h), sendMessage Shrink)
    -- Expand the master area
    , ((m,  xK_l), sendMessage Expand)
    -- Push window back into tiling
    , ((m,  xK_t), withFocused $ windows . W.sink)
    -- Increment the number of windows in the master area
    , ((m,  xK_comma), sendMessage (IncMasterN 1))
    -- Deincrement the number of windows in the master area
    , ((m,  xK_period), sendMessage (IncMasterN (-1)))
    -- Quit xmonad
    , ((ms, xK_BackSpace), io (exitWith ExitSuccess))
    , ((ms, xK_q), spawn ("gksu " ++ bindir ++ "/shutdown.sh"))
    -- Restart xmonad
    , ((m,  xK_q), restart "xmonad" True)
    -- Edit config
    , ((m,  xK_e), spawn "gvim ~/.xmonad/xmonad.hs")
    -- web browser
    , ((m,  xK_w), raiseMaybe (spawn (bindir ++ "/chromium.sh")) (className =? "Chrome"))
    -- download manager
    , ((m,  xK_d), raiseMaybe (spawn ("java -jar ~/apps/'JDownloader 0.7'/JDownloader.jar")) (className =? "jd-Main"))
    -- calculator
    , ((m,  xK_c), spawn ("~/apps/speedcrunch/src/speedcrunch"))
    -- xkill
    , ((m,  xK_x), spawn ("xkill"))
    -- mpc
    , ((m,  xK_p), spawn "pidof mpd && killall mpd || mpd")
    , ((m,  xK_minus), spawn "mpc toggle")
    , ((ms, xK_period), spawn "mpc next")
    , ((ms, xK_comma), spawn "mpc prev")
    , ((ma, xK_period), spawn "mpc seek +10")
    , ((ma, xK_comma), spawn "mpc seek -10")
    , ((m,  xK_uacute), spawn (menudir ++ "/mpd.sh"))
    -- volume
    , ((m,  xK_parenright), spawn (bindir ++ "/volume.sh 2%+"))
    , ((m,  xK_section), spawn (bindir ++ "/volume.sh 2%-"))
    -- brightness
    , ((m,  xK_KP_Add), spawn (homedir ++ "/dev/colors/brightness 16"))
    , ((m,  xK_KP_Subtract), spawn (homedir ++ "/dev/colors/brightness -16"))
    , ((m,  xK_KP_Multiply), spawn (homedir ++ "/dev/colors/brightness"))
    -- invert colors
    , ((m,  xK_KP_Divide), spawn (homedir ++ "/dev/colors/invert"))
    -- parcellite
    {-, ((m, xK_semicolon), spawn (bindir ++ "/clip.py"))-}
    , ((m, xK_semicolon), spawn ("~/dev/qt/copyq/build/copyq"))
    -- fullscreen
    , ((m, xK_F12), sendMessage ToggleGaps >> withFocused toggleBorder >> refresh)
    -- floating
    , ((ms, xK_Up), withFocused (keysResizeWindow (0,40) (1,1)))
    , ((ms, xK_Down), withFocused (keysResizeWindow (0,-40) (1,1)))
    , ((ms, xK_Left), withFocused (keysResizeWindow (40,0) (1,1)))
    , ((ms, xK_Right), withFocused (keysResizeWindow (-40,0) (1,1)))
    , ((m, xK_Up), withFocused (keysMoveWindow (0,-40)))
    , ((m, xK_Down), withFocused (keysMoveWindow (0,40)))
    , ((m, xK_Left), withFocused (keysMoveWindow (-40,0)))
    , ((m, xK_Right), withFocused (keysMoveWindow (40,0)))

    {-, ((0, xK_Menu), gotoMenu)-}
    ]
    ++
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m2 .|. m, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) wskeys
        , (f, m2) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
-- }}}

-- mouse-- {{{
myMouseBindings (XConfig {XMonad.modMask = m}) = M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((m, button1), (\w -> focus w >> mouseMoveWindow w))
    -- mod-button2, Raise the window to the top of the stack
    , ((m, button2), (\w -> focus w >> windows W.swapMaster))
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((m, button3), (\w -> focus w >> mouseResizeWindow w))
    ]
-- }}}

-- layout-- {{{
{-myLayout = smartBorders $ gaps [(D,20)] $ noBorders Full ||| Mirror tiled ||| tiled-}
  {-where-}
     {-[> default tiling algorithm partitions the screen into two panes-}
     {-tiled   = Tall nmaster delta ratio-}
     {-[> The default number of windows in the master pane-}
     {-nmaster = 1-}
     {-[> Default proportion of screen occupied by master pane-}
     {-ratio   = 5/8-}
     {-[> Percent of screen to increment by when resizing panes-}
     {-delta   = 3/100-}
-- }}}

-- hooks-- {{{
myManageHook = composeAll . concat $
    [ [className =? c --> doFloat    | c <- myFloats]
    , [className =? c --> doIgnore   | c <- myIgnore]
    , [className =? c --> doShift ws | (ws,cs) <- myShifts, c <- cs]
    , [isFullscreen --> doFullFloat]
    ]
    where
    myFloats = ["Gksu", "MPlayer", "Vlc", "Gimp", "Copyq", "Wine", "desmume-cli", "jd-Main", "NO$GBA.EXE", "Speedcrunch", "Pidgin", "fontforge", "Qsimpleweb"]
    myIgnore = ["Conky", "trayer", "desktop_window"]
    myShifts = [("1",[myTerminalClass]), ("2",["Chrome"]), ("3",["Pidgin"]), ("4",["Gimp","fontforge","VirtualBox"])]
-- }}}

-- log-- {{{
{-myLogHook h = do dynamicLogWithPP $ myPP h-}

{-myPP :: Handle -> PP-}
{-myPP h = defaultPP  { ppCurrent = wrap "<fc=white,#900000> " " </fc>" -}
                     {-, ppSep     = ""-}
                     {-, ppWsSep = ""-}
                     {-, ppUrgent = wrap "<fc=black,yellow>" "!!</fc>" -}
                     {-, ppLayout = wrap " .:" ":. "-}
                     {-, ppTitle = \x -> if length(x) > 0-}
                                       {-then "<fc=white,#900000>   " ++ shorten 60 x ++ "   </fc>"-}
                                       {-else ""-}
                     {-, ppHidden = wrap " " " "-}
                     {-, ppOutput = hPutStrLn h-}
                     {-}-}
-- }}}

{-myStartupHook = return ()-}

-- main-- {{{
main = xmonad xfceConfig
-- }}}


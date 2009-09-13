import XMonad
import XMonad.Layout.Gaps
import XMonad.Layout.NoBorders
import XMonad.Util.Run (spawnPipe)
import XMonad.Hooks.DynamicLog
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.NoBorders
import XMonad.Actions.FloatKeys
import XMonad.Actions.WindowBringer
import System.Exit
import System.IO

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

menudir = "~/dev/menus"
bindir  = "~/dev/bin"

myTerminal      = "sakura -e ~/screen"
myTerminalClass = "Sakura"

-- keys-- {{{
myNumlockMask   = mod2Mask
m  = mod4Mask
ms = m .|. shiftMask
ma = m .|. mod1Mask

wskeys = [0x2b,0x1ec,0x1b9,0x1e8,0x1f8]

myKeys conf@(XConfig {XMonad.modMask = m}) = M.fromList $
    -- launch a terminal
    [ ((ms, xK_Return), runOrRaise (XMonad.terminal conf) (className =? myTerminalClass))
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
    , ((ms, xK_q), spawn ("sakura -e " ++ bindir ++ "/shutdown.sh"))
    -- Restart xmonad
    , ((m,  xK_q), restart "xmonad" True)
    -- Edit config
    , ((m,  xK_e), spawn "gvim ~/.xmonad/xmonad.hs")
    -- web browser
    , ((m,  xK_w), runOrRaise (bindir ++ "/chromium.sh") (className =? "Chrome"))
    -- download manager
    , ((m,  xK_d), runOrRaise ("java -jar ~/apps/'JDownloader 0.7'/JDownloader.jar") (className =? "jd-Main"))
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
    , ((m,  xK_parenright), spawn (bindir ++ "/volume.sh 1%+"))
    , ((m,  xK_section), spawn (bindir ++ "/volume.sh 1%-"))
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

    , ((0, xK_Menu), gotoMenu)
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
myLayout = smartBorders $ gaps [(D,20)] $ noBorders Full ||| tiled ||| Mirror tiled
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
     -- The default number of windows in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     ratio   = 5/8
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100
-- }}}

-- hooks-- {{{
myManageHook = composeAll . concat $
    [ [className =? c --> doFloat    | c <- myFloats]
    , [className =? c --> doIgnore   | c <- myIgnore]
    , [className =? c --> doShift ws | (ws,cs) <- myShifts, c <- cs]
    ]
    where
    myFloats = ["MPlayer", "Gimp", "desmume-cli", "jd-Main", "NO$GBA.EXE", "Speedcrunch", "Pidgin"]
    myIgnore = ["Conky", "trayer", "desktop_window"]
    myShifts = [("1",[myTerminalClass]), ("2",["Chrome"]), ("3",["Pidgin"])]
-- }}}

-- log-- {{{
myLogHook h = do dynamicLogWithPP $ myPP h

{-
myPP :: Handle -> PP
myPP h = defaultPP  { ppCurrent = wrap "^fg(white)^bg(#40c0e0) " " ^bg()^fg()" 
                     , ppSep     = ""
                     , ppWsSep = ""
                     , ppUrgent = wrap "^fg(white)^bg(red) " " ^bg()^fg()" 
                     , ppLayout = wrap "^fg(aquamarine2) :: " " ^fg()"
                     , ppTitle = \x -> if length(x) > 0
                                       then "^fg(white)^bg(#40c0e0)   " ++ shorten 60 x ++ "   ^bg()^fg()"
                                       else ""
                     , ppHidden = wrap "^fg(#aaaaaa) " " ^fg()"
                     , ppOutput = hPutStrLn h
                     }
-}

myPP :: Handle -> PP
myPP h = defaultPP  { ppCurrent = wrap "<fc=white,#30a0d0> " " </fc>" 
                     , ppSep     = ""
                     , ppWsSep = ""
                     , ppUrgent = wrap "<fc=white,red> " " </fc>" 
                     , ppLayout = wrap "<fc=aquamarine2> :: " " </fc>"
                     , ppTitle = \x -> if length(x) > 0
                                       then "<fc=white,#30a0d0>   " ++ shorten 60 x ++ "   </fc>"
                                       else ""
                     , ppHidden = wrap "<fc=#909090> " " </fc>"
                     , ppOutput = hPutStrLn h
                     }
-- }}}

myStartupHook = return ()

-- main-- {{{
main = do
        h <- spawnPipe "xmobar ~/.xmobarrc"
        {-h <- spawnPipe "~/dev/dzen/panel.sh"-}
        xmonad $ defaultConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = True,
        borderWidth        = 5,
        modMask            = m,
        numlockMask        = myNumlockMask,
        workspaces         = map show [1..5],
        normalBorderColor  = "#000000",
        focusedBorderColor = "#30a0d0",

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        logHook            = myLogHook h,
        startupHook        = myStartupHook
    }
-- }}}


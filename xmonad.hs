--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad
import XMonad.Layout.Gaps
import XMonad.Util.Run(spawnPipe)
import XMonad.Hooks.DynamicLog
import XMonad.Actions.WindowGo
import XMonad.Util.Scratchpad
import System.Exit
import System.IO

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

home   = "~"
menus  = home ++ "/dev/menus"
bindir = home ++ "/dev/bin"

numkeys = [0x2b,0x1ec,0x1b9,0x1e8,0x1f8]

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "sakura -e " ++ home ++ "/screen"
myTerminalClass = "Sakura"

-- Width of the window border in pixels.
--
myBorderWidth   = 5

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The mask for the numlock key. Numlock status is "masked" from the
-- current modifier status, so the keybindings will work with numlock on or
-- off. You may need to change this on some systems.
--
-- You can find the numlock modifier by running "xmodmap" and looking for a
-- modifier with Num_Lock bound to it:
--
-- > $ xmodmap | grep Num
-- > mod2        Num_Lock (0x4d)
--
-- Set numlockMask = 0 if you don't have a numlock key, or want to treat
-- numlock status separately.
--
myNumlockMask   = mod2Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = map show [1..5]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#000000"
myFocusedBorderColor = "#60b0e0"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- launch a terminal
    [ ((modMask .|. shiftMask, xK_Return), runOrRaise (XMonad.terminal conf) (className =? myTerminalClass))

    -- launch dmenu
    {-, ((modMask,               xK_p     ), spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"")-}
    , ((modMask,               xK_r     ), spawn (menus ++ "/runmenu.sh"))

    -- close focused window 
    , ((modMask .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modMask,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modMask,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modMask,               xK_Tab   ), windows W.focusDown >> windows W.swapMaster )

    -- Move focus to the next window
    , ((modMask,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modMask,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modMask,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modMask,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modMask,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modMask,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modMask,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modMask              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modMask              , xK_period), sendMessage (IncMasterN (-1)))

    -- Quit xmonad
    , ((modMask .|. shiftMask, xK_BackSpace), io (exitWith ExitSuccess))
    , ((modMask .|. shiftMask, xK_q     ), spawn ("sakura -e " ++ bindir ++ "/shutdown.sh"))

    -- Restart xmonad
    , ((modMask              , xK_q     ), restart "xmonad" True)
    
    -- Edit config
    , ((modMask              , xK_e     ), spawn "gvim ~/.xmonad/xmonad.hs")

    -- web browser
    , ((modMask,               xK_w     ), runOrRaise (bindir ++ "/chromium.sh") (className =? "Chrome"))
    
    -- download manager
    , ((modMask,               xK_d     ), runOrRaise ("java -jar ~/apps/'JDownloader 0.7'/JDownloader.jar") (className =? "jd-Main"))

    -- calculator
    , ((modMask,               xK_c     ), spawn (home ++ "/apps/speedcrunch/src/speedcrunch"))

    -- xkill
    , ((modMask,               xK_x     ), spawn ("xkill"))

    -- mpc
    , ((modMask,               xK_p      ), spawn "pidof mpd && killall mpd || mpd")
    , ((modMask,               xK_minus  ), spawn "mpc toggle")
    , ((modMask .|. shiftMask, xK_period ), spawn "mpc next")
    , ((modMask .|. shiftMask, xK_comma  ), spawn "mpc prev")
    , ((modMask .|. mod1Mask,  xK_period ), spawn "mpc seek +10")
    , ((modMask .|. mod1Mask,  xK_comma  ), spawn "mpc seek -10")
    , ((modMask,               xK_uacute ), spawn (menus ++ "/mpd.sh"))

    -- volume
    , ((modMask,               xK_parenright ), spawn (bindir ++ "/volume.sh 1%+"))
    , ((modMask,               xK_section    ), spawn (bindir ++ "/volume.sh 1%-"))

    , ((modMask,               xK_Menu  ),
                    scratchpadSpawnAction $ defaultConfig {terminal="xterm"})
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) numkeys
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2), (\w -> focus w >> windows W.swapMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))

    {-, ((modMask, xK_b),       sendMessage ToggleStruts) [> Hide top bar-}

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--

myLayout = gaps [(U,25), (D,0)] $ Full ||| tiled ||| Mirror tiled
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 2/3

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"                --> doFloat
    , className =? "Gimp"                   --> doFloat
    , className =? "desmume-cli"            --> doFloat
    , className =? "jd-Main"                --> doFloat
    , className =? "NO$GBA.EXE"             --> doFloat
    , className =? "Speedcrunch"            --> doFloat
    , className =? "Pidgin"                 --> doFloat
    , className =? "Pidgin"                 --> doShift "3"
    , className =? "Chrome"                 --> doShift "2"
    , className =? "Conky_panel"    --> doIgnore
    , className =? "trayer"         --> doIgnore
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , scratchpadManageHookDefault]

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myLogHook h = do dynamicLogWithPP $ myPP h
 
myPP :: Handle -> PP
myPP h = defaultPP  { ppCurrent = wrap "<fc=white,#60b0e0> " " </fc>" 
                     , ppSep     = ""
                     , ppWsSep = ""
                     , ppVisible = wrap "<fc=black,DarkSlateGray4> " " </fc>" 
                     , ppUrgent = wrap "<fc=white,red> " " </fc>" 
                     , ppLayout = wrap "<fc=aquamarine2,black> :: " " </fc>"
                     , ppTitle = \x -> if length(x) > 0
                                       then "<fc=white,#60b0e0>   " ++ shorten 70 x ++ "   </fc>"
                                       else ""
                     , ppHidden = wrap "<fc=#aaa,black> " " </fc>"
                     , ppOutput = hPutStrLn h
                     }

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = return ()

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
        xmproc <- spawnPipe "xmobar ~/.xmobarrc.hs"
        xmonad $ defaultConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        numlockMask        = myNumlockMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        logHook            = myLogHook xmproc,
        startupHook        = myStartupHook
    }

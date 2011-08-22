/* names of unmanaged windows */
const char *unmanaged[] = {"stalonetray", "xfce4-notifyd", 0};
/* make some space for panel window next to status text */
const char *panel_name = "stalonetray";

#define NUMCOLORS         8             // need at least 3
static const char colors[NUMCOLORS][ColLast][8] = {
   // border   foreground  background
   { "#000", "#aaa", "#000" },  // 0 = normal
   { "#06a", "#eee", "#06a" },  // 1 = selected
   { "#06a", "#fff", "#f00" },  // 2 = urgent/warning
   { "#f00", "#fff", "#f00" },  // 3 = error
   { "#000", "#5af", "#000" },
   { "#000", "#aaa", "#000" },
   { "#000", "#d00", "#000" },
   { "#e00", "#fff", "#e00" },
};

/* appearance */
static const char font[]            =
//"-*-clean-medium-r-*-*-12-*-*-*-*-*-*-*";
//"-bitstream-bitstream vera sans mono-medium-r-normal--11-0-0-0-m-0-iso8859-1";
//"-misc-droid sans mono-medium-r-normal--11-0-0-0-m-0-iso8859-1";
//"-misc-dejavu sans mono-medium-r-normal--11-0-0-0-m-0-iso8859-1";
//"-misc-liberation mono-medium-r-normal--12-0-0-0-m-0-iso8859-1";
//"-misc-novamono-medium-r-normal--11-0-0-0-m-0-iso8859-1";
//"-bitstream-charter-medium-r-normal--11-80-100-100-p-61-iso8859-1";
//"-misc-envy code r-medium-r-normal--12-0-0-0-m-0-iso8859-1";
"-misc-envy code r-medium-r-normal--12-0-0-0-m-0-*-*";
//"-misc-monaco-medium-r-normal--11-0-0-0-p-0-iso8859-1";
//"-monotype-andale mono-medium-r-normal--12-0-0-0-c-0-iso8859-1";
static const unsigned int borderpx  = 3;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const Bool showbar           = True;     /* False means no bar */
static const Bool topbar            = True;     /* False means bottom bar */

/* tagging */
static const char *tags[] = { "1", "2", "3", "4" };

static const Rule rules[] = {
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "trayer",      NULL,       NULL,       ~0,           True,        -1 },
	{ "stalonetray", NULL,       NULL,       ~0,           True,        -1 },
	{ "Sprinter",    NULL,       NULL,       ~0,           True,        -1 },
    { "Gimp",        NULL,       NULL,       1 << 2,       False,       -1 },
    { "Pidgin",      NULL,       NULL,       1 << 3,       True,        -1 },
	{ "Firefox",     NULL,       NULL,       1 << 1,       False,       -1 },
	{ "Nightly",     NULL,       NULL,       1 << 1,       False,       -1 },
	{ "Chrome",      NULL,       NULL,       1 << 1,       False,       -1 },
};

/* layout(s) */
static const float mfact      = 0.55; /* factor of master area size [0.05..0.95] */
static const Bool resizehints = True; /* True means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[M]",      monocle },
	{ "[T]",      tile },
	{ "[F]",      NULL },
};

/* key definitions */
#define MODKEY Mod4Mask
#define ALTKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* commands */
static const char *restart[]  = { "/bin/sh", "/home/lukas/apps/tiling/dwm/make.sh", NULL };

static Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY|ShiftMask,             XK_r,      spawn,          {.v = restart } },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ ALTKEY,                       XK_Tab,    focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.01} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.01} },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ ALTKEY,                       XK_F4,     killclient,     {0} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_Tab,    focusmon,       {.i = +1 } },
	{ MODKEY|ControlMask,           XK_Tab,    tagmon,         {.i = +1 } },
	{ MODKEY|ControlMask,           XK_Tab,    focusmon,       {.i = +1 } },
	TAGKEYS(                        XK_plus,                   0)
	TAGKEYS(                        XK_ecaron,                 1)
	TAGKEYS(                        XK_scaron,                 2)
	TAGKEYS(                        XK_ccaron,                 3)
	TAGKEYS(                        XK_rcaron,                 4)
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};


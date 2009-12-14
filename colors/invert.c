/* Invert display colors */
/* Compile with gcc -g -o invert invert.c -lX11 -lXxf86vm */

#include <stdlib.h>
#include <stdio.h>
#include <X11/Xlib.h>
#include <X11/extensions/xf86vmode.h>

int main(int argc, char *argv[])
{
    Display *dpy = XOpenDisplay(NULL);
    int sz, i;
    short *red, *green, *blue;

    XF86VidModeGetGammaRampSize(dpy, 0, &sz);

    red = malloc(sz * sizeof(short));
    green = malloc(sz * sizeof(short));
    blue = malloc(sz * sizeof(short));

    XF86VidModeGetGammaRamp(dpy, 0, sz, red, green, blue);

    for (i = 0; i < sz / 2; i++)
    {
        short j = sz - i - 1, tmp;

        tmp = red[i];
        red[i] = red[j];
        red[j] = tmp;

        tmp = green[i];
        green[i] = green[j];
        green[j] = tmp;

        tmp = blue[i];
        blue[i] = blue[j];
        blue[j] = tmp;
    }

    XF86VidModeSetGammaRamp(dpy, 0, sz, red, green, blue);

    return 0;
}

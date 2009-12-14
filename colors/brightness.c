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
    unsigned short *red, *green, *blue;
    int d;

    if ( argc == 1 )
        d = 0;
    else if ( argc == 2 )
        d = atoi(argv[1]);
    else
        return 1;

    XF86VidModeGetGammaRampSize(dpy, 0, &sz);

    red = malloc(sz * sizeof(unsigned short));
    green = malloc(sz * sizeof(unsigned short));
    blue = malloc(sz * sizeof(unsigned short));

    XF86VidModeGetGammaRamp(dpy, 0, sz, red, green, blue);

    if (d==0) {
        int x = 0;
        for (i = 0; i < sz; i++)
        {
            red[i] = green[i] = blue[i] = x;
            x+=sz;
        }
        printf("RESET\n");
    }
    else {
        int x = 0;
        int xx = red[1] + d;
        for (i = 0; i < sz; i++)
        {
            red[i] = green[i] = blue[i] = x;
            printf("%d|", red[i]);
            x += xx;
            if ( x <= 0 )
                x = 0;
            else if ( x > 65535 )
                x = 65535;
        }
    }

    XF86VidModeSetGammaRamp(dpy, 0, sz, red, green, blue);

    return 0;
}

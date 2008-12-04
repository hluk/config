/*
 * LCD subpixel antialiasing image resampler
 * See http://gidden.net/tom/2006/05/29/lcd-resampling/
 * Requires MagickWand from recent ImageMagick distributions.
 *
 * Copyright 2007 Tom Gidden <tom@gidden.net>
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may
 * not use this file except in compliance with the License. You may obtain
 * a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "wand/magick_wand.h"

#define throw_wand_exception(wand) {char *description;ExceptionType severity; description=MagickGetException(wand,&severity);(void) fprintf(stderr,"%s %s %ld %s\n",GetMagickModule(),description);description=(char *) MagickRelinquishMemory(description);return(-1);}

typedef struct {
  unsigned char r;
  unsigned char g;
  unsigned char b;
  unsigned char a;
} RGBA;

int get_25_pixels(RGBA *spix, RGBA *dpix, int x3, int y3, int w3, int h3)
// Gets the block of five pixels surrounding a given pixel in 'spix'
// (which has width w3 and height h3).  The block is stored in dpix, which is
// assumed to be a 5x5 (25 pixel) one-dimensional array.  Out-of-buffer
// effects are handled by using the nearest edge pixels.
{
  int x, y;

  for(y=-2; y<3; y++) {
	int yy = y + y3;

	if(yy<0)
	  yy = 0;
	else if(yy>=h3)
	  yy = h3-1;

	for(x=-2; x<3; x++) {
	  int xx = x + x3;

	  if(xx<0)
		xx = 0;
	  else if(xx>=w3)
		xx = w3-1;

	  RGBA *src = (RGBA *)((unsigned long)spix + sizeof(RGBA) * (yy*w3 + xx));
	  RGBA *dst = (RGBA *)((unsigned long)dpix + sizeof(RGBA) * ((y+2)*5 + x+2));

	  dst->r = src->r;
	  dst->g = src->g;
	  dst->b = src->b;
	  dst->a = src->a;
	}
  }

  return 0;
}

int lcd_resample(RGBA *spix, RGBA *dpix, int w3, int h3, int w, int h, int xoff, int yoff, int strength, int order)
{
  int c0, c1, c2, c3, cd;
  int r, g, b, a;
  int x, y;
  RGBA *c, *dst;

  // Initialise the weighting matrix:
  //     [c0/cd, c1/cd, c0/cd]
  //     [c2/cd, c3/cd, c2/cd]
  //     [c0/cd, c1/cd, c0/cd]
  // Strength determines the amount of LCDness of the resampling.

  switch (strength) {
  default:
  case 0: c0 = 0; c1 = 1; c2 = 2; c3 = 4; break;
  case 1: c0 = 1; c1 = 1; c2 = 1; c3 = 1; break;
  case 2: c0 = 1; c1 = 1; c2 = 2; c3 = 2; break;
  case 3: c0 = 1; c1 = 2; c2 = 4; c3 = 4; break;
  }

  // cd: denominator of the matrix.  That sounds SO dramatic.
  cd = c0*4 + c1*2 + c2*2 + c3;

  // Allocate a mini-array for the 5x5 array of source pixels
  // (potentially) used by the resampler.
  if(!(c = (RGBA *)malloc(25*sizeof(RGBA))))
	return 1;

  // Initialise the output pointer
  dst = dpix;

  switch (order) {
  case -1:
	for(y=0; y<h; y++)
	  for(x=0; x<w; x++) {
		int x3 = 2 + xoff + x * 3;
		int y3 = 2 + yoff + y * 3;

		// Get the source pixels into 'c'
		get_25_pixels(spix, c, x3, y3, w3, h3);

		// Calculate blue component from leftmost pixel block
		b =
		  c[0].b*c0 + c[5].b*c1 + c[10].b*c0 +
		  c[1].b*c2 + c[6].b*c3 + c[11].b*c2 +
		  c[2].b*c0 + c[7].b*c1 + c[12].b*c0;

		// Calculate green component from centre pixel block
		g =
		  c[1].g*c0 + c[6].g*c1 + c[11].g*c0 +
		  c[2].g*c2 + c[7].g*c3 + c[12].g*c2 +
		  c[3].g*c0 + c[8].g*c1 + c[13].g*c0;

		// Calculate red component from rightmost pixel block
		r =
		  c[2].r*c0 + c[7].r*c1 + c[12].r*c0 +
		  c[3].r*c2 + c[8].r*c3 + c[13].r*c2 +
		  c[4].r*c0 + c[9].r*c1 + c[14].r*c0;

		// Calculate alpha from the centre pixel block. XXX: This is
		// probably not the correct value, but it looks okay.
		a =
		  c[1].a*c0 + c[6].a*c1 + c[11].a*c0 +
		  c[2].a*c2 + c[7].a*c3 + c[12].a*c2 +
		  c[3].a*c0 + c[8].a*c1 + c[13].a*c0;

		// Set destination pixel.
		dst->r = r/cd;
		dst->g = g/cd;
		dst->b = b/cd;
		dst->a = a/cd;
		dst++;
	  }
	break;

  case 1:
	for(y=0; y<h; y++)
	  for(x=0; x<w; x++) {
		int x3 = 2 + xoff + x * 3;
		int y3 = 2 + yoff + y * 3;

		// Get the source pixels into 'c'
		get_25_pixels(spix, c, x3, y3, w3, h3);

		// Calculate red component from leftmost pixel block
		r =
		  c[0].r*c0 + c[5].r*c1 + c[10].r*c0 +
		  c[1].r*c2 + c[6].r*c3 + c[11].r*c2 +
		  c[2].r*c0 + c[7].r*c1 + c[12].r*c0;

		// Calculate green component from centre pixel block
		g =
		  c[1].g*c0 + c[6].g*c1 + c[11].g*c0 +
		  c[2].g*c2 + c[7].g*c3 + c[12].g*c2 +
		  c[3].g*c0 + c[8].g*c1 + c[13].g*c0;

		// Calculate blue component from rightmost pixel block
		b =
		  c[2].b*c0 + c[7].b*c1 + c[12].b*c0 +
		  c[3].b*c2 + c[8].b*c3 + c[13].b*c2 +
		  c[4].b*c0 + c[9].b*c1 + c[14].b*c0;

		// Calculate alpha from the centre pixel block. XXX: This is
		// probably not the correct value, but it looks okay.
		a =
		  c[1].a*c0 + c[6].a*c1 + c[11].a*c0 +
		  c[2].a*c2 + c[7].a*c3 + c[12].a*c2 +
		  c[3].a*c0 + c[8].a*c1 + c[13].a*c0;

		// Set destination pixel.
		dst->r = r/cd;
		dst->g = g/cd;
		dst->b = b/cd;
		dst->a = a/cd;
		dst++;
	  }
	break;

  default:
	for(y=0; y<h; y++)
	  for(x=0; x<w; x++) {
		int x3 = 2 + xoff + x * 3;
		int y3 = 2 + yoff + y * 3;

		// Get the source pixels into 'c'
		get_25_pixels(spix, c, x3, y3, w3, h3);

		// Calculate red component from centre pixel block
		r =
		  c[1].r*c0 + c[6].r*c1 + c[11].r*c0 +
		  c[2].r*c2 + c[7].r*c3 + c[12].r*c2 +
		  c[3].r*c0 + c[8].r*c1 + c[13].r*c0;

		// Calculate green component from centre pixel block
		g =
		  c[1].g*c0 + c[6].g*c1 + c[11].g*c0 +
		  c[2].g*c2 + c[7].g*c3 + c[12].g*c2 +
		  c[3].g*c0 + c[8].g*c1 + c[13].g*c0;

		// Calculate blue component from centre pixel block
		b =
		  c[1].b*c0 + c[6].b*c1 + c[11].b*c0 +
		  c[2].b*c2 + c[7].b*c3 + c[12].b*c2 +
		  c[3].b*c0 + c[8].b*c1 + c[13].b*c0;

		// Calculate alpha from the centre pixel block. XXX: This is
		// probably not the correct value, but it looks okay.
		a =
		  c[1].a*c0 + c[6].a*c1 + c[11].a*c0 +
		  c[2].a*c2 + c[7].a*c3 + c[12].a*c2 +
		  c[3].a*c0 + c[8].a*c1 + c[13].a*c0;

		// Set destination pixel.
		dst->r = r/cd;
		dst->g = g/cd;
		dst->b = b/cd;
		dst->a = a/cd;
		dst++;
	  }
	break;
  }


  // Free the source pixel buffer.
  free(c);
  return 0;
}

int usage(char *exe)
{
  printf("Usage:\n\t%s -i <fn> -o <fn> [-x <0-2>] [-y <0-2>] [-b <int>] [-s <0-3>] [-r]\n", exe);
  return 1;
}

int main(int argc, char **argv)
{
  MagickWand *wand;
  RGBA *spix, *dpix;
  int w3, h3, w, h;

  char *out_fn = NULL;
  char *in_fn = NULL;
  int strength = -1, xoff = 0, yoff = 0, order = 1, dryrun = 0;
  int ch, optlen;

  while ((ch = getopt(argc, argv, "rno:i:s:x:y:")) != -1) {
	switch (ch) {
	case 'o':
	  out_fn = (char *)malloc(optlen = strlen(optarg));
	  out_fn = strcpy(out_fn, optarg);
	  break;

	case 'i':
	  in_fn = (char *)malloc(optlen = strlen(optarg));
	  in_fn = strcpy(in_fn, optarg);
	  break;

	case 'r':
	  order = -1;
	  break;

	case 'n':
	  dryrun = 1;
	  break;

	case 's':
	  strength = atoi(optarg);
	  break;

	case 'x':
	  xoff = atoi(optarg);
	  break;

	case 'y':
	  yoff = atoi(optarg);
	  break;

	default:
	  return usage(argv[0]);
	}
  }

  if(strength<0 || strength>3) strength = 1;
  if(xoff<0 || xoff>2) xoff = 0;
  if(yoff<0 || yoff>2) yoff = 0;
  if(!out_fn) return usage(argv[0]);
  if(!in_fn) return usage(argv[0]);

  MagickWandGenesis();

  wand = NewMagickWand();

  // Load input image into wand
  if((MagickReadImage(wand, in_fn)) == MagickFalse)
	throw_wand_exception(wand);

  // The source image is 3 times the dimensions of the target
  w3 = MagickGetImageWidth(wand);
  h3 = MagickGetImageHeight(wand);

  // w and h are the dimensions of the target image.
  w = (int)(w3 / 3 + 0.5);
  h = (int)(h3 / 3 + 0.5);

  // Allocate a pixel array for the source
  if(!(spix = (RGBA *)malloc(w3*h3*sizeof(RGBA)))) {
	fprintf(stderr, "Cannot allocate %d bytes\n", ((int)w3*h3*sizeof(RGBA)));
	return(1);
  }

  // Allocate a pixel array for the target
  if(!(dpix = (RGBA *)malloc(w*h*sizeof(RGBA)))) {
	fprintf(stderr, "Cannot allocate %d bytes\n", ((int)w*h*sizeof(RGBA)));
	return(1);
  }

  // Copy the source pixels to the pixel array, in the same order (32-bit
  // pixels) as the RGBA array.
  if((MagickGetImagePixels(wand, 0, 0, w3, h3, "RGBA", CharPixel, spix)) == MagickFalse)
	throw_wand_exception(wand);

  // Perform the resample
  lcd_resample(spix, dpix, w3, h3, w, h, xoff, yoff, strength, order*!dryrun);

  // Remove the source image from the wand
  MagickRemoveImage(wand);

  // Copy the target pixels into the wand as a new image
  if((MagickConstituteImage(wand, w, h, "RGBA", CharPixel, dpix)) == MagickFalse)
	throw_wand_exception(wand);

  // Write out the wand
  if((MagickWriteImage(wand, out_fn)) == MagickFalse)
	throw_wand_exception(wand);

  // Free the pixel arrays
  free(spix);
  free(dpix);

  // Clear up
  DestroyMagickWand(wand);
  MagickWandTerminus();

  return 0;
}

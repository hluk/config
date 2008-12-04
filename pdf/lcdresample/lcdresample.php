<?php
/*
 * LCD subpixel antialiasing image resampler
 * See http://gidden.net/tom/2006/05/29/lcd-resampling/
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

function lcd_resample($src, $dst, $strength)
// Resamples an image ($src) onto another image ($dst) which should be
// 1/3rd of the width and height of $src, and true-colour.  This is done
// using an LCD RGB subpixel antialiasing algorithm.  $strength determines
// the amount of 'LCDness' of the resampling.
//
// Try something like:
//   $dst = ImageCreateTrueColor(ImageSX($src)/3, ImageSY($src)/3);
//   lcd_resample($src, $dst, 2);
//   ImageTrueColorToPalette($dst, TRUE, 255);
//   ImagePNG($dst, $output);
{

  // Get width and height of src and dst images.
  $sw = ImageSX($src);
  $sh = ImageSY($src);
  $dw = ImageSX($dst);
  $dh = ImageSY($dst);

# XXX: Should really check here that $sw == $dw/3, etc.

  // $strength controls the influence weighting factors of neighbouring
  // source pixels.  Each destination pixel "covers" 9 (3*3) source
  // pixels, but we actually look at 25 (5*5) pixels because of the RGB
  // subpixel offsets.  The influence factors ($c0..$c3) determine how
  // these pixels are used.
  switch ($strength) {
  default:
  case 0: $c0 = 0; $c1 = 1; $c2 = 2; $c3 = 4; break;
  case 1: $c0 = 1; $c1 = 1; $c2 = 1; $c3 = 1; break;
  case 2: $c0 = 1; $c1 = 1; $c2 = 2; $c3 = 2; break;
  case 3: $c0 = 1; $c1 = 2; $c2 = 4; $c3 = 4; break;
  }

  // $cd: denominator of the matrix.  That sounds SO dramatic.
  $cd = $c0*4 + $c1*2 + $c2*2 + $c3;

  // Allocate a mini-array for the 5x5 array of source pixels
  // (potentially) used by the resampler.
  $c = array();

  // Loop through all pixels in the destination image.
  for($dy=0; $dy<$dh; $dy++)
	for($dx=0; $dx<$dw; $dx++) {

	  // Calculate the coordinates for the centre pixel in the source
	  // equivalent to the current destination pixel.
	  $sx = 2 + $dx * 3;
	  $sy = 2 + $dy * 3;

	  // Get the source pixels into $c
	  _get_25_pixels($src, $c, $sx, $sy, $sw, $sh);

	  // Calculate red component from leftmost pixel block
	  $r =
		$c[0][0]*$c0 + $c[5][0]*$c1 + $c[10][0]*$c0 +
		$c[1][0]*$c2 + $c[6][0]*$c3 + $c[11][0]*$c2 +
		$c[2][0]*$c0 + $c[7][0]*$c1 + $c[12][0]*$c0;

	  // Calculate green component from centre pixel block
	  $g =
		$c[1][1]*$c0 + $c[6][1]*$c1 + $c[11][1]*$c0 +
		$c[2][1]*$c2 + $c[7][1]*$c3 + $c[12][1]*$c2 +
		$c[3][1]*$c0 + $c[8][1]*$c1 + $c[13][1]*$c0;

	  // Calculate blue component from rightmost pixel block
	  $b =
		$c[2][2]*$c0 + $c[7][2]*$c1 + $c[12][2]*$c0 +
		$c[3][2]*$c2 + $c[8][2]*$c3 + $c[13][2]*$c2 +
		$c[4][2]*$c0 + $c[9][2]*$c1 + $c[14][2]*$c0;

	  // Convert to 0..255 integers for RGB.
	  $r = intval($r/$cd);
	  $g = intval($g/$cd);
	  $b = intval($b/$cd);

	  // Set destination pixel.
	  $col = ImageColorAllocate($dst, $r, $g, $b);
	  ImageSetPixel($dst, $dx, $dy, $col);
	}
}


function _get_25_pixels($src, &$arr, $x3, $y3, $w3, $h3)
// Gets the block of five pixels surrounding a given pixel ($x3,$y3) in
// $src (which is a GD image of width w3 and height h3).  The block is
// stored in $arr, which is a 5x5 (25 pixel) one-dimensional array.
// Out-of-buffer effects are handled by using the nearest edge pixels.
{
  $x = 0;
  $y = 0;
  $arr = array();
  for($y=-2; $y<3; $y++) {
	$yy = $y + $y3;

	if($yy<0)
	  $yy = 0;
	else if($yy>=$h3)
	  $yy = $h3-1;

	for($x=-2; $x<3; $x++) {
	  $xx = $x + $x3;

	  if($xx<0)
		$xx = 0;
	  else if($xx>=$w3)
		$xx = $w3-1;

	  $c = ImageColorAt($src, $xx, $yy);
	  $arr[($x+2) + ($y+2)*5] = array(($c>>16)&0xff, ($c>>8)&0xff, ($c)&0xff);
	}
  }
}

?>
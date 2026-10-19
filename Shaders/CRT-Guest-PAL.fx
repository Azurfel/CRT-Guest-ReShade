/*

	CRT - Guest - PAL

	Copyright (C) 2018-2026 guest(r)

	Sega MS Blue Lift and Sega MD Pallete Fix fixes inspired by Azurfel

	contrast_sigmoid_inv function Copyright (C) 2020-2023 Dogway (Jose Linares)

	Incorporates many good ideas and suggestions from Dr. Venom.

	I would also like give thanks to many Libretro forums members for continuous feedback, suggestions and using the shader.

	This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License
	as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.

	This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
	without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
	See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with this program; if not,
	write to the Free Software Foundation, Inc, 59 Temple Place - STE 330, Boston, MA 02111-1307, USA.

	NTSC version ported to ReShade by DevilSingh with some help from guest(r).
	NTSC version updated to crt-guest-advanced-2025-11-30-release1 by Jobima.
	PAL passes ported to ReShade by Azurfel.
	Updated to crt-guest-advanced-2026-07-23-release1 by Jobima and Azurfel.

*/

uniform float bth <
	ui_category = "Afterglow Settings";
	ui_type = "drag";
	ui_min = 1.0;
	ui_max = 125.0;
	ui_step = 1.0;
	ui_label = "Afterglow Effect Threshold";
> = 4.0;

uniform float PR <
	ui_category = "Afterglow Settings";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 0.5;
	ui_step = 0.01;
	ui_label = "Persistence Red";
> = 0.32;

uniform float PG <
	ui_category = "Afterglow Settings";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 0.5;
	ui_step = 0.01;
	ui_label = "Persistence Green";
> = 0.32;

uniform float PB <
	ui_category = "Afterglow Settings";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 0.5;
	ui_step = 0.01;
	ui_label = "Persistence Blue";
> = 0.32;

uniform float AS <
	ui_category = "Afterglow Settings";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 0.6;
	ui_step = 0.01;
	ui_label = "Afterglow Strength";
> = 0.2;

uniform float ST <
	ui_category = "Afterglow Settings";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.01;
	ui_label = "Afterglow saturation";
> = 0.5;

uniform float CS <
	ui_category = "Color Tweaks";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 5.0;
	ui_step = 1.0;
	ui_label = "Display Gamut: sRGB | Modern | DCI | Adobe | Rec. 2020 | P3";
> = 0.0;

uniform float CP <
	ui_category = "Color Tweaks";
	ui_type = "drag";
	ui_min = -1.0;
	ui_max = 5.0;
	ui_step = 1.0;
	ui_label = "CRT Profile: EBU | P22 | SMPTE-C | Philips | Trinitron";
> = 0.0;

uniform float TNTC <
	ui_category = "Color Tweaks";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 4.0;
	ui_step = 1.0;
	ui_label = "LUT Colors: NTSC-J | Trinitron | Nec MultiSync | NTSC 1953";
> = 0.0;

uniform float LUTLOW <
	ui_category = "Color Tweaks";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 50.0;
	ui_step = 1.0;
	ui_label = "Fix LUT Dark Range";
> = 5.0;

uniform float LUTBR <
	ui_category = "Color Tweaks";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.01;
	ui_label = "Fix LUT Brightness";
> = 1.0;

uniform float WP <
	ui_category = "Color Tweaks";
	ui_type = "drag";
	ui_min = -100.0;
	ui_max = 100.0;
	ui_step = 5.0;
	ui_label = "Color Temperature %";
> = 0.0;

uniform float wp_saturation <
	ui_category = "Color Tweaks";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 2.0;
	ui_step = 0.05;
	ui_label = "Saturation Adjustment";
> = 1.0;

uniform float pre_bb <
	ui_category = "Color Tweaks";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 2.0;
	ui_step = 0.01;
	ui_label = "Brightness Adjustment";
> = 1.0;

uniform float contra <
	ui_category = "Color Tweaks";
	ui_type = "drag";
	ui_min = -2.0;
	ui_max = 2.0;
	ui_step = 0.05;
	ui_label = "Contrast Adjustment";
> = 0.0;

uniform float pre_gc <
	ui_category = "Color Tweaks";
	ui_type = "drag";
	ui_min = 0.5;
	ui_max = 1.75;
	ui_step = 0.025;
	ui_label = "Gamma Correct Adjustment";
> = 1.0;

uniform float sega_fix <
	ui_category = "Color Tweaks";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 1.0;
	ui_label = "Sega Brightness Fix";
> = 0.0;

uniform float segams <
	ui_category = "Color Tweaks";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 1.0;
	ui_label = "Sega MS Blue Lift";
> = 0.0;

uniform float segapal <
	ui_category = "Color Tweaks";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 1.0;
	ui_label = "Sega MD Pallete Fix";
> = 0.0;

uniform float BP <
	ui_category = "Color Tweaks";
	ui_type = "drag";
	ui_min = -100.0;
	ui_max = 0.0;
	ui_step = 1.0;
	ui_label = "Lower Black Level";
> = 0.0;

uniform float BP1 <
	ui_category = "Color Tweaks";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 25.0;
	ui_step = 1.0;
	ui_label = "Raise Black Level";
> = 0.0;

uniform float vigstr <
	ui_category = "Color Tweaks";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 2.0;
	ui_step = 0.05;
	ui_label = "Vignette Strength";
> = 0.0;

uniform float vigdef <
	ui_category = "Color Tweaks";
	ui_type = "drag";
	ui_min = 0.5;
	ui_max = 3.0;
	ui_step = 0.1;
	ui_label = "Vignette Size";
> = 1.0;

uniform float interr <
	ui_category = "Interlacing Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 800.0;
	ui_step = 25.0;
	ui_label = "Interlace Trigger Resolution";
> = 375.0;

uniform float interm <
	ui_category = "Interlacing Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 6.0;
	ui_step = 1.0;
	ui_label = "Interlace Mode: 0:OFF | 1-3,6:Normal | 4-5:Interpolation";
> = 2.0;

uniform float iscanb <
	ui_category = "Interlacing Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.05;
	ui_label = "Interlacing Scanline Effect ('Laced Brightness)";
> = 0.2;

uniform float intres <
	ui_category = "Resolution/Scaling Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 10.0;
	ui_step = 0.5;
	ui_label = "Internal Resolution Y: 0.5...y-dowsample divider";
> = 0.0;

uniform float downsample_levelx <
	ui_category = "Resolution/Scaling Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 2.0;
	ui_step = 0.05;
	ui_label = "Downsampling-X (High-res content, pre-scalers)";
> = 0.0;

uniform float downsample_levely <
	ui_category = "Resolution/Scaling Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 2.0;
	ui_step = 0.05;
	ui_label = "Downsampling-Y (High-res content, pre-scalers)";
> = 0.0;

uniform float iscans <
	ui_category = "Resolution/Scaling Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.05;
	ui_label = "Interlacing (Scanline) Saturation";
> = 0.25;

uniform float hiscan <
	ui_category = "Resolution/Scaling Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 1.0;
	ui_label = "High Resolution Scanlines (prepend a scaler...)";
> = 0.0;

uniform float PAL_FILT <
	ui_category = "PAL Controls";
	ui_type = "drag";
	ui_min = 1.0;
	ui_max = 4.0;
	ui_step = 1.0;
	ui_label = "PAL Connection: RF | Composite | S-Video | SCART";
> = 2.00;

uniform float filter_res <
	ui_category = "Resolution/Scaling Options";
	ui_type = "drag";
	ui_min = 0.5;
	ui_max = 8.0;
	ui_step = 0.1;
	ui_label = "Horizontal Filtering Resolution";
> = 1.0;

uniform float PHMOD <
	ui_category = "PAL Controls";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 2.0;
	ui_step = 1.0;
	ui_label = "PAL Phase: Auto | Progressive | Laced (Dot Crawl)";
> = 0.00;

uniform float ARTIFACTING <
	ui_category = "PAL Controls";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 5.0;
	ui_step = 0.1;
	ui_label = "PAL Artifacting Value";
> = 0.40;

uniform float FRINGING <
	ui_category = "PAL Controls";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 5.0;
	ui_step = 0.1;
	ui_label = "PAL Fringing Value";
> = 0.40;

uniform float SATURATION <
	ui_category = "PAL Controls";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 2.0;
	ui_step = 0.01;
	ui_label = "PAL Saturation Boost";
> = 1.05;

uniform float BRIGHTNESS <
	ui_category = "PAL Controls";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.5;
	ui_step = 0.01;
	ui_label = "PAL Brightness";
> = 1.00;

uniform float CHROMAF <
	ui_category = "PAL Controls";
	ui_type = "drag";
	ui_min = 1.0;
	ui_max = 2.0;
	ui_step = 1.00;
	ui_label = "PAL UV Chroma Filter";
> = 1.00;

uniform float DLINE <
	ui_category = "PAL Controls";
	ui_type = "drag";
	ui_min = 1.0;
	ui_max = 4.0;
	ui_step = 1.00;
	ui_label = "PAL Delay Line | Merge";
> = 2.00;

uniform float DLINEsupport <
	ui_category = "PAL Controls";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 0.0;
	ui_step = 0.00;
	ui_label = "Delay Line Info: 1:OFF  2:Authentic  3:Auth+Merge  4:Merge";
> = 0.0;

uniform float GCORR <
	ui_category = "PAL Controls";
	ui_type = "drag";
	ui_min = 1.0;
	ui_max = 2.6;
	ui_step = 0.05;
	ui_label = "PAL Y Gamma Correct";
> = 1.15;

uniform float RFNOISE <
	ui_category = "RF Noise Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.01;
	ui_label = "PAL RF Noise Frequency";
> = 0.30;

uniform float RFNOISE1 <
	ui_category = "RF Noise Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 0.7;
	ui_step = 0.01;
	ui_label = "PAL RF Noise Luma+";
> = 0.0;

uniform float RFNOISE2 <
	ui_category = "RF Noise Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 0.7;
	ui_step = 0.01;
	ui_label = "PAL RF Noise Chroma+";
> = 0.0;

uniform float pal_res <
	ui_category = "PAL Controls";
	ui_type = "drag";
	ui_min = 1.0;
	ui_max = 2.0;
	ui_step = 1.0;
	ui_label = "PAL Resolution: Connection/Core";
> = 1.0;

uniform float pal_scale <
	ui_category = "PAL Controls";
	ui_type = "drag";
	ui_min = 0.2;
	ui_max = 2.5;
	ui_step = 0.025;
	ui_label = "PAL Resolution: Scaling";
> = 1.0;

uniform float pal_chroma <
	ui_category = "PAL Controls";
	ui_type = "drag";
	ui_min = 0.5;
	ui_max = 2.5;
	ui_step = 0.05;
	ui_label = "PAL Resolution: Chroma Scaling/Bleed ";
> = 1.0;

uniform float pal_dith <
	ui_category = "PAL Controls";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 0.5;
	ui_step = 0.01;
	ui_label = "PAL Resolution: De-dithering Booster ";
> = 0.0;

uniform float pal_ring <
	ui_category = "PAL Controls";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.5;
	ui_label = "PAL Anti Ringing";
> = 0.7;

uniform float CSHARPEN <
	ui_category = "FSharpen";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 5.0;
	ui_step = 0.1;
	ui_label = "FSharpen - Sharpen Strength";
> = 0.0;

uniform float CCONTR <
	ui_category = "FSharpen";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 0.25;
	ui_step = 0.01;
	ui_label = "FSharpen - Sharpen (+ Deb) Contrast";
> = 0.05;

uniform float CDETAILS <
	ui_category = "FSharpen";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.05;
	ui_label = "FSharpen - Details sharpened";
> = 1.0;

uniform float NDEBLUR <
	ui_category = "FSharpen";
	ui_type = "drag";
	ui_min = 1.0;
	ui_max = 8.0;
	ui_step = 0.25;
	ui_label = "FSharpen - Deblur Strength";
> = 1.0;

uniform float DSMART <
	ui_category = "FSharpen";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 1.0;
	ui_label = "FSharpen - Smart 'Dithering' Deblur";
> = 0.0;

uniform float DREDGE <
	ui_category = "FSharpen";
	ui_type = "drag";
	ui_min = 0.7;
	ui_max = 1.0;
	ui_step = 0.01;
	ui_label = "FSharpen - Deblur Edges Falloff";
> = 0.9;

uniform float DSHARP <
	ui_category = "FSharpen";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 4.0;
	ui_step = 0.2;
	ui_label = "FSharpen - Deblur Extra Sharpen";
> = 0.0;


uniform float lsmooth <
	ui_category = "Raster Bloom Options";
	ui_type = "drag";
	ui_min = 0.5;
	ui_max = 1.0;
	ui_step = 0.01;
	ui_label = "Raster Bloom Effect Smoothing";
> = 0.7;

uniform float lsdev <
	ui_category = "Raster Bloom Options";
	ui_type = "drag";
	ui_min = -0.25;
	ui_max = 0.25;
	ui_step = 0.01;
	ui_label = "Raster Bloom Smoothing Bright Deviation";
> = 0.0;

uniform float OS <
	ui_category = "Raster Bloom Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 2.0;
	ui_step = 1.0;
	ui_label = "R. Bloom Overscan Mode";
> = 1.0;

uniform float blm_2 <
	ui_category = "Raster Bloom Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 20.0;
	ui_step = 1.0;
	ui_label = "Raster bloom %";
> = 0.0;

uniform float gamma_i <
	ui_category = "Gamma Options";
	ui_type = "drag";
	ui_min = 1.0;
	ui_max = 5.0;
	ui_step = 0.05;
	ui_label = "Gamma Input";
> = 2.00;

uniform float gamma_o <
	ui_category = "Gamma Options";
	ui_type = "drag";
	ui_min = 1.0;
	ui_max = 5.0;
	ui_step = 0.05;
	ui_label = "Gamma out";
> = 1.95;

uniform float HSHARPNESS <
	ui_category = "Filtering Options";
	ui_type = "drag";
	ui_min = 1.0;
	ui_max = 8.0;
	ui_step = 0.05;
	ui_label = "Horizontal Filter Range";
> = 1.6;

uniform float LIGMA_H <
	ui_category = "Filtering Options";
	ui_type = "drag";
	ui_min = 0.15;
	ui_max = 1.0;
	ui_step = 0.01;
	ui_label = "Horizontal Blur Sigma";
> = 0.5;

uniform float S_SHARP <
	ui_category = "Filtering Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 3.0;
	ui_step = 0.05;
	ui_label = "Substractive Sharpness";
> = 1.1;

uniform float MAXS <
	ui_category = "Filtering Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 0.3;
	ui_step = 0.01;
	ui_label = "Maximum Sharpness";
> = 0.21;

uniform float SSRNG <
	ui_category = "Filtering Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 4.0;
	ui_step = 0.05;
	ui_label = "Substractive Sharpness Ringing";
> = 0.3;

uniform float spike <
	ui_category = "Filtering Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 2.0;
	ui_step = 0.1;
	ui_label = "Scanline Spike Removal";
> = 1.0;

uniform float m_glow <
	ui_category = "Magic Glow Settings";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 2.0;
	ui_step = 1.0;
	ui_label = "Ordinary Glow | Magic Glow";
> = 0.0;

uniform float m_glow_cutoff <
	ui_category = "Magic Glow Settings";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 0.4;
	ui_step = 0.01;
	ui_label = "Magic Glow Cutoff";
> = 0.12;

uniform float m_glow_low <
	ui_category = "Magic Glow Settings";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 7.0;
	ui_step = 0.05;
	ui_label = "Magic Glow Low Strength";
> = 0.35;

uniform float m_glow_high <
	ui_category = "Magic Glow Settings";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 7.0;
	ui_step = 0.1;
	ui_label = "Magic Glow High Strength";
> = 5.0;

uniform float m_glow_dist <
	ui_category = "Magic Glow Settings";
	ui_type = "drag";
	ui_min = 0.2;
	ui_max = 4.0;
	ui_step = 0.05;
	ui_label = "Magic Glow Distribution";
> = 1.0;

uniform float m_glow_mask <
	ui_category = "Magic Glow Settings";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 2.0;
	ui_step = 0.025;
	ui_label = "Magic Glow Mask Strength";
> = 1.0;

uniform float FINE_GAUSS <
	ui_category = "Magic Glow Settings";
	ui_type = "drag";
	ui_min = -1.0;
	ui_max = 5.0;
	ui_step = 1.0;
	ui_label = "Fine Glow/M.Glow Sampling";
> = 1.0;

uniform float SIZEH <
	ui_category = "Glow Pass Settings";
	ui_type = "drag";
	ui_min = 1.0;
	ui_max = 50.0;
	ui_step = 1.0;
	ui_label = "Horizontal Glow Radius";
> = 6.0;

uniform float SIGMA_H <
	ui_category = "Glow Pass Settings";
	ui_type = "drag";
	ui_min = 0.2;
	ui_max = 15.0;
	ui_step = 0.05;
	ui_label = "Horizontal Glow Sigma";
> = 1.2;

uniform float SIZEV <
	ui_category = "Glow Pass Settings";
	ui_type = "drag";
	ui_min = 1.0;
	ui_max = 50.0;
	ui_step = 1.0;
	ui_label = "Vertical Glow Radius";
> = 6.0;

uniform float SIGMA_V <
	ui_category = "Glow Pass Settings";
	ui_type = "drag";
	ui_min = 0.2;
	ui_max = 15.0;
	ui_step = 0.05;
	ui_label = "Vertical Glow Sigma";
> = 1.2;

uniform float FINE_BLOOM <
	ui_category = "Bloom/Halation (Glow) Pass Settings";
	ui_type = "drag";
	ui_min = -1.0;
	ui_max = 5.0;
	ui_step = 1.0;
	ui_label = "Fine Bloom/Halation Sampling";
> = 1.0;

uniform float SIZEX <
	ui_category = "Bloom/Halation (Glow) Pass Settings";
	ui_type = "drag";
	ui_min = 1.0;
	ui_max = 50.0;
	ui_step = 1.0;
	ui_label = "Horizontal Bloom/Halation Radius";
> = 3.0;

uniform float SIGMA_X <
	ui_category = "Bloom/Halation (Glow) Pass Settings";
	ui_type = "drag";
	ui_min = 0.25;
	ui_max = 3.0;
	ui_step = 0.01;
	ui_label = "Horizontal Bloom/Halation Sigma";
> = 0.75;

uniform float SIZEY <
	ui_category = "Bloom/Halation (Glow) Pass Settings";
	ui_type = "drag";
	ui_min = 1.0;
	ui_max = 50.0;
	ui_step = 1.0;
	ui_label = "Vertical Bloom/Halation Radius";
> = 3.0;

uniform float SIGMA_Y <
	ui_category = "Bloom/Halation (Glow) Pass Settings";
	ui_type = "drag";
	ui_min = 0.25;
	ui_max = 15.0;
	ui_step = 0.025;
	ui_label = "Vertical Bloom/Halation Sigma";
> = 0.60;

uniform float glow <
	ui_category = "Brightness Settings";
	ui_type = "drag";
	ui_min = -2.0;
	ui_max = 2.0;
	ui_step = 0.01;
	ui_label = "(Magic) Glow Strength";
> = 0.08;

uniform float blm_1 <
	ui_category = "Brightness Settings";
	ui_type = "drag";
	ui_min = -2.0;
	ui_max = 2.0;
	ui_step = 0.05;
	ui_label = "Bloom Strength";
> = 0.0;

uniform float mask_bloom <
	ui_category = "Brightness Settings";
	ui_type = "drag";
	ui_min = -2.0;
	ui_max = 2.0;
	ui_step = 0.05;
	ui_label = "Mask Bloom";
> = 0.0;

uniform float bloom_dist <
	ui_category = "Brightness Settings";
	ui_type = "drag";
	ui_min = -2.0;
	ui_max = 3.0;
	ui_step = 0.05;
	ui_label = "Bloom Distribution";
> = 0.0;

uniform float halation <
	ui_category = "Brightness Settings";
	ui_type = "drag";
	ui_min = -2.0;
	ui_max = 2.0;
	ui_step = 0.025;
	ui_label = "Halation Strength";
> = 0.0;

uniform float b_mask <
	ui_category = "Brightness Settings";
	ui_type = "drag";
	ui_min = -1.0;
	ui_max = 1.0;
	ui_step = 0.025;
	ui_label = "Bloom Mask Strength";
> = 0.0;

uniform float h_mask <
	ui_category = "Brightness Settings";
	ui_type = "drag";
	ui_min = -1.0;
	ui_max = 1.0;
	ui_step = 0.025;
	ui_label = "Halation Mask Strength";
> = 0.35;

uniform float gamma_c <
	ui_category = "Brightness Settings";
	ui_type = "drag";
	ui_min = 0.5;
	ui_max = 2.0;
	ui_step = 0.025;
	ui_label = "Gamma correct";
> = 1.0;

uniform float gamma_d <
	ui_category = "Brightness Settings";
	ui_type = "drag";
	ui_min = 1.0;
	ui_max = 2.0;
	ui_step = 0.025;
	ui_label = "Complementary Gamma Correct";
> = 1.0;

uniform float brightboost1 <
	ui_category = "Brightness Settings";
	ui_type = "drag";
	ui_min = 0.25;
	ui_max = 10.0;
	ui_step = 0.05;
	ui_label = "Bright Boost Dark Pixels";
> = 1.4;

uniform float brightboost2 <
	ui_category = "Brightness Settings";
	ui_type = "drag";
	ui_min = 0.25;
	ui_max = 3.0;
	ui_step = 0.025;
	ui_label = "Bright Boost Bright Pixels";
> = 1.1;

uniform float clp <
	ui_category = "Brightness Settings";
	ui_type = "drag";
	ui_min = -1.0;
	ui_max = 1.0;
	ui_step = 0.05;
	ui_label = "Clip Saturated Color Beams";
> = 0.0;

uniform float bloomsamp <
	ui_category = "Brightness Settings";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 2.0;
	ui_step = 1.0;
	ui_label = "Bloom Pixel Sampling";
> = 0.0;

uniform float gsl <
	ui_category = "Scanline Options";
	ui_type = "drag";
	ui_min = -1.0;
	ui_max = 2.0;
	ui_step = 1.0;
	ui_label = "Scanline Type";
> = 0.0;

uniform float scanline1 <
	ui_category = "Scanline Options";
	ui_type = "drag";
	ui_min = -20.0;
	ui_max = 40.0;
	ui_step = 0.5;
	ui_label = "Scanline Beam Shape Center";
> = 6.0;

uniform float scanline2 <
	ui_category = "Scanline Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 70.0;
	ui_step = 1.0;
	ui_label = "Scanline Beam Shape Edges";
> = 8.0;

uniform float beam_min <
	ui_category = "Scanline Options";
	ui_type = "drag";
	ui_min = 0.25;
	ui_max = 10.0;
	ui_step = 0.05;
	ui_label = "Scanline Shape Dark Pixels";
> = 1.3;

uniform float beam_max <
	ui_category = "Scanline Options";
	ui_type = "drag";
	ui_min = 0.2;
	ui_max = 3.5;
	ui_step = 0.025;
	ui_label = "Scanline Shape Bright Pixels";
> = 1.0;

uniform float tds <
	ui_category = "Scanline Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 1.0;
	ui_label = "Thinner Dark Scanlines";
> = 0.0;

uniform float beam_size <
	ui_category = "Scanline Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.05;
	ui_label = "Increased Bright Scanline Beam";
> = 0.6;

uniform float scans <
	ui_category = "Scanline Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 6.0;
	ui_step = 0.1;
	ui_label = "Scanline Saturation / Mask Falloff";
> = 0.5;

uniform float scan_falloff <
	ui_category = "Scanline Options";
	ui_type = "drag";
	ui_min = 0.1;
	ui_max = 2.0;
	ui_step = 0.025;
	ui_label = "Scanline Falloff";
> = 1.0;

uniform float ssharp <
	ui_category = "Scanline Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 0.5;
	ui_step = 0.01;
	ui_label = "Smart Sharpen Scanlines";
> = 0.0;

uniform float scangamma <
	ui_category = "Scanline Options";
	ui_type = "drag";
	ui_min = 0.5;
	ui_max = 5.0;
	ui_step = 0.05;
	ui_label = "Scanline Gamma";
> = 2.4;

uniform float rolling_scan <
	ui_category = "Scanline Options";
	ui_type = "drag";
	ui_min = -1.0;
	ui_max = 1.0;
	ui_step = 0.01;
	ui_label = "Rolling Scanlines";
> = 0.0;

uniform float no_scanlines <
	ui_category = "Scanline Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.5;
	ui_step = 0.05;
	ui_label = "No-scanline Mode";
> = 0.0;

uniform float IOS <
	ui_category = "Screen Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 4.0;
	ui_step = 1.0;
	ui_label = "Integer Scaling: Odd:Y | Even:'X'+Y";
> = 0.0;

uniform float warpx <
	ui_category = "Screen Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 0.25;
	ui_step = 0.01;
	ui_label = "Curvature X (Default 0.03)";
> = 0.0;

uniform float warpy <
	ui_category = "Screen Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 0.25;
	ui_step = 0.01;
	ui_label = "Curvature Y (Default 0.04)";
> = 0.0;

uniform float c_shape <
	ui_category = "Screen Options";
	ui_type = "drag";
	ui_min = 0.05;
	ui_max = 0.6;
	ui_step = 0.05;
	ui_label = "Curvature Shape";
> = 0.25;

uniform float cbulge <
	ui_category = "Screen Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.05;
	ui_label = "Curvature 3D Effect";
> = 0.25;

uniform float overscanx <
	ui_category = "Screen Options";
	ui_type = "drag";
	ui_min = -200.0;
	ui_max = 200.0;
	ui_step = 1.0;
	ui_label = "Overscan X original Pixels";
> = 0.0;

uniform float overscany <
	ui_category = "Screen Options";
	ui_type = "drag";
	ui_min = -200.0;
	ui_max = 200.0;
	ui_step = 1.0;
	ui_label = "Overscan Y original Pixels";
> = 0.0;

uniform float VShift <
	ui_category = "Screen Options";
	ui_type = "drag";
	ui_min = -200.0;
	ui_max = 200.0;
	ui_step = 1.0;
	ui_label = "Vertical shift Y original pixels";
> = 0.0;

uniform float csize <
	ui_category = "Screen Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 0.35;
	ui_step = 0.01;
	ui_label = "Corner Size";
> = 0.0;

uniform float bsize <
	ui_category = "Screen Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 2.0;
	ui_step = 0.01;
	ui_label = "Border Size";
> = 0.0;

uniform float sborder <
	ui_category = "Screen Options";
	ui_type = "drag";
	ui_min = 0.25;
	ui_max = 2.0;
	ui_step = 0.05;
	ui_label = "Border Intensity";
> = 0.75;

uniform float barspeed <
	ui_category = "Screen Options";
	ui_type = "drag";
	ui_min = 5.0;
	ui_max = 200.0;
	ui_step = 1.0;
	ui_label = "Hum Bar Speed";
> = 50.0;

uniform float barintensity <
	ui_category = "Screen Options";
	ui_type = "drag";
	ui_min = -1.0;
	ui_max = 1.0;
	ui_step = 0.01;
	ui_label = "Hum Bar Intensity";
> = 0.0;

uniform float bardir <
	ui_category = "Screen Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 1.0;
	ui_label = "Hum Bar Direction";
> = 0.0;

uniform float shadow_msk <
	ui_category = "CRT Mask Options";
	ui_type = "drag";
	ui_min = -1.0;
	ui_max = 14.0;
	ui_step = 1.0;
	ui_label = "CRT Mask: 0:CGWG | 1-4:Lottes | 5-14:'Trinitron'";
> = 0.0;

uniform float maskstr <
	ui_category = "CRT Mask Options";
	ui_type = "drag";
	ui_min = -0.5;
	ui_max = 1.0;
	ui_step = 0.025;
	ui_label = "Mask Strength (0, 5-14)";
> = 0.3;

uniform float mcut <
	ui_category = "CRT Mask Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 2.0;
	ui_step = 0.05;
	ui_label = "Mask 5-14 Low Strength";
> = 1.1;

uniform float maskboost <
	ui_category = "CRT Mask Options";
	ui_type = "drag";
	ui_min = 1.0;
	ui_max = 3.0;
	ui_step = 0.05;
	ui_label = "CRT Mask Boost";
> = 1.0;

uniform float masksize <
	ui_category = "CRT Mask Options";
	ui_type = "drag";
	ui_min = 1.0;
	ui_max = 4.0;
	ui_step = 1.0;
	ui_label = "CRT Mask Size";
> = 1.0;

uniform float mask_zoom <
	ui_category = "CRT Mask Options";
	ui_type = "drag";
	ui_min = -10.0;
	ui_max = 6.0;
	ui_step = 1.0;
	ui_label = "CRT Mask Zoom (+ mask width)";
> = 0.0;

uniform float zoom_mask <
	ui_category = "CRT Mask Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.05;
	ui_label = "CRT Mask Zoom Sharpen (needs Mask Zoom)";
> = 0.0;

uniform float mshift <
	ui_category = "CRT Mask Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.5;
	ui_label = "(Transform to) Shadow Mask";
> = 0.0;

uniform float mask_layout <
	ui_category = "CRT Mask Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 1.0;
	ui_label = "Mask Layout Sequence: RGB or BGR (check LCD panel)";
> = 0.0;

uniform float laysh <
	ui_category = "CRT Mask Options";
	ui_type = "drag";
	ui_min = -1.0;
	ui_max = 1.0;
	ui_step = 1.0;
	ui_label = "Mask Layout Shift: GBR, RGB, BRG | GRB, RBG, BGR";
> = 0.0;

uniform float mask_drk <
	ui_category = "CRT Mask Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 2.0;
	ui_step = 0.05;
	ui_label = "Lottes maskDark";
> = 0.5;

uniform float mask_lgt <
	ui_category = "CRT Mask Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 2.0;
	ui_step = 0.05;
	ui_label = "Lottes maskBright";
> = 1.5;

uniform float mask_gamma <
	ui_category = "CRT Mask Options";
	ui_type = "drag";
	ui_min = 1.0;
	ui_max = 5.0;
	ui_step = 0.05;
	ui_label = "Mask gamma";
> = 2.4;

uniform float slotmask1 <
	ui_category = "CRT Mask Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.05;
	ui_label = "Slot Mask Strength Bright Pixels";
> = 0.0;

uniform float slotmask2 <
	ui_category = "CRT Mask Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.05;
	ui_label = "Slot Mask Strength Dark Pixels";
> = 0.0;

uniform float slotwidth <
	ui_category = "CRT Mask Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 16.0;
	ui_step = 1.0;
	ui_label = "Slot Mask Width (0:Auto)";
> = 0.0;

uniform float double_slot <
	ui_category = "CRT Mask Options";
	ui_type = "drag";
	ui_min = 1.0;
	ui_max = 4.0;
	ui_step = 1.0;
	ui_label = "Slot Mask Height: 2x1 or 4x1...";
> = 2.0;

uniform float slotms <
	ui_category = "CRT Mask Options";
	ui_type = "drag";
	ui_min = 1.0;
	ui_max = 4.0;
	ui_step = 1.0;
	ui_label = "Slot Mask Thickness";
> = 1.0;

uniform float smoothmask <
	ui_category = "CRT Mask Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 2.0;
	ui_step = 0.25;
	ui_label = "Smooth Masks in bright scanlines";
> = 0.0;

uniform float smask_mit <
	ui_category = "CRT Mask Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.05;
	ui_label = "Mitigate Slot Mask Interaction";
> = 0.0;

uniform float bmask <
	ui_category = "CRT Mask Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 0.25;
	ui_step = 0.01;
	ui_label = "Base (black) Mask Strength";
> = 0.0;

uniform float mclip <
	ui_category = "CRT Mask Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.025;
	ui_label = "Preserve Mask Strength";
> = 0.0;

uniform float pr_scan <
	ui_category = "CRT Mask Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.025;
	ui_label = "Preserve Scanline Properties";
> = 0.1;

uniform float edgemask <
	ui_category = "CRT Mask Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.1;
	ui_label = "Mitigate Mask on Edges";
> = 0.0;

uniform float dctypex <
	ui_category = "Deconvergence Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 0.75;
	ui_step = 0.05;
	ui_label = "Deconvergence Type X: 0:static | Other:dynamic";
> = 0.0;

uniform float dctypey <
	ui_category = "Deconvergence Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 0.75;
	ui_step = 0.05;
	ui_label = "Deconvergence Type Y: 0:Static | Other:Dynamic";
> = 0.0;

uniform float deconrx <
	ui_category = "Deconvergence Options";
	ui_type = "drag";
	ui_min = -15.0;
	ui_max = 15.0;
	ui_step = 0.25;
	ui_label = "Horizontal Deconvergence Red Range";
> = 0.0;

uniform float decongx <
	ui_category = "Deconvergence Options";
	ui_type = "drag";
	ui_min = -15.0;
	ui_max = 15.0;
	ui_step = 0.25;
	ui_label = "Horizontal Deconvergence Green Range";
> = 0.0;

uniform float deconbx <
	ui_category = "Deconvergence Options";
	ui_type = "drag";
	ui_min = -15.0;
	ui_max = 15.0;
	ui_step = 0.25;
	ui_label = "Horizontal Deconvergence Blue Range";
> = 0.0;

uniform float deconry <
	ui_category = "Deconvergence Options";
	ui_type = "drag";
	ui_min = -15.0;
	ui_max = 15.0;
	ui_step = 0.25;
	ui_label = "Vertical Deconvergence Red Range";
> = 0.0;

uniform float decongy <
	ui_category = "Deconvergence Options";
	ui_type = "drag";
	ui_min = -15.0;
	ui_max = 15.0;
	ui_step = 0.25;
	ui_label = "Vertical Deconvergence Green Range";
> = 0.0;

uniform float deconby <
	ui_category = "Deconvergence Options";
	ui_type = "drag";
	ui_min = -15.0;
	ui_max = 15.0;
	ui_step = 0.25;
	ui_label = "Vertical Deconvergence Blue Range";
> = 0.0;

uniform float decons <
	ui_category = "Deconvergence Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 3.0;
	ui_step = 0.1;
	ui_label = "Deconvergence Strength";
> = 1.0;

uniform float addnoised <
	ui_category = "Noise Options";
	ui_type = "drag";
	ui_min = -1.0;
	ui_max = 1.0;
	ui_step = 0.02;
	ui_label = "Add Noise";
> = 0.0;

uniform float noiseresd <
	ui_category = "Noise Options";
	ui_type = "drag";
	ui_min = 1.0;
	ui_max = 10.0;
	ui_step = 1.0;
	ui_label = "Noise Resolution";
> = 2.0;

uniform float noisetype <
	ui_category = "Noise Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 1.0;
	ui_label = "Noise Type: Colored | Luma";
> = 0.0;

uniform float post_br <
	ui_category = "Post Effects";
	ui_type = "drag";
	ui_min = 0.25;
	ui_max = 5.0;
	ui_step = 0.01;
	ui_label = "Post Brightness";
> = 1.0;

uniform float oimage <
	ui_category = "Post Effects";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.25;
	ui_label = "Show Original Image";
> = 0.0;

#include "ReShade.fxh"

#define TexSize float2(Resolution_X,Resolution_Y)
#define IptSize float2(800.00000000,600.00000000)
#define BoxSize float2(AspectSize_X,AspectSize_Y)
#define OptSize float4(BUFFER_SCREEN_SIZE,1.0/BUFFER_SCREEN_SIZE)
#define OrgSize float4(TexSize,1.0/TexSize)
#define SrcSize float4(IptSize,1.0/IptSize)
#define NewSize float4(BoxSize,1.0/BoxSize)
#define fuxcoord (texcoord*1.00001)
#define scans 1.5*scans
#define eps 1e-8
#define wts float((bloomsamp < 0.5) ? -10.0 : -12.5)
#define pii 3.14159265
#define fracoord (fuxcoord*NewSize.xy)
#define texCD(c,d) tex2Dlod(c,float4(d,0,0))
#define LumSize float4(2.0*TexSize.x,1.0*TexSize.y,1.0/(2.0*TexSize.x),1.0/(1.0*TexSize.y))
#define rgb_m float3x3(0.299,0.587,0.114,-0.14713,-0.28886,0.436,0.615,-0.51499,-0.10001)
#define yuv_m float3x3(1.000,0.000,1.13983,1.000,-0.39465,-0.58060,1.000,2.03211,0.000)
#define yiq_m float3x3(1.000,0.956,0.621,1.000,-0.272,-0.6474,1.000,-1.106,1.7046)
#define fetch_offset1(dx)  texCD(PAL_S03,tex_c+dx).xyz+texCD(PAL_S03,tex_c-dx).xyz
#define fetch_offset2(dx) float3(texCD(PAL_S03,tex_c+dx.xz).x+texCD(PAL_S03,tex_c-dx.xz).x,texCD(PAL_S03,tex_c+dx.yz).yz+texCD(PAL_S03,tex_c-dx.yz).yz)
#define sample_yuv(dx) float3(texCD(PAL_S04,tex_c+dx.xz).x+texCD(PAL_S04,tex_c-dx.xz).x,texCD(PAL_S04,tex_c+dx.yz).yz+texCD(PAL_S04,tex_c-dx.yz).yz)

#ifndef Resolution_X
#define Resolution_X 320
#endif

#ifndef Resolution_Y
#define Resolution_Y 240
#endif

#ifndef AspectSize_X
#define AspectSize_X BUFFER_SCREEN_SIZE.x
#endif

#ifndef AspectSize_Y
#define AspectSize_Y BUFFER_SCREEN_SIZE.y
#endif

#define PAL_S00 ReShade::BackBuffer

texture PAL_T0S{Width=1.0*Resolution_X;Height=Resolution_Y;Format=RGBA16F;};
sampler PAL_S0S{Texture=PAL_T0S;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=POINT ;MinFilter=POINT ;MipFilter=POINT ;};

texture PAL_T01{Width=1.0*Resolution_X;Height=Resolution_Y ;Format=RGBA16F;};
sampler PAL_S01{Texture=PAL_T01;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=POINT ;MinFilter=POINT ;MipFilter=POINT ;};

texture PAL_T02{Width=1.0*Resolution_X;Height=Resolution_Y ;Format=RGBA16F;};
sampler PAL_S02{Texture=PAL_T02;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=POINT ;MinFilter=POINT ;MipFilter=POINT ;};

texture PAL_T0I{Width=1.0*Resolution_X;Height=Resolution_Y ;Format=RGBA16F;};
sampler PAL_S0I{Texture=PAL_T0I;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=LINEAR;MinFilter=LINEAR;MipFilter=LINEAR;};

texture PAL_T03{Width=4.0*Resolution_X;Height=Resolution_Y ;Format=RGBA16F;};
sampler PAL_S03{Texture=PAL_T03;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=LINEAR;MinFilter=LINEAR;MipFilter=LINEAR;};

texture PAL_T04{Width=2.0*Resolution_X;Height=Resolution_Y ;Format=RGBA16F;};
sampler PAL_S04{Texture=PAL_T04;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=LINEAR;MinFilter=LINEAR;MipFilter=LINEAR;};

texture PAL_T05{Width=2.0*Resolution_X;Height=Resolution_Y ;Format=RGBA16F;};
sampler PAL_S05{Texture=PAL_T05;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=LINEAR;MinFilter=LINEAR;MipFilter=LINEAR;};

texture PAL_T06{Width=2.0*Resolution_X;Height=Resolution_Y ;Format=RGBA16F;};
sampler PAL_S06{Texture=PAL_T06;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=LINEAR;MinFilter=LINEAR;MipFilter=LINEAR;};

texture PAL_T07{Width=2.0*Resolution_X;Height=Resolution_Y ;Format=RGBA16F;};
sampler PAL_S07{Texture=PAL_T07;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=LINEAR;MinFilter=LINEAR;MipFilter=LINEAR;};

texture PAL_T08{Width=2.0*Resolution_X;Height=Resolution_Y ;Format=RGBA16F;};
sampler PAL_S08{Texture=PAL_T08;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=LINEAR;MinFilter=LINEAR;MipFilter=LINEAR;};

texture PAL_T09{Width=1.0*AspectSize_X;Height=Resolution_Y ;Format=RGBA16F;};
sampler PAL_S09{Texture=PAL_T09;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=LINEAR;MinFilter=LINEAR;MipFilter=LINEAR;};

texture PAL_T10{Width=1.0*800.00000000;Height=Resolution_Y ;Format=RGBA16F;};
sampler PAL_S10{Texture=PAL_T10;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=LINEAR;MinFilter=LINEAR;MipFilter=LINEAR;};

texture PAL_T11{Width=1.0*800.00000000;Height=600.00000000 ;Format=RGBA16F;};
sampler PAL_S11{Texture=PAL_T11;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=LINEAR;MinFilter=LINEAR;MipFilter=LINEAR;};

texture PAL_T12{Width=1.0*800.00000000;Height=600.00000000 ;Format=RGBA16F;};
sampler PAL_S12{Texture=PAL_T12;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=LINEAR;MinFilter=LINEAR;MipFilter=LINEAR;};

texture PAL_T13{Width=1.0*800.00000000;Height=600.00000000 ;Format=RGBA16F;};
sampler PAL_S13{Texture=PAL_T13;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=LINEAR;MinFilter=LINEAR;MipFilter=LINEAR;};

texture PAL_T14{Width=1.0*AspectSize_X;Height=AspectSize_Y;Format=RGBA16F;};
sampler PAL_S14{Texture=PAL_T14;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=LINEAR;MinFilter=LINEAR;MipFilter=LINEAR;};

texture PAL_T15{Width=1.0*AspectSize_X;Height=AspectSize_Y;Format=RGBA16F;};
sampler PAL_S15{Texture=PAL_T15;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=LINEAR;MinFilter=LINEAR;MipFilter=LINEAR;};

texture PAL_001<source="CRT-LUT-1.png";>{Width=1024;Height=32;};
sampler PAL_L01{Texture=PAL_001;};

texture PAL_002<source="CRT-LUT-2.png";>{Width=1024;Height=32;};
sampler PAL_L02{Texture=PAL_002;};

texture PAL_003<source="CRT-LUT-3.png";>{Width=1024;Height=32;};
sampler PAL_L03{Texture=PAL_003;};

texture PAL_004<source="CRT-LUT-4.png";>{Width=1024;Height=32;};
sampler PAL_L04{Texture=PAL_004;};

uniform int framecount<source="framecount";>;

float3 fix_lut(float3 lut,float3 ref)
{
	float r=length(ref);
	float l=length(lut);
	float m=max(max(ref.r,ref.g),ref.b);
	ref=normalize(lut+0.0000001)*lerp(r,l,pow(m,1.25));
	return lerp(lut,ref,LUTBR);
}

float vignette(float2 pos)
{
	float2 b=vigdef*float2(1.0,OrgSize.x/OrgSize.y)*0.125;
	pos=clamp(pos,0.0,1.0);
	pos=abs(2.0*(pos-0.5));
	float2 res=lerp(0.0.xx,1.0.xx,smoothstep(1.0.xx,1.0.xx-b,sqrt(pos)));
	res=pow(res,0.70.xx);
	return max(lerp(1.0,sqrt(res.x*res.y),vigstr),0.0);
}

float contrast(float x)
{
	return max(lerp(x,smoothstep(0,1.0,x),contra),0.0);
}

float3 pgc(float3 c)
{
	float mc = max(max(c.r,c.g),c.b);
	float mg = pow(mc, 1.0/pre_gc);
	return c * mg/(mc + 1e-8);  
}

float contrast_sigmoid_inv(float imgColor, float cont, float pivot)
{
	cont = cont - 1.0; cont = cont*cont*cont;
	float knee  = 1.0 / (1.0 + exp (cont *  pivot));
	float shldr = 1.0 / (1.0 + exp (cont * (pivot - 1.0)));
	imgColor = pivot - log(1.0 / (imgColor * (shldr - knee) + knee) - 1.0) / cont;
	return imgColor;
}

float dist(float3 A,float3 B)
{
	float r=0.5*(A.r+B.r);
	float3 d=A-B;
	float3 c=float3(2.+r,4.,3.-r);
	return sqrt(dot(c*d,d))/3.;
}

float3 plant(float3 tar,float r)
{
	float t=max(max(tar.r,tar.g),tar.b)+0.00001;
	return tar*r/t;
}

float3 fetch_pixel(float2 coord)
{
	float2 dx=float2(LumSize.z,0.0)*downsample_levelx;
	float2 dy=float2(0.0,LumSize.w)*downsample_levely;
	float2 d1=dx+dy;
	float2 d2=dx-dy;
	float sum=15.0;
	float3 result=
	3.0*texCD(PAL_S06,coord   ).rgb+2.0*texCD(PAL_S06,coord+dx).rgb+2.0*texCD(PAL_S06,coord-dx).rgb+
	2.0*texCD(PAL_S06,coord+dy).rgb+2.0*texCD(PAL_S06,coord-dy).rgb+    texCD(PAL_S06,coord+d1).rgb+
		texCD(PAL_S06,coord-d1).rgb+    texCD(PAL_S06,coord+d2).rgb+    texCD(PAL_S06,coord-d2).rgb;
	return result/sum;
}

float gauss_h(float x)
{
	float sigma=1.0/(2.0*SIGMA_H*SIGMA_H);
	return exp(-x*x*sigma);
}

float gauss_v(float x)
{
	float sigma=1.0/(2.0*SIGMA_V*SIGMA_V);
	return exp(-x*x*sigma);
}

float bloom_h(float x)
{
	float SIGMA_X2 = SIGMA_X * SIZEX / 3.0;
	float sigma=1.0/(2.0*SIGMA_X2*SIGMA_X2);
	return exp(-x*x*sigma);
}

float bloom_v(float x)
{
	float SIGMA_Y2 = SIGMA_Y * SIZEY / 3.0;
	float sigma=1.0/(2.0*SIGMA_Y2*SIGMA_Y2);
	return exp(-x*x*sigma);
}

float crthd_h(float x,float y)
{
	return exp(-x*x*y);
}

float mod(float x,float y)
{
	return x-y* floor(x/y);
}

float st0(float x)
{
	return exp2(wts*x*x);
}

float3 sw0(float x,float color,float scanline,float3 c)
{
	float3 xe=lerp(1.0.xxx+scans,1.0.xxx,c);
	float tmp=lerp(beam_min,beam_max,color);
	float ex=x*tmp;
	ex=(gsl>-0.5)?ex*ex:lerp(ex*ex,ex*ex*ex,0.4);
	return exp2(-scanline*ex*xe);
}

float3 sw1(float x,float color,float scanline,float3 c)
{
	float3 xe=lerp(1.0.xxx+scans,1.0.xxx,c);
	x=lerp(x,beam_min*x,max(x-0.4*color,0.0));
	float tmp=lerp(1.2*beam_min,beam_max,color);
	float ex=x*tmp;
	return exp2(-scanline*ex*ex*xe);
}

float3 sw2(float x,float color,float scanline,float3 c)
{
	float3 xe=lerp(1.0.xxx+scans,1.0.xxx,c);
	float tmp=lerp((2.5-0.5*color)*beam_min,beam_max,color);
	tmp=lerp(beam_max,tmp,pow(x,color+0.3));
	float ex=x*tmp;
	return exp2(-scanline*ex*ex*xe);
}

float2 overscan(float2 pos,float dx,float dy)
{
	pos=pos*2.0-1.0;
	pos*=float2(dx,dy);
	return pos*0.5+0.5;
}

float2 warp(float2 pos)
{
	pos=pos*2.0-1.0;
	pos=lerp(pos,sign(pos)*pow(abs(pos),1.0+min(15.0*float2(warpy,warpx)*cbulge.xx,cbulge.xx)),0.075+0.125*(abs(pos)+pos*pos));
	pos=lerp(pos,float2(pos.x*rsqrt(1.0-c_shape*pos.y*pos.y),pos.y*rsqrt(1.0-c_shape*pos.x*pos.x)),float2(warpx,warpy)/c_shape);
	return pos*0.5+0.5;
}

float3 gc1(float3 c)
{
	float mc=max(max(c.r,c.g),c.b);
	float mg=pow(mc,1.0/gamma_c);
	return c*mg/(mc+eps);
}

float3 rgb2yiq(float3 r)
{
	return mul(rgb_m, r);
}

float3 yiq2rgb(float3 y)
{
	return mul(yiq_m, y);
}

float3 rgb2yuv(float3 r)
{
	return mul(rgb_m, r);
}

float3 yuv2rgb(float3 y)
{
	return mul(yuv_m, y);
}
	
float edge_cycles(int line, uint frameCount)
{
	float cycles=float(line)*(-0.25);
	if( PHMOD==2.0|| PHMOD==0.0&&OrgSize.y>375.0 ){cycles+=float(framecount&7)*(-0.125);}
	return cycles;
}

float get_luma(float3 c)
{
	return dot(c,float3(0.299,0.587,0.114));
}

float swoothstep(float e0,float e1,float x)
{
	return clamp((x-e0)/(e1-e0),0.0,1.0);
}

float3 crt_mask(float2 pos,float mx,float mb)
{
	float3 mask=mask_drk;
	float3 one=1.0;
	if(shadow_msk== 0.0)
	{
	float mc=1.0-max(maskstr,0.0);
	pos.x=frac(pos.x*0.5);
	if(pos.x<0.49)
	{
	mask.r=1.0;mask.g= mc;mask.b=1.0;
	}else
	{
	mask.r= mc;mask.g=1.0;mask.b= mc;
	}
	}else
	if(shadow_msk== 1.0)
	{
	float lane=mask_lgt;
	float odd=0.0;
	if(frac(pos.x/6.0)<0.49)odd=1.0;
	if(frac((pos.y+odd)/2.0)<0.49)lane=mask_drk;
	pos.x=floor(mod(pos.x,3.0));
	if(pos.x<0.5)mask.r=mask_lgt;else
	if(pos.x<1.5)mask.g=mask_lgt;else
	mask.b= mask_lgt;
	mask*=lane;
	}else
	if(shadow_msk== 2.0)
	{
	pos.x=floor(mod(pos.x,3.0));
	if(pos.x<0.5)mask.r=mask_lgt;else
	if(pos.x<1.5)mask.g=mask_lgt;else
	mask.b= mask_lgt;
	}else
	if(shadow_msk== 3.0)
	{
	pos.x+=pos.y*3.0;
	pos.x=frac(pos.x/6.0);
	if(pos.x<0.3)mask.r=mask_lgt;else
	if(pos.x<0.6)mask.g=mask_lgt;else
	mask.b= mask_lgt;
	}else
	if(shadow_msk== 4.0)
	{
	pos.xy=floor(pos.xy*float2(1.0,0.5));
	pos.x+=pos.y*3.0;
	pos.x=frac(pos.x/6.0);
	if(pos.x<0.3)mask.r=mask_lgt;else
	if(pos.x<0.6)mask.g=mask_lgt;else
	mask.b= mask_lgt;
	}else
	if(shadow_msk== 5.0)
	{
	mask=0.0;
	pos.x=frac(pos.x/2.0);
	if(pos.x<0.49)
	{
	mask.r=1.0;
	mask.b=1.0;
	}else
	mask.g=1.0;
	mask=clamp(lerp(lerp(one,mask,mcut),lerp(one,mask,maskstr),mx),0.0,1.0);
	}else
	if(shadow_msk== 6.0)
	{
	mask=0.0;
	pos.x=floor(mod(pos.x,3.0));
	if(pos.x<0.5)mask.r=1.0;else
	if(pos.x<1.5)mask.g=1.0;else
	mask.b=1.0;
	mask=clamp(lerp(lerp(one,mask,mcut),lerp(one,mask,maskstr),mx),0.0,1.0);
	}else
	if(shadow_msk== 7.0)
	{
	mask=0.0;
	pos.x=frac(pos.x/2.0);
	if(pos.x<0.49)
	{
	mask=0.0.xxx;
	}else
	mask=1.0.xxx;
	mask=clamp(lerp(lerp(one,mask,mcut),lerp(one,mask,maskstr),mx),0.0,1.0);
	}else
	if(shadow_msk== 8.0)
	{
	mask=0.0;
	pos.x=frac(pos.x/3.0);
	if(pos.x<0.3)mask=0.0.xxx;else
	if(pos.x<0.6)mask=1.0.xxx;else
	mask=1.0.xxx;
	mask=clamp(lerp(lerp(one,mask,mcut),lerp(one,mask,maskstr),mx),0.0,1.0);
	}else
	if(shadow_msk== 9.0)
	{
	mask=0.0;
	pos.x=frac(pos.x/3.0);
	if(pos.x<0.3)mask   =0.0.xxx;else
	if(pos.x<0.6)mask.rb=1.0.xx ;else
	mask.g=1.0;
	mask=clamp(lerp(lerp(one,mask,mcut),lerp(one,mask,maskstr),mx),0.0,1.0);
	}else
	if(shadow_msk==10.0)
	{
	mask=0.0;
	pos.x=frac(pos.x*0.25);
	if(pos.x<0.2)mask  =0.0.xxx;else
	if(pos.x<0.4)mask.r=1.0    ;else
	if(pos.x<0.7)mask.g=1.0    ;else
	mask.b=1.0;
	mask=clamp(lerp(lerp(one,mask,mcut),lerp(one,mask,maskstr),mx),0.0,1.0);
	}else
	if(shadow_msk==11.0)
	{
	mask=0.0;
	pos.x=frac(pos.x*0.25);
	if(pos.x<0.2)mask.r =1.0   ;else
	if(pos.x<0.4)mask.rg=1.0.xx;else
	if(pos.x<0.7)mask.gb=1.0.xx;else
	mask.b=1.0;mask=clamp(lerp(lerp(one,mask,mcut),lerp(one,mask,maskstr),mx),0.0,1.0);
	}else
	if(shadow_msk==12.0)
	{
	mask=0.0;
	pos.x=floor(mod(pos.x,7.0));
	if(pos.x<0.5)mask  =0.0.xxx;else
	if(pos.x<2.5)mask.r=1.0    ;else
	if(pos.x<4.5)mask.g=1.0    ;else
	mask.b=1.0;
	mask=clamp(lerp(lerp(one,mask,mcut),lerp(one,mask,maskstr),mx),0.0,1.0);
	}else
	if(shadow_msk==13.0)
	{
	mask=0.0;
	pos.x=floor(mod(pos.x,6.0));
	if(pos.x<0.5)mask    =0.0.xxx;else
	if(pos.x<1.5)mask.r  =1.0    ;else
	if(pos.x<2.5)mask.rg =1.0.xx ;else
	if(pos.x<3.5)mask.rgb=1.0.xxx;else
	if(pos.x<4.5)mask.gb =1.0.xx ;else
	mask.b=1.0;
	mask=clamp(lerp(lerp(one,mask,mcut),lerp(one,mask,maskstr),mx),0.0,1.0);
	}else
	{
	mask=0.0;
	pos.x=floor(mod(pos.x,5.0));
	if(pos.x<0.5)mask    =0.0.xxx;else
	if(pos.x<1.5)mask.r  =1.0    ;else
	if(pos.x<2.5)mask.rg =1.0.xx ;else
	if(pos.x<3.5)mask.gb =1.0.xx ;else
	mask.b=1.0;
	mask=clamp(lerp(lerp(one,mask,mcut),lerp(one,mask,maskstr),mx),0.0,1.0);
	}
	if(mask_layout>0.5)mask=mask.rbg;
	float maskmin=min(min(mask.r,mask.g),mask.b);
	return (mask-maskmin)*(1.0+(maskboost-1.0)*mb)+maskmin;
}

float slt_mask(float2 pos,float m,float swidth)
{
	if  ((slotmask1+slotmask2)==0.0)return 1.0;else
	{
	pos.y=floor(pos.y/slotms);
	float mlen=swidth*2.0;
	float px=floor( mod(pos.x, 0.99999*mlen));
	float py=floor(frac(pos.y/(2.0*double_slot))*2.0*double_slot);
	float slot_dark=lerp(1.0-slotmask2,1.0-slotmask1,m);
	float slot=1.0;
	if(py==0.0&&px<swidth) slot=slot_dark;else
	if(py==double_slot&&px>=swidth) slot=slot_dark;
	return slot;
	}
}

float humbars(float pos)
{
	if  (barintensity==0.0)return 1.0;else
	{
	pos=(barintensity>=0.0)?pos:(1.0-pos);
	pos=frac(pos+ mod(float(framecount),barspeed)/(barspeed-1.0));
	pos=(barintensity< 0.0)?pos:(1.0-pos);
	return (1.0-barintensity)+barintensity*pos;
	}
}

float corner(float2 pos)
{
	pos=abs(2.0*(pos-0.50));
	float2 aspect=float2(1.0,NewSize.x/NewSize.y);
	float b=bsize*0.05+0.0005;pos.y=pos.y+b*(aspect.y-1.0);
	float2 crn=max(csize.xx,2.0*b+0.0015);
	float2 crp=max(pos-(1.0-crn*aspect),0.0)/aspect;float cd=sqrt(dot(crp,crp));
	pos=max(pos,1.0-crn+cd);
	float res=lerp(1.0,0.0,smoothstep(1.0-b,1.0,sqrt(max(pos.x,pos.y))));
	return pow(res,sborder);
}

float3 declip(float3 c,float b)
{
	float m=max(max(c.r,c.g),c.b);
	if(m>b)c=c*b/m;
	return c;
}

float igc(float mc)
{
	return pow(mc,gamma_c);
}

float3 gc2(float3 c,float w3)
{
	float mc=max(max(c.r,c.g),c.b);
	float p=1.0/(1.0+(gamma_d-1.0)* lerp(0.375,1.0,w3));
	float mg=pow(mc, p );
	return c*mg/(mc+eps);
}

float3 noise(float3 v)
{
	if(addnoised<0.0)v.z=-addnoised;else v.z= mod(v.z,6001.0)/1753.0;
	v =frac(v)+frac(v*1e4)+frac(v*1e-4);
	v+=float3(0.12345,0.6789,0.314159);
	v =frac(v*dot(v,v)*123.456);
	v =frac(v*dot(v,v)*123.456);
	v =frac(v*dot(v,v)*123.456);
	v =frac(v*dot(v,v)*123.456);
	return v;
}

float smothstep (float e0, float e1, float x)
{
   return clamp((x - e0) / (e1 - e0), 0.0, 1.0);
}

float2 psrnd(float2 TexCoord, float FrameCount) {
    float3 p = float3(TexCoord * 16758.5453, FrameCount);
    float x = frac(sin(dot(p, float3(12.9898, 78.233, 3.183))) * 43758.5453);
    float y = frac(sin(dot(p, float3(25.9796, 14.113, 11.271))) * 96321.9124);
    return float2(x, y);
}

float3 NoiseNP3(float2 TexCoord, float FrameCount) {
float RFNOISE0 = RFNOISE*RFNOISE + 0.00001;
    TexCoord = psrnd(TexCoord, FrameCount);
    float3 p = float3(TexCoord * 758.5453, FrameCount);
    float res1 = frac(sin(dot(p, float3(12.989835, 78.23341, 0.16453))) * 43758.54531);
    float res2 = frac(sin(dot(p, float3(39.34679, 11.13523, 83.15573))) * 39459.32423);
    float res3 = frac(sin(dot(p, float3(73.15691, 52.23504, 9.15197))) * 60493.84731);
    float lns = float(abs(res1-0.5) < 0.2*RFNOISE0);
    float cny = float(abs(res2-0.5) < 0.5*RFNOISE0);
    float cnz = float(abs(res3-0.5) < 0.5*RFNOISE0);
    lns = lns*smothstep(0.5-0.2*RFNOISE0, 0.5+0.2*RFNOISE0, res1) * 0.66 - 0.33*lns;
    cny = cny*smothstep(0.5-0.5*RFNOISE0, 0.5+0.5*RFNOISE0, res2)  - 0.5*cny;
    cnz = cnz*smothstep(0.5-0.5*RFNOISE0, 0.5+0.5*RFNOISE0, res3)  - 0.5*cnz;	
    return float3(lns, cny, cnz);
}

void bring_pixel(inout float3 c,inout float3 b,inout float3 g,float2 coord,float2 boord)
{
	float stepx=NewSize.z;
	float stepy=NewSize.w;
	float2 dx=float2(stepx,0.0);
	float2 dy=float2(0.0,stepy);
	float posx= 2.0*coord.x-1.0;
	float posy= 2.0*coord.y-1.0;
	if(dctypex>0.025)
	{
	posx= sign(posx)*pow(abs(posx),1.05-dctypex);
	dx=posx*dx;
	}
	if(dctypey>0.025)
	{
	posy= sign(posy)*pow(abs(posy),1.05-dctypey);
	dy=posy*dy;
	}
	float2 rc=deconrx*dx+deconry*dy;
	float2 gc=decongx*dx+decongy*dy;
	float2 bc=deconbx*dx+deconby*dy;
	float r1=texCD(PAL_S14,coord+rc).r;
	float g1=texCD(PAL_S14,coord+gc).g;
	float b1=texCD(PAL_S14,coord+bc).b;
	float ds=decons;
	float3 d=float3(r1,g1,b1);
	c=clamp(lerp(c,d,ds),0.0,1.0);
	r1=texCD(PAL_S13,boord+rc).r;
	g1=texCD(PAL_S13,boord+gc).g;
	b1=texCD(PAL_S13,boord+bc).b;
	d=float3(r1,g1,b1);
	b=g=lerp(b,d,min(ds,1.0));
	r1=texCD(PAL_S11,boord+rc).r;
	g1=texCD(PAL_S11,boord+gc).g;
	b1=texCD(PAL_S11,boord+bc).b;
	d=float3(r1,g1,b1);
	g=lerp(g,d,min(ds,1.0));
}

static const float2 expanse=BoxSize/ (2*OptSize.xy);
static const float2 capital=0.0/OptSize.xy+0.5;
static const float coord_w=capital.x-expanse.x;
static const float coord_e=capital.x+expanse.x;
static const float coord_n=capital.y-expanse.y;
static const float coord_s=capital.y+expanse.y;
static const float2 correct=float2(coord_w,coord_n);

void CropProcessVS(in uint id:SV_VertexID,out float4 position:SV_Position,out float2 texcoord:TEXCOORD)
{
	#if __RENDERER__ <= 0x09300
	texcoord.x=(id==1||id==3)?coord_e:coord_w;
	texcoord.y=(id>1)?coord_s:coord_n;
	position.x=(id==1||id==3)? 1:-1;
	position.y=(id>1)?-1: 1;
	position.zw=1;
	#else
	texcoord.x=(id&1)?coord_e:coord_w;
	texcoord.y=(id&2)?coord_s:coord_n;
	position.x=(id&1)? 1:-1;
	position.y=(id&2)?-1: 1;
	position.zw=1;
	#endif
}

float4 StockPassPS(float4 position:SV_Position,float2 texcoord:TEXCOORD):SV_Target
{
	return texCD(PAL_S00,texcoord);
}

float4 AfterglowPS(float4 position:SV_Position,float2 texcoord:TEXCOORD):SV_Target
{
	float2 dx=float2(OrgSize.z,0.0);
	float2 dy=float2(0.0,OrgSize.w);
	float w=1.0;
	float3 color0=texCD(PAL_S0S,texcoord   ).rgb;
	float3 color1=texCD(PAL_S0S,texcoord-dx).rgb;
	float3 color2=texCD(PAL_S0S,texcoord+dx).rgb;
	float3 color3=texCD(PAL_S0S,texcoord-dy).rgb;
	float3 color4=texCD(PAL_S0S,texcoord+dy).rgb;
	float3 cr=(2.5*color0+color1+color2+color3+color4)/6.5;
	float3 a=texCD(PAL_S01,texcoord).rgb;
	float b = bth/255.0;
	float c = max(max(color0.r,color0.g),color0.b);
	w = smoothstep(b, 2.0*b, c);
	float3 result=lerp(max(lerp(cr,a,0.49+float3(PR,PG,PB))-0.5/255.0,0.0),cr,w);
	return float4(result,w);
}

float4 PreShaderPS(float4 position:SV_Position,float2 texcoord:TEXCOORD):SV_Target
{
	const float3x3 File0=float3x3(0.412391, 0.212639,0.019331, 0.357584,0.715169, 0.119195, 0.180481,0.072192,0.950532);
	const float3x3 File1=float3x3(0.430554, 0.222004,0.020182, 0.341550,0.706655, 0.129553, 0.178352,0.071341,0.939322);
	const float3x3 File2=float3x3(0.396686, 0.210299,0.006131, 0.372504,0.713766, 0.115356, 0.181266,0.075936,0.967571);
	const float3x3 File3=float3x3(0.393521, 0.212376,0.018739, 0.365258,0.701060, 0.111934, 0.191677,0.086564,0.958385);
	const float3x3 File4=float3x3(0.392258, 0.209410,0.016061, 0.351135,0.725680, 0.093636, 0.166603,0.064910,0.850324);
	const float3x3 File5=float3x3(0.377923, 0.195679,0.010514, 0.317366,0.722319, 0.097826, 0.207738,0.082002,1.076960);
	const float3x3 ToRGB=float3x3(3.240970,-0.969244,0.055630,-1.537383,1.875968,-0.203977,-0.498611,0.041555,1.056972);
	const float3x3 ToMDN=float3x3(2.791723,-0.894766,0.041678,-1.173165,1.815586,-0.130886,-0.440973,0.032000,1.002034);
	const float3x3 ToDCI=float3x3(2.973422,-0.867605,0.045031,-1.110433,1.843757,-0.095697,-0.480247,0.024743,1.201215);
	const float3x3 ToADB=float3x3(2.041588,-0.969244,0.013444,-0.565007,1.875968,-0.118360,-0.344731,0.041555,1.015175);
	const float3x3 ToREC=float3x3(1.716651,-0.666684,0.017640,-0.355671,1.616481,-0.042771,-0.253366,0.015769,0.942103);
	const float3x3 ToP3=float3x3(2.493509,-0.829473,0.0358512,-0.931388,1.762630,-0.0761839,-0.402712,0.023624,0.9570296);
	const float3x3 D65_to_D55=float3x3(0.4850339153,0.2500956126,0.0227359648,0.3488957224,0.6977914447,0.1162985741,0.1302823568,0.0521129427,0.6861537456);
	const float3x3 D65_to_D93=float3x3(0.3412754080,0.1759701322,0.0159972847,0.3646170520,0.7292341040,0.1215390173,0.2369894093,0.0947957637,1.2481442225);
	float4 imgColor=texCD(PAL_S0S,texcoord);
	float4 aftrglow=texCD(PAL_S01,texcoord);
	float w=1.0-aftrglow.w;
	float l=length(aftrglow.rgb);
	aftrglow.rgb=AS*w*normalize(pow(aftrglow.rgb+0.01,ST))*l;
	float bp=w*BP1/255.0;
	if(sega_fix>0.5) imgColor.rgb=imgColor.rgb*(255.0/239.0);
	if(segams>0.5) { imgColor.b=(abs(imgColor.b - 0.375) < 0.125) ? 0.4078431372549019607843137254902 : imgColor.b; }
	imgColor.rgb=min(imgColor.rgb,1.0);
	if (segapal > 0.5) {
	imgColor.r = contrast_sigmoid_inv(imgColor.r,2.578419881,0.520674); 
	imgColor.g = contrast_sigmoid_inv(imgColor.g,2.578419881,0.520674); 
	imgColor.b = contrast_sigmoid_inv(imgColor.b,2.578419881,0.520674); }
   
	imgColor.rgb = min(imgColor.rgb, 1.0);
	float3 color=imgColor.rgb;
	if(int(TNTC)==0) {color.rgb=imgColor.rgb;}else
	{
	float lutlow=LUTLOW/255.0;float invs=1.0/32.0;
	float3 lut_ref=imgColor.rgb+lutlow*(1.0-pow(imgColor.rgb,0.333.xxx));
	float lutb=lut_ref.b*(1.0-0.5*invs);
	lut_ref.rg=lut_ref.rg*(1.0-invs)+0.5*invs;
	float tile1=ceil(lutb*(32.0-1.0));
	float tile0=max(tile1-1.0,0.0);
	float f=frac(lutb*(32.0-1.0));if(f==0.0)f=1.0;
	float2 coord1=float2(tile0+lut_ref.r,lut_ref.g)*float2(invs,1.0);
	float2 coord2=float2(tile1+lut_ref.r,lut_ref.g)*float2(invs,1.0);
	float4 color1,color2,res;
	if(int(TNTC)==1)
	{
	color1=texCD(PAL_L01,coord1);
	color2=texCD(PAL_L01,coord2);
	res=lerp(color1,color2,f);
	}else
	if(int(TNTC)==2)
	{
	color1=texCD(PAL_L02,coord1);
	color2=texCD(PAL_L02,coord2);
	res=lerp(color1,color2,f);
	}else
	if(int(TNTC)==3)
	{
	color1=texCD(PAL_L03,coord1);
	color2=texCD(PAL_L03,coord2);
	res=lerp(color1,color2,f);
	}else
	if(int(TNTC)==4)
	{
	color1=texCD(PAL_L04,coord1);
	color2=texCD(PAL_L04,coord2);
	res=lerp(color1,color2,f);
	}
	res.rgb=fix_lut(res.rgb,imgColor.rgb);
	color=lerp(imgColor.rgb,res.rgb,min(TNTC,1.0));
	}
	float3 c=clamp(color,0.0,1.0);
	float3x3 m_o;
	float p;
	if(CS==0.0){p=2.2;m_o=ToRGB;}else
	if(CS==1.0){p=2.2;m_o=ToMDN;}else
	if(CS==2.0){p=2.6;m_o=ToDCI;}else
	if(CS==3.0){p=2.2;m_o=ToADB;}else
	if(CS==4.0){p=2.4;m_o=ToREC;}
	if(CS==5.0){p=2.2;m_o=ToP3; }
	color=pow(c,p);
	float3x3 m_i;
	if(CP==0.0){m_i=File0;}else
	if(CP==1.0){m_i=File1;}else
	if(CP==2.0){m_i=File2;}else
	if(CP==3.0){m_i=File3;}else
	if(CP==4.0){m_i=File4;}else
	if(CP==5.0){m_i=File5;}
	color=mul(color,m_i);
	color=mul(color,m_o);
	color=clamp(color,0.0,1.0);
	color=pow(color,1.0/p);
	if(CP==-1.0)color=c;
	float3 solor1=plant(pow(color,wp_saturation),max(max(color.r,color.g),color.b));
	float luma=dot(color,float3(0.299,0.587,0.114));
	float3 solor2=lerp(luma,color,wp_saturation);
	color=(wp_saturation>1.0)?solor1:solor2;
	color=plant(color,contrast(max(max(color.r,color.g),color.b)));
	p=2.2;
	color=clamp(color,0.0,1.0);
	color=pow(color,p);
	float3 warmer=mul(color,D65_to_D55);
	warmer=mul(warmer,ToRGB);
	float3 cooler=mul(color,D65_to_D93);
	cooler=mul(cooler,ToRGB);
	float m=abs(WP)/100.0;
	float3 comp=(WP<0.0)?cooler:warmer;
	color=lerp(color,comp,m);
	color=pow(max(color,0.0),1.0/p);
	color=pgc(color);
	float bp1 = min(BP, 0.0);
	color = max(color + bp1/255.0, 0.0) / (1.0 + bp1/255.0*step(-bp1/255.0, max(max(color.r,color.g),color.b)));
	color = color + aftrglow.rgb + bp;
	color=min(color*pre_bb,1.0);
	return float4(color,vignette(texcoord));
}

float4 InterlacePS(float4 position:SV_Position,float2 texcoord:TEXCOORD):SV_Target
{
    float3 c1=texCD(PAL_S02,fuxcoord).rgb;
    float3 c2=texCD(PAL_S02,fuxcoord+float2(0.0,OrgSize.w)).rgb;
    if((downsample_levelx+downsample_levely)>0.025)
    {
    c1=fetch_pixel(fuxcoord);
    c2=fetch_pixel(fuxcoord+float2(0.0,OrgSize.w));
    }
    float3 c=c1;
    float intera=1.0;
    float m1=max(max(c1.r,c1.g),c1.b);
    float m2=max(max(c2.r,c2.g),c2.b);
    float3 df=abs(c1-c2);
    float d=max(max(df.r,df.g),df.b);
    if(interm==2.0) d=lerp(0.1*d,10.0*d,step(m1/(m2+0.0001),m2/(m1+0.0001)));
    float r=m1;
    float yres_div=1.0;if(intres>1.25)yres_div=intres;
    bool hscans=(hiscan>0.5);
    if(interr<=OrgSize.y/yres_div&&interm>0.5&&intres!=1.0&&intres!=0.5||hscans)
    {
    intera=0.25;
    float liine_no=floor( mod(OrgSize.y*fuxcoord.y,2.0));
    float frame_no=floor( mod(float(framecount),2.0));
    float ii=abs(liine_no-frame_no);
    if(interm< 3.5 || interm > 5.5)
    {
    if (interm == 6.0) c = lerp(c2, c1, ii); else
    {
    c2=plant(lerp(c2,c2*c2,iscans),max(max(c2.r,c2.g),c2.b));
    r=max(m1*ii,(1.0-iscanb)*min(m1,m2));
    c=plant(lerp(lerp(c1,c2,min(lerp(m1,1.0-m2,min(m1,1.0-m1))/(d+0.00001),1.0)),c1,ii),r);
    if(interm==3.0) c=(1.0-0.5*iscanb)*lerp(c2,c1,ii);
    }
    }
    if(interm==4.0){c=plant(lerp(c,c*c,0.5*iscans),max(max(c.r,c.g),c.b))*(1.0-0.5*iscanb);
    }
    if(interm==5.0){c=lerp(c2,c1,0.5);c=plant(lerp(c,c*c,0.5*iscans),max(max(c.r,c.g),c.b))*(1.0-0.5*iscanb);
    }
    if(hscans)c=c1;
    }
    return float4(c,intera);
}

float4 Signal_1_PS(float4 position:SV_Position,float2 texcoord:TEXCOORD):SV_Target
{
	float2 vtex_c=texcoord;
	float3 ycolor=rgb2yuv(texCD(PAL_S0I, vtex_c).rgb);
	float4 pcolor=float4(texCD(PAL_S03, vtex_c));
	return float4(ycolor.yz, pcolor.xy);
}

float4 Signal_2_PS(float4 position:SV_Position,float2 texcoord:TEXCOORD):SV_Target
	{
	float ARTIFACT=ARTIFACTING;
	float3x3 mix_m = float3x3(BRIGHTNESS,ARTIFACT,ARTIFACT,FRINGING,2.0*SATURATION,0.0,FRINGING,0.0,2.0*SATURATION);
	
	float CYCLES_PER_LINE=4.43361875e6/15625.0;
	float2 vtex_c=texcoord*1.00001;
	
	float3 rgb  = texCD(PAL_S0I, vtex_c).rgb;
	float3 yuv1=rgb2yuv(rgb);
	yuv1.x=pow(max(yuv1.x, 0.0), GCORR); /* no float needed here??? float2? */
	float3 res4=yuv1;
	
	float lum = yuv1.x;
	float3 yuvd=rgb2yuv(texCD(PAL_S03, vtex_c - float2(0.0, OrgSize.w)).rgb); yuvd.x = lum;
	if (DLINE>3.5){yuvd=yuv1;}
	
	int line=int(floor(vtex_c.y*OrgSize.y));
	
	float xN=vtex_c.x*CYCLES_PER_LINE;
	float cycles=xN+edge_cycles(line, framecount);
	float phase=2.0*pii*cycles;
	float linesign=(line%2==0)?1.0:-1.0;
	
	float2 uvmod=float2(cos(phase), sin(phase*linesign));
	yuv1.yz = yuv1.yz*uvmod;
	yuv1 =mul(mix_m,yuv1);
	yuv1.yz=yuv1.yz*uvmod;
	
	if (DLINE>1.5)
	{
	if(DLINE>2.5){uvmod=float2(-uvmod.x, -uvmod.y);} else uvmod=float2(uvmod.x, -uvmod.y); /* should these be in a single {}? */
	yuvd.yz=yuvd.yz*uvmod;
	yuvd=mul(mix_m,yuvd);
	yuvd.yz=yuvd.yz*uvmod;
	yuv1=lerp(yuv1, yuvd, 0.5);
	}

	if(PAL_FILT==4.0){yuv1=res4;}

	return float4(yuv1, lum);
}

float4 Signal_3_PS(float4 position:SV_Position,float2 texcoord:TEXCOORD):SV_Target
{
	float2 tex_c=texcoord+float2(0.125*OrgSize.z, 0.0);
	float2 vtex_c=texcoord+float2(0.125*OrgSize.z,0.0);
	
	float4 CON_TYPE=float4(288.0f, 320.0f, 410.0f, 512.0f); /* not sure this works in reshade code? */

	float luma_weight_pal_25[25]={
   -0.002029,
   -0.005153,
   -0.011795,
   -0.018519,
   -0.049249,
   -0.085003,
   -0.121754,
   -0.155098,
   -0.180556,
   -0.193873,
   -0.191327,
   -0.170006,
   -0.128046,
   -0.064815,
    0.018974,
    0.121221,
    0.238487,
    0.366121,
    0.498457,
    0.629093,
    0.751215,
    0.857963,
    0.942821,
    0.995341,
    1.000000};
	
	float chroma_weight_pal_251[25]={
   -0.001100,
   -0.001650,
   -0.002500,
   -0.003700,
   -0.005200,
   -0.006900,
   -0.008300,
   -0.009000,
   -0.008100,
   -0.005600,
   -0.002200,
    0.000300,
    0.002300,
    0.005200,
    0.009000,
    0.023600,
    0.049000,
    0.075200,
    0.152100,
    0.339700,
    0.447800,
    0.676000,
    0.892000,
    0.984000,
    1.000000};
	
	float chroma_weight_pal_252[25]={
   -0.00100,
   -0.00200,
   -0.00300,
   -0.00400,
   -0.00550,
   -0.00900,
   -0.00550,
   -0.00200,
    0.00430,
    0.00721,
    0.01167,
    0.02333,
    0.06512,
    0.09667,
    0.19333,
    0.30000,
    0.37667,
    0.48333,
    0.56000,
    0.66327,
    0.72333,
    0.86000,
    0.91667,
    0.97333,
    1.00000};

	const int TAPS_PAL=24;

	float chroma_weight_pal_25[25]=chroma_weight_pal_251;
	if (CHROMAF>1.5){chroma_weight_pal_25=chroma_weight_pal_252;}

	float yres=CON_TYPE[int(PAL_FILT)-1];
	float hres=(pal_res < 1.5)?yres:OrgSize.x;

// De-dithering Booster code
	float df = 1.0;
   
	if(pal_dith>0.005&&PAL_FILT<3.5)
	{
        float2 TexD=(floor(fuxcoord*OrgSize.xy)+0.5)*OrgSize.zw;
        float2 xx=float2(OrgSize.z,0.0);
        
        float ca=texCD(PAL_S04,TexD-xx-xx).a;
        float c0=texCD(PAL_S04,TexD-xx).a;
        float c1=texCD(PAL_S04,TexD).a;
        float c2=texCD(PAL_S04,TexD+xx).a;
        float cb=texCD(PAL_S04,TexD+xx+xx).a;
        
        float line0=smothstep(0.0075,0.0,min(abs(c1-c0),abs(c2-c1)));
        float line1=max(smothstep(0.0075,0.0,min(abs(ca-c0),abs(c2-cb))), line0);
        float line2=max(smothstep(0.0075,0.0,min(abs(ca-c2),abs(c0-cb))), line1);
        df=1.0+(1.0-line2)*pal_dith;
	}

	float res=pal_scale;
	float one_x=0.125/hres/res * df;
	float one_y=0.250/hres/res/pal_chroma;

	float3 signal=0.0; /* I'm not sure this should be here */

	float3 wsum =0.0.xxx;
	float3 sums=wsum;
	float3 tmps=wsum;
	float offset=0.0;int i=0;
	float3 dx=float3(one_x, one_y, 0.0); /* I'm not sure this should be here */
	float loop=24.0;
	float3 xd=dx;

	for (i=0;i<24;i++)
	{
	offset=float(i);
	xd.xy=(offset-loop)*dx.xy;
	sums=sample_yuv(xd); /* this may need more work. yuv1? vec3 sample_yuv(vec3 dx) from pal3? */
	tmps=float3(luma_weight_pal_25[i], chroma_weight_pal_25[i].xx);
	wsum=wsum+tmps; signal+=sums*tmps;
	}
	tmps=float3(luma_weight_pal_25[TAPS_PAL], chroma_weight_pal_25[TAPS_PAL], chroma_weight_pal_25[TAPS_PAL]);
	wsum=wsum+wsum+tmps;
	signal+=texCD(PAL_S04,tex_c).xyz*tmps;
	signal =signal/wsum;

	if(pal_ring>0.05)
	{
        float2 dx=float2(8.0*one_x/min(res,1.0),0.0);
        float x1=texCD(PAL_S04,tex_c-4.0*dx).a;
        float x2=texCD(PAL_S04,tex_c-3.0*dx).a;
        float a=texCD(PAL_S04,tex_c-2.0*dx).a;
        float b=texCD(PAL_S04,tex_c-    dx).a;
        float c=texCD(PAL_S04,tex_c+2.0*dx).a;
        float y1=texCD(PAL_S04,tex_c+3.0*dx).a;
        float y2=texCD(PAL_S04,tex_c+4.0*dx).a;
        float d=texCD(PAL_S04,tex_c+    dx).a;
        float e=texCD(PAL_S04,tex_c       ).a;	  
        float a0 = min(min(a,x1),x2);
        float a1 = max(max(a,x1),x2);
        float c0 = min(min(c,y1),y2);
        float c1 = max(max(c,y1),y2);
        signal.x = lerp(signal.x, clamp(signal.x, min(min(min(a0,b),min(c0,d)),e), max(max(max(a1,b),max(c1,d)),e)), pal_ring);
	}

	signal.x=pow(max(signal.x, 0.0), 1.0/GCORR);

    if ((RFNOISE1 + RFNOISE2) > 0.005)
    {
        float3 ns = NoiseNP3(vtex_c, float(framecount));
        float Y   = lerp(0.375, 1.0, pow(signal.x, 0.2));

        signal.x = clamp(signal.x + RFNOISE1 * ns.x,  0.00, 1.00);
        signal.y = clamp(signal.y + Y * RFNOISE2 * (0.325 + 1.325 * abs(signal.y)) * ns.y, -0.45, 0.45);
        signal.z = clamp(signal.z + Y * RFNOISE2 * (0.325 + 1.325 * abs(signal.z)) * ns.z, -0.62, 0.62);
    }

	return float4(clamp(yuv2rgb(signal),0.0,1.0), 1.0);
}

float4 SharpnessPS(float4 position:SV_Position,float2 texcoord:TEXCOORD):SV_Target
{
	float2 g01=float2(-1.0/640.0,0.0);
	float2 g21=float2(-1.0/640.0,0.0);
	float3 c01=texCD(PAL_S05,texcoord+g01).rgb;
	float3 c21=texCD(PAL_S05,texcoord+g21).rgb;
	float3 c11=texCD(PAL_S05,texcoord    ).rgb;
	float3 b11=0.5*(c01+c21);
	float contrazt=max(max(c11.r,c11.g),c11.b);
	contrazt=lerp(2.0*CCONTR,CCONTR,contrazt);
	float3 nim=min(min(c01,c21),c11);float3 mn1=min(nim,c11*(1.0-contrazt));
	float3 xam=max(max(c01,c21),c11);float3 mx1=max(xam,c11*(1.0+contrazt));
	float3 di0=pow(mx1-mn1+0.00001,0.75);
	float3 sharpen=lerp(CSHARPEN*CDETAILS,CSHARPEN,di0);
	float3 res=clamp(lerp(c11,b11,-sharpen),mn1,mx1);
	if(NDEBLUR>1.125)
	{
	float2 toxcoord=(floor(OrgSize.xy*texcoord)+0.5)*OrgSize.zw;
	float l01=get_luma(texCD(PAL_S02,texcoord+2.0*g01).rgb);
	float l21=get_luma(texCD(PAL_S02,texcoord+2.0*g21).rgb);
	float l11=get_luma(texCD(PAL_S02,toxcoord        ).rgb);
	float dth = texCD(PAL_S05,texcoord).a;
	float DEB = NDEBLUR;
	float d11=min(min(l01,l21),l11);
	l11=max(max(l01,l21),l11);
	float lmn=min(min(get_luma(c01),get_luma(c21)),get_luma(c11));float ln1=min(lerp(d11,lmn,lmn),lmn);
	float lmx=max(max(get_luma(c01),get_luma(c21)),get_luma(c11));float lx1=max(lerp(lmx,l11,lmx),lmx);
	float r11=get_luma(res);
	float di1=max((r11-ln1),0.0)+0.00001;di1=pow(di1,DEB);
	float di2=max((lx1-r11),0.0)+0.00001;di2=pow(di2,DEB);
	float ratio=di1/(di1+di2);
	float zharpen=lerp(ln1,lx1,ratio);
	zharpen=min(zharpen,max(DREDGE*zharpen,r11));
	res=rgb2yuv(res);
	d11=res.x;
	res.x=zharpen;
	res.x=clamp((1.0+ DSHARP)* res.x-DSHARP*d11,ln1*(1.0-contrazt),lx1*(1.0+contrazt));
	res=max(yuv2rgb(res),0.0);
	}
	return float4(res,1.0);
}

float4 LuminancePS(float4 position:SV_Position,float2 texcoord:TEXCOORD):SV_Target
{
	float m=max(log2(LumSize.x),log2(LumSize.y));
	m=floor(max(m,1.0))-1.0;
	float2 dx=float2(1.0/LumSize.x,0.0);
	float2 dy=float2(0.0,1.0/LumSize.y);
	float2 x2=2.0*dx;
	float2 y2=2.0*dy;
	float ltotal=0.0;
	ltotal+=length(tex2Dlod(PAL_S06,float4(float2(0.3,0.3),m,0)).rgb);
	ltotal+=length(tex2Dlod(PAL_S06,float4(float2(0.3,0.7),m,0)).rgb);
	ltotal+=length(tex2Dlod(PAL_S06,float4(float2(0.7,0.3),m,0)).rgb);
	ltotal+=length(tex2Dlod(PAL_S06,float4(float2(0.7,0.7),m,0)).rgb);
	ltotal*=0.25;
	ltotal=pow(0.577350269*ltotal,0.7);
	float lhistory=texCD(PAL_S07,float2(0.5,0.5)).a;
	ltotal=lerp(ltotal,lhistory,min(lerp(lsmooth, lsmooth + lsdev, ltotal),0.99));
	float3 l1=texCD(PAL_S06,fuxcoord.xy   ).rgb;
	float3 r1=texCD(PAL_S06,fuxcoord.xy+dx).rgb;
	float3 l2=texCD(PAL_S06,fuxcoord.xy-dx).rgb;
	float3 r2=texCD(PAL_S06,fuxcoord.xy+x2).rgb;
	float c1=dist(l2,l1);
	float c2=dist(l1,r1);
	float c3=dist(r2,r1);
	return float4(c1,c2,c3,ltotal);
}

float4 LinearizeNewPS(float4 position:SV_Position,float2 texcoord:TEXCOORD):SV_Target
{
    float3 c = texCD(PAL_S06,fuxcoord).rgb;
    if((downsample_levelx+downsample_levely)>0.025)
    {
    c=fetch_pixel(fuxcoord);
    }
    float intera = texCD(PAL_S0I,fuxcoord).a;
    float gamma_in=gamma_i;
    c=pow(c,gamma_in);
    if(fuxcoord.x>0.5)gamma_in=intera;else gamma_in=1.0/gamma_in;
    return float4(c,gamma_in);
}

float4 PAL_TV1_PS(float4 position:SV_Position,float2 texcoord:TEXCOORD):SV_Target
{
	float f=frac(LumSize.x*fuxcoord.x);
	f=0.5-f;
	float2 tex=floor(LumSize.xy*fuxcoord)*LumSize.zw+0.5*LumSize.zw;
	float3 color=0.0.xxx;
	float solor=0.0;
	float2 dx=float2(LumSize.z ,0.0);
	float3 pixel;
	float w=0.0;
	float swum=0.0;
	float wsum=0.0;
	float3 cmax=0.0.xxx;
	float3 cmin=1.0.xxx;
	float xs=max(2.0*0.4, 1.0);
	float hsharpness=HSHARPNESS*xs*filter_res;
	float LIGMA_H2 = LIGMA_H * HSHARPNESS;
	xs=1.0/(2.0*LIGMA_H2*LIGMA_H2*xs*xs*filter_res*filter_res);
	float sharp=crthd_h(hsharpness,xs) *S_SHARP;
	float ksharp = -2.0*hsharpness*xs*sharp;	
	float maxsharp=MAXS;
	float FPR=hsharpness;
	float FPRi=1.0/hsharpness;
	float fpx=0.0;
	float sp=0.0;
	float sw=0.0;
	float ts=0.025;
	float3 luma=float3(0.2126,0.7152,0.0722);
	float LOOPSIZE=ceil(2.0*FPR);
	float n=-LOOPSIZE;
	do
	{
	pixel=texCD(PAL_S08,tex+n*dx).rgb;
	w=crthd_h(n+f,xs)-sharp;
	fpx=clamp((abs(n+f)-FPR)*FPRi, 0.0, 1.0);
	if(w<0.0)w=max(ksharp*fpx, maxsharp * ksharp * (1.0-fpx*fpx)); else
	{
	cmax=max(cmax,pixel);cmin=min(cmin,pixel);sw=w*(dot(pixel,luma)+ts);
	sp=max(max(pixel.r,pixel.g),pixel.b);
	solor=solor+sw*sp;
	swum=swum+sw;
	}
	color=color+w*pixel;
	wsum=wsum+w;
	n=n+1.0;
	}
	while(n<=LOOPSIZE);
	color=color/wsum;
	solor=solor/swum;
	color=clamp(lerp( clamp (color,cmin,cmax),color,SSRNG),0.0,1.0);
	solor=clamp(lerp(max(max(color.r,color.g),color.b),solor,spike),0.0,1.0);
	return float4(color,solor);
}

float4 HGaussianPS(float4 position:SV_Position,float2 texcoord:TEXCOORD):SV_Target
{
	float FINE_GAUSS= (FINE_GAUSS>0.5)? FINE_GAUSS: lerp(0.75,0.50,-FINE_GAUSS);
	float4 AdvSize=float4(OrgSize.x,OrgSize.y,OrgSize.z,OrgSize.w)*float4(FINE_GAUSS,FINE_GAUSS,1.0/FINE_GAUSS,1.0/FINE_GAUSS);
	float f=frac(AdvSize.x*texcoord.x);
	f=0.5-f;
	float2 tex=floor(AdvSize.xy*texcoord)*AdvSize.zw+0.5*AdvSize.zw;
	float3 color=0.0;
	float2 dx=float2(AdvSize.z ,0.0);
	float3 pixel;
	float w;
	float wsum=0.0;
	float n=-SIZEH;
	do
	{
	pixel=texCD(PAL_S08,tex+n*dx).rgb;
	if(m_glow>0.5)
	{
	pixel=max(pixel-m_glow_cutoff,0.0);
	pixel=plant(pixel,max(max(max(pixel.r,pixel.g),pixel.b)-m_glow_cutoff,0.0));
	}
	w=gauss_h(n+f);
	color=color+w*pixel;
	wsum=wsum+w;
	n=n+1.0;
	}
	while(n<=SIZEH);
	color=color/wsum;
	return float4(color,1.0);
}

float4 VGaussianPS(float4 position:SV_Position,float2 texcoord:TEXCOORD):SV_Target
{
	float FINE_GAUSS= (FINE_GAUSS>0.5)? FINE_GAUSS: lerp(0.75,0.50,-FINE_GAUSS);
	float4 AdvSize=float4(SrcSize.x,OrgSize.y,SrcSize.z,OrgSize.w)*float4(FINE_GAUSS,FINE_GAUSS,1.0/FINE_GAUSS,1.0/FINE_GAUSS);
	float f=frac(AdvSize.y*texcoord.y);
	f=0.5-f;
	float2 tex=floor(AdvSize.xy*texcoord)*AdvSize.zw+0.5*AdvSize.zw;
	float3 color=0.0;
	float2 dy=float2(0.0,AdvSize.w );
	float3 pixel;
	float w;
	float wsum=0.0;
	float n=-SIZEV;
	do
	{
	pixel=texCD(PAL_S10,tex+n*dy).rgb;
	w=gauss_v(n+f);
	color=color+w*pixel;
	wsum=wsum+w;
	n=n+1.0;
	}
	while(n<=SIZEV);
	color=color/wsum;
	return float4(color,1.0);
}

float4 BloomHorzPS(float4 position:SV_Position,float2 texcoord:TEXCOORD):SV_Target
{
	float FINE_BLOOM= (FINE_BLOOM>0.5)? FINE_BLOOM: lerp(0.75,0.50,-FINE_BLOOM);
	float4 AdvSize=float4(OrgSize.x,OrgSize.y,OrgSize.z,OrgSize.w)*float4(FINE_BLOOM,FINE_BLOOM,1.0/FINE_BLOOM,1.0/FINE_BLOOM);
	float f=frac(AdvSize.x*texcoord.x);
	f=0.5-f;
	float2 tex=floor(AdvSize.xy*texcoord)*AdvSize.zw+0.5*AdvSize.zw;
	float4 color=0.0;
	float2 dx=float2(AdvSize.z ,0.0);
	float4 pixel;
	float w;
	float wsum=0.0;
	float n=-SIZEX;
	do
	{
	pixel=texCD(PAL_S08,tex+n*dx);
	w=bloom_h(n+f);
	pixel.a =max(max(pixel.r,pixel.g),pixel.b);
	pixel.a*=pixel.a*pixel.a;
	color=color+w*pixel;
	wsum=wsum+w;
	n=n+1.0;
	}
	while(n<=SIZEX);
	color=color/wsum;
	return float4(color.rgb,pow(color.a,0.333333));
}

float4 BloomVertPS(float4 position:SV_Position,float2 texcoord:TEXCOORD):SV_Target
{
	float FINE_BLOOM= (FINE_BLOOM>0.5)? FINE_BLOOM: lerp(0.75,0.50,-FINE_BLOOM);
	float4 AdvSize=float4(SrcSize.x,OrgSize.y,SrcSize.z,OrgSize.w)*float4(FINE_BLOOM,FINE_BLOOM,1.0/FINE_BLOOM,1.0/FINE_BLOOM);
	float f=frac(AdvSize.y*texcoord.y);
	f=0.5-f;
	float2 tex=floor(AdvSize.xy*texcoord)*AdvSize.zw+0.5*AdvSize.zw;
	float4 color=0.0;
	float2 dy=float2(0.0,AdvSize.w );
	float4 pixel;
	float w;
	float wsum=0.0;
	float n=-SIZEY;
	do
	{
	pixel=texCD(PAL_S12,tex+n*dy);
	w=bloom_v(n+f);
	pixel.a*=pixel.a*pixel.a;
	color=color+w*pixel;
	wsum=wsum+w;
	n=n+1.0;
	}
	while(n<=SIZEY);
	color=color/wsum;
	return float4(color.rgb,pow(color.a,0.175000));
}
float4 PAL_TV2_PS(float4 position:SV_Position,float2 texcoord:TEXCOORD):SV_Target
{
	float gamma_in=1.0/texCD(PAL_S08,float2(0.25,0.25)).a;
	float lum=texCD(PAL_S07,float2(0.5,0.5)).a;
	float intera=texCD(PAL_S08,float2(0.75,0.25)).a;
	bool hscans=(hiscan>0.5);
	bool inter6=(intera<0.35&&interm==6.0);
	bool interb=(((intera<0.35&&!inter6)||(no_scanlines>0.025))&&!hscans);
	float4 AdvSize= LumSize;
	float SourceY=AdvSize.y;
	float sy=1.0;
	if( intres==1.0)sy=max(round(SourceY/224.0),1.0);
	if( intres>0.25&&intres!=1.0)sy=intres;
	if (inter6) sy*=2.0;
	AdvSize*=float4(1.0,1.0/sy,1.0,sy);
	float2 lexcoord=fuxcoord.xy;
	if(IOS> 0.0&& !interb)
	{
	float2 ofactor= NewSize.xy/OrgSize.xy;
	float2 ifactor=(IOS<2.5)? floor(ofactor):ceil(ofactor);
	float2 diff=ofactor/ifactor;
	float scan=diff.y;
	lexcoord=overscan(lexcoord,scan,scan);
	if(IOS==1.0||IOS==3.0) lexcoord=float2(fuxcoord.x,lexcoord.y);
	}
	float factor=1.0+(1.0-0.5*OS)*blm_2/100.0-lum*blm_2/100.0;
	lexcoord=overscan(lexcoord,factor,factor);
	lexcoord.y = lexcoord.y - VShift*OrgSize.w;
	lexcoord=overscan(lexcoord,(OrgSize.x-overscanx)/OrgSize.x,(OrgSize.y-overscany)/OrgSize.y);
	float2 pos = warp(lexcoord);
	float ii = float(inter6)*(floor(mod(float(framecount), 2.0)));
	float2 coffset = float2(0.5, 0.5 + 0.5*ii);
	float2 ps=AdvSize.zw;
	float2 OGL2Pos=pos*AdvSize.xy-coffset;
	float2 fp=frac(OGL2Pos);
	float2 dx=float2(ps.x,0.0);
	float2 dy=float2(0.0,ps.y);
	float f=fp.y;
	float2 pC4=floor(OGL2Pos)*ps+0.5*ps; pC4.y = pC4.y + float(inter6)*0.25*dy.y;
	pC4.x=pos.x;
	if( intres==0.5<1.5)pC4.y=floor(pC4.y*OrgSize.y)*OrgSize.w+0.5*OrgSize.w;
	if( interb&&no_scanlines<0.025|| hscans) pC4.y=pos.y;else
	if( interb) pC4.y=pC4.y+smoothstep(0.40-0.5*no_scanlines,0.60+0.5*no_scanlines,f)*AdvSize.w;
	float3 color1=texCD(PAL_S09,pC4).rgb;
	float3 solor1=texCD(PAL_S09,pC4).aaa;
	if(!interb)color1=pow(color1,scangamma/gamma_in);
	pC4+=dy;
	if( intres==0.5<1.5)pC4.y=floor((pos.y+0.33*dy.y)*OrgSize.y)*OrgSize.w+0.5*OrgSize.w;
	float3 color2=texCD(PAL_S09,pC4).rgb;
	float3 solor2=texCD(PAL_S09,pC4).aaa;
	if(!interb)color2=pow(color2,scangamma/gamma_in);
	float3 ctmp=color1;float w3=1.0;float3 color=color1;
	float3 one=1.0;
	if( hscans){color2=color1;solor2=solor1;}
	if(!interb|| hscans)
	{
	float ssub = ssharp*abs(solor1.x-solor2.x);
	float shape1=lerp(scanline1,scanline2 + ssub * solor1.x * 35.0,    f);
	float shape2=lerp(scanline1,scanline2 + ssub * solor2.x * 35.0,1.0-f);
	float wt1=st0(    f);
	float wt2=st0(1.0-f);
	float3 color0=color1*wt1+color2*wt2;
	float3 solor0=solor1*wt1+solor2*wt2;
	ctmp = color0/(wt1+wt2);
	float3 stmp=solor0/(wt1+wt2);
	if(abs(rolling_scan)>0.005){color1=ctmp;color2=ctmp;solor1=stmp;solor2=stmp;}
	float3 w1,w2;
	float3 cref1=lerp(stmp,solor1,beam_size);float creff1=pow(max(max(cref1.r,cref1.g),cref1.b),scan_falloff);
	float3 cref2=lerp(stmp,solor2,beam_size);float creff2=pow(max(max(cref2.r,cref2.g),cref2.b),scan_falloff);
	if(tds>0.5){shape1=lerp(scanline2,shape1,creff1);shape2=lerp(scanline2,shape2,creff2);}
	float scanpix=OrgSize.y/NewSize.y;
	float f1=frac(f-rolling_scan*float(framecount)*scanpix);
	float f2=1.0-f1;
	float m1=max(max(color1.r,color1.g),color1.b)+eps;
	float m2=max(max(color2.r,color2.g),color2.b)+eps;
	cref1=color1/m1;
	cref2=color2/m2;
	if(gsl< 0.5)
	{w1=sw0(f1,creff1,shape1,cref1);w2=sw0(f2,creff2,shape2,cref2);}else
	if(gsl==1.0)
	{w1=sw1(f1,creff1,shape1,cref1);w2=sw1(f2,creff2,shape2,cref2);}else
	{w1=sw2(f1,creff1,shape1,cref1);w2=sw2(f2,creff2,shape2,cref2);}
	float3 w3=w1+w2;
	float wf1=max(max(w3.r,w3.g),w3.b);
	if(wf1>1.0){wf1=1.0/wf1;w1*=wf1,w2*=wf1;}
	if(abs(clp)>0.005)
	{
	sy=m1; one=(clp>0.0)?w1:1.0.xxx;
	float sat=1.0001-min(min(cref1.r,cref1.g),cref1.b);
	color1=lerp(color1,plant(pow(color1,0.70.xxx-0.325*sat),sy),pow(sat,0.3333)*one*abs(clp));
	sy=m2; one=(clp>0.0)?w2:1.0.xxx;
	sat=1.0001-min(min(cref2.r,cref2.g),cref2.b);
	color2=lerp(color2,plant(pow(color2,0.70.xxx-0.325*sat),sy),pow(sat,0.3333)*one*abs(clp));
	}
	color=gc1(color1)*w1+gc1(color2)*w2;
	if (bloomsamp > 0.5) {	
		float3 BloomS = texCD(PAL_S13, pos).rgb;
		BloomS = pow(BloomS, scangamma/gamma_in);
		float cm = max(max(ctmp.r,ctmp.g),ctmp.b);
		float bm = max(max(BloomS.r,BloomS.g),BloomS.b);
		float bmix = clamp(max((cm-bm), (bm-cm)/(cm+0.25)-cm), 0.0, 1.0);
		if (abs(clp) > 0.005)
		{
			sy = cm + eps; one = (clp > 0.0) ? min(w1+w2,1.0) : 1.0.xxx;
			cref1 = plant(BloomS,1.0);
			float sat = 1.0001-min(min(cref1.r,cref1.g),cref1.b);
			BloomS = lerp(BloomS, plant(pow(BloomS, 0.70.xxx-0.325*sat),sy), pow(sat,0.3333)*one*abs(clp));
		}
		float3 Bloom1 = (color1*wt1 + color2*wt2)/(wt1+wt2);
		BloomS = lerp(BloomS, Bloom1, min(3.0*abs(plant(sqrt(Bloom1),1.0) - plant(sqrt(BloomS),1.0)), 1.0));
		bm = max(max(BloomS.r,BloomS.g),BloomS.b);
		BloomS = plant(lerp(BloomS,Bloom1,bloomsamp-1.0), lerp(bm, 1.125*cm, bmix));
		BloomS = gc1(BloomS)*(w1+w2);
		color = min(lerp(color, BloomS, pow(cm, lerp(0.4, 0.2, pow(cm,0.375)))), max(BloomS,color));
	}
	color=min(color,1.0);
	}
	if( interb)
	{
	color=gc1(color1);
	}
	float colmx=max( max(ctmp.r,ctmp.g),ctmp.b);
	if(!interb){color=pow(color,gamma_in/scangamma); colmx = pow(colmx, gamma_in/scangamma); }
	return float4(color,colmx);
}

float4 ChromaticPS(float4 position:SV_Position,float2 texcoord:TEXCOORD):SV_Target
{
	float gamma_in=1.0/texCD(PAL_S08,float2(0.25,0.25)).a;
	float lum=texCD(PAL_S07,float2(0.5,0.5)).a;
	float intera=texCD(PAL_S08,float2(0.75,0.25)).a;
	bool inter6=(intera<0.35&&interm==6.0);
	bool interb=(((intera<0.35&&!inter6)||(no_scanlines>0.025))&&!hiscan);
	float2 lexcoord=fuxcoord.xy;
	if(IOS> 0.0&& !interb)
	{
	float2 ofactor= NewSize.xy/OrgSize.xy;
	float2 ifactor=(IOS<2.5)? floor(ofactor):ceil(ofactor);
	float2 diff=ofactor/ifactor;
	float scan=diff.y;
	lexcoord=overscan(lexcoord,scan,scan);
	if(IOS==1.0||IOS==3.0) lexcoord=float2(fuxcoord.x,lexcoord.y);
	}
	float factor=1.0+(1.0-0.5*OS)*blm_2/100.0-lum*blm_2/100.0;
	lexcoord=overscan(lexcoord,factor,factor);
	lexcoord.y=lexcoord.y - VShift*OrgSize.w;
	lexcoord=overscan(lexcoord,(OrgSize.x-overscanx)/OrgSize.x,(OrgSize.y-overscany)/OrgSize.y);
	float2 pos0= warp(fuxcoord);
	float2 pos1= fuxcoord;
	float2 pos = warp(lexcoord);
	float2 posb = 2.0*(pos0-0.5);
	if (blm_2 < 0.5) posb = max(abs(posb), abs(2.0*(pos-0.5)))*sign(posb);
	posb = 0.5*posb + 0.5;
	float3 color=texCD(PAL_S14,pos1).rgb;
	float3 Bloom=texCD(PAL_S13,pos ).rgb;
	float3 Glow =texCD(PAL_S11,pos ).rgb;
	if((abs(deconrx)+abs(deconry)+abs(decongx)+abs(decongy)+abs(deconbx)+abs(deconby))>0.2) bring_pixel(color,Bloom,Glow,pos1,pos);
	float cm=igc(max(max(color.r,color.g),color.b));
	float mx1=texCD(PAL_S14,pos1   ).a;
	float colmx=max(mx1,cm);
	float w3=min((max((cm-0.0005)*1.0005,0.0)+0.0001)/(colmx+0.0005),1.0);if(interb)w3=1.0;
	float2 dx=float2(0.001,0.0);
	float mx0=texCD(PAL_S14,pos1-dx).a;
	float mx2=texCD(PAL_S14,pos1+dx).a;
	float mxg=max(max(mx0,mx1),max(mx2,cm));
	float mx=pow(mxg,1.40/gamma_in);
	float cx=pow(colmx,1.40/gamma_in);
	dx=float2(OrgSize.z,0.0)*0.25;
	mx0=texCD(PAL_S14,pos1-dx).a;
	mx2=texCD(PAL_S14,pos1+dx).a;
	float mb=(1.0-min(abs(mx0-mx2)/(0.5+mx1),1.0));
	float3 orig1=color;
	float3 one=1.0;
	float3 cmask=one;
	float3 dmask=one;
	float3 emask=one;
	float mwidths[16]={0.0,2.0,3.0,3.0,6.0,6.0,2.4,3.4,2.4,3.25,3.4,4.4,4.25,7.4,6.25,5.25};
	float mwidth=mwidths[int(shadow_msk+1)]; // the +1 makes the transform to shadow mask setting behave correctly with the crt masks setting still including the negative numbered option as is the case upstream. is there a better way?
	float mask_compensate=frac(mwidth);
	float mwidth0 = mwidth;
	if(shadow_msk> -0.5)
	{
	float2 maskcoord= fracoord.xy+float2(laysh*masksize,0.0);
	float2 scoord=maskcoord;
	mwidth=floor(mwidth)*masksize;
	float swidth=mwidth;
	bool zoomed=(abs(mask_zoom)>0.75);
	float mscale=1.0;
	float2 maskcoord0=maskcoord;
	maskcoord.y=floor(maskcoord.y/masksize);
	mwidth0=max(mwidth+mask_zoom,2.0);
	if( mshift> 0.25)
	{
	float stagg_lvl=1.0; if(frac(mshift)>0.25)stagg_lvl=2.0;
	float next_line=float(floor(mod(maskcoord.y,2.0*stagg_lvl))<stagg_lvl);
	maskcoord0.x=maskcoord0.x+next_line*0.5*mwidth0;
	}
	maskcoord=maskcoord0/masksize;
	if(!zoomed)cmask=crt_mask(floor(maskcoord),mx,mb);else
	{
	mscale=mwidth0/mwidth;
	float clerp= frac(maskcoord.x/mscale); if( zoom_mask>0.025 )clerp=clamp((1.0+zoom_mask)*clerp-0.5*zoom_mask,0.0,1.0);

	float coord = floor(maskcoord.x/mscale);
	if (shadow_msk == 12.0 && mask_zoom == -2.0) coord = ceil(maskcoord.x/mscale);
	cmask = lerp(crt_mask(float2(coord,maskcoord.y), mx, mb), crt_mask(float2(coord + 1.0, maskcoord.y), mx, mb), clerp);
	}
	float sm_offset=0.0;bool bsm_offset=(shadow_msk==0.0||shadow_msk==2.0||shadow_msk==5.0||shadow_msk==6.0||shadow_msk==8.0||shadow_msk==11.0);
	if( zoomed)
	{
	if(mask_layout<0.5&&bsm_offset)sm_offset=1.0;else
	if(bsm_offset)sm_offset=-1.0;
	}
	swidth=round(mwidth0); if (slotwidth > 0.5) swidth = slotwidth; float smask = 1.0;
	smask =slt_mask(scoord+float2(sm_offset,0.0),mx,swidth);
	smask =clamp(smask+lerp(smask_mit,0.0,w3*pow(colmx,0.3)),0.0,1.0);
	emask =cmask;
	cmask*=smask;
	dmask =cmask;
	if(abs(mask_bloom)>0.025)
	{
	float maxbl=max( max(max(Bloom.r,Bloom.g),Bloom.b),mxg);
	maxbl=maxbl*max(lerp(1.0,2-colmx,bloom_dist),0.0);
	if(mask_bloom>0.025) cmask= max(min(cmask +maxbl*mask_bloom,1),cmask); else
	cmask=max(lerp(cmask,cmask*(1.0-0.5*maxbl)+plant(pow( Bloom,0.35.xxx),maxbl),-mask_bloom),cmask);
	}
	color=pow(color,mask_gamma/gamma_in);
	color=color*cmask;
	color=min(color,1.0);
	color=pow(color,gamma_in/mask_gamma);
	cmask=min(cmask,1.0);
	dmask=min(dmask,1.0);
	}
	float dark_compensate=lerp(max(clamp(lerp(mcut,maskstr,mx),0.0,1.0)-1.0+ mask_compensate,0.0)+1.0,1.0,mx); if(shadow_msk< -0.5) dark_compensate=1.0;
	float bb=lerp(brightboost1,brightboost2,mx)* dark_compensate; color*=bb;
	float3 Ref=texCD(PAL_S08,pos).rgb;
	float maxb=texCD(PAL_S13,pos).a;
	float vig =texCD(PAL_S02,clamp(pos,0.0+0.5*OrgSize.zw,1.0-0.5*OrgSize.zw)).a;
	if(pr_scan > 0.025)
	{
		float mbl = max(max(Bloom.r,Bloom.g),Bloom.b);
		Bloom = lerp(Bloom, lerp(Bloom, plant(orig1,mbl), min(2.5*(1.0-w3),1.0)), min(2.0*pr_scan, 1.0));
	}	
	float3 bcmask=lerp(one,dmask,b_mask);
	float3 hcmask=lerp(one,dmask,h_mask);
	float3 Bloomy=Bloom;
	if(abs(blm_1)>0.025)
	{
	if(blm_1<-0.01)Bloomy=plant(Bloom,maxb);
	Bloomy= min(Bloomy*(orig1+color),max(0.5*(colmx+orig1-color),0.001*Bloomy));
	Bloomy=0.5*(Bloomy+lerp(Bloomy,lerp(colmx*orig1,Bloomy,0.5),1.0-color));
	Bloomy= bcmask*Bloomy*max(lerp(1.0,2.0-colmx,bloom_dist),0);
	color=pow(pow(color,mask_gamma/gamma_in)+abs(blm_1)*pow( Bloomy,mask_gamma/gamma_in),gamma_in/mask_gamma);
	}
	if(halation> 0.01)
	{
	Bloom= 0.5*(Bloom+Bloom*Bloom);float mbl=max(max(Bloom.r,Bloom.g),Bloom.b);float mxh=0.5*(colmx+colmx*colmx);
	mbl=lerp(lerp(mxh,lerp( mxh,mbl,mbl),colmx),mbl,mb);
	Bloom=plant(Bloom,lerp(sqrt(mbl*mxh),max((mbl-0.15*(1.0-colmx)),0.4*mxh),pow(colmx,0.25)))*lerp(0.425,1.0,colmx);
	Bloom=(3.0-colmx-color)*plant(0.325+orig1/w3,0.5*(1.0+w3))*hcmask*Bloom;
	color=pow(pow(color,mask_gamma/gamma_in)+ halation *pow( Bloom ,mask_gamma/gamma_in),gamma_in/mask_gamma);
	}else
	if(halation<-0.01)
	{
	float mbl=max(max(Bloom.r,Bloom.g),Bloom.b);
	Bloom=plant(Bloom+Ref+orig1+Bloom*Bloom*Bloom,min(mbl*mbl,0.75));
	Bloom = 2.0*lerp(1.0,w3,0.5*colmx)*hcmask*Bloom;
	color = color -halation*Bloom;
	}
	color=min(color,1.0);
	color=gc2(color,w3 );
	if(smoothmask>0.125){float w4=pow(w3,0.425+0.3*smoothmask);w4=max(w4-0.175*colmx*smoothmask,0.2);color=lerp(min(color/w4,plant(orig1,1.0+0.175*colmx*smoothmask))*w4,color,w4);}
	if(m_glow<0.5)Glow=lerp(Glow,0.25*color,colmx);else
	{
	float3 orig2=plant(orig1+0.001*Ref,1.0); maxb=max(max(Glow.r,Glow.g),Glow.b);
	Bloom=plant(Glow,1.0);Ref=abs(orig2-Bloom);
	mx0=max(max(orig2.r,orig2.g),orig2.b)-min(min(orig2.r,orig2.g),orig2.b);
	mx2=max(max(Bloom.r,Bloom.g),Bloom.b)-min(min(Bloom.r,Bloom.g),Bloom.b);
	Bloom=lerp(maxb*min(Bloom,orig2),lerp(lerp(Glow,max(max(Ref.r,Ref.g),Ref.b)*Glow,max(mx,mx0)),lerp(color,Glow,mx2),max(mx0,mx2)*Ref),min(sqrt((1.10-mx0)*(0.10+mx2)),1.0));
	if(m_glow>1.5)Glow=lerp(0.5*Glow*Glow,Bloom,Bloom);
	Glow=lerp(m_glow_low*Glow,m_glow_high*Bloom,pow(colmx,m_glow_dist/gamma_in));
	}
	if(m_glow<0.5)
	{
	if(glow >=0.0)color=color+0.5*Glow*glow;else color=color+abs(glow)*min(emask*emask,1.0)*Glow;}else
	{
	float3 fmask=clamp(lerp(one,dmask,m_glow_mask),0.0,1.0);
	color=color+abs(glow)*fmask*Glow;
	}
	color=min(color,1.0);
	if(edgemask>0.05)
	{
	mx0=texCD(PAL_S14,pos1-dx).a;mx0=texCD(PAL_S14,pos1-dx*(1.0-0.75*sqrt(mx0))).a;
	mx2=texCD(PAL_S14,pos1+dx).a;mx2=texCD(PAL_S14,pos1+dx*(1.0-0.75*sqrt(mx2))).a;
	float mx3=texCD(PAL_S14,pos1-4.0*dx).a;
	float mx4=texCD(PAL_S14,pos1+4.0*dx).a;
	mx4=max(pow(abs(mx3-mx4),0.55-0.40*cx),min(max(mx3,mx4)/min(0.1+cx,1.0),1.0));
	mb=(1.0-abs(pow(mx0,1.0-0.65*mx2)-pow(mx2,1.0-0.65*mx0)));
	mb=mx4*edgemask*(1.0001-mb*mb);float3 temp=lerp(color,orig1,mb);
	color=max(temp+lerp(3.5*mb*lerp(1.625*temp,temp,cx),0.0.xxx,pow(color,0.75.xxx -0.5*colmx)),color);
	}
	color=color* lerp(1.0,lerp(0.5*(1.0+w3),w3,mx),pr_scan);
	color=min(color,max(orig1,color)*lerp(one,dmask,mclip));
	color=pow(color,1.0/gamma_o);
	float q=0.6*sqrt(max(max(color.r,color.g),color.b))+0.4;
	if(abs(addnoised)>0.01)
	{
	float3 noise0=noise(float3(floor(NewSize.xy*fuxcoord/noiseresd),float(framecount)));
	if(noisetype<0.5)color=lerp(color,noise0,0.25*abs(addnoised)*q);else
	color=min(color* lerp(1.0,1.5*noise0.x,0.5*abs(addnoised)),1.0);
	}
	colmx=max(max(orig1.r,orig1.g),orig1.b);
	color=color+bmask*lerp(emask,0.125*(1.0-colmx)*color,min(20.0*colmx,1.0));
	return lerp(float4(color*vig*humbars(lerp(pos.y, pos.x, bardir))*post_br*corner(posb), 1.0), 
	            texCD(PAL_S0S, (floor(pos1*OrgSize.xy)+0.5)*OrgSize.zw), step(pos1.x,oimage-0.00025));
}

float4 RatioSizePS(float4 position:SV_Position,float2 texcoord:TEXCOORD):SV_Target
{
    const bool margins=float(texcoord.x>=coord_w&&texcoord.x<=coord_e&&texcoord.y>=coord_n&&texcoord.y<=coord_s);
    const float2 boxcoord=((texcoord-correct)*OptSize.xy+0)/BoxSize;
    const float4 boxcolor=texCD(PAL_S15,boxcoord);
    const float4 orgcolor=texCD(PAL_S00,texcoord);
    return lerp(orgcolor,float4(margins*boxcolor.rgb,boxcolor.a),float(margins));
}

technique CRT_Guest_PAL
{
	pass StockPass
	{
	VertexShader=CropProcessVS;
	PixelShader=StockPassPS;
	RenderTarget=PAL_T0S;
	PrimitiveTopology=TRIANGLESTRIP;
	VertexCount=4;
	}
	pass Afterglow
	{
	VertexShader=PostProcessVS;
	PixelShader=AfterglowPS;
	RenderTarget=PAL_T01;
	}
	pass PreShader
	{
	VertexShader=PostProcessVS;
	PixelShader=PreShaderPS;
	RenderTarget=PAL_T02;
	}
	pass Interlace
	{
	VertexShader=PostProcessVS;
	PixelShader=InterlacePS;
	RenderTarget=PAL_T0I;
	}
	pass PALPASS1
	{
	VertexShader=PostProcessVS;
	PixelShader=Signal_1_PS;
	RenderTarget=PAL_T03;
	}
	pass PALPASS2
	{
	VertexShader=PostProcessVS;
	PixelShader=Signal_2_PS;
	RenderTarget=PAL_T04;
	}
	pass PALPASS3
	{
	VertexShader=PostProcessVS;
	PixelShader=Signal_3_PS;
	RenderTarget=PAL_T05;
	}
	pass Sharpness
	{
	VertexShader=PostProcessVS;
	PixelShader=SharpnessPS;
	RenderTarget=PAL_T06;
	}
	pass Luminance
	{
	VertexShader=PostProcessVS;
	PixelShader=LuminancePS;
	RenderTarget=PAL_T07;
	}
	pass Linearize
	{
	VertexShader=PostProcessVS;
	PixelShader=LinearizeNewPS;
	RenderTarget=PAL_T08;
	}
	pass CRT_Pass1
	{
	VertexShader=PostProcessVS;
	PixelShader=PAL_TV1_PS;
	RenderTarget=PAL_T09;
	}
	pass GaussianX
	{
	VertexShader=PostProcessVS;
	PixelShader=HGaussianPS;
	RenderTarget=PAL_T10;
	}
	pass GaussianY
	{
	VertexShader=PostProcessVS;
	PixelShader=VGaussianPS;
	RenderTarget=PAL_T11;
	}
	pass BloomHorz
	{
	VertexShader=PostProcessVS;
	PixelShader=BloomHorzPS;
	RenderTarget=PAL_T12;
	}
	pass BloomVert
	{
	VertexShader=PostProcessVS;
	PixelShader=BloomVertPS;
	RenderTarget=PAL_T13;
	}
	pass CRT_Pass2
	{
	VertexShader=PostProcessVS;
	PixelShader=PAL_TV2_PS;
	RenderTarget=PAL_T14;
	}
	pass Chromatic
	{
	VertexShader=PostProcessVS;
	PixelShader=ChromaticPS;
	RenderTarget=PAL_T15;
	}
	pass RatioSize
	{
	VertexShader=PostProcessVS;
	PixelShader=RatioSizePS;
	}
}

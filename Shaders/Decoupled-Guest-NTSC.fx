/*

	Decoupled - Guest - NTSC

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

	Ported to ReShade by DevilSingh with some help from guest(r).
	Updated to crt-guest-advanced-2025-11-30-release1 by Jobima.
	Relevant sections decoupled for more granular utility by Azurfel.
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
> = 0.0;

uniform float PG <
	ui_category = "Afterglow Settings";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 0.5;
	ui_step = 0.01;
	ui_label = "Persistence Green";
> = 0.0;

uniform float PB <
	ui_category = "Afterglow Settings";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 0.5;
	ui_step = 0.01;
	ui_label = "Persistence Blue";
> = 0.0;

uniform float AS <
	ui_category = "Afterglow Settings";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 0.6;
	ui_step = 0.01;
	ui_label = "Afterglow Strength";
> = 0.0;

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
> = -1.0;

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
> = 0.0;

uniform float iscanb <
	ui_category = "Interlacing Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.05;
	ui_label = "Interlacing Scanline Effect ('Laced Brightness)";
> = 0.0;

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
> = 0.0;

uniform float hiscan <
	ui_category = "Resolution/Scaling Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 1.0;
	ui_label = "High Resolution Scanlines (prepend a scaler...)";
> = 0.0;

uniform float filter_res <
	ui_category = "Resolution/Scaling Options";
	ui_type = "drag";
	ui_min = 0.5;
	ui_max = 8.0;
	ui_step = 0.1;
	ui_label = "Horizontal Filtering Resolution";
> = 1.0;

uniform float speedup <
	ui_category = "Resolution/Scaling Options";
	ui_type = "drag";
	ui_min = 1.0;
	ui_max = 4.0;
	ui_step = 1.0;
	ui_label = "Speedup w. higher Internal Res.";
> = 1.0;

uniform float cust_artifacting <
	ui_category = "NTSC Settings";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 5.0;
	ui_step = 0.1;
	ui_label = "NTSC Artifacting Value";
> = 0.0;

uniform float cust_fringing <
	ui_category = "NTSC Settings";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 5.0;
	ui_step = 0.1;
	ui_label = "NTSC Fringing Value";
> = 0.0;

uniform float ntsc_fields <
	ui_category = "NTSC Settings";
	ui_type = "drag";
	ui_min = -1.0;
	ui_max = 1.0;
	ui_step = 1.0;
	ui_label = "NTSC Merge Fields: Auto | No | Yes";
> = -1.0;

uniform float ntsc_phase <
	ui_category = "NTSC Settings";
	ui_type = "drag";
	ui_min = 1.0;
	ui_max = 5.0;
	ui_step = 1.0;
	ui_label = "NTSC Phase: Auto | 2 Phase | 3 Phase | Mixed | PCE";
> = 1.0;

uniform float ntsc_scale <
	ui_category = "NTSC Settings";
	ui_type = "drag";
	ui_min = 0.2;
	ui_max = 2.5;
	ui_step = 0.025;
	ui_label = "NTSC Resolution Scaling";
> = 1.0;

uniform float nscale <
	ui_category = "NTSC Settings";
	ui_type = "drag";
	ui_min = 0.2;
	ui_max = 2.5;
	ui_step = 0.025;
	ui_label = "NTSC Filter Scaling";
> = 1.0;

uniform float ntsc_sat <
	ui_category = "NTSC Settings";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 2.0;
	ui_step = 0.01;
	ui_label = "NTSC Color Saturation";
> = 1.0;

uniform float ntsc_brt <
	ui_category = "NTSC Settings";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.5;
	ui_step = 0.01;
	ui_label = "NTSC Brightness";
> = 1.0;

uniform float ntsc_gamma <
	ui_category = "NTSC Settings";
	ui_type = "drag";
	ui_min = 0.25;
	ui_max = 2.5;
	ui_step = 0.025;
	ui_label = "NTSC Filtering Gamma Correction";
> = 1.0;

uniform float ntsc_rainbow <
	ui_category = "NTSC Settings";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 3.0;
	ui_step = 1.0;
	ui_label = "NTSC Coloring/Rainbow Effect (2-phase)";
> = 0.0;

uniform float ntsc_taps <
	ui_category = "NTSC Settings";
	ui_type = "drag";
	ui_min = 6.0;
	ui_max = 48.0;
	ui_step = 1.0;
	ui_label = "NTSC # of Taps (Filter Width)";
> = 32.0;

uniform float ntsc_charp1 <
	ui_category = "NTSC Settings";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 10.0;
	ui_step = 0.5;
	ui_label = "NTSC Preserve 'Edge' Colors (2-phase)";
> = 0.0;

uniform float ntsc_charp2 <
	ui_category = "NTSC Settings";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 10.0;
	ui_step = 0.5;
	ui_label = "NTSC Preserve 'Edge' Colors (3-phase)";
> = 0.0;

uniform float ntsc_cscale1 <
	ui_category = "NTSC Settings";
	ui_type = "drag";
	ui_min = 0.5;
	ui_max = 4.00;
	ui_step = 0.05;
	ui_label = "NTSC Chroma Scaling/Bleeding (2-phase)";
> = 3.2;

uniform float ntsc_cscale2 <
	ui_category = "NTSC Settings";
	ui_type = "drag";
	ui_min = 0.2;
	ui_max = 2.25;
	ui_step = 0.05;
	ui_label = "NTSC Chroma Scaling/Bleeding (3-phase)";
> = 1.0;

uniform float ntsc_ring <
	ui_category = "NTSC Settings";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.1;
	ui_label = "NTSC Anti-Ringing";
> = 0.0;

uniform float ntsc_shrp <
	ui_category = "NTSC Settings";
	ui_type = "drag";
	ui_min = -10.0;
	ui_max = 10.0;
	ui_step = 0.5;
	ui_label = "NTSC Sharpness (Adaptive)";
> = 0.0;

uniform float ntsc_fonts <
	ui_category = "NTSC Settings";
	ui_type = "drag";
	ui_min = 0.25;
	ui_max = 0.75;
	ui_step = 0.01;
	ui_label = "NTSC Preserve Fonts (0.25 = OFF)";
> = 0.25;

uniform float ntsc_shpe <
	ui_category = "NTSC Settings";
	ui_type = "drag";
	ui_min = 0.5;
	ui_max = 1.0;
	ui_step = 0.025;
	ui_label = "NTSC Sharpness Shape";
> = 0.8;

uniform float RFNOISE <
	ui_category = "RF Noise Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.01;
	ui_label = "NTSC RF Noise Frequency";
> = 0.0;

uniform float RFNOISE1 <
	ui_category = "RF Noise Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 0.7;
	ui_step = 0.01;
	ui_label = "NTSC RF Noise Luma+";
> = 0.0;

uniform float RFNOISE2 <
	ui_category = "RF Noise Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 0.7;
	ui_step = 0.01;
	ui_label = "NTSC RF Noise Chroma+";
> = 0.0;

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
> = 0.0;

uniform float CDETAILS <
	ui_category = "FSharpen";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 1.0;
	ui_step = 0.05;
	ui_label = "FSharpen - Details sharpened";
> = 0.0;

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
> = 0.0;

uniform float MAXS <
	ui_category = "Filtering Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 0.3;
	ui_step = 0.01;
	ui_label = "Maximum Sharpness";
> = 0.0;

uniform float SSRNG <
	ui_category = "Filtering Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 4.0;
	ui_step = 0.05;
	ui_label = "Substractive Sharpness Ringing";
> = 0.0;

uniform float spike <
	ui_category = "Filtering Options";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 2.0;
	ui_step = 0.1;
	ui_label = "Scanline Spike Removal";
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
#define eps 1e-8
#define pii 3.14159265
#define fracoord (fuxcoord*NewSize.xy)
#define texCD(c,d) tex2Dlod(c,float4(d,0,0))
#define LumSize float4(2.0*TexSize.x,1.0*TexSize.y,1.0/(2.0*TexSize.x),1.0/(1.0*TexSize.y))
#define rgb_m float3x3(0.2989,0.587,0.114,0.5959,-0.2744,-0.3216,0.2115,-0.5229,0.3114)
#define yiq_m float3x3(1.000,0.956,0.621,1.000,-0.272,-0.6474,1.000,-1.106,1.7046)
#define fetch_offset1(dx)  texCD(NTSCDE_S03,tex_c+dx).xyz+texCD(NTSCDE_S03,tex_c-dx).xyz
#define fetch_offset2(dx) float3(texCD(NTSCDE_S03,tex_c+dx.xz).x+texCD(NTSCDE_S03,tex_c-dx.xz).x,texCD(NTSCDE_S03,tex_c+dx.yz).yz+texCD(NTSCDE_S03,tex_c-dx.yz).yz)

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

#define NTSCDE_S00 ReShade::BackBuffer

texture NTSCDE_T0S{Width=1.0*Resolution_X;Height=Resolution_Y;Format=RGBA16F;};
sampler NTSCDE_S0S{Texture=NTSCDE_T0S;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=POINT ;MinFilter=POINT ;MipFilter=POINT ;};

texture NTSCDE_T01{Width=1.0*Resolution_X;Height=Resolution_Y ;Format=RGBA16F;};
sampler NTSCDE_S01{Texture=NTSCDE_T01;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=POINT ;MinFilter=POINT ;MipFilter=POINT ;};

texture NTSCDE_T02{Width=1.0*Resolution_X;Height=Resolution_Y ;Format=RGBA16F;};
sampler NTSCDE_S02{Texture=NTSCDE_T02;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=POINT ;MinFilter=POINT ;MipFilter=POINT ;};

texture NTSCDE_T0I{Width=1.0*Resolution_X;Height=Resolution_Y ;Format=RGBA16F;};
sampler NTSCDE_S0I{Texture=NTSCDE_T0I;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=LINEAR;MinFilter=LINEAR;MipFilter=LINEAR;};

texture NTSCDE_T03{Width=4.0*Resolution_X;Height=Resolution_Y ;Format=RGBA16F;};
sampler NTSCDE_S03{Texture=NTSCDE_T03;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=LINEAR;MinFilter=LINEAR;MipFilter=LINEAR;};

texture NTSCDE_T04{Width=2.0*Resolution_X;Height=Resolution_Y ;Format=RGBA16F;};
sampler NTSCDE_S04{Texture=NTSCDE_T04;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=LINEAR;MinFilter=LINEAR;MipFilter=LINEAR;};

texture NTSCDE_T05{Width=2.0*Resolution_X;Height=Resolution_Y ;Format=RGBA16F;};
sampler NTSCDE_S05{Texture=NTSCDE_T05;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=LINEAR;MinFilter=LINEAR;MipFilter=LINEAR;};

texture NTSCDE_T06{Width=2.0*Resolution_X;Height=Resolution_Y ;Format=RGBA16F;};
sampler NTSCDE_S06{Texture=NTSCDE_T06;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=LINEAR;MinFilter=LINEAR;MipFilter=LINEAR;};

texture NTSCDE_T08{Width=2.0*Resolution_X;Height=Resolution_Y ;Format=RGBA16F;};
sampler NTSCDE_S08{Texture=NTSCDE_T08;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=LINEAR;MinFilter=LINEAR;MipFilter=LINEAR;};

texture NTSCDE_001<source="CRT-LUT-1.png";>{Width=1024;Height=32;};
sampler NTSCDE_L01{Texture=NTSCDE_001;};

texture NTSCDE_002<source="CRT-LUT-2.png";>{Width=1024;Height=32;};
sampler NTSCDE_L02{Texture=NTSCDE_002;};

texture NTSCDE_003<source="CRT-LUT-3.png";>{Width=1024;Height=32;};
sampler NTSCDE_L03{Texture=NTSCDE_003;};

texture NTSCDE_004<source="CRT-LUT-4.png";>{Width=1024;Height=32;};
sampler NTSCDE_L04{Texture=NTSCDE_004;};

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
	3.0*texCD(NTSCDE_S06,coord   ).rgb+2.0*texCD(NTSCDE_S06,coord+dx).rgb+2.0*texCD(NTSCDE_S06,coord-dx).rgb+
	2.0*texCD(NTSCDE_S06,coord+dy).rgb+2.0*texCD(NTSCDE_S06,coord-dy).rgb+    texCD(NTSCDE_S06,coord+d1).rgb+
		texCD(NTSCDE_S06,coord-d1).rgb+    texCD(NTSCDE_S06,coord+d2).rgb+    texCD(NTSCDE_S06,coord-d2).rgb;
	return result/sum;
}

float crthd_h(float x,float y)
{
	return exp(-x*x*y);
}

float mod(float x,float y)
{
	return x-y* floor(x/y);
}

float3 rgb2yiq(float3 r)
{
	return mul(rgb_m, r);
}

float3 yiq2rgb(float3 y)
{
	return mul(yiq_m, y);
}

float get_luma(float3 c)
{
	return dot(c,float3(0.299,0.587,0.114));
}

float swoothstep(float e0,float e1,float x)
{
	return clamp((x-e0)/(e1-e0),0.0,1.0);
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
	return texCD(NTSCDE_S00,texcoord);
}

float4 AfterglowPS(float4 position:SV_Position,float2 texcoord:TEXCOORD):SV_Target
{
	float2 dx=float2(OrgSize.z,0.0);
	float2 dy=float2(0.0,OrgSize.w);
	float w=1.0;
	float3 color0=texCD(NTSCDE_S0S,texcoord   ).rgb;
	float3 color1=texCD(NTSCDE_S0S,texcoord-dx).rgb;
	float3 color2=texCD(NTSCDE_S0S,texcoord+dx).rgb;
	float3 color3=texCD(NTSCDE_S0S,texcoord-dy).rgb;
	float3 color4=texCD(NTSCDE_S0S,texcoord+dy).rgb;
	float3 cr=(2.5*color0+color1+color2+color3+color4)/6.5;
	float3 a=texCD(NTSCDE_S01,texcoord).rgb;
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
	float4 imgColor=texCD(NTSCDE_S0S,texcoord);
	float4 aftrglow=texCD(NTSCDE_S01,texcoord);
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
	color1=texCD(NTSCDE_L01,coord1);
	color2=texCD(NTSCDE_L01,coord2);
	res=lerp(color1,color2,f);
	}else
	if(int(TNTC)==2)
	{
	color1=texCD(NTSCDE_L02,coord1);
	color2=texCD(NTSCDE_L02,coord2);
	res=lerp(color1,color2,f);
	}else
	if(int(TNTC)==3)
	{
	color1=texCD(NTSCDE_L03,coord1);
	color2=texCD(NTSCDE_L03,coord2);
	res=lerp(color1,color2,f);
	}else
	if(int(TNTC)==4)
	{
	color1=texCD(NTSCDE_L04,coord1);
	color2=texCD(NTSCDE_L04,coord2);
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
    float3 c1=texCD(NTSCDE_S02,fuxcoord).rgb;
    float3 c2=texCD(NTSCDE_S02,fuxcoord+float2(0.0,OrgSize.w)).rgb;
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
	float2 vtexcoord=texcoord*float2(speedup, 1.0);
	float pix_res= min(ntsc_scale,1.0);
	float phase= (ntsc_phase<1.5)?((OrgSize.x>300.0)? 2.0:3.0):((ntsc_phase>2.5)?3.0:2.0);
	if(ntsc_phase==4.0)phase=3.0; else if (ntsc_phase == 5.0) phase = 2.0;
	float res=ntsc_scale;
	float CHROMA_MOD_FREQ=(phase == 2.0 && ntsc_phase != 5.0) ? (4.0 * pii / 15.0) : ((OrgSize <= 300.0 || phase == 3.0) ? (pii / 3.0) : (pii/2.0));
	float ARTIFACT=cust_artifacting;
	float FRINGING=cust_fringing;
	float BRIGHTNESS=ntsc_brt;
	float SATURATION=ntsc_sat;
	float MERGE=0.0;
	if(ntsc_fields== -1.0&&phase==3.0) MERGE=1.0;else
	if(ntsc_fields== 0.0) MERGE=0.0;else
	if(ntsc_fields== 1.0) MERGE=1.0;
	float3x3 mix_m = float3x3(BRIGHTNESS,ARTIFACT,ARTIFACT,FRINGING,2.0*SATURATION,0.0,FRINGING,0.0,2.0*SATURATION);
	float2 pix_no=vtexcoord*OrgSize.xy*pix_res* float2(4.0,1.0);
	if (vtexcoord.x > 1.0) return 0.0.xxxx; else
	{
	float3 col0=texCD(NTSCDE_S0I, vtexcoord).rgb;
	float3 yiq1=rgb2yiq(col0);
	yiq1.x=pow(yiq1.x,ntsc_gamma); float lum=yiq1.x;
	float3 temp=yiq1;
	float3 yiq2=yiq1;
	float3 yiqs=yiq1;
	float3 yiqz=yiq1;
	float mit=ntsc_taps;if(ntsc_charp1>0.25&&phase==2.0)mit=clamp(mit,8.0,min(ntsc_taps,14.0));
	mit=swoothstep(16.0,8.0,mit)*0.325;
	if(MERGE>0.5)
	{
	float chroma_phase2=(phase<2.5)?pii*(mod(pix_no.y,2.0)+mod(float(framecount)+1,2.)):0.6667*pii*(mod(pix_no.y,3.0)+mod(float(framecount)+1,2.));
	float mod_phase2=chroma_phase2+pix_no.x*CHROMA_MOD_FREQ;
	float i_mod2=cos( mod_phase2 );
	float q_mod2=sin( mod_phase2 );
	yiq2.yz*=float2(i_mod2,q_mod2);
	yiq2=mul(mix_m,yiq2);
	yiq2.yz*=float2(i_mod2,q_mod2);
	yiq2.yz =lerp(yiq2.yz,temp.yz,mit);
	if(res>1.025)
	{
	mod_phase2=chroma_phase2 +res *pix_no.x*CHROMA_MOD_FREQ;
	i_mod2=cos(mod_phase2);
	q_mod2=sin(mod_phase2);
	yiqs.yz*=float2(i_mod2,q_mod2);
	yiq2.x=dot(yiqs,mix_m[0]);
	}
	}
	float chroma_phase1=(phase<2.5)?pii*(mod(pix_no.y,2.0)+mod(float(framecount)  ,2.)):0.6667*pii*(mod(pix_no.y,3.0)+mod(float(framecount)  ,2.));
	float mod_phase1=chroma_phase1+pix_no.x*CHROMA_MOD_FREQ;
	float i_mod1=cos( mod_phase1 );
	float q_mod1=sin( mod_phase1 );
	yiq1.yz*=float2(i_mod1,q_mod1);
	yiq1=mul(mix_m,yiq1);
	yiq1.yz*=float2(i_mod1,q_mod1);
	yiq1.yz =lerp(yiq1.yz,temp.yz,mit);
	if(res>1.025)
	{
	mod_phase1=chroma_phase1 +res *pix_no.x*CHROMA_MOD_FREQ;
	i_mod1=cos(mod_phase1);
	q_mod1=sin(mod_phase1);
	yiqz.yz*=float2(i_mod1,q_mod1);
	yiq1.x=dot(yiqz,mix_m[0]);
	}
	if(ntsc_phase==4.0){yiq1.x=lum;yiq2.x=lum;}
	if(MERGE>0.5){if(ntsc_rainbow<0.5||phase>2.5)yiq1=0.5*(yiq1+yiq2); else yiq1.x=0.5*(yiq1.x+yiq2.x);}
	return float4(yiq1,lum);
	}
}

float4 Signal_2_PS(float4 position:SV_Position,float2 texcoord:TEXCOORD):SV_Target
{
	float chroma_filter_2_phase[33]={
    0.001384762, 0.001678312, 0.002021715, 0.002420562, 0.002880460, 0.003406879, 0.004004985, 0.004679445, 0.005434218, 0.006272332, 0.007195654,
    0.008204665, 0.009298238, 0.010473450, 0.011725413, 0.013047155, 0.014429548, 0.015861306, 0.017329037, 0.018817382, 0.020309220, 0.021785952,
    0.023227857, 0.024614500, 0.025925203, 0.027139546, 0.028237893, 0.029201910, 0.030015081, 0.030663170, 0.031134640, 0.031420995, 0.031517031};
	float chroma_filter_3_phase[33]={
    0.000000000, 0.000000000, 0.000000000, 0.000000000, 0.000000000,
    0.000000000, 0.000000000, 0.000000000,
   -0.000118847,-0.000271306,-0.000502642,-0.000930833,-0.001451013,
   -0.002064744,-0.002700432,-0.003241276,-0.003524948,-0.003350284,
   -0.002491729,-0.000721149, 0.002164659, 0.006313635, 0.011789103,
    0.018545660, 0.026414396, 0.035100710, 0.044196567, 0.053207202,
    0.061590275, 0.068803602, 0.074356193, 0.077856564, 0.079052396};
	float luma_filter_2_phase[33]={
   -0.000174844,-0.000205844,-0.000149453,-0.000051693, 0.000000000,-0.000066171,-0.000245058,-0.000432928,-0.000472644,-0.000252236, 0.000198929,
    0.000687058, 0.000944112, 0.000803467, 0.000363199, 0.000013422, 0.000253402, 0.001339461, 0.002932972, 0.003983485, 0.003026683,-0.001102056,
   -0.008373026,-0.016897700,-0.022914480,-0.021642347,-0.028863273, 0.027271957, 0.054921920, 0.098342579, 0.139044281, 0.168055832, 0.178571429};
	float luma_filter_3_phase[33]={
    0.000000000, 0.000000000, 0.000000000, 0.000000000, 0.000000000,
    0.000000000, 0.000000000, 0.000000000,
   -0.000012020,-0.000022146,-0.000013155,-0.000012020,-0.000049979,
   -0.000113940,-0.000122150,-0.000005612, 0.000170516, 0.000237199,
    0.000169640, 0.000285688, 0.000984574, 0.002018683, 0.002002275,
   -0.005909882,-0.012049081,-0.018222860,-0.022606931, 0.002460860,
    0.035868225, 0.084016453, 0.135563500, 0.175261268, 0.220176552};
	const int TAPS_2_phase=32;
	const int TAPS_3_phase=24;
	float res=ntsc_scale * nscale;
	float3 signal=0.0;
	float2 one=0.25*OrgSize.zz/res/speedup;
	float2 tex_c=texcoord+float2(0.5/speedup*OrgSize.z/4.0,0.0);
	if (tex_c.x * speedup > (1.00325)) discard;
	float phase= ( ntsc_phase<1.5)?((OrgSize.x>300.0)?2.0:3.0):((ntsc_phase>2.5)?3.0:2.0);
	if(ntsc_phase>3.5){phase=3.0;luma_filter_3_phase=luma_filter_2_phase;}
	float3 wsum =0.0.xxx;
	float3 sums=wsum;
	float3 tmps=wsum;
	float offset=0.0;int i=0;
	float j =0.0;
	if(phase<2.5)
	{
	float loop=max(ntsc_taps,8.0);
	if(ntsc_charp1>0.25)loop=min(loop,14.0);
	float loob=loop+1.0;
	float taps=0.0;
	float ssub=loop-loop/ntsc_cscale1;
	float mit=1.0+0.04*pow(swoothstep(16.0,8.0,loop),0.5);
	float2 dx=float2(one.x*mit,0.0);
	float2 xd=dx; int loopstart=int(TAPS_2_phase-loop);
	for(i=loopstart;i<32;i++)
	{
	offset=float(i-loopstart);
	j=offset+1.0;xd= (offset-loop)*dx;
	sums=fetch_offset1(xd);
	taps=max(j-ssub,0.0);
	tmps=float3(luma_filter_2_phase[max(i,0)], taps.xx );
	wsum=wsum+tmps; signal+=sums*tmps;
	}
	taps=loob-ssub;
	tmps=float3(luma_filter_2_phase[TAPS_2_phase], taps.xx);
	wsum=wsum+wsum+tmps;
	signal+=texCD(NTSCDE_S03,tex_c).xyz*tmps;
	signal =signal/wsum;
	}else
	{
	float loop=min(ntsc_taps,TAPS_3_phase); one.y=one.y/ntsc_cscale2;
	float mit=1.0;
	if(ntsc_phase>3.5){loop=max(loop,8.0); mit=1.0+0.04*pow(swoothstep(16.0,8.0,loop),0.5);}
	float3 dx=float3(one.x,one.y,0.0);
	float3 xd=dx; int loopstart=int(32.0-loop);
	dx.x*=mit;
	for(i=loopstart;i<32;i++)
	{
	offset=float(i-loopstart);
	xd.xy=(offset-loop)*dx.xy;
	sums=fetch_offset2(xd);
	tmps=float3(luma_filter_3_phase[i], chroma_filter_3_phase[i].xx);
	wsum=wsum+tmps; signal+=sums*tmps;
	}
	tmps=float3(luma_filter_3_phase[TAPS_2_phase], chroma_filter_3_phase[TAPS_2_phase], chroma_filter_3_phase[TAPS_2_phase]);
	wsum=wsum+wsum+tmps;
	signal+=texCD(NTSCDE_S03,tex_c).xyz*tmps;
	signal =signal/wsum;
	}
	signal.x=clamp( signal.x,0.0,1.0);
	if(ntsc_ring>0.05)
	{
	float2 dx=float2(OrgSize.z/min(res,1.0)/speedup,0.0);
	float a=texCD(NTSCDE_S03,tex_c-2.0*dx).a;
	float b=texCD(NTSCDE_S03,tex_c-    dx).a;
	float c=texCD(NTSCDE_S03,tex_c+2.0*dx).a;
	float d=texCD(NTSCDE_S03,tex_c+    dx).a;
	float e=texCD(NTSCDE_S03,tex_c       ).a;
	signal.x=lerp(signal.x,clamp(signal.x,min(min(min(a,b),min(c,d)),e),max(max(max(a,b),max(c,d)),e)),ntsc_ring);
	}
	float x=get_luma(texCD(NTSCDE_S02, tex_c*float2(speedup, 1.0)).rgb);
	return float4(signal,x);
}

float4 Signal_3_PS(float4 position:SV_Position,float2 texcoord:TEXCOORD):SV_Target
{
    float2 vtex_c0=texcoord / float2(speedup, 1.0);
    float2 vtex_c1=(floor(vtex_c0*OrgSize.xy)+0.5)*OrgSize.zw;
    float2 vtex_c=texcoord+float2(0.5*OrgSize.z/4.0,0.0);

    float4 AdvSize= LumSize;

    if(speedup > 1.25 && ((OrgSize.y > 500.0 && AdvSize.y > 820.0) || AdvSize.y > 820.0))
    {
        float3 signal = texCD(NTSCDE_S04, vtex_c0).xyz;
        signal.x = pow(signal.x, 1.0/ntsc_gamma);
        return float4(clamp(yiq2rgb(signal), 0.0, 1.0), 1.0);
    }
    else
    {

	float2 dx=float2(0.0625*OrgSize.z / speedup,0.0);
	float2 xx=float2(0.5000*OrgSize.z / speedup,0.0);

	float2 tcoorb=(floor(OrgSize.xy*vtex_c)+0.5)*OrgSize.zw;
	float2 tcoord=vtex_c-2.0*dx;
	float2 vTex=vtex_c;
	if (speedup > 1.25) { tcoorb = vtex_c1; tcoord = vtex_c0; vTex = vtex_c0; }
	float3 ll1=texCD(NTSCDE_S04,tcoord+ xx).xyz;
	float3 ll2=texCD(NTSCDE_S04,tcoord- xx).xyz;
	float dy=0.0;
	float2 yy = float2(0.0, OrgSize.w);
	xx=float2(OrgSize.z/speedup,0.0);
	float phase= (ntsc_phase<1.5)?((OrgSize.x>300.0)? 2.0:3.0):((ntsc_phase>2.5)?3.0:2.0);
	if(ntsc_phase>3.5)phase=3.0;
	float th=(phase<2.5)?0.025:0.0075;;
	float ca=texCD(NTSCDE_S03,tcoorb-xx-xx).a;
	float c0=texCD(NTSCDE_S03,tcoorb-xx   ).a;
	float c1=texCD(NTSCDE_S03,tcoorb      ).a;
	float c2=texCD(NTSCDE_S03,tcoorb+xx   ).a;
	float cb=texCD(NTSCDE_S03,tcoorb+xx+xx).a;
	float line0=    swoothstep(th,0.0,min(abs(c1-c0),abs(c2-c1)));
	float line1=max(swoothstep(th,0.0,min(abs(ca-c0),abs(c2-cb))), line0 );
	float line2=max(swoothstep(th,0.0,min(abs(ca-c2),abs(c0-cb))), line1 );

    float diffboost = 0.0;

    if (ntsc_fonts > 0.255)
    {
        float b1  = texCD(NTSCDE_S03, tcoorb - yy).a;
        float d1  = texCD(NTSCDE_S03, tcoorb + yy).a;
        float d2  = texCD(NTSCDE_S03, tcoorb + xx + yy).a;

        float maxdif = float(0.5 * (abs(c0-c1) + abs(c1-c2)) > (1.0 - ntsc_fonts)) * float(abs(c2-c0) < 0.05);
        float linecb = swoothstep(0.1, 0.0, max(abs(c1-b1), abs(c1-d1)));
        linecb = linecb * float(abs(c1-b1) < 0.05 || abs(c2-d2) < 0.05);

        float xdif1 = 0.0;
        float xdif2 = 0.0;
        float th   = 0.215;

        for (float i = 0.5; i < 10.5; i++)
        {
            float j = i + 1.0;
            ca  = texCD(NTSCDE_S04, tcoord -  i*xx).x;
            c0  = texCD(NTSCDE_S04, tcoord -  j*xx).x;
            c2 = texCD(NTSCDE_S04, tcoord +  i*xx).x;
            cb = texCD(NTSCDE_S04, tcoord +  j*xx).x;
            xdif1 = max(abs(ca - c0) - th, xdif1);
            xdif2 = max(abs(cb - c2) - th, xdif2);
        }

        float linex   = swoothstep(0.0, 0.125, min(xdif1, xdif2));
        diffboost     = min(linex * linecb * maxdif, 0.625);
    }

    float3 ref = texCD(NTSCDE_S04, tcoord).xyz;
    float2 org = ref.yz;
	if( ntsc_rainbow>0.5&&(phase<2.5 || ntsc_phase == 5.0))
	{
	float ybool1=1.0;
	if((ntsc_rainbow<1.5)&&bool(line0))ybool1=0.0;else
	if((ntsc_rainbow<2.5)&&bool(line2))ybool1=0.0;

	float liine_no=floor( mod(OrgSize.y*vtex_c.y,2.0));
	float frame_no=floor( mod(float(framecount),2.0));
	float ii=abs(liine_no-frame_no);
	dy=ii*OrgSize.w*ybool1;
	float2 ref1 = texCD(NTSCDE_S04, tcoord + float2(0.0, -dy)).yz;
				   
	float2 ref2 = texCD(NTSCDE_S04, tcoord + float2(0.0,  dy)).yz;
	float2 rdf1 = abs(org - ref1);
	float2 rdf2 = abs(org - ref2);
	rdf1        = rdf1 / max(rdf1 + rdf2, 0.0000001);

	ref.yz = lerp(ref1, ref2, rdf1);
	}
	float lum1=min(texCD(NTSCDE_S03,vTex-dx).a, texCD(NTSCDE_S03,vTex+dx).a);
	float lum2=ref.x ;
	float3 ll3=abs(ll1-ll2);
	float di=max(max(max(ll3.x,ll3.y),max(ll3.z,abs(ll1.x*ll1.x-ll2.x*ll2.x))),diffboost);
	float df=pow(di,0.125);
	float lc=swoothstep(0.20,0.10,abs(lum2-lum1))*df;
	float tmp1=swoothstep(0.05-0.03*lc,0.425-0.375*lc,di);
	float tmp2=pow((tmp1+0.1)/1.1,0.25);
	float sweight=lerp(tmp1,tmp2,line0);
	float zweight=lerp(tmp1,tmp2,line2);
	float3 signal=ref;
	float ntzc_shrp= abs(ntsc_shrp);
	if(ntzc_shrp>0.25 || ntsc_fonts > 0.255)
	{
	float mixer=zweight;
	if(ntsc_shrp < -0.25)mixer=sweight; mixer*=max(0.1*ntzc_shrp, diffboost*1.25);
	float lumix=lerp(lum2,lum1,mixer);
	float lm1=lerp(lum2*lum2 ,lum1*lum1 ,mixer);lm1=sqrt(lm1);
	float lm2=lerp(sqrt(lum2),sqrt(lum1),mixer);lm2=lm2* lm2 ;
	float k1=abs(lumix-lm1)+0.00001;
	float k2=abs(lumix-lm2)+0.00001;
	signal.x=min((k2*lm1+k1*lm2)/(k1+k2),1.0);
	signal.x=min(signal.x,max(ntsc_shpe*signal.x,lum2));
	}
	if((ntsc_charp1+ntsc_charp2)>0.25)
	{
	dx.x = 0.0625 * OrgSize.z;
	float lcoord=OrgSize.x*(vtex_c.x+dx.x )-0.5;
	float fpx=frac(lcoord);
	lcoord =(floor(lcoord)+0.5)*OrgSize.z;
	float mixer=sweight;
	if(ntsc_shrp>0.25)mixer=zweight;
	mixer =lerp(swoothstep(0.075,0.125,max(ll3.y,ll3.z)),swoothstep(0.015,0.0275,di),line2)*mixer;
	mixer*=0.1*((phase<2.5)? ntsc_charp1:ntsc_charp2);
	tcoord=float2(lcoord,tcoord.y);
	float3 origin=rgb2yiq(lerp(texCD(NTSCDE_S02,tcoord).rgb,texCD(NTSCDE_S02,tcoord+16.0*dx).rgb,clamp(1.5*fpx-0.25,0.0,1.0)));
	signal.yz=lerp(signal.yz,origin.yz,mixer);
	}

    if ((RFNOISE1 + RFNOISE2) > 0.005)
    {
        float3 ns = NoiseNP3(vtex_c, float(framecount));
        float Y   = lerp(0.375, 1.0, pow(signal.x, 0.2));

        signal.x = clamp(signal.x + RFNOISE1 * ns.x,  0.00, 1.00);
        signal.y = clamp(signal.y + Y * RFNOISE2 * (0.325 + 1.325 * abs(signal.y)) * ns.y, -0.60, 0.60);
        signal.z = clamp(signal.z + Y * RFNOISE2 * (0.325 + 1.325 * abs(signal.z)) * ns.z, -0.53, 0.53);
    }
	signal.x=pow(signal.x,1.0/ntsc_gamma);
	signal=clamp(yiq2rgb(signal),0.0,1.0);
    zweight = (phase == 2.0 || ntsc_phase > 3.5) ? zweight : 1.0;
	return float4(signal,zweight);
    }
}

float4 SharpnessPS(float4 position:SV_Position,float2 texcoord:TEXCOORD):SV_Target
{
	float resmult = round(OrgSize.x / 300.0);
	float2 g01=float2(-0.5*resmult*OrgSize.z,0.0);
	float2 g21=float2( 0.5*resmult*OrgSize.z,0.0);
	float3 c01=texCD(NTSCDE_S05,texcoord+g01).rgb;
	float3 c21=texCD(NTSCDE_S05,texcoord+g21).rgb;
	float3 c11=texCD(NTSCDE_S05,texcoord    ).rgb;
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
	float l01=get_luma(texCD(NTSCDE_S02,texcoord+2.0*g01).rgb);
	float l21=get_luma(texCD(NTSCDE_S02,texcoord+2.0*g21).rgb);
	float l11=get_luma(texCD(NTSCDE_S02,toxcoord        ).rgb);
	float dth = texCD(NTSCDE_S05,texcoord).a;
	float DEB = max(lerp(0.375*NDEBLUR, NDEBLUR, max(1.0-DSMART, dth)), 1.0);
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
	res=rgb2yiq(res);
	d11=res.x;
	res.x=zharpen;
	res.x=clamp((1.0+ DSHARP)* res.x-DSHARP*d11,ln1*(1.0-contrazt),lx1*(1.0+contrazt));
	res=max(yiq2rgb(res),0.0);
	}
	return float4(res,1.0);
}

float4 LinearizeNewPS(float4 position:SV_Position,float2 texcoord:TEXCOORD):SV_Target
{
    float3 c = texCD(NTSCDE_S06,fuxcoord).rgb;
    if((downsample_levelx+downsample_levely)>0.025)
    {
    c=fetch_pixel(fuxcoord);
    }
    float intera = texCD(NTSCDE_S0I,fuxcoord).a;
    float gamma_in=1.0;
    c=pow(c,gamma_in);
    if(fuxcoord.x>0.5)gamma_in=intera;else gamma_in=1.0/gamma_in;
    return float4(c,gamma_in);
}

float4 NTSC_TV1_PS(float4 position:SV_Position,float2 texcoord:TEXCOORD):SV_Target
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
	pixel=texCD(NTSCDE_S08,tex+n*dx).rgb;
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

technique Decoupled_Guest_NTSC
{
	pass StockPass
	{
	VertexShader=CropProcessVS;
	PixelShader=StockPassPS;
	RenderTarget=NTSCDE_T0S;
	PrimitiveTopology=TRIANGLESTRIP;
	VertexCount=4;
	}
	pass Afterglow
	{
	VertexShader=PostProcessVS;
	PixelShader=AfterglowPS;
	RenderTarget=NTSCDE_T01;
	}
	pass PreShader
	{
	VertexShader=PostProcessVS;
	PixelShader=PreShaderPS;
	RenderTarget=NTSCDE_T02;
	}
	pass Interlace
	{
	VertexShader=PostProcessVS;
	PixelShader=InterlacePS;
	RenderTarget=NTSCDE_T0I;
	}
	pass NTSCPASS1
	{
	VertexShader=PostProcessVS;
	PixelShader=Signal_1_PS;
	RenderTarget=NTSCDE_T03;
	}
	pass NTSCPASS2
	{
	VertexShader=PostProcessVS;
	PixelShader=Signal_2_PS;
	RenderTarget=NTSCDE_T04;
	}
	pass NTSCPASS3
	{
	VertexShader=PostProcessVS;
	PixelShader=Signal_3_PS;
	RenderTarget=NTSCDE_T05;
	}
	pass Sharpness
	{
	VertexShader=PostProcessVS;
	PixelShader=SharpnessPS;
	RenderTarget=NTSCDE_T06;
	}
	pass Linearize
	{
	VertexShader=PostProcessVS;
	PixelShader=LinearizeNewPS;
	RenderTarget=NTSCDE_T08;
	}
	pass CRT_Pass1
	{
	VertexShader=PostProcessVS;
	PixelShader=NTSC_TV1_PS;
	}
}

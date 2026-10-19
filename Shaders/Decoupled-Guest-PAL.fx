/*

	Decoupled - Guest - PAL

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
	Relevant sections decoupled for more granular utility by Azurfel.
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

uniform float PAL_FILT <
	ui_category = "PAL Controls";
	ui_type = "drag";
	ui_min = 1.0;
	ui_max = 4.0;
	ui_step = 1.0;
	ui_label = "PAL Connection: RF | Composite | S-Video | SCART";
> = 4.00;

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
> = 0.0;

uniform float FRINGING <
	ui_category = "PAL Controls";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 5.0;
	ui_step = 0.1;
	ui_label = "PAL Fringing Value";
> = 0.0;

uniform float SATURATION <
	ui_category = "PAL Controls";
	ui_type = "drag";
	ui_min = 0.0;
	ui_max = 2.0;
	ui_step = 0.01;
	ui_label = "PAL Saturation Boost";
> = 1.0;

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
> = 0.3;

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
#define wts float((bloomsamp < 0.5) ? -10.0 : -12.5)
#define pii 3.14159265
#define fracoord (fuxcoord*NewSize.xy)
#define texCD(c,d) tex2Dlod(c,float4(d,0,0))
#define LumSize float4(2.0*TexSize.x,1.0*TexSize.y,1.0/(2.0*TexSize.x),1.0/(1.0*TexSize.y))
#define rgb_m float3x3(0.29900,0.58700,0.11400,-0.14713,-0.28886,0.43600,0.61500,-0.51499,-0.10001)
#define yuv_m float3x3(1.00000,0.00000,1.13983,1.00000,-0.39465,-0.58060,1.00000,2.03211,0.00000)
#define sample_yuv(dx) float3(texCD(PALDE_S04,tex_c+dx.xz).x+texCD(PALDE_S04,tex_c-dx.xz).x,texCD(PALDE_S04,tex_c+dx.yz).yz+texCD(PALDE_S04,tex_c-dx.yz).yz)

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

#define PALDE_S00 ReShade::BackBuffer

texture PALDE_T0S{Width=1.0*Resolution_X;Height=Resolution_Y;Format=RGBA16F;};
sampler PALDE_S0S{Texture=PALDE_T0S;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=POINT ;MinFilter=POINT ;MipFilter=POINT ;};

texture PALDE_T01{Width=1.0*Resolution_X;Height=Resolution_Y ;Format=RGBA16F;};
sampler PALDE_S01{Texture=PALDE_T01;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=POINT ;MinFilter=POINT ;MipFilter=POINT ;};

texture PALDE_T02{Width=1.0*Resolution_X;Height=Resolution_Y ;Format=RGBA16F;};
sampler PALDE_S02{Texture=PALDE_T02;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=POINT ;MinFilter=POINT ;MipFilter=POINT ;};

texture PALDE_T0I{Width=1.0*Resolution_X;Height=Resolution_Y ;Format=RGBA16F;};
sampler PALDE_S0I{Texture=PALDE_T0I;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=LINEAR;MinFilter=LINEAR;MipFilter=LINEAR;};

texture PALDE_T03{Width=4.0*Resolution_X;Height=Resolution_Y ;Format=RGBA16F;};
sampler PALDE_S03{Texture=PALDE_T03;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=LINEAR;MinFilter=LINEAR;MipFilter=LINEAR;};

texture PALDE_T04{Width=2.0*Resolution_X;Height=Resolution_Y ;Format=RGBA16F;};
sampler PALDE_S04{Texture=PALDE_T04;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=LINEAR;MinFilter=LINEAR;MipFilter=LINEAR;};

texture PALDE_T05{Width=2.0*Resolution_X;Height=Resolution_Y ;Format=RGBA16F;};
sampler PALDE_S05{Texture=PALDE_T05;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=LINEAR;MinFilter=LINEAR;MipFilter=LINEAR;};

texture PALDE_T06{Width=2.0*Resolution_X;Height=Resolution_Y ;Format=RGBA16F;};
sampler PALDE_S06{Texture=PALDE_T06;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=LINEAR;MinFilter=LINEAR;MipFilter=LINEAR;};

texture PALDE_T08{Width=2.0*Resolution_X;Height=Resolution_Y ;Format=RGBA16F;};
sampler PALDE_S08{Texture=PALDE_T08;AddressU=BORDER;AddressV=BORDER;AddressW=BORDER;MagFilter=LINEAR;MinFilter=LINEAR;MipFilter=LINEAR;};

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
	3.0*texCD(PALDE_S06,coord   ).rgb+2.0*texCD(PALDE_S06,coord+dx).rgb+2.0*texCD(PALDE_S06,coord-dx).rgb+
	2.0*texCD(PALDE_S06,coord+dy).rgb+2.0*texCD(PALDE_S06,coord-dy).rgb+    texCD(PALDE_S06,coord+d1).rgb+
		texCD(PALDE_S06,coord-d1).rgb+    texCD(PALDE_S06,coord+d2).rgb+    texCD(PALDE_S06,coord-d2).rgb;
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
	return texCD(PALDE_S00,texcoord);
}

float4 AfterglowPS(float4 position:SV_Position,float2 texcoord:TEXCOORD):SV_Target
{
	float2 dx=float2(OrgSize.z,0.0);
	float2 dy=float2(0.0,OrgSize.w);
	float w=1.0;
	float3 color0=texCD(PALDE_S0S,texcoord   ).rgb;
	float3 color1=texCD(PALDE_S0S,texcoord-dx).rgb;
	float3 color2=texCD(PALDE_S0S,texcoord+dx).rgb;
	float3 color3=texCD(PALDE_S0S,texcoord-dy).rgb;
	float3 color4=texCD(PALDE_S0S,texcoord+dy).rgb;
	float3 cr=(2.5*color0+color1+color2+color3+color4)/6.5;
	float3 a=texCD(PALDE_S01,texcoord).rgb;
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
	float4 imgColor=texCD(PALDE_S0S,texcoord);
	float4 aftrglow=texCD(PALDE_S01,texcoord);
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
    float3 c1=texCD(PALDE_S02,fuxcoord).rgb;
    float3 c2=texCD(PALDE_S02,fuxcoord+float2(0.0,OrgSize.w)).rgb;
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
	float3 ycolor=rgb2yuv(texCD(PALDE_S0I, vtex_c).rgb);
	float4 pcolor=float4(texCD(PALDE_S03, vtex_c));
	return float4(ycolor.yz, pcolor.xy);
}

float4 Signal_2_PS(float4 position:SV_Position,float2 texcoord:TEXCOORD):SV_Target
	{
	float ARTIFACT=ARTIFACTING;
	float3x3 mix_m = float3x3(BRIGHTNESS,ARTIFACT,ARTIFACT,FRINGING,2.0*SATURATION,0.0,FRINGING,0.0,2.0*SATURATION);
	
	float CYCLES_PER_LINE=4.43361875e6/15625.0;
	float2 vtex_c=texcoord*1.00001;
	
	float3 rgb  = texCD(PALDE_S0I, vtex_c).rgb;
	float3 yuv1=rgb2yuv(rgb);
	yuv1.x=pow(max(yuv1.x, 0.0), GCORR); /* no float needed here??? float2? */
	float3 res4=yuv1;
	
	float lum = yuv1.x;
	float3 yuvd=rgb2yuv(texCD(PALDE_S03, vtex_c - float2(0.0, OrgSize.w)).rgb); yuvd.x = lum;
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
        
        float ca=texCD(PALDE_S04,TexD-xx-xx).a;
        float c0=texCD(PALDE_S04,TexD-xx).a;
        float c1=texCD(PALDE_S04,TexD).a;
        float c2=texCD(PALDE_S04,TexD+xx).a;
        float cb=texCD(PALDE_S04,TexD+xx+xx).a;
        
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
	signal+=texCD(PALDE_S04,tex_c).xyz*tmps;
	signal =signal/wsum;

	if(pal_ring>0.05)
	{
        float2 dx=float2(8.0*one_x/min(res,1.0),0.0);
        float x1=texCD(PALDE_S04,tex_c-4.0*dx).a;
        float x2=texCD(PALDE_S04,tex_c-3.0*dx).a;
        float a=texCD(PALDE_S04,tex_c-2.0*dx).a;
        float b=texCD(PALDE_S04,tex_c-    dx).a;
        float c=texCD(PALDE_S04,tex_c+2.0*dx).a;
        float y1=texCD(PALDE_S04,tex_c+3.0*dx).a;
        float y2=texCD(PALDE_S04,tex_c+4.0*dx).a;
        float d=texCD(PALDE_S04,tex_c+    dx).a;
        float e=texCD(PALDE_S04,tex_c       ).a;	  
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
	float3 c01=texCD(PALDE_S05,texcoord+g01).rgb;
	float3 c21=texCD(PALDE_S05,texcoord+g21).rgb;
	float3 c11=texCD(PALDE_S05,texcoord    ).rgb;
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
	float l01=get_luma(texCD(PALDE_S02,texcoord+2.0*g01).rgb);
	float l21=get_luma(texCD(PALDE_S02,texcoord+2.0*g21).rgb);
	float l11=get_luma(texCD(PALDE_S02,toxcoord        ).rgb);
	float dth = texCD(PALDE_S05,texcoord).a;
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

float4 LinearizeNewPS(float4 position:SV_Position,float2 texcoord:TEXCOORD):SV_Target
{
    float3 c = texCD(PALDE_S06,fuxcoord).rgb;
    if((downsample_levelx+downsample_levely)>0.025)
    {
    c=fetch_pixel(fuxcoord);
    }
    float intera = texCD(PALDE_S0I,fuxcoord).a;
    float gamma_in=1.0;
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
	pixel=texCD(PALDE_S08,tex+n*dx).rgb;
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

technique Decoupled_Guest_PAL
{
	pass StockPass
	{
	VertexShader=CropProcessVS;
	PixelShader=StockPassPS;
	RenderTarget=PALDE_T0S;
	PrimitiveTopology=TRIANGLESTRIP;
	VertexCount=4;
	}
	pass Afterglow
	{
	VertexShader=PostProcessVS;
	PixelShader=AfterglowPS;
	RenderTarget=PALDE_T01;
	}
	pass PreShader
	{
	VertexShader=PostProcessVS;
	PixelShader=PreShaderPS;
	RenderTarget=PALDE_T02;
	}
	pass Interlace
	{
	VertexShader=PostProcessVS;
	PixelShader=InterlacePS;
	RenderTarget=PALDE_T0I;
	}
	pass PALPASS1
	{
	VertexShader=PostProcessVS;
	PixelShader=Signal_1_PS;
	RenderTarget=PALDE_T03;
	}
	pass PALPASS2
	{
	VertexShader=PostProcessVS;
	PixelShader=Signal_2_PS;
	RenderTarget=PALDE_T04;
	}
	pass PALPASS3
	{
	VertexShader=PostProcessVS;
	PixelShader=Signal_3_PS;
	RenderTarget=PALDE_T05;
	}
	pass Sharpness
	{
	VertexShader=PostProcessVS;
	PixelShader=SharpnessPS;
	RenderTarget=PALDE_T06;
	}
	pass Linearize
	{
	VertexShader=PostProcessVS;
	PixelShader=LinearizeNewPS;
	RenderTarget=PALDE_T08;
	}
	pass CRT_Pass1
	{
	VertexShader=PostProcessVS;
	PixelShader=PAL_TV1_PS;
	}
}

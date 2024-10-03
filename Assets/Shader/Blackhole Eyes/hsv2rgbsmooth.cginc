            // The MIT License
            // Copyright © 2014 Inigo Quilez
            // Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
            // hsv2rgb_smooth and sdVesica converted to HLSL by Zekk, original function by Inigo Quilez under the MIT licence.
            float3 hsv2rgb_smooth( in float3 c )
            {
                float3 rgb = clamp( abs(fmod(c.x*6.0+float3(0.0,4.0,2.0),6.0)-3.0)-1.0, 0.0, 1.0 );
                rgb = rgb*rgb*(3.0-2.0*rgb); // cubic smoothing	
                return c.z * lerp( float3(1.0, 1.0, 1.0), rgb, c.y);
            }

            float sdVesica(float2 p, float r, float d)
            {
                p = abs(p);
                float b = sqrt(r*r-d*d);
                return ((p.y-b)*d>p.x*b) ? length(p-float2(0.0,b))
                                        : length(p-float2(-d,0.0))-r;
            }
            //End licence
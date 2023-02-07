#include "hash.gdshaderinc"

#define FLOORFRAC(x, x_int, x_fract) { float x_floor = floor(x); x_int = int(x_floor); x_fract = x - x_floor; }
/* clang-format on */

/* Bilinear Interpolation:
 *
 * v2          v3
 *  @ + + + + @       y
 *  +         +       ^
 *  +         +       |
 *  +         +       | 
 *  @ + + + + @       @------> x
 * v0          v1
 */
float bi_mix(float v0, float v1, float v2, float v3, float x, float y)
{
  float x1 = 1.0 - x;
  return (1.0 - y) * (v0 * x1 + v1 * x) + y * (v2 * x1 + v3 * x);
}

/* Trilinear Interpolation:
 *
 *   v6               v7
 *     @ + + + + + + @
 *     +\            +\
 *     + \           + \
 *     +  \          +  \
 *     +   \ v4      +   \ v5
 *     +    @ + + + +++ + @          z
 *     +    +        +    +      y   ^
 *  v2 @ + +++ + + + @ v3 +       \  |
 *      \   +         \   +        \ |
 *       \  +          \  +         \|
 *        \ +           \ +          +---------> x
 *         \+            \+
 *          @ + + + + + + @
 *        v0               v1
 */
float tri_mix(float v0,
              float v1,
              float v2,
              float v3,
              float v4,
              float v5,
              float v6,
              float v7,
              float x,
              float y,
              float z)
{
  float x1 = 1.0 - x;
  float y1 = 1.0 - y;
  float z1 = 1.0 - z;
  return z1 * (y1 * (v0 * x1 + v1 * x) + y * (v2 * x1 + v3 * x)) +
         z * (y1 * (v4 * x1 + v5 * x) + y * (v6 * x1 + v7 * x));
}

float quad_mix(float v0,
               float v1,
               float v2,
               float v3,
               float v4,
               float v5,
               float v6,
               float v7,
               float v8,
               float v9,
               float v10,
               float v11,
               float v12,
               float v13,
               float v14,
               float v15,
               float x,
               float y,
               float z,
               float w)
{
  return mix(tri_mix(v0, v1, v2, v3, v4, v5, v6, v7, x, y, z),
             tri_mix(v8, v9, v10, v11, v12, v13, v14, v15, x, y, z),
             w);
}

float fade(float t)
{
  return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
}

float negate_if(float value, uint condition)
{
  return (condition != uint(0)) ? -value : value;
}

float noise_grad_1d(uint hash, float x)
{
  uint h = hash & uint(15);
  float g = float(uint(1) + (h & uint(7)));
  return negate_if(g, h & uint(8)) * x;
}

float noise_grad_2d(uint hash, float x, float y)
{
  uint h = hash & uint(7);
  float u = h < uint(4) ? x : y;
  float v = 2.0 * (h < uint(4) ? y : x);
  return negate_if(u, h & uint(1)) + negate_if(v, h & uint(2));
}

float noise_grad_3d(uint hash, float x, float y, float z)
{
  uint h = hash & uint(15);
  float u = h < uint(8) ? x : y;
  float vt = ((h == uint(12)) || (h == uint(14))) ? x : z;
  float v = h < uint(4) ? y : vt;
  return negate_if(u, h & uint(1)) + negate_if(v, h & uint(2));
}

float noise_grad_4d(uint hash, float x, float y, float z, float w)
{
  uint h = hash & uint(31);
  float u = h < uint(24) ? x : y;
  float v = h < uint(16) ? y : z;
  float s = h < uint(8) ? z : w;
  return negate_if(u, h & uint(1)) + negate_if(v, h & uint(2)) + negate_if(s, h & uint(4));
}

float noise_perlin_1d(float x)
{
  int X;
  float fx;

  FLOORFRAC(x, X, fx);

  float u = fade(fx);

  float r = mix(noise_grad_1d(hash_int(X), fx), noise_grad_1d(hash_int(X + 1), fx - 1.0), u);

  return r;
}

float noise_perlin_2d(vec2 vec)
{
  int X, Y;
  float fx, fy;

  FLOORFRAC(vec.x, X, fx);
  FLOORFRAC(vec.y, Y, fy);

  float u = fade(fx);
  float v = fade(fy);

  float r = bi_mix(noise_grad_2d(hash_int2(X, Y), fx, fy),
                   noise_grad_2d(hash_int2(X + 1, Y), fx - 1.0, fy),
                   noise_grad_2d(hash_int2(X, Y + 1), fx, fy - 1.0),
                   noise_grad_2d(hash_int2(X + 1, Y + 1), fx - 1.0, fy - 1.0),
                   u,
                   v);

  return r;
}

float noise_perlin_3d(vec3 vec)
{
  int X, Y, Z;
  float fx, fy, fz;

  FLOORFRAC(vec.x, X, fx);
  FLOORFRAC(vec.y, Y, fy);
  FLOORFRAC(vec.z, Z, fz);

  float u = fade(fx);
  float v = fade(fy);
  float w = fade(fz);

  float r = tri_mix(noise_grad_3d(hash_int3(X, Y, Z), fx, fy, fz),
                    noise_grad_3d(hash_int3(X + 1, Y, Z), fx - 1.0, fy, fz),
                    noise_grad_3d(hash_int3(X, Y + 1, Z), fx, fy - 1.0, fz),
                    noise_grad_3d(hash_int3(X + 1, Y + 1, Z), fx - 1.0, fy - 1.0, fz),
                    noise_grad_3d(hash_int3(X, Y, Z + 1), fx, fy, fz - 1.0),
                    noise_grad_3d(hash_int3(X + 1, Y, Z + 1), fx - 1.0, fy, fz - 1.0),
                    noise_grad_3d(hash_int3(X, Y + 1, Z + 1), fx, fy - 1.0, fz - 1.0),
                    noise_grad_3d(hash_int3(X + 1, Y + 1, Z + 1), fx - 1.0, fy - 1.0, fz - 1.0),
                    u,
                    v,
                    w);

  return r;
}

float noise_perlin_4d(vec4 vec)
{
  int X, Y, Z, W;
  float fx, fy, fz, fw;

  FLOORFRAC(vec.x, X, fx);
  FLOORFRAC(vec.y, Y, fy);
  FLOORFRAC(vec.z, Z, fz);
  FLOORFRAC(vec.w, W, fw);

  float u = fade(fx);
  float v = fade(fy);
  float t = fade(fz);
  float s = fade(fw);

  float r = quad_mix(
      noise_grad_4d(hash_int4(X, Y, Z, W), fx, fy, fz, fw),
      noise_grad_4d(hash_int4(X + 1, Y, Z, W), fx - 1.0, fy, fz, fw),
      noise_grad_4d(hash_int4(X, Y + 1, Z, W), fx, fy - 1.0, fz, fw),
      noise_grad_4d(hash_int4(X + 1, Y + 1, Z, W), fx - 1.0, fy - 1.0, fz, fw),
      noise_grad_4d(hash_int4(X, Y, Z + 1, W), fx, fy, fz - 1.0, fw),
      noise_grad_4d(hash_int4(X + 1, Y, Z + 1, W), fx - 1.0, fy, fz - 1.0, fw),
      noise_grad_4d(hash_int4(X, Y + 1, Z + 1, W), fx, fy - 1.0, fz - 1.0, fw),
      noise_grad_4d(hash_int4(X + 1, Y + 1, Z + 1, W), fx - 1.0, fy - 1.0, fz - 1.0, fw),
      noise_grad_4d(hash_int4(X, Y, Z, W + 1), fx, fy, fz, fw - 1.0),
      noise_grad_4d(hash_int4(X + 1, Y, Z, W + 1), fx - 1.0, fy, fz, fw - 1.0),
      noise_grad_4d(hash_int4(X, Y + 1, Z, W + 1), fx, fy - 1.0, fz, fw - 1.0),
      noise_grad_4d(hash_int4(X + 1, Y + 1, Z, W + 1), fx - 1.0, fy - 1.0, fz, fw - 1.0),
      noise_grad_4d(hash_int4(X, Y, Z + 1, W + 1), fx, fy, fz - 1.0, fw - 1.0),
      noise_grad_4d(hash_int4(X + 1, Y, Z + 1, W + 1), fx - 1.0, fy, fz - 1.0, fw - 1.0),
      noise_grad_4d(hash_int4(X, Y + 1, Z + 1, W + 1), fx, fy - 1.0, fz - 1.0, fw - 1.0),
      noise_grad_4d(hash_int4(X + 1, Y + 1, Z + 1, W + 1), fx - 1.0, fy - 1.0, fz - 1.0, fw - 1.0),
      u,
      v,
      t,
      s);

  return r;
}

/* Remap the output of noise to a predictable range [-1, 1].
 * The scale values were computed experimentally by the OSL developers.
 */
float noise_scale1(float result)
{
  return 0.2500 * result;
}

float noise_scale2(float result)
{
  return 0.6616 * result;
}

float noise_scale3(float result)
{
  return 0.9820 * result;
}

float noise_scale4(float result)
{
  return 0.8344 * result;
}

/* Safe Signed And Unsigned Noise */

float snoise_1d(float p)
{
  float r = noise_perlin_1d(p);
  return (isinf(r)) ? 0.0 : noise_scale1(r);
}

float noise_1d(float p)
{
  return 0.5 * snoise_1d(p) + 0.5;
}

float snoise_2d(vec2 p)
{
  float r = noise_perlin_2d(p);
  return (isinf(r)) ? 0.0 : noise_scale2(r);
}

float noise_2d(vec2 p)
{
  return 0.5 * snoise_2d(p) + 0.5;
}

float snoise_3d(vec3 p)
{
  float r = noise_perlin_3d(p);
  return (isinf(r)) ? 0.0 : noise_scale3(r);
}

float noise_3d(vec3 p)
{
  return 0.5 * snoise_3d(p) + 0.5;
}

float snoise_4d(vec4 p)
{
  float r = noise_perlin_4d(p);
  return (isinf(r)) ? 0.0 : noise_scale4(r);
}

float noise_4d(vec4 p)
{
  return 0.5 * snoise_4d(p) + 0.5;
}

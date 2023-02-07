/* ***** Jenkins Lookup3 Hash Functions ***** */

/* Source: http://burtleburtle.net/bob/c/lookup3.c */

#define rot(x, k) ((uint(x) << uint(k)) | (uint(x) >> (uint(32) - uint(k))))

#define mix(a, b, c) \
  { \
    a -= c; \
    a ^= rot(c, 4); \
    c += b; \
    b -= a; \
    b ^= rot(a, 6); \
    a += c; \
    c -= b; \
    c ^= rot(b, 8); \
    b += a; \
    a -= c; \
    a ^= rot(c, 16); \
    c += b; \
    b -= a; \
    b ^= rot(a, 19); \
    a += c; \
    c -= b; \
    c ^= rot(b, 4); \
    b += a; \
  }

#define final(a, b, c) \
  { \
    c ^= b; \
    c -= rot(b, 14); \
    a ^= c; \
    a -= rot(c, 11); \
    b ^= a; \
    b -= rot(a, 25); \
    c ^= b; \
    c -= rot(b, 16); \
    a ^= c; \
    a -= rot(c, 4); \
    b ^= a; \
    b -= rot(a, 14); \
    c ^= b; \
    c -= rot(b, 24); \
  }

uint hash_uint(uint kx)
{
  uint a, b, c;
  a = b = c = uint(0xdeadbeef) + (uint(1) << uint(2)) + uint(13);

  a += kx;
  final(a, b, c);

  return c;
}

uint hash_uint2(uint kx, uint ky)
{
  uint a, b, c;
  a = b = c = uint(0xdeadbeef) + (uint(2) << uint(2)) + uint(13);

  b += ky;
  a += kx;
  final(a, b, c);

  return c;
}

uint hash_uint3(uint kx, uint ky, uint kz)
{
  uint a, b, c;
  a = b = c = uint(0xdeadbeef) + (uint(3) << uint(2)) + uint(13);

  c += kz;
  b += ky;
  a += kx;
  final(a, b, c);

  return c;
}

uint hash_uint4(uint kx, uint ky, uint kz, uint kw)
{
  uint a, b, c;
  a = b = c = uint(0xdeadbeef) + (uint(4) << uint(2)) + uint(13);

  a += kx;
  b += ky;
  c += kz;
  mix(a, b, c);

  a += kw;
  final(a, b, c);

  return c;
}

#undef rot
#undef final
#undef mix

uint hash_int(int kx)
{
  return hash_uint(uint(kx));
}

uint hash_int2(int kx, int ky)
{
  return hash_uint2(uint(kx), uint(ky));
}

uint hash_int3(int kx, int ky, int kz)
{
  return hash_uint3(uint(kx), uint(ky), uint(kz));
}

uint hash_int4(int kx, int ky, int kz, int kw)
{
  return hash_uint4(uint(kx), uint(ky), uint(kz), uint(kw));
}

/* Hashing uint or uint[234] into a float in the range [0, 1]. */

float hash_uint_to_float(uint kx)
{
  return float(hash_uint(kx)) / float(uint(0xFFFFFFFF));
}

float hash_uint2_to_float(uint kx, uint ky)
{
  return float(hash_uint2(kx, ky)) / float(uint(0xFFFFFFFF));
}

float hash_uint3_to_float(uint kx, uint ky, uint kz)
{
  return float(hash_uint3(kx, ky, kz)) / float(uint(0xFFFFFFFF));
}

float hash_uint4_to_float(uint kx, uint ky, uint kz, uint kw)
{
  return float(hash_uint4(kx, ky, kz, kw)) / float(uint(0xFFFFFFFF));
}

/* Hashing float or vec[234] into a float in the range [0, 1]. */

float hash_float_to_float(float k)
{
  return hash_uint_to_float(floatBitsToUint(k));
}

float hash_vec2_to_float(vec2 k)
{
  return hash_uint2_to_float(floatBitsToUint(k.x), floatBitsToUint(k.y)); 
}

float hash_vec3_to_float(vec3 k)
{
  return hash_uint3_to_float(floatBitsToUint(k.x), floatBitsToUint(k.y), floatBitsToUint(k.z));
}

float hash_vec4_to_float(vec4 k)
{
  return hash_uint4_to_float(
      floatBitsToUint(k.x), floatBitsToUint(k.y), floatBitsToUint(k.z), floatBitsToUint(k.w));
}

/* Hashing vec[234] into vec[234] of components in the range [0, 1]. */

vec2 hash_vec2_to_vec2(vec2 k)
{
  return vec2(hash_vec2_to_float(k), hash_vec3_to_float(vec3(k, 1.0)));
}

vec3 hash_vec3_to_vec3(vec3 k)
{
  return vec3(
      hash_vec3_to_float(k), hash_vec4_to_float(vec4(k, 1.0)), hash_vec4_to_float(vec4(k, 2.0)));
}

vec4 hash_vec4_to_vec4(vec4 k)
{
  return vec4(hash_vec4_to_float(k.xyzw),
              hash_vec4_to_float(k.wxyz),
              hash_vec4_to_float(k.zwxy),
              hash_vec4_to_float(k.yzwx));
}

/* Hashing float or vec[234] into vec3 of components in range [0, 1]. */

vec3 hash_float_to_vec3(float k)
{
  return vec3(
      hash_float_to_float(k), hash_vec2_to_float(vec2(k, 1.0)), hash_vec2_to_float(vec2(k, 2.0)));
}

vec3 hash_vec2_to_vec3(vec2 k)
{
  return vec3(
      hash_vec2_to_float(k), hash_vec3_to_float(vec3(k, 1.0)), hash_vec3_to_float(vec3(k, 2.0)));
}

vec3 hash_vec4_to_vec3(vec4 k)
{
  return vec3(hash_vec4_to_float(k.xyzw), hash_vec4_to_float(k.zxwy), hash_vec4_to_float(k.wzyx));
}

/* Other Hash Functions */

float integer_noise(int n)
{
  /* Integer bit-shifts for these calculations can cause precision problems on macOS.
   * Using uint resolves these issues. */
  uint nn;
  nn = (uint(n) + uint(1013)) & uint(0x7fffffff);
  nn = (nn >> uint(13)) ^ nn;
  nn = (uint(nn * (nn * nn * uint(60493) + uint(19990303))) + uint(1376312589)) & uint(0x7fffffff);
  return 0.5 * (float(nn) / 1073741824.0);
}

float wang_hash_noise(uint s)
{
  s = (s ^ uint(61)) ^ (s >> uint(16));
  s *= uint(9);
  s = s ^ (s >> uint(4));
  s *= uint(0x27d4eb2d);
  s = s ^ (s >> uint(15));

  return fract(float(s) / 4294967296.0);
}

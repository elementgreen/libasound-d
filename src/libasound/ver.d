/*
 *  version.h
 */

module libasound.ver;

extern (C) @nogc nothrow:

enum SND_LIB_MAJOR = 1; /**< major number of library version */
enum SND_LIB_MINOR = 2; /**< minor number of library version */
enum SND_LIB_SUBMINOR = 8; /**< subminor number of library version */
enum SND_LIB_EXTRAVER = 1000000; /**< extra version number, used mainly for betas */
/** library version */
extern (D) auto SND_LIB_VER(T0, T1, T2)(auto ref T0 maj, auto ref T1 min, auto ref T2 sub)
{
    return (maj << 16) | (min << 8) | sub;
}

enum SND_LIB_VERSION = SND_LIB_VER(SND_LIB_MAJOR, SND_LIB_MINOR, SND_LIB_SUBMINOR);
/** library version (string) */
enum SND_LIB_VERSION_STR = "1.2.8";

/**
 * \file include/global.h
 * \brief Application interface library for the ALSA driver
 * \author Jaroslav Kysela <perex@perex.cz>
 * \author Abramo Bagnara <abramo@alsa-project.org>
 * \author Takashi Iwai <tiwai@suse.de>
 * \date 1998-2001
 *
 * Application interface library for the ALSA driver
 */
/*
 *   This library is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Lesser General Public License as
 *   published by the Free Software Foundation; either version 2.1 of
 *   the License, or (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Lesser General Public License for more details.
 *
 *   You should have received a copy of the GNU Lesser General Public
 *   License along with this library; if not, write to the Free Software
 *   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 *
 */

module libasound.global;

import core.sys.posix.sys.select;

extern (C) @nogc nothrow:

/* for timeval and timespec */

/**
 *  \defgroup Global Global defines and functions
 *  Global defines and functions.
 *  \par
 *  The ALSA library implementation uses these macros and functions.
 *  Most applications probably do not need them.
 *  \{
 */

const(char)* snd_asoundlib_version ();

/** do not print warning (gcc) when function parameter is not used */

/* dynamic build */

/** \hideinitializer \brief Helper macro for #SND_DLSYM_BUILD_VERSION. */

/**
 * \hideinitializer
 * \brief Appends the build version to the name of a versioned dynamic symbol.
 */

/* static build */

struct snd_dlsym_link
{
    snd_dlsym_link* next;
    const(char)* dlsym_name;
    const(void)* dlsym_ptr;
}

extern __gshared snd_dlsym_link* snd_dlsym_start;

/** \hideinitializer \brief Helper macro for #SND_DLSYM_BUILD_VERSION. */
extern (D) string __SND_DLSYM_VERSION(T0, T1, T2)(auto ref T0 prefix, auto ref T1 name, auto ref T2 ver)
{
    import std.conv : to;

    return "_" ~ to!string(prefix) ~ to!string(name) ~ to!string(ver);
}

/**
 * \hideinitializer
 * \brief Appends the build version to the name of a versioned dynamic symbol.
 */

/** \brief Return 'x' argument as string */

/** \brief Returns the version of a dynamic symbol as a string. */
// alias SND_DLSYM_VERSION = __STRING;

int snd_dlpath (char* path, size_t path_len, const(char)* name);
void* snd_dlopen (const(char)* file, int mode, char* errbuf, size_t errbuflen);
void* snd_dlsym (void* handle, const(char)* name, const(char)* version_);
int snd_dlclose (void* handle);

/** \brief alloca helper macro. */

/**
 * \brief Internal structure for an async notification client handler.
 *
 * The ALSA library uses a pointer to this structure as a handle to an async
 * notification object. Applications don't access its contents directly.
 */
struct _snd_async_handler;
alias snd_async_handler_t = _snd_async_handler;

/**
 * \brief Async notification callback.
 *
 * See the #snd_async_add_handler function for details.
 */
alias snd_async_callback_t = void function (snd_async_handler_t* handler);

int snd_async_add_handler (
    snd_async_handler_t** handler,
    int fd,
    snd_async_callback_t callback,
    void* private_data);
int snd_async_del_handler (snd_async_handler_t* handler);
int snd_async_handler_get_fd (snd_async_handler_t* handler);
int snd_async_handler_get_signo (snd_async_handler_t* handler);
void* snd_async_handler_get_callback_private (snd_async_handler_t* handler);

struct snd_shm_area;
snd_shm_area* snd_shm_area_create (int shmid, void* ptr);
snd_shm_area* snd_shm_area_share (snd_shm_area* area);
int snd_shm_area_destroy (snd_shm_area* area);

int snd_user_file (const(char)* file, char** result);

/* seconds */
/* microseconds */

/* seconds */
/* nanoseconds */

/** Timestamp */
alias snd_timestamp_t = timeval;
/** Hi-res timestamp */
alias snd_htimestamp_t = timespec;

/** \} */

/* __ALSA_GLOBAL_H */

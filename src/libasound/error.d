/**
 * \file include/error.h
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

module libasound.error;

import core.stdc.stdio;
import core.stdc.stdarg;

extern (C) @nogc nothrow:

/**
 *  \defgroup Error Error handling
 *  Error handling macros and functions.
 *  \{
 */

/**< Lower boundary of sound error codes. */
/**< Kernel/library protocols are not compatible. */
/**< Lisp encountered an error during acall. */

const(char)* snd_strerror (int errnum);

/**
 * \brief Error handler callback.
 * \param file Source file name.
 * \param line Line number.
 * \param function Function name.
 * \param err Value of \c errno, or 0 if not relevant.
 * \param fmt \c printf(3) format.
 * \param ... \c printf(3) arguments.
 *
 * A function of this type is called by the ALSA library when an error occurs.
 * This function usually shows the message on the screen, and/or logs it.
 */
alias snd_lib_error_handler_t = void function (const(char)* file, int line, const(char)* function_, int err, const(char)* fmt, ...); /* __attribute__ ((format (printf, 5, 6))) */
extern __gshared snd_lib_error_handler_t snd_lib_error;
int snd_lib_error_set_handler (snd_lib_error_handler_t handler);

/**< Shows a sound error message. */
/**< Shows a system error message (related to \c errno). */

/**< Shows a sound error message. */
/**< Shows a system error message (related to \c errno). */

/** \} */

/** Local error handler function type */
alias snd_local_error_handler_t = void function (
    const(char)* file,
    int line,
    const(char)* func,
    int err,
    const(char)* fmt,
    va_list arg);

snd_local_error_handler_t snd_lib_error_set_local (snd_local_error_handler_t func);
enum SND_ERROR_BEGIN = 500000;
enum SND_ERROR_INCOMPATIBLE_VERSION = SND_ERROR_BEGIN + 0;
enum SND_ERROR_ALISP_NIL = SND_ERROR_BEGIN + 1;

/* __ALSA_ERROR_H */

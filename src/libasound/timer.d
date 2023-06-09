/**
 * \file include/timer.h
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

module libasound.timer;

import core.stdc.config;
import core.sys.posix.poll;
import core.sys.posix.unistd;

import libasound.conf;
import libasound.global;

extern (C) @nogc nothrow:

/**
 *  \defgroup Timer Timer Interface
 *  Timer Interface. See \ref timer page for more details.
 *  \{
 */

/** dlsym version for interface entry callback */
// enum SND_TIMER_DLSYM_VERSION = _dlsym_timer_001;
/** dlsym version for interface entry callback */
// enum SND_TIMER_QUERY_DLSYM_VERSION = _dlsym_timer_query_001;

/** timer identification structure */
struct _snd_timer_id;
alias snd_timer_id_t = _snd_timer_id;
/** timer global info structure */
struct _snd_timer_ginfo;
alias snd_timer_ginfo_t = _snd_timer_ginfo;
/** timer global params structure */
struct _snd_timer_gparams;
alias snd_timer_gparams_t = _snd_timer_gparams;
/** timer global status structure */
struct _snd_timer_gstatus;
alias snd_timer_gstatus_t = _snd_timer_gstatus;
/** timer info structure */
struct _snd_timer_info;
alias snd_timer_info_t = _snd_timer_info;
/** timer params structure */
struct _snd_timer_params;
alias snd_timer_params_t = _snd_timer_params;
/** timer status structure */
struct _snd_timer_status;
alias snd_timer_status_t = _snd_timer_status;
/** timer master class */
enum _snd_timer_class
{
    SND_TIMER_CLASS_NONE = -1, /**< invalid */
    SND_TIMER_CLASS_SLAVE = 0, /**< slave timer */
    SND_TIMER_CLASS_GLOBAL = 1, /**< global timer */
    SND_TIMER_CLASS_CARD = 2, /**< card timer */
    SND_TIMER_CLASS_PCM = 3, /**< PCM timer */
    SND_TIMER_CLASS_LAST = SND_TIMER_CLASS_PCM /**< last timer */
}

alias snd_timer_class_t = _snd_timer_class;

/** timer slave class */
enum _snd_timer_slave_class
{
    SND_TIMER_SCLASS_NONE = 0, /**< none */
    SND_TIMER_SCLASS_APPLICATION = 1, /**< for internal use */
    SND_TIMER_SCLASS_SEQUENCER = 2, /**< sequencer timer */
    SND_TIMER_SCLASS_OSS_SEQUENCER = 3, /**< OSS sequencer timer */
    SND_TIMER_SCLASS_LAST = SND_TIMER_SCLASS_OSS_SEQUENCER /**< last slave timer */
}

alias snd_timer_slave_class_t = _snd_timer_slave_class;

/** timer read event identification */
enum _snd_timer_event
{
    SND_TIMER_EVENT_RESOLUTION = 0, /* val = resolution in ns */
    SND_TIMER_EVENT_TICK = 1, /* val = ticks */
    SND_TIMER_EVENT_START = 2, /* val = resolution in ns */
    SND_TIMER_EVENT_STOP = 3, /* val = 0 */
    SND_TIMER_EVENT_CONTINUE = 4, /* val = resolution in ns */
    SND_TIMER_EVENT_PAUSE = 5, /* val = 0 */
    SND_TIMER_EVENT_EARLY = 6, /* val = 0 */
    SND_TIMER_EVENT_SUSPEND = 7, /* val = 0 */
    SND_TIMER_EVENT_RESUME = 8, /* val = resolution in ns */
    /* master timer events for slave timer instances */
    SND_TIMER_EVENT_MSTART = SND_TIMER_EVENT_START + 10,
    SND_TIMER_EVENT_MSTOP = SND_TIMER_EVENT_STOP + 10,
    SND_TIMER_EVENT_MCONTINUE = SND_TIMER_EVENT_CONTINUE + 10,
    SND_TIMER_EVENT_MPAUSE = SND_TIMER_EVENT_PAUSE + 10,
    SND_TIMER_EVENT_MSUSPEND = SND_TIMER_EVENT_SUSPEND + 10,
    SND_TIMER_EVENT_MRESUME = SND_TIMER_EVENT_RESUME + 10
}

alias snd_timer_event_t = _snd_timer_event;

/** timer read structure */
struct _snd_timer_read
{
    uint resolution; /**< tick resolution in nanoseconds */
    uint ticks; /**< count of happened ticks */
}

alias snd_timer_read_t = _snd_timer_read;

/** timer tstamp + event read structure */
struct _snd_timer_tread
{
    snd_timer_event_t event; /**< Timer event */
    snd_htimestamp_t tstamp; /**< Time stamp of each event */
    uint val; /**< Event value */
}

alias snd_timer_tread_t = _snd_timer_tread;

/** global timer - system */
enum SND_TIMER_GLOBAL_SYSTEM = 0;
/** global timer - RTC */
enum SND_TIMER_GLOBAL_RTC = 1; /* Obsoleted, due to enough legacy. */
/** global timer - HPET */
enum SND_TIMER_GLOBAL_HPET = 2;
/** global timer - HRTIMER */
enum SND_TIMER_GLOBAL_HRTIMER = 3;

/** timer open mode flag - non-blocking behaviour */
enum SND_TIMER_OPEN_NONBLOCK = 1 << 0;
/** use timestamps and event notification - enhanced read */
enum SND_TIMER_OPEN_TREAD = 1 << 1;

/** timer handle type */
enum _snd_timer_type
{
    /** Kernel level HwDep */
    SND_TIMER_TYPE_HW = 0,
    /** Shared memory client timer (not yet implemented) */
    SND_TIMER_TYPE_SHM = 1,
    /** INET client timer (not yet implemented) */
    SND_TIMER_TYPE_INET = 2
}

alias snd_timer_type_t = _snd_timer_type;

/** timer query handle */
struct _snd_timer_query;
alias snd_timer_query_t = _snd_timer_query;
/** timer handle */
struct _snd_timer;
alias snd_timer_t = _snd_timer;

int snd_timer_query_open (snd_timer_query_t** handle, const(char)* name, int mode);
int snd_timer_query_open_lconf (snd_timer_query_t** handle, const(char)* name, int mode, snd_config_t* lconf);
int snd_timer_query_close (snd_timer_query_t* handle);
int snd_timer_query_next_device (snd_timer_query_t* handle, snd_timer_id_t* tid);
int snd_timer_query_info (snd_timer_query_t* handle, snd_timer_ginfo_t* info);
int snd_timer_query_params (snd_timer_query_t* handle, snd_timer_gparams_t* params);
int snd_timer_query_status (snd_timer_query_t* handle, snd_timer_gstatus_t* status);

int snd_timer_open (snd_timer_t** handle, const(char)* name, int mode);
int snd_timer_open_lconf (snd_timer_t** handle, const(char)* name, int mode, snd_config_t* lconf);
int snd_timer_close (snd_timer_t* handle);
int snd_async_add_timer_handler (
    snd_async_handler_t** handler,
    snd_timer_t* timer,
    snd_async_callback_t callback,
    void* private_data);
snd_timer_t* snd_async_handler_get_timer (snd_async_handler_t* handler);
int snd_timer_poll_descriptors_count (snd_timer_t* handle);
int snd_timer_poll_descriptors (snd_timer_t* handle, pollfd* pfds, uint space);
int snd_timer_poll_descriptors_revents (snd_timer_t* timer, pollfd* pfds, uint nfds, ushort* revents);
int snd_timer_info (snd_timer_t* handle, snd_timer_info_t* timer);
int snd_timer_params (snd_timer_t* handle, snd_timer_params_t* params);
int snd_timer_status (snd_timer_t* handle, snd_timer_status_t* status);
int snd_timer_start (snd_timer_t* handle);
int snd_timer_stop (snd_timer_t* handle);
int snd_timer_continue (snd_timer_t* handle);
ssize_t snd_timer_read (snd_timer_t* handle, void* buffer, size_t size);

size_t snd_timer_id_sizeof ();
/** allocate #snd_timer_id_t container on stack */
extern (D) auto snd_timer_id_alloca(T)(auto ref T ptr)
{
    return __snd_alloca(ptr, snd_timer_id);
}

int snd_timer_id_malloc (snd_timer_id_t** ptr);
void snd_timer_id_free (snd_timer_id_t* obj);
void snd_timer_id_copy (snd_timer_id_t* dst, const(snd_timer_id_t)* src);

void snd_timer_id_set_class (snd_timer_id_t* id, int dev_class);
int snd_timer_id_get_class (snd_timer_id_t* id);
void snd_timer_id_set_sclass (snd_timer_id_t* id, int dev_sclass);
int snd_timer_id_get_sclass (snd_timer_id_t* id);
void snd_timer_id_set_card (snd_timer_id_t* id, int card);
int snd_timer_id_get_card (snd_timer_id_t* id);
void snd_timer_id_set_device (snd_timer_id_t* id, int device);
int snd_timer_id_get_device (snd_timer_id_t* id);
void snd_timer_id_set_subdevice (snd_timer_id_t* id, int subdevice);
int snd_timer_id_get_subdevice (snd_timer_id_t* id);

size_t snd_timer_ginfo_sizeof ();
/** allocate #snd_timer_ginfo_t container on stack */
extern (D) auto snd_timer_ginfo_alloca(T)(auto ref T ptr)
{
    return __snd_alloca(ptr, snd_timer_ginfo);
}

int snd_timer_ginfo_malloc (snd_timer_ginfo_t** ptr);
void snd_timer_ginfo_free (snd_timer_ginfo_t* obj);
void snd_timer_ginfo_copy (snd_timer_ginfo_t* dst, const(snd_timer_ginfo_t)* src);

int snd_timer_ginfo_set_tid (snd_timer_ginfo_t* obj, snd_timer_id_t* tid);
snd_timer_id_t* snd_timer_ginfo_get_tid (snd_timer_ginfo_t* obj);
uint snd_timer_ginfo_get_flags (snd_timer_ginfo_t* obj);
int snd_timer_ginfo_get_card (snd_timer_ginfo_t* obj);
char* snd_timer_ginfo_get_id (snd_timer_ginfo_t* obj);
char* snd_timer_ginfo_get_name (snd_timer_ginfo_t* obj);
c_ulong snd_timer_ginfo_get_resolution (snd_timer_ginfo_t* obj);
c_ulong snd_timer_ginfo_get_resolution_min (snd_timer_ginfo_t* obj);
c_ulong snd_timer_ginfo_get_resolution_max (snd_timer_ginfo_t* obj);
uint snd_timer_ginfo_get_clients (snd_timer_ginfo_t* obj);

size_t snd_timer_info_sizeof ();
/** allocate #snd_timer_info_t container on stack */
extern (D) auto snd_timer_info_alloca(T)(auto ref T ptr)
{
    return __snd_alloca(ptr, snd_timer_info);
}

int snd_timer_info_malloc (snd_timer_info_t** ptr);
void snd_timer_info_free (snd_timer_info_t* obj);
void snd_timer_info_copy (snd_timer_info_t* dst, const(snd_timer_info_t)* src);

int snd_timer_info_is_slave (snd_timer_info_t* info);
int snd_timer_info_get_card (snd_timer_info_t* info);
const(char)* snd_timer_info_get_id (snd_timer_info_t* info);
const(char)* snd_timer_info_get_name (snd_timer_info_t* info);
c_long snd_timer_info_get_resolution (snd_timer_info_t* info);

size_t snd_timer_params_sizeof ();
/** allocate #snd_timer_params_t container on stack */
extern (D) auto snd_timer_params_alloca(T)(auto ref T ptr)
{
    return __snd_alloca(ptr, snd_timer_params);
}

int snd_timer_params_malloc (snd_timer_params_t** ptr);
void snd_timer_params_free (snd_timer_params_t* obj);
void snd_timer_params_copy (snd_timer_params_t* dst, const(snd_timer_params_t)* src);

int snd_timer_params_set_auto_start (snd_timer_params_t* params, int auto_start);
int snd_timer_params_get_auto_start (snd_timer_params_t* params);
int snd_timer_params_set_exclusive (snd_timer_params_t* params, int exclusive);
int snd_timer_params_get_exclusive (snd_timer_params_t* params);
int snd_timer_params_set_early_event (snd_timer_params_t* params, int early_event);
int snd_timer_params_get_early_event (snd_timer_params_t* params);
void snd_timer_params_set_ticks (snd_timer_params_t* params, c_long ticks);
c_long snd_timer_params_get_ticks (snd_timer_params_t* params);
void snd_timer_params_set_queue_size (snd_timer_params_t* params, c_long queue_size);
c_long snd_timer_params_get_queue_size (snd_timer_params_t* params);
void snd_timer_params_set_filter (snd_timer_params_t* params, uint filter);
uint snd_timer_params_get_filter (snd_timer_params_t* params);

size_t snd_timer_status_sizeof ();
/** allocate #snd_timer_status_t container on stack */
extern (D) auto snd_timer_status_alloca(T)(auto ref T ptr)
{
    return __snd_alloca(ptr, snd_timer_status);
}

int snd_timer_status_malloc (snd_timer_status_t** ptr);
void snd_timer_status_free (snd_timer_status_t* obj);
void snd_timer_status_copy (snd_timer_status_t* dst, const(snd_timer_status_t)* src);

snd_htimestamp_t snd_timer_status_get_timestamp (snd_timer_status_t* status);
c_long snd_timer_status_get_resolution (snd_timer_status_t* status);
c_long snd_timer_status_get_lost (snd_timer_status_t* status);
c_long snd_timer_status_get_overrun (snd_timer_status_t* status);
c_long snd_timer_status_get_queue (snd_timer_status_t* status);

/* deprecated functions, for compatibility */
c_long snd_timer_info_get_ticks (snd_timer_info_t* info);

/** \} */

/** __ALSA_TIMER_H */

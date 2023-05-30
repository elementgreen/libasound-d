/**
 * \file include/hwdep.h
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

module libasound.hwdep;

import core.sys.posix.fcntl;
import core.sys.posix.poll;
import core.sys.posix.unistd;

extern (C) @nogc nothrow:

/**
 *  \defgroup HwDep Hardware Dependant Interface
 *  The Hardware Dependant Interface.
 *  \{
 */

/** dlsym version for interface entry callback */

/** HwDep information container */
struct _snd_hwdep_info;
alias snd_hwdep_info_t = _snd_hwdep_info;

/** HwDep DSP status container */
struct _snd_hwdep_dsp_status;
alias snd_hwdep_dsp_status_t = _snd_hwdep_dsp_status;

/** HwDep DSP image container */
struct _snd_hwdep_dsp_image;
alias snd_hwdep_dsp_image_t = _snd_hwdep_dsp_image;

/** HwDep interface */
enum _snd_hwdep_iface
{
    SND_HWDEP_IFACE_OPL2 = 0, /**< OPL2 raw driver */
    SND_HWDEP_IFACE_OPL3 = 1, /**< OPL3 raw driver */
    SND_HWDEP_IFACE_OPL4 = 2, /**< OPL4 raw driver */
    SND_HWDEP_IFACE_SB16CSP = 3, /**< SB16CSP driver */
    SND_HWDEP_IFACE_EMU10K1 = 4, /**< EMU10K1 driver */
    SND_HWDEP_IFACE_YSS225 = 5, /**< YSS225 driver */
    SND_HWDEP_IFACE_ICS2115 = 6, /**< ICS2115 driver */
    SND_HWDEP_IFACE_SSCAPE = 7, /**< Ensoniq SoundScape ISA card (MC68EC000) */
    SND_HWDEP_IFACE_VX = 8, /**< Digigram VX cards */
    SND_HWDEP_IFACE_MIXART = 9, /**< Digigram miXart cards */
    SND_HWDEP_IFACE_USX2Y = 10, /**< Tascam US122, US224 & US428 usb */
    SND_HWDEP_IFACE_EMUX_WAVETABLE = 11, /**< EmuX wavetable */
    SND_HWDEP_IFACE_BLUETOOTH = 12, /**< Bluetooth audio */
    SND_HWDEP_IFACE_USX2Y_PCM = 13, /**< Tascam US122, US224 & US428 raw USB PCM */
    SND_HWDEP_IFACE_PCXHR = 14, /**< Digigram PCXHR */
    SND_HWDEP_IFACE_SB_RC = 15, /**< SB Extigy/Audigy2NX remote control */
    SND_HWDEP_IFACE_HDA = 16, /**< HD-audio */
    SND_HWDEP_IFACE_USB_STREAM = 17, /**< direct access to usb stream */
    SND_HWDEP_IFACE_FW_DICE = 18, /**< TC DICE FireWire device */
    SND_HWDEP_IFACE_FW_FIREWORKS = 19, /**< Echo Audio Fireworks based device */
    SND_HWDEP_IFACE_FW_BEBOB = 20, /**< BridgeCo BeBoB based device */
    SND_HWDEP_IFACE_FW_OXFW = 21, /**< Oxford OXFW970/971 based device */
    SND_HWDEP_IFACE_FW_DIGI00X = 22, /* Digidesign Digi 002/003 family */
    SND_HWDEP_IFACE_FW_TASCAM = 23, /* TASCAM FireWire series */
    SND_HWDEP_IFACE_LINE6 = 24, /* Line6 USB processors */
    SND_HWDEP_IFACE_FW_MOTU = 25, /* MOTU FireWire series */
    SND_HWDEP_IFACE_FW_FIREFACE = 26, /* RME Fireface series */

    SND_HWDEP_IFACE_LAST = SND_HWDEP_IFACE_FW_FIREFACE /**< last known hwdep interface */
}

alias snd_hwdep_iface_t = _snd_hwdep_iface;

/** open for reading */

/** open for writing */

/** open for reading and writing */

/** open mode flag: open in nonblock mode */

/** HwDep handle type */
enum _snd_hwdep_type
{
    /** Kernel level HwDep */
    SND_HWDEP_TYPE_HW = 0,
    /** Shared memory client HwDep (not yet implemented) */
    SND_HWDEP_TYPE_SHM = 1,
    /** INET client HwDep (not yet implemented) */
    SND_HWDEP_TYPE_INET = 2
}

alias snd_hwdep_type_t = _snd_hwdep_type;

/** HwDep handle */
struct _snd_hwdep;
alias snd_hwdep_t = _snd_hwdep;

int snd_hwdep_open (snd_hwdep_t** hwdep, const(char)* name, int mode);
int snd_hwdep_close (snd_hwdep_t* hwdep);
int snd_hwdep_poll_descriptors (snd_hwdep_t* hwdep, pollfd* pfds, uint space);
int snd_hwdep_poll_descriptors_count (snd_hwdep_t* hwdep);
int snd_hwdep_poll_descriptors_revents (snd_hwdep_t* hwdep, pollfd* pfds, uint nfds, ushort* revents);
int snd_hwdep_nonblock (snd_hwdep_t* hwdep, int nonblock);
int snd_hwdep_info (snd_hwdep_t* hwdep, snd_hwdep_info_t* info);
int snd_hwdep_dsp_status (snd_hwdep_t* hwdep, snd_hwdep_dsp_status_t* status);
int snd_hwdep_dsp_load (snd_hwdep_t* hwdep, snd_hwdep_dsp_image_t* block);
int snd_hwdep_ioctl (snd_hwdep_t* hwdep, uint request, void* arg);
ssize_t snd_hwdep_write (snd_hwdep_t* hwdep, const(void)* buffer, size_t size);
ssize_t snd_hwdep_read (snd_hwdep_t* hwdep, void* buffer, size_t size);

size_t snd_hwdep_info_sizeof ();
/** allocate #snd_hwdep_info_t container on stack */

int snd_hwdep_info_malloc (snd_hwdep_info_t** ptr);
void snd_hwdep_info_free (snd_hwdep_info_t* obj);
void snd_hwdep_info_copy (snd_hwdep_info_t* dst, const(snd_hwdep_info_t)* src);

uint snd_hwdep_info_get_device (const(snd_hwdep_info_t)* obj);
int snd_hwdep_info_get_card (const(snd_hwdep_info_t)* obj);
const(char)* snd_hwdep_info_get_id (const(snd_hwdep_info_t)* obj);
const(char)* snd_hwdep_info_get_name (const(snd_hwdep_info_t)* obj);
snd_hwdep_iface_t snd_hwdep_info_get_iface (const(snd_hwdep_info_t)* obj);
void snd_hwdep_info_set_device (snd_hwdep_info_t* obj, uint val);

size_t snd_hwdep_dsp_status_sizeof ();
/** allocate #snd_hwdep_dsp_status_t container on stack */

int snd_hwdep_dsp_status_malloc (snd_hwdep_dsp_status_t** ptr);
void snd_hwdep_dsp_status_free (snd_hwdep_dsp_status_t* obj);
void snd_hwdep_dsp_status_copy (snd_hwdep_dsp_status_t* dst, const(snd_hwdep_dsp_status_t)* src);

uint snd_hwdep_dsp_status_get_version (const(snd_hwdep_dsp_status_t)* obj);
const(char)* snd_hwdep_dsp_status_get_id (const(snd_hwdep_dsp_status_t)* obj);
uint snd_hwdep_dsp_status_get_num_dsps (const(snd_hwdep_dsp_status_t)* obj);
uint snd_hwdep_dsp_status_get_dsp_loaded (const(snd_hwdep_dsp_status_t)* obj);
uint snd_hwdep_dsp_status_get_chip_ready (const(snd_hwdep_dsp_status_t)* obj);

size_t snd_hwdep_dsp_image_sizeof ();
/** allocate #snd_hwdep_dsp_image_t container on stack */

int snd_hwdep_dsp_image_malloc (snd_hwdep_dsp_image_t** ptr);
void snd_hwdep_dsp_image_free (snd_hwdep_dsp_image_t* obj);
void snd_hwdep_dsp_image_copy (snd_hwdep_dsp_image_t* dst, const(snd_hwdep_dsp_image_t)* src);

uint snd_hwdep_dsp_image_get_index (const(snd_hwdep_dsp_image_t)* obj);
const(char)* snd_hwdep_dsp_image_get_name (const(snd_hwdep_dsp_image_t)* obj);
const(void)* snd_hwdep_dsp_image_get_image (const(snd_hwdep_dsp_image_t)* obj);
size_t snd_hwdep_dsp_image_get_length (const(snd_hwdep_dsp_image_t)* obj);

void snd_hwdep_dsp_image_set_index (snd_hwdep_dsp_image_t* obj, uint _index);
void snd_hwdep_dsp_image_set_name (snd_hwdep_dsp_image_t* obj, const(char)* name);
void snd_hwdep_dsp_image_set_image (snd_hwdep_dsp_image_t* obj, void* buffer);
void snd_hwdep_dsp_image_set_length (snd_hwdep_dsp_image_t* obj, size_t length);
// enum SND_HWDEP_DLSYM_VERSION = _dlsym_hwdep_001;
enum SND_HWDEP_OPEN_READ = O_RDONLY;
enum SND_HWDEP_OPEN_WRITE = O_WRONLY;
enum SND_HWDEP_OPEN_DUPLEX = O_RDWR;
enum SND_HWDEP_OPEN_NONBLOCK = O_NONBLOCK;

extern (D) auto snd_hwdep_info_alloca(T)(auto ref T ptr)
{
    return __snd_alloca(ptr, snd_hwdep_info);
}

extern (D) auto snd_hwdep_dsp_status_alloca(T)(auto ref T ptr)
{
    return __snd_alloca(ptr, snd_hwdep_dsp_status);
}

extern (D) auto snd_hwdep_dsp_image_alloca(T)(auto ref T ptr)
{
    return __snd_alloca(ptr, snd_hwdep_dsp_image);
}

/** \} */

/* __ALSA_HWDEP_H */

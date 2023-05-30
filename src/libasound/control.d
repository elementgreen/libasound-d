/**
 * \file include/control.h
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

module libasound.control;

import core.stdc.config;
import core.sys.posix.poll;
import core.sys.posix.unistd;

import libasound.conf;
import libasound.global;

extern (C) @nogc nothrow:

/**
 *  \defgroup Control Control Interface
 *  The control interface.
 *  See \ref control page for more details.
 *  \{
 */

/** dlsym version for interface entry callback */
// enum SND_CONTROL_DLSYM_VERSION = _dlsym_control_001;

/** IEC958 structure */
struct snd_aes_iec958
{
    ubyte[24] status; /**< AES/IEC958 channel status bits */
    ubyte[147] subcode; /**< AES/IEC958 subcode bits */
    ubyte pad; /**< nothing */
    ubyte[4] dig_subframe; /**< AES/IEC958 subframe bits */
}

alias snd_aes_iec958_t = snd_aes_iec958;

/** \brief CTL card info container.
 *
 * This type contains meta information about a sound card, such as the index,
 * name, longname, etc.
 *
 * \par Memory management
 *
 * Before using a snd_ctl_card_info_t object, it must be allocated using
 * snd_ctl_card_info_alloca() or snd_ctl_card_info_malloc(). When using the
 * latter, it must be freed again using snd_ctl_card_info_free().
 *
 * A card info object can be zeroed out using snd_ctl_card_info_clear().
 *
 * A card info object can be copied to another one using
 * snd_ctl_card_info_copy().
 *
 * \par Obtaining the Information
 *
 * To obtain the card information, it must first be opened using
 * snd_ctl_open(), and a snd_ctl_card_info_t container must be
 * allocated. Then, the information can be read using
 * snd_ctl_card_info_get_card().
 *
 * Thereafter, the card properties can be read using the
 * snd_ctl_card_info_get_*() functions.
 */
struct _snd_ctl_card_info;
alias snd_ctl_card_info_t = _snd_ctl_card_info;

/** CTL element identifier container */
struct _snd_ctl_elem_id;
alias snd_ctl_elem_id_t = _snd_ctl_elem_id;

/** CTL element list container
 *
 * This is a list of CTL elements. The list contains management
 * information (e.g. how many elements the sound card has) as well as
 * the element identifiers. All functions which operate on the list
 * are named snd_ctl_elem_list_*().
 *
 * \par Memory management
 *
 * There are two memory areas to deal with: The list container itself
 * and the memory for the element identifiers.
 *
 * To manage the area for the list container, the following functions
 * are used:
 *
 * - snd_ctl_elem_list_malloc() / snd_ctl_elem_list_free() to allocate
 *   and free memory on the heap, or
 * - snd_ctl_elem_list_alloca() to allocate the memory on the
 *   stack. This memory is auto-released when the stack is unwound.
 *
 * To manage the space for the element identifiers, the
 * snd_ctl_elem_list_alloc_space() and snd_ctl_elem_list_free_space()
 * are used. Allocating the right amount of space can be achieved by
 * first obtaining the number of elements and then calling
 * snd_ctl_elem_list_alloc_space():
 *
 * \code
 *   snd_ctl_elem_list_t* list;
 *   int count;
 *
 *   // Initialise list
 *   snd_ctl_elem_list_malloc(&list);
 *
 *   // Get number of elements
 *   snd_ctl_elem_list(ctl, list);
 *   count = snd_ctl_elem_list_get_count(list);
 *
 *   // Allocate space for identifiers
 *   snd_ctl_elem_list_alloc_space(list, count);
 *
 *   // Get identifiers
 *   snd_ctl_elem_list(ctl, list); // yes, this is same as above :)
 *
 *   // Do something useful with the list...
 *
 *   // Cleanup
 *   snd_ctl_elem_list_free_space(list);
 *   snd_ctl_elem_list_free(list);
 * \endcode
 *
 *
 * \par The Elements
 *
 * The elements in the list are accessed using an index. This index is
 * the location in the list; Don't confuse it with the 'index' of the
 * element identifier. For example:
 *
 * \code
 *     snd_ctl_elem_list_t list;
 *     unsigned int element_index;
 *
 *     // Allocate space, fill list ...
 *
 *     element_index = snd_ctl_elem_list_get_index(&list, 2);
 * \endcode
 *
 * This will access the 3rd element in the list (index=2) and get the
 * elements index from the driver (which might be 13, for example).
 */
struct _snd_ctl_elem_list;
alias snd_ctl_elem_list_t = _snd_ctl_elem_list;

/** CTL element info container */
struct _snd_ctl_elem_info;
alias snd_ctl_elem_info_t = _snd_ctl_elem_info;

/** CTL element value container.
 *
 * Contains the value(s) (i.e. members) of a single element. All
 * values of a given element are of the same type.
 *
 * \par Memory management
 *
 * To access a value, a snd_ctl_elem_value_t must be allocated using
 * snd_ctl_elem_value_alloca() or snd_ctl_elem_value_malloc(). When
 * using the latter, it must be freed again using
 * snd_ctl_elem_value_free().
 *
 * A value object can be zeroed out using snd_ctl_elem_value_clear().
 *
 * A value object can be copied to another one using
 * snd_ctl_elem_value_copy().
 *
 * \par Identifier
 *
 * Then, the ID must be filled. It is sufficient to fill only the
 * numid, if known. Otherwise, interface type, device, subdevice,
 * name, index must all be given.  The following functions can be used
 * to fill the ID:
 *
 * - snd_ctl_elem_value_set_id(): Set the ID. Requires an
 *   snd_ctl_elem_id_t object.
 * - snd_ctl_elem_value_set_numid(): Set the numid.
 * - Or use all of the following:
 *
 *   - snd_ctl_elem_value_set_interface()
 *   - snd_ctl_elem_value_set_device()
 *   - snd_ctl_elem_value_set_subdevice()
 *   - snd_ctl_elem_value_set_name()
 *   - snd_ctl_elem_value_set_index()
 *
 * When communicating with the driver (snd_ctl_elem_read(),
 * snd_ctl_elem_write()), and the numid was given, the interface,
 * device, ... are filled (even if you set the before). When the numid
 * is unset (i.e. it is 0), it is filled.
 *
 * \par Communicating with the driver
 *
 * After the value container was created and filled with the ID of the
 * desired element, the value(s) can be fetched from the driver (and
 * thus from the hardware) or written to the driver.
 *
 * To fetch a value, use snd_ctl_elem_read(). Thereafter, use the
 * snd_ctl_elem_value_get_*() functions to obtain the actual value.
 *
 * To write a new value, first use a snd_ctl_elem_value_set_*() to set
 * it, then call snd_ctl_elem_write() to write it to the driver.
 */
struct _snd_ctl_elem_value;
alias snd_ctl_elem_value_t = _snd_ctl_elem_value;

/** CTL event container */
struct _snd_ctl_event;
alias snd_ctl_event_t = _snd_ctl_event;

/** CTL element type */
enum _snd_ctl_elem_type
{
    /** Invalid type */
    SND_CTL_ELEM_TYPE_NONE = 0,
    /** Boolean contents */
    SND_CTL_ELEM_TYPE_BOOLEAN = 1,
    /** Integer contents */
    SND_CTL_ELEM_TYPE_INTEGER = 2,
    /** Enumerated contents */
    SND_CTL_ELEM_TYPE_ENUMERATED = 3,
    /** Bytes contents */
    SND_CTL_ELEM_TYPE_BYTES = 4,
    /** IEC958 (S/PDIF) setting content */
    SND_CTL_ELEM_TYPE_IEC958 = 5,
    /** 64-bit integer contents */
    SND_CTL_ELEM_TYPE_INTEGER64 = 6,
    SND_CTL_ELEM_TYPE_LAST = SND_CTL_ELEM_TYPE_INTEGER64
}

alias snd_ctl_elem_type_t = _snd_ctl_elem_type;

/** CTL related interface */
enum _snd_ctl_elem_iface
{
    /** Card level */
    SND_CTL_ELEM_IFACE_CARD = 0,
    /** Hardware dependent device */
    SND_CTL_ELEM_IFACE_HWDEP = 1,
    /** Mixer */
    SND_CTL_ELEM_IFACE_MIXER = 2,
    /** PCM */
    SND_CTL_ELEM_IFACE_PCM = 3,
    /** RawMidi */
    SND_CTL_ELEM_IFACE_RAWMIDI = 4,
    /** Timer */
    SND_CTL_ELEM_IFACE_TIMER = 5,
    /** Sequencer */
    SND_CTL_ELEM_IFACE_SEQUENCER = 6,
    SND_CTL_ELEM_IFACE_LAST = SND_CTL_ELEM_IFACE_SEQUENCER
}

alias snd_ctl_elem_iface_t = _snd_ctl_elem_iface;

/** Event class */
enum _snd_ctl_event_type
{
    /** Elements related event */
    SND_CTL_EVENT_ELEM = 0,
    SND_CTL_EVENT_LAST = SND_CTL_EVENT_ELEM
}

alias snd_ctl_event_type_t = _snd_ctl_event_type;

/** Element has been removed (Warning: test this first and if set don't
  * test the other masks) \hideinitializer */
enum SND_CTL_EVENT_MASK_REMOVE = ~0U;
/** Element value has been changed \hideinitializer */
enum SND_CTL_EVENT_MASK_VALUE = 1 << 0;
/** Element info has been changed \hideinitializer */
enum SND_CTL_EVENT_MASK_INFO = 1 << 1;
/** Element has been added \hideinitializer */
enum SND_CTL_EVENT_MASK_ADD = 1 << 2;
/** Element's TLV value has been changed \hideinitializer */
enum SND_CTL_EVENT_MASK_TLV = 1 << 3;

/** CTL name helper */
enum SND_CTL_NAME_NONE = "";
/** CTL name helper */
enum SND_CTL_NAME_PLAYBACK = "Playback ";
/** CTL name helper */
enum SND_CTL_NAME_CAPTURE = "Capture ";

/** CTL name helper */
enum SND_CTL_NAME_IEC958_NONE = "";
/** CTL name helper */
enum SND_CTL_NAME_IEC958_SWITCH = "Switch";
/** CTL name helper */
enum SND_CTL_NAME_IEC958_VOLUME = "Volume";
/** CTL name helper */
enum SND_CTL_NAME_IEC958_DEFAULT = "Default";
/** CTL name helper */
enum SND_CTL_NAME_IEC958_MASK = "Mask";
/** CTL name helper */
enum SND_CTL_NAME_IEC958_CON_MASK = "Con Mask";
/** CTL name helper */
enum SND_CTL_NAME_IEC958_PRO_MASK = "Pro Mask";
/** CTL name helper */
enum SND_CTL_NAME_IEC958_PCM_STREAM = "PCM Stream";
/** Element name for IEC958 (S/PDIF) */

/** Mask for the major Power State identifier */
enum SND_CTL_POWER_MASK = 0xff00;
/** ACPI/PCI Power State D0 */
enum SND_CTL_POWER_D0 = 0x0000;
/** ACPI/PCI Power State D1 */
enum SND_CTL_POWER_D1 = 0x0100;
/** ACPI/PCI Power State D2 */
enum SND_CTL_POWER_D2 = 0x0200;
/** ACPI/PCI Power State D3 */
enum SND_CTL_POWER_D3 = 0x0300;
/** ACPI/PCI Power State D3hot */
enum SND_CTL_POWER_D3hot = SND_CTL_POWER_D3 | 0x0000;
/** ACPI/PCI Power State D3cold */
enum SND_CTL_POWER_D3cold = SND_CTL_POWER_D3 | 0x0001;

/** TLV type - Container */
enum SND_CTL_TLVT_CONTAINER = 0x0000;
/** TLV type - basic dB scale */
enum SND_CTL_TLVT_DB_SCALE = 0x0001;
/** TLV type - linear volume */
enum SND_CTL_TLVT_DB_LINEAR = 0x0002;
/** TLV type - dB range container */
enum SND_CTL_TLVT_DB_RANGE = 0x0003;
/** TLV type - dB scale specified by min/max values */
enum SND_CTL_TLVT_DB_MINMAX = 0x0004;
/** TLV type - dB scale specified by min/max values (with mute) */
enum SND_CTL_TLVT_DB_MINMAX_MUTE = 0x0005;

/** Mute state */
enum SND_CTL_TLV_DB_GAIN_MUTE = -9999999;

/** TLV type - fixed channel map positions */
enum SND_CTL_TLVT_CHMAP_FIXED = 0x00101;
/** TLV type - freely swappable channel map positions */
enum SND_CTL_TLVT_CHMAP_VAR = 0x00102;
/** TLV type - pair-wise swappable channel map positions */
enum SND_CTL_TLVT_CHMAP_PAIRED = 0x00103;

/** CTL type */
enum _snd_ctl_type
{
    /** Kernel level CTL */
    SND_CTL_TYPE_HW = 0,
    /** Shared memory client CTL */
    SND_CTL_TYPE_SHM = 1,
    /** INET client CTL (not yet implemented) */
    SND_CTL_TYPE_INET = 2,
    /** External control plugin */
    SND_CTL_TYPE_EXT = 3,
    /** Control functionality remapping */
    SND_CTL_TYPE_REMAP = 4
}

alias snd_ctl_type_t = _snd_ctl_type;

/** Non blocking mode (flag for open mode) \hideinitializer */
enum SND_CTL_NONBLOCK = 0x0001;

/** Async notification (flag for open mode) \hideinitializer */
enum SND_CTL_ASYNC = 0x0002;

/** Read only (flag for open mode) \hideinitializer */
enum SND_CTL_READONLY = 0x0004;

/** CTL handle */
struct _snd_ctl;
alias snd_ctl_t = _snd_ctl;

/** Don't destroy the ctl handle when close */
enum SND_SCTL_NOFREE = 0x0001;

/** SCTL type */
struct _snd_sctl;
alias snd_sctl_t = _snd_sctl;

int snd_card_load (int card);
int snd_card_next (int* card);
int snd_card_get_index (const(char)* name);
int snd_card_get_name (int card, char** name);
int snd_card_get_longname (int card, char** name);

int snd_device_name_hint (int card, const(char)* iface, void*** hints);
int snd_device_name_free_hint (void** hints);
char* snd_device_name_get_hint (const(void)* hint, const(char)* id);

int snd_ctl_open (snd_ctl_t** ctl, const(char)* name, int mode);
int snd_ctl_open_lconf (snd_ctl_t** ctl, const(char)* name, int mode, snd_config_t* lconf);
int snd_ctl_open_fallback (snd_ctl_t** ctl, snd_config_t* root, const(char)* name, const(char)* orig_name, int mode);
int snd_ctl_close (snd_ctl_t* ctl);
int snd_ctl_nonblock (snd_ctl_t* ctl, int nonblock);
int snd_ctl_abort (snd_ctl_t* ctl);
int snd_async_add_ctl_handler (
    snd_async_handler_t** handler,
    snd_ctl_t* ctl,
    snd_async_callback_t callback,
    void* private_data);
snd_ctl_t* snd_async_handler_get_ctl (snd_async_handler_t* handler);
int snd_ctl_poll_descriptors_count (snd_ctl_t* ctl);
int snd_ctl_poll_descriptors (snd_ctl_t* ctl, pollfd* pfds, uint space);
int snd_ctl_poll_descriptors_revents (snd_ctl_t* ctl, pollfd* pfds, uint nfds, ushort* revents);
int snd_ctl_subscribe_events (snd_ctl_t* ctl, int subscribe);
int snd_ctl_card_info (snd_ctl_t* ctl, snd_ctl_card_info_t* info);
int snd_ctl_elem_list (snd_ctl_t* ctl, snd_ctl_elem_list_t* list);
int snd_ctl_elem_info (snd_ctl_t* ctl, snd_ctl_elem_info_t* info);
int snd_ctl_elem_read (snd_ctl_t* ctl, snd_ctl_elem_value_t* data);
int snd_ctl_elem_write (snd_ctl_t* ctl, snd_ctl_elem_value_t* data);
int snd_ctl_elem_lock (snd_ctl_t* ctl, snd_ctl_elem_id_t* id);
int snd_ctl_elem_unlock (snd_ctl_t* ctl, snd_ctl_elem_id_t* id);
int snd_ctl_elem_tlv_read (
    snd_ctl_t* ctl,
    const(snd_ctl_elem_id_t)* id,
    uint* tlv,
    uint tlv_size);
int snd_ctl_elem_tlv_write (
    snd_ctl_t* ctl,
    const(snd_ctl_elem_id_t)* id,
    const(uint)* tlv);
int snd_ctl_elem_tlv_command (
    snd_ctl_t* ctl,
    const(snd_ctl_elem_id_t)* id,
    const(uint)* tlv);

int snd_ctl_set_power_state (snd_ctl_t* ctl, uint state);
int snd_ctl_get_power_state (snd_ctl_t* ctl, uint* state);

int snd_ctl_read (snd_ctl_t* ctl, snd_ctl_event_t* event);
int snd_ctl_wait (snd_ctl_t* ctl, int timeout);
const(char)* snd_ctl_name (snd_ctl_t* ctl);
snd_ctl_type_t snd_ctl_type (snd_ctl_t* ctl);

const(char)* snd_ctl_elem_type_name (snd_ctl_elem_type_t type);
const(char)* snd_ctl_elem_iface_name (snd_ctl_elem_iface_t iface);
const(char)* snd_ctl_event_type_name (snd_ctl_event_type_t type);

uint snd_ctl_event_elem_get_mask (const(snd_ctl_event_t)* obj);
uint snd_ctl_event_elem_get_numid (const(snd_ctl_event_t)* obj);
void snd_ctl_event_elem_get_id (const(snd_ctl_event_t)* obj, snd_ctl_elem_id_t* ptr);
snd_ctl_elem_iface_t snd_ctl_event_elem_get_interface (const(snd_ctl_event_t)* obj);
uint snd_ctl_event_elem_get_device (const(snd_ctl_event_t)* obj);
uint snd_ctl_event_elem_get_subdevice (const(snd_ctl_event_t)* obj);
const(char)* snd_ctl_event_elem_get_name (const(snd_ctl_event_t)* obj);
uint snd_ctl_event_elem_get_index (const(snd_ctl_event_t)* obj);

int snd_ctl_elem_list_alloc_space (snd_ctl_elem_list_t* obj, uint entries);
void snd_ctl_elem_list_free_space (snd_ctl_elem_list_t* obj);

char* snd_ctl_ascii_elem_id_get (snd_ctl_elem_id_t* id);
int snd_ctl_ascii_elem_id_parse (snd_ctl_elem_id_t* dst, const(char)* str);
int snd_ctl_ascii_value_parse (
    snd_ctl_t* handle,
    snd_ctl_elem_value_t* dst,
    snd_ctl_elem_info_t* info,
    const(char)* value);

size_t snd_ctl_elem_id_sizeof ();
/** \hideinitializer
 * \brief allocate an invalid #snd_ctl_elem_id_t using standard alloca
 * \param ptr returned pointer
 */
extern (D) auto snd_ctl_elem_id_alloca(T)(auto ref T ptr)
{
    return __snd_alloca(ptr, snd_ctl_elem_id);
}

int snd_ctl_elem_id_malloc (snd_ctl_elem_id_t** ptr);
void snd_ctl_elem_id_free (snd_ctl_elem_id_t* obj);
void snd_ctl_elem_id_clear (snd_ctl_elem_id_t* obj);
void snd_ctl_elem_id_copy (snd_ctl_elem_id_t* dst, const(snd_ctl_elem_id_t)* src);
int snd_ctl_elem_id_compare_numid (const(snd_ctl_elem_id_t)* id1, const(snd_ctl_elem_id_t)* id2);
int snd_ctl_elem_id_compare_set (const(snd_ctl_elem_id_t)* id1, const(snd_ctl_elem_id_t)* id2);
uint snd_ctl_elem_id_get_numid (const(snd_ctl_elem_id_t)* obj);
snd_ctl_elem_iface_t snd_ctl_elem_id_get_interface (const(snd_ctl_elem_id_t)* obj);
uint snd_ctl_elem_id_get_device (const(snd_ctl_elem_id_t)* obj);
uint snd_ctl_elem_id_get_subdevice (const(snd_ctl_elem_id_t)* obj);
const(char)* snd_ctl_elem_id_get_name (const(snd_ctl_elem_id_t)* obj);
uint snd_ctl_elem_id_get_index (const(snd_ctl_elem_id_t)* obj);
void snd_ctl_elem_id_set_numid (snd_ctl_elem_id_t* obj, uint val);
void snd_ctl_elem_id_set_interface (snd_ctl_elem_id_t* obj, snd_ctl_elem_iface_t val);
void snd_ctl_elem_id_set_device (snd_ctl_elem_id_t* obj, uint val);
void snd_ctl_elem_id_set_subdevice (snd_ctl_elem_id_t* obj, uint val);
void snd_ctl_elem_id_set_name (snd_ctl_elem_id_t* obj, const(char)* val);
void snd_ctl_elem_id_set_index (snd_ctl_elem_id_t* obj, uint val);

size_t snd_ctl_card_info_sizeof ();

/** \hideinitializer
 * \brief Allocate an invalid #snd_ctl_card_info_t on the stack.
 *
 * Allocate space for a card info object on the stack. The allocated
 * memory need not be freed, because it is on the stack.
 *
 * See snd_ctl_card_info_t for details.
 *
 * \param ptr Pointer to a snd_ctl_elem_value_t pointer. The address
 *            of the allocated space will returned here.
 */
extern (D) auto snd_ctl_card_info_alloca(T)(auto ref T ptr)
{
    return __snd_alloca(ptr, snd_ctl_card_info);
}

int snd_ctl_card_info_malloc (snd_ctl_card_info_t** ptr);
void snd_ctl_card_info_free (snd_ctl_card_info_t* obj);
void snd_ctl_card_info_clear (snd_ctl_card_info_t* obj);
void snd_ctl_card_info_copy (snd_ctl_card_info_t* dst, const(snd_ctl_card_info_t)* src);
int snd_ctl_card_info_get_card (const(snd_ctl_card_info_t)* obj);
const(char)* snd_ctl_card_info_get_id (const(snd_ctl_card_info_t)* obj);
const(char)* snd_ctl_card_info_get_driver (const(snd_ctl_card_info_t)* obj);
const(char)* snd_ctl_card_info_get_name (const(snd_ctl_card_info_t)* obj);
const(char)* snd_ctl_card_info_get_longname (const(snd_ctl_card_info_t)* obj);
const(char)* snd_ctl_card_info_get_mixername (const(snd_ctl_card_info_t)* obj);
const(char)* snd_ctl_card_info_get_components (const(snd_ctl_card_info_t)* obj);

size_t snd_ctl_event_sizeof ();
/** \hideinitializer
 * \brief allocate an invalid #snd_ctl_event_t using standard alloca
 * \param ptr returned pointer
 */
extern (D) auto snd_ctl_event_alloca(T)(auto ref T ptr)
{
    return __snd_alloca(ptr, snd_ctl_event);
}

int snd_ctl_event_malloc (snd_ctl_event_t** ptr);
void snd_ctl_event_free (snd_ctl_event_t* obj);
void snd_ctl_event_clear (snd_ctl_event_t* obj);
void snd_ctl_event_copy (snd_ctl_event_t* dst, const(snd_ctl_event_t)* src);
snd_ctl_event_type_t snd_ctl_event_get_type (const(snd_ctl_event_t)* obj);

size_t snd_ctl_elem_list_sizeof ();

/** \hideinitializer
 *
 * \brief Allocate a #snd_ctl_elem_list_t using standard alloca.
 *
 * The memory is allocated on the stack and will automatically be
 * released when the stack unwinds (i.e. no free() is needed).
 *
 * \param ptr Pointer to allocated memory.
 */
extern (D) auto snd_ctl_elem_list_alloca(T)(auto ref T ptr)
{
    return __snd_alloca(ptr, snd_ctl_elem_list);
}

int snd_ctl_elem_list_malloc (snd_ctl_elem_list_t** ptr);
void snd_ctl_elem_list_free (snd_ctl_elem_list_t* obj);
void snd_ctl_elem_list_clear (snd_ctl_elem_list_t* obj);
void snd_ctl_elem_list_copy (snd_ctl_elem_list_t* dst, const(snd_ctl_elem_list_t)* src);
void snd_ctl_elem_list_set_offset (snd_ctl_elem_list_t* obj, uint val);
uint snd_ctl_elem_list_get_used (const(snd_ctl_elem_list_t)* obj);
uint snd_ctl_elem_list_get_count (const(snd_ctl_elem_list_t)* obj);
void snd_ctl_elem_list_get_id (const(snd_ctl_elem_list_t)* obj, uint idx, snd_ctl_elem_id_t* ptr);
uint snd_ctl_elem_list_get_numid (const(snd_ctl_elem_list_t)* obj, uint idx);
snd_ctl_elem_iface_t snd_ctl_elem_list_get_interface (const(snd_ctl_elem_list_t)* obj, uint idx);
uint snd_ctl_elem_list_get_device (const(snd_ctl_elem_list_t)* obj, uint idx);
uint snd_ctl_elem_list_get_subdevice (const(snd_ctl_elem_list_t)* obj, uint idx);
const(char)* snd_ctl_elem_list_get_name (const(snd_ctl_elem_list_t)* obj, uint idx);
uint snd_ctl_elem_list_get_index (const(snd_ctl_elem_list_t)* obj, uint idx);

size_t snd_ctl_elem_info_sizeof ();
/** \hideinitializer
 * \brief allocate an invalid #snd_ctl_elem_info_t using standard alloca
 * \param ptr returned pointer
 */
extern (D) auto snd_ctl_elem_info_alloca(T)(auto ref T ptr)
{
    return __snd_alloca(ptr, snd_ctl_elem_info);
}

int snd_ctl_elem_info_malloc (snd_ctl_elem_info_t** ptr);
void snd_ctl_elem_info_free (snd_ctl_elem_info_t* obj);
void snd_ctl_elem_info_clear (snd_ctl_elem_info_t* obj);
void snd_ctl_elem_info_copy (snd_ctl_elem_info_t* dst, const(snd_ctl_elem_info_t)* src);
snd_ctl_elem_type_t snd_ctl_elem_info_get_type (const(snd_ctl_elem_info_t)* obj);
int snd_ctl_elem_info_is_readable (const(snd_ctl_elem_info_t)* obj);
int snd_ctl_elem_info_is_writable (const(snd_ctl_elem_info_t)* obj);
int snd_ctl_elem_info_is_volatile (const(snd_ctl_elem_info_t)* obj);
int snd_ctl_elem_info_is_inactive (const(snd_ctl_elem_info_t)* obj);
int snd_ctl_elem_info_is_locked (const(snd_ctl_elem_info_t)* obj);
int snd_ctl_elem_info_is_tlv_readable (const(snd_ctl_elem_info_t)* obj);
int snd_ctl_elem_info_is_tlv_writable (const(snd_ctl_elem_info_t)* obj);
int snd_ctl_elem_info_is_tlv_commandable (const(snd_ctl_elem_info_t)* obj);
int snd_ctl_elem_info_is_owner (const(snd_ctl_elem_info_t)* obj);
int snd_ctl_elem_info_is_user (const(snd_ctl_elem_info_t)* obj);
pid_t snd_ctl_elem_info_get_owner (const(snd_ctl_elem_info_t)* obj);
uint snd_ctl_elem_info_get_count (const(snd_ctl_elem_info_t)* obj);
c_long snd_ctl_elem_info_get_min (const(snd_ctl_elem_info_t)* obj);
c_long snd_ctl_elem_info_get_max (const(snd_ctl_elem_info_t)* obj);
c_long snd_ctl_elem_info_get_step (const(snd_ctl_elem_info_t)* obj);
long snd_ctl_elem_info_get_min64 (const(snd_ctl_elem_info_t)* obj);
long snd_ctl_elem_info_get_max64 (const(snd_ctl_elem_info_t)* obj);
long snd_ctl_elem_info_get_step64 (const(snd_ctl_elem_info_t)* obj);
uint snd_ctl_elem_info_get_items (const(snd_ctl_elem_info_t)* obj);
void snd_ctl_elem_info_set_item (snd_ctl_elem_info_t* obj, uint val);
const(char)* snd_ctl_elem_info_get_item_name (const(snd_ctl_elem_info_t)* obj);
int snd_ctl_elem_info_get_dimensions (const(snd_ctl_elem_info_t)* obj);
int snd_ctl_elem_info_get_dimension (const(snd_ctl_elem_info_t)* obj, uint idx);
int snd_ctl_elem_info_set_dimension (
    snd_ctl_elem_info_t* info,
    ref const(int)[4] dimension);
void snd_ctl_elem_info_get_id (const(snd_ctl_elem_info_t)* obj, snd_ctl_elem_id_t* ptr);
uint snd_ctl_elem_info_get_numid (const(snd_ctl_elem_info_t)* obj);
snd_ctl_elem_iface_t snd_ctl_elem_info_get_interface (const(snd_ctl_elem_info_t)* obj);
uint snd_ctl_elem_info_get_device (const(snd_ctl_elem_info_t)* obj);
uint snd_ctl_elem_info_get_subdevice (const(snd_ctl_elem_info_t)* obj);
const(char)* snd_ctl_elem_info_get_name (const(snd_ctl_elem_info_t)* obj);
uint snd_ctl_elem_info_get_index (const(snd_ctl_elem_info_t)* obj);
void snd_ctl_elem_info_set_id (snd_ctl_elem_info_t* obj, const(snd_ctl_elem_id_t)* ptr);
void snd_ctl_elem_info_set_numid (snd_ctl_elem_info_t* obj, uint val);
void snd_ctl_elem_info_set_interface (snd_ctl_elem_info_t* obj, snd_ctl_elem_iface_t val);
void snd_ctl_elem_info_set_device (snd_ctl_elem_info_t* obj, uint val);
void snd_ctl_elem_info_set_subdevice (snd_ctl_elem_info_t* obj, uint val);
void snd_ctl_elem_info_set_name (snd_ctl_elem_info_t* obj, const(char)* val);
void snd_ctl_elem_info_set_index (snd_ctl_elem_info_t* obj, uint val);
void snd_ctl_elem_info_set_read_write (snd_ctl_elem_info_t* obj, int rval, int wval);
void snd_ctl_elem_info_set_tlv_read_write (snd_ctl_elem_info_t* obj, int rval, int wval);
void snd_ctl_elem_info_set_inactive (snd_ctl_elem_info_t* obj, int val);

int snd_ctl_add_integer_elem_set (
    snd_ctl_t* ctl,
    snd_ctl_elem_info_t* info,
    uint element_count,
    uint member_count,
    c_long min,
    c_long max,
    c_long step);
int snd_ctl_add_integer64_elem_set (
    snd_ctl_t* ctl,
    snd_ctl_elem_info_t* info,
    uint element_count,
    uint member_count,
    long min,
    long max,
    long step);
int snd_ctl_add_boolean_elem_set (
    snd_ctl_t* ctl,
    snd_ctl_elem_info_t* info,
    uint element_count,
    uint member_count);
int snd_ctl_add_enumerated_elem_set (
    snd_ctl_t* ctl,
    snd_ctl_elem_info_t* info,
    uint element_count,
    uint member_count,
    uint items,
    const(char*)* labels);
int snd_ctl_add_bytes_elem_set (
    snd_ctl_t* ctl,
    snd_ctl_elem_info_t* info,
    uint element_count,
    uint member_count);

int snd_ctl_elem_add_integer (snd_ctl_t* ctl, const(snd_ctl_elem_id_t)* id, uint count, c_long imin, c_long imax, c_long istep);
int snd_ctl_elem_add_integer64 (snd_ctl_t* ctl, const(snd_ctl_elem_id_t)* id, uint count, long imin, long imax, long istep);
int snd_ctl_elem_add_boolean (snd_ctl_t* ctl, const(snd_ctl_elem_id_t)* id, uint count);
int snd_ctl_elem_add_enumerated (snd_ctl_t* ctl, const(snd_ctl_elem_id_t)* id, uint count, uint items, const(char*)* names);
int snd_ctl_elem_add_iec958 (snd_ctl_t* ctl, const(snd_ctl_elem_id_t)* id);
int snd_ctl_elem_remove (snd_ctl_t* ctl, snd_ctl_elem_id_t* id);

size_t snd_ctl_elem_value_sizeof ();

/** \hideinitializer
 * \brief Allocate an invalid #snd_ctl_elem_value_t on the stack.
 *
 * Allocate space for a value object on the stack. The allocated
 * memory need not be freed, because it is on the stack.
 *
 * See snd_ctl_elem_value_t for details.
 *
 * \param ptr Pointer to a snd_ctl_elem_value_t pointer. The address
 *            of the allocated space will returned here.
 */
extern (D) auto snd_ctl_elem_value_alloca(T)(auto ref T ptr)
{
    return __snd_alloca(ptr, snd_ctl_elem_value);
}

int snd_ctl_elem_value_malloc (snd_ctl_elem_value_t** ptr);
void snd_ctl_elem_value_free (snd_ctl_elem_value_t* obj);
void snd_ctl_elem_value_clear (snd_ctl_elem_value_t* obj);
void snd_ctl_elem_value_copy (snd_ctl_elem_value_t* dst, const(snd_ctl_elem_value_t)* src);
int snd_ctl_elem_value_compare (snd_ctl_elem_value_t* left, const(snd_ctl_elem_value_t)* right);
void snd_ctl_elem_value_get_id (const(snd_ctl_elem_value_t)* obj, snd_ctl_elem_id_t* ptr);
uint snd_ctl_elem_value_get_numid (const(snd_ctl_elem_value_t)* obj);
snd_ctl_elem_iface_t snd_ctl_elem_value_get_interface (const(snd_ctl_elem_value_t)* obj);
uint snd_ctl_elem_value_get_device (const(snd_ctl_elem_value_t)* obj);
uint snd_ctl_elem_value_get_subdevice (const(snd_ctl_elem_value_t)* obj);
const(char)* snd_ctl_elem_value_get_name (const(snd_ctl_elem_value_t)* obj);
uint snd_ctl_elem_value_get_index (const(snd_ctl_elem_value_t)* obj);
void snd_ctl_elem_value_set_id (snd_ctl_elem_value_t* obj, const(snd_ctl_elem_id_t)* ptr);
void snd_ctl_elem_value_set_numid (snd_ctl_elem_value_t* obj, uint val);
void snd_ctl_elem_value_set_interface (snd_ctl_elem_value_t* obj, snd_ctl_elem_iface_t val);
void snd_ctl_elem_value_set_device (snd_ctl_elem_value_t* obj, uint val);
void snd_ctl_elem_value_set_subdevice (snd_ctl_elem_value_t* obj, uint val);
void snd_ctl_elem_value_set_name (snd_ctl_elem_value_t* obj, const(char)* val);
void snd_ctl_elem_value_set_index (snd_ctl_elem_value_t* obj, uint val);
int snd_ctl_elem_value_get_boolean (const(snd_ctl_elem_value_t)* obj, uint idx);
c_long snd_ctl_elem_value_get_integer (const(snd_ctl_elem_value_t)* obj, uint idx);
long snd_ctl_elem_value_get_integer64 (const(snd_ctl_elem_value_t)* obj, uint idx);
uint snd_ctl_elem_value_get_enumerated (const(snd_ctl_elem_value_t)* obj, uint idx);
ubyte snd_ctl_elem_value_get_byte (const(snd_ctl_elem_value_t)* obj, uint idx);
void snd_ctl_elem_value_set_boolean (snd_ctl_elem_value_t* obj, uint idx, c_long val);
void snd_ctl_elem_value_set_integer (snd_ctl_elem_value_t* obj, uint idx, c_long val);
void snd_ctl_elem_value_set_integer64 (snd_ctl_elem_value_t* obj, uint idx, long val);
void snd_ctl_elem_value_set_enumerated (snd_ctl_elem_value_t* obj, uint idx, uint val);
void snd_ctl_elem_value_set_byte (snd_ctl_elem_value_t* obj, uint idx, ubyte val);
void snd_ctl_elem_set_bytes (snd_ctl_elem_value_t* obj, void* data, size_t size);
const(void)* snd_ctl_elem_value_get_bytes (const(snd_ctl_elem_value_t)* obj);
void snd_ctl_elem_value_get_iec958 (const(snd_ctl_elem_value_t)* obj, snd_aes_iec958_t* ptr);
void snd_ctl_elem_value_set_iec958 (snd_ctl_elem_value_t* obj, const(snd_aes_iec958_t)* ptr);

int snd_tlv_parse_dB_info (uint* tlv, uint tlv_size, uint** db_tlvp);
int snd_tlv_get_dB_range (
    uint* tlv,
    c_long rangemin,
    c_long rangemax,
    c_long* min,
    c_long* max);
int snd_tlv_convert_to_dB (
    uint* tlv,
    c_long rangemin,
    c_long rangemax,
    c_long volume,
    c_long* db_gain);
int snd_tlv_convert_from_dB (
    uint* tlv,
    c_long rangemin,
    c_long rangemax,
    c_long db_gain,
    c_long* value,
    int xdir);
int snd_ctl_get_dB_range (
    snd_ctl_t* ctl,
    const(snd_ctl_elem_id_t)* id,
    c_long* min,
    c_long* max);
int snd_ctl_convert_to_dB (
    snd_ctl_t* ctl,
    const(snd_ctl_elem_id_t)* id,
    c_long volume,
    c_long* db_gain);
int snd_ctl_convert_from_dB (
    snd_ctl_t* ctl,
    const(snd_ctl_elem_id_t)* id,
    c_long db_gain,
    c_long* value,
    int xdir);

/**
 *  \defgroup HControl High level Control Interface
 *  \ingroup Control
 *  The high level control interface.
 *  See \ref hcontrol page for more details.
 *  \{
 */

/** HCTL element handle */
struct _snd_hctl_elem;
alias snd_hctl_elem_t = _snd_hctl_elem;

/** HCTL handle */
struct _snd_hctl;
alias snd_hctl_t = _snd_hctl;

/**
 * \brief Compare function for sorting HCTL elements
 * \param e1 First element
 * \param e2 Second element
 * \return -1 if e1 < e2, 0 if e1 == e2, 1 if e1 > e2
 */
alias snd_hctl_compare_t = int function (
    const(snd_hctl_elem_t)* e1,
    const(snd_hctl_elem_t)* e2);
int snd_hctl_compare_fast (
    const(snd_hctl_elem_t)* c1,
    const(snd_hctl_elem_t)* c2);
/**
 * \brief HCTL callback function
 * \param hctl HCTL handle
 * \param mask event mask
 * \param elem related HCTL element (if any)
 * \return 0 on success otherwise a negative error code
 */
alias snd_hctl_callback_t = int function (
    snd_hctl_t* hctl,
    uint mask,
    snd_hctl_elem_t* elem);
/**
 * \brief HCTL element callback function
 * \param elem HCTL element
 * \param mask event mask
 * \return 0 on success otherwise a negative error code
 */
alias snd_hctl_elem_callback_t = int function (
    snd_hctl_elem_t* elem,
    uint mask);

int snd_hctl_open (snd_hctl_t** hctl, const(char)* name, int mode);
int snd_hctl_open_ctl (snd_hctl_t** hctlp, snd_ctl_t* ctl);
int snd_hctl_close (snd_hctl_t* hctl);
int snd_hctl_nonblock (snd_hctl_t* hctl, int nonblock);
int snd_hctl_abort (snd_hctl_t* hctl);
int snd_hctl_poll_descriptors_count (snd_hctl_t* hctl);
int snd_hctl_poll_descriptors (snd_hctl_t* hctl, pollfd* pfds, uint space);
int snd_hctl_poll_descriptors_revents (snd_hctl_t* ctl, pollfd* pfds, uint nfds, ushort* revents);
uint snd_hctl_get_count (snd_hctl_t* hctl);
int snd_hctl_set_compare (snd_hctl_t* hctl, snd_hctl_compare_t hsort);
snd_hctl_elem_t* snd_hctl_first_elem (snd_hctl_t* hctl);
snd_hctl_elem_t* snd_hctl_last_elem (snd_hctl_t* hctl);
snd_hctl_elem_t* snd_hctl_find_elem (snd_hctl_t* hctl, const(snd_ctl_elem_id_t)* id);
void snd_hctl_set_callback (snd_hctl_t* hctl, snd_hctl_callback_t callback);
void snd_hctl_set_callback_private (snd_hctl_t* hctl, void* data);
void* snd_hctl_get_callback_private (snd_hctl_t* hctl);
int snd_hctl_load (snd_hctl_t* hctl);
int snd_hctl_free (snd_hctl_t* hctl);
int snd_hctl_handle_events (snd_hctl_t* hctl);
const(char)* snd_hctl_name (snd_hctl_t* hctl);
int snd_hctl_wait (snd_hctl_t* hctl, int timeout);
snd_ctl_t* snd_hctl_ctl (snd_hctl_t* hctl);

snd_hctl_elem_t* snd_hctl_elem_next (snd_hctl_elem_t* elem);
snd_hctl_elem_t* snd_hctl_elem_prev (snd_hctl_elem_t* elem);
int snd_hctl_elem_info (snd_hctl_elem_t* elem, snd_ctl_elem_info_t* info);
int snd_hctl_elem_read (snd_hctl_elem_t* elem, snd_ctl_elem_value_t* value);
int snd_hctl_elem_write (snd_hctl_elem_t* elem, snd_ctl_elem_value_t* value);
int snd_hctl_elem_tlv_read (snd_hctl_elem_t* elem, uint* tlv, uint tlv_size);
int snd_hctl_elem_tlv_write (snd_hctl_elem_t* elem, const(uint)* tlv);
int snd_hctl_elem_tlv_command (snd_hctl_elem_t* elem, const(uint)* tlv);

snd_hctl_t* snd_hctl_elem_get_hctl (snd_hctl_elem_t* elem);

void snd_hctl_elem_get_id (const(snd_hctl_elem_t)* obj, snd_ctl_elem_id_t* ptr);
uint snd_hctl_elem_get_numid (const(snd_hctl_elem_t)* obj);
snd_ctl_elem_iface_t snd_hctl_elem_get_interface (const(snd_hctl_elem_t)* obj);
uint snd_hctl_elem_get_device (const(snd_hctl_elem_t)* obj);
uint snd_hctl_elem_get_subdevice (const(snd_hctl_elem_t)* obj);
const(char)* snd_hctl_elem_get_name (const(snd_hctl_elem_t)* obj);
uint snd_hctl_elem_get_index (const(snd_hctl_elem_t)* obj);
void snd_hctl_elem_set_callback (snd_hctl_elem_t* obj, snd_hctl_elem_callback_t val);
void* snd_hctl_elem_get_callback_private (const(snd_hctl_elem_t)* obj);
void snd_hctl_elem_set_callback_private (snd_hctl_elem_t* obj, void* val);

/** \} */

/** \} */

/**
 *  \defgroup SControl Setup Control Interface
 *  \ingroup Control
 *  The setup control interface - set or modify control elements from a configuration file.
 *  \{
 */

int snd_sctl_build (
    snd_sctl_t** ctl,
    snd_ctl_t* handle,
    snd_config_t* config,
    snd_config_t* private_data,
    int mode);
int snd_sctl_free (snd_sctl_t* handle);
int snd_sctl_install (snd_sctl_t* handle);
int snd_sctl_remove (snd_sctl_t* handle);

/** \} */

/* __ALSA_CONTROL_H */

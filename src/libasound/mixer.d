/**
 * \file include/mixer.h
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

module libasound.mixer;

import core.stdc.config;
import core.sys.posix.poll;

import libasound.control;
import libasound.pcm;

extern (C) @nogc nothrow:

/**
 *  \defgroup Mixer Mixer Interface
 *  The mixer interface.
 *  \{
 */

/** Mixer handle */
struct _snd_mixer;
alias snd_mixer_t = _snd_mixer;
/** Mixer elements class handle */
struct _snd_mixer_class;
alias snd_mixer_class_t = _snd_mixer_class;
/** Mixer element handle */
struct _snd_mixer_elem;
alias snd_mixer_elem_t = _snd_mixer_elem;

/**
 * \brief Mixer callback function
 * \param mixer Mixer handle
 * \param mask event mask
 * \param elem related mixer element (if any)
 * \return 0 on success otherwise a negative error code
 */
alias snd_mixer_callback_t = int function (
    snd_mixer_t* ctl,
    uint mask,
    snd_mixer_elem_t* elem);

/**
 * \brief Mixer element callback function
 * \param elem Mixer element
 * \param mask event mask
 * \return 0 on success otherwise a negative error code
 */
alias snd_mixer_elem_callback_t = int function (
    snd_mixer_elem_t* elem,
    uint mask);

/**
 * \brief Compare function for sorting mixer elements
 * \param e1 First element
 * \param e2 Second element
 * \return -1 if e1 < e2, 0 if e1 == e2, 1 if e1 > e2
 */
alias snd_mixer_compare_t = int function (
    const(snd_mixer_elem_t)* e1,
    const(snd_mixer_elem_t)* e2);

/**
 * \brief Event callback for the mixer class
 * \param class_ Mixer class
 * \param mask Event mask (SND_CTL_EVENT_*)
 * \param helem HCTL element which invoked the event
 * \param melem Mixer element associated to HCTL element
 * \return zero if success, otherwise a negative error value
 */
alias snd_mixer_event_t = int function (
    snd_mixer_class_t* class_,
    uint mask,
    snd_hctl_elem_t* helem,
    snd_mixer_elem_t* melem);

/** Mixer element type */
enum _snd_mixer_elem_type
{
    /* Simple mixer elements */
    SND_MIXER_ELEM_SIMPLE = 0,
    SND_MIXER_ELEM_LAST = SND_MIXER_ELEM_SIMPLE
}

alias snd_mixer_elem_type_t = _snd_mixer_elem_type;

int snd_mixer_open (snd_mixer_t** mixer, int mode);
int snd_mixer_close (snd_mixer_t* mixer);
snd_mixer_elem_t* snd_mixer_first_elem (snd_mixer_t* mixer);
snd_mixer_elem_t* snd_mixer_last_elem (snd_mixer_t* mixer);
int snd_mixer_handle_events (snd_mixer_t* mixer);
int snd_mixer_attach (snd_mixer_t* mixer, const(char)* name);
int snd_mixer_attach_hctl (snd_mixer_t* mixer, snd_hctl_t* hctl);
int snd_mixer_detach (snd_mixer_t* mixer, const(char)* name);
int snd_mixer_detach_hctl (snd_mixer_t* mixer, snd_hctl_t* hctl);
int snd_mixer_get_hctl (snd_mixer_t* mixer, const(char)* name, snd_hctl_t** hctl);
int snd_mixer_poll_descriptors_count (snd_mixer_t* mixer);
int snd_mixer_poll_descriptors (snd_mixer_t* mixer, pollfd* pfds, uint space);
int snd_mixer_poll_descriptors_revents (snd_mixer_t* mixer, pollfd* pfds, uint nfds, ushort* revents);
int snd_mixer_load (snd_mixer_t* mixer);
void snd_mixer_free (snd_mixer_t* mixer);
int snd_mixer_wait (snd_mixer_t* mixer, int timeout);
int snd_mixer_set_compare (snd_mixer_t* mixer, snd_mixer_compare_t msort);
void snd_mixer_set_callback (snd_mixer_t* obj, snd_mixer_callback_t val);
void* snd_mixer_get_callback_private (const(snd_mixer_t)* obj);
void snd_mixer_set_callback_private (snd_mixer_t* obj, void* val);
uint snd_mixer_get_count (const(snd_mixer_t)* obj);
int snd_mixer_class_unregister (snd_mixer_class_t* clss);

snd_mixer_elem_t* snd_mixer_elem_next (snd_mixer_elem_t* elem);
snd_mixer_elem_t* snd_mixer_elem_prev (snd_mixer_elem_t* elem);
void snd_mixer_elem_set_callback (snd_mixer_elem_t* obj, snd_mixer_elem_callback_t val);
void* snd_mixer_elem_get_callback_private (const(snd_mixer_elem_t)* obj);
void snd_mixer_elem_set_callback_private (snd_mixer_elem_t* obj, void* val);
snd_mixer_elem_type_t snd_mixer_elem_get_type (const(snd_mixer_elem_t)* obj);

int snd_mixer_class_register (snd_mixer_class_t* class_, snd_mixer_t* mixer);
int snd_mixer_elem_new (
    snd_mixer_elem_t** elem,
    snd_mixer_elem_type_t type,
    int compare_weight,
    void* private_data,
    void function (snd_mixer_elem_t* elem) private_free);
int snd_mixer_elem_add (snd_mixer_elem_t* elem, snd_mixer_class_t* class_);
int snd_mixer_elem_remove (snd_mixer_elem_t* elem);
void snd_mixer_elem_free (snd_mixer_elem_t* elem);
int snd_mixer_elem_info (snd_mixer_elem_t* elem);
int snd_mixer_elem_value (snd_mixer_elem_t* elem);
int snd_mixer_elem_attach (snd_mixer_elem_t* melem, snd_hctl_elem_t* helem);
int snd_mixer_elem_detach (snd_mixer_elem_t* melem, snd_hctl_elem_t* helem);
int snd_mixer_elem_empty (snd_mixer_elem_t* melem);
void* snd_mixer_elem_get_private (const(snd_mixer_elem_t)* melem);

size_t snd_mixer_class_sizeof ();
/** \hideinitializer
 * \brief allocate an invalid #snd_mixer_class_t using standard alloca
 * \param ptr returned pointer
 */
extern (D) auto snd_mixer_class_alloca(T)(auto ref T ptr)
{
    return __snd_alloca(ptr, snd_mixer_class);
}

int snd_mixer_class_malloc (snd_mixer_class_t** ptr);
void snd_mixer_class_free (snd_mixer_class_t* obj);
void snd_mixer_class_copy (snd_mixer_class_t* dst, const(snd_mixer_class_t)* src);
snd_mixer_t* snd_mixer_class_get_mixer (const(snd_mixer_class_t)* class_);
snd_mixer_event_t snd_mixer_class_get_event (const(snd_mixer_class_t)* class_);
void* snd_mixer_class_get_private (const(snd_mixer_class_t)* class_);
snd_mixer_compare_t snd_mixer_class_get_compare (const(snd_mixer_class_t)* class_);
int snd_mixer_class_set_event (snd_mixer_class_t* class_, snd_mixer_event_t event);
int snd_mixer_class_set_private (snd_mixer_class_t* class_, void* private_data);
int snd_mixer_class_set_private_free (snd_mixer_class_t* class_, void function (snd_mixer_class_t*) private_free);
int snd_mixer_class_set_compare (snd_mixer_class_t* class_, snd_mixer_compare_t compare);

/**
 *  \defgroup SimpleMixer Simple Mixer Interface
 *  \ingroup Mixer
 *  The simple mixer interface.
 *  \{
 */

/* Simple mixer elements API */

/** Mixer simple element channel identifier */
enum _snd_mixer_selem_channel_id
{
    /** Unknown */
    SND_MIXER_SCHN_UNKNOWN = -1,
    /** Front left */
    SND_MIXER_SCHN_FRONT_LEFT = 0,
    /** Front right */
    SND_MIXER_SCHN_FRONT_RIGHT = 1,
    /** Rear left */
    SND_MIXER_SCHN_REAR_LEFT = 2,
    /** Rear right */
    SND_MIXER_SCHN_REAR_RIGHT = 3,
    /** Front center */
    SND_MIXER_SCHN_FRONT_CENTER = 4,
    /** Woofer */
    SND_MIXER_SCHN_WOOFER = 5,
    /** Side Left */
    SND_MIXER_SCHN_SIDE_LEFT = 6,
    /** Side Right */
    SND_MIXER_SCHN_SIDE_RIGHT = 7,
    /** Rear Center */
    SND_MIXER_SCHN_REAR_CENTER = 8,
    SND_MIXER_SCHN_LAST = 31,
    /** Mono (Front left alias) */
    SND_MIXER_SCHN_MONO = SND_MIXER_SCHN_FRONT_LEFT
}

alias snd_mixer_selem_channel_id_t = _snd_mixer_selem_channel_id;

/** Mixer simple element - register options - abstraction level */
enum snd_mixer_selem_regopt_abstract
{
    /** no abstraction - try use all universal controls from driver */
    SND_MIXER_SABSTRACT_NONE = 0,
    /** basic abstraction - Master,PCM,CD,Aux,Record-Gain etc. */
    SND_MIXER_SABSTRACT_BASIC = 1
}

/** Mixer simple element - register options */
struct snd_mixer_selem_regopt
{
    /** structure version */
    int ver;
    /** v1: abstract layer selection */
    snd_mixer_selem_regopt_abstract abstract_;
    /** v1: device name (must be NULL when playback_pcm or capture_pcm != NULL) */
    const(char)* device;
    /** v1: playback PCM connected to mixer device (NULL == none) */
    snd_pcm_t* playback_pcm;
    /** v1: capture PCM connected to mixer device (NULL == none) */
    snd_pcm_t* capture_pcm;
}

/** Mixer simple element identifier */
struct _snd_mixer_selem_id;
alias snd_mixer_selem_id_t = _snd_mixer_selem_id;

const(char)* snd_mixer_selem_channel_name (snd_mixer_selem_channel_id_t channel);

int snd_mixer_selem_register (
    snd_mixer_t* mixer,
    snd_mixer_selem_regopt* options,
    snd_mixer_class_t** classp);
void snd_mixer_selem_get_id (
    snd_mixer_elem_t* element,
    snd_mixer_selem_id_t* id);
const(char)* snd_mixer_selem_get_name (snd_mixer_elem_t* elem);
uint snd_mixer_selem_get_index (snd_mixer_elem_t* elem);
snd_mixer_elem_t* snd_mixer_find_selem (
    snd_mixer_t* mixer,
    const(snd_mixer_selem_id_t)* id);

int snd_mixer_selem_is_active (snd_mixer_elem_t* elem);
int snd_mixer_selem_is_playback_mono (snd_mixer_elem_t* elem);
int snd_mixer_selem_has_playback_channel (snd_mixer_elem_t* obj, snd_mixer_selem_channel_id_t channel);
int snd_mixer_selem_is_capture_mono (snd_mixer_elem_t* elem);
int snd_mixer_selem_has_capture_channel (snd_mixer_elem_t* obj, snd_mixer_selem_channel_id_t channel);
int snd_mixer_selem_get_capture_group (snd_mixer_elem_t* elem);
int snd_mixer_selem_has_common_volume (snd_mixer_elem_t* elem);
int snd_mixer_selem_has_playback_volume (snd_mixer_elem_t* elem);
int snd_mixer_selem_has_playback_volume_joined (snd_mixer_elem_t* elem);
int snd_mixer_selem_has_capture_volume (snd_mixer_elem_t* elem);
int snd_mixer_selem_has_capture_volume_joined (snd_mixer_elem_t* elem);
int snd_mixer_selem_has_common_switch (snd_mixer_elem_t* elem);
int snd_mixer_selem_has_playback_switch (snd_mixer_elem_t* elem);
int snd_mixer_selem_has_playback_switch_joined (snd_mixer_elem_t* elem);
int snd_mixer_selem_has_capture_switch (snd_mixer_elem_t* elem);
int snd_mixer_selem_has_capture_switch_joined (snd_mixer_elem_t* elem);
int snd_mixer_selem_has_capture_switch_exclusive (snd_mixer_elem_t* elem);

int snd_mixer_selem_ask_playback_vol_dB (snd_mixer_elem_t* elem, c_long value, c_long* dBvalue);
int snd_mixer_selem_ask_capture_vol_dB (snd_mixer_elem_t* elem, c_long value, c_long* dBvalue);
int snd_mixer_selem_ask_playback_dB_vol (snd_mixer_elem_t* elem, c_long dBvalue, int dir, c_long* value);
int snd_mixer_selem_ask_capture_dB_vol (snd_mixer_elem_t* elem, c_long dBvalue, int dir, c_long* value);
int snd_mixer_selem_get_playback_volume (snd_mixer_elem_t* elem, snd_mixer_selem_channel_id_t channel, c_long* value);
int snd_mixer_selem_get_capture_volume (snd_mixer_elem_t* elem, snd_mixer_selem_channel_id_t channel, c_long* value);
int snd_mixer_selem_get_playback_dB (snd_mixer_elem_t* elem, snd_mixer_selem_channel_id_t channel, c_long* value);
int snd_mixer_selem_get_capture_dB (snd_mixer_elem_t* elem, snd_mixer_selem_channel_id_t channel, c_long* value);
int snd_mixer_selem_get_playback_switch (snd_mixer_elem_t* elem, snd_mixer_selem_channel_id_t channel, int* value);
int snd_mixer_selem_get_capture_switch (snd_mixer_elem_t* elem, snd_mixer_selem_channel_id_t channel, int* value);
int snd_mixer_selem_set_playback_volume (snd_mixer_elem_t* elem, snd_mixer_selem_channel_id_t channel, c_long value);
int snd_mixer_selem_set_capture_volume (snd_mixer_elem_t* elem, snd_mixer_selem_channel_id_t channel, c_long value);
int snd_mixer_selem_set_playback_dB (snd_mixer_elem_t* elem, snd_mixer_selem_channel_id_t channel, c_long value, int dir);
int snd_mixer_selem_set_capture_dB (snd_mixer_elem_t* elem, snd_mixer_selem_channel_id_t channel, c_long value, int dir);
int snd_mixer_selem_set_playback_volume_all (snd_mixer_elem_t* elem, c_long value);
int snd_mixer_selem_set_capture_volume_all (snd_mixer_elem_t* elem, c_long value);
int snd_mixer_selem_set_playback_dB_all (snd_mixer_elem_t* elem, c_long value, int dir);
int snd_mixer_selem_set_capture_dB_all (snd_mixer_elem_t* elem, c_long value, int dir);
int snd_mixer_selem_set_playback_switch (snd_mixer_elem_t* elem, snd_mixer_selem_channel_id_t channel, int value);
int snd_mixer_selem_set_capture_switch (snd_mixer_elem_t* elem, snd_mixer_selem_channel_id_t channel, int value);
int snd_mixer_selem_set_playback_switch_all (snd_mixer_elem_t* elem, int value);
int snd_mixer_selem_set_capture_switch_all (snd_mixer_elem_t* elem, int value);
int snd_mixer_selem_get_playback_volume_range (
    snd_mixer_elem_t* elem,
    c_long* min,
    c_long* max);
int snd_mixer_selem_get_playback_dB_range (
    snd_mixer_elem_t* elem,
    c_long* min,
    c_long* max);
int snd_mixer_selem_set_playback_volume_range (
    snd_mixer_elem_t* elem,
    c_long min,
    c_long max);
int snd_mixer_selem_get_capture_volume_range (
    snd_mixer_elem_t* elem,
    c_long* min,
    c_long* max);
int snd_mixer_selem_get_capture_dB_range (
    snd_mixer_elem_t* elem,
    c_long* min,
    c_long* max);
int snd_mixer_selem_set_capture_volume_range (
    snd_mixer_elem_t* elem,
    c_long min,
    c_long max);

int snd_mixer_selem_is_enumerated (snd_mixer_elem_t* elem);
int snd_mixer_selem_is_enum_playback (snd_mixer_elem_t* elem);
int snd_mixer_selem_is_enum_capture (snd_mixer_elem_t* elem);
int snd_mixer_selem_get_enum_items (snd_mixer_elem_t* elem);
int snd_mixer_selem_get_enum_item_name (snd_mixer_elem_t* elem, uint idx, size_t maxlen, char* str);
int snd_mixer_selem_get_enum_item (snd_mixer_elem_t* elem, snd_mixer_selem_channel_id_t channel, uint* idxp);
int snd_mixer_selem_set_enum_item (snd_mixer_elem_t* elem, snd_mixer_selem_channel_id_t channel, uint idx);

size_t snd_mixer_selem_id_sizeof ();
/** \hideinitializer
 * \brief allocate an invalid #snd_mixer_selem_id_t using standard alloca
 * \param ptr returned pointer
 */
extern (D) auto snd_mixer_selem_id_alloca(T)(auto ref T ptr)
{
    return __snd_alloca(ptr, snd_mixer_selem_id);
}

int snd_mixer_selem_id_malloc (snd_mixer_selem_id_t** ptr);
void snd_mixer_selem_id_free (snd_mixer_selem_id_t* obj);
void snd_mixer_selem_id_copy (snd_mixer_selem_id_t* dst, const(snd_mixer_selem_id_t)* src);
const(char)* snd_mixer_selem_id_get_name (const(snd_mixer_selem_id_t)* obj);
uint snd_mixer_selem_id_get_index (const(snd_mixer_selem_id_t)* obj);
void snd_mixer_selem_id_set_name (snd_mixer_selem_id_t* obj, const(char)* val);
void snd_mixer_selem_id_set_index (snd_mixer_selem_id_t* obj, uint val);
int snd_mixer_selem_id_parse (snd_mixer_selem_id_t* dst, const(char)* str);

/** \} */

/** \} */

/* __ALSA_MIXER_H */

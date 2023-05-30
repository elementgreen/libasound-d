/**
 * \file include/seq_event.h
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

module libasound.seq_event;

extern (C) @nogc nothrow:

/**
 *  \defgroup SeqEvents Sequencer Event Definitions
 *  Sequencer Event Definitions
 *  \ingroup Sequencer
 *  \{
 */

/**
 * Sequencer event data type
 */
alias snd_seq_event_type_t = ubyte;

/** Sequencer event type */
enum snd_seq_event_type
{
    /** system status; event data type = #snd_seq_result_t */
    SND_SEQ_EVENT_SYSTEM = 0,
    /** returned result status; event data type = #snd_seq_result_t */
    SND_SEQ_EVENT_RESULT = 1,

    /** note on and off with duration; event data type = #snd_seq_ev_note_t */
    SND_SEQ_EVENT_NOTE = 5,
    /** note on; event data type = #snd_seq_ev_note_t */
    SND_SEQ_EVENT_NOTEON = 6,
    /** note off; event data type = #snd_seq_ev_note_t */
    SND_SEQ_EVENT_NOTEOFF = 7,
    /** key pressure change (aftertouch); event data type = #snd_seq_ev_note_t */
    SND_SEQ_EVENT_KEYPRESS = 8,

    /** controller; event data type = #snd_seq_ev_ctrl_t */
    SND_SEQ_EVENT_CONTROLLER = 10,
    /** program change; event data type = #snd_seq_ev_ctrl_t */
    SND_SEQ_EVENT_PGMCHANGE = 11,
    /** channel pressure; event data type = #snd_seq_ev_ctrl_t */
    SND_SEQ_EVENT_CHANPRESS = 12,
    /** pitchwheel; event data type = #snd_seq_ev_ctrl_t; data is from -8192 to 8191) */
    SND_SEQ_EVENT_PITCHBEND = 13,
    /** 14 bit controller value; event data type = #snd_seq_ev_ctrl_t */
    SND_SEQ_EVENT_CONTROL14 = 14,
    /** 14 bit NRPN;  event data type = #snd_seq_ev_ctrl_t */
    SND_SEQ_EVENT_NONREGPARAM = 15,
    /** 14 bit RPN; event data type = #snd_seq_ev_ctrl_t */
    SND_SEQ_EVENT_REGPARAM = 16,

    /** SPP with LSB and MSB values; event data type = #snd_seq_ev_ctrl_t */
    SND_SEQ_EVENT_SONGPOS = 20,
    /** Song Select with song ID number; event data type = #snd_seq_ev_ctrl_t */
    SND_SEQ_EVENT_SONGSEL = 21,
    /** midi time code quarter frame; event data type = #snd_seq_ev_ctrl_t */
    SND_SEQ_EVENT_QFRAME = 22,
    /** SMF Time Signature event; event data type = #snd_seq_ev_ctrl_t */
    SND_SEQ_EVENT_TIMESIGN = 23,
    /** SMF Key Signature event; event data type = #snd_seq_ev_ctrl_t */
    SND_SEQ_EVENT_KEYSIGN = 24,

    /** MIDI Real Time Start message; event data type = #snd_seq_ev_queue_control_t */
    SND_SEQ_EVENT_START = 30,
    /** MIDI Real Time Continue message; event data type = #snd_seq_ev_queue_control_t */
    SND_SEQ_EVENT_CONTINUE = 31,
    /** MIDI Real Time Stop message; event data type = #snd_seq_ev_queue_control_t */
    SND_SEQ_EVENT_STOP = 32,
    /** Set tick queue position; event data type = #snd_seq_ev_queue_control_t */
    SND_SEQ_EVENT_SETPOS_TICK = 33,
    /** Set real-time queue position; event data type = #snd_seq_ev_queue_control_t */
    SND_SEQ_EVENT_SETPOS_TIME = 34,
    /** (SMF) Tempo event; event data type = #snd_seq_ev_queue_control_t */
    SND_SEQ_EVENT_TEMPO = 35,
    /** MIDI Real Time Clock message; event data type = #snd_seq_ev_queue_control_t */
    SND_SEQ_EVENT_CLOCK = 36,
    /** MIDI Real Time Tick message; event data type = #snd_seq_ev_queue_control_t */
    SND_SEQ_EVENT_TICK = 37,
    /** Queue timer skew; event data type = #snd_seq_ev_queue_control_t */
    SND_SEQ_EVENT_QUEUE_SKEW = 38,
    /** Sync position changed; event data type = #snd_seq_ev_queue_control_t */
    SND_SEQ_EVENT_SYNC_POS = 39,

    /** Tune request; event data type = none */
    SND_SEQ_EVENT_TUNE_REQUEST = 40,
    /** Reset to power-on state; event data type = none */
    SND_SEQ_EVENT_RESET = 41,
    /** Active sensing event; event data type = none */
    SND_SEQ_EVENT_SENSING = 42,

    /** Echo-back event; event data type = any type */
    SND_SEQ_EVENT_ECHO = 50,
    /** OSS emulation raw event; event data type = any type */
    SND_SEQ_EVENT_OSS = 51,

    /** New client has connected; event data type = #snd_seq_addr_t */
    SND_SEQ_EVENT_CLIENT_START = 60,
    /** Client has left the system; event data type = #snd_seq_addr_t */
    SND_SEQ_EVENT_CLIENT_EXIT = 61,
    /** Client status/info has changed; event data type = #snd_seq_addr_t */
    SND_SEQ_EVENT_CLIENT_CHANGE = 62,
    /** New port was created; event data type = #snd_seq_addr_t */
    SND_SEQ_EVENT_PORT_START = 63,
    /** Port was deleted from system; event data type = #snd_seq_addr_t */
    SND_SEQ_EVENT_PORT_EXIT = 64,
    /** Port status/info has changed; event data type = #snd_seq_addr_t */
    SND_SEQ_EVENT_PORT_CHANGE = 65,

    /** Ports connected; event data type = #snd_seq_connect_t */
    SND_SEQ_EVENT_PORT_SUBSCRIBED = 66,
    /** Ports disconnected; event data type = #snd_seq_connect_t */
    SND_SEQ_EVENT_PORT_UNSUBSCRIBED = 67,

    /** user-defined event; event data type = any (fixed size) */
    SND_SEQ_EVENT_USR0 = 90,
    /** user-defined event; event data type = any (fixed size) */
    SND_SEQ_EVENT_USR1 = 91,
    /** user-defined event; event data type = any (fixed size) */
    SND_SEQ_EVENT_USR2 = 92,
    /** user-defined event; event data type = any (fixed size) */
    SND_SEQ_EVENT_USR3 = 93,
    /** user-defined event; event data type = any (fixed size) */
    SND_SEQ_EVENT_USR4 = 94,
    /** user-defined event; event data type = any (fixed size) */
    SND_SEQ_EVENT_USR5 = 95,
    /** user-defined event; event data type = any (fixed size) */
    SND_SEQ_EVENT_USR6 = 96,
    /** user-defined event; event data type = any (fixed size) */
    SND_SEQ_EVENT_USR7 = 97,
    /** user-defined event; event data type = any (fixed size) */
    SND_SEQ_EVENT_USR8 = 98,
    /** user-defined event; event data type = any (fixed size) */
    SND_SEQ_EVENT_USR9 = 99,

    /** system exclusive data (variable length);  event data type = #snd_seq_ev_ext_t */
    SND_SEQ_EVENT_SYSEX = 130,
    /** error event;  event data type = #snd_seq_ev_ext_t */
    SND_SEQ_EVENT_BOUNCE = 131,
    /** reserved for user apps;  event data type = #snd_seq_ev_ext_t */
    SND_SEQ_EVENT_USR_VAR0 = 135,
    /** reserved for user apps; event data type = #snd_seq_ev_ext_t */
    SND_SEQ_EVENT_USR_VAR1 = 136,
    /** reserved for user apps; event data type = #snd_seq_ev_ext_t */
    SND_SEQ_EVENT_USR_VAR2 = 137,
    /** reserved for user apps; event data type = #snd_seq_ev_ext_t */
    SND_SEQ_EVENT_USR_VAR3 = 138,
    /** reserved for user apps; event data type = #snd_seq_ev_ext_t */
    SND_SEQ_EVENT_USR_VAR4 = 139,

    /** NOP; ignored in any case */
    SND_SEQ_EVENT_NONE = 255
}

/** Sequencer event address */
struct snd_seq_addr
{
    ubyte client; /**< Client id */
    ubyte port; /**< Port id */
}

alias snd_seq_addr_t = snd_seq_addr;

/** Connection (subscription) between ports */
struct snd_seq_connect
{
    snd_seq_addr_t sender; /**< sender address */
    snd_seq_addr_t dest; /**< destination address */
}

alias snd_seq_connect_t = snd_seq_connect;

/** Real-time data record */
struct snd_seq_real_time
{
    uint tv_sec; /**< seconds */
    uint tv_nsec; /**< nanoseconds */
}

alias snd_seq_real_time_t = snd_seq_real_time;

/** (MIDI) Tick-time data record */
alias snd_seq_tick_time_t = uint;

/** unioned time stamp */
union snd_seq_timestamp
{
    snd_seq_tick_time_t tick; /**< tick-time */
    snd_seq_real_time time; /**< real-time */
}

alias snd_seq_timestamp_t = snd_seq_timestamp;

/**
 * Event mode flags
 *
 * NOTE: only 8 bits available!
 */
/**< timestamp in clock ticks */
/**< timestamp in real time */
/**< mask for timestamp bits */

/**< absolute timestamp */
/**< relative to current time */
/**< mask for time mode bits */

/**< fixed event size */
/**< variable event size */
/**< variable event size - user memory space */
/**< mask for event length bits */

/**< normal priority */
/**< event should be processed before others */
/**< mask for priority bits */

/** Note event */
struct snd_seq_ev_note
{
    ubyte channel; /**< channel number */
    ubyte note; /**< note */
    ubyte velocity; /**< velocity */
    ubyte off_velocity; /**< note-off velocity; only for #SND_SEQ_EVENT_NOTE */
    uint duration; /**< duration until note-off; only for #SND_SEQ_EVENT_NOTE */
}

alias snd_seq_ev_note_t = snd_seq_ev_note;

/** Controller event */
struct snd_seq_ev_ctrl
{
    ubyte channel; /**< channel number */
    ubyte[3] unused; /**< reserved */
    uint param; /**< control parameter */
    int value; /**< control value */
}

alias snd_seq_ev_ctrl_t = snd_seq_ev_ctrl;

/** generic set of bytes (12x8 bit) */
struct snd_seq_ev_raw8
{
    ubyte[12] d; /**< 8 bit value */
}

alias snd_seq_ev_raw8_t = snd_seq_ev_raw8;

/** generic set of integers (3x32 bit) */
struct snd_seq_ev_raw32
{
    uint[3] d; /**< 32 bit value */
}

alias snd_seq_ev_raw32_t = snd_seq_ev_raw32;

/** external stored data */
struct snd_seq_ev_ext
{
    align (1):

    uint len; /**< length of data */
    void* ptr; /**< pointer to data (note: can be 64-bit) */
}

/** external stored data */
alias snd_seq_ev_ext_t = snd_seq_ev_ext;

/* redefine typedef for stupid doxygen */

/** Result events */
struct snd_seq_result
{
    int event; /**< processed event type */
    int result; /**< status */
}

alias snd_seq_result_t = snd_seq_result;

/** Queue skew values */
struct snd_seq_queue_skew
{
    uint value; /**< skew value */
    uint base; /**< skew base */
}

alias snd_seq_queue_skew_t = snd_seq_queue_skew;

/** queue timer control */
struct snd_seq_ev_queue_control
{
    ubyte queue; /**< affected queue */
    ubyte[3] unused; /**< reserved */

    /**< affected value (e.g. tempo) */
    /**< time */
    /**< sync position */
    /**< queue skew */
    /**< any data */
    /**< any data */
    union _Anonymous_0
    {
        int value;
        snd_seq_timestamp_t time;
        uint position;
        snd_seq_queue_skew_t skew;
        uint[2] d32;
        ubyte[8] d8;
    }

    _Anonymous_0 param; /**< data value union */
}

alias snd_seq_ev_queue_control_t = snd_seq_ev_queue_control;

/** Sequencer event */
struct snd_seq_event
{
    snd_seq_event_type_t type; /**< event type */
    ubyte flags; /**< event flags */
    ubyte tag; /**< tag */

    ubyte queue; /**< schedule queue */
    snd_seq_timestamp_t time; /**< schedule time */

    snd_seq_addr_t source; /**< source address */
    snd_seq_addr_t dest; /**< destination address */

    /**< note information */
    /**< MIDI control information */
    /**< raw8 data */
    /**< raw32 data */
    /**< external data */
    /**< queue control */
    /**< timestamp */
    /**< address */
    /**< connect information */
    /**< operation result code */
    union _Anonymous_1
    {
        snd_seq_ev_note_t note;
        snd_seq_ev_ctrl_t control;
        snd_seq_ev_raw8_t raw8;
        snd_seq_ev_raw32_t raw32;
        snd_seq_ev_ext_t ext;
        snd_seq_ev_queue_control_t queue;
        snd_seq_timestamp_t time;
        snd_seq_addr_t addr;
        snd_seq_connect_t connect;
        snd_seq_result_t result;
    }

    _Anonymous_1 data; /**< event data... */
}

alias snd_seq_event_t = snd_seq_event;
enum SND_SEQ_TIME_STAMP_TICK = 0 << 0;
enum SND_SEQ_TIME_STAMP_REAL = 1 << 0;
enum SND_SEQ_TIME_STAMP_MASK = 1 << 0;
enum SND_SEQ_TIME_MODE_ABS = 0 << 1;
enum SND_SEQ_TIME_MODE_REL = 1 << 1;
enum SND_SEQ_TIME_MODE_MASK = 1 << 1;
enum SND_SEQ_EVENT_LENGTH_FIXED = 0 << 2;
enum SND_SEQ_EVENT_LENGTH_VARIABLE = 1 << 2;
enum SND_SEQ_EVENT_LENGTH_VARUSR = 2 << 2;
enum SND_SEQ_EVENT_LENGTH_MASK = 3 << 2;
enum SND_SEQ_PRIORITY_NORMAL = 0 << 4;
enum SND_SEQ_PRIORITY_HIGH = 1 << 4;
enum SND_SEQ_PRIORITY_MASK = 1 << 4;

/** \} */

/* __ALSA_SEQ_EVENT_H */

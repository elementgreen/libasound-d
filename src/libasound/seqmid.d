/**
 * \file include/seqmid.h
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

module libasound.seqmid;

import core.stdc.string;

import libasound.seq;
import libasound.seq_event;

extern (C) @nogc nothrow:

/**
 *  \defgroup SeqMiddle Sequencer Middle Level Interface
 *  Sequencer Middle Level Interface
 *  \ingroup Sequencer
 *  \{
 */

/**
 * \brief initialize event record
 * \param ev event record pointer
 *
 * This macro clears the given event record pointer to the default status.
 */
extern (D) auto snd_seq_ev_clear(T)(auto ref T ev)
{
    return memset(ev, 0, snd_seq_event_t.sizeof);
}

/**
 * \brief set the tag for given event
 * \param ev event record
 * \param t event tag
 *
 * This macro sets the tag to the given event record.
 */

/**
 * \brief set the explicit destination
 * \param ev event record
 * \param c destination client id
 * \param p destination port id
 *
 * This macro sets the client and port id numbers to the given event record.
 *
 * \sa snd_seq_ev_set_subs()
 */

/**
 * \brief set broadcasting to subscribers
 * \param ev event record
 *
 * This macro sets the destination as the subscribers.
 *
 * \sa snd_seq_ev_set_dest()
 */

/**
 * \brief set broadcasting to all clients/ports
 * \param ev event record
 *
 * This macro sets the destination as the broadcasting.
 *
 * \sa snd_seq_ev_set_dest()
 */

/**
 * \brief set the source port
 * \param ev event record
 * \param p source port id
 *
 * This macro sets the source port id number.
 */

/**
 * \brief set direct passing mode (without queued)
 * \param ev event instance
 *
 * This macro sets the event to the direct passing mode
 * to be delivered immediately without queueing.
 *
 * \sa snd_seq_ev_schedule_tick(), snd_seq_ev_schedule_real()
 */

/**
 * \brief set tick-scheduling mode on queue
 * \param ev event instance
 * \param q queue id to schedule
 * \param relative relative time-stamp if non-zero
 * \param ttick tick time-stamp to be delivered
 *
 * This macro sets the scheduling of the event in the
 * MIDI tick mode.
 *
 * \sa snd_seq_ev_schedule_real(), snd_seq_ev_set_direct()
 */

/**
 * \brief set real-time-scheduling mode on queue
 * \param ev event instance
 * \param q queue id to schedule
 * \param relative relative time-stamp if non-zero
 * \param rtime time-stamp to be delivered
 *
 * This macro sets the scheduling of the event in the
 * realtime mode.
 *
 * \sa snd_seq_ev_schedule_tick(), snd_seq_ev_set_direct()
 */

/**
 * \brief set event priority
 * \param ev event instance
 * \param high_prior 1 for high priority mode
 */

/**
 * \brief set fixed data
 * \param ev event instance
 *
 * Sets the event length mode as fixed size.
 *
 * \sa snd_seq_ev_set_variable(), snd_seq_ev_set_varusr()
 */

/**
 * \brief set variable data
 * \param ev event instance
 * \param datalen length of the external data
 * \param dataptr pointer of the external data
 *
 * Sets the event length mode as variable length and stores the data.
 *
 * \sa snd_seq_ev_set_fixed(), snd_seq_ev_set_varusr()
 */

/**
 * \brief set varusr data
 * \param ev event instance
 * \param datalen length of the external data
 * \param dataptr pointer of the external data
 *
 * Sets the event length mode as variable user-space data and stores the data.
 *
 * \sa snd_seq_ev_set_fixed(), snd_seq_ev_set_variable()
 */

/**
 * \brief set queue controls
 * \param ev event record
 * \param typ event type
 * \param q queue id
 * \param val control value
 */

/**
 * \brief set the start queue event
 * \param ev event record
 * \param q queue id to start
 *
 * \sa snd_seq_ev_set_queue_stop(), snd_seq_ev_set_queue_continue()
 */
extern (D) auto snd_seq_ev_set_queue_start(T0, T1)(auto ref T0 ev, auto ref T1 q)
{
    return snd_seq_ev_set_queue_control(ev, snd_seq_event_type.SND_SEQ_EVENT_START, q, 0);
}

/**
 * \brief set the stop queue event
 * \param ev event record
 * \param q queue id to stop
 *
 * \sa snd_seq_ev_set_queue_start(), snd_seq_ev_set_queue_continue()
 */
extern (D) auto snd_seq_ev_set_queue_stop(T0, T1)(auto ref T0 ev, auto ref T1 q)
{
    return snd_seq_ev_set_queue_control(ev, snd_seq_event_type.SND_SEQ_EVENT_STOP, q, 0);
}

/**
 * \brief set the stop queue event
 * \param ev event record
 * \param q queue id to continue
 *
 * \sa snd_seq_ev_set_queue_start(), snd_seq_ev_set_queue_stop()
 */
extern (D) auto snd_seq_ev_set_queue_continue(T0, T1)(auto ref T0 ev, auto ref T1 q)
{
    return snd_seq_ev_set_queue_control(ev, snd_seq_event_type.SND_SEQ_EVENT_CONTINUE, q, 0);
}

/**
 * \brief set the stop queue event
 * \param ev event record
 * \param q queue id to change tempo
 * \param val the new tempo value
 */
extern (D) auto snd_seq_ev_set_queue_tempo(T0, T1, T2)(auto ref T0 ev, auto ref T1 q, auto ref T2 val)
{
    return snd_seq_ev_set_queue_control(ev, snd_seq_event_type.SND_SEQ_EVENT_TEMPO, q, val);
}

/**
 * \brief set the real-time position of a queue
 * \param ev event record
 * \param q queue id to change tempo
 * \param rtime the new real-time pointer
 */

/**
 * \brief set the tick-time position of a queue
 * \param ev event record
 * \param q queue id to change tempo
 * \param ttime the new tick-time
 */

/* set and send a queue control event */
int snd_seq_control_queue (snd_seq_t* seq, int q, int type, int value, snd_seq_event_t* ev);

/**
 * \brief start the specified queue
 * \param seq sequencer handle
 * \param q queue id to start
 * \param ev optional event record (see #snd_seq_control_queue)
 */
extern (D) auto snd_seq_start_queue(T0, T1, T2)(auto ref T0 seq, auto ref T1 q, auto ref T2 ev)
{
    return snd_seq_control_queue(seq, q, snd_seq_event_type.SND_SEQ_EVENT_START, 0, ev);
}

/**
 * \brief stop the specified queue
 * \param seq sequencer handle
 * \param q queue id to stop
 * \param ev optional event record (see #snd_seq_control_queue)
 */
extern (D) auto snd_seq_stop_queue(T0, T1, T2)(auto ref T0 seq, auto ref T1 q, auto ref T2 ev)
{
    return snd_seq_control_queue(seq, q, snd_seq_event_type.SND_SEQ_EVENT_STOP, 0, ev);
}

/**
 * \brief continue the specified queue
 * \param seq sequencer handle
 * \param q queue id to continue
 * \param ev optional event record (see #snd_seq_control_queue)
 */
extern (D) auto snd_seq_continue_queue(T0, T1, T2)(auto ref T0 seq, auto ref T1 q, auto ref T2 ev)
{
    return snd_seq_control_queue(seq, q, snd_seq_event_type.SND_SEQ_EVENT_CONTINUE, 0, ev);
}

/**
 * \brief change the tempo of the specified queue
 * \param seq sequencer handle
 * \param q queue id
 * \param tempo the new tempo value
 * \param ev optional event record (see #snd_seq_control_queue)
 */
extern (D) auto snd_seq_change_queue_tempo(T0, T1, T2, T3)(auto ref T0 seq, auto ref T1 q, auto ref T2 tempo, auto ref T3 ev)
{
    return snd_seq_control_queue(seq, q, snd_seq_event_type.SND_SEQ_EVENT_TEMPO, tempo, ev);
}

/* create a port - simple version - return the port number */
int snd_seq_create_simple_port (
    snd_seq_t* seq,
    const(char)* name,
    uint caps,
    uint type);
/* delete the port */
int snd_seq_delete_simple_port (snd_seq_t* seq, int port);

/* simple subscription between this port and another port
   (w/o exclusive & time conversion)
   */
int snd_seq_connect_from (snd_seq_t* seq, int my_port, int src_client, int src_port);
int snd_seq_connect_to (snd_seq_t* seq, int my_port, int dest_client, int dest_port);
int snd_seq_disconnect_from (snd_seq_t* seq, int my_port, int src_client, int src_port);
int snd_seq_disconnect_to (snd_seq_t* seq, int my_port, int dest_client, int dest_port);

/*
 * set client information
 */
int snd_seq_set_client_name (snd_seq_t* seq, const(char)* name);
int snd_seq_set_client_event_filter (snd_seq_t* seq, int event_type);
int snd_seq_set_client_pool_output (snd_seq_t* seq, size_t size);
int snd_seq_set_client_pool_output_room (snd_seq_t* seq, size_t size);
int snd_seq_set_client_pool_input (snd_seq_t* seq, size_t size);
/* sync output queue */
int snd_seq_sync_output_queue (snd_seq_t* seq);

/*
 * parse the given string and get the sequencer address
 */
int snd_seq_parse_address (snd_seq_t* seq, snd_seq_addr_t* addr, const(char)* str);

/*
 * reset client input/output pool
 */
int snd_seq_reset_pool_output (snd_seq_t* seq);
int snd_seq_reset_pool_input (snd_seq_t* seq);

/**
 * \brief set note event
 * \param ev event record
 * \param ch channel number
 * \param key note key
 * \param vel velocity
 * \param dur duration (in tick or msec)
 */

/**
 * \brief set note-on event
 * \param ev event record
 * \param ch channel number
 * \param key note key
 * \param vel velocity
 */

/**
 * \brief set note-off event
 * \param ev event record
 * \param ch channel number
 * \param key note key
 * \param vel velocity
 */

/**
 * \brief set key-pressure event
 * \param ev event record
 * \param ch channel number
 * \param key note key
 * \param vel velocity
 */

/**
 * \brief set MIDI controller event
 * \param ev event record
 * \param ch channel number
 * \param cc controller number
 * \param val control value
 */

/**
 * \brief set program change event
 * \param ev event record
 * \param ch channel number
 * \param val program number
 */

/**
 * \brief set pitch-bend event
 * \param ev event record
 * \param ch channel number
 * \param val pitch bend; zero centered from -8192 to 8191
 */

/**
 * \brief set channel pressure event
 * \param ev event record
 * \param ch channel number
 * \param val channel pressure value
 */

/**
 * \brief set sysex event
 * \param ev event record
 * \param datalen length of sysex data
 * \param dataptr sysex data pointer
 *
 * the sysex data must contain the start byte 0xf0 and the end byte 0xf7.
 */

/** \} */

/* __ALSA_SEQMID_H */

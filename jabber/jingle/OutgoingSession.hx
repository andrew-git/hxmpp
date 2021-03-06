/*
 *	This file is part of HXMPP.
 *	Copyright (c)2009 http://www.disktree.net
 *	
 *	HXMPP is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  HXMPP is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *	See the GNU Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with HXMPP. If not, see <http://www.gnu.org/licenses/>.
*/
package jabber.jingle;

import jabber.jingle.io.Transport;
import jabber.util.Base64;
import xmpp.IQ;
import xmpp.IQType;

/**
	Abstract base for outgoing jingle sessions
*/
class OutgoingSession<T:Transport> extends Session<T> {
	
	/** Transports we offer */
	public var transports(default,null) : Array<T>;
	
	function new( stream : jabber.Stream, entity : String, contentName : String, xmlns : String ) {
		super( stream, xmlns );
		this.entity = entity;
		this.contentName = contentName;
		this.initiator = stream.jid.toString();
		transports = new Array();
	}
	
	public function init() {
		sendSessionInit();
	}
	
	function sendSessionInit( ?description : Xml ) {
		if( transports.length == 0 )
			throw "no transports registered";
		sid = Base64.random( 16 );
		var iq = new IQ( IQType.set, null, entity );
		var j = new xmpp.Jingle( xmpp.jingle.Action.session_initiate, stream.jid.toString(), sid, entity );
		var content = new xmpp.jingle.Content( xmpp.jingle.Creator.initiator, contentName );
//		content.senders = xmpp.jingle.Senders.both; //TODO
		if( description != null ) content.other.push( description );
		content.other.push( createTransportXml() );
		j.content.push( content );
		iq.x = j;
		addSessionCollector();
		iq.from = stream.jid.toString();
		stream.sendIQ( iq, handleSessionInitResponse );
	}
	
	function handleSessionInitResponse( iq : IQ ) {
		switch( iq.type ) {
		case result :
			handleSessionInitResult();
		case error :
			//onError( new jabber.XMPPError( iq ) );
			var err = iq.errors[0];
			onFail( err.condition );
			//onFail( new jabber.XMPPError( iq ) );
			cleanup();
		default :
		}
	}
	
	function handleSessionInitResult() {
		// abstract
	}
	
	function createTransportXml() : Xml {
		var x = xmpp.IQ.createQueryXml( xmlns, 'transport' );
		for( t in transports ) {
			var cx = createCandidateXml( t );
			if( cx != null ) {
				x.addChild( cx );
			}
		}
		return x;
	}
	
	function createCandidateXml( t : Transport ) : Xml {
		return t.toXml();
	}
	
}

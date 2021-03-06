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
import jabber.stream.PacketCollector;

/**
	Abstract base for jingle session listeners.

	T:Transport The kind of transport this class uses
	R:SessionResponder<T> The kind of responder this class generates

*/
class SessionListener<T:Transport,R:SessionResponder<T>> {
	
	public var stream(default,null) : jabber.Stream;
	
	/** The handler/callback a responder get passed to */
	public var handler(default,setHandler) : R->Void;
	
	/** The namespace of this jingle implementation */
	public var xmlns(default,null) : String;
	
	var c : PacketCollector;
	
	function new( stream : jabber.Stream, handler : R->Void, xmlns : String ) {
		if( !stream.features.add( xmlns ) )
			throw "jingle listener already added ["+xmlns+"]";
		this.stream = stream;
		this.handler = handler;
		this.xmlns = xmlns;
	}
	
	public function dispose() {
		stream.features.remove( xmlns );
		setHandler( null );
	}
	
	function setHandler( h : R->Void ) : R->Void {
		if( h == null ) {
			if( c != null ) {
				stream.removeCollector( c );
				c = null;
			}
		} else if( c == null )
			c = stream.collect( [cast new xmpp.filter.JingleFilter( xmlns )], handleRequest, true );
		return handler = h;
	}
	
	function handleRequest( iq : xmpp.IQ ) {
		if( handler == null )
			return;
		var r = createResponder();
		if( r.handleRequest( iq ) ) {
			handler( r );
		}
	}
	
	function createResponder() : R { // override me
		#if JABBER_DEBUG
		return throw 'abstract method';
		#else
		return null;
		#end
	}
	
}

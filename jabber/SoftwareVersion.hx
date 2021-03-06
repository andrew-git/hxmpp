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
package jabber;

/**
	<a href="http://www.xmpp.org/extensions/xep-0092.html">XEP 0092 - Software Version</a>
*/
class SoftwareVersion {
	
	public dynamic function onLoad( jid : String, sv : xmpp.SoftwareVersion ) {}
	public dynamic function onError( e : jabber.XMPPError ) {}
	
	public var stream(default,null) : Stream;
	
	public function new( stream : Stream ) {
		this.stream = stream;
	}
	
	/**
		Requests the software version of the given entity.
	*/
	public function load( jid : String ) {
		var iq = new xmpp.IQ( xmpp.IQType.get, null, jid );
		iq.x = new xmpp.SoftwareVersion();
		var me = this;
		stream.sendIQ( iq, function( r ) {
			switch( r.type ) {
			case result : me.onLoad( jid, xmpp.SoftwareVersion.parse( r.x.toXml() ) );
			case error : me.onError( new jabber.XMPPError( r ) );
			default : //
			}
		} );
	}
	
}

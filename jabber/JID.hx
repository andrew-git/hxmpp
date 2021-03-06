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
	An XMPP address (JID).
	
	A JID is made up of a node (generally a username), a domain, and a resource.
	<pre>
jid             = [ node "@" ] domain [ "/" resource ]
domain          = fqdn / address-literal
fqdn            = (sub-domain 1*("." sub-domain))
sub-domain      = (internationalized domain label)
address-literal = IPv4address / IPv6address
	</pre>

	Each allowable portion of a JID (node, domain, and resource) must not be more than 1023 bytes in length,
	resulting in a maximum total size (including the '@' and '/' separators) of 3071 bytes.
*/
class JID {
	
	/***/
	public var node : String;
	
	/***/
	public var domain : String;
	
	/***/
	public var resource : String;
	
	/** JID without resource */
	public var bare(getBare,null) : String;
	
	/** Just a shortcut for toString()  */
	public var s(toString,null) : String;
	
	public function new( t : String ) {
		if( t != null ) {
			if( !JIDUtil.isValid( t ) )
				throw "invalid JID ["+t+"]"; 
			this.node = JIDUtil.node( t );
			this.domain = JIDUtil.domain( t );
			this.resource = JIDUtil.resource( t );
		}
	}
	
	function getBare() : String {
		return ( node == null || domain == null ) ? null : node+"@"+domain;
	}
	
	@:keep public function toString() : String {
		var j = getBare();
		return ( j == null ) ? null : ( resource == null ) ? j : j+"/"+resource;
	}
	
}

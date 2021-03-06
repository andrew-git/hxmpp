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
package xmpp.pubsub;

class Item {
	
	public var id : String;
	public var payload : Xml;
	/* The node attribute is allowed (required!) in pubsub-event namespace only!? */
	//public var node : String;
	
	public function new( ?id : String, ?payload : Xml/*, ?node : String*/ ) {
		this.id = id;
		this.payload = payload;
		//this.node = node;
	}
	
	public function toXml() : Xml {
		var x = Xml.createElement( "item" );
		if( id != null ) x.set( "id", id );
		//if( node != null ) x.set( "node", node );
		if( payload != null ) x.addChild( payload );
		return x;
	}
	
	public static function parse( x : Xml ) : Item {
		var e = x.firstElement();
		if( e == null ) e = x.firstChild();
		return new Item( x.get( "id" ), e/*, x.get( "node" )*/ );
	}
	
}

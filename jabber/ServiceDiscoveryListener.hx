package jabber;

import jabber.stream.PacketCollector;
import xmpp.filter.IQFilter;

/**
	Listens/Answers incoming service discovery requests.
	<a href="http://www.xmpp.org/extensions/xep-0030.html">XEP 30 - ServiceDiscovery</a>
*/
class ServiceDiscoveryListener {
	
	//public static var defaultIdentity = { category : "client", name : "HXMPP", type : "pc" };
	
	public var stream(default,null) : Stream;
	public var identities : Array<xmpp.disco.Identity>; //TODO!!!!!
	
	public function new( stream : Stream,  ?identities : Array<xmpp.disco.Identity> ) {
		if( !stream.features.add( xmpp.disco.Info.XMLNS ) || !stream.features.add( xmpp.disco.Items.XMLNS ) )
			throw "Service Discovery listener stream feature already added";
		this.stream = stream;
		this.identities = identities;
		stream.addCollector( new PacketCollector( [cast new IQFilter( xmpp.disco.Info.XMLNS, null, xmpp.IQType.get )], handleInfoQuery, true ) );
		stream.addCollector( new PacketCollector( [cast new IQFilter( xmpp.disco.Items.XMLNS, null, xmpp.IQType.get )], handleItemsQuery, true ) );
	}
	
	/*
	function setIdentity( i : xmpp.disco.Identity ) : xmpp.disco.Identity {
		return identity = ( i == null ) ? defaultIdentity :  i;
	}
	*/

	function handleInfoQuery( iq : xmpp.IQ ) {
		// return identities and stream features
		var r = new xmpp.IQ( xmpp.IQType.result, iq.id, iq.from, stream.jidstr );
		r.x = new xmpp.disco.Info( identities, Lambda.array( stream.features ) );
		stream.sendData( r.toString() );
	}
	
	function handleItemsQuery( iq : xmpp.IQ ) {
		if( Reflect.hasField( stream, "items" ) ) { // component stream
			// return local stream items
			var r = new xmpp.IQ( xmpp.IQType.result, iq.id, iq.from, Reflect.field( stream, "serviceName" ) );
			r.x = Reflect.field( stream, "items" );
			stream.sendPacket( r );
		} else { // client streams do not have items, return a feature-not-implemented
			var r = new xmpp.IQ( xmpp.IQType.error, iq.id, iq.from );
			r.errors.push( new xmpp.Error( xmpp.ErrorType.cancel, -1, xmpp.ErrorCondition.FEATURE_NOT_IMPLEMENTED ) );
			stream.sendPacket( r );
		}
	}
	
}

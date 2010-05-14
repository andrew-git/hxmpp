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
package jabber.sasl;

class AnonymousMechanism {
	
	static function __init__() {
		ID = "ANONYMOUS";
	}
	
	public static var ID(default,null) : String;
	
	public var id(default,null) : String;
	
	/**
		Some servers may send a challenge to gather more information such as email address.<br/>
		Return any string value.
	*/
	public var challengeResponse : String;
	
	public function new( challengeResponse = "any" ) {
		id = ID;
		this.challengeResponse = challengeResponse;
	}
	
	public function createAuthenticationText( user : String, host : String, pw : String ) : String {
		return null; // Nothing to send in the <auth> body.
	}
	
	public function createChallengeResponse( chl : String ) : String {
		return challengeResponse; // not required
	}
	
}
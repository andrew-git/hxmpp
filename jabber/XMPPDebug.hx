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

#if XMPP_DEBUG

#if neko
import neko.Lib;
#elseif php
import php.Lib;
#elseif cpp
import cpp.Lib;
#elseif nodejs
import js.Lib;
#elseif (flash&&!air)
import flash.external.ExternalInterface;
#end

/**
	Utility for debugging XMPP transfer.<br/>
	Set the haXe compiler flag: -D XMPP_DEBUG to activate it.<br/>
	Displayed XMPP transfer gets relayed to the default debug console on browser targets,
	color highlighted on terminal targets.
*/
class XMPPDebug {
	
	#if (flash||js)
	
	static function __init__() {
		#if air
		useConsole = false;
		#else
		#if flash
		useConsole = ( ExternalInterface.available &&
					   ExternalInterface.call( "console.error.toString" ) != null );
		#elseif (js&&!nodejs)
		try useConsole = untyped console != null && console.error != null catch( e : Dynamic ) {
			useConsole = false;
		}
		#end
		#end
	}
	
	#end // (flash||js)
	
	/**
		Default incoming XMPP debug relay.
	*/
	public static inline function inc( t : String ) {
		print( t, false, "log" );
	}
	
	/**
		Default outgoing XMPP debug relay.
	*/
	public static inline function out( t : String ) {
		print( t, true, "log" );
	}
	
	public static inline function print( t : String, out : Bool, level : String = "log" ) {
		#if (neko||cpp||php||nodejs)
		_print( t, out ? color_out : color_inc );
		#elseif (flash||js)
		_print( t, out, level );
		#end
	}
	
	
	#if (neko||cpp||php||nodejs)

	public static var color_out = 36;
	public static var color_inc = 33;
	
	public static function _print( t : String, color : Int ) {
		if( color == null ) {
			Lib.print( t );
			return;
		}
		var b = new StringBuf();
		b.add( "\033[" );
		b.add( color );
		b.add( "m" );
		b.add( t );
		b.add( "\033[" );
		b.add( "m\n" );
		Lib.print( b.toString() );
	}
	
	
	#elseif (flash||js)
	
	/** Indicates if the XMPP transfer should get printed to the browsers debug console */
	public static var useConsole : Bool;
	
	public static function _print( t : String, out : Bool = true, level : String = "log" ) {
		var dir = out ? "=>" : "<=";
		#if air
		haxe.Log.trace( t, { className : "", methodName : "", fileName : "XMPP"+dir, lineNumber : t.length, customParams : [] } );
		#else
		if( useConsole ) {
			#if flash
			ExternalInterface.call( "console."+level, dir+t );
			#else
			untyped console[level]( dir+t );
			#end
		} else {
			//haxe.Log.trace( t, { className : "", methodName : "", fileName : dir, lineNumber : 0, customParams : [] } );
			haxe.Log.trace( t, { className : "", methodName : "", fileName : "XMPP"+dir, lineNumber : t.length, customParams : [] } );
		}
		#end
	}
	
	#end // (flash||js)
	
}

#end // XMPP_DEBUG

/* JabberFLash - Jabber API for Macromedia Flash
 * Copyright 1999-2001  Yannick Connan <yannick@dazzlebox.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

Jabber.Presence = function (jid,status,priority,show){
	// changed 'this.jid = null' to 'this._jid=null'
	// this originally used 'Jabber.private_exist(var)' but this class doesn't necessarily have a superclass. 
	this.private_exist(jid) ? this._jid = jid : this._jid = null;
	this.private_exist(status) ? this._status = status : this._status = "Online";
	this.private_exist(priority) ? this._priority = Number(priority) : this._priority = 0;
	this.private_exist(show) ? this._show = show : this._show = null;
	if (this.private_exist(jid)) {
		var temp_string = this._jid.split("/");
		this._userid = temp_string[0];
		this._resource = temp_string[1];
	}
}
Jabber.Presence.prototype.private_exist = function (value) {
	var temp = new Boolean();
	if (typeof(value) != "undefined" && value != null && value != "null" ) {
		temp = true;
	} else {
		temp = false;
	}
	return temp;
}

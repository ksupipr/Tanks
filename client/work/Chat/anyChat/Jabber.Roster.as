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

Jabber.Roster = function(session) {
	this._session = session;
	this._items = {};
	
}

Jabber.Roster.prototype.addItem = function(jid,nick) {
	var temp_item = new Jabber.RosterItem(this,jid,nick);
	this._items[temp_item._userid] = temp_item;
	return this._items[temp_item._userid];
}

Jabber.Roster.prototype.findUserID = function(userid) {
	if (this._session.private_exist(this._items[userid])) {
		return this._items[userid];
	} else {
		var find_i;
		var ok = new Boolean(false);
		for (find_i in this._items) {
			if (this.items[find_i]._jid == userid) {
				ok = true;
				return this.items[find_i];
				break;
			}
		}
		if (ok != true) {
			return "nil";
		}
	}
}

Jabber.Roster.prototype.findNick = function(nick) {
	var find_i;
	var ok = new Boolean(false);
	for (find_i in this._items) {
		if (this.items[find_i]._nickname == nick) {
			ok = true;
			return this._items[find_i];
			break;
		}
	}
	if (! ok) {
		return "nil";
	}
}
//returns all nicknames as an array
Jabber.Roster.prototype.getNicks = function() {
	var find_i;
	var temp = new Array();
	for (find_i in this._items) {
		temp.push(this._items[find_i]._nickname);
		trace("for find:"+temp.toString());
	}
	return temp;
}


Jabber.Roster.prototype.clear = function () {
	var i;
	for (i in this._items) {
		delete this._items[i];
	}
}

Jabber.Roster.prototype.remove = function (jid) {
		delete this._items[jid];
}

Jabber.Roster.prototype.fetch = function() {
	var temp_iq = new Jabber.IQ("jabber:iq:roster","get",null,null,"do_roster_"+random(10000),this.onRosterFetch);
	this._session.sendIQ(temp_iq);
}

Jabber.Roster.prototype.onRosterFetch = function(object_iq) {
	var object_iq;
	this.onRosterStart();
	var i;
	for (i in object_iq._fields) {
		var obj = object_iq._fields[i];
		if (obj.nodeName.toLowerCase() == "item") {
			var temp_groups = new Array();
			var i_i;
			var temp_child = obj.childNodes;
			for (i_i in temp_child) {
				temp_groups.push(temp_child[i_i].firstChild.nodeValue);
			}
			var temp_item = this._roster.addItem(obj.attributes.jid,obj.attributes.name);
			temp_item._subscription = obj.attributes.subscription;
			temp_item._ask = obj.attributes.ask;
			temp_item._groups = temp_groups;
			this.onRosterItem(temp_item);
		}
	}
	this.onRosterEnd();
}
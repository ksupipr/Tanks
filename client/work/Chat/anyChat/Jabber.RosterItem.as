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

Jabber.RosterItem = function(roster,jid,nickname,subscription,ask,groups) {
	this._jid = new String(jid);
	this._roster = roster;
	this._roster._session.private_exist(this._groups) ? this._groups = groups : this._groups = new Array();
	this._subscription = new String(subscription);
	this._ask = new String(ask);
	var temp_userid = this._jid.split("/");
	this._userid = temp_userid[0];
	if (this._roster._session.private_exist(nickname)) {
		this._nickname = new String(nickname);
	} else {
		var temp_nickname = this._jid.split("@");
		this._nickname = temp_nickname[0];
	}

	
}

Jabber.RosterItem.prototype.addGroup = function(group) {
	return this._groups.push(group);
}

Jabber.RosterItem.prototype.deleteGroup = function(group) {
	var i;
	for (i in this._groups) {
		if (this._group[i] == group) {
			this._groups.splice(i,1);
		}
	}
}

Jabber.RosterItem.prototype.inGroup = function(group) {
	var ok = new Boolean(false);
	var i;
	for (i in this._groups) {
		if (this._group[i] == group) {
			ok = new Boolean(true);
		}
	}
	return ok;
}

Jabber.RosterItem.prototype.update = function() {
	var temp_xml = new XML();
	temp_xml.nodeName = "item";
	temp_xml.attributes.name = this._nickname;
	temp_xml.attributes.jid = this._jid;
	if (this._roster._session.private_exist(this._subscription)) {
		temp_xml.attributes.subscription = this._subscription;
	}
	if (this._roster._session.private_exist(this._ask)) {
		temp_xml.attributes.ask = this._ask;
	}
	if (this._groups.length > 0) {
		var g_i;
		for (g_i in this._groups) {
			temp_xml.appendChild(this._roster._session.private_simpleNode("group",this._groups[g_i]));
		}
	}
	var temp_iq = new Jabber.IQ("jabber:iq:roster","set",null,null,"set_roster_"+random(10000));
	temp_iq._fields.push(temp_xml);
	this._roster._session.sendIQ(temp_iq);
}

Jabber.RosterItem.prototype.remove = function() {
	var temp_xml = new XML();
	temp_xml.nodeName = "item";
	temp_xml.attributes.name = this._nickname;
	temp_xml.attributes.jid = this._jid;
	temp_xml.attributes.subscription = "remove";
	var temp_iq = new Jabber.IQ("jabber:iq:roster","set",null,null,"set_roster_"+random(10000));
	temp_iq._fields.push(temp_xml);
	this._roster._session.sendIQ(temp_iq);
}
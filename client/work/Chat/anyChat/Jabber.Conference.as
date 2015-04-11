/* JabberFLash - Jabber API for Macromedia Flash
 * Copyright 1999-2001  Chris Hill <chill@collective3.com>
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

Jabber.Conference = function () {
	//constructor function to create a room listing on a conference server
	this._rooms = new Array();
	trace("temp_xml:"+temp_xml.toString());
}

Jabber.Conference.prototype.parseXML = function(temp_xml){
	//this function pareses the jabber:iq:browse query on a conference server
	for(var i=0;i<temp_xml.length;i++){
		if(this.exist(temp_xml[i].attributes.jid)){		
			var r_jid = temp_xml[i].attributes.jid;
			var r_name = temp_xml[i].attributes.name;
			trace("r_jid:"+r_jid);
			this._rooms.push(new Jabber.Conference.RoomList(r_jid,r_name));
		}
	}
}

Jabber.Conference.RoomList = function (jid,name){
	//this constructor is for an item in the room listings returned from a jabber:iq:browse query on a conference server
	this._jid = jid;
	this._roomname = name;
	var tempString = this._jid.split("@");
	this._room = tempString[0];
	//split up the name to find out how many people are in the room, syntax 'roomname (num)'
	tempString = this._roomname.split("(");
	this._roomname = tempString[0];
	tempString = tempString[tempString.length-1].split(")");
	this._people = tempString[0];
}

Jabber.Conference.prototype.exist = function (value) {
	var temp = new Boolean();
	if (typeof(value) != "undefined" && value != null && value != "null" ) {
		temp = true
	} else {
		temp = false;
	}
	return temp;
}



Jabber.Room = function (parent,nickname,name,desc,persistent,restricted,anonymous){
	//creates a chat room object
	this._parent = parent;
	this.exist(nickname) ? this._nickname = new String(nickname) : this._nickname = null;
	this.exist(name) ? this._name = new String(name) : this._name = null;
	this.exist(desc) ? this._desc = new String(desc) : this._desc = null;
	this.exist(persistent) ? this._persistent = new String(persistent) : this._persistent = null;
	this.exist(restricted) ? this._restricted = new String(restricted) : this._restricted = null;
	this.exist(anonymous) ? this._anonymous = new String(anonymous) : this._anonymous = null;
	this._exists = false;
}

Jabber.Room.prototype.doRoomXML = function() {
	// ok, so first you send presence, once you've recieved a reply
	// you iq-get then iq-set
	var temp_xml = new XML();
	temp_xml.nodeName = "IQ";
	temp_xml.attributes.type = "set";
	temp_xml.appendChild(this.simpleAttribNode("create","xmlns","jabber:iq:conference"));
	temp_xml.firstChild.appendChild(this.simpleTextNode("metainfo",null));
	trace("creating XML");
	return temp_xml;
}
Jabber.Room.prototype.simpleAttribNode = function (name,attrib,value) {
	var temp_xml = new XML();
	temp_xml.nodeName = name;
	if (this.exist(attrib)) {
		temp_xml.appendChild(temp_xml.createTextNode(""));
	}
	temp_xml.attributes[attrib] = value;
	return temp_xml;
}
Jabber.Room.prototype.simpleTextNode = function (name,value) {
	var temp_xml = new XML();
	temp_xml.nodeName = name;
	if (this.exist(value)) {
		temp_xml.appendChild(temp_xml.createTextNode(value));
	}
	return temp_xml;
}
	






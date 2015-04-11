/* JabberFLash - Jabber API for Macromedia Flash
 * Copyright 2002  Yannick Connan <yannick@dazzlebox.com>
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

Jabber.Message = function(to,from,body,type,subject) {
	this.exist(to) ? this._to = new String(to) : this._to = null;
	this.exist(from) ? this._from = new String(from) : this._from = null;
	this.exist(body) ? this._body = new String(body) : this._body = null;
	this.exist(type) ? this._type = new String(type) : this._type = null;
	this.exist(subject) ? this._subject = new String(subject) : this._subject = null;
	this._x = new Array();
}
Jabber.Message.prototype.createThread = function() {
	this._thread = "message_thread_"+this._to + random(100000000);
	return this._thread;
}
Jabber.Message.prototype.doXML = function() {
	var temp_xml = new XML();
	temp_xml.nodeName = "message";
	this.exist(this._to) ? temp_xml.attributes.to = this._to : null;
	this.exist(this._from) ? temp_xml.attributes.from = this._from : null;
	this.exist(this._type) ? temp_xml.attributes.type = this._type : null;
	this.exist(this._id) ? temp_xml.attributes.id = this._id : null;
	this.exist(this._body) ? temp_xml.appendChild(this.simpleNode("body",this._body)) : null;
	this.exist(this._subject) ? temp_xml.appendChild(this.simpleNode("subject",this._subject)) : null;
	this.exist(this._thread) ? temp_xml.appendChild(this.simpleNode("thread",this._thread)) : null;
	if (this._type == "error") {
		var temp_error = this.simpleNode("error",this._error);
		temp_error.attributes.code = this._errorcode;
		temp_xml.appendChild(temp_error);
	}
	if (this._x.length >0) {
		var x_i;
		for (x_i in this._x) {
			temp_xml.appendChild(this._x[x_i]);
		}
	}
	return temp_xml;
}
Jabber.Message.prototype.parseXML = function (temp_xml) {
	var temp_xml;
	this._x = new Array();
	this.exist(temp_xml.attributes.to) ? this._to = temp_xml.attributes.to : this._to = null;
	this.exist(temp_xml.attributes.from) ? this._from = temp_xml.attributes.from : this._from = null;
	this.exist(temp_xml.attributes.type) ? this._type = temp_xml.attributes.type : this._type = "normal";
	var temp_child = temp_xml.childNodes;
	var i;
	for (i in temp_child) {
		var name = temp_child[i].nodeName.toLowerCase();
		if (name == "body") {
			this._body = temp_child[i].firstChild.nodeValue;
		} else if (name == "thread") {
			this._thread = temp_child[i].firstChild.nodeValue;
		} else if (name == "subject") {
			this._subject = temp_child[i].firstChild.nodeValue;
		} else if (name == "x") {
			this._x.push(temp_child[i]);
		} else if (name == "error") {
			this._error = temp_child[i].firstChild.nodeValue;
			this._errorcode = temp_child[i].attributes.code;
			this._id = temp_xml.attributes.id;
		}
	}
}
Jabber.Message.prototype.exist = function (value) {
	var temp = new Boolean();
	if (typeof(value) != "undefined" && value != null && value != "null" ) {
		temp = true;
	} else {
		temp = false;
	}
	return temp;
}

Jabber.Message.prototype.addXtag = function(xEvent,xmlns,stamp){
	//takes an xml tag (xEvent) and a string of the ns
	var temp_xml = new XML();
	temp_xml.appendChild(temp_xml.createElement("x"));
	temp_xml.firstChild.attributes.xmlns = xmlns;
	if (this.exist(stamp)){
		temp_xml.firstChild.attributes.stamp = stamp;
	}
	temp_xml.firstChild.appendChild(xEvent);
	this._x.push(temp_xml);
}
	
	
Jabber.Message.prototype.simpleNode = function (name,value) {
	var temp_xml = new XML();
	temp_xml.nodeName = name;
	if (this.exist(value)) {
		temp_xml.appendChild(temp_xml.createTextNode(value));
	}
	return temp_xml;
}
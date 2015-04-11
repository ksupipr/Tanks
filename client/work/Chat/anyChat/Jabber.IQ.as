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

Jabber.IQ = function(name,type,to,from,id,on_call_back) {
	this.exist(to) ? this._to = new String(to) : this._to = null;
	this.exist(from) ? this._from = new String(from) : this._from = null;
	this.exist(name) ? this._name = new String(name) : this._name = null;
	this.exist(type) ? this._type = new String(type) : this._type = null;
	this.exist(id) ? this._id = new String(id) : this._id = "query_id_"+random(10000000);
	this._fields = new Array();
	this._oncallback = on_call_back;
	this._x = new Array();
	
}

Jabber.IQ.prototype.doXML = function() {
	var temp_xml = new XML();
	temp_xml.nodeName = "iq";
	temp_xml.attributes.type = this._type;
	this.exist(this._id) ? temp_xml.attributes.id = this._id : null;
	this.exist(this._to) ? temp_xml.attributes.to = this._to : null;
	this.exist(this._from) ? temp_xml.attributes.from = this._from : null;
	var temp_query =  temp_xml.createElement("query")
	temp_query.attributes.xmlns = this._name;
	if (this._fields.length >0) {
		var name;
		for (name in this._fields) {
			temp_query.appendChild(this._fields[name]);
		}
	}
	temp_xml.appendChild(temp_query);
	if (this._x.length >0) {
		var x_name;
		for (x_name in object._x) {
			temp_xml.appendChild(this._x[x_name]);
		}
	}
	return temp_xml;
}

Jabber.IQ.prototype.parseXML = function(temp_xml) {
	this.exist(temp_xml.attributes.id) ? this._id = temp_xml.attributes.id : this._id = null;
	this.exist(temp_xml.attributes.to) ? this._to = temp_xml.attributes.to : this._to = null;
	this.exist(temp_xml.attributes.from) ? this._from = temp_xml.attributes.from : this._from = null;
	this.exist(temp_xml.attributes.type) ? this._type = temp_xml.attributes.type : this._type = null;
	this._x = [];
	this._fields = [];
	var temp_x = temp_xml.childNodes;
	var x_i;
	for (x_i in temp_x) {
		var x_name = temp_x[x_i].nodeName.toLowerCase();
		if (x_name == "query") {
			this._name = temp_x[x_i].attributes.xmlns;
			this._fields = temp_x[x_i].childNodes;
		} else if (x_name == "x") {
			this._x.push(temp_x[x_i]);
		} else if (x_name == "error") {
			this._error = temp_x[x_i].firstChild.nodeValue;
			this._errorcode = temp_x[x_i].attributes.code;
		}
	}
}

Jabber.IQ.prototype.exist = function (value) {
	var temp = new Boolean();
	if (typeof(value) != "undefined" && value != null && value != "null" ) {
		temp = true
	} else {
		temp = false;
	}
	return temp;
}
Jabber.IQ.prototype.simpleNode = function (name,value) {
	var temp_xml = new XML ();
	temp_xml.nodeName = name;
	if (this.exist(value)) {
		temp_xml.appendChild(temp_xml.createTextNode(value));
	}
	return temp_xml;
}
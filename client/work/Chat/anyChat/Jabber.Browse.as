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
 

Jabber.Browse = function(to,id,queryNS,type) {
	// standard IQ get tag for browsing
	this._queryNS = queryNS;
	this.exist(type) ? this._type = new String(type) : this._type = "get";
	this.exist(to) ? this._to = new String(to) : this._to = null;
	this.exist(id) ? this._id = new String(id) : this._id = null;
	this._items = new Array();
}

Jabber.Browse.prototype.setType = function(type){
	this._type = type;
}


Jabber.Browse.prototype.addItem = function (name,value){
	//items to add for namespace
	this._items.push(new Jabber.Browse.BrowseItem(name,value));
}

Jabber.Browse.BrowseItem = function(name,value){
	trace("name"+name);
	this.name = name;
	this.value = value;
}


 Jabber.Browse.prototype.exist = function (value) {
	var temp = new Boolean();
	if (typeof(value) != "undefined" && value != null && value != "null" ) {
		temp = true;
	} else {
		temp = false;
	}
	return temp;
}

Jabber.Browse.prototype.doXML = function() {
	var temp_xml = new XML();
	temp_xml.nodeName = "iq";
	this.exist(this._type) ? temp_xml.attributes.type = this._type : null;
	this.exist(this._to) ? temp_xml.attributes.to = this._to : null;
	this.exist(this._id) ? temp_xml.attributes.id = this._id : null;
	this.exist(this._version) ? temp_xml.attributes.version = this._version : null;
	temp_xml.appendChild(this.queryNode("query",this._queryNS));
	for(i=0;i<this._items.length;i++){
		trace("hello from xml land!");
		trace("name:"+this._items[i].name);
		temp_xml.firstChild.appendChild(this.simpleNode(this._items[i].name,this._items[i].value));
	}
	return temp_xml;
}
Jabber.Browse.prototype.queryNode = function (name,value) {
	var temp_xml = new XML();
	temp_xml.nodeName = name;
	if (this.exist(value)) {
		temp_xml.appendChild(temp_xml.createTextNode(""));
	}
	temp_xml.attributes.xmlns = value;
	return temp_xml;
}

Jabber.Browse.prototype.simpleNode = function (name,value) {
	var temp_xml = new XML();
	temp_xml.nodeName = name;
	if (this.exist(value)) {
		temp_xml.appendChild(temp_xml.createTextNode(value));
	}
	return temp_xml;
}
	

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

Object.prototype.Jabber = function (server,username,password,resource,show,status,priority,port) {
	this._server = server;
	this._username = username;
	this._password = password;
	this._resource = resource;
	this._show = show;
	this._jid = username+"@"+server+"/"+resource;
	this._status = status;
	this._priority = priority;
	this._sessionid = new Number();
	this._available = new Boolean(false);
	this._active = new Boolean(false);
	this._lasterrorcode = "";
	this._roster = new Jabber.Roster(this);
	this._firstxmltag = new XML("<flash:stream to=\""+this._server+"\" xmlns=\"jabber:client\" xmlns:flash=\"http://www.jabber.com/streams/flash\">");
	this._xmlrepository = new XML();
	this._PENDING_ = {};
	this._PRESENCE_= [];
	this._roster._session = this;
	if(port == "undefined" || port == null){
		this._port = "5222";
	}else{
		this._port = port;
	}
}
ASSetPropFlags(Object.prototype,["Jabber"],1);

Jabber.prototype.__proto__ = XMLSocket.prototype;

// connect to the jabber server
Jabber.prototype.doConnect = function (newcomer,method) {
	this._private_doconnect_newcomer = newcomer;
	this._private_doconnect_method = method;
	this.connect(this._server,5222);
}

// disconnect from the server
Jabber.prototype.doDisconnect = function() {
	var end_tag = new XML("<flash:stream />");
	this.sendXML(end_tag);
}
// check the nessesary fields to register a service
Jabber.prototype.checkRegFields = function(jid) {
	var temp_iq = new Jabber.IQ("jabber:iq:register","get",jid,this._jid,"check_reg_fields"+random(10000),this.private_onRegFields);
	this.sendIQ(temp_iq);
}
// send your registration to a service
Jabber.prototype.sendRegister = function(fields,jid) {
	var call_back;
	if (this.private_exist(jid)) {
	} else {
		jid = this._server;
	}
	var temp_iq = new Jabber.IQ("jabber:iq:register","set",jid,this._jid,"register_"+random(10000),this.private_onRegister);
	temp_iq._fields = fields;
	this.sendIQ(temp_iq);

}
Jabber.prototype.sendAuth = function(type) {
	this._private_doconnect_method = type;
	var temp_iq = new Jabber.IQ("jabber:iq:auth","get",null,null,"log_user_"+random(10000),this.private_onCheckAuth);
	temp_iq._fields.push(this.private_simpleNode("username",this._username));
	this.sendIQ(temp_iq);	
}
/*
 THIS FUNCTION IS DECLARED BELOW
Jabber.prototype.sendMessage = function (message_object) {
	var temp_xml = message_object.doXML();
	this.sendXML(temp_xml);
}
*/
// transform a IQ object into a xml object and send it to the server
Jabber.prototype.sendIQ = function(obj) {
	var temp_xml = obj.doXML();
	this._PENDING_[obj._id] = obj._oncallback;
	this.sendXML(temp_xml);
}
Jabber.prototype.sendMyPresence = function(type,id) {
	//added this._room variable and setRoom function
	// if type == unavailable you will leave the room
	//added id variable to allow for more complex tracking inside flash
	//for instance set id="roomCreate" and then use id to decide what to do when OnPresence is called.
	this.sendPresence (type,this._roomID,null,this._status,this._show,this._priority,null,id); 
}
//creates the jid for the room
Jabber.prototype.setRoom = function(room,confID) {
	if (this.private_exist(confID)){
		this._confID = confID;
	}
	if (this.private_exist(room)){
		this._room = room;
	}
	this._roomID = this._room+"@"+this._confID+"/"+this._username;
	trace("roomid:"+this._roomID);
}

//send a presence tag to the server
Jabber.prototype.sendPresence = function(type,to,from,status,show,priority,x,id) {
	var temp_xml = this.private_simpleNode("presence");
	if (this.private_exist(type)) {
		temp_xml.attributes.type = type;
	}
	if (this.private_exist(to)) {
		temp_xml.attributes.to = to;
	}
	if (this.private_exist(from)) {
		temp_xml.attributes.from = from;
	}
	if (this.private_exist(id)) {
		temp_xml.attributes.id = id;
	}
	if (this.private_exist(status)) {
		temp_xml.appendChild(this.private_simpleNode("status",status));
	}
	if (this.private_exist(show)) {
		temp_xml.appendChild(this.private_simpleNode("show",show));
	}
	if (this.private_exist(priority)) {
		temp_xml.appendChild(this.private_simpleNode("priority",priority));
	}
	if (this.private_exist(x) && x.length > 0) {
		var iii;
		for (iii in x) {
			temp_xml.appendChild(x[iii]);
		}
	}
	this.sendXML(temp_xml);
}
Jabber.prototype.subscribe = function(jid,name,status,groups) {
	var temp_item = this._roster.addItem(jid,name);
	temp_item.addGroup(groups);
	temp_item.update();
	this.sendPresence("subscribe",jid,null,status);
}
Jabber.prototype.unSubscribe = function(jid) {
	var temp_jid = this._roster.findUserID(jid)
	temp_jid.remove();
}
Jabber.prototype.sendXML = function(temp_xml) {
	this.send(temp_xml);
	this.onXML(true,temp_xml);
}
Jabber.prototype.sendMessage = function(temp_message) {
	var temp_xml = temp_message.doXML();
	this.sendXML(temp_xml);
}

Jabber.prototype.sendBrowse = function(temp_message) {
	var temp_xml = temp_message.doXML();
	this.sendXML(temp_xml);
}

Jabber.prototype.getPresence = function(jid,resource,primary) {
	var jid, resource;
	var temp_jid = jid.split("/");
	if (temp_jid[0] != jid) {
		jid = temp_jid[0];
		this.private_exist(resource) ? null : resource = temp_jid[1];
	}
	var temp_array = [];
	var i;
	if (this.private_exist(resource)) {
		for (i in this._PRESENCE_) {
			if (this._PRESENCE_[i]._userid == jid && this._PRESENCE_[i]._resource == resource) {
				temp_array.push(this._PRESENCE_[i]);
				break;
			}
		}
		if (temp_array.length == 0 ) {
			return null;
		} else {
			return temp_array[0];
		}
	} else {
		var i_i;
		for (i_i in this._PRESENCE_) {
			if (this._PRESENCE_[i_i]._userid == jid) {
				temp_array.push(this._PRESENCE_[i_i]);
			}
		}
		if (temp_array.length == 0 ) {
			return null;
		} else {
			temp_array.sort(this.private_order);
			 if (primary == true) {
				return temp_array[0];
			} else {
				return temp_array;
			}
		}
	}
}

Jabber.prototype.getRoomRoster = function(){
	//returns an array of all people in the room
	var temp_array = new Array();
	for (i in this._PRESENCE_) {
		if(this._PRESENCE_[i]._resource.length > 0){
			temp_array.push(this._PRESENCE_[i]._resource);
		}
	}
	return temp_array;
}

Jabber.prototype.on_data_parser = new Object();

Jabber.prototype.on_data_parser["stream:stream"] = function(first_tag){
	// server first exchange
	this._sessionid = first_tag.attributes.id;
	//log to the server (send pass and username)
	if (first_tag.attributes.from == this._server) {
		 if(this._private_doconnect_method == "none") {
			var temp_iq = new Jabber.IQ("jabber:iq:register","get",null,null,"reg_info_"+random(10000),this.private_OnRegFields);
			this.sendIQ(temp_iq);
		}else if (this._private_doconnect_newcomer == true) {
			var reg_obj = new Array();
			reg_obj.push(this.private_simpleNode("username",this._username));
			reg_obj.push(this.private_simpleNode("password",this._password));
			this.sendRegister(reg_obj);
		} else {
			this.sendAuth(this._private_doconnect_method);
		}
		
	}	
}

Jabber.prototype.on_data_parser["flash:stream"] = Jabber.prototype.on_data_parser["stream:stream"];

Jabber.prototype.on_data_parser["stream:error"] = function(first_tag){
	//stream error handling
	this._lasterrorcode = "Stream Error";
	this.onCommError(first_tag.firstChild.nodeValue);
}

Jabber.prototype.on_data_parser["iq"] = function(first_tag){
	// transform the "iq" tag into a IQ object
	var temp_iq = new Jabber.IQ();
	temp_iq.parseXML(first_tag);
	if (temp_iq._type == "error") {
			this._lasterrorcode = temp_iq._errorcode;
			this.onQueryError(temp_iq._error);
	}
	this.temp_IQ_callback = this._PENDING_[temp_iq._id];
	this.temp_IQ_callback(temp_iq);
	this.onQuery(temp_iq,first_tag);
	if (temp_iq._type == "set"  && temp_iq._name == "jabber:iq:roster") {
		var rost_xml = temp_iq._fields;
		var rost_i;
		for (rost_i in rost_xml) {
			if (rost_xml[rost_i].nodeName.toLowerCase() == "item") {
				var temp_item_groups = [];
				var item_i;
				if (rost_xml[rost_i].hasChildNodes) {
					var item_i;
					var temp_item_child = rost_xml[rost_i].childNodes;
					for (item_i in temp_item_child) {
						temp_item_groups.push(temp_item_child[item_i].firstChild.nodeValue);
					}
				}
				var temp_item = this._roster.addItem(rost_xml[rost_i].attributes.jid,rost_xml[rost_i].attributes.name);
				temp_item._subscription = rost_xml[rost_i].attributes.subscription;
				temp_item._ask = rost_xml[rost_i].attributes.ask;
				temp_item._groups = temp_item_groups;
				if (temp_item._subscription == "remove") {
					var temp_item_2 = new Jabber.RosterItem(this._roster,temp_item._jid,temp_item._name);
					temp_item_2._subscription = "remove";
					this._roster.remove(temp_item);
					this.onRosterItem(temp_item_2);
				} else {
					this.onRosterItem(temp_item);
				}
			}
		}
	}//end roster namespace
	if (temp_iq._type == "result"){
		var results = first_tag.childNodes;
		nodeName = results[0].nodeName.toLowerCase();
		if(nodeName == "conference"){
			var rooms = results[0].childNodes;
			this._conference = new Jabber.Conference();
			this._conference.parseXML(rooms);
			this.onConference(_conference,first_tag);
		}else{
			onResult(first_tag,temp_IQ._id);
		}
	}
}

Jabber.prototype.on_data_parser["presence"] = function(first_tag){
	// presence tag handling
	var pre_to = first_tag.attributes.to;
	var pre_from = first_tag.attributes.from;
	var pre_type = first_tag.attributes.type;
	var pre_id = first_tag.attributes.id;
	var pre_show = null;
	var pre_status = null;
	var pre_priority = null;
	var pre_x = new Array();
	var pre_xml = first_tag.childNodes;
	var pre_i;
	for (pre_i in pre_xml) {
		var pre_tag = pre_xml[pre_i].nodeName.toLowerCase();
		if (pre_tag == "show") {
			pre_show = pre_xml[pre_i].firstChild.nodeValue;
		} else if (pre_tag == "status") { 
			pre_status = pre_xml[pre_i].firstChild.nodeValue;
		} else if (pre_tag == "priority") {
			pre_priority = pre_xml[pre_i].firstChild.nodeValue;
		} else if (pre_tag == "x") {
			pre_x.push(pre_xml[pre_i]);
		}
	}
	if (pre_type == "subscribe") {
		var temp_sub_item = this._roster.findUserID(pre_from);
		if (temp_sub_item._subscription == "to") {
			this.onSubscriptionReply(pre_from,pre_status);
		} else {
			this.onSubscriptionRequest(pre_from,pre_status);
		}
	} else if (pre_type == "subscribed") {
		this.onSubscriptionApproved(pre_from,pre_status);
	} else if (pre_type == "unsubscribe") {
		this.onUnSubscription(pre_from,pre_type,pre_status);
	} else if (pre_type == "unsubscribed") {
		this.onUnSubscription(pre_from,pre_type,pre_status);
		var temp_sub_item = this._roster.findUserID(pre_from);
		if (temp_sub_item._ask == "subscribe") {
			this.onSubscriptionDenied(pre_from,pre_status);
		}
	} else if (! this.private_exist(pre_type) || pre_type == "available" || pre_type == "unavailable") {
		if (pre_type == "unavailable") {
			var i_u;
			for (i_u in this._PRESENCE_) {
				if (this._PRESENCE_[i_u]._jid == pre_from) {
					this._PRESENCE_.splice(i_u,1);
				}
			}
			var pre_available = false;
		} else {
			var temp_pre_s = this.getPresence(pre_from);
			if (this.private_exist(temp_pre_s)) {
				this.private_exist(pre_status) ? temp_pre_s._status = pre_status : null;
				this.private_exist(pre_show) ? temp_pre_s._show = pre_show : null;
				this.private_exist(pre_priority) ? temp_pre_s._priority = Number(pre_priority) : null;
			} else {
				var temp_pre_obj = new Jabber.Presence(pre_from,pre_status,pre_priority,pre_show)
				trace("pushing presence");
				this._PRESENCE_.push(temp_pre_obj);
			}
			var pre_available = true;
		}
		if (this._roster.findUserID(pre_from) == "nil") {
			var pre_roster = false;
		} else {
			var pre_roster = true;
		} 
		this.onPresence(pre_from,pre_available,pre_roster,first_tag,pre_id);
	}
}

Jabber.prototype.on_data_parser["message"] = function(first_tag){
	//message tag handling
	var temp_message = new Jabber.Message();
	temp_message.parseXML(first_tag);
	this.onMessage(temp_message,first_tag);
	//call Xevent handler tag.
	for(i=0;i<temp_message._x.length;i++){
		this.onXevent(temp_message._x[i],temp_message._from);
	}
}


//private function called when the xmlsocket receive data.
Jabber.prototype.onData = function(src) {
	src_xml = new XML(src);
	this.onXML(false,src_xml);
	var first_tag = src_xml.firstChild;
	var name = first_tag.nodeName.toLowerCase();
	this.temp_on_data_parser = this.on_data_parser[name];
	this.temp_on_data_parser(first_tag);
}
// when the XML socket is connected
Jabber.prototype.onConnect = function(success) {
	if (success) {
		this.sendXML(this._firstxmltag);
	} else {
		this._lasterrorcode = "DNS";
		this.onCommError("can't connect to "+ this._server);
	}
}
//check if a value exist or not
Jabber.prototype.private_exist = function (value) {
	var temp = new Boolean();
	if (typeof(value) != "undefined" && value != null && value != "null" ) {
		temp = true;
	} else {
		temp = false;
	}
	return temp;
}
// create simple XML node
Jabber.prototype.private_simpleNode = function (name,value) {
	var temp_xml = new XML ();
	temp_xml.nodeName = name;
	if (typeof(value) != "undefined" || value != null) {
	
	}
	temp_xml.appendChild(temp_xml.createTextNode(value));
	return temp_xml;
}
// when the server reply to the username check
Jabber.prototype.private_onCheckAuth = function (object) {
	var type = this._private_doconnect_method;
	if (object._type == "result") {
		for (i in object._fields){
			if (object._fields[i].nodeName.toLowerCase() == "token"){
				var token = object._fields[i].firstChild.nodeValue;
				var tokenOK = true;
			} else if (object._fields[i].nodeName.toLowerCase() == "digest"){
				var digestOK = true;
			} else if (object._fields[i].nodeName.toLowerCase() == "sequence"){
				var sequence = Number(object._fields[i].firstChild.nodeValue);
				var sequenceOK = true;
			} else if (object._fields[i].nodeName.toLowerCase() == "password"){
				var passwordOK = true;
			}
		}
		var temp_iq = new Jabber.IQ("jabber:iq:auth","set",null,null,"log_user_"+random(10000),this.private_onLogin);
		temp_iq._fields.push(this.private_simpleNode("username",this._username));
		temp_iq._fields.push(this.private_simpleNode("resource",this._resource));
		if(type == "auto"){
			if ((tokenOK)&&(sequenceOK)&& (typeof(Encrypt.SHA1) == "function")){
				type = "hash";
			} else if((digestOK) && (typeof(Encrypt.SHA1) == "function")){
				type = "digest";
			} else {
				type = "text";
			}
		}
		if(type == "hash"){
			//due to ActionScript's slowness this function has been disabled and replaced by the "digest" function instead.
			//var hashA = Encrypt.SHA1(this._parent._password);
			//var hash0 = Encrypt.SHA1(hashA+token);
			//for (i=1;i<=sequence;i++){
			//	hash0 = Encrypt.SHA1(hash0);
			//}
			//temp_iq._fields.push(this._parent.private_simpleNode("hash",hash0));
			
			temp_iq._fields.push(this.private_simpleNode("digest",Encrypt.SHA1(this._sessionid + this._password)));
		} else if(type == "digest"){
			temp_iq._fields.push(this.private_simpleNode("digest",Encrypt.SHA1(this._sessionid + this._password)));
		} else if(type == "text"){
			temp_iq._fields.push(this.private_simpleNode("password",this._password));
		}
		this.sendIQ(temp_iq);
	} else if (object._type == "error") {
		this._lasterrorcode = object._errorcode;
		this.onAuthError(object._error);
	}
}
Jabber.prototype.private_onRegFields = function (object) {
	if (object._type == "result") {
		this.onRegFields(object._from,object._fields);
	} else if (object._type == "error") {
		this._lasterrorcode = object._errorcode;
		this.onAuthError(object._error);
	}
}


// when the server reply to the login request
Jabber.prototype.private_onLogin = function (object) {
	if (object._type == "result") {
		this._active = true;
		this.onLogin();
	} else if (object._type == "error") {
		this._lasterrorcode = object._errorcode;
		this.onAuthError(object._error);
	}
}
Jabber.prototype.private_onRegister = function(object) {
	if (object._type == "result") {
		this.onRegister(object._from);
		this.sendAuth(this._private_doconnect_method);
	} else if (object._type == "error") {
		this._lasterrorcode = object._errorcode;
		this.onAuthError(object._error);
	}
}
Jabber.prototype.private_order = function (a, b) {
	var name1 = a._priority;
	var name2 = b._priority;
	 if (name1<name2) {
		return 1;
	} else if (name1 > name2) {
		return -1;
	} else {
		return 0;
	}
}
Jabber.prototype.getRoomInfo = function (id){
	this.private_exist(id) ? null  : id = "getRoomInfo_"+random(10000000);
	var myBrowse = new Jabber.Browse(this._room+"@"+this._confID,id,"jabber:iq:conference");
	myJabber.sendBrowse(myBrowse);
}
Jabber.prototype.setRoomInfo = function(name,value,id){
	//creates a browse object, then sets it, then sends it. Can only be called by the room's owner,
	// and sets the private, name and secret tags
	this.private_exist(id) ? null : id = "setRoomInfo_"+random(10000000);
	var myBrowse = new Jabber.Browse(this._room+"@"+this._confID,id,"jabber:iq:conference","set");
	myBrowse.addItem(name,value);
	this.sendBrowse(myBrowse);
	trace("sending info");
}
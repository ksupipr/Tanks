/* JabberFLash - Jabber API for Macromedia Flash
 * Chris Hill <chill@collective3.com>
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


/*This file is a connector between the jabber API and Flash.
 It gives hints and tips in order to allow people to write 
 apps without needing to know in-depth the rest of the jabber 
 actionscript
After JabberFlash handles requests it passes the relevent data 
to this suite of functions, in which you may put whatever actionscript 
is needed to connect it to your GUI.

For more information on using the Jabber Protocol:
www.jabber.org

The Jabber Client Developer's Cheat Sheet
http://homepage.mac.com/jens/Jabber/JabberClientCheatSheet.html

Jabber Programmer's Guide:
http://docs.jabber.org/jpg/html/main.html

*/

//initialize jabber variables, and create Jabber Object

server = "yourserver.com";
user = "user";
password = "pass";
newuser = false;
port = 5222;

//create the jabber object called myjabber
connectJabber(server, user,password,newuser,port);

/*for conferencing and room features you can initialize a list of rooms (myjabber._rooms) :
confDomain = "conference.yourserver.com";
browseRooms(confDomain);
*/

/*
myjabber._rooms is an array of room objects. The room object consists of:
_room - room's ID(such as "test2349";
_people - number of people in room;
_roomName - The room's name or description

You may use jabber.setRoom(), jabber.setRoomInfo(), jabber.getRoomInfo() and the presence functions to enter and leave rooms.
Joining a room basically works like this:
	//get the room's ID
	myRoom = _root.myjabber._rooms[0]._room;
	//create the room object
	_root.myjabber.setRoom(myRoom,_root.confDomain);
	//send presence to the room
	_root.myjabber.sendMyPresence();

if creating:
	_root.myjabber.sendMyPresence();
	setRoomInfo("name","Chris's Jabber Nook");
	gives it a name.
if entering you can use: 
	var nicks = myjabber.getRoomRoster();
which will return an array of the nicknames of all room participants.
*/

function connectJabber(server,user,password,newuser, port) {
	myjabber = new Jabber(server,user,password,"flash",null,"online",0,port);
	myjabber.onLogin = onLogin;
	myjabber.onXML = onXML;
	myjabber.onDisconnect = onDisconnect;
	myjabber.onCommError = onCommError;
	myjabber.onRosterStart = onRosterStart;
	myjabber.onRosterItem = onRosterItem;
	myjabber.onRosterEnd = onRosterEnd;
	myjabber.onMessage = onMessage;
	myjabber.onPresence = onPresence;
	myjabber.onSubscriptionRequest = onSubscriptionRequest;
	myjabber.onSubscriptionReply = onSubscriptionReply;
	myjabber.onSubscriptionApproved = onSubscriptionApproved;
	myjabber.onSubscriptionDenied = onSubscriptionDenied;
	myjabber.onUnSubscription = onUnSubscription;
	myjabber.onQuery = onQuery;
	myjabber.onQueryError = onQueryError;
	myjabber.onRegFields = onRegFields;
	myjabber.onRegister = onRegister;
	myjabber.onAuthError = onAuthError;
	myjabber.doConnect(newuser,"digest");
	myjabber.onConference = onConference;
	myjabber.onCreateRoom = onCreateRoom;
	myjabber.onResult = onResult;
	myjabber.onXevent = onXevent;
}

function onLogin () {
	myjabber._roster.fetch();
	outerror += "onLogin \n";
}

function onXML(way,obj) {
	var way2;
	way ? way2="send":way2="receive";
	output += way2+" "+obj+"\n";
}

function onDisconnect () {
	outerror += "onDisconnect \n";
}

function onCommError () {
	outerror += "onCommError \n";
}

function onRegFields () {
	outerror += "onRegFields \n";
}

function onAuthError () {
	outerror += "onAuthError \n";
}

function onRegister () {
	outerror += "onRegister \n";
}

function onRosterStart () {
	outerror += "onRosterStart \n";
}

function onRosterItem (temp_item) {
	outerror += "onRosterItem \n";
}


function onRosterEnd () {
	outerror += "onRosterEnd \n";

}

function onXevent(eventXml,from){
	//when you receive a jabber:x:event inside a message you can handle it here
	//the following two variables point to the namespace and the xml inside the x event wrapper 
	var xType = eventXML.attributes.xmlns;
	var xXml = eventXML.firstChild.attributes;
	if(xType == "jabber:x:event"){
		if(xXml.type == "event"){
			//then do something
		}
	}
}

function onMessage (tempMessage, firstTag) {
	outerror += "onMessage \n";	
}

function onPresence (pre_from,pre_available,pre_roster,first_tag,pre_id) {
	outerror += "onPresence \n";
}

function onCreateRoom(){
	//When a room has been created successfully;
	trace("we just might have named the room!");
}

getConfUser = function(userString){
	//pulls the userid out of a conference room ID syntax room@conference.domain.com/userid
	var temp_string = userString.split("/");
	if(temp_string.length == 1){
		var userid = "system";
	}else{	
		var userid = temp_string[1];
	}
	return userid;
}
	
function onQuery () {
	outerror += "onQuery \n";
}

function onQueryError () {
	outerror += "onQueryError \n";
}

function onResult (first_tag,id){
	outerror += "onResult \n";

}
function onSubscriptionRequest (jid,status) {
	outerror += "onSubscriptionRequest \n";
	_root.attachMovie("on_subscription","on_subscription",5);
	var mc = _root["on_subscription"];
	mc.jid = jid;
}

function onSubscriptionReply (jid,status) {
	outerror += "onSubscriptionReply \n";
	_root.attachMovie("reply_subscription","reply_subscription",4);
	var mc = _root["reply_subscription"];
	mc.jid = jid;
	mc.text = jid + " want to subscribe to your request."
}

function onSubscriptionApproved (jid,status) {
	outerror += "onSubscriptionApproved \n";
}

function onSubscriptionDenied (jid,status) {
	outerror += "onSubscriptionDenied \n";
	myjabber._roster.findUserID(jid).remove();

}

function onUnSubscription (jid,type,status) {
	outerror += "onUnSubscription \n";
	if (type == "unsubscribed") {
		myjabber._roster.findUserID(jid).remove();
	}

}

function sendGroupChat (body){
	 var myMessage = new Jabber.Message(myjabber._room+"@"+myjabber._confID,null,body,"groupchat",null);
	myjabber.sendMessage(myMessage);
}

function browseRooms(confID){
	//initializes the jabber rooms this should probably go into the jabber.as file
	_root.myJabber._confID = confID; 
	//creates the jabber._rooms object, a list of rooms available
	var myBrowse = new Jabber.Browse(confID,"browseRooms"+random(10000000),"jabber:iq:browse");
	myJabber.sendBrowse(myBrowse);
}

function roomInfo(){
	var myBrowse = new Jabber.Browse(myjabber._room+"@"+myjabber._confID,"roomInfo"+random(10000000),"jabber:iq:conference");
	myJabber.sendBrowse(myBrowse);
}

function onConference(rooms,first_tag){
	outerror += "onConference \n";
}

function sendXEvent(eventInfo,user){
	//example function for sending a simple message with a jabber:x: namespace to a room
	//eventInfo must be a valid xml object
	var myMessage = new Jabber.Message(myjabber._room+"@"+myjabber._confID+"/"+user,null,"","chat",null);
	myMessage.addXtag(eventInfo,"jabber:x:game");
	myjabber.sendMessage(myMessage);
}

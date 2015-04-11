/*
 * A JavaScript implementation of the Secure Hash Algorithm, SHA-1, as defined
 * in FIPS PUB 180-1
 * Copyright (C) Paul Johnston 2000 - 2002.
 * See http://pajhome.org.uk/site/legal.html for details.
 */

if(typeof(Object.prototype.Encrypt)=="undefined"){
	Object.prototype.Encrypt = new Object();
	ASSetPropFlags(Object.prototype,["Encrypt"],1);	
}

Encrypt.SHA1 = function (val) {
  Encrypt.SHA1.hex_chr = "0123456789abcdef";
  var x = Encrypt.SHA1.str2blks_SHA1(val);
  var w = new Array(80);
  var a =  1732584193;
  var b = -271733879;
  var c = -1732584194;
  var d =  271733878;
  var e = -1009589776;
  for(var i = 0; i < x.length; i += 16)
  {
    var olda = a;
    var oldb = b;
    var oldc = c;
    var oldd = d;
    var olde = e;
    for(var j = 0; j < 80; j++)
    {
	if(j < 16){ 
      		w[j] = x[i + j];
	} else {
		w[j] = Encrypt.SHA1.rol(w[j-3] ^ w[j-8] ^ w[j-14] ^ w[j-16], 1);
	}
      var t = Encrypt.SHA1.safe_add(Encrypt.SHA1.safe_add(Encrypt.SHA1.rol(a, 5), Encrypt.SHA1.ft(j, b, c, d)), Encrypt.SHA1.safe_add(Encrypt.SHA1.safe_add(e, w[j]), Encrypt.SHA1.kt(j)));
      e = d;
      d = c;
      c = Encrypt.SHA1.rol(b, 30);
      b = a;
      a = t;
    }
    a = Encrypt.SHA1.safe_add(a, olda);
    b = Encrypt.SHA1.safe_add(b, oldb);
    c = Encrypt.SHA1.safe_add(c, oldc);
    d = Encrypt.SHA1.safe_add(d, oldd);
    e = Encrypt.SHA1.safe_add(e, olde);
  }
  return Encrypt.SHA1.hex(a) + Encrypt.SHA1.hex(b) + Encrypt.SHA1.hex(c) + Encrypt.SHA1.hex(d) + Encrypt.SHA1.hex(e);
}
	
Encrypt.SHA1.hex = function(num){
  var str = "";
  for(var j = 7; j >= 0; j--)
  str += Encrypt.SHA1.hex_chr.charAt((num >> (j * 4)) & 0x0F);
  return str;
}

Encrypt.SHA1.str2blks_SHA1 = function(str){
  var nblk = ((str.length + 8) >> 6) + 1;
  var blks = new Array(nblk * 16);
  for(var i = 0; i < nblk * 16; i++) blks[i] = 0;
  for(var i = 0; i < str.length; i++)
    blks[i >> 2] |= str.charCodeAt(i) << (24 - (i % 4) * 8);
  blks[i >> 2] |= 0x80 << (24 - (i % 4) * 8);
  blks[nblk * 16 - 1] = str.length * 8;
  return blks;
}

Encrypt.SHA1.safe_add = function(x, y){
  var lsw = (x & 0xFFFF) + (y & 0xFFFF);
  var msw = (x >> 16) + (y >> 16) + (lsw >> 16);
  return (msw << 16) | (lsw & 0xFFFF);
}

Encrypt.SHA1.rol = function(num, cnt){
  return (num << cnt) | (num >>> (32 - cnt));
}

Encrypt.SHA1.ft = function(t, b, c, d){
  if(t < 20) return (b & c) | ((~b) & d);
  if(t < 40) return b ^ c ^ d;
  if(t < 60) return (b & c) | (b & d) | (c & d);
  return b ^ c ^ d;
}

Encrypt.SHA1.kt = function(t){
  return (t < 20) ?  1518500249 : (t < 40) ?  1859775393 :
         (t < 60) ? -1894007588 : -899497514;
}


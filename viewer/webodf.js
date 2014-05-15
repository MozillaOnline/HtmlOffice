// Input 0
var webodf_version="0.4.2-2076-g89220e5-dirty";
// Input 1
function Runtime(){}Runtime.prototype.getVariable=function(m){};Runtime.prototype.toJson=function(m){};Runtime.prototype.fromJson=function(m){};Runtime.prototype.byteArrayFromString=function(m,k){};Runtime.prototype.byteArrayToString=function(m,k){};Runtime.prototype.read=function(m,k,b,g){};Runtime.prototype.readFile=function(m,k,b){};Runtime.prototype.readFileSync=function(m,k){};Runtime.prototype.loadXML=function(m,k){};Runtime.prototype.writeFile=function(m,k,b){};
Runtime.prototype.isFile=function(m,k){};Runtime.prototype.getFileSize=function(m,k){};Runtime.prototype.deleteFile=function(m,k){};Runtime.prototype.log=function(m,k){};Runtime.prototype.setTimeout=function(m,k){};Runtime.prototype.clearTimeout=function(m){};Runtime.prototype.libraryPaths=function(){};Runtime.prototype.currentDirectory=function(){};Runtime.prototype.setCurrentDirectory=function(m){};Runtime.prototype.type=function(){};Runtime.prototype.getDOMImplementation=function(){};
Runtime.prototype.parseXML=function(m){};Runtime.prototype.exit=function(m){};Runtime.prototype.getWindow=function(){};Runtime.prototype.requestAnimationFrame=function(m){};Runtime.prototype.cancelAnimationFrame=function(m){};Runtime.prototype.assert=function(m,k,b){};var IS_COMPILED_CODE=!0;
Runtime.byteArrayToString=function(m,k){function b(b){var d="",n,r=b.length;for(n=0;n<r;n+=1)d+=String.fromCharCode(b[n]&255);return d}function g(b){var d="",n,r=b.length,f=[],q,a,c,h;for(n=0;n<r;n+=1)q=b[n],128>q?f.push(q):(n+=1,a=b[n],194<=q&&224>q?f.push((q&31)<<6|a&63):(n+=1,c=b[n],224<=q&&240>q?f.push((q&15)<<12|(a&63)<<6|c&63):(n+=1,h=b[n],240<=q&&245>q&&(q=(q&7)<<18|(a&63)<<12|(c&63)<<6|h&63,q-=65536,f.push((q>>10)+55296,(q&1023)+56320))))),1E3===f.length&&(d+=String.fromCharCode.apply(null,
f),f.length=0);return d+String.fromCharCode.apply(null,f)}var p;"utf8"===k?p=g(m):("binary"!==k&&this.log("Unsupported encoding: "+k),p=b(m));return p};Runtime.getVariable=function(m){try{return eval(m)}catch(k){}};Runtime.toJson=function(m){return JSON.stringify(m)};Runtime.fromJson=function(m){return JSON.parse(m)};Runtime.getFunctionName=function(m){return void 0===m.name?(m=/function\s+(\w+)/.exec(m))&&m[1]:m.name};
function BrowserRuntime(m){function k(q){var a=q.length,c,h,e=0;for(c=0;c<a;c+=1)h=q.charCodeAt(c),e+=1+(128<h)+(2048<h),55040<h&&57344>h&&(e+=1,c+=1);return e}function b(q,a,c){var h=q.length,e,b;a=new Uint8Array(new ArrayBuffer(a));c?(a[0]=239,a[1]=187,a[2]=191,b=3):b=0;for(c=0;c<h;c+=1)e=q.charCodeAt(c),128>e?(a[b]=e,b+=1):2048>e?(a[b]=192|e>>>6,a[b+1]=128|e&63,b+=2):55040>=e||57344<=e?(a[b]=224|e>>>12&15,a[b+1]=128|e>>>6&63,a[b+2]=128|e&63,b+=3):(c+=1,e=(e-55296<<10|q.charCodeAt(c)-56320)+65536,
a[b]=240|e>>>18&7,a[b+1]=128|e>>>12&63,a[b+2]=128|e>>>6&63,a[b+3]=128|e&63,b+=4);return a}function g(b){var a=b.length,c=new Uint8Array(new ArrayBuffer(a)),h;for(h=0;h<a;h+=1)c[h]=b.charCodeAt(h)&255;return c}function p(b,a){var c,h,e;void 0!==a?e=b:a=b;m?(h=m.ownerDocument,e&&(c=h.createElement("span"),c.className=e,c.appendChild(h.createTextNode(e)),m.appendChild(c),m.appendChild(h.createTextNode(" "))),c=h.createElement("span"),0<a.length&&"<"===a[0]?c.innerHTML=a:c.appendChild(h.createTextNode(a)),
m.appendChild(c),m.appendChild(h.createElement("br"))):console&&console.log(a);"alert"===e&&alert(a)}function l(q,a,c){if(0!==c.status||c.responseText)if(200===c.status||0===c.status){if(c.response&&"string"!==typeof c.response)"binary"===a?(c=c.response,c=new Uint8Array(c)):c=String(c.response);else if("binary"===a)if(null!==c.responseBody&&"undefined"!==String(typeof VBArray)){c=(new VBArray(c.responseBody)).toArray();var h=c.length,e=new Uint8Array(new ArrayBuffer(h));for(a=0;a<h;a+=1)e[a]=c[a];
c=e}else{(a=c.getResponseHeader("Content-Length"))&&(a=parseInt(a,10));if(a&&a!==c.responseText.length)a:{var h=c.responseText,e=!1,n=k(h);if("number"===typeof a){if(a!==n&&a!==n+3){h=void 0;break a}e=n+3===a;n=a}h=b(h,n,e)}void 0===h&&(h=g(c.responseText));c=h}else c=c.responseText;f[q]=c;q={err:null,data:c}}else q={err:c.responseText||c.statusText,data:null};else q={err:"File "+q+" is empty.",data:null};return q}function d(b,a,c){var h=new XMLHttpRequest;h.open("GET",b,c);h.overrideMimeType&&("binary"!==
a?h.overrideMimeType("text/plain; charset="+a):h.overrideMimeType("text/plain; charset=x-user-defined"));return h}function n(b,a,c){function h(){var h;4===e.readyState&&(h=l(b,a,e),c(h.err,h.data))}if(f.hasOwnProperty(b))c(null,f[b]);else{var e=d(b,a,!0);e.onreadystatechange=h;try{e.send(null)}catch(n){c(n.message,null)}}}var r=this,f={};this.byteArrayFromString=function(q,a){var c;"utf8"===a?c=b(q,k(q),!1):("binary"!==a&&r.log("unknown encoding: "+a),c=g(q));return c};this.byteArrayToString=Runtime.byteArrayToString;
this.getVariable=Runtime.getVariable;this.fromJson=Runtime.fromJson;this.toJson=Runtime.toJson;this.readFile=n;this.read=function(b,a,c,h){n(b,"binary",function(e,b){var q=null;if(b){if("string"===typeof b)throw"This should not happen.";q=b.subarray(a,a+c)}h(e,q)})};this.readFileSync=function(b,a){var c=d(b,a,!1),h;try{c.send(null);h=l(b,a,c);if(h.err)throw h.err;if(null===h.data)throw"No data read from "+b+".";}catch(e){throw e;}return h.data};this.writeFile=function(b,a,c){f[b]=a;var h=new XMLHttpRequest,
e;h.open("PUT",b,!0);h.onreadystatechange=function(){4===h.readyState&&(0!==h.status||h.responseText?200<=h.status&&300>h.status||0===h.status?c(null):c("Status "+String(h.status)+": "+h.responseText||h.statusText):c("File "+b+" is empty."))};e=a.buffer&&!h.sendAsBinary?a.buffer:r.byteArrayToString(a,"binary");try{h.sendAsBinary?h.sendAsBinary(e):h.send(e)}catch(n){r.log("HUH? "+n+" "+a),c(n.message)}};this.deleteFile=function(b,a){delete f[b];var c=new XMLHttpRequest;c.open("DELETE",b,!0);c.onreadystatechange=
function(){4===c.readyState&&(200>c.status&&300<=c.status?a(c.responseText):a(null))};c.send(null)};this.loadXML=function(b,a){var c=new XMLHttpRequest;c.open("GET",b,!0);c.overrideMimeType&&c.overrideMimeType("text/xml");c.onreadystatechange=function(){4===c.readyState&&(0!==c.status||c.responseText?200===c.status||0===c.status?a(null,c.responseXML):a(c.responseText,null):a("File "+b+" is empty.",null))};try{c.send(null)}catch(h){a(h.message,null)}};this.isFile=function(b,a){r.getFileSize(b,function(c){a(-1!==
c)})};this.getFileSize=function(b,a){if(f.hasOwnProperty(b)&&"string"!==typeof f[b])a(f[b].length);else{var c=new XMLHttpRequest;c.open("HEAD",b,!0);c.onreadystatechange=function(){if(4===c.readyState){var h=c.getResponseHeader("Content-Length");h?a(parseInt(h,10)):n(b,"binary",function(c,h){c?a(-1):a(h.length)})}};c.send(null)}};this.log=p;this.assert=function(b,a,c){if(!b)throw p("alert","ASSERTION FAILED:\n"+a),c&&c(),a;};this.setTimeout=function(b,a){return setTimeout(function(){b()},a)};this.clearTimeout=
function(b){clearTimeout(b)};this.libraryPaths=function(){return["lib"]};this.setCurrentDirectory=function(){};this.currentDirectory=function(){return""};this.type=function(){return"BrowserRuntime"};this.getDOMImplementation=function(){return window.document.implementation};this.parseXML=function(b){return(new DOMParser).parseFromString(b,"text/xml")};this.exit=function(b){p("Calling exit with code "+String(b)+", but exit() is not implemented.")};this.getWindow=function(){return window};this.requestAnimationFrame=
function(b){var a=window.requestAnimationFrame||window.webkitRequestAnimationFrame||window.mozRequestAnimationFrame||window.msRequestAnimationFrame,c=0;if(a)a.bind(window),c=a(b);else return setTimeout(b,15);return c};this.cancelAnimationFrame=function(b){var a=window.cancelAnimationFrame||window.webkitCancelAnimationFrame||window.mozCancelAnimationFrame||window.msCancelAnimationFrame;a?(a.bind(window),a(b)):clearTimeout(b)}}
function NodeJSRuntime(){function m(b){var f=b.length,n,a=new Uint8Array(new ArrayBuffer(f));for(n=0;n<f;n+=1)a[n]=b[n];return a}function k(b,f,n){function a(a,h){if(a)return n(a,null);if(!h)return n("No data for "+b+".",null);if("string"===typeof h)return n(a,h);n(a,m(h))}b=p.resolve(l,b);"binary"!==f?g.readFile(b,f,a):g.readFile(b,null,a)}var b=this,g=require("fs"),p=require("path"),l="",d,n;this.byteArrayFromString=function(b,f){var n=new Buffer(b,f),a,c=n.length,h=new Uint8Array(new ArrayBuffer(c));
for(a=0;a<c;a+=1)h[a]=n[a];return h};this.byteArrayToString=Runtime.byteArrayToString;this.getVariable=Runtime.getVariable;this.fromJson=Runtime.fromJson;this.toJson=Runtime.toJson;this.readFile=k;this.loadXML=function(n,f){k(n,"utf-8",function(q,a){if(q)return f(q,null);if(!a)return f("No data for "+n+".",null);f(null,b.parseXML(a))})};this.writeFile=function(b,f,n){f=new Buffer(f);b=p.resolve(l,b);g.writeFile(b,f,"binary",function(a){n(a||null)})};this.deleteFile=function(b,f){b=p.resolve(l,b);
g.unlink(b,f)};this.read=function(b,f,n,a){b=p.resolve(l,b);g.open(b,"r+",666,function(c,h){if(c)a(c,null);else{var b=new Buffer(n);g.read(h,b,0,n,f,function(c){g.close(h);a(c,m(b))})}})};this.readFileSync=function(b,n){var d;d=g.readFileSync(b,"binary"===n?null:n);if(null===d)throw"File "+b+" could not be read.";"binary"===n&&(d=m(d));return d};this.isFile=function(b,n){b=p.resolve(l,b);g.stat(b,function(b,a){n(!b&&a.isFile())})};this.getFileSize=function(b,n){b=p.resolve(l,b);g.stat(b,function(b,
a){b?n(-1):n(a.size)})};this.log=function(b,n){var d;void 0!==n?d=b:n=b;"alert"===d&&process.stderr.write("\n!!!!! ALERT !!!!!\n");process.stderr.write(n+"\n");"alert"===d&&process.stderr.write("!!!!! ALERT !!!!!\n")};this.assert=function(b,n,d){b||(process.stderr.write("ASSERTION FAILED: "+n),d&&d())};this.setTimeout=function(b,n){return setTimeout(function(){b()},n)};this.clearTimeout=function(b){clearTimeout(b)};this.libraryPaths=function(){return[__dirname]};this.setCurrentDirectory=function(b){l=
b};this.currentDirectory=function(){return l};this.type=function(){return"NodeJSRuntime"};this.getDOMImplementation=function(){return n};this.parseXML=function(b){return d.parseFromString(b,"text/xml")};this.exit=process.exit;this.getWindow=function(){return null};this.requestAnimationFrame=function(b){return setTimeout(b,15)};this.cancelAnimationFrame=function(b){clearTimeout(b)};d=new (require("xmldom").DOMParser);n=b.parseXML("<a/>").implementation}
function RhinoRuntime(){function m(b,d){var f;void 0!==d?f=b:d=b;"alert"===f&&print("\n!!!!! ALERT !!!!!");print(d);"alert"===f&&print("!!!!! ALERT !!!!!")}var k=this,b={},g=b.javax.xml.parsers.DocumentBuilderFactory.newInstance(),p,l,d="";g.setValidating(!1);g.setNamespaceAware(!0);g.setExpandEntityReferences(!1);g.setSchema(null);l=b.org.xml.sax.EntityResolver({resolveEntity:function(n,d){var f=new b.java.io.FileReader(d);return new b.org.xml.sax.InputSource(f)}});p=g.newDocumentBuilder();p.setEntityResolver(l);
this.byteArrayFromString=function(b,d){var f,p=b.length,a=new Uint8Array(new ArrayBuffer(p));for(f=0;f<p;f+=1)a[f]=b.charCodeAt(f)&255;return a};this.byteArrayToString=Runtime.byteArrayToString;this.getVariable=Runtime.getVariable;this.fromJson=Runtime.fromJson;this.toJson=Runtime.toJson;this.loadXML=function(n,d){var f=new b.java.io.File(n),g=null;try{g=p.parse(f)}catch(a){return print(a),d(a,null)}d(null,g)};this.readFile=function(n,p,f){d&&(n=d+"/"+n);var g=new b.java.io.File(n),a="binary"===p?
"latin1":p;g.isFile()?((n=readFile(n,a))&&"binary"===p&&(n=k.byteArrayFromString(n,"binary")),f(null,n)):f(n+" is not a file.",null)};this.writeFile=function(n,p,f){d&&(n=d+"/"+n);n=new b.java.io.FileOutputStream(n);var g,a=p.length;for(g=0;g<a;g+=1)n.write(p[g]);n.close();f(null)};this.deleteFile=function(n,p){d&&(n=d+"/"+n);var f=new b.java.io.File(n),g=n+Math.random(),g=new b.java.io.File(g);f.rename(g)?(g.deleteOnExit(),p(null)):p("Could not delete "+n)};this.read=function(n,g,f,p){d&&(n=d+"/"+
n);var a;a=n;var c="binary";(new b.java.io.File(a)).isFile()?("binary"===c&&(c="latin1"),a=readFile(a,c)):a=null;a?p(null,this.byteArrayFromString(a.substring(g,g+f),"binary")):p("Cannot read "+n,null)};this.readFileSync=function(b,d){if(!d)return"";var f=readFile(b,d);if(null===f)throw"File could not be read.";return f};this.isFile=function(n,g){d&&(n=d+"/"+n);var f=new b.java.io.File(n);g(f.isFile())};this.getFileSize=function(n,g){d&&(n=d+"/"+n);var f=new b.java.io.File(n);g(f.length())};this.log=
m;this.assert=function(b,d,f){b||(m("alert","ASSERTION FAILED: "+d),f&&f())};this.setTimeout=function(b){b();return 0};this.clearTimeout=function(){};this.libraryPaths=function(){return["lib"]};this.setCurrentDirectory=function(b){d=b};this.currentDirectory=function(){return d};this.type=function(){return"RhinoRuntime"};this.getDOMImplementation=function(){return p.getDOMImplementation()};this.parseXML=function(n){n=new b.java.io.StringReader(n);n=new b.org.xml.sax.InputSource(n);return p.parse(n)};
this.exit=quit;this.getWindow=function(){return null};this.requestAnimationFrame=function(b){b();return 0};this.cancelAnimationFrame=function(){}}Runtime.create=function(){return"undefined"!==String(typeof window)?new BrowserRuntime(window.document.getElementById("logoutput")):"undefined"!==String(typeof require)?new NodeJSRuntime:new RhinoRuntime};var runtime=Runtime.create(),core={},gui={},xmldom={},odf={},ops={};
(function(){function m(b,d,f){var g=b+"/manifest.json",a,c;runtime.log("Loading manifest: "+g);try{a=runtime.readFileSync(g,"utf-8")}catch(h){if(f)runtime.log("No loadable manifest found.");else throw console.log(String(h)),h;return}f=JSON.parse(a);for(c in f)f.hasOwnProperty(c)&&(d[c]={dir:b,deps:f[c]})}function k(b,d,f){function g(b){if(!h[b]&&!f(b)){if(c[b])throw"Circular dependency detected for "+b+".";c[b]=!0;if(!d[b])throw"Missing dependency information for class "+b+".";var n=d[b],p=n.deps,
l,k=p.length;for(l=0;l<k;l+=1)g(p[l]);c[b]=!1;h[b]=!0;a.push(n.dir+"/"+b.replace(".","/")+".js")}}var a=[],c={},h={};b.forEach(g);return a}function b(b,d){return d=d+("\n//# sourceURL="+b)+("\n//@ sourceURL="+b)}function g(n){var d,f;for(d=0;d<n.length;d+=1)f=runtime.readFileSync(n[d],"utf-8"),f=b(n[d],f),eval(f)}function p(b){b=b.split(".");var g,f=d,p=b.length;for(g=0;g<p;g+=1){if(!f.hasOwnProperty(b[g]))return!1;f=f[b[g]]}return!0}var l,d={core:core,gui:gui,xmldom:xmldom,odf:odf,ops:ops};runtime.loadClasses=
function(b,d){if(IS_COMPILED_CODE||0===b.length)return d&&d();var f;if(!(f=l)){f=[];var q=runtime.libraryPaths(),a;runtime.currentDirectory()&&-1===q.indexOf(runtime.currentDirectory())&&m(runtime.currentDirectory(),f,!0);for(a=0;a<q.length;a+=1)m(q[a],f)}l=f;b=k(b,l,p);if(0===b.length)return d&&d();if("BrowserRuntime"===runtime.type()&&d){f=b;q=document.currentScript||document.documentElement.lastChild;a=document.createDocumentFragment();var c,h;for(h=0;h<f.length;h+=1)c=document.createElement("script"),
c.type="text/javascript",c.charset="utf-8",c.async=!1,c.setAttribute("src",f[h]),a.appendChild(c);d&&(c.onload=d);q.parentNode.insertBefore(a,q)}else g(b),d&&d()};runtime.loadClass=function(b,d){runtime.loadClasses([b],d)}})();(function(){var m=function(k){return k};runtime.getTranslator=function(){return m};runtime.setTranslator=function(k){m=k};runtime.tr=function(k){var b=m(k);return b&&"string"===String(typeof b)?b:k}})();
(function(m){function k(b){if(b.length){var g=b[0];runtime.readFile(g,"utf8",function(p,l){function d(){var b;(b=eval(k))&&runtime.exit(b)}var n="",n=g.lastIndexOf("/"),k=l,n=-1!==n?g.substring(0,n):".";runtime.setCurrentDirectory(n);p?(runtime.log(p),runtime.exit(1)):null===k?(runtime.log("No code found for "+g),runtime.exit(1)):d.apply(null,b)})}}m=m?Array.prototype.slice.call(m):[];"NodeJSRuntime"===runtime.type()?k(process.argv.slice(2)):"RhinoRuntime"===runtime.type()?k(m):k(m.slice(1))})("undefined"!==
String(typeof arguments)&&arguments);
// Input 2
(function(){core.Async=function(){return{forEach:function(m,k,b){function g(g){d!==l&&(g?(d=l,b(g)):(d+=1,d===l&&b(null)))}var p,l=m.length,d=0;for(p=0;p<l;p+=1)k(m[p],g)},destroyAll:function(m,k){function b(g,p){if(p)k(p);else if(g<m.length)m[g](function(p){b(g+1,p)});else k()}b(0,void 0)}}}()})();
// Input 3
function makeBase64(){function m(a){var c,b=a.length,h=new Uint8Array(new ArrayBuffer(b));for(c=0;c<b;c+=1)h[c]=a.charCodeAt(c)&255;return h}function k(a){var c,b="",h,e=a.length-2;for(h=0;h<e;h+=3)c=a[h]<<16|a[h+1]<<8|a[h+2],b+="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"[c>>>18],b+="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"[c>>>12&63],b+="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"[c>>>6&63],b+="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"[c&
63];h===e+1?(c=a[h]<<4,b+="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"[c>>>6],b+="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"[c&63],b+="=="):h===e&&(c=a[h]<<10|a[h+1]<<2,b+="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"[c>>>12],b+="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"[c>>>6&63],b+="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"[c&63],b+="=");return b}function b(a){a=a.replace(/[^A-Za-z0-9+\/]+/g,
"");var c=a.length,b=new Uint8Array(new ArrayBuffer(3*c)),h=a.length%4,d=0,g,f;for(g=0;g<c;g+=4)f=(e[a.charAt(g)]||0)<<18|(e[a.charAt(g+1)]||0)<<12|(e[a.charAt(g+2)]||0)<<6|(e[a.charAt(g+3)]||0),b[d]=f>>16,b[d+1]=f>>8&255,b[d+2]=f&255,d+=3;c=3*c-[0,0,2,1][h];return b.subarray(0,c)}function g(a){var c,b,h=a.length,e=0,d=new Uint8Array(new ArrayBuffer(3*h));for(c=0;c<h;c+=1)b=a[c],128>b?d[e++]=b:(2048>b?d[e++]=192|b>>>6:(d[e++]=224|b>>>12&15,d[e++]=128|b>>>6&63),d[e++]=128|b&63);return d.subarray(0,
e)}function p(a){var c,b,h,e,d=a.length,g=new Uint8Array(new ArrayBuffer(d)),f=0;for(c=0;c<d;c+=1)b=a[c],128>b?g[f++]=b:(c+=1,h=a[c],224>b?g[f++]=(b&31)<<6|h&63:(c+=1,e=a[c],g[f++]=(b&15)<<12|(h&63)<<6|e&63));return g.subarray(0,f)}function l(a){return k(m(a))}function d(a){return String.fromCharCode.apply(String,b(a))}function n(a){return p(m(a))}function r(a){a=p(a);for(var c="",b=0;b<a.length;)c+=String.fromCharCode.apply(String,a.subarray(b,b+45E3)),b+=45E3;return c}function f(a,c,b){var h,e,
d,g="";for(d=c;d<b;d+=1)c=a.charCodeAt(d)&255,128>c?g+=String.fromCharCode(c):(d+=1,h=a.charCodeAt(d)&255,224>c?g+=String.fromCharCode((c&31)<<6|h&63):(d+=1,e=a.charCodeAt(d)&255,g+=String.fromCharCode((c&15)<<12|(h&63)<<6|e&63)));return g}function q(a,c){function b(){var d=e+1E5;d>a.length&&(d=a.length);h+=f(a,e,d);e=d;d=e===a.length;c(h,d)&&!d&&runtime.setTimeout(b,0)}var h="",e=0;1E5>a.length?c(f(a,0,a.length),!0):("string"!==typeof a&&(a=a.slice()),b())}function a(a){return g(m(a))}function c(a){return String.fromCharCode.apply(String,
g(a))}function h(a){return String.fromCharCode.apply(String,g(m(a)))}var e=function(a){var c={},b,h;b=0;for(h=a.length;b<h;b+=1)c[a.charAt(b)]=b;return c}("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"),v,w,A=runtime.getWindow(),x,u;A&&A.btoa?(x=A.btoa,v=function(a){return x(h(a))}):(x=l,v=function(c){return k(a(c))});A&&A.atob?(u=A.atob,w=function(a){a=u(a);return f(a,0,a.length)}):(u=d,w=function(a){return r(b(a))});core.Base64=function(){this.convertByteArrayToBase64=this.convertUTF8ArrayToBase64=
k;this.convertBase64ToByteArray=this.convertBase64ToUTF8Array=b;this.convertUTF16ArrayToByteArray=this.convertUTF16ArrayToUTF8Array=g;this.convertByteArrayToUTF16Array=this.convertUTF8ArrayToUTF16Array=p;this.convertUTF8StringToBase64=l;this.convertBase64ToUTF8String=d;this.convertUTF8StringToUTF16Array=n;this.convertByteArrayToUTF16String=this.convertUTF8ArrayToUTF16String=r;this.convertUTF8StringToUTF16String=q;this.convertUTF16StringToByteArray=this.convertUTF16StringToUTF8Array=a;this.convertUTF16ArrayToUTF8String=
c;this.convertUTF16StringToUTF8String=h;this.convertUTF16StringToBase64=v;this.convertBase64ToUTF16String=w;this.fromBase64=d;this.toBase64=l;this.atob=u;this.btoa=x;this.utob=h;this.btou=q;this.encode=v;this.encodeURI=function(a){return v(a).replace(/[+\/]/g,function(a){return"+"===a?"-":"_"}).replace(/\\=+$/,"")};this.decode=function(a){return w(a.replace(/[\-_]/g,function(a){return"-"===a?"+":"/"}))};return this};return core.Base64}core.Base64=makeBase64();
// Input 4
core.ByteArray=function(m){this.pos=0;this.data=m;this.readUInt32LE=function(){this.pos+=4;var k=this.data,b=this.pos;return k[--b]<<24|k[--b]<<16|k[--b]<<8|k[--b]};this.readUInt16LE=function(){this.pos+=2;var k=this.data,b=this.pos;return k[--b]<<8|k[--b]}};
// Input 5
core.ByteArrayWriter=function(m){function k(b){b>p-g&&(p=Math.max(2*p,g+b),b=new Uint8Array(new ArrayBuffer(p)),b.set(l),l=b)}var b=this,g=0,p=1024,l=new Uint8Array(new ArrayBuffer(p));this.appendByteArrayWriter=function(d){b.appendByteArray(d.getByteArray())};this.appendByteArray=function(b){var n=b.length;k(n);l.set(b,g);g+=n};this.appendArray=function(b){var n=b.length;k(n);l.set(b,g);g+=n};this.appendUInt16LE=function(d){b.appendArray([d&255,d>>8&255])};this.appendUInt32LE=function(d){b.appendArray([d&
255,d>>8&255,d>>16&255,d>>24&255])};this.appendString=function(d){b.appendByteArray(runtime.byteArrayFromString(d,m))};this.getLength=function(){return g};this.getByteArray=function(){var b=new Uint8Array(new ArrayBuffer(g));b.set(l.subarray(0,g));return b}};
// Input 6
core.CSSUnits=function(){var m=this,k={"in":1,cm:2.54,mm:25.4,pt:72,pc:12};this.convert=function(b,g,p){return b*k[p]/k[g]};this.convertMeasure=function(b,g){var p,l;b&&g?(p=parseFloat(b),l=b.replace(p.toString(),""),p=m.convert(p,l,g).toString()):p="";return p};this.getUnits=function(b){return b.substr(b.length-2,b.length)}};
// Input 7
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
(function(){function m(){var g,p,l,d,n,k,f,q,a;void 0===b&&(p=(g=runtime.getWindow())&&g.document,k=p.documentElement,f=p.body,b={rangeBCRIgnoresElementBCR:!1,unscaledRangeClientRects:!1,elementBCRIgnoresBodyScroll:!1},p&&(d=p.createElement("div"),d.style.position="absolute",d.style.left="-99999px",d.style.transform="scale(2)",d.style["-webkit-transform"]="scale(2)",n=p.createElement("div"),d.appendChild(n),f.appendChild(d),g=p.createRange(),g.selectNode(n),b.rangeBCRIgnoresElementBCR=0===g.getClientRects().length,
n.appendChild(p.createTextNode("Rect transform test")),p=n.getBoundingClientRect(),l=g.getBoundingClientRect(),b.unscaledRangeClientRects=2<Math.abs(p.height-l.height),d.style.transform="",d.style["-webkit-transform"]="",p=k.style.overflow,l=f.style.overflow,q=f.style.height,a=f.scrollTop,k.style.overflow="visible",f.style.overflow="visible",f.style.height="200%",f.scrollTop=f.scrollHeight,b.elementBCRIgnoresBodyScroll=g.getBoundingClientRect().top!==n.getBoundingClientRect().top,f.scrollTop=a,f.style.height=
q,f.style.overflow=l,k.style.overflow=p,g.detach(),f.removeChild(d),g=Object.keys(b).map(function(a){return a+":"+String(b[a])}).join(", "),runtime.log("Detected browser quirks - "+g)));return b}function k(b,p,k){for(b=b?b.firstElementChild:null;b;){if(b.localName===k&&b.namespaceURI===p)return b;b=b.nextElementSibling}return null}var b;core.DomUtils=function(){function b(a,c){for(var h=0,e;a.parentNode!==c;)runtime.assert(null!==a.parentNode,"parent is null"),a=a.parentNode;for(e=c.firstChild;e!==
a;)h+=1,e=e.nextSibling;return h}function p(a,c){return 0>=a.compareBoundaryPoints(Range.START_TO_START,c)&&0<=a.compareBoundaryPoints(Range.END_TO_END,c)}function l(a,c){var b=null;a.nodeType===Node.TEXT_NODE&&(0===a.length?(a.parentNode.removeChild(a),c.nodeType===Node.TEXT_NODE&&(b=c)):(c.nodeType===Node.TEXT_NODE&&(a.appendData(c.data),c.parentNode.removeChild(c)),b=a));return b}function d(a){for(var c=a.parentNode;a.firstChild;)c.insertBefore(a.firstChild,a);c.removeChild(a);return c}function n(a,
c){for(var b=a.parentNode,e=a.firstChild,g;e;)g=e.nextSibling,n(e,c),e=g;b&&c(a)&&d(a);return b}function r(a,c){return a===c||Boolean(a.compareDocumentPosition(c)&Node.DOCUMENT_POSITION_CONTAINED_BY)}function f(a,c,b){Object.keys(c).forEach(function(e){var d=e.split(":"),g=d[1],n=b(d[0]),d=c[e],p=typeof d;"object"===p?Object.keys(d).length&&(e=n?a.getElementsByTagNameNS(n,g)[0]||a.ownerDocument.createElementNS(n,e):a.getElementsByTagName(g)[0]||a.ownerDocument.createElement(e),a.appendChild(e),f(e,
d,b)):n&&(runtime.assert("number"===p||"string"===p,"attempting to map unsupported type '"+p+"' (key: "+e+")"),a.setAttributeNS(n,e,String(d)))})}var q=null;this.splitBoundaries=function(a){var c,h=[],e,d,f;if(a.startContainer.nodeType===Node.TEXT_NODE||a.endContainer.nodeType===Node.TEXT_NODE){e=a.endContainer;d=a.endContainer.nodeType!==Node.TEXT_NODE?a.endOffset===a.endContainer.childNodes.length:!1;f=a.endOffset;c=a.endContainer;if(f<c.childNodes.length)for(c=c.childNodes.item(f),f=0;c.firstChild;)c=
c.firstChild;else for(;c.lastChild;)c=c.lastChild,f=c.nodeType===Node.TEXT_NODE?c.textContent.length:c.childNodes.length;c===e&&(e=null);a.setEnd(c,f);f=a.endContainer;0!==a.endOffset&&f.nodeType===Node.TEXT_NODE&&(c=f,a.endOffset!==c.length&&(h.push(c.splitText(a.endOffset)),h.push(c)));f=a.startContainer;0!==a.startOffset&&f.nodeType===Node.TEXT_NODE&&(c=f,a.startOffset!==c.length&&(f=c.splitText(a.startOffset),h.push(c),h.push(f),a.setStart(f,0)));if(null!==e){for(f=a.endContainer;f.parentNode&&
f.parentNode!==e;)f=f.parentNode;d=d?e.childNodes.length:b(f,e);a.setEnd(e,d)}}return h};this.containsRange=p;this.rangesIntersect=function(a,c){return 0>=a.compareBoundaryPoints(Range.END_TO_START,c)&&0<=a.compareBoundaryPoints(Range.START_TO_END,c)};this.getNodesInRange=function(a,c,b){var e=[],d=a.commonAncestorContainer;b=a.startContainer.ownerDocument.createTreeWalker(d.nodeType===Node.TEXT_NODE?d.parentNode:d,b,c,!1);var f;a.endContainer.childNodes[a.endOffset-1]?(d=a.endContainer.childNodes[a.endOffset-
1],f=Node.DOCUMENT_POSITION_PRECEDING|Node.DOCUMENT_POSITION_CONTAINED_BY):(d=a.endContainer,f=Node.DOCUMENT_POSITION_PRECEDING);a.startContainer.childNodes[a.startOffset]?(a=a.startContainer.childNodes[a.startOffset],b.currentNode=a):a.startOffset===(a.startContainer.nodeType===Node.TEXT_NODE?a.startContainer.length:a.startContainer.childNodes.length)?(a=a.startContainer,b.currentNode=a,b.lastChild(),a=b.nextNode()):(a=a.startContainer,b.currentNode=a);a&&c(a)===NodeFilter.FILTER_ACCEPT&&e.push(a);
for(a=b.nextNode();a;){c=d.compareDocumentPosition(a);if(0!==c&&0===(c&f))break;e.push(a);a=b.nextNode()}return e};this.normalizeTextNodes=function(a){a&&a.nextSibling&&(a=l(a,a.nextSibling));a&&a.previousSibling&&l(a.previousSibling,a)};this.rangeContainsNode=function(a,c){var b=c.ownerDocument.createRange(),e=c.ownerDocument.createRange(),d;b.setStart(a.startContainer,a.startOffset);b.setEnd(a.endContainer,a.endOffset);e.selectNodeContents(c);d=p(b,e);b.detach();e.detach();return d};this.mergeIntoParent=
d;this.removeUnwantedNodes=n;this.getElementsByTagNameNS=function(a,c,b){var e=[];a=a.getElementsByTagNameNS(c,b);e.length=b=a.length;for(c=0;c<b;c+=1)e[c]=a.item(c);return e};this.containsNode=function(a,c){return a===c||a.contains(c)};this.comparePoints=function(a,c,h,e){if(a===h)return e-c;var d=a.compareDocumentPosition(h);2===d?d=-1:4===d?d=1:10===d?(c=b(a,h),d=c<e?1:-1):(e=b(h,a),d=e<c?-1:1);return d};this.adaptRangeDifferenceToZoomLevel=function(a,c){return m().unscaledRangeClientRects?a:a/
c};this.getBoundingClientRect=function(a){var c=a.ownerDocument,b=m(),e=c.body;if((!1===b.unscaledRangeClientRects||b.rangeBCRIgnoresElementBCR)&&a.nodeType===Node.ELEMENT_NODE)return a=a.getBoundingClientRect(),b.elementBCRIgnoresBodyScroll?{left:a.left+e.scrollLeft,right:a.right+e.scrollLeft,top:a.top+e.scrollTop,bottom:a.bottom+e.scrollTop,width:a.width,height:a.height}:a;var d;q?d=q:q=d=c.createRange();b=d;b.selectNode(a);return b.getBoundingClientRect()};this.mapKeyValObjOntoNode=function(a,
c,b){Object.keys(c).forEach(function(e){var d=e.split(":"),f=d[1],d=b(d[0]),g=c[e];d?(f=a.getElementsByTagNameNS(d,f)[0],f||(f=a.ownerDocument.createElementNS(d,e),a.appendChild(f)),f.textContent=g):runtime.log("Key ignored: "+e)})};this.removeKeyElementsFromNode=function(a,c,b){c.forEach(function(c){var d=c.split(":"),f=d[1];(d=b(d[0]))?(f=a.getElementsByTagNameNS(d,f)[0])?f.parentNode.removeChild(f):runtime.log("Element for "+c+" not found."):runtime.log("Property Name ignored: "+c)})};this.getKeyValRepresentationOfNode=
function(a,c){for(var b={},e=a.firstElementChild,d;e;){if(d=c(e.namespaceURI))b[d+":"+e.localName]=e.textContent;e=e.nextElementSibling}return b};this.mapObjOntoNode=f;this.getDirectChild=k;(function(a){var c,b;b=runtime.getWindow();null!==b&&(c=b.navigator.appVersion.toLowerCase(),b=-1===c.indexOf("chrome")&&(-1!==c.indexOf("applewebkit")||-1!==c.indexOf("safari")),c=c.indexOf("msie"),b||c)&&(a.containsNode=r)})(this)};return core.DomUtils})();
// Input 8
core.Cursor=function(m,k){function b(a){a.parentNode&&(n.push(a.previousSibling),n.push(a.nextSibling),a.parentNode.removeChild(a))}function g(a,c,b){if(c.nodeType===Node.TEXT_NODE){runtime.assert(Boolean(c),"putCursorIntoTextNode: invalid container");var e=c.parentNode;runtime.assert(Boolean(e),"putCursorIntoTextNode: container without parent");runtime.assert(0<=b&&b<=c.length,"putCursorIntoTextNode: offset is out of bounds");0===b?e.insertBefore(a,c):(b!==c.length&&c.splitText(b),e.insertBefore(a,
c.nextSibling))}else c.nodeType===Node.ELEMENT_NODE&&c.insertBefore(a,c.childNodes.item(b));n.push(a.previousSibling);n.push(a.nextSibling)}var p=m.createElementNS("urn:webodf:names:cursor","cursor"),l=m.createElementNS("urn:webodf:names:cursor","anchor"),d,n=[],r=m.createRange(),f,q=new core.DomUtils;this.getNode=function(){return p};this.getAnchorNode=function(){return l.parentNode?l:p};this.getSelectedRange=function(){f?(r.setStartBefore(p),r.collapse(!0)):(r.setStartAfter(d?l:p),r.setEndBefore(d?
p:l));return r};this.setSelectedRange=function(a,c){r&&r!==a&&r.detach();r=a;d=!1!==c;(f=a.collapsed)?(b(l),b(p),g(p,a.startContainer,a.startOffset)):(b(l),b(p),g(d?p:l,a.endContainer,a.endOffset),g(d?l:p,a.startContainer,a.startOffset));n.forEach(q.normalizeTextNodes);n.length=0};this.hasForwardSelection=function(){return d};this.remove=function(){b(p);n.forEach(q.normalizeTextNodes);n.length=0};p.setAttributeNS("urn:webodf:names:cursor","memberId",k);l.setAttributeNS("urn:webodf:names:cursor","memberId",
k)};
// Input 9
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
core.Destroyable=function(){};core.Destroyable.prototype.destroy=function(m){};
// Input 10
/*

 Copyright (C) 2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
core.EventNotifier=function(m){var k={};this.emit=function(b,g){var p,l;runtime.assert(k.hasOwnProperty(b),'unknown event fired "'+b+'"');l=k[b];for(p=0;p<l.length;p+=1)l[p](g)};this.subscribe=function(b,g){runtime.assert(k.hasOwnProperty(b),'tried to subscribe to unknown event "'+b+'"');k[b].push(g)};this.unsubscribe=function(b,g){var p;runtime.assert(k.hasOwnProperty(b),'tried to unsubscribe from unknown event "'+b+'"');p=k[b].indexOf(g);runtime.assert(-1!==p,'tried to unsubscribe unknown callback from event "'+
b+'"');-1!==p&&k[b].splice(p,1)};(function(){var b,g;for(b=0;b<m.length;b+=1)g=m[b],runtime.assert(!k.hasOwnProperty(g),'Duplicated event ids: "'+g+'" registered more than once.'),k[g]=[]})()};
// Input 11
/*

 Copyright (C) 2012 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
core.LoopWatchDog=function(m,k){var b=Date.now(),g=0;this.check=function(){var p;if(m&&(p=Date.now(),p-b>m))throw runtime.log("alert","watchdog timeout"),"timeout!";if(0<k&&(g+=1,g>k))throw runtime.log("alert","watchdog loop overflow"),"loop overflow";}};
// Input 12
core.PositionIterator=function(m,k,b,g){function p(){this.acceptNode=function(a){return!a||a.nodeType===h&&0===a.length?w:v}}function l(a){this.acceptNode=function(c){return!c||c.nodeType===h&&0===c.length?w:a.acceptNode(c)}}function d(){var c=q.currentNode,b=c.nodeType;a=b===h?c.length-1:b===e?1:0}function n(){if(null===q.previousSibling()){if(!q.parentNode()||q.currentNode===m)return q.firstChild(),!1;a=0}else d();return!0}function r(){var b=q.currentNode,h;h=c(b);if(b!==m)for(b=b.parentNode;b&&
b!==m;)c(b)===w&&(q.currentNode=b,h=w),b=b.parentNode;h===w?(a=1,b=f.nextPosition()):b=h===v?!0:f.nextPosition();b&&runtime.assert(c(q.currentNode)===v,"moveToAcceptedNode did not result in walker being on an accepted node");return b}var f=this,q,a,c,h=Node.TEXT_NODE,e=Node.ELEMENT_NODE,v=NodeFilter.FILTER_ACCEPT,w=NodeFilter.FILTER_REJECT;this.nextPosition=function(){var c=q.currentNode,b=c.nodeType;if(c===m)return!1;if(0===a&&b===e)null===q.firstChild()&&(a=1);else if(b===h&&a+1<c.length)a+=1;else if(null!==
q.nextSibling())a=0;else if(q.parentNode())a=1;else return!1;return!0};this.previousPosition=function(){var c=!0,b=q.currentNode;0===a?c=n():b.nodeType===h?a-=1:null!==q.lastChild()?d():b===m?c=!1:a=0;return c};this.previousNode=n;this.container=function(){var c=q.currentNode,b=c.nodeType;0===a&&b!==h&&(c=c.parentNode);return c};this.rightNode=function(){var b=q.currentNode,d=b.nodeType;if(d===h&&a===b.length)for(b=b.nextSibling;b&&c(b)!==v;)b=b.nextSibling;else d===e&&1===a&&(b=null);return b};this.leftNode=
function(){var b=q.currentNode;if(0===a)for(b=b.previousSibling;b&&c(b)!==v;)b=b.previousSibling;else if(b.nodeType===e)for(b=b.lastChild;b&&c(b)!==v;)b=b.previousSibling;return b};this.getCurrentNode=function(){return q.currentNode};this.unfilteredDomOffset=function(){if(q.currentNode.nodeType===h)return a;for(var c=0,b=q.currentNode,b=1===a?b.lastChild:b.previousSibling;b;)c+=1,b=b.previousSibling;return c};this.getPreviousSibling=function(){var a=q.currentNode,c=q.previousSibling();q.currentNode=
a;return c};this.getNextSibling=function(){var a=q.currentNode,c=q.nextSibling();q.currentNode=a;return c};this.setPositionBeforeElement=function(c){runtime.assert(Boolean(c),"setPositionBeforeElement called without element");q.currentNode=c;a=0;return r()};this.setUnfilteredPosition=function(c,b){runtime.assert(Boolean(c),"PositionIterator.setUnfilteredPosition called without container");q.currentNode=c;if(c.nodeType===h)return a=b,runtime.assert(b<=c.length,"Error in setPosition: "+b+" > "+c.length),
runtime.assert(0<=b,"Error in setPosition: "+b+" < 0"),b===c.length&&(q.nextSibling()?a=0:q.parentNode()?a=1:runtime.assert(!1,"Error in setUnfilteredPosition: position not valid.")),!0;b<c.childNodes.length?(q.currentNode=c.childNodes.item(b),a=0):a=1;return r()};this.moveToEnd=function(){q.currentNode=m;a=1};this.moveToEndOfNode=function(c){c.nodeType===h?f.setUnfilteredPosition(c,c.length):(q.currentNode=c,a=1)};this.isBeforeNode=function(){return 0===a};this.getNodeFilter=function(){return c};
c=(b?new l(b):new p).acceptNode;c.acceptNode=c;k=k||NodeFilter.SHOW_ALL;runtime.assert(m.nodeType!==Node.TEXT_NODE,"Internet Explorer doesn't allow tree walker roots to be text nodes");q=m.ownerDocument.createTreeWalker(m,k,c,g);a=0;null===q.firstChild()&&(a=1)};
// Input 13
core.PositionFilter=function(){};core.PositionFilter.FilterResult={FILTER_ACCEPT:1,FILTER_REJECT:2,FILTER_SKIP:3};core.PositionFilter.prototype.acceptPosition=function(m){};(function(){return core.PositionFilter})();
// Input 14
core.PositionFilterChain=function(){var m=[],k=core.PositionFilter.FilterResult.FILTER_ACCEPT,b=core.PositionFilter.FilterResult.FILTER_REJECT;this.acceptPosition=function(g){var p;for(p=0;p<m.length;p+=1)if(m[p].acceptPosition(g)===b)return b;return k};this.addFilter=function(b){m.push(b)}};
// Input 15
core.zip_HuftNode=function(){this.n=this.b=this.e=0;this.t=null};core.zip_HuftList=function(){this.list=this.next=null};
core.RawInflate=function(){function m(a,c,b,h,e,d){this.BMAX=16;this.N_MAX=288;this.status=0;this.root=null;this.m=0;var f=Array(this.BMAX+1),g,n,p,k,l,z,q,m=Array(this.BMAX+1),M,s,F,r=new core.zip_HuftNode,v=Array(this.BMAX);k=Array(this.N_MAX);var u,H=Array(this.BMAX+1),t,w,O;O=this.root=null;for(l=0;l<f.length;l++)f[l]=0;for(l=0;l<m.length;l++)m[l]=0;for(l=0;l<v.length;l++)v[l]=null;for(l=0;l<k.length;l++)k[l]=0;for(l=0;l<H.length;l++)H[l]=0;g=256<c?a[256]:this.BMAX;M=a;s=0;l=c;do f[M[s]]++,s++;
while(0<--l);if(f[0]===c)this.root=null,this.status=this.m=0;else{for(z=1;z<=this.BMAX&&0===f[z];z++);q=z;d<z&&(d=z);for(l=this.BMAX;0!==l&&0===f[l];l--);p=l;d>l&&(d=l);for(t=1<<z;z<l;z++,t<<=1)if(t-=f[z],0>t){this.status=2;this.m=d;return}t-=f[l];if(0>t)this.status=2,this.m=d;else{f[l]+=t;H[1]=z=0;M=f;s=1;for(F=2;0<--l;)z+=M[s++],H[F++]=z;M=a;l=s=0;do z=M[s++],0!==z&&(k[H[z]++]=l);while(++l<c);c=H[p];H[0]=l=0;M=k;s=0;k=-1;u=m[0]=0;F=null;w=0;for(q=q-1+1;q<=p;q++)for(a=f[q];0<a--;){for(;q>u+m[1+k];){u+=
m[1+k];k++;w=p-u;w=w>d?d:w;z=q-u;n=1<<z;if(n>a+1)for(n-=a+1,F=q;++z<w;){n<<=1;if(n<=f[++F])break;n-=f[F]}u+z>g&&u<g&&(z=g-u);w=1<<z;m[1+k]=z;F=Array(w);for(n=0;n<w;n++)F[n]=new core.zip_HuftNode;O=null===O?this.root=new core.zip_HuftList:O.next=new core.zip_HuftList;O.next=null;O.list=F;v[k]=F;0<k&&(H[k]=l,r.b=m[k],r.e=16+z,r.t=F,z=(l&(1<<u)-1)>>u-m[k],v[k-1][z].e=r.e,v[k-1][z].b=r.b,v[k-1][z].n=r.n,v[k-1][z].t=r.t)}r.b=q-u;s>=c?r.e=99:M[s]<b?(r.e=256>M[s]?16:15,r.n=M[s++]):(r.e=e[M[s]-b],r.n=h[M[s++]-
b]);n=1<<q-u;for(z=l>>u;z<w;z+=n)F[z].e=r.e,F[z].b=r.b,F[z].n=r.n,F[z].t=r.t;for(z=1<<q-1;0!==(l&z);z>>=1)l^=z;for(l^=z;(l&(1<<u)-1)!==H[k];)u-=m[k],k--}this.m=m[1];this.status=0!==t&&1!==p?1:0}}}function k(b){for(;c<b;){var h=a,e;e=s.length===z?-1:s[z++];a=h|e<<c;c+=8}}function b(c){return a&H[c]}function g(b){a>>=b;c-=b}function p(a,c,e){var f,l,p;if(0===e)return 0;for(p=0;;){k(u);l=A.list[b(u)];for(f=l.e;16<f;){if(99===f)return-1;g(l.b);f-=16;k(f);l=l.t[b(f)];f=l.e}g(l.b);if(16===f)n&=32767,a[c+
p++]=d[n++]=l.n;else{if(15===f)break;k(f);v=l.n+b(f);g(f);k(t);l=x.list[b(t)];for(f=l.e;16<f;){if(99===f)return-1;g(l.b);f-=16;k(f);l=l.t[b(f)];f=l.e}g(l.b);k(f);w=n-l.n-b(f);for(g(f);0<v&&p<e;)v--,w&=32767,n&=32767,a[c+p++]=d[n++]=d[w++]}if(p===e)return e}h=-1;return p}function l(a,c,h){var e,d,f,l,n,z,q,s=Array(316);for(e=0;e<s.length;e++)s[e]=0;k(5);z=257+b(5);g(5);k(5);q=1+b(5);g(5);k(4);e=4+b(4);g(4);if(286<z||30<q)return-1;for(d=0;d<e;d++)k(3),s[T[d]]=b(3),g(3);for(d=e;19>d;d++)s[T[d]]=0;u=
7;d=new m(s,19,19,null,null,u);if(0!==d.status)return-1;A=d.root;u=d.m;l=z+q;for(e=f=0;e<l;)if(k(u),n=A.list[b(u)],d=n.b,g(d),d=n.n,16>d)s[e++]=f=d;else if(16===d){k(2);d=3+b(2);g(2);if(e+d>l)return-1;for(;0<d--;)s[e++]=f}else{17===d?(k(3),d=3+b(3),g(3)):(k(7),d=11+b(7),g(7));if(e+d>l)return-1;for(;0<d--;)s[e++]=0;f=0}u=9;d=new m(s,z,257,M,O,u);0===u&&(d.status=1);if(0!==d.status)return-1;A=d.root;u=d.m;for(e=0;e<q;e++)s[e]=s[e+z];t=6;d=new m(s,q,0,F,W,t);x=d.root;t=d.m;return 0===t&&257<z||0!==d.status?
-1:p(a,c,h)}var d=[],n,r=null,f,q,a,c,h,e,v,w,A,x,u,t,s,z,H=[0,1,3,7,15,31,63,127,255,511,1023,2047,4095,8191,16383,32767,65535],M=[3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,67,83,99,115,131,163,195,227,258,0,0],O=[0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0,99,99],F=[1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,2049,3073,4097,6145,8193,12289,16385,24577],W=[0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13],T=[16,17,18,0,8,7,9,6,
10,5,11,4,12,3,13,2,14,1,15],Z;this.inflate=function(H,T){d.length=65536;c=a=n=0;h=-1;e=!1;v=w=0;A=null;s=H;z=0;var E=new Uint8Array(new ArrayBuffer(T));a:for(var J=0,I;J<T&&(!e||-1!==h);){if(0<v){if(0!==h)for(;0<v&&J<T;)v--,w&=32767,n&=32767,E[0+J]=d[n]=d[w],J+=1,n+=1,w+=1;else{for(;0<v&&J<T;)v-=1,n&=32767,k(8),E[0+J]=d[n]=b(8),J+=1,n+=1,g(8);0===v&&(h=-1)}if(J===T)break}if(-1===h){if(e)break;k(1);0!==b(1)&&(e=!0);g(1);k(2);h=b(2);g(2);A=null;v=0}switch(h){case 0:I=E;var $=0+J,V=T-J,L=void 0,L=c&
7;g(L);k(16);L=b(16);g(16);k(16);if(L!==(~a&65535))I=-1;else{g(16);v=L;for(L=0;0<v&&L<V;)v--,n&=32767,k(8),I[$+L++]=d[n++]=b(8),g(8);0===v&&(h=-1);I=L}break;case 1:if(null!==A)I=p(E,0+J,T-J);else b:{I=E;$=0+J;V=T-J;if(null===r){for(var y=void 0,L=Array(288),y=void 0,y=0;144>y;y++)L[y]=8;for(y=144;256>y;y++)L[y]=9;for(y=256;280>y;y++)L[y]=7;for(y=280;288>y;y++)L[y]=8;q=7;y=new m(L,288,257,M,O,q);if(0!==y.status){alert("HufBuild error: "+y.status);I=-1;break b}r=y.root;q=y.m;for(y=0;30>y;y++)L[y]=5;
Z=5;y=new m(L,30,0,F,W,Z);if(1<y.status){r=null;alert("HufBuild error: "+y.status);I=-1;break b}f=y.root;Z=y.m}A=r;x=f;u=q;t=Z;I=p(I,$,V)}break;case 2:I=null!==A?p(E,0+J,T-J):l(E,0+J,T-J);break;default:I=-1}if(-1===I)break a;J+=I}s=new Uint8Array(new ArrayBuffer(0));return E}};
// Input 16
core.ScheduledTask=function(m,k){function b(){l&&(runtime.clearTimeout(p),l=!1)}function g(){b();m.apply(void 0,d);d=null}var p,l=!1,d=[];this.trigger=function(){d=Array.prototype.slice.call(arguments);l||(l=!0,p=runtime.setTimeout(g,k))};this.triggerImmediate=function(){d=Array.prototype.slice.call(arguments);g()};this.processRequests=function(){l&&g()};this.cancel=b;this.destroy=function(d){b();d()}};
// Input 17
/*

 Copyright (C) 2014 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
core.StepIterator=function(m,k){function b(){q=null;c=a=void 0}function g(){void 0===c&&(c=m.acceptPosition(k)===f);return c}function p(a,c){b();return k.setUnfilteredPosition(a,c)}function l(){q||(q=k.container());return q}function d(){void 0===a&&(a=k.unfilteredDomOffset());return a}function n(){for(b();k.nextPosition();)if(b(),g())return!0;return!1}function r(){for(b();k.previousPosition();)if(b(),g())return!0;return!1}var f=core.PositionFilter.FilterResult.FILTER_ACCEPT,q,a,c;this.isStep=g;this.setPosition=
p;this.container=l;this.offset=d;this.nextStep=n;this.previousStep=r;this.roundToClosestStep=function(){var a=l(),c=d(),b=g();b||(b=r(),b||(p(a,c),b=n()));return b};this.roundToPreviousStep=function(){var a=g();a||(a=r());return a};this.roundToNextStep=function(){var a=g();a||(a=n());return a}};
// Input 18
core.UnitTest=function(){};core.UnitTest.prototype.setUp=function(){};core.UnitTest.prototype.tearDown=function(){};core.UnitTest.prototype.description=function(){};core.UnitTest.prototype.tests=function(){};core.UnitTest.prototype.asyncTests=function(){};
core.UnitTest.provideTestAreaDiv=function(){var m=runtime.getWindow().document,k=m.getElementById("testarea");runtime.assert(!k,'Unclean test environment, found a div with id "testarea".');k=m.createElement("div");k.setAttribute("id","testarea");m.body.appendChild(k);return k};
core.UnitTest.cleanupTestAreaDiv=function(){var m=runtime.getWindow().document,k=m.getElementById("testarea");runtime.assert(!!k&&k.parentNode===m.body,'Test environment broken, found no div with id "testarea" below body.');m.body.removeChild(k)};core.UnitTest.createOdtDocument=function(m,k){var b="<?xml version='1.0' encoding='UTF-8'?>",b=b+"<office:document";Object.keys(k).forEach(function(g){b+=" xmlns:"+g+'="'+k[g]+'"'});b+=">";b+=m;b+="</office:document>";return runtime.parseXML(b)};
core.UnitTestLogger=function(){var m=[],k=0,b=0,g="",p="";this.startTest=function(l,d){m=[];k=0;g=l;p=d;b=(new Date).getTime()};this.endTest=function(){var l=(new Date).getTime();return{description:p,suite:[g,p],success:0===k,log:m,time:l-b}};this.debug=function(b){m.push({category:"debug",message:b})};this.fail=function(b){k+=1;m.push({category:"fail",message:b})};this.pass=function(b){m.push({category:"pass",message:b})}};
core.UnitTestRunner=function(m,k){function b(c){r+=1;a?k.debug(c):k.fail(c)}function g(a,h){var e;try{if(a.length!==h.length)return b("array of length "+a.length+" should be "+h.length+" long"),!1;for(e=0;e<a.length;e+=1)if(a[e]!==h[e])return b(a[e]+" should be "+h[e]+" at array index "+e),!1}catch(d){return!1}return!0}function p(a,h,e){var d=a.attributes,f=d.length,l,g,n;for(l=0;l<f;l+=1)if(g=d.item(l),"xmlns"!==g.prefix&&"urn:webodf:names:steps"!==g.namespaceURI){n=h.getAttributeNS(g.namespaceURI,
g.localName);if(!h.hasAttributeNS(g.namespaceURI,g.localName))return b("Attribute "+g.localName+" with value "+g.value+" was not present"),!1;if(n!==g.value)return b("Attribute "+g.localName+" was "+n+" should be "+g.value),!1}return e?!0:p(h,a,!0)}function l(a,h){var e,d;e=a.nodeType;d=h.nodeType;if(e!==d)return b("Nodetype '"+e+"' should be '"+d+"'"),!1;if(e===Node.TEXT_NODE){if(a.data===h.data)return!0;b("Textnode data '"+a.data+"' should be '"+h.data+"'");return!1}runtime.assert(e===Node.ELEMENT_NODE,
"Only textnodes and elements supported.");if(a.namespaceURI!==h.namespaceURI)return b("namespace '"+a.namespaceURI+"' should be '"+h.namespaceURI+"'"),!1;if(a.localName!==h.localName)return b("localName '"+a.localName+"' should be '"+h.localName+"'"),!1;if(!p(a,h,!1))return!1;e=a.firstChild;for(d=h.firstChild;e;){if(!d)return b("Nodetype '"+e.nodeType+"' is unexpected here."),!1;if(!l(e,d))return!1;e=e.nextSibling;d=d.nextSibling}return d?(b("Nodetype '"+d.nodeType+"' is missing here."),!1):!0}function d(a,
b){return 0===b?a===b&&1/a===1/b:a===b?!0:null===a||null===b?!1:"number"===typeof b&&isNaN(b)?"number"===typeof a&&isNaN(a):Object.prototype.toString.call(b)===Object.prototype.toString.call([])?g(a,b):"object"===typeof b&&"object"===typeof a?b.constructor===Element||b.constructor===Node?l(a,b):q(a,b):!1}function n(a,h,e){"string"===typeof h&&"string"===typeof e||k.debug("WARN: shouldBe() expects string arguments");var f,g;try{g=eval(h)}catch(l){f=l}a=eval(e);f?b(h+" should be "+a+". Threw exception "+
f):d(g,a)?k.pass(h+" is "+e):String(typeof g)===String(typeof a)?(e=0===g&&0>1/g?"-0":String(g),b(h+" should be "+a+". Was "+e+".")):b(h+" should be "+a+" (of type "+typeof a+"). Was "+g+" (of type "+typeof g+").")}var r=0,f,q,a=!1;this.resourcePrefix=function(){return m};this.beginExpectFail=function(){f=r;a=!0};this.endExpectFail=function(){var c=f===r;a=!1;r=f;c&&(r+=1,k.fail("Expected at least one failed test, but none registered."))};q=function(a,h){var e=Object.keys(a),f=Object.keys(h);e.sort();
f.sort();return g(e,f)&&Object.keys(a).every(function(e){var f=a[e],g=h[e];return d(f,g)?!0:(b(f+" should be "+g+" for key "+e),!1)})};this.areNodesEqual=l;this.shouldBeNull=function(a,b){n(a,b,"null")};this.shouldBeNonNull=function(a,h){var e,d;try{d=eval(h)}catch(f){e=f}e?b(h+" should be non-null. Threw exception "+e):null!==d?k.pass(h+" is non-null."):b(h+" should be non-null. Was "+d)};this.shouldBe=n;this.testFailed=b;this.countFailedTests=function(){return r};this.name=function(a){var b,d,f=
[],g=a.length;f.length=g;for(b=0;b<g;b+=1){d=Runtime.getFunctionName(a[b])||"";if(""===d)throw"Found a function without a name.";f[b]={f:a[b],name:d}}return f}};
core.UnitTester=function(){function m(b,d){return"<span style='color:blue;cursor:pointer' onclick='"+d+"'>"+b+"</span>"}function k(d){b.reporter&&b.reporter(d)}var b=this,g=0,p=new core.UnitTestLogger,l={},d="BrowserRuntime"===runtime.type();this.resourcePrefix="";this.reporter=function(b){var g,f;d?runtime.log("<span>Running "+m(b.description,'runTest("'+b.suite[0]+'","'+b.description+'")')+"</span>"):runtime.log("Running "+b.description);if(!b.success)for(g=0;g<b.log.length;g+=1)f=b.log[g],runtime.log(f.category,
f.message)};this.runTests=function(n,r,f){function q(b){if(0===b.length)l[a]=e,g+=c.countFailedTests(),r();else{w=b[0].f;var d=b[0].name,n=!0===b[0].expectFail;u=c.countFailedTests();f.length&&-1===f.indexOf(d)?q(b.slice(1)):(h.setUp(),p.startTest(a,d),n&&c.beginExpectFail(),w(function(){n&&c.endExpectFail();k(p.endTest());h.tearDown();e[d]=u===c.countFailedTests();q(b.slice(1))}))}}var a=Runtime.getFunctionName(n)||"",c=new core.UnitTestRunner(b.resourcePrefix,p),h=new n(c),e={},v,w,A,x,u;if(l.hasOwnProperty(a))runtime.log("Test "+
a+" has already run.");else{d?runtime.log("<span>Running "+m(a,'runSuite("'+a+'");')+": "+h.description()+"</span>"):runtime.log("Running "+a+": "+h.description);A=h.tests();for(v=0;v<A.length;v+=1)if(w=A[v].f,n=A[v].name,x=!0===A[v].expectFail,!f.length||-1!==f.indexOf(n)){u=c.countFailedTests();h.setUp();p.startTest(a,n);x&&c.beginExpectFail();try{w()}catch(t){c.testFailed("Unexpected exception encountered: "+t.toString()+"\n"+t.stack)}x&&c.endExpectFail();k(p.endTest());h.tearDown();e[n]=u===c.countFailedTests()}q(h.asyncTests())}};
this.countFailedTests=function(){return g};this.results=function(){return l}};
// Input 19
core.Utils=function(){function m(k,b){if(b&&Array.isArray(b)){k=k||[];if(!Array.isArray(k))throw"Destination is not an array.";k=k.concat(b.map(function(b){return m(null,b)}))}else if(b&&"object"===typeof b){k=k||{};if("object"!==typeof k)throw"Destination is not an object.";Object.keys(b).forEach(function(g){k[g]=m(k[g],b[g])})}else k=b;return k}this.hashString=function(k){var b=0,g,p;g=0;for(p=k.length;g<p;g+=1)b=(b<<5)-b+k.charCodeAt(g),b|=0;return b};this.mergeObjects=function(k,b){Object.keys(b).forEach(function(g){k[g]=
m(k[g],b[g])});return k}};
// Input 20
/*

 WebODF
 Copyright (c) 2010 Jos van den Oever
 Licensed under the ... License:

 Project home: http://www.webodf.org/
*/
core.Zip=function(m,k){function b(a){var c=[0,1996959894,3993919788,2567524794,124634137,1886057615,3915621685,2657392035,249268274,2044508324,3772115230,2547177864,162941995,2125561021,3887607047,2428444049,498536548,1789927666,4089016648,2227061214,450548861,1843258603,4107580753,2211677639,325883990,1684777152,4251122042,2321926636,335633487,1661365465,4195302755,2366115317,997073096,1281953886,3579855332,2724688242,1006888145,1258607687,3524101629,2768942443,901097722,1119000684,3686517206,2898065728,
853044451,1172266101,3705015759,2882616665,651767980,1373503546,3369554304,3218104598,565507253,1454621731,3485111705,3099436303,671266974,1594198024,3322730930,2970347812,795835527,1483230225,3244367275,3060149565,1994146192,31158534,2563907772,4023717930,1907459465,112637215,2680153253,3904427059,2013776290,251722036,2517215374,3775830040,2137656763,141376813,2439277719,3865271297,1802195444,476864866,2238001368,4066508878,1812370925,453092731,2181625025,4111451223,1706088902,314042704,2344532202,
4240017532,1658658271,366619977,2362670323,4224994405,1303535960,984961486,2747007092,3569037538,1256170817,1037604311,2765210733,3554079995,1131014506,879679996,2909243462,3663771856,1141124467,855842277,2852801631,3708648649,1342533948,654459306,3188396048,3373015174,1466479909,544179635,3110523913,3462522015,1591671054,702138776,2966460450,3352799412,1504918807,783551873,3082640443,3233442989,3988292384,2596254646,62317068,1957810842,3939845945,2647816111,81470997,1943803523,3814918930,2489596804,
225274430,2053790376,3826175755,2466906013,167816743,2097651377,4027552580,2265490386,503444072,1762050814,4150417245,2154129355,426522225,1852507879,4275313526,2312317920,282753626,1742555852,4189708143,2394877945,397917763,1622183637,3604390888,2714866558,953729732,1340076626,3518719985,2797360999,1068828381,1219638859,3624741850,2936675148,906185462,1090812512,3747672003,2825379669,829329135,1181335161,3412177804,3160834842,628085408,1382605366,3423369109,3138078467,570562233,1426400815,3317316542,
2998733608,733239954,1555261956,3268935591,3050360625,752459403,1541320221,2607071920,3965973030,1969922972,40735498,2617837225,3943577151,1913087877,83908371,2512341634,3803740692,2075208622,213261112,2463272603,3855990285,2094854071,198958881,2262029012,4057260610,1759359992,534414190,2176718541,4139329115,1873836001,414664567,2282248934,4279200368,1711684554,285281116,2405801727,4167216745,1634467795,376229701,2685067896,3608007406,1308918612,956543938,2808555105,3495958263,1231636301,1047427035,
2932959818,3654703836,1088359270,936918E3,2847714899,3736837829,1202900863,817233897,3183342108,3401237130,1404277552,615818150,3134207493,3453421203,1423857449,601450431,3009837614,3294710456,1567103746,711928724,3020668471,3272380065,1510334235,755167117],b,h,d=a.length,e=0,e=0;b=-1;for(h=0;h<d;h+=1)e=(b^a[h])&255,e=c[e],b=b>>>8^e;return b^-1}function g(a){return new Date((a>>25&127)+1980,(a>>21&15)-1,a>>16&31,a>>11&15,a>>5&63,(a&31)<<1)}function p(a){var c=a.getFullYear();return 1980>c?0:c-1980<<
25|a.getMonth()+1<<21|a.getDate()<<16|a.getHours()<<11|a.getMinutes()<<5|a.getSeconds()>>1}function l(a,c){var b,h,d,f,l,n,p,k=this;this.load=function(c){if(null!==k.data)c(null,k.data);else{var b=l+34+h+d+256;b+p>e&&(b=e-p);runtime.read(a,p,b,function(b,h){if(b||null===h)c(b,h);else a:{var d=h,e=new core.ByteArray(d),g=e.readUInt32LE(),p;if(67324752!==g)c("File entry signature is wrong."+g.toString()+" "+d.length.toString(),null);else{e.pos+=22;g=e.readUInt16LE();p=e.readUInt16LE();e.pos+=g+p;if(f){d=
d.subarray(e.pos,e.pos+l);if(l!==d.length){c("The amount of compressed bytes read was "+d.length.toString()+" instead of "+l.toString()+" for "+k.filename+" in "+a+".",null);break a}d=w(d,n)}else d=d.subarray(e.pos,e.pos+n);n!==d.length?c("The amount of bytes read was "+d.length.toString()+" instead of "+n.toString()+" for "+k.filename+" in "+a+".",null):(k.data=d,c(null,d))}}})}};this.set=function(a,c,b,d){k.filename=a;k.data=c;k.compressed=b;k.date=d};this.error=null;c&&(b=c.readUInt32LE(),33639248!==
b?this.error="Central directory entry has wrong signature at position "+(c.pos-4).toString()+' for file "'+a+'": '+c.data.length.toString():(c.pos+=6,f=c.readUInt16LE(),this.date=g(c.readUInt32LE()),c.readUInt32LE(),l=c.readUInt32LE(),n=c.readUInt32LE(),h=c.readUInt16LE(),d=c.readUInt16LE(),b=c.readUInt16LE(),c.pos+=8,p=c.readUInt32LE(),this.filename=runtime.byteArrayToString(c.data.subarray(c.pos,c.pos+h),"utf8"),this.data=null,c.pos+=h+d+b))}function d(a,c){if(22!==a.length)c("Central directory length should be 22.",
A);else{var b=new core.ByteArray(a),d;d=b.readUInt32LE();101010256!==d?c("Central directory signature is wrong: "+d.toString(),A):(d=b.readUInt16LE(),0!==d?c("Zip files with non-zero disk numbers are not supported.",A):(d=b.readUInt16LE(),0!==d?c("Zip files with non-zero disk numbers are not supported.",A):(d=b.readUInt16LE(),v=b.readUInt16LE(),d!==v?c("Number of entries is inconsistent.",A):(d=b.readUInt32LE(),b=b.readUInt16LE(),b=e-22-d,runtime.read(m,b,e-b,function(a,b){if(a||null===b)c(a,A);else a:{var d=
new core.ByteArray(b),e,f;h=[];for(e=0;e<v;e+=1){f=new l(m,d);if(f.error){c(f.error,A);break a}h[h.length]=f}c(null,A)}})))))}}function n(a,c){var b=null,d,e;for(e=0;e<h.length;e+=1)if(d=h[e],d.filename===a){b=d;break}b?b.data?c(null,b.data):b.load(c):c(a+" not found.",null)}function r(a){var c=new core.ByteArrayWriter("utf8"),d=0;c.appendArray([80,75,3,4,20,0,0,0,0,0]);a.data&&(d=a.data.length);c.appendUInt32LE(p(a.date));c.appendUInt32LE(a.data?b(a.data):0);c.appendUInt32LE(d);c.appendUInt32LE(d);
c.appendUInt16LE(a.filename.length);c.appendUInt16LE(0);c.appendString(a.filename);a.data&&c.appendByteArray(a.data);return c}function f(a,c){var d=new core.ByteArrayWriter("utf8"),h=0;d.appendArray([80,75,1,2,20,0,20,0,0,0,0,0]);a.data&&(h=a.data.length);d.appendUInt32LE(p(a.date));d.appendUInt32LE(a.data?b(a.data):0);d.appendUInt32LE(h);d.appendUInt32LE(h);d.appendUInt16LE(a.filename.length);d.appendArray([0,0,0,0,0,0,0,0,0,0,0,0]);d.appendUInt32LE(c);d.appendString(a.filename);return d}function q(a,
c){if(a===h.length)c(null);else{var b=h[a];null!==b.data?q(a+1,c):b.load(function(b){b?c(b):q(a+1,c)})}}function a(a,c){q(0,function(b){if(b)c(b);else{var d,e,g=new core.ByteArrayWriter("utf8"),l=[0];for(d=0;d<h.length;d+=1)g.appendByteArrayWriter(r(h[d])),l.push(g.getLength());b=g.getLength();for(d=0;d<h.length;d+=1)e=h[d],g.appendByteArrayWriter(f(e,l[d]));d=g.getLength()-b;g.appendArray([80,75,5,6,0,0,0,0]);g.appendUInt16LE(h.length);g.appendUInt16LE(h.length);g.appendUInt32LE(d);g.appendUInt32LE(b);
g.appendArray([0,0]);a(g.getByteArray())}})}function c(c,b){a(function(a){runtime.writeFile(c,a,b)},b)}var h,e,v,w=(new core.RawInflate).inflate,A=this,x=new core.Base64;this.load=n;this.save=function(a,c,b,d){var e,f;for(e=0;e<h.length;e+=1)if(f=h[e],f.filename===a){f.set(a,c,b,d);return}f=new l(m);f.set(a,c,b,d);h.push(f)};this.remove=function(a){var c,b;for(c=0;c<h.length;c+=1)if(b=h[c],b.filename===a)return h.splice(c,1),!0;return!1};this.write=function(a){c(m,a)};this.writeAs=c;this.createByteArray=
a;this.loadContentXmlAsFragments=function(a,c){A.loadAsString(a,function(a,b){if(a)return c.rootElementReady(a);c.rootElementReady(null,b,!0)})};this.loadAsString=function(a,c){n(a,function(a,b){if(a||null===b)return c(a,null);var d=runtime.byteArrayToString(b,"utf8");c(null,d)})};this.loadAsDOM=function(a,c){A.loadAsString(a,function(a,b){if(a||null===b)c(a,null);else{var d=(new DOMParser).parseFromString(b,"text/xml");c(null,d)}})};this.loadAsDataURL=function(a,c,b){n(a,function(a,d){if(a||!d)return b(a,
null);var e=0,h;c||(c=80===d[1]&&78===d[2]&&71===d[3]?"image/png":255===d[0]&&216===d[1]&&255===d[2]?"image/jpeg":71===d[0]&&73===d[1]&&70===d[2]?"image/gif":"");for(h="data:"+c+";base64,";e<d.length;)h+=x.convertUTF8ArrayToBase64(d.subarray(e,Math.min(e+45E3,d.length))),e+=45E3;b(null,h)})};this.getEntries=function(){return h.slice()};e=-1;null===k?h=[]:runtime.getFileSize(m,function(a){e=a;0>e?k("File '"+m+"' cannot be read.",A):runtime.read(m,e-22,22,function(a,c){a||null===k||null===c?k(a,A):
d(c,k)})})};
// Input 21
xmldom.LSSerializerFilter=function(){};xmldom.LSSerializerFilter.prototype.acceptNode=function(m){};
// Input 22
/*

 Copyright (C) 2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
odf.OdfNodeFilter=function(){this.acceptNode=function(m){return"http://www.w3.org/1999/xhtml"===m.namespaceURI?NodeFilter.FILTER_SKIP:m.namespaceURI&&m.namespaceURI.match(/^urn:webodf:/)?NodeFilter.FILTER_REJECT:NodeFilter.FILTER_ACCEPT}};
// Input 23
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
odf.Namespaces={namespaceMap:{db:"urn:oasis:names:tc:opendocument:xmlns:database:1.0",dc:"http://purl.org/dc/elements/1.1/",dr3d:"urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0",draw:"urn:oasis:names:tc:opendocument:xmlns:drawing:1.0",chart:"urn:oasis:names:tc:opendocument:xmlns:chart:1.0",fo:"urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0",form:"urn:oasis:names:tc:opendocument:xmlns:form:1.0",meta:"urn:oasis:names:tc:opendocument:xmlns:meta:1.0",number:"urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0",
office:"urn:oasis:names:tc:opendocument:xmlns:office:1.0",presentation:"urn:oasis:names:tc:opendocument:xmlns:presentation:1.0",style:"urn:oasis:names:tc:opendocument:xmlns:style:1.0",svg:"urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0",table:"urn:oasis:names:tc:opendocument:xmlns:table:1.0",text:"urn:oasis:names:tc:opendocument:xmlns:text:1.0",xlink:"http://www.w3.org/1999/xlink",xml:"http://www.w3.org/XML/1998/namespace"},prefixMap:{},dbns:"urn:oasis:names:tc:opendocument:xmlns:database:1.0",
dcns:"http://purl.org/dc/elements/1.1/",dr3dns:"urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0",drawns:"urn:oasis:names:tc:opendocument:xmlns:drawing:1.0",chartns:"urn:oasis:names:tc:opendocument:xmlns:chart:1.0",fons:"urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0",formns:"urn:oasis:names:tc:opendocument:xmlns:form:1.0",metans:"urn:oasis:names:tc:opendocument:xmlns:meta:1.0",numberns:"urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0",officens:"urn:oasis:names:tc:opendocument:xmlns:office:1.0",
presentationns:"urn:oasis:names:tc:opendocument:xmlns:presentation:1.0",stylens:"urn:oasis:names:tc:opendocument:xmlns:style:1.0",svgns:"urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0",tablens:"urn:oasis:names:tc:opendocument:xmlns:table:1.0",textns:"urn:oasis:names:tc:opendocument:xmlns:text:1.0",xlinkns:"http://www.w3.org/1999/xlink",xmlns:"http://www.w3.org/XML/1998/namespace"};
(function(){var m=odf.Namespaces.namespaceMap,k=odf.Namespaces.prefixMap,b;for(b in m)m.hasOwnProperty(b)&&(k[m[b]]=b)})();odf.Namespaces.forEachPrefix=function(m){var k=odf.Namespaces.namespaceMap,b;for(b in k)k.hasOwnProperty(b)&&m(b,k[b])};odf.Namespaces.lookupNamespaceURI=function(m){var k=null;odf.Namespaces.namespaceMap.hasOwnProperty(m)&&(k=odf.Namespaces.namespaceMap[m]);return k};odf.Namespaces.lookupPrefix=function(m){var k=odf.Namespaces.prefixMap;return k.hasOwnProperty(m)?k[m]:null};
odf.Namespaces.lookupNamespaceURI.lookupNamespaceURI=odf.Namespaces.lookupNamespaceURI;
// Input 24
xmldom.XPathIterator=function(){};xmldom.XPathIterator.prototype.next=function(){};xmldom.XPathIterator.prototype.reset=function(){};
function createXPathSingleton(){function m(b,a,c){return-1!==b&&(b<a||-1===a)&&(b<c||-1===c)}function k(b){for(var a=[],c=0,d=b.length,e;c<d;){var g=b,l=d,n=a,p="",k=[],r=g.indexOf("[",c),s=g.indexOf("/",c),z=g.indexOf("=",c);m(s,r,z)?(p=g.substring(c,s),c=s+1):m(r,s,z)?(p=g.substring(c,r),c=f(g,r,k)):m(z,s,r)?(p=g.substring(c,z),c=z):(p=g.substring(c,l),c=l);n.push({location:p,predicates:k});if(c<d&&"="===b[c]){e=b.substring(c+1,d);if(2<e.length&&("'"===e[0]||'"'===e[0]))e=e.slice(1,e.length-1);
else try{e=parseInt(e,10)}catch(H){}c=d}}return{steps:a,value:e}}function b(){var b=null,a=!1;this.setNode=function(a){b=a};this.reset=function(){a=!1};this.next=function(){var c=a?null:b;a=!0;return c}}function g(b,a,c){this.reset=function(){b.reset()};this.next=function(){for(var d=b.next();d;){d.nodeType===Node.ELEMENT_NODE&&(d=d.getAttributeNodeNS(a,c));if(d)break;d=b.next()}return d}}function p(b,a){var c=b.next(),d=null;this.reset=function(){b.reset();c=b.next();d=null};this.next=function(){for(;c;){if(d)if(a&&
d.firstChild)d=d.firstChild;else{for(;!d.nextSibling&&d!==c;)d=d.parentNode;d===c?c=b.next():d=d.nextSibling}else{do(d=c.firstChild)||(c=b.next());while(c&&!d)}if(d&&d.nodeType===Node.ELEMENT_NODE)return d}return null}}function l(b,a){this.reset=function(){b.reset()};this.next=function(){for(var c=b.next();c&&!a(c);)c=b.next();return c}}function d(b,a,c){a=a.split(":",2);var d=c(a[0]),e=a[1];return new l(b,function(a){return a.localName===e&&a.namespaceURI===d})}function n(d,a,c){var h=new b,e=r(h,
a,c),f=a.value;return void 0===f?new l(d,function(a){h.setNode(a);e.reset();return null!==e.next()}):new l(d,function(a){h.setNode(a);e.reset();return(a=e.next())?a.nodeValue===f:!1})}var r,f;f=function(b,a,c){for(var d=a,e=b.length,f=0;d<e;)"]"===b[d]?(f-=1,0>=f&&c.push(k(b.substring(a,d)))):"["===b[d]&&(0>=f&&(a=d+1),f+=1),d+=1;return d};r=function(b,a,c){var h,e,f,l;for(h=0;h<a.steps.length;h+=1){f=a.steps[h];e=f.location;if(""===e)b=new p(b,!1);else if("@"===e[0]){e=e.substr(1).split(":",2);l=
c(e[0]);if(!l)throw"No namespace associated with the prefix "+e[0];b=new g(b,l,e[1])}else"."!==e&&(b=new p(b,!1),-1!==e.indexOf(":")&&(b=d(b,e,c)));for(e=0;e<f.predicates.length;e+=1)l=f.predicates[e],b=n(b,l,c)}return b};return{getODFElementsWithXPath:function(d,a,c){var h=d.ownerDocument,e=[],f=null;if(h&&"function"===typeof h.evaluate)for(c=h.evaluate(a,d,c,XPathResult.UNORDERED_NODE_ITERATOR_TYPE,null),f=c.iterateNext();null!==f;)f.nodeType===Node.ELEMENT_NODE&&e.push(f),f=c.iterateNext();else{e=
new b;e.setNode(d);d=k(a);e=r(e,d,c);d=[];for(c=e.next();c;)d.push(c),c=e.next();e=d}return e}}}xmldom.XPath=createXPathSingleton();
// Input 25
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
odf.StyleInfo=function(){function m(a,c){var b,d,e,h,f,g=0;if(b=M[a.localName])if(e=b[a.namespaceURI])g=e.length;for(b=0;b<g;b+=1)d=e[b],h=d.ns,f=d.localname,(d=a.getAttributeNS(h,f))&&a.setAttributeNS(h,z[h]+f,c+d);for(e=a.firstElementChild;e;)m(e,c),e=e.nextElementSibling}function k(a,c){var b,d,e,h,f,g=0;if(b=M[a.localName])if(e=b[a.namespaceURI])g=e.length;for(b=0;b<g;b+=1)if(d=e[b],h=d.ns,f=d.localname,d=a.getAttributeNS(h,f))d=d.replace(c,""),a.setAttributeNS(h,z[h]+f,d);for(e=a.firstElementChild;e;)k(e,
c),e=e.nextElementSibling}function b(a,b){var c,d,e,h,f,g=0;if(c=M[a.localName])if(e=c[a.namespaceURI])g=e.length;for(c=0;c<g;c+=1)if(h=e[c],d=h.ns,f=h.localname,d=a.getAttributeNS(d,f))b=b||{},h=h.keyname,b.hasOwnProperty(h)?b[h][d]=1:(f={},f[d]=1,b[h]=f);return b}function g(a,c){var d,e;b(a,c);for(d=a.firstChild;d;)d.nodeType===Node.ELEMENT_NODE&&(e=d,g(e,c)),d=d.nextSibling}function p(a,b,c){this.key=a;this.name=b;this.family=c;this.requires={}}function l(a,b,c){var d=a+'"'+b,e=c[d];e||(e=c[d]=
new p(d,a,b));return e}function d(a,b,c){var e,h,f,g,n,p=0;e=a.getAttributeNS(u,"name");g=a.getAttributeNS(u,"family");e&&g&&(b=l(e,g,c));if(b){if(e=M[a.localName])if(f=e[a.namespaceURI])p=f.length;for(e=0;e<p;e+=1)if(g=f[e],h=g.ns,n=g.localname,h=a.getAttributeNS(h,n))g=g.keyname,g=l(h,g,c),b.requires[g.key]=g}for(a=a.firstElementChild;a;)d(a,b,c),a=a.nextElementSibling;return c}function n(a,b){var c=b[a.family];c||(c=b[a.family]={});c[a.name]=1;Object.keys(a.requires).forEach(function(c){n(a.requires[c],
b)})}function r(a,c){var b=d(a,null,{});Object.keys(b).forEach(function(a){a=b[a];var d=c[a.family];d&&d.hasOwnProperty(a.name)&&n(a,c)})}function f(a,c){function b(c){(c=h.getAttributeNS(u,c))&&(a[c]=!0)}var d=["font-name","font-name-asian","font-name-complex"],e,h;for(e=c&&c.firstElementChild;e;)h=e,d.forEach(b),f(a,h),e=e.nextElementSibling}function q(a,c){function b(a){var d=h.getAttributeNS(u,a);d&&c.hasOwnProperty(d)&&h.setAttributeNS(u,"style:"+a,c[d])}var d=["font-name","font-name-asian",
"font-name-complex"],e,h;for(e=a&&a.firstElementChild;e;)h=e,d.forEach(b),q(h,c),e=e.nextElementSibling}var a=odf.Namespaces.chartns,c=odf.Namespaces.dbns,h=odf.Namespaces.dr3dns,e=odf.Namespaces.drawns,v=odf.Namespaces.formns,w=odf.Namespaces.numberns,A=odf.Namespaces.officens,x=odf.Namespaces.presentationns,u=odf.Namespaces.stylens,t=odf.Namespaces.tablens,s=odf.Namespaces.textns,z={"urn:oasis:names:tc:opendocument:xmlns:chart:1.0":"chart:","urn:oasis:names:tc:opendocument:xmlns:database:1.0":"db:",
"urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0":"dr3d:","urn:oasis:names:tc:opendocument:xmlns:drawing:1.0":"draw:","urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0":"fo:","urn:oasis:names:tc:opendocument:xmlns:form:1.0":"form:","urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0":"number:","urn:oasis:names:tc:opendocument:xmlns:office:1.0":"office:","urn:oasis:names:tc:opendocument:xmlns:presentation:1.0":"presentation:","urn:oasis:names:tc:opendocument:xmlns:style:1.0":"style:","urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0":"svg:",
"urn:oasis:names:tc:opendocument:xmlns:table:1.0":"table:","urn:oasis:names:tc:opendocument:xmlns:text:1.0":"chart:","http://www.w3.org/XML/1998/namespace":"xml:"},H={text:[{ens:u,en:"tab-stop",ans:u,a:"leader-text-style"},{ens:u,en:"drop-cap",ans:u,a:"style-name"},{ens:s,en:"notes-configuration",ans:s,a:"citation-body-style-name"},{ens:s,en:"notes-configuration",ans:s,a:"citation-style-name"},{ens:s,en:"a",ans:s,a:"style-name"},{ens:s,en:"alphabetical-index",ans:s,a:"style-name"},{ens:s,en:"linenumbering-configuration",
ans:s,a:"style-name"},{ens:s,en:"list-level-style-number",ans:s,a:"style-name"},{ens:s,en:"ruby-text",ans:s,a:"style-name"},{ens:s,en:"span",ans:s,a:"style-name"},{ens:s,en:"a",ans:s,a:"visited-style-name"},{ens:u,en:"text-properties",ans:u,a:"text-line-through-text-style"},{ens:s,en:"alphabetical-index-source",ans:s,a:"main-entry-style-name"},{ens:s,en:"index-entry-bibliography",ans:s,a:"style-name"},{ens:s,en:"index-entry-chapter",ans:s,a:"style-name"},{ens:s,en:"index-entry-link-end",ans:s,a:"style-name"},
{ens:s,en:"index-entry-link-start",ans:s,a:"style-name"},{ens:s,en:"index-entry-page-number",ans:s,a:"style-name"},{ens:s,en:"index-entry-span",ans:s,a:"style-name"},{ens:s,en:"index-entry-tab-stop",ans:s,a:"style-name"},{ens:s,en:"index-entry-text",ans:s,a:"style-name"},{ens:s,en:"index-title-template",ans:s,a:"style-name"},{ens:s,en:"list-level-style-bullet",ans:s,a:"style-name"},{ens:s,en:"outline-level-style",ans:s,a:"style-name"}],paragraph:[{ens:e,en:"caption",ans:e,a:"text-style-name"},{ens:e,
en:"circle",ans:e,a:"text-style-name"},{ens:e,en:"connector",ans:e,a:"text-style-name"},{ens:e,en:"control",ans:e,a:"text-style-name"},{ens:e,en:"custom-shape",ans:e,a:"text-style-name"},{ens:e,en:"ellipse",ans:e,a:"text-style-name"},{ens:e,en:"frame",ans:e,a:"text-style-name"},{ens:e,en:"line",ans:e,a:"text-style-name"},{ens:e,en:"measure",ans:e,a:"text-style-name"},{ens:e,en:"path",ans:e,a:"text-style-name"},{ens:e,en:"polygon",ans:e,a:"text-style-name"},{ens:e,en:"polyline",ans:e,a:"text-style-name"},
{ens:e,en:"rect",ans:e,a:"text-style-name"},{ens:e,en:"regular-polygon",ans:e,a:"text-style-name"},{ens:A,en:"annotation",ans:e,a:"text-style-name"},{ens:v,en:"column",ans:v,a:"text-style-name"},{ens:u,en:"style",ans:u,a:"next-style-name"},{ens:t,en:"body",ans:t,a:"paragraph-style-name"},{ens:t,en:"even-columns",ans:t,a:"paragraph-style-name"},{ens:t,en:"even-rows",ans:t,a:"paragraph-style-name"},{ens:t,en:"first-column",ans:t,a:"paragraph-style-name"},{ens:t,en:"first-row",ans:t,a:"paragraph-style-name"},
{ens:t,en:"last-column",ans:t,a:"paragraph-style-name"},{ens:t,en:"last-row",ans:t,a:"paragraph-style-name"},{ens:t,en:"odd-columns",ans:t,a:"paragraph-style-name"},{ens:t,en:"odd-rows",ans:t,a:"paragraph-style-name"},{ens:s,en:"notes-configuration",ans:s,a:"default-style-name"},{ens:s,en:"alphabetical-index-entry-template",ans:s,a:"style-name"},{ens:s,en:"bibliography-entry-template",ans:s,a:"style-name"},{ens:s,en:"h",ans:s,a:"style-name"},{ens:s,en:"illustration-index-entry-template",ans:s,a:"style-name"},
{ens:s,en:"index-source-style",ans:s,a:"style-name"},{ens:s,en:"object-index-entry-template",ans:s,a:"style-name"},{ens:s,en:"p",ans:s,a:"style-name"},{ens:s,en:"table-index-entry-template",ans:s,a:"style-name"},{ens:s,en:"table-of-content-entry-template",ans:s,a:"style-name"},{ens:s,en:"table-index-entry-template",ans:s,a:"style-name"},{ens:s,en:"user-index-entry-template",ans:s,a:"style-name"},{ens:u,en:"page-layout-properties",ans:u,a:"register-truth-ref-style-name"}],chart:[{ens:a,en:"axis",ans:a,
a:"style-name"},{ens:a,en:"chart",ans:a,a:"style-name"},{ens:a,en:"data-label",ans:a,a:"style-name"},{ens:a,en:"data-point",ans:a,a:"style-name"},{ens:a,en:"equation",ans:a,a:"style-name"},{ens:a,en:"error-indicator",ans:a,a:"style-name"},{ens:a,en:"floor",ans:a,a:"style-name"},{ens:a,en:"footer",ans:a,a:"style-name"},{ens:a,en:"grid",ans:a,a:"style-name"},{ens:a,en:"legend",ans:a,a:"style-name"},{ens:a,en:"mean-value",ans:a,a:"style-name"},{ens:a,en:"plot-area",ans:a,a:"style-name"},{ens:a,en:"regression-curve",
ans:a,a:"style-name"},{ens:a,en:"series",ans:a,a:"style-name"},{ens:a,en:"stock-gain-marker",ans:a,a:"style-name"},{ens:a,en:"stock-loss-marker",ans:a,a:"style-name"},{ens:a,en:"stock-range-line",ans:a,a:"style-name"},{ens:a,en:"subtitle",ans:a,a:"style-name"},{ens:a,en:"title",ans:a,a:"style-name"},{ens:a,en:"wall",ans:a,a:"style-name"}],section:[{ens:s,en:"alphabetical-index",ans:s,a:"style-name"},{ens:s,en:"bibliography",ans:s,a:"style-name"},{ens:s,en:"illustration-index",ans:s,a:"style-name"},
{ens:s,en:"index-title",ans:s,a:"style-name"},{ens:s,en:"object-index",ans:s,a:"style-name"},{ens:s,en:"section",ans:s,a:"style-name"},{ens:s,en:"table-of-content",ans:s,a:"style-name"},{ens:s,en:"table-index",ans:s,a:"style-name"},{ens:s,en:"user-index",ans:s,a:"style-name"}],ruby:[{ens:s,en:"ruby",ans:s,a:"style-name"}],table:[{ens:c,en:"query",ans:c,a:"style-name"},{ens:c,en:"table-representation",ans:c,a:"style-name"},{ens:t,en:"background",ans:t,a:"style-name"},{ens:t,en:"table",ans:t,a:"style-name"}],
"table-column":[{ens:c,en:"column",ans:c,a:"style-name"},{ens:t,en:"table-column",ans:t,a:"style-name"}],"table-row":[{ens:c,en:"query",ans:c,a:"default-row-style-name"},{ens:c,en:"table-representation",ans:c,a:"default-row-style-name"},{ens:t,en:"table-row",ans:t,a:"style-name"}],"table-cell":[{ens:c,en:"column",ans:c,a:"default-cell-style-name"},{ens:t,en:"table-column",ans:t,a:"default-cell-style-name"},{ens:t,en:"table-row",ans:t,a:"default-cell-style-name"},{ens:t,en:"body",ans:t,a:"style-name"},
{ens:t,en:"covered-table-cell",ans:t,a:"style-name"},{ens:t,en:"even-columns",ans:t,a:"style-name"},{ens:t,en:"covered-table-cell",ans:t,a:"style-name"},{ens:t,en:"even-columns",ans:t,a:"style-name"},{ens:t,en:"even-rows",ans:t,a:"style-name"},{ens:t,en:"first-column",ans:t,a:"style-name"},{ens:t,en:"first-row",ans:t,a:"style-name"},{ens:t,en:"last-column",ans:t,a:"style-name"},{ens:t,en:"last-row",ans:t,a:"style-name"},{ens:t,en:"odd-columns",ans:t,a:"style-name"},{ens:t,en:"odd-rows",ans:t,a:"style-name"},
{ens:t,en:"table-cell",ans:t,a:"style-name"}],graphic:[{ens:h,en:"cube",ans:e,a:"style-name"},{ens:h,en:"extrude",ans:e,a:"style-name"},{ens:h,en:"rotate",ans:e,a:"style-name"},{ens:h,en:"scene",ans:e,a:"style-name"},{ens:h,en:"sphere",ans:e,a:"style-name"},{ens:e,en:"caption",ans:e,a:"style-name"},{ens:e,en:"circle",ans:e,a:"style-name"},{ens:e,en:"connector",ans:e,a:"style-name"},{ens:e,en:"control",ans:e,a:"style-name"},{ens:e,en:"custom-shape",ans:e,a:"style-name"},{ens:e,en:"ellipse",ans:e,a:"style-name"},
{ens:e,en:"frame",ans:e,a:"style-name"},{ens:e,en:"g",ans:e,a:"style-name"},{ens:e,en:"line",ans:e,a:"style-name"},{ens:e,en:"measure",ans:e,a:"style-name"},{ens:e,en:"page-thumbnail",ans:e,a:"style-name"},{ens:e,en:"path",ans:e,a:"style-name"},{ens:e,en:"polygon",ans:e,a:"style-name"},{ens:e,en:"polyline",ans:e,a:"style-name"},{ens:e,en:"rect",ans:e,a:"style-name"},{ens:e,en:"regular-polygon",ans:e,a:"style-name"},{ens:A,en:"annotation",ans:e,a:"style-name"}],presentation:[{ens:h,en:"cube",ans:x,
a:"style-name"},{ens:h,en:"extrude",ans:x,a:"style-name"},{ens:h,en:"rotate",ans:x,a:"style-name"},{ens:h,en:"scene",ans:x,a:"style-name"},{ens:h,en:"sphere",ans:x,a:"style-name"},{ens:e,en:"caption",ans:x,a:"style-name"},{ens:e,en:"circle",ans:x,a:"style-name"},{ens:e,en:"connector",ans:x,a:"style-name"},{ens:e,en:"control",ans:x,a:"style-name"},{ens:e,en:"custom-shape",ans:x,a:"style-name"},{ens:e,en:"ellipse",ans:x,a:"style-name"},{ens:e,en:"frame",ans:x,a:"style-name"},{ens:e,en:"g",ans:x,a:"style-name"},
{ens:e,en:"line",ans:x,a:"style-name"},{ens:e,en:"measure",ans:x,a:"style-name"},{ens:e,en:"page-thumbnail",ans:x,a:"style-name"},{ens:e,en:"path",ans:x,a:"style-name"},{ens:e,en:"polygon",ans:x,a:"style-name"},{ens:e,en:"polyline",ans:x,a:"style-name"},{ens:e,en:"rect",ans:x,a:"style-name"},{ens:e,en:"regular-polygon",ans:x,a:"style-name"},{ens:A,en:"annotation",ans:x,a:"style-name"}],"drawing-page":[{ens:e,en:"page",ans:e,a:"style-name"},{ens:x,en:"notes",ans:e,a:"style-name"},{ens:u,en:"handout-master",
ans:e,a:"style-name"},{ens:u,en:"master-page",ans:e,a:"style-name"}],"list-style":[{ens:s,en:"list",ans:s,a:"style-name"},{ens:s,en:"numbered-paragraph",ans:s,a:"style-name"},{ens:s,en:"list-item",ans:s,a:"style-override"},{ens:u,en:"style",ans:u,a:"list-style-name"}],data:[{ens:u,en:"style",ans:u,a:"data-style-name"},{ens:u,en:"style",ans:u,a:"percentage-data-style-name"},{ens:x,en:"date-time-decl",ans:u,a:"data-style-name"},{ens:s,en:"creation-date",ans:u,a:"data-style-name"},{ens:s,en:"creation-time",
ans:u,a:"data-style-name"},{ens:s,en:"database-display",ans:u,a:"data-style-name"},{ens:s,en:"date",ans:u,a:"data-style-name"},{ens:s,en:"editing-duration",ans:u,a:"data-style-name"},{ens:s,en:"expression",ans:u,a:"data-style-name"},{ens:s,en:"meta-field",ans:u,a:"data-style-name"},{ens:s,en:"modification-date",ans:u,a:"data-style-name"},{ens:s,en:"modification-time",ans:u,a:"data-style-name"},{ens:s,en:"print-date",ans:u,a:"data-style-name"},{ens:s,en:"print-time",ans:u,a:"data-style-name"},{ens:s,
en:"table-formula",ans:u,a:"data-style-name"},{ens:s,en:"time",ans:u,a:"data-style-name"},{ens:s,en:"user-defined",ans:u,a:"data-style-name"},{ens:s,en:"user-field-get",ans:u,a:"data-style-name"},{ens:s,en:"user-field-input",ans:u,a:"data-style-name"},{ens:s,en:"variable-get",ans:u,a:"data-style-name"},{ens:s,en:"variable-input",ans:u,a:"data-style-name"},{ens:s,en:"variable-set",ans:u,a:"data-style-name"}],"page-layout":[{ens:x,en:"notes",ans:u,a:"page-layout-name"},{ens:u,en:"handout-master",ans:u,
a:"page-layout-name"},{ens:u,en:"master-page",ans:u,a:"page-layout-name"}]},M,O=xmldom.XPath;this.collectUsedFontFaces=f;this.changeFontFaceNames=q;this.UsedStyleList=function(a,c){var b={};this.uses=function(a){var c=a.localName,d=a.getAttributeNS(e,"name")||a.getAttributeNS(u,"name");a="style"===c?a.getAttributeNS(u,"family"):a.namespaceURI===w?"data":c;return(a=b[a])?0<a[d]:!1};g(a,b);c&&r(c,b)};this.hasDerivedStyles=function(a,c,b){var d=b.getAttributeNS(u,"name");b=b.getAttributeNS(u,"family");
return O.getODFElementsWithXPath(a,"//style:*[@style:parent-style-name='"+d+"'][@style:family='"+b+"']",c).length?!0:!1};this.prefixStyleNames=function(a,c,b){var d;if(a){for(d=a.firstChild;d;){if(d.nodeType===Node.ELEMENT_NODE){var h=d,f=c,g=h.getAttributeNS(e,"name"),l=void 0;g?l=e:(g=h.getAttributeNS(u,"name"))&&(l=u);l&&h.setAttributeNS(l,z[l]+"name",f+g)}d=d.nextSibling}m(a,c);b&&m(b,c)}};this.removePrefixFromStyleNames=function(a,c,b){var d=RegExp("^"+c);if(a){for(c=a.firstChild;c;){if(c.nodeType===
Node.ELEMENT_NODE){var h=c,f=d,g=h.getAttributeNS(e,"name"),l=void 0;g?l=e:(g=h.getAttributeNS(u,"name"))&&(l=u);l&&(g=g.replace(f,""),h.setAttributeNS(l,z[l]+"name",g))}c=c.nextSibling}k(a,d);b&&k(b,d)}};this.determineStylesForNode=b;M=function(){var a,c,b,d,e,h={},f,g,l,n;for(b in H)if(H.hasOwnProperty(b))for(d=H[b],c=d.length,a=0;a<c;a+=1)e=d[a],l=e.en,n=e.ens,h.hasOwnProperty(l)?f=h[l]:h[l]=f={},f.hasOwnProperty(n)?g=f[n]:f[n]=g=[],g.push({ns:e.ans,localname:e.a,keyname:b});return h}()};
// Input 26
"function"!==typeof Object.create&&(Object.create=function(m){var k=function(){};k.prototype=m;return new k});
xmldom.LSSerializer=function(){function m(b){var g=b||{},d=function(b){var a={},c;for(c in b)b.hasOwnProperty(c)&&(a[b[c]]=c);return a}(b),n=[g],k=[d],f=0;this.push=function(){f+=1;g=n[f]=Object.create(g);d=k[f]=Object.create(d)};this.pop=function(){n.pop();k.pop();f-=1;g=n[f];d=k[f]};this.getLocalNamespaceDefinitions=function(){return d};this.getQName=function(b){var a=b.namespaceURI,c=0,h;if(!a)return b.localName;if(h=d[a])return h+":"+b.localName;do{h||!b.prefix?(h="ns"+c,c+=1):h=b.prefix;if(g[h]===
a)break;if(!g[h]){g[h]=a;d[a]=h;break}h=null}while(null===h);return h+":"+b.localName}}function k(b){return b.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/'/g,"&apos;").replace(/"/g,"&quot;")}function b(p,l){var d="",n=g.filter?g.filter.acceptNode(l):NodeFilter.FILTER_ACCEPT,m;if(n===NodeFilter.FILTER_ACCEPT&&l.nodeType===Node.ELEMENT_NODE){p.push();m=p.getQName(l);var f,q=l.attributes,a,c,h,e="",v;f="<"+m;a=q.length;for(c=0;c<a;c+=1)h=q.item(c),"http://www.w3.org/2000/xmlns/"!==
h.namespaceURI&&(v=g.filter?g.filter.acceptNode(h):NodeFilter.FILTER_ACCEPT,v===NodeFilter.FILTER_ACCEPT&&(v=p.getQName(h),h="string"===typeof h.value?k(h.value):h.value,e+=" "+(v+'="'+h+'"')));a=p.getLocalNamespaceDefinitions();for(c in a)a.hasOwnProperty(c)&&((q=a[c])?"xmlns"!==q&&(f+=" xmlns:"+a[c]+'="'+c+'"'):f+=' xmlns="'+c+'"');d+=f+(e+">")}if(n===NodeFilter.FILTER_ACCEPT||n===NodeFilter.FILTER_SKIP){for(n=l.firstChild;n;)d+=b(p,n),n=n.nextSibling;l.nodeValue&&(d+=k(l.nodeValue))}m&&(d+="</"+
m+">",p.pop());return d}var g=this;this.filter=null;this.writeToString=function(g,l){if(!g)return"";var d=new m(l);return b(d,g)}};
// Input 27
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
(function(){function m(b){var a,c=n.length;for(a=0;a<c;a+=1)if("urn:oasis:names:tc:opendocument:xmlns:office:1.0"===b.namespaceURI&&b.localName===n[a])return a;return-1}function k(b,a){var c=new p.UsedStyleList(b,a),d=new odf.OdfNodeFilter;this.acceptNode=function(b){var f=d.acceptNode(b);f===NodeFilter.FILTER_ACCEPT&&b.parentNode===a&&b.nodeType===Node.ELEMENT_NODE&&(f=c.uses(b)?NodeFilter.FILTER_ACCEPT:NodeFilter.FILTER_REJECT);return f}}function b(b,a){var c=new k(b,a);this.acceptNode=function(a){var b=
c.acceptNode(a);b!==NodeFilter.FILTER_ACCEPT||!a.parentNode||a.parentNode.namespaceURI!==odf.Namespaces.textns||"s"!==a.parentNode.localName&&"tab"!==a.parentNode.localName||(b=NodeFilter.FILTER_REJECT);return b}}function g(b,a){if(a){var c=m(a),d,e=b.firstChild;if(-1!==c){for(;e;){d=m(e);if(-1!==d&&d>c)break;e=e.nextSibling}b.insertBefore(a,e)}}}var p=new odf.StyleInfo,l=new core.DomUtils,d=odf.Namespaces.stylens,n="meta settings scripts font-face-decls styles automatic-styles master-styles body".split(" "),
r=(new Date).getTime()+"_webodf_",f=new core.Base64;odf.ODFElement=function(){};odf.ODFDocumentElement=function(){};odf.ODFDocumentElement.prototype=new odf.ODFElement;odf.ODFDocumentElement.prototype.constructor=odf.ODFDocumentElement;odf.ODFDocumentElement.prototype.fontFaceDecls=null;odf.ODFDocumentElement.prototype.manifest=null;odf.ODFDocumentElement.prototype.settings=null;odf.ODFDocumentElement.namespaceURI="urn:oasis:names:tc:opendocument:xmlns:office:1.0";odf.ODFDocumentElement.localName=
"document";odf.AnnotationElement=function(){};odf.OdfPart=function(b,a,c,d){var e=this;this.size=0;this.type=null;this.name=b;this.container=c;this.url=null;this.mimetype=a;this.onstatereadychange=this.document=null;this.EMPTY=0;this.LOADING=1;this.DONE=2;this.state=this.EMPTY;this.data="";this.load=function(){null!==d&&(this.mimetype=a,d.loadAsDataURL(b,a,function(a,b){a&&runtime.log(a);e.url=b;if(e.onchange)e.onchange(e);if(e.onstatereadychange)e.onstatereadychange(e)}))}};odf.OdfPart.prototype.load=
function(){};odf.OdfPart.prototype.getUrl=function(){return this.data?"data:;base64,"+f.toBase64(this.data):null};odf.OdfContainer=function a(c,h){function e(a){for(var b=a.firstChild,c;b;)c=b.nextSibling,b.nodeType===Node.ELEMENT_NODE?e(b):b.nodeType===Node.PROCESSING_INSTRUCTION_NODE&&a.removeChild(b),b=c}function n(a){var b={},c,d,e=a.ownerDocument.createNodeIterator(a,NodeFilter.SHOW_ELEMENT,null,!1);for(a=e.nextNode();a;)"urn:oasis:names:tc:opendocument:xmlns:office:1.0"===a.namespaceURI&&("annotation"===
a.localName?(c=a.getAttributeNS("urn:oasis:names:tc:opendocument:xmlns:office:1.0","name"))&&(b.hasOwnProperty(c)?runtime.log("Warning: annotation name used more than once with <office:annotation/>: '"+c+"'"):b[c]=a):"annotation-end"===a.localName&&((c=a.getAttributeNS("urn:oasis:names:tc:opendocument:xmlns:office:1.0","name"))?b.hasOwnProperty(c)?(d=b[c],d.annotationEndElement?runtime.log("Warning: annotation name used more than once with <office:annotation-end/>: '"+c+"'"):d.annotationEndElement=
a):runtime.log("Warning: annotation end without an annotation start, name: '"+c+"'"):runtime.log("Warning: annotation end without a name found"))),a=e.nextNode()}function m(a,b){for(var c=a&&a.firstChild;c;)c.nodeType===Node.ELEMENT_NODE&&c.setAttributeNS("urn:webodf:names:scope","scope",b),c=c.nextSibling}function A(a){var b={},c;for(a=a.firstChild;a;)a.nodeType===Node.ELEMENT_NODE&&a.namespaceURI===d&&"font-face"===a.localName&&(c=a.getAttributeNS(d,"name"),b[c]=a),a=a.nextSibling;return b}function x(a,
b){var c=null,d,e,h;if(a)for(c=a.cloneNode(!0),d=c.firstElementChild;d;)e=d.nextElementSibling,(h=d.getAttributeNS("urn:webodf:names:scope","scope"))&&h!==b&&c.removeChild(d),d=e;return c}function u(a,b){var c,e,h,f=null,g={};if(a)for(b.forEach(function(a){p.collectUsedFontFaces(g,a)}),f=a.cloneNode(!0),c=f.firstElementChild;c;)e=c.nextElementSibling,h=c.getAttributeNS(d,"name"),g[h]||f.removeChild(c),c=e;return f}function t(a){var b=P.rootElement.ownerDocument,c;if(a){e(a.documentElement);try{c=
b.importNode(a.documentElement,!0)}catch(d){}}return c}function s(a){P.state=a;if(P.onchange)P.onchange(P);if(P.onstatereadychange)P.onstatereadychange(P)}function z(a){ba=null;P.rootElement=a;a.fontFaceDecls=l.getDirectChild(a,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","font-face-decls");a.styles=l.getDirectChild(a,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","styles");a.automaticStyles=l.getDirectChild(a,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","automatic-styles");a.masterStyles=
l.getDirectChild(a,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","master-styles");a.body=l.getDirectChild(a,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","body");a.meta=l.getDirectChild(a,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","meta");n(a)}function H(b){var c=t(b),d=P.rootElement,e;c&&"document-styles"===c.localName&&"urn:oasis:names:tc:opendocument:xmlns:office:1.0"===c.namespaceURI?(d.fontFaceDecls=l.getDirectChild(c,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","font-face-decls"),
g(d,d.fontFaceDecls),e=l.getDirectChild(c,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","styles"),d.styles=e||b.createElementNS("urn:oasis:names:tc:opendocument:xmlns:office:1.0","styles"),g(d,d.styles),e=l.getDirectChild(c,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","automatic-styles"),d.automaticStyles=e||b.createElementNS("urn:oasis:names:tc:opendocument:xmlns:office:1.0","automatic-styles"),m(d.automaticStyles,"document-styles"),g(d,d.automaticStyles),c=l.getDirectChild(c,"urn:oasis:names:tc:opendocument:xmlns:office:1.0",
"master-styles"),d.masterStyles=c||b.createElementNS("urn:oasis:names:tc:opendocument:xmlns:office:1.0","master-styles"),g(d,d.masterStyles),p.prefixStyleNames(d.automaticStyles,r,d.masterStyles)):s(a.INVALID)}function M(b){b=t(b);var c,e,h,f;if(b&&"document-content"===b.localName&&"urn:oasis:names:tc:opendocument:xmlns:office:1.0"===b.namespaceURI){c=P.rootElement;h=l.getDirectChild(b,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","font-face-decls");if(c.fontFaceDecls&&h){f=c.fontFaceDecls;var n,
k,z,r,M={};e=A(f);r=A(h);for(h=h.firstElementChild;h;){n=h.nextElementSibling;if(h.namespaceURI===d&&"font-face"===h.localName)if(k=h.getAttributeNS(d,"name"),e.hasOwnProperty(k)){if(!h.isEqualNode(e[k])){z=k;for(var F=e,E=r,v=0,H=void 0,H=z=z.replace(/\d+$/,"");F.hasOwnProperty(H)||E.hasOwnProperty(H);)v+=1,H=z+v;z=H;h.setAttributeNS(d,"style:name",z);f.appendChild(h);e[z]=h;delete r[k];M[k]=z}}else f.appendChild(h),e[k]=h,delete r[k];h=n}f=M}else h&&(c.fontFaceDecls=h,g(c,h));e=l.getDirectChild(b,
"urn:oasis:names:tc:opendocument:xmlns:office:1.0","automatic-styles");m(e,"document-content");f&&p.changeFontFaceNames(e,f);if(c.automaticStyles&&e)for(f=e.firstChild;f;)c.automaticStyles.appendChild(f),f=e.firstChild;else e&&(c.automaticStyles=e,g(c,e));b=l.getDirectChild(b,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","body");if(null===b)throw"<office:body/> tag is mising.";c.body=b;g(c,c.body)}else s(a.INVALID)}function O(a){a=t(a);var b;a&&"document-meta"===a.localName&&"urn:oasis:names:tc:opendocument:xmlns:office:1.0"===
a.namespaceURI&&(b=P.rootElement,b.meta=l.getDirectChild(a,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","meta"),g(b,b.meta))}function F(a){a=t(a);var b;a&&"document-settings"===a.localName&&"urn:oasis:names:tc:opendocument:xmlns:office:1.0"===a.namespaceURI&&(b=P.rootElement,b.settings=l.getDirectChild(a,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","settings"),g(b,b.settings))}function W(a){a=t(a);var b;if(a&&"manifest"===a.localName&&"urn:oasis:names:tc:opendocument:xmlns:manifest:1.0"===
a.namespaceURI)for(b=P.rootElement,b.manifest=a,a=b.manifest.firstElementChild;a;)"file-entry"===a.localName&&"urn:oasis:names:tc:opendocument:xmlns:manifest:1.0"===a.namespaceURI&&(Q[a.getAttributeNS("urn:oasis:names:tc:opendocument:xmlns:manifest:1.0","full-path")]=a.getAttributeNS("urn:oasis:names:tc:opendocument:xmlns:manifest:1.0","media-type")),a=a.nextElementSibling}function T(b){var c=b.shift();c?N.loadAsDOM(c.path,function(d,e){c.handler(e);d||P.state===a.INVALID||T(b)}):(n(P.rootElement),
s(a.DONE))}function Z(a){var b="";odf.Namespaces.forEachPrefix(function(a,c){b+=" xmlns:"+a+'="'+c+'"'});return'<?xml version="1.0" encoding="UTF-8"?><office:'+a+" "+b+' office:version="1.2">'}function D(){var a=new xmldom.LSSerializer,b=Z("document-meta");a.filter=new odf.OdfNodeFilter;b+=a.writeToString(P.rootElement.meta,odf.Namespaces.namespaceMap);return b+"</office:document-meta>"}function ca(a,b){var c=document.createElementNS("urn:oasis:names:tc:opendocument:xmlns:manifest:1.0","manifest:file-entry");
c.setAttributeNS("urn:oasis:names:tc:opendocument:xmlns:manifest:1.0","manifest:full-path",a);c.setAttributeNS("urn:oasis:names:tc:opendocument:xmlns:manifest:1.0","manifest:media-type",b);return c}function E(){var a=runtime.parseXML('<manifest:manifest xmlns:manifest="urn:oasis:names:tc:opendocument:xmlns:manifest:1.0" manifest:version="1.2"></manifest:manifest>'),b=a.documentElement,c=new xmldom.LSSerializer,d;for(d in Q)Q.hasOwnProperty(d)&&b.appendChild(ca(d,Q[d]));c.filter=new odf.OdfNodeFilter;
return'<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n'+c.writeToString(a,odf.Namespaces.namespaceMap)}function J(){var a=new xmldom.LSSerializer,b=Z("document-settings");a.filter=new odf.OdfNodeFilter;P.rootElement.settings.firstElementChild&&(b+=a.writeToString(P.rootElement.settings,odf.Namespaces.namespaceMap));return b+"</office:document-settings>"}function I(){var a,b,c,d=odf.Namespaces.namespaceMap,e=new xmldom.LSSerializer,h=Z("document-styles");b=x(P.rootElement.automaticStyles,
"document-styles");c=P.rootElement.masterStyles.cloneNode(!0);a=u(P.rootElement.fontFaceDecls,[c,P.rootElement.styles,b]);p.removePrefixFromStyleNames(b,r,c);e.filter=new k(c,b);h+=e.writeToString(a,d);h+=e.writeToString(P.rootElement.styles,d);h+=e.writeToString(b,d);h+=e.writeToString(c,d);return h+"</office:document-styles>"}function $(){var a,c,d=odf.Namespaces.namespaceMap,e=new xmldom.LSSerializer,h=Z("document-content");c=x(P.rootElement.automaticStyles,"document-content");a=u(P.rootElement.fontFaceDecls,
[c]);e.filter=new b(P.rootElement.body,c);h+=e.writeToString(a,d);h+=e.writeToString(c,d);h+=e.writeToString(P.rootElement.body,d);return h+"</office:document-content>"}function V(b,c){runtime.loadXML(b,function(b,d){if(b)c(b);else{var e=t(d);e&&"document"===e.localName&&"urn:oasis:names:tc:opendocument:xmlns:office:1.0"===e.namespaceURI?(z(e),s(a.DONE)):s(a.INVALID)}})}function L(a,b){var c;c=P.rootElement;var d=c.meta;d||(c.meta=d=document.createElementNS("urn:oasis:names:tc:opendocument:xmlns:office:1.0",
"meta"),g(c,d));c=d;a&&l.mapKeyValObjOntoNode(c,a,odf.Namespaces.lookupNamespaceURI);b&&l.removeKeyElementsFromNode(c,b,odf.Namespaces.lookupNamespaceURI)}function y(){function b(a,c){var d;c||(c=a);d=document.createElementNS("urn:oasis:names:tc:opendocument:xmlns:office:1.0",c);e[a]=d;e.appendChild(d)}var c=new core.Zip("",null),d=runtime.byteArrayFromString("application/vnd.oasis.opendocument.text","utf8"),e=P.rootElement,h=document.createElementNS("urn:oasis:names:tc:opendocument:xmlns:office:1.0",
"text");c.save("mimetype",d,!1,new Date);b("meta");b("settings");b("scripts");b("fontFaceDecls","font-face-decls");b("styles");b("automaticStyles","automatic-styles");b("masterStyles","master-styles");b("body");e.body.appendChild(h);Q["/"]="application/vnd.oasis.opendocument.text";Q["settings.xml"]="text/xml";Q["meta.xml"]="text/xml";Q["styles.xml"]="text/xml";Q["content.xml"]="text/xml";s(a.DONE);return c}function aa(){var a,b=new Date,c=runtime.getWindow();a="WebODF/"+("undefined"!==String(typeof webodf_version)?
webodf_version:"FromSource");c&&(a=a+" "+c.navigator.userAgent);L({"meta:generator":a},null);a=runtime.byteArrayFromString(J(),"utf8");N.save("settings.xml",a,!0,b);a=runtime.byteArrayFromString(D(),"utf8");N.save("meta.xml",a,!0,b);a=runtime.byteArrayFromString(I(),"utf8");N.save("styles.xml",a,!0,b);a=runtime.byteArrayFromString($(),"utf8");N.save("content.xml",a,!0,b);a=runtime.byteArrayFromString(E(),"utf8");N.save("META-INF/manifest.xml",a,!0,b)}function X(a,b){aa();N.writeAs(a,function(a){b(a)})}
var P=this,N,Q={},ba;this.onstatereadychange=h;this.state=this.onchange=null;this.setRootElement=z;this.getContentElement=function(){var a;ba||(a=P.rootElement.body,ba=l.getDirectChild(a,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","text")||l.getDirectChild(a,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","presentation")||l.getDirectChild(a,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","spreadsheet"));if(!ba)throw"Could not find content element in <office:body/>.";return ba};this.getDocumentType=
function(){var a=P.getContentElement();return a&&a.localName};this.getPart=function(a){return new odf.OdfPart(a,Q[a],P,N)};this.getPartData=function(a,b){N.load(a,b)};this.setMetadata=L;this.incrementEditingCycles=function(){var a;for(a=(a=P.rootElement.meta)&&a.firstChild;a&&(a.namespaceURI!==odf.Namespaces.metans||"editing-cycles"!==a.localName);)a=a.nextSibling;for(a=a&&a.firstChild;a&&a.nodeType!==Node.TEXT_NODE;)a=a.nextSibling;a=a?a.data:null;a=a?parseInt(a,10):0;isNaN(a)&&(a=0);L({"meta:editing-cycles":a+
1},null)};this.createByteArray=function(a,b){aa();N.createByteArray(a,b)};this.saveAs=X;this.save=function(a){X(c,a)};this.getUrl=function(){return c};this.setBlob=function(a,b,c){c=f.convertBase64ToByteArray(c);N.save(a,c,!1,new Date);Q.hasOwnProperty(a)&&runtime.log(a+" has been overwritten.");Q[a]=b};this.removeBlob=function(a){var b=N.remove(a);runtime.assert(b,"file is not found: "+a);delete Q[a]};this.state=a.LOADING;this.rootElement=function(a){var b=document.createElementNS(a.namespaceURI,
a.localName),c;a=new a.Type;for(c in a)a.hasOwnProperty(c)&&(b[c]=a[c]);return b}({Type:odf.ODFDocumentElement,namespaceURI:odf.ODFDocumentElement.namespaceURI,localName:odf.ODFDocumentElement.localName});N=c?new core.Zip(c,function(b,d){N=d;b?V(c,function(c){b&&(N.error=b+"\n"+c,s(a.INVALID))}):T([{path:"styles.xml",handler:H},{path:"content.xml",handler:M},{path:"meta.xml",handler:O},{path:"settings.xml",handler:F},{path:"META-INF/manifest.xml",handler:W}])}):y()};odf.OdfContainer.EMPTY=0;odf.OdfContainer.LOADING=
1;odf.OdfContainer.DONE=2;odf.OdfContainer.INVALID=3;odf.OdfContainer.SAVING=4;odf.OdfContainer.MODIFIED=5;odf.OdfContainer.getContainer=function(a){return new odf.OdfContainer(a,null)};return odf.OdfContainer})();
// Input 28
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
odf.OdfUtils=function(){function m(a){return"image"===(a&&a.localName)&&a.namespaceURI===T}function k(a){return null!==a&&a.nodeType===Node.ELEMENT_NODE&&"frame"===a.localName&&a.namespaceURI===T&&"as-char"===a.getAttributeNS(W,"anchor-type")}function b(a){var b;(b="annotation"===(a&&a.localName)&&a.namespaceURI===odf.Namespaces.officens)||(b="div"===(a&&a.localName)&&"annotationWrapper"===a.className);return b}function g(a){return"a"===(a&&a.localName)&&a.namespaceURI===W}function p(a){var b=a&&
a.localName;return("p"===b||"h"===b)&&a.namespaceURI===W}function l(a){for(;a&&!p(a);)a=a.parentNode;return a}function d(a){return/^[ \t\r\n]+$/.test(a)}function n(a){if(null===a||a.nodeType!==Node.ELEMENT_NODE)return!1;var b=a.localName;return/^(span|p|h|a|meta)$/.test(b)&&a.namespaceURI===W||"span"===b&&"webodf-annotationHighlight"===a.className}function r(a){var b=a&&a.localName,c=!1;b&&(a=a.namespaceURI,a===W&&(c="s"===b||"tab"===b||"line-break"===b));return c}function f(a){return r(a)||k(a)||
b(a)}function q(a){var b=a&&a.localName,c=!1;b&&(a=a.namespaceURI,a===W&&(c="s"===b));return c}function a(a){for(;null!==a.firstChild&&n(a);)a=a.firstChild;return a}function c(a){for(;null!==a.lastChild&&n(a);)a=a.lastChild;return a}function h(a){for(;!p(a)&&null===a.previousSibling;)a=a.parentNode;return p(a)?null:c(a.previousSibling)}function e(b){for(;!p(b)&&null===b.nextSibling;)b=b.parentNode;return p(b)?null:a(b.nextSibling)}function v(a){for(var b=!1;a;)if(a.nodeType===Node.TEXT_NODE)if(0===
a.length)a=h(a);else return!d(a.data.substr(a.length-1,1));else f(a)?(b=!1===q(a),a=null):a=h(a);return b}function w(b){var c=!1,h;for(b=b&&a(b);b;){h=b.nodeType===Node.TEXT_NODE?b.length:0;if(0<h&&!d(b.data)){c=!0;break}if(f(b)){c=!0;break}b=e(b)}return c}function A(a,b){return d(a.data.substr(b))?!w(e(a)):!1}function x(a,b){var c=a.data,e;if(!d(c[b])||f(a.parentNode))return!1;0<b?d(c[b-1])||(e=!0):v(h(a))&&(e=!0);return!0===e?A(a,b)?!1:!0:!1}function u(a){return(a=/(-?[0-9]*[0-9][0-9]*(\.[0-9]*)?|0+\.[0-9]*[1-9][0-9]*|\.[0-9]*[1-9][0-9]*)((cm)|(mm)|(in)|(pt)|(pc)|(px)|(%))/.exec(a))?
{value:parseFloat(a[1]),unit:a[3]}:null}function t(a){return(a=u(a))&&(0>a.value||"%"===a.unit)?null:a}function s(a){return(a=u(a))&&"%"!==a.unit?null:a}function z(a){switch(a.namespaceURI){case odf.Namespaces.drawns:case odf.Namespaces.svgns:case odf.Namespaces.dr3dns:return!1;case odf.Namespaces.textns:switch(a.localName){case "note-body":case "ruby-text":return!1}break;case odf.Namespaces.officens:switch(a.localName){case "annotation":case "binary-data":case "event-listeners":return!1}break;default:switch(a.localName){case "cursor":case "editinfo":return!1}}return!0}
function H(a,b){for(;0<b.length&&!ca.rangeContainsNode(a,b[0]);)b.shift();for(;0<b.length&&!ca.rangeContainsNode(a,b[b.length-1]);)b.pop()}function M(a,c,e){var h;h=ca.getNodesInRange(a,function(a){var c=NodeFilter.FILTER_REJECT;if(r(a.parentNode)||b(a))c=NodeFilter.FILTER_REJECT;else if(a.nodeType===Node.TEXT_NODE){if(e||Boolean(l(a)&&(!d(a.textContent)||x(a,0))))c=NodeFilter.FILTER_ACCEPT}else if(f(a))c=NodeFilter.FILTER_ACCEPT;else if(z(a)||n(a))c=NodeFilter.FILTER_SKIP;return c},NodeFilter.SHOW_ELEMENT|
NodeFilter.SHOW_TEXT);c||H(a,h);return h}function O(a,c,d){for(;a;){if(d(a)){c[0]!==a&&c.unshift(a);break}if(b(a))break;a=a.parentNode}}function F(a,b){var c=a;if(b<c.childNodes.length-1)c=c.childNodes[b+1];else{for(;!c.nextSibling;)c=c.parentNode;c=c.nextSibling}for(;c.firstChild;)c=c.firstChild;return c}var W=odf.Namespaces.textns,T=odf.Namespaces.drawns,Z=odf.Namespaces.xlinkns,D=/^\s*$/,ca=new core.DomUtils;this.isImage=m;this.isCharacterFrame=k;this.isInlineRoot=b;this.isTextSpan=function(a){return"span"===
(a&&a.localName)&&a.namespaceURI===W};this.isHyperlink=g;this.getHyperlinkTarget=function(a){return a.getAttributeNS(Z,"href")};this.isParagraph=p;this.getParagraphElement=l;this.isWithinTrackedChanges=function(a,b){for(;a&&a!==b;){if(a.namespaceURI===W&&"tracked-changes"===a.localName)return!0;a=a.parentNode}return!1};this.isListItem=function(a){return"list-item"===(a&&a.localName)&&a.namespaceURI===W};this.isLineBreak=function(a){return"line-break"===(a&&a.localName)&&a.namespaceURI===W};this.isODFWhitespace=
d;this.isGroupingElement=n;this.isCharacterElement=r;this.isAnchoredAsCharacterElement=f;this.isSpaceElement=q;this.firstChild=a;this.lastChild=c;this.previousNode=h;this.nextNode=e;this.scanLeftForNonSpace=v;this.lookLeftForCharacter=function(a){var b,c=b=0;a.nodeType===Node.TEXT_NODE&&(c=a.length);0<c?(b=a.data,b=d(b.substr(c-1,1))?1===c?v(h(a))?2:0:d(b.substr(c-2,1))?0:2:1):f(a)&&(b=1);return b};this.lookRightForCharacter=function(a){var b=!1,c=0;a&&a.nodeType===Node.TEXT_NODE&&(c=a.length);0<
c?b=!d(a.data.substr(0,1)):f(a)&&(b=!0);return b};this.scanLeftForAnyCharacter=function(a){var b=!1,e;for(a=a&&c(a);a;){e=a.nodeType===Node.TEXT_NODE?a.length:0;if(0<e&&!d(a.data)){b=!0;break}if(f(a)){b=!0;break}a=h(a)}return b};this.scanRightForAnyCharacter=w;this.isTrailingWhitespace=A;this.isSignificantWhitespace=x;this.isDowngradableSpaceElement=function(a){return a.namespaceURI===W&&"s"===a.localName?v(h(a))&&w(e(a)):!1};this.getFirstNonWhitespaceChild=function(a){for(a=a&&a.firstChild;a&&a.nodeType===
Node.TEXT_NODE&&D.test(a.nodeValue);)a=a.nextSibling;return a};this.parseLength=u;this.parseNonNegativeLength=t;this.parseFoFontSize=function(a){var b;b=(b=u(a))&&(0>=b.value||"%"===b.unit)?null:b;return b||s(a)};this.parseFoLineHeight=function(a){return t(a)||s(a)};this.isTextContentContainingNode=z;this.getTextNodes=function(a,b){var c;c=ca.getNodesInRange(a,function(a){var b=NodeFilter.FILTER_REJECT;a.nodeType===Node.TEXT_NODE?Boolean(l(a)&&(!d(a.textContent)||x(a,0)))&&(b=NodeFilter.FILTER_ACCEPT):
z(a)&&(b=NodeFilter.FILTER_SKIP);return b},NodeFilter.SHOW_ELEMENT|NodeFilter.SHOW_TEXT);b||H(a,c);return c};this.getTextElements=M;this.getParagraphElements=function(a){var b;b=ca.getNodesInRange(a,function(a){var b=NodeFilter.FILTER_REJECT;if(p(a))b=NodeFilter.FILTER_ACCEPT;else if(z(a)||n(a))b=NodeFilter.FILTER_SKIP;return b},NodeFilter.SHOW_ELEMENT);O(a.startContainer,b,p);return b};this.getImageElements=function(a){var b;b=ca.getNodesInRange(a,function(a){var b=NodeFilter.FILTER_SKIP;m(a)&&(b=
NodeFilter.FILTER_ACCEPT);return b},NodeFilter.SHOW_ELEMENT);O(a.startContainer,b,m);return b};this.getHyperlinkElements=function(a){var b=[],c=a.cloneRange();a.collapsed&&a.endContainer.nodeType===Node.ELEMENT_NODE&&(a=F(a.endContainer,a.endOffset),a.nodeType===Node.TEXT_NODE&&c.setEnd(a,1));M(c,!0,!1).forEach(function(a){for(a=a.parentNode;!p(a);){if(g(a)&&-1===b.indexOf(a)){b.push(a);break}a=a.parentNode}});c.detach();return b}};
// Input 29
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
gui.AnnotatableCanvas=function(){};gui.AnnotatableCanvas.prototype.refreshSize=function(){};gui.AnnotatableCanvas.prototype.getZoomLevel=function(){};gui.AnnotatableCanvas.prototype.getSizer=function(){};
gui.AnnotationViewManager=function(m,k,b,g){function p(a){var b=a.annotationEndElement,d=f.createRange(),g=a.getAttributeNS(odf.Namespaces.officens,"name");b&&(d.setStart(a,a.childNodes.length),d.setEnd(b,0),a=q.getTextNodes(d,!1),a.forEach(function(a){var b=f.createElement("span");b.className="webodf-annotationHighlight";b.setAttribute("annotation",g);a.parentNode.insertBefore(b,a);b.appendChild(a)}));d.detach()}function l(c){var d=m.getSizer();c?(b.style.display="inline-block",d.style.paddingRight=
a.getComputedStyle(b).width):(b.style.display="none",d.style.paddingRight=0);m.refreshSize()}function d(){r.sort(function(a,b){return 0!==(a.compareDocumentPosition(b)&Node.DOCUMENT_POSITION_FOLLOWING)?-1:1})}function n(){var a;for(a=0;a<r.length;a+=1){var d=r[a],e=d.parentNode,f=e.nextElementSibling,g=f.nextElementSibling,l=e.parentNode,n=0,n=r[r.indexOf(d)-1],k=void 0,d=m.getZoomLevel();e.style.left=(b.getBoundingClientRect().left-l.getBoundingClientRect().left)/d+"px";e.style.width=b.getBoundingClientRect().width/
d+"px";f.style.width=parseFloat(e.style.left)-30+"px";n&&(k=n.parentNode.getBoundingClientRect(),20>=(l.getBoundingClientRect().top-k.bottom)/d?e.style.top=Math.abs(l.getBoundingClientRect().top-k.bottom)/d+20+"px":e.style.top="0px");g.style.left=f.getBoundingClientRect().width/d+"px";var f=g.style,l=g.getBoundingClientRect().left/d,n=g.getBoundingClientRect().top/d,k=e.getBoundingClientRect().left/d,p=e.getBoundingClientRect().top/d,q=0,z=0,q=k-l,q=q*q,z=p-n,z=z*z,l=Math.sqrt(q+z);f.width=l+"px";
n=Math.asin((e.getBoundingClientRect().top-g.getBoundingClientRect().top)/(d*parseFloat(g.style.width)));g.style.transform="rotate("+n+"rad)";g.style.MozTransform="rotate("+n+"rad)";g.style.WebkitTransform="rotate("+n+"rad)";g.style.msTransform="rotate("+n+"rad)"}}var r=[],f=k.ownerDocument,q=new odf.OdfUtils,a=runtime.getWindow();runtime.assert(Boolean(a),"Expected to be run in an environment which has a global window, like a browser.");this.rerenderAnnotations=n;this.getMinimumHeightForAnnotationPane=
function(){return"none"!==b.style.display&&0<r.length?(r[r.length-1].parentNode.getBoundingClientRect().bottom-b.getBoundingClientRect().top)/m.getZoomLevel()+"px":null};this.addAnnotation=function(a){l(!0);r.push(a);d();var b=f.createElement("div"),e=f.createElement("div"),k=f.createElement("div"),m=f.createElement("div"),q;b.className="annotationWrapper";a.parentNode.insertBefore(b,a);e.className="annotationNote";e.appendChild(a);g&&(q=f.createElement("div"),q.className="annotationRemoveButton",
e.appendChild(q));k.className="annotationConnector horizontal";m.className="annotationConnector angular";b.appendChild(e);b.appendChild(k);b.appendChild(m);a.annotationEndElement&&p(a);n()};this.forgetAnnotations=function(){for(;r.length;){var a=r[0],b=r.indexOf(a),d=a.parentNode.parentNode;"div"===d.localName&&(d.parentNode.insertBefore(a,d),d.parentNode.removeChild(d));for(var a=a.getAttributeNS(odf.Namespaces.officens,"name"),a=f.querySelectorAll('span.webodf-annotationHighlight[annotation="'+
a+'"]'),g=d=void 0,d=0;d<a.length;d+=1){for(g=a.item(d);g.firstChild;)g.parentNode.insertBefore(g.firstChild,g);g.parentNode.removeChild(g)}-1!==b&&r.splice(b,1);0===r.length&&l(!1)}}};
// Input 30
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
(function(){function m(g,k,l,d,n){var r,f=0,q;for(q in g)if(g.hasOwnProperty(q)){if(f===l){r=q;break}f+=1}r?k.getPartData(g[r].href,function(a,c){if(a)runtime.log(a);else if(c){var h="@font-face { font-family: '"+(g[r].family||r)+"'; src: url(data:application/x-font-ttf;charset=binary;base64,"+b.convertUTF8ArrayToBase64(c)+') format("truetype"); }';try{d.insertRule(h,d.cssRules.length)}catch(e){runtime.log("Problem inserting rule in CSS: "+runtime.toJson(e)+"\nRule: "+h)}}else runtime.log("missing font data for "+
g[r].href);m(g,k,l+1,d,n)}):n&&n()}var k=xmldom.XPath,b=new core.Base64;odf.FontLoader=function(){this.loadFonts=function(b,p){for(var l=b.rootElement.fontFaceDecls;p.cssRules.length;)p.deleteRule(p.cssRules.length-1);if(l){var d={},n,r,f,q;if(l)for(l=k.getODFElementsWithXPath(l,"style:font-face[svg:font-face-src]",odf.Namespaces.lookupNamespaceURI),n=0;n<l.length;n+=1)r=l[n],f=r.getAttributeNS(odf.Namespaces.stylens,"name"),q=r.getAttributeNS(odf.Namespaces.svgns,"font-family"),r=k.getODFElementsWithXPath(r,
"svg:font-face-src/svg:font-face-uri",odf.Namespaces.lookupNamespaceURI),0<r.length&&(r=r[0].getAttributeNS(odf.Namespaces.xlinkns,"href"),d[f]={href:r,family:q});m(d,b,0,p)}}};return odf.FontLoader})();
// Input 31
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
odf.Formatting=function(){function m(a){return(a=t[a])?u.mergeObjects({},a):{}}function k(){for(var a=q.rootElement.fontFaceDecls,b={},d,e,a=a&&a.firstElementChild;a;){if(d=a.getAttributeNS(h,"name"))if((e=a.getAttributeNS(c,"font-family"))||0<a.getElementsByTagNameNS(c,"font-face-uri").length)b[d]=e;a=a.nextElementSibling}return b}function b(a){for(var b=q.rootElement.styles.firstElementChild;b;){if(b.namespaceURI===h&&"default-style"===b.localName&&b.getAttributeNS(h,"family")===a)return b;b=b.nextElementSibling}return null}
function g(a,b,c){var d,f,g;c=c||[q.rootElement.automaticStyles,q.rootElement.styles];for(g=0;g<c.length;g+=1)for(d=c[g],d=d.firstElementChild;d;){f=d.getAttributeNS(h,"name");if(d.namespaceURI===h&&"style"===d.localName&&d.getAttributeNS(h,"family")===b&&f===a||"list-style"===b&&d.namespaceURI===e&&"list-style"===d.localName&&f===a||"data"===b&&d.namespaceURI===v&&f===a)return d;d=d.nextElementSibling}return null}function p(a){for(var b,c,d,e,f={},g=a.firstElementChild;g;){if(g.namespaceURI===h)for(d=
f[g.nodeName]={},c=g.attributes,b=0;b<c.length;b+=1)e=c.item(b),d[e.name]=e.value;g=g.nextElementSibling}c=a.attributes;for(b=0;b<c.length;b+=1)e=c.item(b),f[e.name]=e.value;return f}function l(a,c){for(var d=q.rootElement.styles,e,f={},l=a.getAttributeNS(h,"family"),n=a;n;)e=p(n),f=u.mergeObjects(e,f),n=(e=n.getAttributeNS(h,"parent-style-name"))?g(e,l,[d]):null;if(n=b(l))e=p(n),f=u.mergeObjects(e,f);!1!==c&&(e=m(l),f=u.mergeObjects(e,f));return f}function d(b,c){function d(a){Object.keys(a).forEach(function(b){Object.keys(a[b]).forEach(function(a){g+=
"|"+b+":"+a+"|"})})}for(var e=b.nodeType===Node.TEXT_NODE?b.parentNode:b,f,h=[],g="",l=!1;e;)!l&&A.isGroupingElement(e)&&(l=!0),(f=a.determineStylesForNode(e))&&h.push(f),e=e.parentNode;l&&(h.forEach(d),c&&(c[g]=h));return l?h:void 0}function n(a){var b={orderedStyles:[]};a.forEach(function(a){Object.keys(a).forEach(function(c){var d=Object.keys(a[c])[0],e={name:d,family:c,displayName:void 0,isCommonStyle:!1},f;(f=g(d,c))?(c=l(f),b=u.mergeObjects(c,b),e.displayName=f.getAttributeNS(h,"display-name"),
e.isCommonStyle=f.parentNode===q.rootElement.styles):runtime.log("No style element found for '"+d+"' of family '"+c+"'");b.orderedStyles.push(e)})});return b}function r(a,b){var c={},e=[];b||(b={});a.forEach(function(a){d(a,c)});Object.keys(c).forEach(function(a){b[a]||(b[a]=n(c[a]));e.push(b[a])});return e}function f(a,b){var c=A.parseLength(a),d=b;if(c)switch(c.unit){case "cm":d=c.value;break;case "mm":d=0.1*c.value;break;case "in":d=2.54*c.value;break;case "pt":d=0.035277778*c.value;break;case "pc":case "px":case "em":break;
default:runtime.log("Unit identifier: "+c.unit+" is not supported.")}return d}var q,a=new odf.StyleInfo,c=odf.Namespaces.svgns,h=odf.Namespaces.stylens,e=odf.Namespaces.textns,v=odf.Namespaces.numberns,w=odf.Namespaces.fons,A=new odf.OdfUtils,x=new core.DomUtils,u=new core.Utils,t={paragraph:{"style:paragraph-properties":{"fo:text-align":"left"}}};this.getSystemDefaultStyleAttributes=m;this.setOdfContainer=function(a){q=a};this.getFontMap=k;this.getAvailableParagraphStyles=function(){for(var a=q.rootElement.styles,
b,c,d=[],a=a&&a.firstElementChild;a;)"style"===a.localName&&a.namespaceURI===h&&(b=a.getAttributeNS(h,"family"),"paragraph"===b&&(b=a.getAttributeNS(h,"name"),c=a.getAttributeNS(h,"display-name")||b,b&&c&&d.push({name:b,displayName:c}))),a=a.nextElementSibling;return d};this.isStyleUsed=function(b){var c,d=q.rootElement;c=a.hasDerivedStyles(d,odf.Namespaces.lookupNamespaceURI,b);b=(new a.UsedStyleList(d.styles)).uses(b)||(new a.UsedStyleList(d.automaticStyles)).uses(b)||(new a.UsedStyleList(d.body)).uses(b);
return c||b};this.getDefaultStyleElement=b;this.getStyleElement=g;this.getStyleAttributes=p;this.getInheritedStyleAttributes=l;this.getFirstCommonParentStyleNameOrSelf=function(a){var b=q.rootElement.automaticStyles,c=q.rootElement.styles,d;for(d=g(a,"paragraph",[b]);d;)a=d.getAttributeNS(h,"parent-style-name"),d=g(a,"paragraph",[b]);return(d=g(a,"paragraph",[c]))?a:null};this.hasParagraphStyle=function(a){return Boolean(g(a,"paragraph"))};this.getAppliedStyles=r;this.getAppliedStylesForElement=function(a,
b){return r([a],b)[0]};this.updateStyle=function(a,b){var d,e;x.mapObjOntoNode(a,b,odf.Namespaces.lookupNamespaceURI);(d=b["style:text-properties"]&&b["style:text-properties"]["style:font-name"])&&!k().hasOwnProperty(d)&&(e=a.ownerDocument.createElementNS(h,"style:font-face"),e.setAttributeNS(h,"style:name",d),e.setAttributeNS(c,"svg:font-family",d),q.rootElement.fontFaceDecls.appendChild(e))};this.createDerivedStyleObject=function(a,b,c){var d=g(a,b);runtime.assert(Boolean(d),"No style element found for '"+
a+"' of family '"+b+"'");a=d.parentNode===q.rootElement.styles?{"style:parent-style-name":a}:p(d);a["style:family"]=b;u.mergeObjects(a,c);return a};this.getDefaultTabStopDistance=function(){for(var a=b("paragraph"),a=a&&a.firstElementChild,c;a;)a.namespaceURI===h&&"paragraph-properties"===a.localName&&(c=a.getAttributeNS(h,"tab-stop-distance")),a=a.nextElementSibling;c||(c="1.25cm");return A.parseNonNegativeLength(c)};this.getContentSize=function(a,b){var c,d,e,l,n,k,p,m,r,v,u;a:{var t,A,V;c=g(a,
b);runtime.assert("paragraph"===b||"table"===b,"styleFamily has to be either paragraph or table");if(c){t=c.getAttributeNS(h,"master-page-name")||"Standard";for(c=q.rootElement.masterStyles.lastElementChild;c&&c.getAttributeNS(h,"name")!==t;)c=c.previousElementSibling;t=c.getAttributeNS(h,"page-layout-name");A=x.getElementsByTagNameNS(q.rootElement.automaticStyles,h,"page-layout");for(V=0;V<A.length;V+=1)if(c=A[V],c.getAttributeNS(h,"name")===t)break a}c=null}c||(c=x.getDirectChild(q.rootElement.styles,
h,"default-page-layout"));if(c=x.getDirectChild(c,h,"page-layout-properties"))d=c.getAttributeNS(h,"print-orientation")||"portrait","portrait"===d?(d=21.001,e=29.7):(d=29.7,e=21.001),d=f(c.getAttributeNS(w,"page-width"),d),e=f(c.getAttributeNS(w,"page-height"),e),l=f(c.getAttributeNS(w,"margin"),null),null===l?(l=f(c.getAttributeNS(w,"margin-left"),2),n=f(c.getAttributeNS(w,"margin-right"),2),k=f(c.getAttributeNS(w,"margin-top"),2),p=f(c.getAttributeNS(w,"margin-bottom"),2)):l=n=k=p=l,m=f(c.getAttributeNS(w,
"padding"),null),null===m?(m=f(c.getAttributeNS(w,"padding-left"),0),r=f(c.getAttributeNS(w,"padding-right"),0),v=f(c.getAttributeNS(w,"padding-top"),0),u=f(c.getAttributeNS(w,"padding-bottom"),0)):m=r=v=u=m;return{width:d-l-n-m-r,height:e-k-p-v-u}}};
// Input 32
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
odf.StyleTreeNode=function(m){this.derivedStyles={};this.element=m};
odf.Style2CSS=function(){function m(a){var b,c,d,e={};if(!a)return e;for(a=a.firstElementChild;a;){if(c=a.namespaceURI!==h||"style"!==a.localName&&"default-style"!==a.localName?a.namespaceURI===w&&"list-style"===a.localName?"list":a.namespaceURI!==h||"page-layout"!==a.localName&&"default-page-layout"!==a.localName?void 0:"page":a.getAttributeNS(h,"family"))(b=a.getAttributeNS(h,"name"))||(b=""),e.hasOwnProperty(c)?d=e[c]:e[c]=d={},d[b]=a;a=a.nextElementSibling}return e}function k(a,b){if(a.hasOwnProperty(b))return a[b];
var c,d=null;for(c in a)if(a.hasOwnProperty(c)&&(d=k(a[c].derivedStyles,b)))break;return d}function b(a,c,d){var e,f,g;if(!c.hasOwnProperty(a))return null;e=new odf.StyleTreeNode(c[a]);f=e.element.getAttributeNS(h,"parent-style-name");g=null;f&&(g=k(d,f)||b(f,c,d));g?g.derivedStyles[a]=e:d[a]=e;delete c[a];return e}function g(a,c){for(var d in a)a.hasOwnProperty(d)&&b(d,a,c)}function p(a,b,c){var d=[];c=c.derivedStyles;var e;var f=t[a],h;void 0===f?b=null:(h=b?"["+f+'|style-name="'+b+'"]':"","presentation"===
f&&(f="draw",h=b?'[presentation|style-name="'+b+'"]':""),b=f+"|"+s[a].join(h+","+f+"|")+h);null!==b&&d.push(b);for(e in c)c.hasOwnProperty(e)&&(b=p(a,e,c[e]),d=d.concat(b));return d}function l(a,b){var c="",d,e,f;for(d=0;d<b.length;d+=1)if(e=b[d],f=a.getAttributeNS(e[0],e[1])){f=f.trim();if(E.hasOwnProperty(e[1])){var h=f.indexOf(" "),g=void 0,l=void 0;-1!==h?(g=f.substring(0,h),l=f.substring(h)):(g=f,l="");(g=I.parseLength(g))&&"pt"===g.unit&&0.75>g.value&&(f="0.75pt"+l)}e[2]&&(c+=e[2]+":"+f+";")}return c}
function d(b){return(b=u.getDirectChild(b,h,"text-properties"))?I.parseFoFontSize(b.getAttributeNS(a,"font-size")):null}function n(a,b,c,d){return b+b+c+c+d+d}function r(b,c,d,e){c='text|list[text|style-name="'+c+'"]';var f=d.getAttributeNS(w,"level");d=u.getDirectChild(d,h,"list-level-properties");d=u.getDirectChild(d,h,"list-level-label-alignment");var g,l;d&&(g=d.getAttributeNS(a,"text-indent"),l=d.getAttributeNS(a,"margin-left"));g||(g="-0.6cm");d="-"===g.charAt(0)?g.substring(1):"-"+g;for(f=
f&&parseInt(f,10);1<f;)c+=" > text|list-item > text|list",f-=1;if(l){f=c+" > text|list-item > *:not(text|list):first-child";f+="{";f=f+("margin-left:"+l+";")+"}";try{b.insertRule(f,b.cssRules.length)}catch(n){runtime.log("cannot load rule: "+f)}}e=c+" > text|list-item > *:not(text|list):first-child:before{"+e+";";e=e+"counter-increment:list;"+("margin-left:"+g+";");e+="width:"+d+";";e+="display:inline-block}";try{b.insertRule(e,b.cssRules.length)}catch(k){runtime.log("cannot load rule: "+e)}}function f(b,
e,g,k){if("list"===e)for(var m=k.element.firstChild,s,t;m;){if(m.namespaceURI===w)if(s=m,"list-level-style-number"===m.localName){var E=s;t=E.getAttributeNS(h,"num-format");var R=E.getAttributeNS(h,"num-suffix")||"",E=E.getAttributeNS(h,"num-prefix")||"",S={1:"decimal",a:"lower-latin",A:"upper-latin",i:"lower-roman",I:"upper-roman"},U="";E&&(U+=' "'+E+'"');U=S.hasOwnProperty(t)?U+(" counter(list, "+S[t]+")"):t?U+(' "'+t+'"'):U+" ''";t="content:"+U+' "'+R+'"';r(b,g,s,t)}else"list-level-style-image"===
m.localName?(t="content: none;",r(b,g,s,t)):"list-level-style-bullet"===m.localName&&(t="content: '"+s.getAttributeNS(w,"bullet-char")+"';",r(b,g,s,t));m=m.nextSibling}else if("page"===e){if(t=k.element,E=R=g="",m=u.getDirectChild(t,h,"page-layout-properties"))if(s=t.getAttributeNS(h,"name"),g+=l(m,D),(R=u.getDirectChild(m,h,"background-image"))&&(E=R.getAttributeNS(A,"href"))&&(g=g+("background-image: url('odfkit:"+E+"');")+l(R,H)),"presentation"===$)for(t=(t=u.getDirectChild(t.parentNode.parentNode,
c,"master-styles"))&&t.firstElementChild;t;){if(t.namespaceURI===h&&"master-page"===t.localName&&t.getAttributeNS(h,"page-layout-name")===s){E=t.getAttributeNS(h,"name");R="draw|page[draw|master-page-name="+E+"] {"+g+"}";E="office|body, draw|page[draw|master-page-name="+E+"] {"+l(m,ca)+" }";try{b.insertRule(R,b.cssRules.length),b.insertRule(E,b.cssRules.length)}catch(ia){throw ia;}}t=t.nextElementSibling}else if("text"===$){R="office|text {"+g+"}";E="office|body {width: "+m.getAttributeNS(a,"page-width")+
";}";try{b.insertRule(R,b.cssRules.length),b.insertRule(E,b.cssRules.length)}catch(fa){throw fa;}}}else{g=p(e,g,k).join(",");m="";if(s=u.getDirectChild(k.element,h,"text-properties")){E=s;t=U="";R=1;s=""+l(E,z);S=E.getAttributeNS(h,"text-underline-style");"solid"===S&&(U+=" underline");S=E.getAttributeNS(h,"text-line-through-style");"solid"===S&&(U+=" line-through");U.length&&(s+="text-decoration:"+U+";");if(U=E.getAttributeNS(h,"font-name")||E.getAttributeNS(a,"font-family"))S=J[U],s+="font-family: "+
(S||U)+";";S=E.parentNode;if(E=d(S)){for(;S;){if(E=d(S)){if("%"!==E.unit){t="font-size: "+E.value*R+E.unit+";";break}R*=E.value/100}E=S;U=S="";S=null;"default-style"===E.localName?S=null:(S=E.getAttributeNS(h,"parent-style-name"),U=E.getAttributeNS(h,"family"),S=y.getODFElementsWithXPath(V,S?"//style:*[@style:name='"+S+"'][@style:family='"+U+"']":"//style:default-style[@style:family='"+U+"']",odf.Namespaces.lookupNamespaceURI)[0])}t||(t="font-size: "+parseFloat(L)*R+aa.getUnits(L)+";");s+=t}m+=s}if(s=
u.getDirectChild(k.element,h,"paragraph-properties"))t=s,s=""+l(t,M),(R=u.getDirectChild(t,h,"background-image"))&&(E=R.getAttributeNS(A,"href"))&&(s=s+("background-image: url('odfkit:"+E+"');")+l(R,H)),(t=t.getAttributeNS(a,"line-height"))&&"normal"!==t&&(t=I.parseFoLineHeight(t),s="%"!==t.unit?s+("line-height: "+t.value+t.unit+";"):s+("line-height: "+t.value/100+";")),m+=s;if(s=u.getDirectChild(k.element,h,"graphic-properties"))E=s,s=""+l(E,O),t=E.getAttributeNS(q,"opacity"),R=E.getAttributeNS(q,
"fill"),E=E.getAttributeNS(q,"fill-color"),"solid"===R||"hatch"===R?E&&"none"!==E?(t=isNaN(parseFloat(t))?1:parseFloat(t)/100,R=E.replace(/^#?([a-f\d])([a-f\d])([a-f\d])$/i,n),(E=(R=/^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(R))?{r:parseInt(R[1],16),g:parseInt(R[2],16),b:parseInt(R[3],16)}:null)&&(s+="background-color: rgba("+E.r+","+E.g+","+E.b+","+t+");")):s+="background: none;":"none"===R&&(s+="background: none;"),m+=s;if(s=u.getDirectChild(k.element,h,"drawing-page-properties"))t=""+l(s,
O),"true"===s.getAttributeNS(x,"background-visible")&&(t+="background: none;"),m+=t;if(s=u.getDirectChild(k.element,h,"table-cell-properties"))s=""+l(s,F),m+=s;if(s=u.getDirectChild(k.element,h,"table-row-properties"))s=""+l(s,T),m+=s;if(s=u.getDirectChild(k.element,h,"table-column-properties"))s=""+l(s,W),m+=s;if(s=u.getDirectChild(k.element,h,"table-properties"))t=s,s=""+l(t,Z),t=t.getAttributeNS(v,"border-model"),"collapsing"===t?s+="border-collapse:collapse;":"separating"===t&&(s+="border-collapse:separate;"),
m+=s;if(0!==m.length)try{b.insertRule(g+"{"+m+"}",b.cssRules.length)}catch(ea){throw ea;}}for(var ha in k.derivedStyles)k.derivedStyles.hasOwnProperty(ha)&&f(b,e,ha,k.derivedStyles[ha])}var q=odf.Namespaces.drawns,a=odf.Namespaces.fons,c=odf.Namespaces.officens,h=odf.Namespaces.stylens,e=odf.Namespaces.svgns,v=odf.Namespaces.tablens,w=odf.Namespaces.textns,A=odf.Namespaces.xlinkns,x=odf.Namespaces.presentationns,u=new core.DomUtils,t={graphic:"draw","drawing-page":"draw",paragraph:"text",presentation:"presentation",
ruby:"text",section:"text",table:"table","table-cell":"table","table-column":"table","table-row":"table",text:"text",list:"text",page:"office"},s={graphic:"circle connected control custom-shape ellipse frame g line measure page page-thumbnail path polygon polyline rect regular-polygon".split(" "),paragraph:"alphabetical-index-entry-template h illustration-index-entry-template index-source-style object-index-entry-template p table-index-entry-template table-of-content-entry-template user-index-entry-template".split(" "),
presentation:"caption circle connector control custom-shape ellipse frame g line measure page-thumbnail path polygon polyline rect regular-polygon".split(" "),"drawing-page":"caption circle connector control page custom-shape ellipse frame g line measure page-thumbnail path polygon polyline rect regular-polygon".split(" "),ruby:["ruby","ruby-text"],section:"alphabetical-index bibliography illustration-index index-title object-index section table-of-content table-index user-index".split(" "),table:["background",
"table"],"table-cell":"body covered-table-cell even-columns even-rows first-column first-row last-column last-row odd-columns odd-rows table-cell".split(" "),"table-column":["table-column"],"table-row":["table-row"],text:"a index-entry-chapter index-entry-link-end index-entry-link-start index-entry-page-number index-entry-span index-entry-tab-stop index-entry-text index-title-template linenumbering-configuration list-level-style-number list-level-style-bullet outline-level-style span".split(" "),
list:["list-item"]},z=[[a,"color","color"],[a,"background-color","background-color"],[a,"font-weight","font-weight"],[a,"font-style","font-style"]],H=[[h,"repeat","background-repeat"]],M=[[a,"background-color","background-color"],[a,"text-align","text-align"],[a,"text-indent","text-indent"],[a,"padding","padding"],[a,"padding-left","padding-left"],[a,"padding-right","padding-right"],[a,"padding-top","padding-top"],[a,"padding-bottom","padding-bottom"],[a,"border-left","border-left"],[a,"border-right",
"border-right"],[a,"border-top","border-top"],[a,"border-bottom","border-bottom"],[a,"margin","margin"],[a,"margin-left","margin-left"],[a,"margin-right","margin-right"],[a,"margin-top","margin-top"],[a,"margin-bottom","margin-bottom"],[a,"border","border"]],O=[[a,"background-color","background-color"],[a,"min-height","min-height"],[q,"stroke","border"],[e,"stroke-color","border-color"],[e,"stroke-width","border-width"],[a,"border","border"],[a,"border-left","border-left"],[a,"border-right","border-right"],
[a,"border-top","border-top"],[a,"border-bottom","border-bottom"]],F=[[a,"background-color","background-color"],[a,"border-left","border-left"],[a,"border-right","border-right"],[a,"border-top","border-top"],[a,"border-bottom","border-bottom"],[a,"border","border"]],W=[[h,"column-width","width"]],T=[[h,"row-height","height"],[a,"keep-together",null]],Z=[[h,"width","width"],[a,"margin-left","margin-left"],[a,"margin-right","margin-right"],[a,"margin-top","margin-top"],[a,"margin-bottom","margin-bottom"]],
D=[[a,"background-color","background-color"],[a,"padding","padding"],[a,"padding-left","padding-left"],[a,"padding-right","padding-right"],[a,"padding-top","padding-top"],[a,"padding-bottom","padding-bottom"],[a,"border","border"],[a,"border-left","border-left"],[a,"border-right","border-right"],[a,"border-top","border-top"],[a,"border-bottom","border-bottom"],[a,"margin","margin"],[a,"margin-left","margin-left"],[a,"margin-right","margin-right"],[a,"margin-top","margin-top"],[a,"margin-bottom","margin-bottom"]],
ca=[[a,"page-width","width"],[a,"page-height","height"]],E={border:!0,"border-left":!0,"border-right":!0,"border-top":!0,"border-bottom":!0,"stroke-width":!0},J={},I=new odf.OdfUtils,$,V,L,y=xmldom.XPath,aa=new core.CSSUnits;this.style2css=function(a,b,c,d,e){for(var h,l,n,k;b.cssRules.length;)b.deleteRule(b.cssRules.length-1);h=null;d&&(h=d.ownerDocument,V=d.parentNode);e&&(h=e.ownerDocument,V=e.parentNode);if(h)for(k in odf.Namespaces.forEachPrefix(function(a,c){l="@namespace "+a+" url("+c+");";
try{b.insertRule(l,b.cssRules.length)}catch(d){}}),J=c,$=a,L=runtime.getWindow().getComputedStyle(document.body,null).getPropertyValue("font-size")||"12pt",a=m(d),d=m(e),e={},t)if(t.hasOwnProperty(k))for(n in c=e[k]={},g(a[k],c),g(d[k],c),c)c.hasOwnProperty(n)&&f(b,k,n,c[n])}};
// Input 33
/*

 Copyright (C) 2014 KO GmbH <copyright@kogmbh.com>

 @licstart
 This file is part of WebODF.

 WebODF is free software: you can redistribute it and/or modify it
 under the terms of the GNU Affero General Public License (GNU AGPL)
 as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.

 WebODF is distributed in the hope that it will be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Affero General Public License for more details.

 You should have received a copy of the GNU Affero General Public License
 along with WebODF.  If not, see <http://www.gnu.org/licenses/>.
 @licend

 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
(function(){function m(k,b){var g=this;this.getDistance=function(b){var l=g.x-b.x;b=g.y-b.y;return Math.sqrt(l*l+b*b)};this.getCenter=function(b){return new m((g.x+b.x)/2,(g.y+b.y)/2)};g.x=k;g.y=b}gui.ZoomHelper=function(){function k(a,b,d,e){a=e?"translate3d("+a+"px, "+b+"px, 0) scale3d("+d+", "+d+", 1)":"translate("+a+"px, "+b+"px) scale("+d+")";c.style.WebkitTransform=a;c.style.MozTransform=a;c.style.msTransform=a;c.style.OTransform=a;c.style.transform=a}function b(a){a?k(-h.x,-h.y,w,!0):(k(0,
0,w,!0),k(0,0,w,!1))}function g(a){if(u&&H){var b=u.style.overflow,c=u.classList.contains("webodf-customScrollbars");a&&c||!a&&!c||(a?(u.classList.add("webodf-customScrollbars"),u.style.overflow="hidden",runtime.requestAnimationFrame(function(){u.style.overflow=b})):u.classList.remove("webodf-customScrollbars"))}}function p(){k(-h.x,-h.y,w,!0);u.scrollLeft=0;u.scrollTop=0;g(!1)}function l(){k(0,0,w,!0);u.scrollLeft=h.x;u.scrollTop=h.y;g(!0)}function d(a){return new m(a.pageX-c.offsetLeft,a.pageY-
c.offsetTop)}function n(a){e&&(h.x-=a.x-e.x,h.y-=a.y-e.y,h=new m(Math.min(Math.max(h.x,c.offsetLeft),(c.offsetLeft+c.offsetWidth)*w-u.clientWidth),Math.min(Math.max(h.y,c.offsetTop),(c.offsetTop+c.offsetHeight)*w-u.clientHeight)));e=a}function r(a){var b=a.touches.length,c=0<b?d(a.touches[0]):null;a=1<b?d(a.touches[1]):null;c&&a?(v=c.getDistance(a),A=w,e=c.getCenter(a),p(),z=s.PINCH):c&&(e=c,z=s.SCROLL)}function f(a){var e=a.touches.length,f=0<e?d(a.touches[0]):null,e=1<e?d(a.touches[1]):null;if(f&&
e)if(a.preventDefault(),z===s.SCROLL)z=s.PINCH,p(),v=f.getDistance(e);else{a=f.getCenter(e);f=f.getDistance(e)/v;n(a);var e=w,g=Math.min(x,c.offsetParent.clientWidth/c.offsetWidth);w=A*f;w=Math.min(Math.max(w,g),x);f=w/e;h.x+=(f-1)*(a.x+h.x);h.y+=(f-1)*(a.y+h.y);b(!0)}else f&&(z===s.PINCH?(z=s.SCROLL,l()):n(f))}function q(){z===s.PINCH&&(t.emit(gui.ZoomHelper.signalZoomChanged,w),l(),b(!1));z=s.NONE}function a(){u&&(u.removeEventListener("touchstart",r,!1),u.removeEventListener("touchmove",f,!1),
u.removeEventListener("touchend",q,!1))}var c,h,e,v,w,A,x=4,u,t=new core.EventNotifier([gui.ZoomHelper.signalZoomChanged]),s={NONE:0,SCROLL:1,PINCH:2},z=s.NONE,H=runtime.getWindow().hasOwnProperty("ontouchstart");this.subscribe=function(a,b){t.subscribe(a,b)};this.unsubscribe=function(a,b){t.unsubscribe(a,b)};this.getZoomLevel=function(){return w};this.setZoomLevel=function(a){c&&(w=a,b(!1),t.emit(gui.ZoomHelper.signalZoomChanged,w))};this.destroy=function(b){a();g(!1);b()};this.setZoomableElement=
function(d){a();c=d;u=c.offsetParent;b(!1);u&&(u.addEventListener("touchstart",r,!1),u.addEventListener("touchmove",f,!1),u.addEventListener("touchend",q,!1));g(!0)};A=w=1;h=new m(0,0)};gui.ZoomHelper.signalZoomChanged="zoomChanged"})();
// Input 34
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.Canvas=function(){};ops.Canvas.prototype.getZoomLevel=function(){};ops.Canvas.prototype.getElement=function(){};ops.Canvas.prototype.getZoomHelper=function(){};
// Input 35
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
(function(){function m(){function a(d){c=!0;runtime.setTimeout(function(){try{d()}catch(e){runtime.log(String(e))}c=!1;0<b.length&&a(b.pop())},10)}var b=[],c=!1;this.clearQueue=function(){b.length=0};this.addToQueue=function(d){if(0===b.length&&!c)return a(d);b.push(d)}}function k(a){function b(){for(;0<c.cssRules.length;)c.deleteRule(0);c.insertRule("#shadowContent draw|page {display:none;}",0);c.insertRule("office|presentation draw|page {display:none;}",1);c.insertRule("#shadowContent draw|page:nth-of-type("+
d+") {display:block;}",2);c.insertRule("office|presentation draw|page:nth-of-type("+d+") {display:block;}",3)}var c=a.sheet,d=1;this.showFirstPage=function(){d=1;b()};this.showNextPage=function(){d+=1;b()};this.showPreviousPage=function(){1<d&&(d-=1,b())};this.showPage=function(a){0<a&&(d=a,b())};this.css=a;this.destroy=function(b){a.parentNode.removeChild(a);b()}}function b(a){for(;a.firstChild;)a.removeChild(a.firstChild)}function g(a){a=a.sheet;for(var b=a.cssRules;b.length;)a.deleteRule(b.length-
1)}function p(a,b,c){(new odf.Style2CSS).style2css(a.getDocumentType(),c.sheet,b.getFontMap(),a.rootElement.styles,a.rootElement.automaticStyles)}function l(a,b,c){var d=null;a=a.rootElement.body.getElementsByTagNameNS(F,c+"-decl");c=b.getAttributeNS(F,"use-"+c+"-name");var e;if(c&&0<a.length)for(b=0;b<a.length;b+=1)if(e=a[b],e.getAttributeNS(F,"name")===c){d=e.textContent;break}return d}function d(a,c,d,e){var f=a.ownerDocument;c=a.getElementsByTagNameNS(c,d);for(a=0;a<c.length;a+=1)b(c[a]),e&&(d=
c[a],d.appendChild(f.createTextNode(e)))}function n(a,b,c){b.setAttributeNS("urn:webodf:names:helper","styleid",a);var d,e=b.getAttributeNS(H,"anchor-type"),f=b.getAttributeNS(s,"x"),h=b.getAttributeNS(s,"y"),g=b.getAttributeNS(s,"width"),l=b.getAttributeNS(s,"height"),n=b.getAttributeNS(x,"min-height"),k=b.getAttributeNS(x,"min-width");if("as-char"===e)d="display: inline-block;";else if(e||f||h)d="position: absolute;";else if(g||l||n||k)d="display: block;";f&&(d+="left: "+f+";");h&&(d+="top: "+h+
";");g&&(d+="width: "+g+";");l&&(d+="height: "+l+";");n&&(d+="min-height: "+n+";");k&&(d+="min-width: "+k+";");d&&(d="draw|"+b.localName+'[webodfhelper|styleid="'+a+'"] {'+d+"}",c.insertRule(d,c.cssRules.length))}function r(a){for(a=a.firstChild;a;){if(a.namespaceURI===u&&"binary-data"===a.localName)return"data:image/png;base64,"+a.textContent.replace(/[\r\n\s]/g,"");a=a.nextSibling}return""}function f(a,b,c,d){function e(b){b&&(b='draw|image[webodfhelper|styleid="'+a+'"] {'+("background-image: url("+
b+");")+"}",d.insertRule(b,d.cssRules.length))}function f(a){e(a.url)}c.setAttributeNS("urn:webodf:names:helper","styleid",a);var h=c.getAttributeNS(M,"href"),g;if(h)try{g=b.getPart(h),g.onchange=f,g.load()}catch(l){runtime.log("slight problem: "+String(l))}else h=r(c),e(h)}function q(a){var b=a.ownerDocument;D.getElementsByTagNameNS(a,H,"line-break").forEach(function(a){a.hasChildNodes()||a.appendChild(b.createElement("br"))})}function a(a){var b=a.ownerDocument;D.getElementsByTagNameNS(a,H,"s").forEach(function(a){for(var c,
d;a.firstChild;)a.removeChild(a.firstChild);a.appendChild(b.createTextNode(" "));d=parseInt(a.getAttributeNS(H,"c"),10);if(1<d)for(a.removeAttributeNS(H,"c"),c=1;c<d;c+=1)a.parentNode.insertBefore(a.cloneNode(!0),a)})}function c(a){D.getElementsByTagNameNS(a,H,"tab").forEach(function(a){a.textContent="\t"})}function h(a,b){function c(a,d){var h=g.documentElement.namespaceURI;"video/"===d.substr(0,6)?(e=g.createElementNS(h,"video"),e.setAttribute("controls","controls"),f=g.createElementNS(h,"source"),
a&&f.setAttribute("src",a),f.setAttribute("type",d),e.appendChild(f),b.parentNode.appendChild(e)):b.innerHtml="Unrecognised Plugin"}function d(a){c(a.url,a.mimetype)}var e,f,h,g=b.ownerDocument,l;if(h=b.getAttributeNS(M,"href"))try{l=a.getPart(h),l.onchange=d,l.load()}catch(n){runtime.log("slight problem: "+String(n))}else runtime.log("using MP4 data fallback"),h=r(b),c(h,"video/mp4")}function e(a){var b=a.getElementsByTagName("head")[0],c,d;c=a.styleSheets.length;for(d=b.firstElementChild;d&&("style"!==
d.localName||!d.hasAttribute("webodfcss"));)d=d.nextElementSibling;if(d)return c=parseInt(d.getAttribute("webodfcss"),10),d.setAttribute("webodfcss",c+1),d;"string"===String(typeof webodf_css)?c=webodf_css:(d="webodf.css",runtime.currentDirectory&&(d=runtime.currentDirectory(),0<d.length&&"/"!==d.substr(-1)&&(d+="/"),d+="../webodf.css"),c=runtime.readFileSync(d,"utf-8"));d=a.createElementNS(b.namespaceURI,"style");d.setAttribute("media","screen, print, handheld, projection");d.setAttribute("type",
"text/css");d.setAttribute("webodfcss","1");d.appendChild(a.createTextNode(c));b.appendChild(d);return d}function v(a){var b=parseInt(a.getAttribute("webodfcss"),10);1===b?a.parentNode.removeChild(a):a.setAttribute("count",b-1)}function w(a){var b=a.getElementsByTagName("head")[0],c=a.createElementNS(b.namespaceURI,"style"),d="";c.setAttribute("type","text/css");c.setAttribute("media","screen, print, handheld, projection");odf.Namespaces.forEachPrefix(function(a,b){d+="@namespace "+a+" url("+b+");\n"});
d+="@namespace webodfhelper url(urn:webodf:names:helper);\n";c.appendChild(a.createTextNode(d));b.appendChild(c);return c}var A=odf.Namespaces.drawns,x=odf.Namespaces.fons,u=odf.Namespaces.officens,t=odf.Namespaces.stylens,s=odf.Namespaces.svgns,z=odf.Namespaces.tablens,H=odf.Namespaces.textns,M=odf.Namespaces.xlinkns,O=odf.Namespaces.xmlns,F=odf.Namespaces.presentationns,W=runtime.getWindow(),T=xmldom.XPath,Z=new odf.OdfUtils,D=new core.DomUtils;odf.OdfCanvas=function(r){function s(a,b,c){function d(a,
b,c,e){ka.addToQueue(function(){f(a,b,c,e)})}var e,h;e=b.getElementsByTagNameNS(A,"image");for(b=0;b<e.length;b+=1)h=e.item(b),d("image"+String(b),a,h,c)}function M(a,b){function c(a,b){ka.addToQueue(function(){h(a,b)})}var d,e,f;e=b.getElementsByTagNameNS(A,"plugin");for(d=0;d<e.length;d+=1)f=e.item(d),c(a,f)}function x(){var a;a=Q.firstChild;var b=Y.getZoomLevel();a&&(Q.style.WebkitTransformOrigin="0% 0%",Q.style.MozTransformOrigin="0% 0%",Q.style.msTransformOrigin="0% 0%",Q.style.OTransformOrigin=
"0% 0%",Q.style.transformOrigin="0% 0%",G&&((a=G.getMinimumHeightForAnnotationPane())?Q.style.minHeight=a:Q.style.removeProperty("min-height")),r.style.width=Math.round(b*Q.offsetWidth)+"px",r.style.height=Math.round(b*Q.offsetHeight)+"px")}function $(a){la?(ba.parentNode||Q.appendChild(ba),G&&G.forgetAnnotations(),G=new gui.AnnotationViewManager(y,a.body,ba,da),D.getElementsByTagNameNS(a.body,u,"annotation").forEach(G.addAnnotation),G.rerenderAnnotations(),x()):ba.parentNode&&(Q.removeChild(ba),
G.forgetAnnotations(),x())}function V(e){function f(){g(S);g(U);g(ia);b(r);r.style.display="inline-block";var h=X.rootElement;r.ownerDocument.importNode(h,!0);P.setOdfContainer(X);var k=X,m=S;(new odf.FontLoader).loadFonts(k,m.sheet);p(X,P,U);m=X;k=ia.sheet;b(r);Q=aa.createElementNS(r.namespaceURI,"div");Q.style.display="inline-block";Q.style.background="white";Q.style.setProperty("float","left","important");Q.appendChild(h);r.appendChild(Q);ba=aa.createElementNS(r.namespaceURI,"div");ba.id="annotationsPane";
fa=aa.createElementNS(r.namespaceURI,"div");fa.id="shadowContent";fa.style.position="absolute";fa.style.top=0;fa.style.left=0;m.getContentElement().appendChild(fa);var v=h.body,w,x=[],y;for(w=v.firstElementChild;w&&w!==v;)if(w.namespaceURI===A&&(x[x.length]=w),w.firstElementChild)w=w.firstElementChild;else{for(;w&&w!==v&&!w.nextElementSibling;)w=w.parentNode;w&&w.nextElementSibling&&(w=w.nextElementSibling)}for(y=0;y<x.length;y+=1)w=x[y],n("frame"+String(y),w,k);x=T.getODFElementsWithXPath(v,".//*[*[@text:anchor-type='paragraph']]",
odf.Namespaces.lookupNamespaceURI);for(w=0;w<x.length;w+=1)v=x[w],v.setAttributeNS&&v.setAttributeNS("urn:webodf:names:helper","containsparagraphanchor",!0);var v=fa,D,V,I;I=0;var L,K,x=m.rootElement.ownerDocument;if((w=h.body.firstElementChild)&&w.namespaceURI===u&&("presentation"===w.localName||"drawing"===w.localName))for(w=w.firstElementChild;w;){y=w.getAttributeNS(A,"master-page-name");if(y){for(D=m.rootElement.masterStyles.firstElementChild;D&&(D.getAttributeNS(t,"name")!==y||"master-page"!==
D.localName||D.namespaceURI!==t);)D=D.nextElementSibling;y=D}else y=null;if(y){D=w.getAttributeNS("urn:webodf:names:helper","styleid");V=x.createElementNS(A,"draw:page");K=y.firstElementChild;for(L=0;K;)"true"!==K.getAttributeNS(F,"placeholder")&&(I=K.cloneNode(!0),V.appendChild(I),n(D+"_"+L,I,k)),K=K.nextElementSibling,L+=1;K=L=I=void 0;var G=V.getElementsByTagNameNS(A,"frame");for(I=0;I<G.length;I+=1)L=G[I],(K=L.getAttributeNS(F,"class"))&&!/^(date-time|footer|header|page-number)$/.test(K)&&L.parentNode.removeChild(L);
v.appendChild(V);I=String(v.getElementsByTagNameNS(A,"page").length);d(V,H,"page-number",I);d(V,F,"header",l(m,w,"header"));d(V,F,"footer",l(m,w,"footer"));n(D,V,k);V.setAttributeNS(A,"draw:master-page-name",y.getAttributeNS(t,"name"))}w=w.nextElementSibling}v=r.namespaceURI;x=h.body.getElementsByTagNameNS(z,"table-cell");for(w=0;w<x.length;w+=1)y=x.item(w),y.hasAttributeNS(z,"number-columns-spanned")&&y.setAttributeNS(v,"colspan",y.getAttributeNS(z,"number-columns-spanned")),y.hasAttributeNS(z,"number-rows-spanned")&&
y.setAttributeNS(v,"rowspan",y.getAttributeNS(z,"number-rows-spanned"));q(h.body);a(h.body);c(h.body);s(m,h.body,k);M(m,h.body);y=h.body;m=r.namespaceURI;w={};var x={},N;D=W.document.getElementsByTagNameNS(H,"list-style");for(v=0;v<D.length;v+=1)L=D.item(v),(K=L.getAttributeNS(t,"name"))&&(x[K]=L);y=y.getElementsByTagNameNS(H,"list");for(v=0;v<y.length;v+=1)if(L=y.item(v),D=L.getAttributeNS(O,"id")){V=L.getAttributeNS(H,"continue-list");L.setAttributeNS(m,"id",D);I="text|list#"+D+" > text|list-item > *:first-child:before {";
if(K=L.getAttributeNS(H,"style-name")){L=x[K];N=Z.getFirstNonWhitespaceChild(L);L=void 0;if(N)if("list-level-style-number"===N.localName){L=N.getAttributeNS(t,"num-format");K=N.getAttributeNS(t,"num-suffix")||"";var G="",G={1:"decimal",a:"lower-latin",A:"upper-latin",i:"lower-roman",I:"upper-roman"},R=void 0,R=N.getAttributeNS(t,"num-prefix")||"",R=G.hasOwnProperty(L)?R+(" counter(list, "+G[L]+")"):L?R+("'"+L+"';"):R+" ''";K&&(R+=" '"+K+"'");L=G="content: "+R+";"}else"list-level-style-image"===N.localName?
L="content: none;":"list-level-style-bullet"===N.localName&&(L="content: '"+N.getAttributeNS(H,"bullet-char")+"';");N=L}if(V){for(L=w[V];L;)L=w[L];I+="counter-increment:"+V+";";N?(N=N.replace("list",V),I+=N):I+="content:counter("+V+");"}else V="",N?(N=N.replace("list",D),I+=N):I+="content: counter("+D+");",I+="counter-increment:"+D+";",k.insertRule("text|list#"+D+" {counter-reset:"+D+"}",k.cssRules.length);I+="}";w[D]=V;I&&k.insertRule(I,k.cssRules.length)}Q.insertBefore(fa,Q.firstChild);Y.setZoomableElement(Q);
$(h);if(!e&&(h=[X],ea.hasOwnProperty("statereadychange")))for(k=ea.statereadychange,N=0;N<k.length;N+=1)k[N].apply(null,h)}X.state===odf.OdfContainer.DONE?f():(runtime.log("WARNING: refreshOdf called but ODF was not DONE."),ha=runtime.setTimeout(function B(){X.state===odf.OdfContainer.DONE?f():(runtime.log("will be back later..."),ha=runtime.setTimeout(B,500))},100))}function L(a){ka.clearQueue();r.innerHTML=runtime.tr("Loading")+" "+a+"...";r.removeAttribute("style");X=new odf.OdfContainer(a,function(a){X=
a;V(!1)})}runtime.assert(null!==r&&void 0!==r,"odf.OdfCanvas constructor needs DOM element");runtime.assert(null!==r.ownerDocument&&void 0!==r.ownerDocument,"odf.OdfCanvas constructor needs DOM");var y=this,aa=r.ownerDocument,X,P=new odf.Formatting,N,Q=null,ba=null,la=!1,da=!1,G=null,R,S,U,ia,fa,ea={},ha,ja,ma=!1,ga=!1,ka=new m,Y=new gui.ZoomHelper;this.refreshCSS=function(){ma=!0;ja.trigger()};this.refreshSize=function(){ja.trigger()};this.odfContainer=function(){return X};this.setOdfContainer=function(a,
b){X=a;V(!0===b)};this.load=this.load=L;this.save=function(a){X.save(a)};this.addListener=function(a,b){switch(a){case "click":var c=r,d=a;c.addEventListener?c.addEventListener(d,b,!1):c.attachEvent?c.attachEvent("on"+d,b):c["on"+d]=b;break;default:c=ea.hasOwnProperty(a)?ea[a]:ea[a]=[],b&&-1===c.indexOf(b)&&c.push(b)}};this.getFormatting=function(){return P};this.getAnnotationViewManager=function(){return G};this.refreshAnnotations=function(){$(X.rootElement)};this.rerenderAnnotations=function(){G&&
(ga=!0,ja.trigger())};this.getSizer=function(){return Q};this.enableAnnotations=function(a,b){a!==la&&(la=a,da=b,X&&$(X.rootElement))};this.addAnnotation=function(a){G&&(G.addAnnotation(a),x())};this.forgetAnnotations=function(){G&&(G.forgetAnnotations(),x())};this.getZoomHelper=function(){return Y};this.setZoomLevel=function(a){Y.setZoomLevel(a)};this.getZoomLevel=function(){return Y.getZoomLevel()};this.fitToContainingElement=function(a,b){var c=Y.getZoomLevel(),d=r.offsetHeight/c,c=a/(r.offsetWidth/
c);b/d<c&&(c=b/d);Y.setZoomLevel(c)};this.fitToWidth=function(a){var b=r.offsetWidth/Y.getZoomLevel();Y.setZoomLevel(a/b)};this.fitSmart=function(a,b){var c,d;d=Y.getZoomLevel();c=r.offsetWidth/d;d=r.offsetHeight/d;c=a/c;void 0!==b&&b/d<c&&(c=b/d);Y.setZoomLevel(Math.min(1,c))};this.fitToHeight=function(a){var b=r.offsetHeight/Y.getZoomLevel();Y.setZoomLevel(a/b)};this.showFirstPage=function(){N.showFirstPage()};this.showNextPage=function(){N.showNextPage()};this.showPreviousPage=function(){N.showPreviousPage()};
this.showPage=function(a){N.showPage(a);x()};this.getElement=function(){return r};this.addCssForFrameWithImage=function(a){var b=a.getAttributeNS(A,"name"),c=a.firstElementChild;n(b,a,ia.sheet);c&&f(b+"img",X,c,ia.sheet)};this.destroy=function(a){var b=aa.getElementsByTagName("head")[0],c=[N.destroy,ja.destroy];runtime.clearTimeout(ha);ba&&ba.parentNode&&ba.parentNode.removeChild(ba);Y.destroy(function(){Q&&(r.removeChild(Q),Q=null)});v(R);b.removeChild(S);b.removeChild(U);b.removeChild(ia);core.Async.destroyAll(c,
a)};R=e(aa);N=new k(w(aa));S=w(aa);U=w(aa);ia=w(aa);ja=new core.ScheduledTask(function(){ma&&(p(X,P,U),ma=!1);ga&&(G&&G.rerenderAnnotations(),ga=!1);x()},0);Y.subscribe(gui.ZoomHelper.signalZoomChanged,x)}})();
// Input 36
/*

 Copyright (C) 2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 This file is part of WebODF.

 WebODF is free software: you can redistribute it and/or modify it
 under the terms of the GNU Affero General Public License (GNU AGPL)
 as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.

 WebODF is distributed in the hope that it will be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Affero General Public License for more details.

 You should have received a copy of the GNU Affero General Public License
 along with WebODF.  If not, see <http://www.gnu.org/licenses/>.
 @licend

 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.MemberProperties=function(){};
ops.Member=function(m,k){var b=new ops.MemberProperties;this.getMemberId=function(){return m};this.getProperties=function(){return b};this.setProperties=function(g){Object.keys(g).forEach(function(k){b[k]=g[k]})};this.removeProperties=function(g){Object.keys(g).forEach(function(g){"fullName"!==g&&"color"!==g&&"imageUrl"!==g&&b.hasOwnProperty(g)&&delete b[g]})};runtime.assert(Boolean(m),"No memberId was supplied!");k.fullName||(k.fullName=runtime.tr("Unknown Author"));k.color||(k.color="black");k.imageUrl||
(k.imageUrl="avatar-joe.png");b=k};
// Input 37
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
gui.SelectionMover=function(m,k){function b(){q.setUnfilteredPosition(m.getNode(),0);return q}function g(a,b){var d,f=null;a&&0<a.length&&(d=b?a.item(a.length-1):a.item(0));d&&(f={top:d.top,left:b?d.right:d.left,bottom:d.bottom});return f}function p(a,b,d,f){var l=a.nodeType;d.setStart(a,b);d.collapse(!f);f=g(d.getClientRects(),!0===f);!f&&0<b&&(d.setStart(a,b-1),d.setEnd(a,b),f=g(d.getClientRects(),!0));f||(l===Node.ELEMENT_NODE&&0<b&&a.childNodes.length>=b?f=p(a,b-1,d,!0):a.nodeType===Node.TEXT_NODE&&
0<b?f=p(a,b-1,d,!0):a.previousSibling?f=p(a.previousSibling,a.previousSibling.nodeType===Node.TEXT_NODE?a.previousSibling.textContent.length:a.previousSibling.childNodes.length,d,!0):a.parentNode&&a.parentNode!==k?f=p(a.parentNode,0,d,!1):(d.selectNode(k),f=g(d.getClientRects(),!1)));runtime.assert(Boolean(f),"No visible rectangle found");return f}function l(c,d,e){for(var f=b(),g=new core.LoopWatchDog(1E4),l=0,k=0;0<c&&f.nextPosition();)g.check(),e.acceptPosition(f)===a&&(l+=1,d.acceptPosition(f)===
a&&(k+=l,l=0,c-=1));return k}function d(c,d,e){for(var f=b(),g=new core.LoopWatchDog(1E4),l=0,k=0;0<c&&f.previousPosition();)g.check(),e.acceptPosition(f)===a&&(l+=1,d.acceptPosition(f)===a&&(k+=l,l=0,c-=1));return k}function n(c,d){var e=b(),f=0,g=0,l=0>c?-1:1;for(c=Math.abs(c);0<c;){for(var n=d,m=l,r=e,q=r.container(),z=0,H=null,M=void 0,O=10,F=void 0,W=0,T=void 0,Z=void 0,D=void 0,F=void 0,ca=k.ownerDocument.createRange(),E=new core.LoopWatchDog(1E4),F=p(q,r.unfilteredDomOffset(),ca),T=F.top,Z=
F.left,D=T;!0===(0>m?r.previousPosition():r.nextPosition());)if(E.check(),n.acceptPosition(r)===a&&(z+=1,q=r.container(),F=p(q,r.unfilteredDomOffset(),ca),F.top!==T)){if(F.top!==D&&D!==T)break;D=F.top;F=Math.abs(Z-F.left);if(null===H||F<O)H=q,M=r.unfilteredDomOffset(),O=F,W=z}null!==H?(r.setUnfilteredPosition(H,M),z=W):z=0;ca.detach();f+=z;if(0===f)break;g+=f;c-=1}return g*l}function r(c,d){var e,g,l,n,m=b(),r=f.getParagraphElement(m.getCurrentNode()),q=0,s=k.ownerDocument.createRange();0>c?(e=m.previousPosition,
g=-1):(e=m.nextPosition,g=1);for(l=p(m.container(),m.unfilteredDomOffset(),s);e.call(m);)if(d.acceptPosition(m)===a){if(f.getParagraphElement(m.getCurrentNode())!==r)break;n=p(m.container(),m.unfilteredDomOffset(),s);if(n.bottom!==l.bottom&&(l=n.top>=l.top&&n.bottom<l.bottom||n.top<=l.top&&n.bottom>l.bottom,!l))break;q+=g;l=n}s.detach();return q}var f=new odf.OdfUtils,q,a=core.PositionFilter.FilterResult.FILTER_ACCEPT;this.getStepCounter=function(){return{convertForwardStepsBetweenFilters:l,convertBackwardStepsBetweenFilters:d,
countLinesSteps:n,countStepsToLineBoundary:r}};(function(){q=gui.SelectionMover.createPositionIterator(k);var a=k.ownerDocument.createRange();a.setStart(q.container(),q.unfilteredDomOffset());a.collapse(!0);m.setSelectedRange(a)})()};
gui.SelectionMover.createPositionIterator=function(m){var k=new function(){this.acceptNode=function(b){return b&&"urn:webodf:names:cursor"!==b.namespaceURI&&"urn:webodf:names:editinfo"!==b.namespaceURI?NodeFilter.FILTER_ACCEPT:NodeFilter.FILTER_REJECT}};return new core.PositionIterator(m,5,k,!1)};(function(){return gui.SelectionMover})();
// Input 38
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.Document=function(){};ops.Document.prototype.getMemberIds=function(){};ops.Document.prototype.removeCursor=function(m){};ops.Document.prototype.getDocumentElement=function(){};ops.Document.prototype.getRootNode=function(){};ops.Document.prototype.getDOMDocument=function(){};ops.Document.prototype.cloneDocumentElement=function(){};ops.Document.prototype.setDocumentElement=function(m){};ops.Document.prototype.subscribe=function(m,k){};ops.Document.prototype.unsubscribe=function(m,k){};
ops.Document.prototype.getCanvas=function(){};ops.Document.prototype.createRootFilter=function(m){};ops.Document.signalCursorAdded="cursor/added";ops.Document.signalCursorRemoved="cursor/removed";ops.Document.signalCursorMoved="cursor/moved";ops.Document.signalMemberAdded="member/added";ops.Document.signalMemberUpdated="member/updated";ops.Document.signalMemberRemoved="member/removed";
// Input 39
ops.OdtCursor=function(m,k){var b=this,g={},p,l,d,n=new core.EventNotifier([ops.OdtCursor.signalCursorUpdated]);this.removeFromDocument=function(){d.remove()};this.subscribe=function(b,d){n.subscribe(b,d)};this.unsubscribe=function(b,d){n.unsubscribe(b,d)};this.getStepCounter=function(){return l.getStepCounter()};this.getMemberId=function(){return m};this.getNode=function(){return d.getNode()};this.getAnchorNode=function(){return d.getAnchorNode()};this.getSelectedRange=function(){return d.getSelectedRange()};
this.setSelectedRange=function(g,f){d.setSelectedRange(g,f);n.emit(ops.OdtCursor.signalCursorUpdated,b)};this.hasForwardSelection=function(){return d.hasForwardSelection()};this.getDocument=function(){return k};this.getSelectionType=function(){return p};this.setSelectionType=function(b){g.hasOwnProperty(b)?p=b:runtime.log("Invalid selection type: "+b)};this.resetSelectionType=function(){b.setSelectionType(ops.OdtCursor.RangeSelection)};d=new core.Cursor(k.getDOMDocument(),m);l=new gui.SelectionMover(d,
k.getRootNode());g[ops.OdtCursor.RangeSelection]=!0;g[ops.OdtCursor.RegionSelection]=!0;b.resetSelectionType()};ops.OdtCursor.RangeSelection="Range";ops.OdtCursor.RegionSelection="Region";ops.OdtCursor.signalCursorUpdated="cursorUpdated";(function(){return ops.OdtCursor})();
// Input 40
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.Operation=function(){};ops.Operation.prototype.init=function(m){};ops.Operation.prototype.execute=function(m){};ops.Operation.prototype.spec=function(){};
// Input 41
/*

 Copyright (C) 2010-2014 KO GmbH <copyright@kogmbh.com>

 @licstart
 This file is part of WebODF.

 WebODF is free software: you can redistribute it and/or modify it
 under the terms of the GNU Affero General Public License (GNU AGPL)
 as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.

 WebODF is distributed in the hope that it will be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Affero General Public License for more details.

 You should have received a copy of the GNU Affero General Public License
 along with WebODF.  If not, see <http://www.gnu.org/licenses/>.
 @licend

 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
(function(){var m=0;ops.StepsCache=function(k,b,g){function p(a,c,d){this.nodeId=a;this.steps=c;this.node=d;this.previousBookmark=this.nextBookmark=null;this.setIteratorPosition=function(a){a.setPositionBeforeElement(d);do if(b.acceptPosition(a)===t)break;while(a.nextPosition())}}function l(a,c,d){this.nodeId=a;this.steps=c;this.node=d;this.previousBookmark=this.nextBookmark=null;this.setIteratorPosition=function(a){a.setUnfilteredPosition(d,0);do if(b.acceptPosition(a)===t)break;while(a.nextPosition())}}
function d(a,b){var c="["+a.nodeId;b&&(c+=" => "+b.nodeId);return c+"]"}function n(){for(var a=x,b,c,e,f=new core.LoopWatchDog(0,1E5);a;){f.check();(b=a.previousBookmark)?runtime.assert(b.nextBookmark===a,"Broken bookmark link to previous @"+d(b,a)):(runtime.assert(a===x,"Broken bookmark link @"+d(a)),runtime.assert(void 0===u||x.steps<=u,"Base point is damaged @"+d(a)));(c=a.nextBookmark)&&runtime.assert(c.previousBookmark===a,"Broken bookmark link to next @"+d(a,c));if(void 0===u||a.steps<=u)runtime.assert(A.containsNode(k,
a.node),"Disconnected node is being reported as undamaged @"+d(a)),b&&(e=a.node.compareDocumentPosition(b.node),runtime.assert(0===e||0!==(e&Node.DOCUMENT_POSITION_PRECEDING),"Bookmark order with previous does not reflect DOM order @"+d(b,a))),c&&A.containsNode(k,c.node)&&(e=a.node.compareDocumentPosition(c.node),runtime.assert(0===e||0!==(e&Node.DOCUMENT_POSITION_FOLLOWING),"Bookmark order with next does not reflect DOM order @"+d(a,c)));a=a.nextBookmark}}function r(a){var b="";a.nodeType===Node.ELEMENT_NODE&&
(b=a.getAttributeNS(h,"nodeId"));return b}function f(a){var b=m.toString();a.setAttributeNS(h,"nodeId",b);m+=1;return b}function q(a){var b,c,d=new core.LoopWatchDog(0,1E4);void 0!==u&&a>u&&(a=u);for(b=Math.floor(a/g)*g;!c&&0!==b;)c=e[b],b-=g;for(c=c||x;c.nextBookmark&&c.nextBookmark.steps<=a;)d.check(),c=c.nextBookmark;return c}function a(a){a.previousBookmark&&(a.previousBookmark.nextBookmark=a.nextBookmark);a.nextBookmark&&(a.nextBookmark.previousBookmark=a.previousBookmark)}function c(a){for(var b,
c=null;!c&&a&&a!==k;)(b=r(a))&&(c=v[b])&&c.node!==a&&(runtime.log("Cloned node detected. Creating new bookmark"),c=null,a.removeAttributeNS(h,"nodeId")),a=a.parentNode;return c}var h="urn:webodf:names:steps",e={},v={},w=new odf.OdfUtils,A=new core.DomUtils,x,u,t=core.PositionFilter.FilterResult.FILTER_ACCEPT,s;this.updateCache=function(b,c,d){var h;h=c.getCurrentNode();if(c.isBeforeNode()&&w.isParagraph(h)){d||(b+=1);c=b;var l,n,m;if(void 0!==u&&u<c){l=q(u);for(d=l.nextBookmark;d&&d.steps<=c;)n=d.nextBookmark,
m=Math.ceil(d.steps/g)*g,e[m]===d&&delete e[m],A.containsNode(k,d.node)?d.steps=c+1:(a(d),delete v[d.nodeId]),d=n;u=c}else l=q(c);c=l;d=r(h)||f(h);(l=v[d])?l.node===h?l.steps=b:(runtime.log("Cloned node detected. Creating new bookmark"),d=f(h),l=v[d]=new p(d,b,h)):l=v[d]=new p(d,b,h);h=l;c!==h&&c.nextBookmark!==h&&(a(h),b=c.nextBookmark,h.nextBookmark=c.nextBookmark,h.previousBookmark=c,c.nextBookmark=h,b&&(b.previousBookmark=h));b=Math.ceil(h.steps/g)*g;c=e[b];if(!c||h.steps>c.steps)e[b]=h;s()}};
this.setToClosestStep=function(a,b){var c;s();c=q(a);c.setIteratorPosition(b);return c.steps};this.setToClosestDomPoint=function(a,b,d){var f,h;s();if(a===k&&0===b)f=x;else if(a===k&&b===k.childNodes.length)for(h in f=x,e)e.hasOwnProperty(h)&&(a=e[h],a.steps>f.steps&&(f=a));else if(f=c(a.childNodes.item(b)||a),!f)for(d.setUnfilteredPosition(a,b);!f&&d.previousNode();)f=c(d.getCurrentNode());f=f||x;void 0!==u&&f.steps>u&&(f=q(u));f.setIteratorPosition(d);return f.steps};this.damageCacheAfterStep=function(a){0>
a&&(a=0);void 0===u?u=a:a<u&&(u=a);s()};(function(){var a=r(k)||f(k);x=new l(a,0,k);s=ops.StepsCache.ENABLE_CACHE_VERIFICATION?n:function(){}})()};ops.StepsCache.ENABLE_CACHE_VERIFICATION=!1;ops.StepsCache.Bookmark=function(){};ops.StepsCache.Bookmark.prototype.setIteratorPosition=function(k){}})();
// Input 42
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
(function(){ops.StepsTranslator=function(m,k,b,g){function p(){var a=m();a!==d&&(runtime.log("Undo detected. Resetting steps cache"),d=a,n=new ops.StepsCache(d,b,g),f=k(d))}function l(a,c){if(!c||b.acceptPosition(a)===q)return!0;for(;a.previousPosition();)if(b.acceptPosition(a)===q){if(c(0,a.container(),a.unfilteredDomOffset()))return!0;break}for(;a.nextPosition();)if(b.acceptPosition(a)===q){if(c(1,a.container(),a.unfilteredDomOffset()))return!0;break}return!1}var d=m(),n=new ops.StepsCache(d,b,
g),r=new core.DomUtils,f=k(m()),q=core.PositionFilter.FilterResult.FILTER_ACCEPT;this.convertStepsToDomPoint=function(a){var c,d;if(isNaN(a))throw new TypeError("Requested steps is not numeric ("+a+")");if(0>a)throw new RangeError("Requested steps is negative ("+a+")");p();for(c=n.setToClosestStep(a,f);c<a&&f.nextPosition();)(d=b.acceptPosition(f)===q)&&(c+=1),n.updateCache(c,f,d);if(c!==a)throw new RangeError("Requested steps ("+a+") exceeds available steps ("+c+")");return{node:f.container(),offset:f.unfilteredDomOffset()}};
this.convertDomPointToSteps=function(a,c,h){var e;p();r.containsNode(d,a)||(c=0>r.comparePoints(d,0,a,c),a=d,c=c?0:d.childNodes.length);f.setUnfilteredPosition(a,c);l(f,h)||f.setUnfilteredPosition(a,c);h=f.container();c=f.unfilteredDomOffset();a=n.setToClosestDomPoint(h,c,f);if(0>r.comparePoints(f.container(),f.unfilteredDomOffset(),h,c))return 0<a?a-1:a;for(;(f.container()!==h||f.unfilteredDomOffset()!==c)&&f.nextPosition();)(e=b.acceptPosition(f)===q)&&(a+=1),n.updateCache(a,f,e);return a+0};this.prime=
function(){var a,c;p();for(a=n.setToClosestStep(0,f);f.nextPosition();)(c=b.acceptPosition(f)===q)&&(a+=1),n.updateCache(a,f,c)};this.handleStepsInserted=function(a){p();n.damageCacheAfterStep(a.position)};this.handleStepsRemoved=function(a){p();n.damageCacheAfterStep(a.position-1)}};ops.StepsTranslator.PREVIOUS_STEP=0;ops.StepsTranslator.NEXT_STEP=1;return ops.StepsTranslator})();
// Input 43
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.TextPositionFilter=function(m){function k(g,k,f){var m,a;if(k){if(b.isInlineRoot(k)&&b.isGroupingElement(f))return d;m=b.lookLeftForCharacter(k);if(1===m||2===m&&(b.scanRightForAnyCharacter(f)||b.scanRightForAnyCharacter(b.nextNode(g))))return l}m=null===k&&b.isParagraph(g);a=b.lookRightForCharacter(f);if(m)return a?l:b.scanRightForAnyCharacter(f)?d:l;if(!a)return d;k=k||b.previousNode(g);return b.scanLeftForAnyCharacter(k)?d:l}var b=new odf.OdfUtils,g=Node.ELEMENT_NODE,p=Node.TEXT_NODE,l=core.PositionFilter.FilterResult.FILTER_ACCEPT,
d=core.PositionFilter.FilterResult.FILTER_REJECT;this.acceptPosition=function(n){var r=n.container(),f=r.nodeType,q,a,c;if(f!==g&&f!==p)return d;if(f===p){if(!b.isGroupingElement(r.parentNode)||b.isWithinTrackedChanges(r.parentNode,m()))return d;f=n.unfilteredDomOffset();q=r.data;runtime.assert(f!==q.length,"Unexpected offset.");if(0<f){n=q[f-1];if(!b.isODFWhitespace(n))return l;if(1<f)if(n=q[f-2],!b.isODFWhitespace(n))a=l;else{if(!b.isODFWhitespace(q.substr(0,f)))return d}else c=b.previousNode(r),
b.scanLeftForNonSpace(c)&&(a=l);if(a===l)return b.isTrailingWhitespace(r,f)?d:l;a=q[f];return b.isODFWhitespace(a)?d:b.scanLeftForAnyCharacter(b.previousNode(r))?d:l}c=n.leftNode();a=r;r=r.parentNode;a=k(r,c,a)}else!b.isGroupingElement(r)||b.isWithinTrackedChanges(r,m())?a=d:(c=n.leftNode(),a=n.rightNode(),a=k(r,c,a));return a}};
// Input 44
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.OdtDocument=function(m){function k(){var a=m.odfContainer().getContentElement(),b=a&&a.localName;runtime.assert("text"===b,"Unsupported content element type '"+b+"' for OdtDocument");return a}function b(){return a.getDocumentElement().ownerDocument}function g(a){for(;a&&!(a.namespaceURI===odf.Namespaces.officens&&"text"===a.localName||a.namespaceURI===odf.Namespaces.officens&&"annotation"===a.localName);)a=a.parentNode;return a}function p(a){this.acceptPosition=function(b){b=b.container();var c;
c="string"===typeof a?e[a].getNode():a;return g(b)===g(c)?A:x}}function l(a,b,c,d){d=gui.SelectionMover.createPositionIterator(d);var e;1===c.length?e=c[0]:(e=new core.PositionFilterChain,c.forEach(e.addFilter));c=new core.StepIterator(e,d);c.setPosition(a,b);return c}function d(a){var b=gui.SelectionMover.createPositionIterator(k());a=t.convertStepsToDomPoint(a);b.setUnfilteredPosition(a.node,a.offset);return b}function n(a){return c.getParagraphElement(a)}function r(a,b){return m.getFormatting().getStyleElement(a,
b)}function f(a){return r(a,"paragraph")}function q(a,b,c){a=a.childNodes.item(b)||a;return(a=n(a))&&h.containsNode(c,a)?a:c}var a=this,c,h,e={},v={},w=new core.EventNotifier([ops.Document.signalMemberAdded,ops.Document.signalMemberUpdated,ops.Document.signalMemberRemoved,ops.Document.signalCursorAdded,ops.Document.signalCursorRemoved,ops.Document.signalCursorMoved,ops.OdtDocument.signalParagraphChanged,ops.OdtDocument.signalParagraphStyleModified,ops.OdtDocument.signalCommonStyleCreated,ops.OdtDocument.signalCommonStyleDeleted,
ops.OdtDocument.signalTableAdded,ops.OdtDocument.signalOperationStart,ops.OdtDocument.signalOperationEnd,ops.OdtDocument.signalProcessingBatchStart,ops.OdtDocument.signalProcessingBatchEnd,ops.OdtDocument.signalUndoStackChanged,ops.OdtDocument.signalStepsInserted,ops.OdtDocument.signalStepsRemoved]),A=core.PositionFilter.FilterResult.FILTER_ACCEPT,x=core.PositionFilter.FilterResult.FILTER_REJECT,u,t,s;this.getDocumentElement=function(){return m.odfContainer().rootElement};this.getDOMDocument=function(){return this.getDocumentElement().ownerDocument};
this.cloneDocumentElement=function(){var b=a.getDocumentElement(),c=m.getAnnotationViewManager();c&&c.forgetAnnotations();b=b.cloneNode(!0);m.refreshAnnotations();return b};this.setDocumentElement=function(a){var b=m.odfContainer();b.setRootElement(a);m.setOdfContainer(b,!0);m.refreshCSS()};this.getDOMDocument=b;this.getRootElement=g;this.createStepIterator=l;this.getIteratorAtPosition=d;this.convertDomPointToCursorStep=function(a,b,c){return t.convertDomPointToSteps(a,b,c)};this.convertDomToCursorRange=
function(a,b){var c,d;c=b&&b(a.anchorNode,a.anchorOffset);c=t.convertDomPointToSteps(a.anchorNode,a.anchorOffset,c);b||a.anchorNode!==a.focusNode||a.anchorOffset!==a.focusOffset?(d=b&&b(a.focusNode,a.focusOffset),d=t.convertDomPointToSteps(a.focusNode,a.focusOffset,d)):d=c;return{position:c,length:d-c}};this.convertCursorToDomRange=function(a,c){var d=b().createRange(),e,f;e=t.convertStepsToDomPoint(a);c?(f=t.convertStepsToDomPoint(a+c),0<c?(d.setStart(e.node,e.offset),d.setEnd(f.node,f.offset)):
(d.setStart(f.node,f.offset),d.setEnd(e.node,e.offset))):d.setStart(e.node,e.offset);return d};this.getStyleElement=r;this.upgradeWhitespacesAtPosition=function(a){a=d(a);var b,e,f;a.previousPosition();a.previousPosition();for(f=-1;1>=f;f+=1){b=a.container();e=a.unfilteredDomOffset();if(b.nodeType===Node.TEXT_NODE&&" "===b.data[e]&&c.isSignificantWhitespace(b,e)){runtime.assert(" "===b.data[e],"upgradeWhitespaceToElement: textNode.data[offset] should be a literal space");var h=b.ownerDocument.createElementNS(odf.Namespaces.textns,
"text:s"),g=b.parentNode,l=b;h.appendChild(b.ownerDocument.createTextNode(" "));1===b.length?g.replaceChild(h,b):(b.deleteData(e,1),0<e&&(e<b.length&&b.splitText(e),l=b.nextSibling),g.insertBefore(h,l));b=h;a.moveToEndOfNode(b)}a.nextPosition()}};this.downgradeWhitespacesAtPosition=function(a){var b=d(a),e;a=b.container();for(b=b.unfilteredDomOffset();!c.isSpaceElement(a)&&a.childNodes.item(b);)a=a.childNodes.item(b),b=0;a.nodeType===Node.TEXT_NODE&&(a=a.parentNode);c.isDowngradableSpaceElement(a)&&
(b=a.firstChild,e=a.lastChild,h.mergeIntoParent(a),e!==b&&h.normalizeTextNodes(e),h.normalizeTextNodes(b))};this.getParagraphStyleElement=f;this.getParagraphElement=n;this.getParagraphStyleAttributes=function(a){return(a=f(a))?m.getFormatting().getInheritedStyleAttributes(a,!1):null};this.getTextNodeAtStep=function(c,f){var h=d(c),g=h.container(),l,k=0,n=null;g.nodeType===Node.TEXT_NODE?(l=g,k=h.unfilteredDomOffset(),0<l.length&&(0<k&&(l=l.splitText(k)),l.parentNode.insertBefore(b().createTextNode(""),
l),l=l.previousSibling,k=0)):(l=b().createTextNode(""),k=0,g.insertBefore(l,h.rightNode()));if(f){if(e[f]&&a.getCursorPosition(f)===c){for(n=e[f].getNode();n.nextSibling&&"cursor"===n.nextSibling.localName;)n.parentNode.insertBefore(n.nextSibling,n);0<l.length&&l.nextSibling!==n&&(l=b().createTextNode(""),k=0);n.parentNode.insertBefore(l,n)}}else for(;l.nextSibling&&"cursor"===l.nextSibling.localName;)l.parentNode.insertBefore(l.nextSibling,l);for(;l.previousSibling&&l.previousSibling.nodeType===
Node.TEXT_NODE;)h=l.previousSibling,h.appendData(l.data),k=h.length,l=h,l.parentNode.removeChild(l.nextSibling);for(;l.nextSibling&&l.nextSibling.nodeType===Node.TEXT_NODE;)h=l.nextSibling,l.appendData(h.data),l.parentNode.removeChild(h);return{textNode:l,offset:k}};this.fixCursorPositions=function(){Object.keys(e).forEach(function(b){var c=e[b],d=g(c.getNode()),f=a.createRootFilter(d),h,k,n,m=!1;n=c.getSelectedRange();h=q(n.startContainer,n.startOffset,d);k=l(n.startContainer,n.startOffset,[u,f],
h);n.collapsed?d=k:(h=q(n.endContainer,n.endOffset,d),d=l(n.endContainer,n.endOffset,[u,f],h));k.isStep()&&d.isStep()?k.container()!==d.container()||k.offset()!==d.offset()||n.collapsed&&c.getAnchorNode()===c.getNode()||(m=!0,n.setStart(k.container(),k.offset()),n.collapse(!0)):(m=!0,runtime.assert(k.roundToClosestStep(),"No walkable step found for cursor owned by "+b),n.setStart(k.container(),k.offset()),runtime.assert(d.roundToClosestStep(),"No walkable step found for cursor owned by "+b),n.setEnd(d.container(),
d.offset()));m&&(c.setSelectedRange(n,c.hasForwardSelection()),a.emit(ops.Document.signalCursorMoved,c))})};this.getCursorPosition=function(a){return(a=e[a])?t.convertDomPointToSteps(a.getNode(),0):0};this.getCursorSelection=function(a){a=e[a];var b=0,c=0;a&&(b=t.convertDomPointToSteps(a.getNode(),0),c=t.convertDomPointToSteps(a.getAnchorNode(),0));return{position:c,length:b-c}};this.getPositionFilter=function(){return u};this.getOdfCanvas=function(){return m};this.getCanvas=function(){return m};
this.getRootNode=k;this.addMember=function(a){runtime.assert(void 0===v[a.getMemberId()],"This member already exists");v[a.getMemberId()]=a};this.getMember=function(a){return v.hasOwnProperty(a)?v[a]:null};this.removeMember=function(a){delete v[a]};this.getCursor=function(a){return e[a]};this.getMemberIds=function(){var a=[],b;for(b in e)e.hasOwnProperty(b)&&a.push(e[b].getMemberId());return a};this.addCursor=function(b){runtime.assert(Boolean(b),"OdtDocument::addCursor without cursor");var c=b.getMemberId(),
d=a.convertCursorToDomRange(0,0);runtime.assert("string"===typeof c,"OdtDocument::addCursor has cursor without memberid");runtime.assert(!e[c],"OdtDocument::addCursor is adding a duplicate cursor with memberid "+c);b.setSelectedRange(d,!0);e[c]=b};this.removeCursor=function(b){var c=e[b];return c?(c.removeFromDocument(),delete e[b],a.emit(ops.Document.signalCursorRemoved,b),!0):!1};this.moveCursor=function(b,c,d,f){b=e[b];c=a.convertCursorToDomRange(c,d);b&&(b.setSelectedRange(c,0<=d),b.setSelectionType(f||
ops.OdtCursor.RangeSelection))};this.getFormatting=function(){return m.getFormatting()};this.emit=function(a,b){w.emit(a,b)};this.subscribe=function(a,b){w.subscribe(a,b)};this.unsubscribe=function(a,b){w.unsubscribe(a,b)};this.createRootFilter=function(a){return new p(a)};this.close=function(a){a()};this.destroy=function(a){a()};u=new ops.TextPositionFilter(k);c=new odf.OdfUtils;h=new core.DomUtils;t=new ops.StepsTranslator(k,gui.SelectionMover.createPositionIterator,u,500);w.subscribe(ops.OdtDocument.signalStepsInserted,
t.handleStepsInserted);w.subscribe(ops.OdtDocument.signalStepsRemoved,t.handleStepsRemoved);w.subscribe(ops.OdtDocument.signalOperationEnd,function(b){var c=b.spec(),d=c.memberid,c=(new Date(c.timestamp)).toISOString(),e=m.odfContainer();b.isEdit&&(d=a.getMember(d).getProperties().fullName,e.setMetadata({"dc:creator":d,"dc:date":c},null),s||(e.incrementEditingCycles(),e.setMetadata(null,["meta:editing-duration","meta:document-statistic"])),s=b)})};ops.OdtDocument.signalParagraphChanged="paragraph/changed";
ops.OdtDocument.signalTableAdded="table/added";ops.OdtDocument.signalCommonStyleCreated="style/created";ops.OdtDocument.signalCommonStyleDeleted="style/deleted";ops.OdtDocument.signalParagraphStyleModified="paragraphstyle/modified";ops.OdtDocument.signalOperationStart="operation/start";ops.OdtDocument.signalOperationEnd="operation/end";ops.OdtDocument.signalProcessingBatchStart="router/batchstart";ops.OdtDocument.signalProcessingBatchEnd="router/batchend";ops.OdtDocument.signalUndoStackChanged="undo/changed";
ops.OdtDocument.signalStepsInserted="steps/inserted";ops.OdtDocument.signalStepsRemoved="steps/removed";(function(){return ops.OdtDocument})();
// Input 45
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.OpAddAnnotation=function(){function m(b,d,f){var g=b.getTextNodeAtStep(f,k);g&&(b=g.textNode,f=b.parentNode,g.offset!==b.length&&b.splitText(g.offset),f.insertBefore(d,b.nextSibling),0===b.length&&f.removeChild(b))}var k,b,g,p,l,d;this.init=function(d){k=d.memberid;b=parseInt(d.timestamp,10);g=parseInt(d.position,10);p=parseInt(d.length,10)||0;l=d.name};this.isEdit=!0;this.group=void 0;this.execute=function(n){var r=n.getCursor(k),f,q;q=new core.DomUtils;d=n.getDOMDocument();var a=new Date(b),
c,h,e,v;c=d.createElementNS(odf.Namespaces.officens,"office:annotation");c.setAttributeNS(odf.Namespaces.officens,"office:name",l);f=d.createElementNS(odf.Namespaces.dcns,"dc:creator");f.setAttributeNS("urn:webodf:names:editinfo","editinfo:memberid",k);f.textContent=n.getMember(k).getProperties().fullName;h=d.createElementNS(odf.Namespaces.dcns,"dc:date");h.appendChild(d.createTextNode(a.toISOString()));a=d.createElementNS(odf.Namespaces.textns,"text:list");e=d.createElementNS(odf.Namespaces.textns,
"text:list-item");v=d.createElementNS(odf.Namespaces.textns,"text:p");e.appendChild(v);a.appendChild(e);c.appendChild(f);c.appendChild(h);c.appendChild(a);p&&(f=d.createElementNS(odf.Namespaces.officens,"office:annotation-end"),f.setAttributeNS(odf.Namespaces.officens,"office:name",l),c.annotationEndElement=f,m(n,f,g+p));m(n,c,g);n.emit(ops.OdtDocument.signalStepsInserted,{position:g,length:p});r&&(f=d.createRange(),q=q.getElementsByTagNameNS(c,odf.Namespaces.textns,"p")[0],f.selectNodeContents(q),
r.setSelectedRange(f,!1),n.emit(ops.Document.signalCursorMoved,r));n.getOdfCanvas().addAnnotation(c);n.fixCursorPositions();return!0};this.spec=function(){return{optype:"AddAnnotation",memberid:k,timestamp:b,position:g,length:p,name:l}}};
// Input 46
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.OpAddCursor=function(){var m,k;this.init=function(b){m=b.memberid;k=b.timestamp};this.isEdit=!1;this.group=void 0;this.execute=function(b){var g=b.getCursor(m);if(g)return!1;g=new ops.OdtCursor(m,b);b.addCursor(g);b.emit(ops.Document.signalCursorAdded,g);return!0};this.spec=function(){return{optype:"AddCursor",memberid:m,timestamp:k}}};
// Input 47
/*

 Copyright (C) 2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 This file is part of WebODF.

 WebODF is free software: you can redistribute it and/or modify it
 under the terms of the GNU Affero General Public License (GNU AGPL)
 as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.

 WebODF is distributed in the hope that it will be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Affero General Public License for more details.

 You should have received a copy of the GNU Affero General Public License
 along with WebODF.  If not, see <http://www.gnu.org/licenses/>.
 @licend

 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.OpAddMember=function(){var m,k,b;this.init=function(g){m=g.memberid;k=parseInt(g.timestamp,10);b=g.setProperties};this.isEdit=!1;this.group=void 0;this.execute=function(g){var k;if(g.getMember(m))return!1;k=new ops.Member(m,b);g.addMember(k);g.emit(ops.Document.signalMemberAdded,k);return!0};this.spec=function(){return{optype:"AddMember",memberid:m,timestamp:k,setProperties:b}}};
// Input 48
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.OpAddStyle=function(){var m,k,b,g,p,l,d=odf.Namespaces.stylens;this.init=function(d){m=d.memberid;k=d.timestamp;b=d.styleName;g=d.styleFamily;p="true"===d.isAutomaticStyle||!0===d.isAutomaticStyle;l=d.setProperties};this.isEdit=!0;this.group=void 0;this.execute=function(k){var m=k.getOdfCanvas().odfContainer(),f=k.getFormatting(),q=k.getDOMDocument().createElementNS(d,"style:style");if(!q)return!1;l&&f.updateStyle(q,l);q.setAttributeNS(d,"style:family",g);q.setAttributeNS(d,"style:name",b);p?
m.rootElement.automaticStyles.appendChild(q):m.rootElement.styles.appendChild(q);k.getOdfCanvas().refreshCSS();p||k.emit(ops.OdtDocument.signalCommonStyleCreated,{name:b,family:g});return!0};this.spec=function(){return{optype:"AddStyle",memberid:m,timestamp:k,styleName:b,styleFamily:g,isAutomaticStyle:p,setProperties:l}}};
// Input 49
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
odf.ObjectNameGenerator=function(m,k){function b(a,b){var c={};this.generateName=function(){var d=b(),f=0,h;do h=a+f,f+=1;while(c[h]||d[h]);c[h]=!0;return h}}function g(){var a={};[m.rootElement.automaticStyles,m.rootElement.styles].forEach(function(b){for(b=b.firstElementChild;b;)b.namespaceURI===p&&"style"===b.localName&&(a[b.getAttributeNS(p,"name")]=!0),b=b.nextElementSibling});return a}var p=odf.Namespaces.stylens,l=odf.Namespaces.drawns,d=odf.Namespaces.xlinkns,n=new core.DomUtils,r=(new core.Utils).hashString(k),
f=null,q=null,a=null,c={},h={};this.generateStyleName=function(){null===f&&(f=new b("auto"+r+"_",function(){return g()}));return f.generateName()};this.generateFrameName=function(){null===q&&(n.getElementsByTagNameNS(m.rootElement.body,l,"frame").forEach(function(a){c[a.getAttributeNS(l,"name")]=!0}),q=new b("fr"+r+"_",function(){return c}));return q.generateName()};this.generateImageName=function(){null===a&&(n.getElementsByTagNameNS(m.rootElement.body,l,"image").forEach(function(a){a=a.getAttributeNS(d,
"href");a=a.substring(9,a.lastIndexOf("."));h[a]=!0}),a=new b("img"+r+"_",function(){return h}));return a.generateName()}};
// Input 50
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
odf.TextStyleApplicator=function(m,k,b){function g(b){function d(a,b){return"object"===typeof a&&"object"===typeof b?Object.keys(a).every(function(e){return d(a[e],b[e])}):a===b}var a={};this.isStyleApplied=function(c){c=k.getAppliedStylesForElement(c,a);return d(b,c)}}function p(d){var g={};this.applyStyleToContainer=function(a){var c;c=a.getAttributeNS(n,"style-name");var h=a.ownerDocument;c=c||"";if(!g.hasOwnProperty(c)){var e=c,l;l=c?k.createDerivedStyleObject(c,"text",d):d;h=h.createElementNS(r,
"style:style");k.updateStyle(h,l);h.setAttributeNS(r,"style:name",m.generateStyleName());h.setAttributeNS(r,"style:family","text");h.setAttributeNS("urn:webodf:names:scope","scope","document-content");b.appendChild(h);g[e]=h}c=g[c].getAttributeNS(r,"name");a.setAttributeNS(n,"text:style-name",c)}}function l(b,g){var a=b.ownerDocument,c=b.parentNode,h,e,l=new core.LoopWatchDog(1E4);e=[];"span"!==c.localName||c.namespaceURI!==n?(h=a.createElementNS(n,"text:span"),c.insertBefore(h,b),c=!1):(b.previousSibling&&
!d.rangeContainsNode(g,c.firstChild)?(h=c.cloneNode(!1),c.parentNode.insertBefore(h,c.nextSibling)):h=c,c=!0);e.push(b);for(a=b.nextSibling;a&&d.rangeContainsNode(g,a);)l.check(),e.push(a),a=a.nextSibling;e.forEach(function(a){a.parentNode!==h&&h.appendChild(a)});if(a&&c)for(e=h.cloneNode(!1),h.parentNode.insertBefore(e,h.nextSibling);a;)l.check(),c=a.nextSibling,e.appendChild(a),a=c;return h}var d=new core.DomUtils,n=odf.Namespaces.textns,r=odf.Namespaces.stylens;this.applyStyle=function(b,d,a){var c=
{},h,e,k,n;runtime.assert(a&&a.hasOwnProperty("style:text-properties"),"applyStyle without any text properties");c["style:text-properties"]=a["style:text-properties"];k=new p(c);n=new g(c);b.forEach(function(a){h=n.isStyleApplied(a);!1===h&&(e=l(a,d),k.applyStyleToContainer(e))})}};
// Input 51
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.OpApplyDirectStyling=function(){function m(b,f,g){var a=b.getOdfCanvas().odfContainer(),c=n.splitBoundaries(f),h=d.getTextNodes(f,!1);f={startContainer:f.startContainer,startOffset:f.startOffset,endContainer:f.endContainer,endOffset:f.endOffset};(new odf.TextStyleApplicator(new odf.ObjectNameGenerator(a,k),b.getFormatting(),a.rootElement.automaticStyles)).applyStyle(h,f,g);c.forEach(n.normalizeTextNodes)}var k,b,g,p,l,d=new odf.OdfUtils,n=new core.DomUtils;this.init=function(d){k=d.memberid;b=
d.timestamp;g=parseInt(d.position,10);p=parseInt(d.length,10);l=d.setProperties};this.isEdit=!0;this.group=void 0;this.execute=function(n){var f=n.convertCursorToDomRange(g,p),q=d.getParagraphElements(f);m(n,f,l);f.detach();n.getOdfCanvas().refreshCSS();n.fixCursorPositions();q.forEach(function(a){n.emit(ops.OdtDocument.signalParagraphChanged,{paragraphElement:a,memberId:k,timeStamp:b})});n.getOdfCanvas().rerenderAnnotations();return!0};this.spec=function(){return{optype:"ApplyDirectStyling",memberid:k,
timestamp:b,position:g,length:p,setProperties:l}}};
// Input 52
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.OpApplyHyperlink=function(){function m(b){for(;b;){if(n.isHyperlink(b))return!0;b=b.parentNode}return!1}var k,b,g,p,l,d=new core.DomUtils,n=new odf.OdfUtils;this.init=function(d){k=d.memberid;b=d.timestamp;g=d.position;p=d.length;l=d.hyperlink};this.isEdit=!0;this.group=void 0;this.execute=function(r){var f=r.getDOMDocument(),q=r.convertCursorToDomRange(g,p),a=d.splitBoundaries(q),c=[],h=n.getTextNodes(q,!1);if(0===h.length)return!1;h.forEach(function(a){var b=n.getParagraphElement(a);runtime.assert(!1===
m(a),"The given range should not contain any link.");var d=l,h=f.createElementNS(odf.Namespaces.textns,"text:a");h.setAttributeNS(odf.Namespaces.xlinkns,"xlink:type","simple");h.setAttributeNS(odf.Namespaces.xlinkns,"xlink:href",d);a.parentNode.insertBefore(h,a);h.appendChild(a);-1===c.indexOf(b)&&c.push(b)});a.forEach(d.normalizeTextNodes);q.detach();r.getOdfCanvas().refreshSize();r.getOdfCanvas().rerenderAnnotations();c.forEach(function(a){r.emit(ops.OdtDocument.signalParagraphChanged,{paragraphElement:a,
memberId:k,timeStamp:b})});return!0};this.spec=function(){return{optype:"ApplyHyperlink",memberid:k,timestamp:b,position:g,length:p,hyperlink:l}}};
// Input 53
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.OpInsertImage=function(){var m,k,b,g,p,l,d,n,r=odf.Namespaces.drawns,f=odf.Namespaces.svgns,q=odf.Namespaces.textns,a=odf.Namespaces.xlinkns;this.init=function(a){m=a.memberid;k=a.timestamp;b=a.position;g=a.filename;p=a.frameWidth;l=a.frameHeight;d=a.frameStyleName;n=a.frameName};this.isEdit=!0;this.group=void 0;this.execute=function(c){var h=c.getOdfCanvas(),e=c.getTextNodeAtStep(b,m),v,w;if(!e)return!1;v=e.textNode;w=c.getParagraphElement(v);var e=e.offset!==v.length?v.splitText(e.offset):v.nextSibling,
A=c.getDOMDocument(),x=A.createElementNS(r,"draw:image"),A=A.createElementNS(r,"draw:frame");x.setAttributeNS(a,"xlink:href",g);x.setAttributeNS(a,"xlink:type","simple");x.setAttributeNS(a,"xlink:show","embed");x.setAttributeNS(a,"xlink:actuate","onLoad");A.setAttributeNS(r,"draw:style-name",d);A.setAttributeNS(r,"draw:name",n);A.setAttributeNS(q,"text:anchor-type","as-char");A.setAttributeNS(f,"svg:width",p);A.setAttributeNS(f,"svg:height",l);A.appendChild(x);v.parentNode.insertBefore(A,e);c.emit(ops.OdtDocument.signalStepsInserted,
{position:b,length:1});0===v.length&&v.parentNode.removeChild(v);h.addCssForFrameWithImage(A);h.refreshCSS();c.emit(ops.OdtDocument.signalParagraphChanged,{paragraphElement:w,memberId:m,timeStamp:k});h.rerenderAnnotations();return!0};this.spec=function(){return{optype:"InsertImage",memberid:m,timestamp:k,filename:g,position:b,frameWidth:p,frameHeight:l,frameStyleName:d,frameName:n}}};
// Input 54
/*

 Copyright (C) 2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.OpInsertTable=function(){function m(b,a){var c;if(1===f.length)c=f[0];else if(3===f.length)switch(b){case 0:c=f[0];break;case g-1:c=f[2];break;default:c=f[1]}else c=f[b];if(1===c.length)return c[0];if(3===c.length)switch(a){case 0:return c[0];case p-1:return c[2];default:return c[1]}return c[a]}var k,b,g,p,l,d,n,r,f;this.init=function(m){k=m.memberid;b=m.timestamp;l=m.position;g=m.initialRows;p=m.initialColumns;d=m.tableName;n=m.tableStyleName;r=m.tableColumnStyleName;f=m.tableCellStyleMatrix};
this.isEdit=!0;this.group=void 0;this.execute=function(f){var a=f.getTextNodeAtStep(l),c=f.getRootNode();if(a){var h=f.getDOMDocument(),e=h.createElementNS("urn:oasis:names:tc:opendocument:xmlns:table:1.0","table:table"),v=h.createElementNS("urn:oasis:names:tc:opendocument:xmlns:table:1.0","table:table-column"),w,A,x,u;n&&e.setAttributeNS("urn:oasis:names:tc:opendocument:xmlns:table:1.0","table:style-name",n);d&&e.setAttributeNS("urn:oasis:names:tc:opendocument:xmlns:table:1.0","table:name",d);v.setAttributeNS("urn:oasis:names:tc:opendocument:xmlns:table:1.0",
"table:number-columns-repeated",p);r&&v.setAttributeNS("urn:oasis:names:tc:opendocument:xmlns:table:1.0","table:style-name",r);e.appendChild(v);for(x=0;x<g;x+=1){v=h.createElementNS("urn:oasis:names:tc:opendocument:xmlns:table:1.0","table:table-row");for(u=0;u<p;u+=1)w=h.createElementNS("urn:oasis:names:tc:opendocument:xmlns:table:1.0","table:table-cell"),(A=m(x,u))&&w.setAttributeNS("urn:oasis:names:tc:opendocument:xmlns:table:1.0","table:style-name",A),A=h.createElementNS("urn:oasis:names:tc:opendocument:xmlns:text:1.0",
"text:p"),w.appendChild(A),v.appendChild(w);e.appendChild(v)}a=f.getParagraphElement(a.textNode);c.insertBefore(e,a.nextSibling);f.emit(ops.OdtDocument.signalStepsInserted,{position:l,length:p*g+1});f.getOdfCanvas().refreshSize();f.emit(ops.OdtDocument.signalTableAdded,{tableElement:e,memberId:k,timeStamp:b});f.getOdfCanvas().rerenderAnnotations();return!0}return!1};this.spec=function(){return{optype:"InsertTable",memberid:k,timestamp:b,position:l,initialRows:g,initialColumns:p,tableName:d,tableStyleName:n,
tableColumnStyleName:r,tableCellStyleMatrix:f}}};
// Input 55
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.OpInsertText=function(){var m,k,b,g,p;this.init=function(l){m=l.memberid;k=l.timestamp;b=l.position;p=l.text;g="true"===l.moveCursor||!0===l.moveCursor};this.isEdit=!0;this.group=void 0;this.execute=function(l){var d,n,r,f=null,q=l.getDOMDocument(),a,c=0,h,e=l.getCursor(m),v;l.upgradeWhitespacesAtPosition(b);if(d=l.getTextNodeAtStep(b)){n=d.textNode;f=n.nextSibling;r=n.parentNode;a=l.getParagraphElement(n);for(v=0;v<p.length;v+=1)if(" "===p[v]&&(0===v||v===p.length-1||" "===p[v-1])||"\t"===p[v])0===
c?(d.offset!==n.length&&(f=n.splitText(d.offset)),0<v&&n.appendData(p.substring(0,v))):c<v&&(c=p.substring(c,v),r.insertBefore(q.createTextNode(c),f)),c=v+1,h=" "===p[v]?"text:s":"text:tab",h=q.createElementNS("urn:oasis:names:tc:opendocument:xmlns:text:1.0",h),h.appendChild(q.createTextNode(p[v])),r.insertBefore(h,f);0===c?n.insertData(d.offset,p):c<p.length&&(d=p.substring(c),r.insertBefore(q.createTextNode(d),f));r=n.parentNode;f=n.nextSibling;r.removeChild(n);r.insertBefore(n,f);0===n.length&&
n.parentNode.removeChild(n);l.emit(ops.OdtDocument.signalStepsInserted,{position:b,length:p.length});e&&g&&(l.moveCursor(m,b+p.length,0),l.emit(ops.Document.signalCursorMoved,e));0<b&&(1<b&&l.downgradeWhitespacesAtPosition(b-2),l.downgradeWhitespacesAtPosition(b-1));l.downgradeWhitespacesAtPosition(b);l.downgradeWhitespacesAtPosition(b+p.length-1);l.downgradeWhitespacesAtPosition(b+p.length);l.getOdfCanvas().refreshSize();l.emit(ops.OdtDocument.signalParagraphChanged,{paragraphElement:a,memberId:m,
timeStamp:k});l.getOdfCanvas().rerenderAnnotations();return!0}return!1};this.spec=function(){return{optype:"InsertText",memberid:m,timestamp:k,position:b,text:p,moveCursor:g}}};
// Input 56
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.OpMoveCursor=function(){var m,k,b,g,p;this.init=function(l){m=l.memberid;k=l.timestamp;b=l.position;g=l.length||0;p=l.selectionType||ops.OdtCursor.RangeSelection};this.isEdit=!1;this.group=void 0;this.execute=function(l){var d=l.getCursor(m),k;if(!d)return!1;k=l.convertCursorToDomRange(b,g);d.setSelectedRange(k,0<=g);d.setSelectionType(p);l.emit(ops.Document.signalCursorMoved,d);return!0};this.spec=function(){return{optype:"MoveCursor",memberid:m,timestamp:k,position:b,length:g,selectionType:p}}};
// Input 57
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.OpRemoveAnnotation=function(){var m,k,b,g,p;this.init=function(l){m=l.memberid;k=l.timestamp;b=parseInt(l.position,10);g=parseInt(l.length,10);p=new core.DomUtils};this.isEdit=!0;this.group=void 0;this.execute=function(l){function d(b){m.parentNode.insertBefore(b,m)}for(var k=l.getIteratorAtPosition(b).container(),m;k.namespaceURI!==odf.Namespaces.officens||"annotation"!==k.localName;)k=k.parentNode;if(null===k)return!1;m=k;k=m.annotationEndElement;l.getOdfCanvas().forgetAnnotations();p.getElementsByTagNameNS(m,
"urn:webodf:names:cursor","cursor").forEach(d);p.getElementsByTagNameNS(m,"urn:webodf:names:cursor","anchor").forEach(d);m.parentNode.removeChild(m);k&&k.parentNode.removeChild(k);l.emit(ops.OdtDocument.signalStepsRemoved,{position:0<b?b-1:b,length:g});l.fixCursorPositions();l.getOdfCanvas().refreshAnnotations();return!0};this.spec=function(){return{optype:"RemoveAnnotation",memberid:m,timestamp:k,position:b,length:g}}};
// Input 58
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.OpRemoveBlob=function(){var m,k,b;this.init=function(g){m=g.memberid;k=g.timestamp;b=g.filename};this.isEdit=!0;this.group=void 0;this.execute=function(g){g.getOdfCanvas().odfContainer().removeBlob(b);return!0};this.spec=function(){return{optype:"RemoveBlob",memberid:m,timestamp:k,filename:b}}};
// Input 59
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.OpRemoveCursor=function(){var m,k;this.init=function(b){m=b.memberid;k=b.timestamp};this.isEdit=!1;this.group=void 0;this.execute=function(b){return b.removeCursor(m)?!0:!1};this.spec=function(){return{optype:"RemoveCursor",memberid:m,timestamp:k}}};
// Input 60
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.OpRemoveHyperlink=function(){var m,k,b,g,p=new core.DomUtils,l=new odf.OdfUtils;this.init=function(d){m=d.memberid;k=d.timestamp;b=d.position;g=d.length};this.isEdit=!0;this.group=void 0;this.execute=function(d){var n=d.convertCursorToDomRange(b,g),r=l.getHyperlinkElements(n);runtime.assert(1===r.length,"The given range should only contain a single link.");r=p.mergeIntoParent(r[0]);n.detach();d.getOdfCanvas().refreshSize();d.emit(ops.OdtDocument.signalParagraphChanged,{paragraphElement:l.getParagraphElement(r),
memberId:m,timeStamp:k});d.getOdfCanvas().rerenderAnnotations();return!0};this.spec=function(){return{optype:"RemoveHyperlink",memberid:m,timestamp:k,position:b,length:g}}};
// Input 61
/*

 Copyright (C) 2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 This file is part of WebODF.

 WebODF is free software: you can redistribute it and/or modify it
 under the terms of the GNU Affero General Public License (GNU AGPL)
 as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.

 WebODF is distributed in the hope that it will be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Affero General Public License for more details.

 You should have received a copy of the GNU Affero General Public License
 along with WebODF.  If not, see <http://www.gnu.org/licenses/>.
 @licend

 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.OpRemoveMember=function(){var m,k;this.init=function(b){m=b.memberid;k=parseInt(b.timestamp,10)};this.isEdit=!1;this.group=void 0;this.execute=function(b){if(!b.getMember(m))return!1;b.removeMember(m);b.emit(ops.Document.signalMemberRemoved,m);return!0};this.spec=function(){return{optype:"RemoveMember",memberid:m,timestamp:k}}};
// Input 62
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.OpRemoveStyle=function(){var m,k,b,g;this.init=function(p){m=p.memberid;k=p.timestamp;b=p.styleName;g=p.styleFamily};this.isEdit=!0;this.group=void 0;this.execute=function(k){var l=k.getStyleElement(b,g);if(!l)return!1;l.parentNode.removeChild(l);k.getOdfCanvas().refreshCSS();k.emit(ops.OdtDocument.signalCommonStyleDeleted,{name:b,family:g});return!0};this.spec=function(){return{optype:"RemoveStyle",memberid:m,timestamp:k,styleName:b,styleFamily:g}}};
// Input 63
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.OpRemoveText=function(){function m(b){function f(a){return n.hasOwnProperty(a.namespaceURI)||"br"===a.localName&&l.isLineBreak(a.parentNode)||a.nodeType===Node.TEXT_NODE&&n.hasOwnProperty(a.parentNode.namespaceURI)}function g(a){if(l.isCharacterElement(a))return!1;if(a.nodeType===Node.TEXT_NODE)return 0===a.textContent.length;for(a=a.firstChild;a;){if(n.hasOwnProperty(a.namespaceURI)||!g(a))return!1;a=a.nextSibling}return!0}function a(c){var h;c.nodeType===Node.TEXT_NODE?(h=c.parentNode,h.removeChild(c)):
h=d.removeUnwantedNodes(c,f);return h&&!l.isParagraph(h)&&h!==b&&g(h)?a(h):h}this.isEmpty=g;this.mergeChildrenIntoParent=a}var k,b,g,p,l,d,n={};this.init=function(m){runtime.assert(0<=m.length,"OpRemoveText only supports positive lengths");k=m.memberid;b=m.timestamp;g=parseInt(m.position,10);p=parseInt(m.length,10);l=new odf.OdfUtils;d=new core.DomUtils;n[odf.Namespaces.dbns]=!0;n[odf.Namespaces.dcns]=!0;n[odf.Namespaces.dr3dns]=!0;n[odf.Namespaces.drawns]=!0;n[odf.Namespaces.chartns]=!0;n[odf.Namespaces.formns]=
!0;n[odf.Namespaces.numberns]=!0;n[odf.Namespaces.officens]=!0;n[odf.Namespaces.presentationns]=!0;n[odf.Namespaces.stylens]=!0;n[odf.Namespaces.svgns]=!0;n[odf.Namespaces.tablens]=!0;n[odf.Namespaces.textns]=!0};this.isEdit=!0;this.group=void 0;this.execute=function(n){var f,q,a,c,h=n.getCursor(k),e=new m(n.getRootNode());n.upgradeWhitespacesAtPosition(g);n.upgradeWhitespacesAtPosition(g+p);q=n.convertCursorToDomRange(g,p);d.splitBoundaries(q);f=n.getParagraphElement(q.startContainer);a=l.getTextElements(q,
!1,!0);c=l.getParagraphElements(q);q.detach();a.forEach(function(a){a.parentNode?e.mergeChildrenIntoParent(a):runtime.log("WARN: text element has already been removed from it's container")});q=c.reduce(function(a,b){var c,d=a,f=b,h,g=null;e.isEmpty(a)&&(b.parentNode!==a.parentNode&&(h=b.parentNode,a.parentNode.insertBefore(b,a.nextSibling)),f=a,d=b,g=d.getElementsByTagNameNS("urn:webodf:names:editinfo","editinfo").item(0)||d.firstChild);for(;f.firstChild;)c=f.firstChild,f.removeChild(c),"editinfo"!==
c.localName&&d.insertBefore(c,g);h&&e.isEmpty(h)&&e.mergeChildrenIntoParent(h);e.mergeChildrenIntoParent(f);return d});n.emit(ops.OdtDocument.signalStepsRemoved,{position:g,length:p});n.downgradeWhitespacesAtPosition(g);n.fixCursorPositions();n.getOdfCanvas().refreshSize();n.emit(ops.OdtDocument.signalParagraphChanged,{paragraphElement:q||f,memberId:k,timeStamp:b});h&&(h.resetSelectionType(),n.emit(ops.Document.signalCursorMoved,h));n.getOdfCanvas().rerenderAnnotations();return!0};this.spec=function(){return{optype:"RemoveText",
memberid:k,timestamp:b,position:g,length:p}}};
// Input 64
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.OpSetBlob=function(){var m,k,b,g,p;this.init=function(l){m=l.memberid;k=l.timestamp;b=l.filename;g=l.mimetype;p=l.content};this.isEdit=!0;this.group=void 0;this.execute=function(l){l.getOdfCanvas().odfContainer().setBlob(b,g,p);return!0};this.spec=function(){return{optype:"SetBlob",memberid:m,timestamp:k,filename:b,mimetype:g,content:p}}};
// Input 65
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.OpSetParagraphStyle=function(){var m,k,b,g;this.init=function(p){m=p.memberid;k=p.timestamp;b=p.position;g=p.styleName};this.isEdit=!0;this.group=void 0;this.execute=function(p){var l;l=p.getIteratorAtPosition(b);return(l=p.getParagraphElement(l.container()))?(""!==g?l.setAttributeNS("urn:oasis:names:tc:opendocument:xmlns:text:1.0","text:style-name",g):l.removeAttributeNS("urn:oasis:names:tc:opendocument:xmlns:text:1.0","style-name"),p.getOdfCanvas().refreshSize(),p.emit(ops.OdtDocument.signalParagraphChanged,
{paragraphElement:l,timeStamp:k,memberId:m}),p.getOdfCanvas().rerenderAnnotations(),!0):!1};this.spec=function(){return{optype:"SetParagraphStyle",memberid:m,timestamp:k,position:b,styleName:g}}};
// Input 66
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.OpSplitParagraph=function(){var m,k,b,g,p;this.init=function(l){m=l.memberid;k=l.timestamp;b=l.position;g="true"===l.moveCursor||!0===l.moveCursor;p=new odf.OdfUtils};this.isEdit=!0;this.group=void 0;this.execute=function(l){var d,n,r,f,q,a,c,h=l.getCursor(m);l.upgradeWhitespacesAtPosition(b);d=l.getTextNodeAtStep(b);if(!d)return!1;n=l.getParagraphElement(d.textNode);if(!n)return!1;r=p.isListItem(n.parentNode)?n.parentNode:n;0===d.offset?(c=d.textNode.previousSibling,a=null):(c=d.textNode,a=d.offset>=
d.textNode.length?null:d.textNode.splitText(d.offset));for(f=d.textNode;f!==r;){f=f.parentNode;q=f.cloneNode(!1);a&&q.appendChild(a);if(c)for(;c&&c.nextSibling;)q.appendChild(c.nextSibling);else for(;f.firstChild;)q.appendChild(f.firstChild);f.parentNode.insertBefore(q,f.nextSibling);c=f;a=q}p.isListItem(a)&&(a=a.childNodes.item(0));0===d.textNode.length&&d.textNode.parentNode.removeChild(d.textNode);l.emit(ops.OdtDocument.signalStepsInserted,{position:b,length:1});h&&g&&(l.moveCursor(m,b+1,0),l.emit(ops.Document.signalCursorMoved,
h));l.fixCursorPositions();l.getOdfCanvas().refreshSize();l.emit(ops.OdtDocument.signalParagraphChanged,{paragraphElement:n,memberId:m,timeStamp:k});l.emit(ops.OdtDocument.signalParagraphChanged,{paragraphElement:a,memberId:m,timeStamp:k});l.getOdfCanvas().rerenderAnnotations();return!0};this.spec=function(){return{optype:"SplitParagraph",memberid:m,timestamp:k,position:b,moveCursor:g}}};
// Input 67
/*

 Copyright (C) 2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 This file is part of WebODF.

 WebODF is free software: you can redistribute it and/or modify it
 under the terms of the GNU Affero General Public License (GNU AGPL)
 as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.

 WebODF is distributed in the hope that it will be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Affero General Public License for more details.

 You should have received a copy of the GNU Affero General Public License
 along with WebODF.  If not, see <http://www.gnu.org/licenses/>.
 @licend

 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.OpUpdateMember=function(){function m(b){var d="//dc:creator[@editinfo:memberid='"+k+"']";b=xmldom.XPath.getODFElementsWithXPath(b.getRootNode(),d,function(b){return"editinfo"===b?"urn:webodf:names:editinfo":odf.Namespaces.lookupNamespaceURI(b)});for(d=0;d<b.length;d+=1)b[d].textContent=g.fullName}var k,b,g,p;this.init=function(l){k=l.memberid;b=parseInt(l.timestamp,10);g=l.setProperties;p=l.removedProperties};this.isEdit=!1;this.group=void 0;this.execute=function(b){var d=b.getMember(k);if(!d)return!1;
p&&d.removeProperties(p);g&&(d.setProperties(g),g.fullName&&m(b));b.emit(ops.Document.signalMemberUpdated,d);return!0};this.spec=function(){return{optype:"UpdateMember",memberid:k,timestamp:b,setProperties:g,removedProperties:p}}};
// Input 68
/*

 Copyright (C) 2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 This file is part of WebODF.

 WebODF is free software: you can redistribute it and/or modify it
 under the terms of the GNU Affero General Public License (GNU AGPL)
 as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.

 WebODF is distributed in the hope that it will be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Affero General Public License for more details.

 You should have received a copy of the GNU Affero General Public License
 along with WebODF.  If not, see <http://www.gnu.org/licenses/>.
 @licend

 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.OpUpdateMetadata=function(){var m,k,b,g;this.init=function(p){m=p.memberid;k=parseInt(p.timestamp,10);b=p.setProperties;g=p.removedProperties};this.isEdit=!0;this.group=void 0;this.execute=function(k){k=k.getOdfCanvas().odfContainer();var l=[];g&&(l=g.attributes.split(","));k.setMetadata(b,l);return!0};this.spec=function(){return{optype:"UpdateMetadata",memberid:m,timestamp:k,setProperties:b,removedProperties:g}}};
// Input 69
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.OpUpdateParagraphStyle=function(){function m(b,d){var f,g,a=d?d.split(","):[];for(f=0;f<a.length;f+=1)g=a[f].split(":"),b.removeAttributeNS(odf.Namespaces.lookupNamespaceURI(g[0]),g[1])}var k,b,g,p,l,d=odf.Namespaces.stylens;this.init=function(d){k=d.memberid;b=d.timestamp;g=d.styleName;p=d.setProperties;l=d.removedProperties};this.isEdit=!0;this.group=void 0;this.execute=function(b){var k=b.getFormatting(),f,q,a;return(f=""!==g?b.getParagraphStyleElement(g):k.getDefaultStyleElement("paragraph"))?
(q=f.getElementsByTagNameNS(d,"paragraph-properties").item(0),a=f.getElementsByTagNameNS(d,"text-properties").item(0),p&&k.updateStyle(f,p),l&&(k=l["style:paragraph-properties"],q&&k&&(m(q,k.attributes),0===q.attributes.length&&f.removeChild(q)),k=l["style:text-properties"],a&&k&&(m(a,k.attributes),0===a.attributes.length&&f.removeChild(a)),m(f,l.attributes)),b.getOdfCanvas().refreshCSS(),b.emit(ops.OdtDocument.signalParagraphStyleModified,g),b.getOdfCanvas().rerenderAnnotations(),!0):!1};this.spec=
function(){return{optype:"UpdateParagraphStyle",memberid:k,timestamp:b,styleName:g,setProperties:p,removedProperties:l}}};
// Input 70
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.OperationFactory=function(){var m;this.register=function(k,b){m[k]=b};this.create=function(k){var b=null,g=m[k.optype];g&&(b=new g,b.init(k));return b};m={AddMember:ops.OpAddMember,UpdateMember:ops.OpUpdateMember,RemoveMember:ops.OpRemoveMember,AddCursor:ops.OpAddCursor,ApplyDirectStyling:ops.OpApplyDirectStyling,SetBlob:ops.OpSetBlob,RemoveBlob:ops.OpRemoveBlob,InsertImage:ops.OpInsertImage,InsertTable:ops.OpInsertTable,InsertText:ops.OpInsertText,RemoveText:ops.OpRemoveText,SplitParagraph:ops.OpSplitParagraph,
SetParagraphStyle:ops.OpSetParagraphStyle,UpdateParagraphStyle:ops.OpUpdateParagraphStyle,AddStyle:ops.OpAddStyle,RemoveStyle:ops.OpRemoveStyle,MoveCursor:ops.OpMoveCursor,RemoveCursor:ops.OpRemoveCursor,AddAnnotation:ops.OpAddAnnotation,RemoveAnnotation:ops.OpRemoveAnnotation,UpdateMetadata:ops.OpUpdateMetadata,ApplyHyperlink:ops.OpApplyHyperlink,RemoveHyperlink:ops.OpRemoveHyperlink}};
// Input 71
/*

 Copyright (C) 2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.OperationRouter=function(){};ops.OperationRouter.prototype.setOperationFactory=function(m){};ops.OperationRouter.prototype.setPlaybackFunction=function(m){};ops.OperationRouter.prototype.push=function(m){};ops.OperationRouter.prototype.close=function(m){};ops.OperationRouter.prototype.subscribe=function(m,k){};ops.OperationRouter.prototype.unsubscribe=function(m,k){};ops.OperationRouter.prototype.hasLocalUnsyncedOps=function(){};ops.OperationRouter.prototype.hasSessionHostConnection=function(){};
ops.OperationRouter.signalProcessingBatchStart="router/batchstart";ops.OperationRouter.signalProcessingBatchEnd="router/batchend";
// Input 72
/*

 Copyright (C) 2012 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.TrivialOperationRouter=function(){var m=new core.EventNotifier([ops.OperationRouter.signalProcessingBatchStart,ops.OperationRouter.signalProcessingBatchEnd]),k,b,g=0;this.setOperationFactory=function(b){k=b};this.setPlaybackFunction=function(g){b=g};this.push=function(p){g+=1;m.emit(ops.OperationRouter.signalProcessingBatchStart,{});p.forEach(function(l){l=l.spec();l.timestamp=(new Date).getTime();l=k.create(l);l.group="g"+g;b(l)});m.emit(ops.OperationRouter.signalProcessingBatchEnd,{})};this.close=
function(b){b()};this.subscribe=function(b,g){m.subscribe(b,g)};this.unsubscribe=function(b,g){m.unsubscribe(b,g)};this.hasLocalUnsyncedOps=function(){return!1};this.hasSessionHostConnection=function(){return!0}};
// Input 73
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.Session=function(m){function k(b){p.emit(ops.OdtDocument.signalProcessingBatchStart,b)}function b(b){p.emit(ops.OdtDocument.signalProcessingBatchEnd,b)}var g=new ops.OperationFactory,p=new ops.OdtDocument(m),l=null;this.setOperationFactory=function(b){g=b;l&&l.setOperationFactory(g)};this.setOperationRouter=function(d){l&&(l.unsubscribe(ops.OperationRouter.signalProcessingBatchStart,k),l.unsubscribe(ops.OperationRouter.signalProcessingBatchEnd,b));l=d;l.subscribe(ops.OperationRouter.signalProcessingBatchStart,
k);l.subscribe(ops.OperationRouter.signalProcessingBatchEnd,b);d.setPlaybackFunction(function(b){p.emit(ops.OdtDocument.signalOperationStart,b);return b.execute(p)?(p.emit(ops.OdtDocument.signalOperationEnd,b),!0):!1});d.setOperationFactory(g)};this.getOperationFactory=function(){return g};this.getOdtDocument=function(){return p};this.enqueue=function(b){l.push(b)};this.close=function(b){l.close(function(g){g?b(g):p.close(b)})};this.destroy=function(b){p.destroy(b)};this.setOperationRouter(new ops.TrivialOperationRouter)};
// Input 74
/*

 Copyright (C) 2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 This file is part of WebODF.

 WebODF is free software: you can redistribute it and/or modify it
 under the terms of the GNU Affero General Public License (GNU AGPL)
 as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.

 WebODF is distributed in the hope that it will be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Affero General Public License for more details.

 You should have received a copy of the GNU Affero General Public License
 along with WebODF.  If not, see <http://www.gnu.org/licenses/>.
 @licend

 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
gui.AnnotationController=function(m,k){function b(){var b=d.getCursor(k),b=b&&b.getNode(),a=!1;if(b){a:{for(a=d.getRootNode();b&&b!==a;){if(b.namespaceURI===f&&"annotation"===b.localName){b=!0;break a}b=b.parentNode}b=!1}a=!b}a!==n&&(n=a,r.emit(gui.AnnotationController.annotatableChanged,n))}function g(d){d.getMemberId()===k&&b()}function p(d){d===k&&b()}function l(d){d.getMemberId()===k&&b()}var d=m.getOdtDocument(),n=!1,r=new core.EventNotifier([gui.AnnotationController.annotatableChanged]),f=odf.Namespaces.officens;
this.isAnnotatable=function(){return n};this.addAnnotation=function(){var b=new ops.OpAddAnnotation,a=d.getCursorSelection(k),c=a.length,a=a.position;n&&(a=0<=c?a:a+c,c=Math.abs(c),b.init({memberid:k,position:a,length:c,name:k+Date.now()}),m.enqueue([b]))};this.removeAnnotation=function(b){var a,c;a=d.convertDomPointToCursorStep(b,0)+1;c=d.convertDomPointToCursorStep(b,b.childNodes.length);b=new ops.OpRemoveAnnotation;b.init({memberid:k,position:a,length:c-a});c=new ops.OpMoveCursor;c.init({memberid:k,
position:0<a?a-1:a,length:0});m.enqueue([b,c])};this.subscribe=function(b,a){r.subscribe(b,a)};this.unsubscribe=function(b,a){r.unsubscribe(b,a)};this.destroy=function(b){d.unsubscribe(ops.Document.signalCursorAdded,g);d.unsubscribe(ops.Document.signalCursorRemoved,p);d.unsubscribe(ops.Document.signalCursorMoved,l);b()};d.subscribe(ops.Document.signalCursorAdded,g);d.subscribe(ops.Document.signalCursorRemoved,p);d.subscribe(ops.Document.signalCursorMoved,l);b()};
gui.AnnotationController.annotatableChanged="annotatable/changed";(function(){return gui.AnnotationController})();
// Input 75
gui.Avatar=function(m,k){var b=this,g,p,l;this.setColor=function(b){p.style.borderColor=b};this.setImageUrl=function(d){b.isVisible()?p.src=d:l=d};this.isVisible=function(){return"block"===g.style.display};this.show=function(){l&&(p.src=l,l=void 0);g.style.display="block"};this.hide=function(){g.style.display="none"};this.markAsFocussed=function(b){b?g.classList.add("active"):g.classList.remove("active")};this.destroy=function(b){m.removeChild(g);b()};(function(){var b=m.ownerDocument,l=b.documentElement.namespaceURI;
g=b.createElementNS(l,"div");p=b.createElementNS(l,"img");p.width=64;p.height=64;g.appendChild(p);g.style.width="64px";g.style.height="70px";g.style.position="absolute";g.style.top="-80px";g.style.left="-34px";g.style.display=k?"block":"none";g.className="handle";m.appendChild(g)})()};
// Input 76
gui.Caret=function(m,k,b){function g(){r.style.opacity="0"===r.style.opacity?"1":"0";e.trigger()}function p(a,b){var c=a.getBoundingClientRect(),d=0,e=0;c&&b&&(d=Math.max(c.top,b.top),e=Math.min(c.bottom,b.bottom));return e-d}function l(){Object.keys(x).forEach(function(a){u[a]=x[a]})}function d(){var d,h,g,k;if(!1===x.isShown||m.getSelectionType()!==ops.OdtCursor.RangeSelection||!b&&!m.getSelectedRange().collapsed)x.visibility="hidden",r.style.visibility="hidden",e.cancel();else{x.visibility="visible";
r.style.visibility="visible";if(!1===x.isFocused)r.style.opacity="1",e.cancel();else{if(v||u.visibility!==x.visibility)r.style.opacity="1",e.cancel();e.trigger()}if(A||w||u.visibility!==x.visibility){d=m.getSelectedRange().cloneRange();h=m.getNode();var n=null;h.previousSibling&&(g=h.previousSibling.nodeType===Node.TEXT_NODE?h.previousSibling.textContent.length:h.previousSibling.childNodes.length,d.setStart(h.previousSibling,0<g?g-1:0),d.setEnd(h.previousSibling,g),(g=d.getBoundingClientRect())&&
g.height&&(n=g));h.nextSibling&&(d.setStart(h.nextSibling,0),d.setEnd(h.nextSibling,0<(h.nextSibling.nodeType===Node.TEXT_NODE?h.nextSibling.textContent.length:h.nextSibling.childNodes.length)?1:0),(g=d.getBoundingClientRect())&&g.height&&(!n||p(h,g)>p(h,n))&&(n=g));h=n;n=m.getDocument().getCanvas();d=n.getZoomLevel();n=c.getBoundingClientRect(n.getSizer());h?(r.style.top="0",g=c.getBoundingClientRect(r),8>h.height&&(h={top:h.top-(8-h.height)/2,height:8}),r.style.height=c.adaptRangeDifferenceToZoomLevel(h.height,
d)+"px",r.style.top=c.adaptRangeDifferenceToZoomLevel(h.top-g.top,d)+"px"):(r.style.height="1em",r.style.top="5%");a&&(h=runtime.getWindow().getComputedStyle(r,null),g=c.getBoundingClientRect(r),a.style.bottom=c.adaptRangeDifferenceToZoomLevel(n.bottom-g.bottom,d)+"px",a.style.left=c.adaptRangeDifferenceToZoomLevel(g.right-n.left,d)+"px",h.font?a.style.font=h.font:(a.style.fontStyle=h.fontStyle,a.style.fontVariant=h.fontVariant,a.style.fontWeight=h.fontWeight,a.style.fontSize=h.fontSize,a.style.lineHeight=
h.lineHeight,a.style.fontFamily=h.fontFamily))}if(w){var n=m.getDocument().getCanvas().getElement().parentNode,q;g=n.offsetWidth-n.clientWidth+5;k=n.offsetHeight-n.clientHeight+5;q=r.getBoundingClientRect();d=q.left-g;h=q.top-k;g=q.right+g;k=q.bottom+k;q=n.getBoundingClientRect();h<q.top?n.scrollTop-=q.top-h:k>q.bottom&&(n.scrollTop+=k-q.bottom);d<q.left?n.scrollLeft-=q.left-d:g>q.right&&(n.scrollLeft+=g-q.right)}}u.isFocused!==x.isFocused&&f.markAsFocussed(x.isFocused);l();A=w=v=!1}function n(a){q.removeChild(r);
a()}var r,f,q,a,c=new core.DomUtils,h,e,v=!1,w=!1,A=!1,x={isFocused:!1,isShown:!0,visibility:"hidden"},u={isFocused:!x.isFocused,isShown:!x.isShown,visibility:"hidden"};this.handleUpdate=function(){A=!0;"hidden"!==x.visibility&&(x.visibility="hidden",r.style.visibility="hidden");h.trigger()};this.refreshCursorBlinking=function(){v=!0;h.trigger()};this.setFocus=function(){x.isFocused=!0;h.trigger()};this.removeFocus=function(){x.isFocused=!1;h.trigger()};this.show=function(){x.isShown=!0;h.trigger()};
this.hide=function(){x.isShown=!1;h.trigger()};this.setAvatarImageUrl=function(a){f.setImageUrl(a)};this.setColor=function(a){r.style.borderColor=a;f.setColor(a)};this.getCursor=function(){return m};this.getFocusElement=function(){return r};this.toggleHandleVisibility=function(){f.isVisible()?f.hide():f.show()};this.showHandle=function(){f.show()};this.hideHandle=function(){f.hide()};this.setOverlayElement=function(b){a=b;A=!0;h.trigger()};this.ensureVisible=function(){w=!0;h.trigger()};this.destroy=
function(a){core.Async.destroyAll([h.destroy,e.destroy,f.destroy,n],a)};(function(){var a=m.getDocument().getDOMDocument();r=a.createElementNS(a.documentElement.namespaceURI,"span");r.className="caret";r.style.top="5%";q=m.getNode();q.appendChild(r);f=new gui.Avatar(q,k);h=new core.ScheduledTask(d,0);e=new core.ScheduledTask(g,500);h.triggerImmediate()})()};
// Input 77
/*

 Copyright (C) 2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
odf.TextSerializer=function(){function m(g){var p="",l=k.filter?k.filter.acceptNode(g):NodeFilter.FILTER_ACCEPT,d=g.nodeType,n;if((l===NodeFilter.FILTER_ACCEPT||l===NodeFilter.FILTER_SKIP)&&b.isTextContentContainingNode(g))for(n=g.firstChild;n;)p+=m(n),n=n.nextSibling;l===NodeFilter.FILTER_ACCEPT&&(d===Node.ELEMENT_NODE&&b.isParagraph(g)?p+="\n":d===Node.TEXT_NODE&&g.textContent&&(p+=g.textContent));return p}var k=this,b=new odf.OdfUtils;this.filter=null;this.writeToString=function(b){if(!b)return"";
b=m(b);"\n"===b[b.length-1]&&(b=b.substr(0,b.length-1));return b}};
// Input 78
/*

 Copyright (C) 2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 This file is part of WebODF.

 WebODF is free software: you can redistribute it and/or modify it
 under the terms of the GNU Affero General Public License (GNU AGPL)
 as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.

 WebODF is distributed in the hope that it will be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Affero General Public License for more details.

 You should have received a copy of the GNU Affero General Public License
 along with WebODF.  If not, see <http://www.gnu.org/licenses/>.
 @licend

 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
gui.MimeDataExporter=function(){var m,k;this.exportRangeToDataTransfer=function(b,g){var k;k=g.startContainer.ownerDocument.createElement("span");k.appendChild(g.cloneContents());k=m.writeToString(k);try{b.setData("text/plain",k)}catch(l){b.setData("Text",k)}};m=new odf.TextSerializer;k=new odf.OdfNodeFilter;m.filter=k};
// Input 79
/*

 Copyright (C) 2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
gui.Clipboard=function(m){this.setDataFromRange=function(k,b){var g,p=k.clipboardData;g=runtime.getWindow();!p&&g&&(p=g.clipboardData);p?(g=!0,m.exportRangeToDataTransfer(p,b),k.preventDefault()):g=!1;return g}};
// Input 80
/*

 Copyright (C) 2012-2014 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
gui.StyleSummary=function(m){function k(b,d){var g=b+"|"+d,k;p.hasOwnProperty(g)||(k=[],m.forEach(function(f){f=(f=f[b])&&f[d];-1===k.indexOf(f)&&k.push(f)}),p[g]=k);return p[g]}function b(b,d,g){return function(){var m=k(b,d);return g.length>=m.length&&m.every(function(b){return-1!==g.indexOf(b)})}}function g(b,d){var g=k(b,d);return 1===g.length?g[0]:void 0}var p={};this.getPropertyValues=k;this.getCommonValue=g;this.isBold=b("style:text-properties","fo:font-weight",["bold"]);this.isItalic=b("style:text-properties",
"fo:font-style",["italic"]);this.hasUnderline=b("style:text-properties","style:text-underline-style",["solid"]);this.hasStrikeThrough=b("style:text-properties","style:text-line-through-style",["solid"]);this.fontSize=function(){var b=g("style:text-properties","fo:font-size");return b&&parseFloat(b)};this.fontName=function(){return g("style:text-properties","style:font-name")};this.isAlignedLeft=b("style:paragraph-properties","fo:text-align",["left","start"]);this.isAlignedCenter=b("style:paragraph-properties",
"fo:text-align",["center"]);this.isAlignedRight=b("style:paragraph-properties","fo:text-align",["right","end"]);this.isAlignedJustified=b("style:paragraph-properties","fo:text-align",["justify"]);this.text={isBold:this.isBold,isItalic:this.isItalic,hasUnderline:this.hasUnderline,hasStrikeThrough:this.hasStrikeThrough,fontSize:this.fontSize,fontName:this.fontName};this.paragraph={isAlignedLeft:this.isAlignedLeft,isAlignedCenter:this.isAlignedCenter,isAlignedRight:this.isAlignedRight,isAlignedJustified:this.isAlignedJustified}};
// Input 81
/*

 Copyright (C) 2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
gui.DirectFormattingController=function(m,k,b,g){function p(a){var b;a.collapsed?(b=a.startContainer,b.hasChildNodes()&&a.startOffset<b.childNodes.length&&(b=b.childNodes.item(a.startOffset)),a=[b]):a=T.getTextNodes(a,!0);return a}function l(a,b){var c={};Object.keys(a).forEach(function(d){var e=a[d](),f=b[d]();e!==f&&(c[d]=f)});return c}function d(){var a,b,c;a=(a=(a=F.getCursor(k))&&a.getSelectedRange())?p(a):[];a=F.getFormatting().getAppliedStyles(a);a[0]&&E&&(a[0]=W.mergeObjects(a[0],E));J=a;
c=new gui.StyleSummary(J);a=l(I.text,c.text);b=l(I.paragraph,c.paragraph);I=c;0<Object.keys(a).length&&Z.emit(gui.DirectFormattingController.textStylingChanged,a);0<Object.keys(b).length&&Z.emit(gui.DirectFormattingController.paragraphStylingChanged,b)}function n(a){("string"===typeof a?a:a.getMemberId())===k&&d()}function r(){d()}function f(a){var b=F.getCursor(k);a=a.paragraphElement;b&&F.getParagraphElement(b.getNode())===a&&d()}function q(a,b){b(!a());return!0}function a(a){var b=F.getCursorSelection(k),
c={"style:text-properties":a};0!==b.length?(a=new ops.OpApplyDirectStyling,a.init({memberid:k,position:b.position,length:b.length,setProperties:c}),m.enqueue([a])):(E=W.mergeObjects(E||{},c),d())}function c(b,c){var d={};d[b]=c;a(d)}function h(a){a=a.spec();E&&a.memberid===k&&"SplitParagraph"!==a.optype&&(E=null,d())}function e(a){c("fo:font-weight",a?"bold":"normal")}function v(a){c("fo:font-style",a?"italic":"normal")}function w(a){c("style:text-underline-style",a?"solid":"none")}function A(a){c("style:text-line-through-style",
a?"solid":"none")}function x(a){return a===ops.StepsTranslator.NEXT_STEP}function u(a){var c=F.getCursor(k).getSelectedRange(),c=T.getParagraphElements(c),d=F.getFormatting(),e=[],f={},h;c.forEach(function(c){var g=F.convertDomPointToCursorStep(c,0,x),l=c.getAttributeNS(odf.Namespaces.textns,"style-name"),n;c=l?f.hasOwnProperty(l)?f[l]:void 0:h;c||(c=b.generateStyleName(),l?(f[l]=c,n=d.createDerivedStyleObject(l,"paragraph",{})):(h=c,n={}),n=a(n),l=new ops.OpAddStyle,l.init({memberid:k,styleName:c.toString(),
styleFamily:"paragraph",isAutomaticStyle:!0,setProperties:n}),e.push(l));l=new ops.OpSetParagraphStyle;l.init({memberid:k,styleName:c.toString(),position:g});e.push(l)});m.enqueue(e)}function t(a){u(function(b){return W.mergeObjects(b,a)})}function s(a){t({"style:paragraph-properties":{"fo:text-align":a}})}function z(a,b){var c=F.getFormatting().getDefaultTabStopDistance(),d=b["style:paragraph-properties"],e;d&&(d=d["fo:margin-left"])&&(e=T.parseLength(d));return W.mergeObjects(b,{"style:paragraph-properties":{"fo:margin-left":e&&
e.unit===c.unit?e.value+a*c.value+e.unit:a*c.value+c.unit}})}function H(a,b){var c=p(a),d=F.getFormatting().getAppliedStyles(c)[0],e=F.getFormatting().getAppliedStylesForElement(b);if(!d||"text"!==d["style:family"]||!d["style:text-properties"])return!1;if(!e||!e["style:text-properties"])return!0;d=d["style:text-properties"];e=e["style:text-properties"];return!Object.keys(d).every(function(a){return d[a]===e[a]})}function M(){}var O=this,F=m.getOdtDocument(),W=new core.Utils,T=new odf.OdfUtils,Z=new core.EventNotifier([gui.DirectFormattingController.textStylingChanged,
gui.DirectFormattingController.paragraphStylingChanged]),D=odf.Namespaces.textns,ca=core.PositionFilter.FilterResult.FILTER_ACCEPT,E,J=[],I=new gui.StyleSummary(J);this.formatTextSelection=a;this.createCursorStyleOp=function(a,b,c){var e=null;(c=c?J[0]:E)&&c["style:text-properties"]&&(e=new ops.OpApplyDirectStyling,e.init({memberid:k,position:a,length:b,setProperties:{"style:text-properties":c["style:text-properties"]}}),E=null,d());return e};this.setBold=e;this.setItalic=v;this.setHasUnderline=w;
this.setHasStrikethrough=A;this.setFontSize=function(a){c("fo:font-size",a+"pt")};this.setFontName=function(a){c("style:font-name",a)};this.getAppliedStyles=function(){return J};this.toggleBold=q.bind(O,function(){return I.isBold()},e);this.toggleItalic=q.bind(O,function(){return I.isItalic()},v);this.toggleUnderline=q.bind(O,function(){return I.hasUnderline()},w);this.toggleStrikethrough=q.bind(O,function(){return I.hasStrikeThrough()},A);this.isBold=function(){return I.isBold()};this.isItalic=function(){return I.isItalic()};
this.hasUnderline=function(){return I.hasUnderline()};this.hasStrikeThrough=function(){return I.hasStrikeThrough()};this.fontSize=function(){return I.fontSize()};this.fontName=function(){return I.fontName()};this.isAlignedLeft=function(){return I.isAlignedLeft()};this.isAlignedCenter=function(){return I.isAlignedCenter()};this.isAlignedRight=function(){return I.isAlignedRight()};this.isAlignedJustified=function(){return I.isAlignedJustified()};this.alignParagraphLeft=function(){s("left");return!0};
this.alignParagraphCenter=function(){s("center");return!0};this.alignParagraphRight=function(){s("right");return!0};this.alignParagraphJustified=function(){s("justify");return!0};this.indent=function(){u(z.bind(null,1));return!0};this.outdent=function(){u(z.bind(null,-1));return!0};this.createParagraphStyleOps=function(a){var c=F.getCursor(k),d=c.getSelectedRange(),e=[],f,h;c.hasForwardSelection()?(f=c.getAnchorNode(),h=c.getNode()):(f=c.getNode(),h=c.getAnchorNode());c=F.getParagraphElement(h);runtime.assert(Boolean(c),
"DirectFormattingController: Cursor outside paragraph");var g;a:{g=c;var l=gui.SelectionMover.createPositionIterator(g),n=new core.PositionFilterChain;n.addFilter(F.getPositionFilter());n.addFilter(F.createRootFilter(k));for(l.setUnfilteredPosition(d.endContainer,d.endOffset);l.nextPosition();)if(n.acceptPosition(l)===ca){g=F.getParagraphElement(l.getCurrentNode())!==g;break a}g=!0}if(!g)return e;h!==f&&(c=F.getParagraphElement(f));if(!E&&!H(d,c))return e;d=J[0];if(!d)return e;if(f=c.getAttributeNS(D,
"style-name"))d={"style:text-properties":d["style:text-properties"]},d=F.getFormatting().createDerivedStyleObject(f,"paragraph",d);c=b.generateStyleName();f=new ops.OpAddStyle;f.init({memberid:k,styleName:c,styleFamily:"paragraph",isAutomaticStyle:!0,setProperties:d});e.push(f);f=new ops.OpSetParagraphStyle;f.init({memberid:k,styleName:c,position:a});e.push(f);return e};this.subscribe=function(a,b){Z.subscribe(a,b)};this.unsubscribe=function(a,b){Z.unsubscribe(a,b)};this.destroy=function(a){F.unsubscribe(ops.Document.signalCursorAdded,
n);F.unsubscribe(ops.Document.signalCursorRemoved,n);F.unsubscribe(ops.Document.signalCursorMoved,n);F.unsubscribe(ops.OdtDocument.signalParagraphStyleModified,r);F.unsubscribe(ops.OdtDocument.signalParagraphChanged,f);F.unsubscribe(ops.OdtDocument.signalOperationEnd,h);a()};(function(){F.subscribe(ops.Document.signalCursorAdded,n);F.subscribe(ops.Document.signalCursorRemoved,n);F.subscribe(ops.Document.signalCursorMoved,n);F.subscribe(ops.OdtDocument.signalParagraphStyleModified,r);F.subscribe(ops.OdtDocument.signalParagraphChanged,
f);F.subscribe(ops.OdtDocument.signalOperationEnd,h);d();g||(O.alignParagraphCenter=M,O.alignParagraphJustified=M,O.alignParagraphLeft=M,O.alignParagraphRight=M,O.createParagraphStyleOps=function(){return[]},O.indent=M,O.outdent=M)})()};gui.DirectFormattingController.textStylingChanged="textStyling/changed";gui.DirectFormattingController.paragraphStylingChanged="paragraphStyling/changed";(function(){return gui.DirectFormattingController})();
// Input 82
gui.HyperlinkClickHandler=function(m){function k(){var b=m();runtime.assert(Boolean(b.classList),"Document container has no classList element");b.classList.remove("webodf-inactiveLinks")}function b(){var b=m();runtime.assert(Boolean(b.classList),"Document container has no classList element");b.classList.add("webodf-inactiveLinks")}var g=gui.HyperlinkClickHandler.Modifier.None,p=gui.HyperlinkClickHandler.Modifier.Ctrl,l=gui.HyperlinkClickHandler.Modifier.Meta,d=new odf.OdfUtils,n=xmldom.XPath,r=g;
this.handleClick=function(b){var k=b.target||b.srcElement,a,c;b.ctrlKey?a=p:b.metaKey&&(a=l);if(r===g||r===a){a:{for(;null!==k;){if(d.isHyperlink(k))break a;if(d.isParagraph(k))break;k=k.parentNode}k=null}k&&(k=d.getHyperlinkTarget(k),""!==k&&("#"===k[0]?(k=k.substring(1),a=m(),c=n.getODFElementsWithXPath(a,"//text:bookmark-start[@text:name='"+k+"']",odf.Namespaces.lookupNamespaceURI),0===c.length&&(c=n.getODFElementsWithXPath(a,"//text:bookmark[@text:name='"+k+"']",odf.Namespaces.lookupNamespaceURI)),
0<c.length&&c[0].scrollIntoView(!0)):runtime.getWindow().open(k),b.preventDefault?b.preventDefault():b.returnValue=!1))}};this.showPointerCursor=k;this.showTextCursor=b;this.setModifier=function(d){r=d;r!==g?b():k()}};gui.HyperlinkClickHandler.Modifier={None:0,Ctrl:1,Meta:2};
// Input 83
gui.HyperlinkController=function(m,k){var b=new odf.OdfUtils,g=m.getOdtDocument();this.addHyperlink=function(b,l){var d=g.getCursorSelection(k),n=new ops.OpApplyHyperlink,r=[];if(0===d.length||l)l=l||b,n=new ops.OpInsertText,n.init({memberid:k,position:d.position,text:l}),d.length=l.length,r.push(n);n=new ops.OpApplyHyperlink;n.init({memberid:k,position:d.position,length:d.length,hyperlink:b});r.push(n);m.enqueue(r)};this.removeHyperlinks=function(){var p=gui.SelectionMover.createPositionIterator(g.getRootNode()),
l=g.getCursor(k).getSelectedRange(),d=b.getHyperlinkElements(l),n=l.collapsed&&1===d.length,r=g.getDOMDocument().createRange(),f=[],q,a;0!==d.length&&(d.forEach(function(b){r.selectNodeContents(b);q=g.convertDomToCursorRange({anchorNode:r.startContainer,anchorOffset:r.startOffset,focusNode:r.endContainer,focusOffset:r.endOffset});a=new ops.OpRemoveHyperlink;a.init({memberid:k,position:q.position,length:q.length});f.push(a)}),n||(n=d[0],-1===l.comparePoint(n,0)&&(r.setStart(n,0),r.setEnd(l.startContainer,
l.startOffset),q=g.convertDomToCursorRange({anchorNode:r.startContainer,anchorOffset:r.startOffset,focusNode:r.endContainer,focusOffset:r.endOffset}),0<q.length&&(a=new ops.OpApplyHyperlink,a.init({memberid:k,position:q.position,length:q.length,hyperlink:b.getHyperlinkTarget(n)}),f.push(a))),d=d[d.length-1],p.moveToEndOfNode(d),p=p.unfilteredDomOffset(),1===l.comparePoint(d,p)&&(r.setStart(l.endContainer,l.endOffset),r.setEnd(d,p),q=g.convertDomToCursorRange({anchorNode:r.startContainer,anchorOffset:r.startOffset,
focusNode:r.endContainer,focusOffset:r.endOffset}),0<q.length&&(a=new ops.OpApplyHyperlink,a.init({memberid:k,position:q.position,length:q.length,hyperlink:b.getHyperlinkTarget(d)}),f.push(a)))),m.enqueue(f),r.detach())}};
// Input 84
gui.EventManager=function(m){function k(){var a=this,b=[];this.filters=[];this.handlers=[];this.handleEvent=function(c){-1===b.indexOf(c)&&(b.push(c),a.filters.every(function(a){return a(c)})&&a.handlers.forEach(function(a){a(c)}),runtime.setTimeout(function(){b.splice(b.indexOf(c),1)},0))}}function b(a,b,c){function d(b){c(b,e,function(b){b.type=a;f.emit("eventTriggered",b)})}var e={},f=new core.EventNotifier(["eventTriggered"]);this.subscribe=function(a){f.subscribe("eventTriggered",a)};this.unsubscribe=
function(a){f.unsubscribe("eventTriggered",a)};this.destroy=function(){b.forEach(function(a){z.unsubscribe(a,d)})};(function(){b.forEach(function(a){z.subscribe(a,d)})})()}function g(a){runtime.clearTimeout(a);delete H[a]}function p(a,b){var c=runtime.setTimeout(function(){a();g(c)},b);H[c]=!0;return c}function l(a,b,c){var d=a.touches.length,e=a.touches[0],f=b.timer;"touchmove"===a.type||"touchend"===a.type?f&&g(f):"touchstart"===a.type&&(1!==d?runtime.clearTimeout(f):f=p(function(){c({clientX:e.clientX,
clientY:e.clientY,pageX:e.pageX,pageY:e.pageY,target:a.target||a.srcElement||null,detail:1})},400));b.timer=f}function d(a,b,c){var d=a.touches[0],e=a.target||a.srcElement||null,f=b.target;1!==a.touches.length||"touchend"===a.type?f=null:"touchstart"===a.type&&"webodf-draggable"===e.getAttribute("class")?f=e:"touchmove"===a.type&&f&&(a.preventDefault(),a.stopPropagation(),c({clientX:d.clientX,clientY:d.clientY,pageX:d.pageX,pageY:d.pageY,target:f,detail:1}));b.target=f}function n(a,b,c){var d=a.target||
a.srcElement||null,e=b.dragging;"drag"===a.type?e=!0:"touchend"===a.type&&e&&(e=!1,a=a.changedTouches[0],c({clientX:a.clientX,clientY:a.clientY,pageX:a.pageX,pageY:a.pageY,target:d,detail:1}));b.dragging=e}function r(){s.classList.add("webodf-touchEnabled");z.unsubscribe("touchstart",r)}function f(a){var b=a.scrollX,c=a.scrollY;this.restore=function(){a.scrollX===b&&a.scrollY===c||a.scrollTo(b,c)}}function q(a){var b=a.scrollTop,c=a.scrollLeft;this.restore=function(){if(a.scrollTop!==b||a.scrollLeft!==
c)a.scrollTop=b,a.scrollLeft=c}}function a(a,b,c){var d,e=!1;x.hasOwnProperty(b)?x[b].subscribe(c):(d="on"+b,a.attachEvent&&(a.attachEvent(d,c),e=!0),!e&&a.addEventListener&&(a.addEventListener(b,c,!1),e=!0),e&&!w[b]||!a.hasOwnProperty(d)||(a[d]=c))}function c(b,c){var d=u[b]||null;!d&&c&&(d=u[b]=new k,A[b]&&a(v,b,d.handleEvent),a(t,b,d.handleEvent),a(s,b,d.handleEvent));return d}function h(){return m.getDOMDocument().activeElement===t}function e(a){for(var b=[];a;)(a.scrollWidth>a.clientWidth||a.scrollHeight>
a.clientHeight)&&b.push(new q(a)),a=a.parentNode;b.push(new f(v));return b}var v=runtime.getWindow(),w={beforecut:!0,beforepaste:!0,longpress:!0,drag:!0,dragstop:!0},A={mousedown:!0,mouseup:!0,focus:!0},x={},u={},t,s=m.getCanvas().getElement(),z=this,H={};this.addFilter=function(a,b){c(a,!0).filters.push(b)};this.removeFilter=function(a,b){var d=c(a,!0),e=d.filters.indexOf(b);-1!==e&&d.filters.splice(e,1)};this.subscribe=function(a,b){c(a,!0).handlers.push(b)};this.unsubscribe=function(a,b){var d=
c(a,!1),e=d&&d.handlers.indexOf(b);d&&-1!==e&&d.handlers.splice(e,1)};this.hasFocus=h;this.focus=function(){var a;h()||(a=e(t),t.focus(),a.forEach(function(a){a.restore()}))};this.getEventTrap=function(){return t};this.blur=function(){h()&&t.blur()};this.destroy=function(a){Object.keys(H).forEach(function(a){g(parseInt(a,10))});H.length=0;Object.keys(x).forEach(function(a){x[a].destroy()});x={};z.unsubscribe("touchstart",r);t.parentNode.removeChild(t);a()};(function(){var a=m.getOdfCanvas().getSizer(),
c=a.ownerDocument;runtime.assert(Boolean(v),"EventManager requires a window object to operate correctly");t=c.createElement("input");t.id="eventTrap";t.setAttribute("tabindex",-1);a.appendChild(t);x.longpress=new b("longpress",["touchstart","touchmove","touchend"],l);x.drag=new b("drag",["touchstart","touchmove","touchend"],d);x.dragstop=new b("dragstop",["drag","touchend"],n);z.subscribe("touchstart",r)})()};
// Input 85
/*

 Copyright (C) 2014 KO GmbH <copyright@kogmbh.com>

 @licstart
 This file is part of WebODF.

 WebODF is free software: you can redistribute it and/or modify it
 under the terms of the GNU Affero General Public License (GNU AGPL)
 as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.

 WebODF is distributed in the hope that it will be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Affero General Public License for more details.

 You should have received a copy of the GNU Affero General Public License
 along with WebODF.  If not, see <http://www.gnu.org/licenses/>.
 @licend

 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
gui.IOSSafariSupport=function(m){function k(){b.innerHeight!==b.outerHeight&&(g.style.display="none",runtime.requestAnimationFrame(function(){g.style.display="block"}))}var b=runtime.getWindow(),g=m.getEventTrap();this.destroy=function(b){m.unsubscribe("focus",k);g.removeAttribute("autocapitalize");g.style.WebkitTransform="";b()};m.subscribe("focus",k);g.setAttribute("autocapitalize","off");g.style.WebkitTransform="translateX(-10000px)"};
// Input 86
gui.ImageController=function(m,k,b){var g={"image/gif":".gif","image/jpeg":".jpg","image/png":".png"},p=odf.Namespaces.textns,l=m.getOdtDocument(),d=l.getFormatting(),n={};this.insertImage=function(r,f,q,a){var c;runtime.assert(0<q&&0<a,"Both width and height of the image should be greater than 0px.");c=l.getParagraphElement(l.getCursor(k).getNode()).getAttributeNS(p,"style-name");n.hasOwnProperty(c)||(n[c]=d.getContentSize(c,"paragraph"));c=n[c];q*=0.0264583333333334;a*=0.0264583333333334;var h=
1,e=1;q>c.width&&(h=c.width/q);a>c.height&&(e=c.height/a);h=Math.min(h,e);c=q*h;q=a*h;e=l.getOdfCanvas().odfContainer().rootElement.styles;a=r.toLowerCase();var h=g.hasOwnProperty(a)?g[a]:null,v;a=[];runtime.assert(null!==h,"Image type is not supported: "+r);h="Pictures/"+b.generateImageName()+h;v=new ops.OpSetBlob;v.init({memberid:k,filename:h,mimetype:r,content:f});a.push(v);d.getStyleElement("Graphics","graphic",[e])||(r=new ops.OpAddStyle,r.init({memberid:k,styleName:"Graphics",styleFamily:"graphic",
isAutomaticStyle:!1,setProperties:{"style:graphic-properties":{"text:anchor-type":"paragraph","svg:x":"0cm","svg:y":"0cm","style:wrap":"dynamic","style:number-wrapped-paragraphs":"no-limit","style:wrap-contour":"false","style:vertical-pos":"top","style:vertical-rel":"paragraph","style:horizontal-pos":"center","style:horizontal-rel":"paragraph"}}}),a.push(r));r=b.generateStyleName();f=new ops.OpAddStyle;f.init({memberid:k,styleName:r,styleFamily:"graphic",isAutomaticStyle:!0,setProperties:{"style:parent-style-name":"Graphics",
"style:graphic-properties":{"style:vertical-pos":"top","style:vertical-rel":"baseline","style:horizontal-pos":"center","style:horizontal-rel":"paragraph","fo:background-color":"transparent","style:background-transparency":"100%","style:shadow":"none","style:mirror":"none","fo:clip":"rect(0cm, 0cm, 0cm, 0cm)","draw:luminance":"0%","draw:contrast":"0%","draw:red":"0%","draw:green":"0%","draw:blue":"0%","draw:gamma":"100%","draw:color-inversion":"false","draw:image-opacity":"100%","draw:color-mode":"standard"}}});
a.push(f);v=new ops.OpInsertImage;v.init({memberid:k,position:l.getCursorPosition(k),filename:h,frameWidth:c+"cm",frameHeight:q+"cm",frameStyleName:r,frameName:b.generateFrameName()});a.push(v);m.enqueue(a)}};
// Input 87
gui.ImageSelector=function(m){function k(){var b=m.getSizer(),k=p.createElement("div");k.id="imageSelector";k.style.borderWidth="1px";b.appendChild(k);g.forEach(function(b){var d=p.createElement("div");d.className=b;k.appendChild(d)});return k}var b=odf.Namespaces.svgns,g="topLeft topRight bottomRight bottomLeft topMiddle rightMiddle bottomMiddle leftMiddle".split(" "),p=m.getElement().ownerDocument,l=!1;this.select=function(d){var g,r,f=p.getElementById("imageSelector");f||(f=k());l=!0;g=f.parentNode;
r=d.getBoundingClientRect();var q=g.getBoundingClientRect(),a=m.getZoomLevel();g=(r.left-q.left)/a-1;r=(r.top-q.top)/a-1;f.style.display="block";f.style.left=g+"px";f.style.top=r+"px";f.style.width=d.getAttributeNS(b,"width");f.style.height=d.getAttributeNS(b,"height")};this.clearSelection=function(){var b;l&&(b=p.getElementById("imageSelector"))&&(b.style.display="none");l=!1};this.isSelectorElement=function(b){var g=p.getElementById("imageSelector");return g?b===g||b.parentNode===g:!1}};
// Input 88
(function(){function m(k){function b(b){d=b.which&&String.fromCharCode(b.which)===l;l=void 0;return!1===d}function g(){d=!1}function m(b){l=b.data;d=!1}var l,d=!1;this.destroy=function(d){k.unsubscribe("textInput",g);k.unsubscribe("compositionend",m);k.removeFilter("keypress",b);d()};k.subscribe("textInput",g);k.subscribe("compositionend",m);k.addFilter("keypress",b)}gui.InputMethodEditor=function(k,b){function g(a){h&&(a?h.getNode().setAttributeNS(c,"composing","true"):(h.getNode().removeAttributeNS(c,
"composing"),w.textContent=""))}function p(){u&&(u=!1,g(!1),s.emit(gui.InputMethodEditor.signalCompositionEnd,{data:t}),t="")}function l(){p();h&&h.getSelectedRange().collapsed?e.value="":e.value=A;e.setSelectionRange(0,e.value.length)}function d(){z=void 0;x.cancel();g(!0);u||s.emit(gui.InputMethodEditor.signalCompositionStart,{data:""})}function n(a){a=z=a.data;u=!0;t+=a;x.trigger()}function r(a){a.data!==z&&(a=a.data,u=!0,t+=a,x.trigger());z=void 0}function f(){w.textContent=e.value}function q(){b.blur();
e.setAttribute("disabled",!0)}function a(){var a=b.hasFocus();a&&b.blur();O?e.removeAttribute("disabled"):e.setAttribute("disabled",!0);a&&b.focus()}var c="urn:webodf:names:cursor",h=null,e=b.getEventTrap(),v=e.ownerDocument,w,A="b",x,u=!1,t="",s=new core.EventNotifier([gui.InputMethodEditor.signalCompositionStart,gui.InputMethodEditor.signalCompositionEnd]),z,H=[],M,O=!1;this.subscribe=s.subscribe;this.unsubscribe=s.unsubscribe;this.registerCursor=function(a){a.getMemberId()===k&&(h=a,h.getNode().appendChild(w),
b.subscribe("input",f),b.subscribe("compositionupdate",f))};this.removeCursor=function(a){h&&a===k&&(h.getNode().removeChild(w),b.unsubscribe("input",f),b.unsubscribe("compositionupdate",f),h=null)};this.setEditing=function(b){O=b;a()};this.destroy=function(c){b.unsubscribe("compositionstart",d);b.unsubscribe("compositionend",n);b.unsubscribe("textInput",r);b.unsubscribe("keypress",p);b.unsubscribe("mousedown",q);b.unsubscribe("mouseup",a);b.unsubscribe("focus",l);core.Async.destroyAll(M,c)};(function(){b.subscribe("compositionstart",
d);b.subscribe("compositionend",n);b.subscribe("textInput",r);b.subscribe("keypress",p);b.subscribe("mousedown",q);b.subscribe("mouseup",a);b.subscribe("focus",l);H.push(new m(b));M=H.map(function(a){return a.destroy});w=v.createElement("span");w.setAttribute("id","composer");x=new core.ScheduledTask(l,1);M.push(x.destroy)})()};gui.InputMethodEditor.signalCompositionStart="input/compositionstart";gui.InputMethodEditor.signalCompositionEnd="input/compositionend";return gui.InputMethodEditor})();
// Input 89
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
gui.KeyboardHandler=function(){function m(b,g){g||(g=k.None);switch(b){case gui.KeyboardHandler.KeyCode.LeftMeta:case gui.KeyboardHandler.KeyCode.MetaInMozilla:g|=k.Meta;break;case gui.KeyboardHandler.KeyCode.Ctrl:g|=k.Ctrl;break;case gui.KeyboardHandler.KeyCode.Alt:g|=k.Alt;break;case gui.KeyboardHandler.KeyCode.Shift:g|=k.Shift}return b+":"+g}var k=gui.KeyboardHandler.Modifier,b=null,g={};this.setDefault=function(g){b=g};this.bind=function(b,k,d,n){b=m(b,k);runtime.assert(n||!1===g.hasOwnProperty(b),
"tried to overwrite the callback handler of key combo: "+b);g[b]=d};this.unbind=function(b,k){var d=m(b,k);delete g[d]};this.reset=function(){b=null;g={}};this.handleEvent=function(p){var l=p.keyCode,d=k.None;p.metaKey&&(d|=k.Meta);p.ctrlKey&&(d|=k.Ctrl);p.altKey&&(d|=k.Alt);p.shiftKey&&(d|=k.Shift);l=m(l,d);l=g[l];d=!1;l?d=l():null!==b&&(d=b(p));d&&(p.preventDefault?p.preventDefault():p.returnValue=!1)}};
gui.KeyboardHandler.Modifier={None:0,Meta:1,Ctrl:2,Alt:4,CtrlAlt:6,Shift:8,MetaShift:9,CtrlShift:10,AltShift:12};gui.KeyboardHandler.KeyCode={Backspace:8,Tab:9,Clear:12,Enter:13,Shift:16,Ctrl:17,Alt:18,End:35,Home:36,Left:37,Up:38,Right:39,Down:40,Delete:46,A:65,B:66,C:67,D:68,E:69,F:70,G:71,H:72,I:73,J:74,K:75,L:76,M:77,N:78,O:79,P:80,Q:81,R:82,S:83,T:84,U:85,V:86,W:87,X:88,Y:89,Z:90,LeftMeta:91,MetaInMozilla:224};(function(){return gui.KeyboardHandler})();
// Input 90
/*

 Copyright (C) 2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
gui.PlainTextPasteboard=function(m,k){function b(b,k){b.init(k);return b}this.createPasteOps=function(g){var p=m.getCursorPosition(k),l=p,d=[];g.replace(/\r/g,"").split("\n").forEach(function(g){d.push(b(new ops.OpSplitParagraph,{memberid:k,position:l,moveCursor:!0}));l+=1;d.push(b(new ops.OpInsertText,{memberid:k,position:l,text:g,moveCursor:!0}));l+=g.length});d.push(b(new ops.OpRemoveText,{memberid:k,position:p,length:1}));return d}};
// Input 91
/*

 Copyright (C) 2014 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
odf.WordBoundaryFilter=function(m,k){function b(a,b,c){for(var d=null,f=m.getRootNode(),h;a!==f&&null!==a&&null===d;)h=0>b?a.previousSibling:a.nextSibling,c(h)===NodeFilter.FILTER_ACCEPT&&(d=h),a=a.parentNode;return d}function g(a,b){var c;return null===a?h.NO_NEIGHBOUR:d.isCharacterElement(a)?h.SPACE_CHAR:a.nodeType===p||d.isTextSpan(a)||d.isHyperlink(a)?(c=a.textContent.charAt(b()),r.test(c)?h.SPACE_CHAR:n.test(c)?h.PUNCTUATION_CHAR:h.WORD_CHAR):h.OTHER}var p=Node.TEXT_NODE,l=Node.ELEMENT_NODE,
d=new odf.OdfUtils,n=/[!-#%-*,-\/:-;?-@\[-\]_{}\u00a1\u00ab\u00b7\u00bb\u00bf;\u00b7\u055a-\u055f\u0589-\u058a\u05be\u05c0\u05c3\u05c6\u05f3-\u05f4\u0609-\u060a\u060c-\u060d\u061b\u061e-\u061f\u066a-\u066d\u06d4\u0700-\u070d\u07f7-\u07f9\u0964-\u0965\u0970\u0df4\u0e4f\u0e5a-\u0e5b\u0f04-\u0f12\u0f3a-\u0f3d\u0f85\u0fd0-\u0fd4\u104a-\u104f\u10fb\u1361-\u1368\u166d-\u166e\u169b-\u169c\u16eb-\u16ed\u1735-\u1736\u17d4-\u17d6\u17d8-\u17da\u1800-\u180a\u1944-\u1945\u19de-\u19df\u1a1e-\u1a1f\u1b5a-\u1b60\u1c3b-\u1c3f\u1c7e-\u1c7f\u2000-\u206e\u207d-\u207e\u208d-\u208e\u3008-\u3009\u2768-\u2775\u27c5-\u27c6\u27e6-\u27ef\u2983-\u2998\u29d8-\u29db\u29fc-\u29fd\u2cf9-\u2cfc\u2cfe-\u2cff\u2e00-\u2e7e\u3000-\u303f\u30a0\u30fb\ua60d-\ua60f\ua673\ua67e\ua874-\ua877\ua8ce-\ua8cf\ua92e-\ua92f\ua95f\uaa5c-\uaa5f\ufd3e-\ufd3f\ufe10-\ufe19\ufe30-\ufe52\ufe54-\ufe61\ufe63\ufe68\ufe6a-\ufe6b\uff01-\uff03\uff05-\uff0a\uff0c-\uff0f\uff1a-\uff1b\uff1f-\uff20\uff3b-\uff3d\uff3f\uff5b\uff5d\uff5f-\uff65]|\ud800[\udd00-\udd01\udf9f\udfd0]|\ud802[\udd1f\udd3f\ude50-\ude58]|\ud809[\udc00-\udc7e]/,
r=/\s/,f=core.PositionFilter.FilterResult.FILTER_ACCEPT,q=core.PositionFilter.FilterResult.FILTER_REJECT,a=odf.WordBoundaryFilter.IncludeWhitespace.TRAILING,c=odf.WordBoundaryFilter.IncludeWhitespace.LEADING,h={NO_NEIGHBOUR:0,SPACE_CHAR:1,PUNCTUATION_CHAR:2,WORD_CHAR:3,OTHER:4};this.acceptPosition=function(d){var n=d.container(),m=d.leftNode(),p=d.rightNode(),r=d.unfilteredDomOffset,u=function(){return d.unfilteredDomOffset()-1};n.nodeType===l&&(null===p&&(p=b(n,1,d.getNodeFilter())),null===m&&(m=
b(n,-1,d.getNodeFilter())));n!==p&&(r=function(){return 0});n!==m&&null!==m&&(u=function(){return m.textContent.length-1});n=g(m,u);p=g(p,r);return n===h.WORD_CHAR&&p===h.WORD_CHAR||n===h.PUNCTUATION_CHAR&&p===h.PUNCTUATION_CHAR||k===a&&n!==h.NO_NEIGHBOUR&&p===h.SPACE_CHAR||k===c&&n===h.SPACE_CHAR&&p!==h.NO_NEIGHBOUR?q:f}};odf.WordBoundaryFilter.IncludeWhitespace={None:0,TRAILING:1,LEADING:2};(function(){return odf.WordBoundaryFilter})();
// Input 92
gui.SelectionController=function(m,k){function b(){var a=x.getCursor(k).getNode();return x.createStepIterator(a,0,[s,H],x.getRootElement(a))}function g(a,b,c){c=new odf.WordBoundaryFilter(x,c);return x.createStepIterator(a,b,[s,H,c],x.getRootElement(a))}function p(a){return function(b){var c=a(b);return function(b,d){return a(d)===c}}}function l(a,b){return b?{anchorNode:a.startContainer,anchorOffset:a.startOffset,focusNode:a.endContainer,focusOffset:a.endOffset}:{anchorNode:a.endContainer,anchorOffset:a.endOffset,
focusNode:a.startContainer,focusOffset:a.startOffset}}function d(a,b,c){var d=new ops.OpMoveCursor;d.init({memberid:k,position:a,length:b||0,selectionType:c});return d}function n(a){var b;b=g(a.startContainer,a.startOffset,M);b.roundToPreviousStep()&&a.setStart(b.container(),b.offset());b=g(a.endContainer,a.endOffset,O);b.roundToNextStep()&&a.setEnd(b.container(),b.offset())}function r(a){var b=t.getParagraphElements(a),c=b[0],b=b[b.length-1];c&&a.setStart(c,0);b&&(t.isParagraph(a.endContainer)&&
0===a.endOffset?a.setEndBefore(b):a.setEnd(b,b.childNodes.length))}function f(a){var b=x.getCursorSelection(k),c=x.getCursor(k).getStepCounter();0!==a&&(a=0<a?c.convertForwardStepsBetweenFilters(a,z,s):-c.convertBackwardStepsBetweenFilters(-a,z,s),a=b.length+a,m.enqueue([d(b.position,a)]))}function q(a){var c=b(),e=x.getCursor(k).getAnchorNode();a(c)&&(a=x.convertDomToCursorRange({anchorNode:e,anchorOffset:0,focusNode:c.container(),focusOffset:c.offset()}),m.enqueue([d(a.position,a.length)]))}function a(a){var b=
x.getCursorPosition(k),c=x.getCursor(k).getStepCounter();0!==a&&(a=0<a?c.convertForwardStepsBetweenFilters(a,z,s):-c.convertBackwardStepsBetweenFilters(-a,z,s),m.enqueue([d(b+a,0)]))}function c(a){var c=b();a(c)&&(a=x.convertDomPointToCursorStep(c.container(),c.offset()),m.enqueue([d(a,0)]))}function h(b,c){var d=x.getParagraphElement(x.getCursor(k).getNode());runtime.assert(Boolean(d),"SelectionController: Cursor outside paragraph");d=x.getCursor(k).getStepCounter().countLinesSteps(b,z);c?f(d):a(d)}
function e(b,c){var d=x.getCursor(k).getStepCounter().countStepsToLineBoundary(b,z);c?f(d):a(d)}function v(a,b){var c=x.getCursor(k),c=l(c.getSelectedRange(),c.hasForwardSelection()),e=g(c.focusNode,c.focusOffset,M);if(0<=a?e.nextStep():e.previousStep())c.focusNode=e.container(),c.focusOffset=e.offset(),b||(c.anchorNode=c.focusNode,c.anchorOffset=c.focusOffset),c=x.convertDomToCursorRange(c),m.enqueue([d(c.position,c.length)])}function w(a,b){var c=x.getCursor(k),e=b(c.getNode()),c=l(c.getSelectedRange(),
c.hasForwardSelection());runtime.assert(Boolean(e),"SelectionController: Cursor outside root");0>a?(c.focusNode=e,c.focusOffset=0):(c.focusNode=e,c.focusOffset=e.childNodes.length);e=x.convertDomToCursorRange(c,p(b));m.enqueue([d(e.position,e.length)])}function A(a){var b=x.getCursor(k),b=x.getRootElement(b.getNode());runtime.assert(Boolean(b),"SelectionController: Cursor outside root");a=0>a?x.convertDomPointToCursorStep(b,0,function(a){return a===ops.StepsTranslator.NEXT_STEP}):x.convertDomPointToCursorStep(b,
b.childNodes.length);m.enqueue([d(a,0)]);return!0}var x=m.getOdtDocument(),u=new core.DomUtils,t=new odf.OdfUtils,s=x.getPositionFilter(),z=new core.PositionFilterChain,H=x.createRootFilter(k),M=odf.WordBoundaryFilter.IncludeWhitespace.TRAILING,O=odf.WordBoundaryFilter.IncludeWhitespace.LEADING;this.selectionToRange=function(a){var b=0<=u.comparePoints(a.anchorNode,a.anchorOffset,a.focusNode,a.focusOffset),c=a.focusNode.ownerDocument.createRange();b?(c.setStart(a.anchorNode,a.anchorOffset),c.setEnd(a.focusNode,
a.focusOffset)):(c.setStart(a.focusNode,a.focusOffset),c.setEnd(a.anchorNode,a.anchorOffset));return{range:c,hasForwardSelection:b}};this.rangeToSelection=l;this.selectImage=function(a){var b=x.getRootElement(a),c=x.createRootFilter(b),b=x.createStepIterator(a,0,[c,x.getPositionFilter()],b),e;b.roundToPreviousStep()||runtime.assert(!1,"No walkable position before frame");c=b.container();e=b.offset();b.setPosition(a,a.childNodes.length);b.roundToNextStep()||runtime.assert(!1,"No walkable position after frame");
a=x.convertDomToCursorRange({anchorNode:c,anchorOffset:e,focusNode:b.container(),focusOffset:b.offset()});a=d(a.position,a.length,ops.OdtCursor.RegionSelection);m.enqueue([a])};this.expandToWordBoundaries=n;this.expandToParagraphBoundaries=r;this.selectRange=function(a,b,c){var e=x.getOdfCanvas().getElement(),f;f=u.containsNode(e,a.startContainer);e=u.containsNode(e,a.endContainer);if(f||e)if(f&&e&&(2===c?n(a):3<=c&&r(a)),a=l(a,b),b=x.convertDomToCursorRange(a,p(t.getParagraphElement)),a=x.getCursorSelection(k),
b.position!==a.position||b.length!==a.length)a=d(b.position,b.length,ops.OdtCursor.RangeSelection),m.enqueue([a])};this.moveCursorToLeft=function(){c(function(a){return a.previousStep()});return!0};this.moveCursorToRight=function(){c(function(a){return a.nextStep()});return!0};this.extendSelectionToLeft=function(){q(function(a){return a.previousStep()});return!0};this.extendSelectionToRight=function(){q(function(a){return a.nextStep()});return!0};this.moveCursorUp=function(){h(-1,!1);return!0};this.moveCursorDown=
function(){h(1,!1);return!0};this.extendSelectionUp=function(){h(-1,!0);return!0};this.extendSelectionDown=function(){h(1,!0);return!0};this.moveCursorBeforeWord=function(){v(-1,!1);return!0};this.moveCursorPastWord=function(){v(1,!1);return!0};this.extendSelectionBeforeWord=function(){v(-1,!0);return!0};this.extendSelectionPastWord=function(){v(1,!0);return!0};this.moveCursorToLineStart=function(){e(-1,!1);return!0};this.moveCursorToLineEnd=function(){e(1,!1);return!0};this.extendSelectionToLineStart=
function(){e(-1,!0);return!0};this.extendSelectionToLineEnd=function(){e(1,!0);return!0};this.extendSelectionToParagraphStart=function(){w(-1,x.getParagraphElement);return!0};this.extendSelectionToParagraphEnd=function(){w(1,x.getParagraphElement);return!0};this.moveCursorToDocumentStart=function(){A(-1);return!0};this.moveCursorToDocumentEnd=function(){A(1);return!0};this.extendSelectionToDocumentStart=function(){w(-1,x.getRootElement);return!0};this.extendSelectionToDocumentEnd=function(){w(1,x.getRootElement);
return!0};this.extendSelectionToEntireDocument=function(){var a=x.getCursor(k),a=x.getRootElement(a.getNode());runtime.assert(Boolean(a),"SelectionController: Cursor outside root");a=x.convertDomToCursorRange({anchorNode:a,anchorOffset:0,focusNode:a,focusOffset:a.childNodes.length},p(x.getRootElement));m.enqueue([d(a.position,a.length)]);return!0};z.addFilter(s);z.addFilter(x.createRootFilter(k))};
// Input 93
/*

 Copyright (C) 2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
gui.TextController=function(m,k,b,g){function p(b){var d=new ops.OpRemoveText;d.init({memberid:k,position:b.position,length:b.length});return d}function l(b){0>b.length&&(b.position+=b.length,b.length=-b.length);return b}function d(b){var d;d=l(n.getCursorSelection(k));var g,a=null;if(0===d.length){d=n.getCursor(k).getNode();g=n.getRootElement(d);var c=[n.getPositionFilter(),n.createRootFilter(g)];g=n.createStepIterator(d,0,c,g);g.roundToClosestStep()&&(b?g.nextStep():g.previousStep())&&(d=l(n.convertDomToCursorRange({anchorNode:d,
anchorOffset:0,focusNode:g.container(),focusOffset:g.offset()})),a=new ops.OpRemoveText,a.init({memberid:k,position:d.position,length:d.length}),m.enqueue([a]))}else a=p(d),m.enqueue([a]);return null!==a}var n=m.getOdtDocument();this.enqueueParagraphSplittingOps=function(){var b=l(n.getCursorSelection(k)),d,q=[];0<b.length&&(d=p(b),q.push(d));d=new ops.OpSplitParagraph;d.init({memberid:k,position:b.position,moveCursor:!0});q.push(d);g&&(b=g(b.position+1),q=q.concat(b));m.enqueue(q);return!0};this.removeTextByBackspaceKey=
function(){return d(!1)};this.removeTextByDeleteKey=function(){return d(!0)};this.removeCurrentSelection=function(){var b=l(n.getCursorSelection(k));0!==b.length&&(b=p(b),m.enqueue([b]));return!0};this.insertText=function(d){var f=l(n.getCursorSelection(k)),g,a=[],c=!1;0<f.length&&(g=p(f),a.push(g),c=!0);g=new ops.OpInsertText;g.init({memberid:k,position:f.position,text:d,moveCursor:!0});a.push(g);b&&(d=b(f.position,d.length,c))&&a.push(d);m.enqueue(a)}};(function(){return gui.TextController})();
// Input 94
/*

 Copyright (C) 2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
gui.UndoManager=function(){};gui.UndoManager.prototype.subscribe=function(m,k){};gui.UndoManager.prototype.unsubscribe=function(m,k){};gui.UndoManager.prototype.setDocument=function(m){};gui.UndoManager.prototype.setInitialState=function(){};gui.UndoManager.prototype.initialize=function(){};gui.UndoManager.prototype.purgeInitialState=function(){};gui.UndoManager.prototype.setPlaybackFunction=function(m){};gui.UndoManager.prototype.hasUndoStates=function(){};
gui.UndoManager.prototype.hasRedoStates=function(){};gui.UndoManager.prototype.moveForward=function(m){};gui.UndoManager.prototype.moveBackward=function(m){};gui.UndoManager.prototype.onOperationExecuted=function(m){};gui.UndoManager.signalUndoStackChanged="undoStackChanged";gui.UndoManager.signalUndoStateCreated="undoStateCreated";gui.UndoManager.signalUndoStateModified="undoStateModified";(function(){return gui.UndoManager})();
// Input 95
(function(){var m=core.PositionFilter.FilterResult.FILTER_ACCEPT;gui.SessionController=function(k,b,g,p){function l(a){return a.target||a.srcElement||null}function d(a,b){var c=J.getDOMDocument(),d=null;c.caretRangeFromPoint?(c=c.caretRangeFromPoint(a,b),d={container:c.startContainer,offset:c.startOffset}):c.caretPositionFromPoint&&(c=c.caretPositionFromPoint(a,b))&&c.offsetNode&&(d={container:c.offsetNode,offset:c.offset});return d}function n(a){var c=J.getCursor(b).getSelectedRange();c.collapsed?
a.preventDefault():L.setDataFromRange(a,c)?U.removeCurrentSelection():runtime.log("Cut operation failed")}function r(){return!1!==J.getCursor(b).getSelectedRange().collapsed}function f(a){var c=J.getCursor(b).getSelectedRange();c.collapsed?a.preventDefault():L.setDataFromRange(a,c)||runtime.log("Copy operation failed")}function q(a){var b;E.clipboardData&&E.clipboardData.getData?b=E.clipboardData.getData("Text"):a.clipboardData&&a.clipboardData.getData&&(b=a.clipboardData.getData("text/plain"));b&&
(U.removeCurrentSelection(),k.enqueue(ma.createPasteOps(b)));a.preventDefault?a.preventDefault():a.returnValue=!1}function a(){return!1}function c(a){if(da)da.onOperationExecuted(a)}function h(a){J.emit(ops.OdtDocument.signalUndoStackChanged,a)}function e(){var a=G.getEventTrap(),b,c;return da?(c=G.hasFocus(),da.moveBackward(1),b=J.getOdfCanvas().getSizer(),I.containsNode(b,a)||(b.appendChild(a),c&&G.focus()),!0):!1}function v(){var a;return da?(a=G.hasFocus(),da.moveForward(1),a&&G.focus(),!0):!1}
function w(a){var c=J.getCursor(b).getSelectedRange(),e=l(a).getAttribute("end");c&&e&&(a=d(a.clientX,a.clientY))&&(ea.setUnfilteredPosition(a.container,a.offset),ba.acceptPosition(ea)===m&&(c=c.cloneRange(),"left"===e?c.setStart(ea.container(),ea.unfilteredDomOffset()):c.setEnd(ea.container(),ea.unfilteredDomOffset()),g.setSelectedRange(c,"right"===e),J.emit(ops.Document.signalCursorMoved,g)))}function A(){K.selectRange(g.getSelectedRange(),g.hasForwardSelection(),1)}function x(){var a=E.getSelection(),
b=0<a.rangeCount&&K.selectionToRange(a);P&&b&&(Q=!0,fa.clearSelection(),ea.setUnfilteredPosition(a.focusNode,a.focusOffset),ba.acceptPosition(ea)===m&&(2===ka?K.expandToWordBoundaries(b.range):3<=ka&&K.expandToParagraphBoundaries(b.range),g.setSelectedRange(b.range,b.hasForwardSelection),J.emit(ops.Document.signalCursorMoved,g)))}function u(a){var c=l(a),d=J.getCursor(b);if(P=null!==c&&I.containsNode(J.getOdfCanvas().getElement(),c))Q=!1,ba=J.createRootFilter(c),ka=a.detail,d&&a.shiftKey?E.getSelection().collapse(d.getAnchorNode(),
0):(a=E.getSelection(),c=d.getSelectedRange(),a.extend?d.hasForwardSelection()?(a.collapse(c.startContainer,c.startOffset),a.extend(c.endContainer,c.endOffset)):(a.collapse(c.endContainer,c.endOffset),a.extend(c.startContainer,c.startOffset)):(a.removeAllRanges(),a.addRange(c.cloneRange()))),1<ka&&x()}function t(a){var b=J.getRootElement(a),c=J.createRootFilter(b),b=J.createStepIterator(a,0,[c,J.getPositionFilter()],b);b.setPosition(a,a.childNodes.length);return b.roundToNextStep()?{container:b.container(),
offset:b.offset()}:null}function s(a){var b;b=(b=E.getSelection())?{anchorNode:b.anchorNode,anchorOffset:b.anchorOffset,focusNode:b.focusNode,focusOffset:b.focusOffset}:null;var c,e;b.anchorNode||b.focusNode||!(c=d(a.clientX,a.clientY))||(b.anchorNode=c.container,b.anchorOffset=c.offset,b.focusNode=b.anchorNode,b.focusOffset=b.anchorOffset);if($.isImage(b.focusNode)&&0===b.focusOffset&&$.isCharacterFrame(b.focusNode.parentNode)){if(e=b.focusNode.parentNode,c=e.getBoundingClientRect(),a.clientX>c.right&&
(c=t(e)))b.anchorNode=b.focusNode=c.container,b.anchorOffset=b.focusOffset=c.offset}else $.isImage(b.focusNode.firstChild)&&1===b.focusOffset&&$.isCharacterFrame(b.focusNode)&&(c=t(b.focusNode))&&(b.anchorNode=b.focusNode=c.container,b.anchorOffset=b.focusOffset=c.offset);b.anchorNode&&b.focusNode&&(b=K.selectionToRange(b),K.selectRange(b.range,b.hasForwardSelection,a.detail));G.focus()}function z(a){var b;if(b=d(a.clientX,a.clientY))a=b.container,b=b.offset,a={anchorNode:a,anchorOffset:b,focusNode:a,
focusOffset:b},a=K.selectionToRange(a),K.selectRange(a.range,a.hasForwardSelection,2),G.focus()}function H(a){var b=l(a),c,d;ha.processRequests();$.isImage(b)&&$.isCharacterFrame(b.parentNode)&&E.getSelection().isCollapsed?(K.selectImage(b.parentNode),G.focus()):fa.isSelectorElement(b)?G.focus():P&&(Q?(b=g.getSelectedRange(),c=b.collapsed,$.isImage(b.endContainer)&&0===b.endOffset&&$.isCharacterFrame(b.endContainer.parentNode)&&(d=b.endContainer.parentNode,d=t(d))&&(b.setEnd(d.container,d.offset),
c&&b.collapse(!1)),K.selectRange(b,g.hasForwardSelection(),a.detail),G.focus()):pa?s(a):la=runtime.setTimeout(function(){s(a)},0));ka=0;Q=P=!1}function M(a){var c=J.getCursor(b).getSelectedRange();c.collapsed||V.exportRangeToDataTransfer(a.dataTransfer,c)}function O(){P&&G.focus();ka=0;Q=P=!1}function F(a){H(a)}function W(a){var b=l(a),c=null;"annotationRemoveButton"===b.className?(c=I.getElementsByTagNameNS(b.parentNode,odf.Namespaces.officens,"annotation")[0],R.removeAnnotation(c),G.focus()):"webodf-draggable"!==
b.getAttribute("class")&&H(a)}function T(a){(a=a.data)&&U.insertText(a)}function Z(a){return function(){a();return!0}}function D(a){return function(c){return J.getCursor(b).getSelectionType()===ops.OdtCursor.RangeSelection?a(c):!0}}function ca(a){G.unsubscribe("keydown",y.handleEvent);G.unsubscribe("keypress",aa.handleEvent);G.unsubscribe("keyup",X.handleEvent);G.unsubscribe("copy",f);G.unsubscribe("mousedown",u);G.unsubscribe("mousemove",ha.trigger);G.unsubscribe("mouseup",W);G.unsubscribe("contextmenu",
F);G.unsubscribe("dragstart",M);G.unsubscribe("dragend",O);G.unsubscribe("click",Y.handleClick);G.unsubscribe("longpress",z);G.unsubscribe("drag",w);G.unsubscribe("dragstop",A);J.unsubscribe(ops.OdtDocument.signalOperationEnd,ja.trigger);J.unsubscribe(ops.Document.signalCursorAdded,ga.registerCursor);J.unsubscribe(ops.Document.signalCursorRemoved,ga.removeCursor);J.unsubscribe(ops.OdtDocument.signalOperationEnd,c);a()}var E=runtime.getWindow(),J=k.getOdtDocument(),I=new core.DomUtils,$=new odf.OdfUtils,
V=new gui.MimeDataExporter,L=new gui.Clipboard(V),y=new gui.KeyboardHandler,aa=new gui.KeyboardHandler,X=new gui.KeyboardHandler,P=!1,N=new odf.ObjectNameGenerator(J.getOdfCanvas().odfContainer(),b),Q=!1,ba=null,la,da=null,G=new gui.EventManager(J),R=new gui.AnnotationController(k,b),S=new gui.DirectFormattingController(k,b,N,p.directParagraphStylingEnabled),U=new gui.TextController(k,b,S.createCursorStyleOp,S.createParagraphStyleOps),ia=new gui.ImageController(k,b,N),fa=new gui.ImageSelector(J.getOdfCanvas()),
ea=gui.SelectionMover.createPositionIterator(J.getRootNode()),ha,ja,ma=new gui.PlainTextPasteboard(J,b),ga=new gui.InputMethodEditor(b,G),ka=0,Y=new gui.HyperlinkClickHandler(J.getOdfCanvas().getElement),qa=new gui.HyperlinkController(k,b),K=new gui.SelectionController(k,b),C=gui.KeyboardHandler.Modifier,B=gui.KeyboardHandler.KeyCode,na=-1!==E.navigator.appVersion.toLowerCase().indexOf("mac"),pa=-1!==["iPad","iPod","iPhone"].indexOf(E.navigator.platform),oa;runtime.assert(null!==E,"Expected to be run in an environment which has a global window, like a browser.");
this.undo=e;this.redo=v;this.insertLocalCursor=function(){runtime.assert(void 0===k.getOdtDocument().getCursor(b),"Inserting local cursor a second time.");var a=new ops.OpAddCursor;a.init({memberid:b});k.enqueue([a]);G.focus()};this.removeLocalCursor=function(){runtime.assert(void 0!==k.getOdtDocument().getCursor(b),"Removing local cursor without inserting before.");var a=new ops.OpRemoveCursor;a.init({memberid:b});k.enqueue([a])};this.startEditing=function(){ga.subscribe(gui.InputMethodEditor.signalCompositionStart,
U.removeCurrentSelection);ga.subscribe(gui.InputMethodEditor.signalCompositionEnd,T);G.subscribe("beforecut",r);G.subscribe("cut",n);G.subscribe("beforepaste",a);G.subscribe("paste",q);E.addEventListener("focus",Y.showTextCursor,!1);da&&da.initialize();ga.setEditing(!0);Y.setModifier(na?gui.HyperlinkClickHandler.Modifier.Meta:gui.HyperlinkClickHandler.Modifier.Ctrl);y.bind(B.Backspace,C.None,Z(U.removeTextByBackspaceKey),!0);y.bind(B.Delete,C.None,U.removeTextByDeleteKey);y.bind(B.Tab,C.None,D(function(){U.insertText("\t");
return!0}));na?(y.bind(B.Clear,C.None,U.removeCurrentSelection),y.bind(B.B,C.Meta,D(S.toggleBold)),y.bind(B.I,C.Meta,D(S.toggleItalic)),y.bind(B.U,C.Meta,D(S.toggleUnderline)),y.bind(B.L,C.MetaShift,D(S.alignParagraphLeft)),y.bind(B.E,C.MetaShift,D(S.alignParagraphCenter)),y.bind(B.R,C.MetaShift,D(S.alignParagraphRight)),y.bind(B.J,C.MetaShift,D(S.alignParagraphJustified)),y.bind(B.C,C.MetaShift,R.addAnnotation),y.bind(B.Z,C.Meta,e),y.bind(B.Z,C.MetaShift,v),y.bind(B.LeftMeta,C.None,Y.showPointerCursor),
y.bind(B.MetaInMozilla,C.None,Y.showPointerCursor),X.bind(B.LeftMeta,C.None,Y.showTextCursor),X.bind(B.MetaInMozilla,C.None,Y.showTextCursor)):(y.bind(B.B,C.Ctrl,D(S.toggleBold)),y.bind(B.I,C.Ctrl,D(S.toggleItalic)),y.bind(B.U,C.Ctrl,D(S.toggleUnderline)),y.bind(B.L,C.CtrlShift,D(S.alignParagraphLeft)),y.bind(B.E,C.CtrlShift,D(S.alignParagraphCenter)),y.bind(B.R,C.CtrlShift,D(S.alignParagraphRight)),y.bind(B.J,C.CtrlShift,D(S.alignParagraphJustified)),y.bind(B.C,C.CtrlAlt,R.addAnnotation),y.bind(B.Z,
C.Ctrl,e),y.bind(B.Z,C.CtrlShift,v),y.bind(B.Ctrl,C.None,Y.showPointerCursor),X.bind(B.Ctrl,C.None,Y.showTextCursor));aa.setDefault(D(function(a){var b;b=null===a.which||void 0===a.which?String.fromCharCode(a.keyCode):0!==a.which&&0!==a.charCode?String.fromCharCode(a.which):null;return!b||a.altKey||a.ctrlKey||a.metaKey?!1:(U.insertText(b),!0)}));aa.bind(B.Enter,C.None,D(U.enqueueParagraphSplittingOps))};this.endEditing=function(){ga.unsubscribe(gui.InputMethodEditor.signalCompositionStart,U.removeCurrentSelection);
ga.unsubscribe(gui.InputMethodEditor.signalCompositionEnd,T);G.unsubscribe("cut",n);G.unsubscribe("beforecut",r);G.unsubscribe("paste",q);G.unsubscribe("beforepaste",a);E.removeEventListener("focus",Y.showTextCursor,!1);ga.setEditing(!1);Y.setModifier(gui.HyperlinkClickHandler.Modifier.None);y.bind(B.Backspace,C.None,function(){return!0},!0);y.unbind(B.Delete,C.None);y.unbind(B.Tab,C.None);na?(y.unbind(B.Clear,C.None),y.unbind(B.B,C.Meta),y.unbind(B.I,C.Meta),y.unbind(B.U,C.Meta),y.unbind(B.L,C.MetaShift),
y.unbind(B.E,C.MetaShift),y.unbind(B.R,C.MetaShift),y.unbind(B.J,C.MetaShift),y.unbind(B.C,C.MetaShift),y.unbind(B.Z,C.Meta),y.unbind(B.Z,C.MetaShift),y.unbind(B.LeftMeta,C.Meta),y.unbind(B.MetaInMozilla,C.Meta),X.unbind(B.LeftMeta,C.None),X.unbind(B.MetaInMozilla,C.None)):(y.unbind(B.B,C.Ctrl),y.unbind(B.I,C.Ctrl),y.unbind(B.U,C.Ctrl),y.unbind(B.L,C.CtrlShift),y.unbind(B.E,C.CtrlShift),y.unbind(B.R,C.CtrlShift),y.unbind(B.J,C.CtrlShift),y.unbind(B.C,C.CtrlAlt),y.unbind(B.Z,C.Ctrl),y.unbind(B.Z,C.CtrlShift),
y.unbind(B.Ctrl,C.Ctrl),X.unbind(B.Ctrl,C.None));aa.setDefault(null);aa.unbind(B.Enter,C.None)};this.getInputMemberId=function(){return b};this.getSession=function(){return k};this.setUndoManager=function(a){da&&da.unsubscribe(gui.UndoManager.signalUndoStackChanged,h);if(da=a)da.setDocument(J),da.setPlaybackFunction(k.enqueue),da.subscribe(gui.UndoManager.signalUndoStackChanged,h)};this.getUndoManager=function(){return da};this.getAnnotationController=function(){return R};this.getDirectFormattingController=
function(){return S};this.getHyperlinkController=function(){return qa};this.getImageController=function(){return ia};this.getSelectionController=function(){return K};this.getTextController=function(){return U};this.getEventManager=function(){return G};this.getKeyboardHandlers=function(){return{keydown:y,keypress:aa}};this.destroy=function(a){var b=[];oa&&b.push(oa.destroy);b=b.concat([ha.destroy,ja.destroy,S.destroy,ga.destroy,G.destroy,ca]);runtime.clearTimeout(la);core.Async.destroyAll(b,a)};ha=
new core.ScheduledTask(x,0);ja=new core.ScheduledTask(function(){var a=J.getCursor(b);if(a&&a.getSelectionType()===ops.OdtCursor.RegionSelection&&(a=$.getImageElements(a.getSelectedRange())[0])){fa.select(a.parentNode);return}fa.clearSelection()},0);y.bind(B.Left,C.None,D(K.moveCursorToLeft));y.bind(B.Right,C.None,D(K.moveCursorToRight));y.bind(B.Up,C.None,D(K.moveCursorUp));y.bind(B.Down,C.None,D(K.moveCursorDown));y.bind(B.Left,C.Shift,D(K.extendSelectionToLeft));y.bind(B.Right,C.Shift,D(K.extendSelectionToRight));
y.bind(B.Up,C.Shift,D(K.extendSelectionUp));y.bind(B.Down,C.Shift,D(K.extendSelectionDown));y.bind(B.Home,C.None,D(K.moveCursorToLineStart));y.bind(B.End,C.None,D(K.moveCursorToLineEnd));y.bind(B.Home,C.Ctrl,D(K.moveCursorToDocumentStart));y.bind(B.End,C.Ctrl,D(K.moveCursorToDocumentEnd));y.bind(B.Home,C.Shift,D(K.extendSelectionToLineStart));y.bind(B.End,C.Shift,D(K.extendSelectionToLineEnd));y.bind(B.Up,C.CtrlShift,D(K.extendSelectionToParagraphStart));y.bind(B.Down,C.CtrlShift,D(K.extendSelectionToParagraphEnd));
y.bind(B.Home,C.CtrlShift,D(K.extendSelectionToDocumentStart));y.bind(B.End,C.CtrlShift,D(K.extendSelectionToDocumentEnd));na?(y.bind(B.Left,C.Alt,D(K.moveCursorBeforeWord)),y.bind(B.Right,C.Alt,D(K.moveCursorPastWord)),y.bind(B.Left,C.Meta,D(K.moveCursorToLineStart)),y.bind(B.Right,C.Meta,D(K.moveCursorToLineEnd)),y.bind(B.Home,C.Meta,D(K.moveCursorToDocumentStart)),y.bind(B.End,C.Meta,D(K.moveCursorToDocumentEnd)),y.bind(B.Left,C.AltShift,D(K.extendSelectionBeforeWord)),y.bind(B.Right,C.AltShift,
D(K.extendSelectionPastWord)),y.bind(B.Left,C.MetaShift,D(K.extendSelectionToLineStart)),y.bind(B.Right,C.MetaShift,D(K.extendSelectionToLineEnd)),y.bind(B.Up,C.AltShift,D(K.extendSelectionToParagraphStart)),y.bind(B.Down,C.AltShift,D(K.extendSelectionToParagraphEnd)),y.bind(B.Up,C.MetaShift,D(K.extendSelectionToDocumentStart)),y.bind(B.Down,C.MetaShift,D(K.extendSelectionToDocumentEnd)),y.bind(B.A,C.Meta,D(K.extendSelectionToEntireDocument))):(y.bind(B.Left,C.Ctrl,D(K.moveCursorBeforeWord)),y.bind(B.Right,
C.Ctrl,D(K.moveCursorPastWord)),y.bind(B.Left,C.CtrlShift,D(K.extendSelectionBeforeWord)),y.bind(B.Right,C.CtrlShift,D(K.extendSelectionPastWord)),y.bind(B.A,C.Ctrl,D(K.extendSelectionToEntireDocument)));pa&&(oa=new gui.IOSSafariSupport(G));G.subscribe("keydown",y.handleEvent);G.subscribe("keypress",aa.handleEvent);G.subscribe("keyup",X.handleEvent);G.subscribe("copy",f);G.subscribe("mousedown",u);G.subscribe("mousemove",ha.trigger);G.subscribe("mouseup",W);G.subscribe("contextmenu",F);G.subscribe("dragstart",
M);G.subscribe("dragend",O);G.subscribe("click",Y.handleClick);G.subscribe("longpress",z);G.subscribe("drag",w);G.subscribe("dragstop",A);J.subscribe(ops.OdtDocument.signalOperationEnd,ja.trigger);J.subscribe(ops.Document.signalCursorAdded,ga.registerCursor);J.subscribe(ops.Document.signalCursorRemoved,ga.removeCursor);J.subscribe(ops.OdtDocument.signalOperationEnd,c)};return gui.SessionController})();
// Input 96
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
gui.CaretManager=function(m){function k(a){return c.hasOwnProperty(a)?c[a]:null}function b(){return Object.keys(c).map(function(a){return c[a]})}function g(a){var b=c[a];b&&(b.destroy(function(){}),delete c[a])}function p(a){a=a.getMemberId();a===m.getInputMemberId()&&(a=k(a))&&a.refreshCursorBlinking()}function l(){var a=k(m.getInputMemberId());v=!1;a&&a.ensureVisible()}function d(){var a=k(m.getInputMemberId());a&&(a.handleUpdate(),v||(v=!0,e=runtime.setTimeout(l,50)))}function n(a){a.memberId===
m.getInputMemberId()&&d()}function r(){var a=k(m.getInputMemberId());a&&a.setFocus()}function f(){var a=k(m.getInputMemberId());a&&a.removeFocus()}function q(){var a=k(m.getInputMemberId());a&&a.show()}function a(){var a=k(m.getInputMemberId());a&&a.hide()}var c={},h=runtime.getWindow(),e,v=!1;this.registerCursor=function(a,b,e){var f=a.getMemberId();b=new gui.Caret(a,b,e);e=m.getEventManager();c[f]=b;f===m.getInputMemberId()?(runtime.log("Starting to track input on new cursor of "+f),a.subscribe(ops.OdtCursor.signalCursorUpdated,
d),b.setOverlayElement(e.getEventTrap())):a.subscribe(ops.OdtCursor.signalCursorUpdated,b.handleUpdate);return b};this.getCaret=k;this.getCarets=b;this.destroy=function(d){var k=m.getSession().getOdtDocument(),l=m.getEventManager(),u=b().map(function(a){return a.destroy});runtime.clearTimeout(e);k.unsubscribe(ops.OdtDocument.signalParagraphChanged,n);k.unsubscribe(ops.Document.signalCursorMoved,p);k.unsubscribe(ops.Document.signalCursorRemoved,g);l.unsubscribe("focus",r);l.unsubscribe("blur",f);h.removeEventListener("focus",
q,!1);h.removeEventListener("blur",a,!1);c={};core.Async.destroyAll(u,d)};(function(){var b=m.getSession().getOdtDocument(),c=m.getEventManager();b.subscribe(ops.OdtDocument.signalParagraphChanged,n);b.subscribe(ops.Document.signalCursorMoved,p);b.subscribe(ops.Document.signalCursorRemoved,g);c.subscribe("focus",r);c.subscribe("blur",f);h.addEventListener("focus",q,!1);h.addEventListener("blur",a,!1)})()};
// Input 97
gui.EditInfoHandle=function(m){var k=[],b,g=m.ownerDocument,p=g.documentElement.namespaceURI;this.setEdits=function(l){k=l;var d,n,m,f;b.innerHTML="";for(l=0;l<k.length;l+=1)d=g.createElementNS(p,"div"),d.className="editInfo",n=g.createElementNS(p,"span"),n.className="editInfoColor",n.setAttributeNS("urn:webodf:names:editinfo","editinfo:memberid",k[l].memberid),m=g.createElementNS(p,"span"),m.className="editInfoAuthor",m.setAttributeNS("urn:webodf:names:editinfo","editinfo:memberid",k[l].memberid),
f=g.createElementNS(p,"span"),f.className="editInfoTime",f.setAttributeNS("urn:webodf:names:editinfo","editinfo:memberid",k[l].memberid),f.innerHTML=k[l].time,d.appendChild(n),d.appendChild(m),d.appendChild(f),b.appendChild(d)};this.show=function(){b.style.display="block"};this.hide=function(){b.style.display="none"};this.destroy=function(g){m.removeChild(b);g()};b=g.createElementNS(p,"div");b.setAttribute("class","editInfoHandle");b.style.display="none";m.appendChild(b)};
// Input 98
/*

 Copyright (C) 2012 KO GmbH <aditya.bhatt@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.EditInfo=function(m,k){function b(){var b=[],d;for(d in p)p.hasOwnProperty(d)&&b.push({memberid:d,time:p[d].time});b.sort(function(b,d){return b.time-d.time});return b}var g,p={};this.getNode=function(){return g};this.getOdtDocument=function(){return k};this.getEdits=function(){return p};this.getSortedEdits=function(){return b()};this.addEdit=function(b,d){p[b]={time:d}};this.clearEdits=function(){p={}};this.destroy=function(b){m.parentNode&&m.removeChild(g);b()};g=k.getDOMDocument().createElementNS("urn:webodf:names:editinfo",
"editinfo");m.insertBefore(g,m.firstChild)};
// Input 99
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
gui.EditInfoMarker=function(m,k){function b(b,a){return runtime.setTimeout(function(){d.style.opacity=b},a)}var g=this,p,l,d,n,r,f;this.addEdit=function(g,a){var c=Date.now()-a;m.addEdit(g,a);l.setEdits(m.getSortedEdits());d.setAttributeNS("urn:webodf:names:editinfo","editinfo:memberid",g);runtime.clearTimeout(r);runtime.clearTimeout(f);1E4>c?(n=b(1,0),r=b(0.5,1E4-c),f=b(0.2,2E4-c)):1E4<=c&&2E4>c?(n=b(0.5,0),f=b(0.2,2E4-c)):n=b(0.2,0)};this.getEdits=function(){return m.getEdits()};this.clearEdits=
function(){m.clearEdits();l.setEdits([]);d.hasAttributeNS("urn:webodf:names:editinfo","editinfo:memberid")&&d.removeAttributeNS("urn:webodf:names:editinfo","editinfo:memberid")};this.getEditInfo=function(){return m};this.show=function(){d.style.display="block"};this.hide=function(){g.hideHandle();d.style.display="none"};this.showHandle=function(){l.show()};this.hideHandle=function(){l.hide()};this.destroy=function(b){runtime.clearTimeout(n);runtime.clearTimeout(r);runtime.clearTimeout(f);p.removeChild(d);
l.destroy(function(a){a?b(a):m.destroy(b)})};(function(){var b=m.getOdtDocument().getDOMDocument();d=b.createElementNS(b.documentElement.namespaceURI,"div");d.setAttribute("class","editInfoMarker");d.onmouseover=function(){g.showHandle()};d.onmouseout=function(){g.hideHandle()};p=m.getNode();p.appendChild(d);l=new gui.EditInfoHandle(p);k||g.hide()})()};
// Input 100
gui.ShadowCursor=function(m){var k=m.getDOMDocument().createRange(),b=!0;this.removeFromDocument=function(){};this.getMemberId=function(){return gui.ShadowCursor.ShadowCursorMemberId};this.getSelectedRange=function(){return k};this.setSelectedRange=function(g,m){k=g;b=!1!==m};this.hasForwardSelection=function(){return b};this.getDocument=function(){return m};this.getSelectionType=function(){return ops.OdtCursor.RangeSelection};k.setStart(m.getRootNode(),0)};gui.ShadowCursor.ShadowCursorMemberId="";
(function(){return gui.ShadowCursor})();
// Input 101
gui.SelectionView=function(m){};gui.SelectionView.prototype.rerender=function(){};gui.SelectionView.prototype.show=function(){};gui.SelectionView.prototype.hide=function(){};gui.SelectionView.prototype.destroy=function(m){};
// Input 102
/*

 Copyright (C) 2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
gui.SelectionViewManager=function(m){function k(){return Object.keys(b).map(function(g){return b[g]})}var b={};this.getSelectionView=function(g){return b.hasOwnProperty(g)?b[g]:null};this.getSelectionViews=k;this.removeSelectionView=function(g){b.hasOwnProperty(g)&&(b[g].destroy(function(){}),delete b[g])};this.hideSelectionView=function(g){b.hasOwnProperty(g)&&b[g].hide()};this.showSelectionView=function(g){b.hasOwnProperty(g)&&b[g].show()};this.rerenderSelectionViews=function(){Object.keys(b).forEach(function(g){b[g].rerender()})};
this.registerCursor=function(g,k){var l=g.getMemberId(),d=new m(g);k?d.show():d.hide();return b[l]=d};this.destroy=function(b){function m(d,k){k?b(k):d<l.length?l[d].destroy(function(b){m(d+1,b)}):b()}var l=k();m(0,void 0)}};
// Input 103
/*

 Copyright (C) 2012-2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
gui.SessionViewOptions=function(){this.caretBlinksOnRangeSelect=this.caretAvatarsInitiallyVisible=this.editInfoMarkersInitiallyVisible=!0};
(function(){gui.SessionView=function(m,k,b,g,p){function l(a,b,c){function d(b,c,e){c=b+'[editinfo|memberid="'+a+'"]'+e+c;a:{var f=h.firstChild;for(b=b+'[editinfo|memberid="'+a+'"]'+e+"{";f;){if(f.nodeType===Node.TEXT_NODE&&0===f.data.indexOf(b)){b=f;break a}f=f.nextSibling}b=null}b?b.data=c:h.appendChild(document.createTextNode(c))}d("div.editInfoMarker","{ background-color: "+c+"; }","");d("span.editInfoColor","{ background-color: "+c+"; }","");d("span.editInfoAuthor",'{ content: "'+b+'"; }',":before");
d("dc|creator","{ background-color: "+c+"; }","");d(".webodf-selectionOverlay","{ fill: "+c+"; stroke: "+c+";}","");a!==gui.ShadowCursor.ShadowCursorMemberId&&a!==k||d(".webodf-touchEnabled .webodf-selectionOverlay","{ display: block; }"," > .webodf-draggable")}function d(a){var b,c;for(c in v)v.hasOwnProperty(c)&&(b=v[c],a?b.show():b.hide())}function n(a){g.getCarets().forEach(function(b){a?b.showHandle():b.hideHandle()})}function r(a){var b=a.getMemberId();a=a.getProperties();l(b,a.fullName,a.color);
k===b&&l("","",a.color)}function f(a){var c=a.getMemberId(),d=b.getOdtDocument().getMember(c).getProperties();g.registerCursor(a,A,x);p.registerCursor(a,!0);if(a=g.getCaret(c))a.setAvatarImageUrl(d.imageUrl),a.setColor(d.color);runtime.log("+++ View here +++ eagerly created an Caret for '"+c+"'! +++")}function q(a){a=a.getMemberId();var b=p.getSelectionView(k),c=p.getSelectionView(gui.ShadowCursor.ShadowCursorMemberId),d=g.getCaret(k);a===k?(c.hide(),b&&b.show(),d&&d.show()):a===gui.ShadowCursor.ShadowCursorMemberId&&
(c.show(),b&&b.hide(),d&&d.hide())}function a(a){p.removeSelectionView(a)}function c(a){var c=a.paragraphElement,d=a.memberId;a=a.timeStamp;var f,g="",h=c.getElementsByTagNameNS(e,"editinfo").item(0);h?(g=h.getAttributeNS(e,"id"),f=v[g]):(g=Math.random().toString(),f=new ops.EditInfo(c,b.getOdtDocument()),f=new gui.EditInfoMarker(f,w),h=c.getElementsByTagNameNS(e,"editinfo").item(0),h.setAttributeNS(e,"id",g),v[g]=f);f.addEdit(d,new Date(a))}var h,e="urn:webodf:names:editinfo",v={},w=void 0!==m.editInfoMarkersInitiallyVisible?
Boolean(m.editInfoMarkersInitiallyVisible):!0,A=void 0!==m.caretAvatarsInitiallyVisible?Boolean(m.caretAvatarsInitiallyVisible):!0,x=void 0!==m.caretBlinksOnRangeSelect?Boolean(m.caretBlinksOnRangeSelect):!0;this.showEditInfoMarkers=function(){w||(w=!0,d(w))};this.hideEditInfoMarkers=function(){w&&(w=!1,d(w))};this.showCaretAvatars=function(){A||(A=!0,n(A))};this.hideCaretAvatars=function(){A&&(A=!1,n(A))};this.getSession=function(){return b};this.getCaret=function(a){return g.getCaret(a)};this.destroy=
function(d){var e=b.getOdtDocument(),g=Object.keys(v).map(function(a){return v[a]});e.unsubscribe(ops.Document.signalMemberAdded,r);e.unsubscribe(ops.Document.signalMemberUpdated,r);e.unsubscribe(ops.Document.signalCursorAdded,f);e.unsubscribe(ops.Document.signalCursorRemoved,a);e.unsubscribe(ops.OdtDocument.signalParagraphChanged,c);e.unsubscribe(ops.Document.signalCursorMoved,q);e.unsubscribe(ops.OdtDocument.signalParagraphChanged,p.rerenderSelectionViews);e.unsubscribe(ops.OdtDocument.signalTableAdded,
p.rerenderSelectionViews);e.unsubscribe(ops.OdtDocument.signalParagraphStyleModified,p.rerenderSelectionViews);h.parentNode.removeChild(h);(function H(a,b){b?d(b):a<g.length?g[a].destroy(function(b){H(a+1,b)}):d()})(0,void 0)};(function(){var d=b.getOdtDocument(),e=document.getElementsByTagName("head").item(0);d.subscribe(ops.Document.signalMemberAdded,r);d.subscribe(ops.Document.signalMemberUpdated,r);d.subscribe(ops.Document.signalCursorAdded,f);d.subscribe(ops.Document.signalCursorRemoved,a);d.subscribe(ops.OdtDocument.signalParagraphChanged,
c);d.subscribe(ops.Document.signalCursorMoved,q);d.subscribe(ops.OdtDocument.signalParagraphChanged,p.rerenderSelectionViews);d.subscribe(ops.OdtDocument.signalTableAdded,p.rerenderSelectionViews);d.subscribe(ops.OdtDocument.signalParagraphStyleModified,p.rerenderSelectionViews);h=document.createElementNS(e.namespaceURI,"style");h.type="text/css";h.media="screen, print, handheld, projection";h.appendChild(document.createTextNode("@namespace editinfo url(urn:webodf:names:editinfo);"));h.appendChild(document.createTextNode("@namespace dc url(http://purl.org/dc/elements/1.1/);"));
e.appendChild(h)})()}})();
// Input 104
gui.SvgSelectionView=function(m){function k(){var a=h.getRootNode();e!==a&&(e=a,v=e.parentNode.parentNode.parentNode,v.appendChild(A),A.setAttribute("class","webodf-selectionOverlay"),u.setAttribute("class","webodf-draggable"),t.setAttribute("class","webodf-draggable"),u.setAttribute("end","left"),t.setAttribute("end","right"),u.setAttribute("r",8),t.setAttribute("r",8),A.appendChild(x),A.appendChild(u),A.appendChild(t))}function b(a){var b=z.getBoundingClientRect(v),c=H.getZoomLevel(),d={};d.top=
z.adaptRangeDifferenceToZoomLevel(a.top-b.top,c);d.left=z.adaptRangeDifferenceToZoomLevel(a.left-b.left,c);d.bottom=z.adaptRangeDifferenceToZoomLevel(a.bottom-b.top,c);d.right=z.adaptRangeDifferenceToZoomLevel(a.right-b.left,c);d.width=z.adaptRangeDifferenceToZoomLevel(a.width,c);d.height=z.adaptRangeDifferenceToZoomLevel(a.height,c);return d}function g(a){a=a.getBoundingClientRect();return Boolean(a&&0!==a.height)}function p(a){var b=s.getTextElements(a,!0,!1),c=a.cloneRange(),d=a.cloneRange();a=
a.cloneRange();if(!b.length)return null;var e;a:{e=0;var f=b[e],h=c.startContainer===f?c.startOffset:0,k=h;c.setStart(f,h);for(c.setEnd(f,k);!g(c);){if(f.nodeType===Node.ELEMENT_NODE&&k<f.childNodes.length)k=f.childNodes.length;else if(f.nodeType===Node.TEXT_NODE&&k<f.length)k+=1;else if(b[e])f=b[e],e+=1,h=k=0;else{e=!1;break a}c.setStart(f,h);c.setEnd(f,k)}e=!0}if(!e)return null;a:{e=b.length-1;f=b[e];k=h=d.endContainer===f?d.endOffset:f.nodeType===Node.TEXT_NODE?f.length:f.childNodes.length;d.setStart(f,
h);for(d.setEnd(f,k);!g(d);){if(f.nodeType===Node.ELEMENT_NODE&&0<h)h=0;else if(f.nodeType===Node.TEXT_NODE&&0<h)h-=1;else if(b[e])f=b[e],e-=1,h=k=f.length||f.childNodes.length;else{b=!1;break a}d.setStart(f,h);d.setEnd(f,k)}b=!0}if(!b)return null;a.setStart(c.startContainer,c.startOffset);a.setEnd(d.endContainer,d.endOffset);return{firstRange:c,lastRange:d,fillerRange:a}}function l(a,b){var c={};c.top=Math.min(a.top,b.top);c.left=Math.min(a.left,b.left);c.right=Math.max(a.right,b.right);c.bottom=
Math.max(a.bottom,b.bottom);c.width=c.right-c.left;c.height=c.bottom-c.top;return c}function d(a,b){b&&0<b.width&&0<b.height&&(a=a?l(a,b):b);return a}function n(a){function b(a){O.setUnfilteredPosition(a,0);return u.acceptNode(a)===F&&v.acceptPosition(O)===F?F:W}function c(a){var d=null;b(a)===F&&(d=z.getBoundingClientRect(a));return d}var e=a.commonAncestorContainer,f=a.startContainer,g=a.endContainer,k=a.startOffset,l=a.endOffset,n,m,p=null,r,q=w.createRange(),v,u=new odf.OdfNodeFilter,t;if(f===
e||g===e)return q=a.cloneRange(),p=q.getBoundingClientRect(),q.detach(),p;for(a=f;a.parentNode!==e;)a=a.parentNode;for(m=g;m.parentNode!==e;)m=m.parentNode;v=h.createRootFilter(f);for(e=a.nextSibling;e&&e!==m;)r=c(e),p=d(p,r),e=e.nextSibling;if(s.isParagraph(a))p=d(p,z.getBoundingClientRect(a));else if(a.nodeType===Node.TEXT_NODE)e=a,q.setStart(e,k),q.setEnd(e,e===m?l:e.length),r=q.getBoundingClientRect(),p=d(p,r);else for(t=w.createTreeWalker(a,NodeFilter.SHOW_TEXT,b,!1),e=t.currentNode=f;e&&e!==
g;)q.setStart(e,k),q.setEnd(e,e.length),r=q.getBoundingClientRect(),p=d(p,r),n=e,k=0,e=t.nextNode();n||(n=f);if(s.isParagraph(m))p=d(p,z.getBoundingClientRect(m));else if(m.nodeType===Node.TEXT_NODE)e=m,q.setStart(e,e===a?k:0),q.setEnd(e,l),r=q.getBoundingClientRect(),p=d(p,r);else for(t=w.createTreeWalker(m,NodeFilter.SHOW_TEXT,b,!1),e=t.currentNode=g;e&&e!==n;)if(q.setStart(e,0),q.setEnd(e,l),r=q.getBoundingClientRect(),p=d(p,r),e=t.previousNode())l=e.length;return p}function r(a,b){var c=a.getBoundingClientRect(),
d={width:0};d.top=c.top;d.bottom=c.bottom;d.height=c.height;d.left=d.right=b?c.right:c.left;return d}function f(){var a=m.getSelectedRange(),c;if(c=M&&m.getSelectionType()===ops.OdtCursor.RangeSelection&&!a.collapsed){k();var a=p(a),d,e,f,g,h,q,s,v;if(a){c=a.firstRange;d=a.lastRange;e=a.fillerRange;f=b(r(c,!1));h=b(r(d,!0));g=(g=n(e))?b(g):l(f,h);q=g.left;s=f.left+Math.max(0,g.width-(f.left-g.left));g=Math.min(f.top,h.top);v=h.top+h.height;q=[{x:f.left,y:g+f.height},{x:f.left,y:g},{x:s,y:g},{x:s,
y:v-h.height},{x:h.right,y:v-h.height},{x:h.right,y:v},{x:q,y:v},{x:q,y:g+f.height},{x:f.left,y:g+f.height}];s="";var w;for(w=0;w<q.length;w+=1)s+=q[w].x+","+q[w].y+" ";x.setAttribute("points",s);u.setAttribute("cx",f.left);u.setAttribute("cy",g+f.height/2);t.setAttribute("cx",h.right);t.setAttribute("cy",v-h.height/2);c.detach();d.detach();e.detach()}c=Boolean(a)}A.style.display=c?"block":"none"}function q(a){M&&a===m&&T.trigger()}function a(a){a=8/a;u.setAttribute("r",a);t.setAttribute("r",a)}function c(b){v.removeChild(A);
m.getDocument().unsubscribe(ops.Document.signalCursorMoved,q);H.unsubscribe(gui.ZoomHelper.signalZoomChanged,a);b()}var h=m.getDocument(),e,v,w=h.getDOMDocument(),A=w.createElementNS("http://www.w3.org/2000/svg","svg"),x=w.createElementNS("http://www.w3.org/2000/svg","polygon"),u=w.createElementNS("http://www.w3.org/2000/svg","circle"),t=w.createElementNS("http://www.w3.org/2000/svg","circle"),s=new odf.OdfUtils,z=new core.DomUtils,H=h.getCanvas().getZoomHelper(),M=!0,O=gui.SelectionMover.createPositionIterator(h.getRootNode()),
F=NodeFilter.FILTER_ACCEPT,W=NodeFilter.FILTER_REJECT,T;this.rerender=function(){M&&T.trigger()};this.show=function(){M=!0;T.trigger()};this.hide=function(){M=!1;T.trigger()};this.destroy=function(a){core.Async.destroyAll([T.destroy,c],a)};(function(){var b=m.getMemberId();T=new core.ScheduledTask(f,0);k();A.setAttributeNS("urn:webodf:names:editinfo","editinfo:memberid",b);m.getDocument().subscribe(ops.Document.signalCursorMoved,q);H.subscribe(gui.ZoomHelper.signalZoomChanged,a);a(H.getZoomLevel())})()};
// Input 105
/*

 Copyright (C) 2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
gui.UndoStateRules=function(){function m(b,g){var d=b.length;this.previous=function(){for(d-=1;0<=d;d-=1)if(g(b[d]))return b[d];return null}}function k(b){b=b.spec();var g;b.hasOwnProperty("position")&&(g=b.position);return g}function b(b){return b.isEdit}function g(b,g,d){if(!d)return d=k(b)-k(g),0===d||1===Math.abs(d);b=k(b);g=k(g);d=k(d);return b-g===g-d}this.isEditOperation=b;this.isPartOfOperationSet=function(k,l){var d=void 0!==k.group,n;if(!k.isEdit||0===l.length)return!0;n=l[l.length-1];if(d&&
k.group===n.group)return!0;a:switch(k.spec().optype){case "RemoveText":case "InsertText":n=!0;break a;default:n=!1}if(n&&l.some(b)){if(d){var r;d=k.spec().optype;n=new m(l,b);var f=n.previous(),q=null,a,c;runtime.assert(Boolean(f),"No edit operations found in state");c=f.group;runtime.assert(void 0!==c,"Operation has no group");for(a=1;f&&f.group===c;){if(d===f.spec().optype){r=f;break}f=n.previous()}if(r){for(f=n.previous();f;){if(f.group!==c){if(2===a)break;c=f.group;a+=1}if(d===f.spec().optype){q=
f;break}f=n.previous()}r=g(k,r,q)}else r=!1;return r}r=k.spec().optype;d=new m(l,b);n=d.previous();runtime.assert(Boolean(n),"No edit operations found in state");r=r===n.spec().optype?g(k,n,d.previous()):!1;return r}return!1}};
// Input 106
/*

 Copyright (C) 2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
gui.TrivialUndoManager=function(m){function k(a){0<a.length&&(t=!0,h(a),t=!1)}function b(){x.emit(gui.UndoManager.signalUndoStackChanged,{undoAvailable:r.hasUndoStates(),redoAvailable:r.hasRedoStates()})}function g(){v!==c&&v!==w[w.length-1]&&w.push(v)}function p(a){var b=a.previousSibling||a.nextSibling;a.parentNode.removeChild(a);q.normalizeTextNodes(b)}function l(a){return Object.keys(a).map(function(b){return a[b]})}function d(a){function b(a){var e=a.spec();if(f[e.memberid])switch(e.optype){case "AddCursor":c[e.memberid]||
(c[e.memberid]=a,delete f[e.memberid],g-=1);break;case "MoveCursor":d[e.memberid]||(d[e.memberid]=a)}}var c={},d={},f={},g,h=a.pop();e.getMemberIds().forEach(function(a){f[a]=!0});for(g=Object.keys(f).length;h&&0<g;)h.reverse(),h.forEach(b),h=a.pop();return l(c).concat(l(d))}function n(){var h=a=e.cloneDocumentElement();q.getElementsByTagNameNS(h,f,"cursor").forEach(p);q.getElementsByTagNameNS(h,f,"anchor").forEach(p);g();v=c=d([c].concat(w));w.length=0;A.length=0;b()}var r=this,f="urn:webodf:names:cursor",
q=new core.DomUtils,a,c=[],h,e,v=[],w=[],A=[],x=new core.EventNotifier([gui.UndoManager.signalUndoStackChanged,gui.UndoManager.signalUndoStateCreated,gui.UndoManager.signalUndoStateModified,gui.TrivialUndoManager.signalDocumentRootReplaced]),u=m||new gui.UndoStateRules,t=!1;this.subscribe=function(a,b){x.subscribe(a,b)};this.unsubscribe=function(a,b){x.unsubscribe(a,b)};this.hasUndoStates=function(){return 0<w.length};this.hasRedoStates=function(){return 0<A.length};this.setDocument=function(a){e=
a};this.purgeInitialState=function(){w.length=0;A.length=0;c.length=0;v.length=0;a=null;b()};this.setInitialState=n;this.initialize=function(){a||n()};this.setPlaybackFunction=function(a){h=a};this.onOperationExecuted=function(a){t||(u.isEditOperation(a)&&(v===c||0<A.length)||!u.isPartOfOperationSet(a,v)?(A.length=0,g(),v=[a],w.push(v),x.emit(gui.UndoManager.signalUndoStateCreated,{operations:v}),b()):(v.push(a),x.emit(gui.UndoManager.signalUndoStateModified,{operations:v})))};this.moveForward=function(a){for(var c=
0,d;a&&A.length;)d=A.pop(),w.push(d),k(d),a-=1,c+=1;c&&(v=w[w.length-1],b());return c};this.moveBackward=function(d){for(var f=0;d&&w.length;)A.push(w.pop()),d-=1,f+=1;f&&(e.setDocumentElement(a.cloneNode(!0)),x.emit(gui.TrivialUndoManager.signalDocumentRootReplaced,{}),e.getMemberIds().forEach(function(a){e.removeCursor(a)}),k(c),w.forEach(k),v=w[w.length-1]||c,b());return f}};gui.TrivialUndoManager.signalDocumentRootReplaced="documentRootReplaced";(function(){return gui.TrivialUndoManager})();
// Input 107
/*

 Copyright (C) 2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 This file is part of WebODF.

 WebODF is free software: you can redistribute it and/or modify it
 under the terms of the GNU Affero General Public License (GNU AGPL)
 as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.

 WebODF is distributed in the hope that it will be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Affero General Public License for more details.

 You should have received a copy of the GNU Affero General Public License
 along with WebODF.  If not, see <http://www.gnu.org/licenses/>.
 @licend

 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.OperationTransformMatrix=function(){function m(a){a.position+=a.length;a.length*=-1}function k(a){var b=0>a.length;b&&m(a);return b}function b(a,b){function d(f){a[f]===b&&e.push(f)}var e=[];a&&["style:parent-style-name","style:next-style-name"].forEach(d);return e}function g(a,b){function d(e){a[e]===b&&delete a[e]}a&&["style:parent-style-name","style:next-style-name"].forEach(d)}function p(a){var b={};Object.keys(a).forEach(function(d){b[d]="object"===typeof a[d]?p(a[d]):a[d]});return b}function l(a,
b,d,e){var f,g=!1,k=!1,l,m=[];e&&e.attributes&&(m=e.attributes.split(","));a&&(d||0<m.length)&&Object.keys(a).forEach(function(b){var c=a[b],e;"object"!==typeof c&&(d&&(e=d[b]),void 0!==e?(delete a[b],k=!0,e===c&&(delete d[b],g=!0)):-1!==m.indexOf(b)&&(delete a[b],k=!0))});if(b&&b.attributes&&(d||0<m.length)){l=b.attributes.split(",");for(e=0;e<l.length;e+=1)if(f=l[e],d&&void 0!==d[f]||m&&-1!==m.indexOf(f))l.splice(e,1),e-=1,k=!0;0<l.length?b.attributes=l.join(","):delete b.attributes}return{majorChanged:g,
minorChanged:k}}function d(a){for(var b in a)if(a.hasOwnProperty(b))return!0;return!1}function n(a){for(var b in a)if(a.hasOwnProperty(b)&&("attributes"!==b||0<a.attributes.length))return!0;return!1}function r(a,b,f,e,g){var k=a?a[g]:null,m=b?b[g]:null,p=f?f[g]:null,r=e?e[g]:null,q;q=l(k,m,p,r);k&&!d(k)&&delete a[g];m&&!n(m)&&delete b[g];p&&!d(p)&&delete f[g];r&&!n(r)&&delete e[g];return q}function f(a,b){return{opSpecsA:[a],opSpecsB:[b]}}var q;q={AddCursor:{AddCursor:f,AddMember:f,AddStyle:f,ApplyDirectStyling:f,
InsertText:f,MoveCursor:f,RemoveCursor:f,RemoveMember:f,RemoveStyle:f,RemoveText:f,SetParagraphStyle:f,SplitParagraph:f,UpdateMember:f,UpdateMetadata:f,UpdateParagraphStyle:f},AddMember:{AddStyle:f,InsertText:f,MoveCursor:f,RemoveCursor:f,RemoveStyle:f,RemoveText:f,SetParagraphStyle:f,SplitParagraph:f,UpdateMetadata:f,UpdateParagraphStyle:f},AddStyle:{AddStyle:f,ApplyDirectStyling:f,InsertText:f,MoveCursor:f,RemoveCursor:f,RemoveMember:f,RemoveStyle:function(a,c){var d,e=[a],f=[c];a.styleFamily===
c.styleFamily&&(d=b(a.setProperties,c.styleName),0<d.length&&(d={optype:"UpdateParagraphStyle",memberid:c.memberid,timestamp:c.timestamp,styleName:a.styleName,removedProperties:{attributes:d.join(",")}},f.unshift(d)),g(a.setProperties,c.styleName));return{opSpecsA:e,opSpecsB:f}},RemoveText:f,SetParagraphStyle:f,SplitParagraph:f,UpdateMember:f,UpdateMetadata:f,UpdateParagraphStyle:f},ApplyDirectStyling:{ApplyDirectStyling:function(a,b,f){var e,g,k,l,m,n,q,s;l=[a];k=[b];if(!(a.position+a.length<=b.position||
a.position>=b.position+b.length)){e=f?a:b;g=f?b:a;if(a.position!==b.position||a.length!==b.length)n=p(e),q=p(g);b=r(g.setProperties,null,e.setProperties,null,"style:text-properties");if(b.majorChanged||b.minorChanged)k=[],a=[],l=e.position+e.length,m=g.position+g.length,g.position<e.position?b.minorChanged&&(s=p(q),s.length=e.position-g.position,a.push(s),g.position=e.position,g.length=m-g.position):e.position<g.position&&b.majorChanged&&(s=p(n),s.length=g.position-e.position,k.push(s),e.position=
g.position,e.length=l-e.position),m>l?b.minorChanged&&(n=q,n.position=l,n.length=m-l,a.push(n),g.length=l-g.position):l>m&&b.majorChanged&&(n.position=m,n.length=l-m,k.push(n),e.length=m-e.position),e.setProperties&&d(e.setProperties)&&k.push(e),g.setProperties&&d(g.setProperties)&&a.push(g),f?(l=k,k=a):l=a}return{opSpecsA:l,opSpecsB:k}},InsertText:function(a,b){b.position<=a.position?a.position+=b.text.length:b.position<=a.position+a.length&&(a.length+=b.text.length);return{opSpecsA:[a],opSpecsB:[b]}},
MoveCursor:f,RemoveCursor:f,RemoveStyle:f,RemoveText:function(a,b){var d=a.position+a.length,e=b.position+b.length,f=[a],g=[b];e<=a.position?a.position-=b.length:b.position<d&&(a.position<b.position?a.length=e<d?a.length-b.length:b.position-a.position:(a.position=b.position,e<d?a.length=d-e:f=[]));return{opSpecsA:f,opSpecsB:g}},SetParagraphStyle:f,SplitParagraph:function(a,b){b.position<a.position?a.position+=1:b.position<a.position+a.length&&(a.length+=1);return{opSpecsA:[a],opSpecsB:[b]}},UpdateMetadata:f,
UpdateParagraphStyle:f},InsertText:{InsertText:function(a,b,d){a.position<b.position?b.position+=a.text.length:a.position>b.position?a.position+=b.text.length:d?b.position+=a.text.length:a.position+=b.text.length;return{opSpecsA:[a],opSpecsB:[b]}},MoveCursor:function(a,b){var d=k(b);a.position<b.position?b.position+=a.text.length:a.position<b.position+b.length&&(b.length+=a.text.length);d&&m(b);return{opSpecsA:[a],opSpecsB:[b]}},RemoveCursor:f,RemoveMember:f,RemoveStyle:f,RemoveText:function(a,b){var d;
d=b.position+b.length;var e=[a],f=[b];d<=a.position?a.position-=b.length:a.position<=b.position?b.position+=a.text.length:(b.length=a.position-b.position,d={optype:"RemoveText",memberid:b.memberid,timestamp:b.timestamp,position:a.position+a.text.length,length:d-a.position},f.unshift(d),a.position=b.position);return{opSpecsA:e,opSpecsB:f}},SplitParagraph:function(a,b,d){if(a.position<b.position)b.position+=a.text.length;else if(a.position>b.position)a.position+=1;else return d?b.position+=a.text.length:
a.position+=1,null;return{opSpecsA:[a],opSpecsB:[b]}},UpdateMember:f,UpdateMetadata:f,UpdateParagraphStyle:f},MoveCursor:{MoveCursor:f,RemoveCursor:function(a,b){return{opSpecsA:a.memberid===b.memberid?[]:[a],opSpecsB:[b]}},RemoveMember:f,RemoveStyle:f,RemoveText:function(a,b){var d=k(a),e=a.position+a.length,f=b.position+b.length;f<=a.position?a.position-=b.length:b.position<e&&(a.position<b.position?a.length=f<e?a.length-b.length:b.position-a.position:(a.position=b.position,a.length=f<e?e-f:0));
d&&m(a);return{opSpecsA:[a],opSpecsB:[b]}},SetParagraphStyle:f,SplitParagraph:function(a,b){var d=k(a);b.position<a.position?a.position+=1:b.position<a.position+a.length&&(a.length+=1);d&&m(a);return{opSpecsA:[a],opSpecsB:[b]}},UpdateMember:f,UpdateMetadata:f,UpdateParagraphStyle:f},RemoveCursor:{RemoveCursor:function(a,b){var d=a.memberid===b.memberid;return{opSpecsA:d?[]:[a],opSpecsB:d?[]:[b]}},RemoveMember:f,RemoveStyle:f,RemoveText:f,SetParagraphStyle:f,SplitParagraph:f,UpdateMember:f,UpdateMetadata:f,
UpdateParagraphStyle:f},RemoveMember:{RemoveStyle:f,RemoveText:f,SetParagraphStyle:f,SplitParagraph:f,UpdateMetadata:f,UpdateParagraphStyle:f},RemoveStyle:{RemoveStyle:function(a,b){var d=a.styleName===b.styleName&&a.styleFamily===b.styleFamily;return{opSpecsA:d?[]:[a],opSpecsB:d?[]:[b]}},RemoveText:f,SetParagraphStyle:function(a,b){var d,e=[a],f=[b];"paragraph"===a.styleFamily&&a.styleName===b.styleName&&(d={optype:"SetParagraphStyle",memberid:a.memberid,timestamp:a.timestamp,position:b.position,
styleName:""},e.unshift(d),b.styleName="");return{opSpecsA:e,opSpecsB:f}},SplitParagraph:f,UpdateMember:f,UpdateMetadata:f,UpdateParagraphStyle:function(a,c){var d,e=[a],f=[c];"paragraph"===a.styleFamily&&(d=b(c.setProperties,a.styleName),0<d.length&&(d={optype:"UpdateParagraphStyle",memberid:a.memberid,timestamp:a.timestamp,styleName:c.styleName,removedProperties:{attributes:d.join(",")}},e.unshift(d)),a.styleName===c.styleName?f=[]:g(c.setProperties,a.styleName));return{opSpecsA:e,opSpecsB:f}}},
RemoveText:{RemoveText:function(a,b){var d=a.position+a.length,e=b.position+b.length,f=[a],g=[b];e<=a.position?a.position-=b.length:d<=b.position?b.position-=a.length:b.position<d&&(a.position<b.position?(a.length=e<d?a.length-b.length:b.position-a.position,d<e?(b.position=a.position,b.length=e-d):g=[]):(d<e?b.length-=a.length:b.position<a.position?b.length=a.position-b.position:g=[],e<d?(a.position=b.position,a.length=d-e):f=[]));return{opSpecsA:f,opSpecsB:g}},SplitParagraph:function(a,b){var d=
a.position+a.length,e=[a],f=[b];b.position<=a.position?a.position+=1:b.position<d&&(a.length=b.position-a.position,d={optype:"RemoveText",memberid:a.memberid,timestamp:a.timestamp,position:b.position+1,length:d-b.position},e.unshift(d));a.position+a.length<=b.position?b.position-=a.length:a.position<b.position&&(b.position=a.position);return{opSpecsA:e,opSpecsB:f}},UpdateMember:f,UpdateMetadata:f,UpdateParagraphStyle:f},SetParagraphStyle:{UpdateMember:f,UpdateMetadata:f,UpdateParagraphStyle:f},SplitParagraph:{SplitParagraph:function(a,
b,d){a.position<b.position?b.position+=1:a.position>b.position?a.position+=1:a.position===b.position&&(d?b.position+=1:a.position+=1);return{opSpecsA:[a],opSpecsB:[b]}},UpdateMember:f,UpdateMetadata:f,UpdateParagraphStyle:f},UpdateMember:{UpdateMetadata:f,UpdateParagraphStyle:f},UpdateMetadata:{UpdateMetadata:function(a,b,f){var e,g=[a],k=[b];e=f?a:b;a=f?b:a;l(a.setProperties||null,a.removedProperties||null,e.setProperties||null,e.removedProperties||null);e.setProperties&&d(e.setProperties)||e.removedProperties&&
n(e.removedProperties)||(f?g=[]:k=[]);a.setProperties&&d(a.setProperties)||a.removedProperties&&n(a.removedProperties)||(f?k=[]:g=[]);return{opSpecsA:g,opSpecsB:k}},UpdateParagraphStyle:f},UpdateParagraphStyle:{UpdateParagraphStyle:function(a,b,f){var e,g=[a],k=[b];a.styleName===b.styleName&&(e=f?a:b,a=f?b:a,r(a.setProperties,a.removedProperties,e.setProperties,e.removedProperties,"style:paragraph-properties"),r(a.setProperties,a.removedProperties,e.setProperties,e.removedProperties,"style:text-properties"),
l(a.setProperties||null,a.removedProperties||null,e.setProperties||null,e.removedProperties||null),e.setProperties&&d(e.setProperties)||e.removedProperties&&n(e.removedProperties)||(f?g=[]:k=[]),a.setProperties&&d(a.setProperties)||a.removedProperties&&n(a.removedProperties)||(f?k=[]:g=[]));return{opSpecsA:g,opSpecsB:k}}}};this.passUnchanged=f;this.extendTransformations=function(a){Object.keys(a).forEach(function(b){var d=a[b],e,f=q.hasOwnProperty(b);runtime.log((f?"Extending":"Adding")+" map for optypeA: "+
b);f||(q[b]={});e=q[b];Object.keys(d).forEach(function(a){var f=e.hasOwnProperty(a);runtime.assert(b<=a,"Wrong order:"+b+", "+a);runtime.log("  "+(f?"Overwriting":"Adding")+" entry for optypeB: "+a);e[a]=d[a]})})};this.transformOpspecVsOpspec=function(a,b){var d=a.optype<=b.optype,e;runtime.log("Crosstransforming:");runtime.log(runtime.toJson(a));runtime.log(runtime.toJson(b));d||(e=a,a=b,b=e);(e=(e=q[a.optype])&&e[b.optype])?(e=e(a,b,!d),d||null===e||(e={opSpecsA:e.opSpecsB,opSpecsB:e.opSpecsA})):
e=null;runtime.log("result:");e?(runtime.log(runtime.toJson(e.opSpecsA)),runtime.log(runtime.toJson(e.opSpecsB))):runtime.log("null");return e}};
// Input 108
/*

 Copyright (C) 2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 This file is part of WebODF.

 WebODF is free software: you can redistribute it and/or modify it
 under the terms of the GNU Affero General Public License (GNU AGPL)
 as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.

 WebODF is distributed in the hope that it will be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Affero General Public License for more details.

 You should have received a copy of the GNU Affero General Public License
 along with WebODF.  If not, see <http://www.gnu.org/licenses/>.
 @licend

 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.OperationTransformer=function(){function m(g){var k=[];g.forEach(function(d){k.push(b.create(d))});return k}function k(b,l){for(var d,m,r=[],f=[];0<b.length&&l;){d=b.shift();d=g.transformOpspecVsOpspec(d,l);if(!d)return null;r=r.concat(d.opSpecsA);if(0===d.opSpecsB.length){r=r.concat(b);l=null;break}for(;1<d.opSpecsB.length;){m=k(b,d.opSpecsB.shift());if(!m)return null;f=f.concat(m.opSpecsB);b=m.opSpecsA}l=d.opSpecsB.pop()}l&&f.push(l);return{opSpecsA:r,opSpecsB:f}}var b,g=new ops.OperationTransformMatrix;
this.setOperationFactory=function(g){b=g};this.getOperationTransformMatrix=function(){return g};this.transform=function(b,g){for(var d,n=[];0<g.length;){d=k(b,g.shift());if(!d)return null;b=d.opSpecsA;n=n.concat(d.opSpecsB)}return{opsA:m(b),opsB:m(n)}}};
// Input 109
/*

 Copyright (C) 2013 KO GmbH <copyright@kogmbh.com>

 @licstart
 The JavaScript code in this page is free software: you can redistribute it
 and/or modify it under the terms of the GNU Affero General Public License
 (GNU AGPL) as published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.  The code is distributed
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this code.  If not, see <http://www.gnu.org/licenses/>.

 As additional permission under GNU AGPL version 3 section 7, you
 may distribute non-source (e.g., minimized or compacted) forms of
 that code without the copy of the GNU GPL normally required by
 section 4, provided you include this license notice and a URL
 through which recipients can access the Corresponding Source.

 As a special exception to the AGPL, any HTML file which merely makes function
 calls to this code, and for that purpose includes it by reference shall be
 deemed a separate work for copyright law purposes. In addition, the copyright
 holders of this code give you permission to combine this code with free
 software libraries that are released under the GNU LGPL. You may copy and
 distribute such a system following the terms of the GNU AGPL for this code
 and the LGPL for the libraries. If you modify this code, you may extend this
 exception to your version of the code, but you are not obligated to do so.
 If you do not wish to do so, delete this exception statement from your
 version.

 This license applies to this entire compilation.
 @licend
 @source: http://www.webodf.org/
 @source: https://github.com/kogmbh/WebODF/
*/
ops.Server=function(){};ops.Server.prototype.connect=function(m,k){};ops.Server.prototype.networkStatus=function(){};ops.Server.prototype.login=function(m,k,b,g){};ops.Server.prototype.joinSession=function(m,k,b,g){};ops.Server.prototype.leaveSession=function(m,k,b,g){};ops.Server.prototype.getGenesisUrl=function(m){};
// Input 110
var webodf_css="@namespace draw url(urn:oasis:names:tc:opendocument:xmlns:drawing:1.0);\n@namespace fo url(urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0);\n@namespace office url(urn:oasis:names:tc:opendocument:xmlns:office:1.0);\n@namespace presentation url(urn:oasis:names:tc:opendocument:xmlns:presentation:1.0);\n@namespace style url(urn:oasis:names:tc:opendocument:xmlns:style:1.0);\n@namespace svg url(urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0);\n@namespace table url(urn:oasis:names:tc:opendocument:xmlns:table:1.0);\n@namespace text url(urn:oasis:names:tc:opendocument:xmlns:text:1.0);\n@namespace webodfhelper url(urn:webodf:names:helper);\n@namespace cursor url(urn:webodf:names:cursor);\n@namespace editinfo url(urn:webodf:names:editinfo);\n@namespace annotation url(urn:webodf:names:annotation);\n@namespace dc url(http://purl.org/dc/elements/1.1/);\n@namespace svgns url(http://www.w3.org/2000/svg);\n\noffice|document > *, office|document-content > * {\n  display: none;\n}\noffice|body, office|document {\n  display: inline-block;\n  position: relative;\n}\n\ntext|p, text|h {\n  display: block;\n  padding: 0;\n  margin: 0;\n  line-height: normal;\n  position: relative;\n  min-height: 1.3em; /* prevent empty paragraphs and headings from collapsing if they are empty */\n}\n*[webodfhelper|containsparagraphanchor] {\n  position: relative;\n}\ntext|s {\n    white-space: pre;\n}\ntext|tab {\n  display: inline;\n  white-space: pre;\n}\ntext|tracked-changes {\n  /*Consumers that do not support change tracking, should ignore changes.*/\n  display: none;\n}\noffice|binary-data {\n  display: none;\n}\noffice|text {\n  display: block;\n  text-align: left;\n  overflow: visible;\n  word-wrap: break-word;\n}\n\noffice|text::selection {\n  /** Let's not draw selection highlight that overflows into the office|text\n   * node when selecting content across several paragraphs\n   */\n  background: transparent;\n}\n\noffice|document *::selection {\n  background: transparent;\n}\noffice|document *::-moz-selection {\n  background: transparent;\n}\n\noffice|text * draw|text-box {\n/** only for text documents */\n    display: block;\n    border: 1px solid #d3d3d3;\n}\ndraw|frame {\n  /** make sure frames are above the main body. */\n  z-index: 1;\n}\noffice|spreadsheet {\n  display: block;\n  border-collapse: collapse;\n  empty-cells: show;\n  font-family: sans-serif;\n  font-size: 10pt;\n  text-align: left;\n  page-break-inside: avoid;\n  overflow: hidden;\n}\noffice|presentation {\n  display: inline-block;\n  text-align: left;\n}\n#shadowContent {\n  display: inline-block;\n  text-align: left;\n}\ndraw|page {\n  display: block;\n  position: relative;\n  overflow: hidden;\n}\npresentation|notes, presentation|footer-decl, presentation|date-time-decl {\n    display: none;\n}\n@media print {\n  draw|page {\n    border: 1pt solid black;\n    page-break-inside: avoid;\n  }\n  presentation|notes {\n    /*TODO*/\n  }\n}\noffice|spreadsheet text|p {\n  border: 0px;\n  padding: 1px;\n  margin: 0px;\n}\noffice|spreadsheet table|table {\n  margin: 3px;\n}\noffice|spreadsheet table|table:after {\n  /* show sheet name the end of the sheet */\n  /*content: attr(table|name);*/ /* gives parsing error in opera */\n}\noffice|spreadsheet table|table-row {\n  counter-increment: row;\n}\noffice|spreadsheet table|table-row:before {\n  width: 3em;\n  background: #cccccc;\n  border: 1px solid black;\n  text-align: center;\n  content: counter(row);\n  display: table-cell;\n}\noffice|spreadsheet table|table-cell {\n  border: 1px solid #cccccc;\n}\ntable|table {\n  display: table;\n}\ndraw|frame table|table {\n  width: 100%;\n  height: 100%;\n  background: white;\n}\ntable|table-header-rows {\n  display: table-header-group;\n}\ntable|table-row {\n  display: table-row;\n}\ntable|table-column {\n  display: table-column;\n}\ntable|table-cell {\n  width: 0.889in;\n  display: table-cell;\n  word-break: break-all; /* prevent long words from extending out the table cell */\n}\ndraw|frame {\n  display: block;\n}\ndraw|image {\n  display: block;\n  width: 100%;\n  height: 100%;\n  top: 0px;\n  left: 0px;\n  background-repeat: no-repeat;\n  background-size: 100% 100%;\n  -moz-background-size: 100% 100%;\n}\n/* only show the first image in frame */\ndraw|frame > draw|image:nth-of-type(n+2) {\n  display: none;\n}\ntext|list:before {\n    display: none;\n    content:\"\";\n}\ntext|list {\n    counter-reset: list;\n}\ntext|list-item {\n    display: block;\n}\ntext|number {\n    display:none;\n}\n\ntext|a {\n    color: blue;\n    text-decoration: underline;\n    cursor: pointer;\n}\n.webodf-inactiveLinks text|a {\n    cursor: text;\n}\ntext|note-citation {\n    vertical-align: super;\n    font-size: smaller;\n}\ntext|note-body {\n    display: none;\n}\ntext|note:hover text|note-citation {\n    background: #dddddd;\n}\ntext|note:hover text|note-body {\n    display: block;\n    left:1em;\n    max-width: 80%;\n    position: absolute;\n    background: #ffffaa;\n}\nsvg|title, svg|desc {\n    display: none;\n}\nvideo {\n    width: 100%;\n    height: 100%\n}\n\n/* below set up the cursor */\ncursor|cursor {\n    display: inline;\n    width: 0;\n    height: 1em;\n    /* making the position relative enables the avatar to use\n       the cursor as reference for its absolute position */\n    position: relative;\n    z-index: 1;\n    pointer-events: none;\n}\n\ncursor|cursor > .caret {\n    /* IMPORTANT: when changing these values ensure DEFAULT_CARET_TOP and DEFAULT_CARET_HEIGHT\n        in Caret.js remain in sync */\n    display: inline;\n    position: absolute;\n    top: 5%; /* push down the caret; 0px can do the job, 5% looks better, 10% is a bit over */\n    height: 1em;\n    border-left: 2px solid black;\n    outline: none;\n}\n\ncursor|cursor > .handle {\n    padding: 3px;\n    box-shadow: 0px 0px 5px rgba(50, 50, 50, 0.75);\n    border: none !important;\n    border-radius: 5px;\n    opacity: 0.3;\n}\n\ncursor|cursor > .handle > img {\n    border-radius: 5px;\n}\n\ncursor|cursor > .handle.active {\n    opacity: 0.8;\n}\n\ncursor|cursor > .handle:after {\n    content: ' ';\n    position: absolute;\n    width: 0px;\n    height: 0px;\n    border-style: solid;\n    border-width: 8.7px 5px 0 5px;\n    border-color: black transparent transparent transparent;\n\n    top: 100%;\n    left: 43%;\n}\n\n/** Input Method Editor input pane & behaviours */\n/* not within a cursor */\n#eventTrap {\n    height: auto;\n    display: block;\n    position: absolute;\n    width: 1px;\n    outline: none;\n    opacity: 0;\n    color: rgba(255, 255, 255, 0); /* hide the blinking caret by setting the colour to fully transparent */\n    overflow: hidden; /* The overflow visibility is used to hide and show characters being entered */\n    pointer-events: none;\n}\n\n/* within a cursor */\ncursor|cursor > #composer {\n    text-decoration: underline;\n}\n\ncursor|cursor[cursor|composing=\"true\"] > #composer {\n    display: inline-block;\n    height: auto;\n    width: auto;\n}\n\ncursor|cursor[cursor|composing=\"true\"] {\n    display: inline-block;\n    width: auto;\n    height: inherit;\n}\n\ncursor|cursor[cursor|composing=\"true\"] > .caret {\n    /* during composition, the caret should be pushed along by the composition text, inline with the text */\n    position: static;\n    /* as it is now part of an inline-block, it will no longer need correct to top or height values to align properly */\n    height: auto !important;\n    top: auto !important;\n}\n\neditinfo|editinfo {\n    /* Empty or invisible display:inline elements respond very badly to mouse selection.\n       Inline blocks are much more reliably selectable in Chrome & friends */\n    display: inline-block;\n}\n\n.editInfoMarker {\n    position: absolute;\n    width: 10px;\n    height: 100%;\n    left: -20px;\n    opacity: 0.8;\n    top: 0;\n    border-radius: 5px;\n    background-color: transparent;\n    box-shadow: 0px 0px 5px rgba(50, 50, 50, 0.75);\n}\n.editInfoMarker:hover {\n    box-shadow: 0px 0px 8px rgba(0, 0, 0, 1);\n}\n\n.editInfoHandle {\n    position: absolute;\n    background-color: black;\n    padding: 5px;\n    border-radius: 5px;\n    opacity: 0.8;\n    box-shadow: 0px 0px 5px rgba(50, 50, 50, 0.75);\n    bottom: 100%;\n    margin-bottom: 10px;\n    z-index: 3;\n    left: -25px;\n}\n.editInfoHandle:after {\n    content: ' ';\n    position: absolute;\n    width: 0px;\n    height: 0px;\n    border-style: solid;\n    border-width: 8.7px 5px 0 5px;\n    border-color: black transparent transparent transparent;\n\n    top: 100%;\n    left: 5px;\n}\n.editInfo {\n    font-family: sans-serif;\n    font-weight: normal;\n    font-style: normal;\n    text-decoration: none;\n    color: white;\n    width: 100%;\n    height: 12pt;\n}\n.editInfoColor {\n    float: left;\n    width: 10pt;\n    height: 10pt;\n    border: 1px solid white;\n}\n.editInfoAuthor {\n    float: left;\n    margin-left: 5pt;\n    font-size: 10pt;\n    text-align: left;\n    height: 12pt;\n    line-height: 12pt;\n}\n.editInfoTime {\n    float: right;\n    margin-left: 30pt;\n    font-size: 8pt;\n    font-style: italic;\n    color: yellow;\n    height: 12pt;\n    line-height: 12pt;\n}\n\n.annotationWrapper {\n    display: inline;\n    position: relative;\n}\n\n.annotationRemoveButton:before {\n    content: '\u00d7';\n    color: white;\n    padding: 5px;\n    line-height: 1em;\n}\n\n.annotationRemoveButton {\n    width: 20px;\n    height: 20px;\n    border-radius: 10px;\n    background-color: black;\n    box-shadow: 0px 0px 5px rgba(50, 50, 50, 0.75);\n    position: absolute;\n    top: -10px;\n    left: -10px;\n    z-index: 3;\n    text-align: center;\n    font-family: sans-serif;\n    font-style: normal;\n    font-weight: normal;\n    text-decoration: none;\n    font-size: 15px;\n}\n.annotationRemoveButton:hover {\n    cursor: pointer;\n    box-shadow: 0px 0px 5px rgba(0, 0, 0, 1);\n}\n\n.annotationNote {\n    width: 4cm;\n    position: absolute;\n    display: inline;\n    z-index: 10;\n}\n.annotationNote > office|annotation {\n    display: block;\n    text-align: left;\n}\n\n.annotationConnector {\n    position: absolute;\n    display: inline;\n    z-index: 2;\n    border-top: 1px dashed brown;\n}\n.annotationConnector.angular {\n    -moz-transform-origin: left top;\n    -webkit-transform-origin: left top;\n    -ms-transform-origin: left top;\n    transform-origin: left top;\n}\n.annotationConnector.horizontal {\n    left: 0;\n}\n.annotationConnector.horizontal:before {\n    content: '';\n    display: inline;\n    position: absolute;\n    width: 0px;\n    height: 0px;\n    border-style: solid;\n    border-width: 8.7px 5px 0 5px;\n    border-color: brown transparent transparent transparent;\n    top: -1px;\n    left: -5px;\n}\n\noffice|annotation {\n    width: 100%;\n    height: 100%;\n    display: none;\n    background: rgb(198, 238, 184);\n    background: -moz-linear-gradient(90deg, rgb(198, 238, 184) 30%, rgb(180, 196, 159) 100%);\n    background: -webkit-linear-gradient(90deg, rgb(198, 238, 184) 30%, rgb(180, 196, 159) 100%);\n    background: -o-linear-gradient(90deg, rgb(198, 238, 184) 30%, rgb(180, 196, 159) 100%);\n    background: -ms-linear-gradient(90deg, rgb(198, 238, 184) 30%, rgb(180, 196, 159) 100%);\n    background: linear-gradient(180deg, rgb(198, 238, 184) 30%, rgb(180, 196, 159) 100%);\n    box-shadow: 0 3px 4px -3px #ccc;\n}\n\noffice|annotation > dc|creator {\n    display: block;\n    font-size: 10pt;\n    font-weight: normal;\n    font-style: normal;\n    font-family: sans-serif;\n    color: white;\n    background-color: brown;\n    padding: 4px;\n}\noffice|annotation > dc|date {\n    display: block;\n    font-size: 10pt;\n    font-weight: normal;\n    font-style: normal;\n    font-family: sans-serif;\n    border: 4px solid transparent;\n    color: black;\n}\noffice|annotation > text|list {\n    display: block;\n    padding: 5px;\n}\n\n/* This is very temporary CSS. This must go once\n * we start bundling webodf-default ODF styles for annotations.\n */\noffice|annotation text|p {\n    font-size: 10pt;\n    color: black;\n    font-weight: normal;\n    font-style: normal;\n    text-decoration: none;\n    font-family: sans-serif;\n}\n\ndc|*::selection {\n    background: transparent;\n}\ndc|*::-moz-selection {\n    background: transparent;\n}\n\n#annotationsPane {\n    background-color: #EAEAEA;\n    width: 4cm;\n    height: 100%;\n    display: none;\n    position: absolute;\n    outline: 1px solid #ccc;\n}\n\n.webodf-annotationHighlight {\n    background-color: yellow;\n    position: relative;\n}\n\n.webodf-selectionOverlay {\n    position: absolute;\n    pointer-events: none;\n    top: 0;\n    left: 0;\n    top: 0;\n    left: 0;\n    width: 100%;\n    height: 100%;\n    z-index: 15;\n}\n.webodf-selectionOverlay > polygon {\n    fill-opacity: 0.3;\n    stroke-opacity: 0.8;\n    stroke-width: 1;\n    fill-rule: evenodd;\n}\n\n.webodf-selectionOverlay > .webodf-draggable {\n    fill-opacity: 0.8;\n    stroke-opacity: 0;\n    stroke-width: 8;\n    pointer-events: all;\n    display: none;\n\n    -moz-transform-origin: center center;\n    -webkit-transform-origin: center center;\n    -ms-transform-origin: center center;\n    transform-origin: center center;\n}\n\n#imageSelector {\n    display: none;\n    position: absolute;\n    border-style: solid;\n    border-color: black;\n}\n\n#imageSelector > div {\n    width: 5px;\n    height: 5px;\n    display: block;\n    position: absolute;\n    border: 1px solid black;\n    background-color: #ffffff;\n}\n\n#imageSelector > .topLeft {\n    top: -4px;\n    left: -4px;\n}\n\n#imageSelector > .topRight {\n    top: -4px;\n    right: -4px;\n}\n\n#imageSelector > .bottomRight {\n    right: -4px;\n    bottom: -4px;\n}\n\n#imageSelector > .bottomLeft {\n    bottom: -4px;\n    left: -4px;\n}\n\n#imageSelector > .topMiddle {\n    top: -4px;\n    left: 50%;\n    margin-left: -2.5px; /* half of the width defined in #imageSelector > div */\n}\n\n#imageSelector > .rightMiddle {\n    top: 50%;\n    right: -4px;\n    margin-top: -2.5px; /* half of the height defined in #imageSelector > div */\n}\n\n#imageSelector > .bottomMiddle {\n    bottom: -4px;\n    left: 50%;\n    margin-left: -2.5px; /* half of the width defined in #imageSelector > div */\n}\n\n#imageSelector > .leftMiddle {\n    top: 50%;\n    left: -4px;\n    margin-top: -2.5px; /* half of the height defined in #imageSelector > div */\n}\n\ndiv.webodf-customScrollbars::-webkit-scrollbar\n{\n    width: 8px;\n    height: 8px;\n    background-color: transparent;\n}\n\ndiv.webodf-customScrollbars::-webkit-scrollbar-track\n{\n    background-color: transparent;\n}\n\ndiv.webodf-customScrollbars::-webkit-scrollbar-thumb\n{\n    background-color: #444;\n    border-radius: 4px;\n}\n";

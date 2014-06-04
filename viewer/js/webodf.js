// Input 0
var webodf_version="0.4.2-2400-gba50413";
// Input 1
function Runtime(){}Runtime.prototype.getVariable=function(h){};Runtime.prototype.toJson=function(h){};Runtime.prototype.fromJson=function(h){};Runtime.prototype.byteArrayFromString=function(h,g){};Runtime.prototype.byteArrayToString=function(h,g){};Runtime.prototype.read=function(h,g,b,d){};Runtime.prototype.readFile=function(h,g,b){};Runtime.prototype.readFileSync=function(h,g){};Runtime.prototype.loadXML=function(h,g){};Runtime.prototype.writeFile=function(h,g,b){};
Runtime.prototype.isFile=function(h,g){};Runtime.prototype.getFileSize=function(h,g){};Runtime.prototype.deleteFile=function(h,g){};Runtime.prototype.log=function(h,g){};Runtime.prototype.setTimeout=function(h,g){};Runtime.prototype.clearTimeout=function(h){};Runtime.prototype.libraryPaths=function(){};Runtime.prototype.currentDirectory=function(){};Runtime.prototype.setCurrentDirectory=function(h){};Runtime.prototype.type=function(){};Runtime.prototype.getDOMImplementation=function(){};
Runtime.prototype.parseXML=function(h){};Runtime.prototype.exit=function(h){};Runtime.prototype.getWindow=function(){};Runtime.prototype.requestAnimationFrame=function(h){};Runtime.prototype.cancelAnimationFrame=function(h){};Runtime.prototype.assert=function(h,g,b){};var IS_COMPILED_CODE=!0;
Runtime.byteArrayToString=function(h,g){function b(b){var d="",e,g=b.length;for(e=0;e<g;e+=1)d+=String.fromCharCode(b[e]&255);return d}function d(b){var d="",e,g=b.length,m=[],r,c,a,n;for(e=0;e<g;e+=1)r=b[e],128>r?m.push(r):(e+=1,c=b[e],194<=r&&224>r?m.push((r&31)<<6|c&63):(e+=1,a=b[e],224<=r&&240>r?m.push((r&15)<<12|(c&63)<<6|a&63):(e+=1,n=b[e],240<=r&&245>r&&(r=(r&7)<<18|(c&63)<<12|(a&63)<<6|n&63,r-=65536,m.push((r>>10)+55296,(r&1023)+56320))))),1E3<=m.length&&(d+=String.fromCharCode.apply(null,
m),m.length=0);return d+String.fromCharCode.apply(null,m)}var e;"utf8"===g?e=d(h):("binary"!==g&&this.log("Unsupported encoding: "+g),e=b(h));return e};Runtime.getVariable=function(h){try{return eval(h)}catch(g){}};Runtime.toJson=function(h){return JSON.stringify(h)};Runtime.fromJson=function(h){return JSON.parse(h)};Runtime.getFunctionName=function(h){return void 0===h.name?(h=/function\s+(\w+)/.exec(h))&&h[1]:h.name};
function BrowserRuntime(h){function g(b){var c=b.length,a,n,k=0;for(a=0;a<c;a+=1)n=b.charCodeAt(a),k+=1+(128<n)+(2048<n),55040<n&&57344>n&&(k+=1,a+=1);return k}function b(b,c,a){var n=b.length,k,d;c=new Uint8Array(new ArrayBuffer(c));a?(c[0]=239,c[1]=187,c[2]=191,d=3):d=0;for(a=0;a<n;a+=1)k=b.charCodeAt(a),128>k?(c[d]=k,d+=1):2048>k?(c[d]=192|k>>>6,c[d+1]=128|k&63,d+=2):55040>=k||57344<=k?(c[d]=224|k>>>12&15,c[d+1]=128|k>>>6&63,c[d+2]=128|k&63,d+=3):(a+=1,k=(k-55296<<10|b.charCodeAt(a)-56320)+65536,
c[d]=240|k>>>18&7,c[d+1]=128|k>>>12&63,c[d+2]=128|k>>>6&63,c[d+3]=128|k&63,d+=4);return c}function d(b){var c=b.length,a=new Uint8Array(new ArrayBuffer(c)),n;for(n=0;n<c;n+=1)a[n]=b.charCodeAt(n)&255;return a}function e(b,c){var a,n,k;void 0!==c?k=b:c=b;h?(n=h.ownerDocument,k&&(a=n.createElement("span"),a.className=k,a.appendChild(n.createTextNode(k)),h.appendChild(a),h.appendChild(n.createTextNode(" "))),a=n.createElement("span"),0<c.length&&"<"===c[0]?a.innerHTML=c:a.appendChild(n.createTextNode(c)),
h.appendChild(a),h.appendChild(n.createElement("br"))):console&&console.log(c);"alert"===k&&alert(c)}function l(r,c,a){if(0!==a.status||a.responseText)if(200===a.status||0===a.status){if(a.response&&"string"!==typeof a.response)"binary"===c?(a=a.response,a=new Uint8Array(a)):a=String(a.response);else if("binary"===c)if(null!==a.responseBody&&"undefined"!==String(typeof VBArray)){a=(new VBArray(a.responseBody)).toArray();var n=a.length,k=new Uint8Array(new ArrayBuffer(n));for(c=0;c<n;c+=1)k[c]=a[c];
a=k}else{(c=a.getResponseHeader("Content-Length"))&&(c=parseInt(c,10));if(c&&c!==a.responseText.length)a:{var n=a.responseText,k=!1,e=g(n);if("number"===typeof c){if(c!==e&&c!==e+3){n=void 0;break a}k=e+3===c;e=c}n=b(n,e,k)}void 0===n&&(n=d(a.responseText));a=n}else a=a.responseText;m[r]=a;r={err:null,data:a}}else r={err:a.responseText||a.statusText,data:null};else r={err:"File "+r+" is empty.",data:null};return r}function f(b,c,a){var n=new XMLHttpRequest;n.open("GET",b,a);n.overrideMimeType&&("binary"!==
c?n.overrideMimeType("text/plain; charset="+c):n.overrideMimeType("text/plain; charset=x-user-defined"));return n}function p(b,c,a){function n(){var n;4===k.readyState&&(n=l(b,c,k),a(n.err,n.data))}if(m.hasOwnProperty(b))a(null,m[b]);else{var k=f(b,c,!0);k.onreadystatechange=n;try{k.send(null)}catch(d){a(d.message,null)}}}var q=this,m={};this.byteArrayFromString=function(r,c){var a;"utf8"===c?a=b(r,g(r),!1):("binary"!==c&&q.log("unknown encoding: "+c),a=d(r));return a};this.byteArrayToString=Runtime.byteArrayToString;
this.getVariable=Runtime.getVariable;this.fromJson=Runtime.fromJson;this.toJson=Runtime.toJson;this.readFile=p;this.read=function(b,c,a,n){p(b,"binary",function(k,b){var d=null;if(b){if("string"===typeof b)throw"This should not happen.";d=b.subarray(c,c+a)}n(k,d)})};this.readFileSync=function(b,c){var a=f(b,c,!1),n;try{a.send(null);n=l(b,c,a);if(n.err)throw n.err;if(null===n.data)throw"No data read from "+b+".";}catch(k){throw k;}return n.data};this.writeFile=function(b,c,a){m[b]=c;var n=new XMLHttpRequest,
k;n.open("PUT",b,!0);n.onreadystatechange=function(){4===n.readyState&&(0!==n.status||n.responseText?200<=n.status&&300>n.status||0===n.status?a(null):a("Status "+String(n.status)+": "+n.responseText||n.statusText):a("File "+b+" is empty."))};k=c.buffer&&!n.sendAsBinary?c.buffer:q.byteArrayToString(c,"binary");try{n.sendAsBinary?n.sendAsBinary(k):n.send(k)}catch(d){q.log("HUH? "+d+" "+c),a(d.message)}};this.deleteFile=function(b,c){delete m[b];var a=new XMLHttpRequest;a.open("DELETE",b,!0);a.onreadystatechange=
function(){4===a.readyState&&(200>a.status&&300<=a.status?c(a.responseText):c(null))};a.send(null)};this.loadXML=function(b,c){var a=new XMLHttpRequest;a.open("GET",b,!0);a.overrideMimeType&&a.overrideMimeType("text/xml");a.onreadystatechange=function(){4===a.readyState&&(0!==a.status||a.responseText?200===a.status||0===a.status?c(null,a.responseXML):c(a.responseText,null):c("File "+b+" is empty.",null))};try{a.send(null)}catch(n){c(n.message,null)}};this.isFile=function(b,c){q.getFileSize(b,function(a){c(-1!==
a)})};this.getFileSize=function(b,c){if(m.hasOwnProperty(b)&&"string"!==typeof m[b])c(m[b].length);else{var a=new XMLHttpRequest;a.open("HEAD",b,!0);a.onreadystatechange=function(){if(4===a.readyState){var n=a.getResponseHeader("Content-Length");n?c(parseInt(n,10)):p(b,"binary",function(a,n){a?c(-1):c(n.length)})}};a.send(null)}};this.log=e;this.assert=function(b,c,a){if(!b)throw e("alert","ASSERTION FAILED:\n"+c),a&&a(),c;};this.setTimeout=function(b,c){return setTimeout(function(){b()},c)};this.clearTimeout=
function(b){clearTimeout(b)};this.libraryPaths=function(){return["lib"]};this.setCurrentDirectory=function(){};this.currentDirectory=function(){return""};this.type=function(){return"BrowserRuntime"};this.getDOMImplementation=function(){return window.document.implementation};this.parseXML=function(b){return(new DOMParser).parseFromString(b,"text/xml")};this.exit=function(b){e("Calling exit with code "+String(b)+", but exit() is not implemented.")};this.getWindow=function(){return window};this.requestAnimationFrame=
function(b){var c=window.requestAnimationFrame||window.webkitRequestAnimationFrame||window.mozRequestAnimationFrame||window.msRequestAnimationFrame,a=0;if(c)c.bind(window),a=c(b);else return setTimeout(b,15);return a};this.cancelAnimationFrame=function(b){var c=window.cancelAnimationFrame||window.webkitCancelAnimationFrame||window.mozCancelAnimationFrame||window.msCancelAnimationFrame;c?(c.bind(window),c(b)):clearTimeout(b)}}
function NodeJSRuntime(){function h(b){var d=b.length,e,c=new Uint8Array(new ArrayBuffer(d));for(e=0;e<d;e+=1)c[e]=b[e];return c}function g(b,f,r){function c(a,c){if(a)return r(a,null);if(!c)return r("No data for "+b+".",null);if("string"===typeof c)return r(a,c);r(a,h(c))}b=e.resolve(l,b);"binary"!==f?d.readFile(b,f,c):d.readFile(b,null,c)}var b=this,d=require("fs"),e=require("path"),l="",f,p;this.byteArrayFromString=function(b,d){var e=new Buffer(b,d),c,a=e.length,n=new Uint8Array(new ArrayBuffer(a));
for(c=0;c<a;c+=1)n[c]=e[c];return n};this.byteArrayToString=Runtime.byteArrayToString;this.getVariable=Runtime.getVariable;this.fromJson=Runtime.fromJson;this.toJson=Runtime.toJson;this.readFile=g;this.loadXML=function(d,e){g(d,"utf-8",function(f,c){if(f)return e(f,null);if(!c)return e("No data for "+d+".",null);e(null,b.parseXML(c))})};this.writeFile=function(b,f,r){f=new Buffer(f);b=e.resolve(l,b);d.writeFile(b,f,"binary",function(c){r(c||null)})};this.deleteFile=function(b,f){b=e.resolve(l,b);
d.unlink(b,f)};this.read=function(b,f,r,c){b=e.resolve(l,b);d.open(b,"r+",666,function(a,n){if(a)c(a,null);else{var k=new Buffer(r);d.read(n,k,0,r,f,function(a){d.close(n);c(a,h(k))})}})};this.readFileSync=function(b,e){var f;f=d.readFileSync(b,"binary"===e?null:e);if(null===f)throw"File "+b+" could not be read.";"binary"===e&&(f=h(f));return f};this.isFile=function(b,f){b=e.resolve(l,b);d.stat(b,function(b,c){f(!b&&c.isFile())})};this.getFileSize=function(b,f){b=e.resolve(l,b);d.stat(b,function(b,
c){b?f(-1):f(c.size)})};this.log=function(b,d){var e;void 0!==d?e=b:d=b;"alert"===e&&process.stderr.write("\n!!!!! ALERT !!!!!\n");process.stderr.write(d+"\n");"alert"===e&&process.stderr.write("!!!!! ALERT !!!!!\n")};this.assert=function(b,d,e){b||(process.stderr.write("ASSERTION FAILED: "+d),e&&e())};this.setTimeout=function(b,d){return setTimeout(function(){b()},d)};this.clearTimeout=function(b){clearTimeout(b)};this.libraryPaths=function(){return[__dirname]};this.setCurrentDirectory=function(b){l=
b};this.currentDirectory=function(){return l};this.type=function(){return"NodeJSRuntime"};this.getDOMImplementation=function(){return p};this.parseXML=function(b){return f.parseFromString(b,"text/xml")};this.exit=process.exit;this.getWindow=function(){return null};this.requestAnimationFrame=function(b){return setTimeout(b,15)};this.cancelAnimationFrame=function(b){clearTimeout(b)};f=new (require("xmldom").DOMParser);p=b.parseXML("<a/>").implementation}
function RhinoRuntime(){function h(b,d){var e;void 0!==d?e=b:d=b;"alert"===e&&print("\n!!!!! ALERT !!!!!");print(d);"alert"===e&&print("!!!!! ALERT !!!!!")}var g=this,b={},d=b.javax.xml.parsers.DocumentBuilderFactory.newInstance(),e,l,f="";d.setValidating(!1);d.setNamespaceAware(!0);d.setExpandEntityReferences(!1);d.setSchema(null);l=b.org.xml.sax.EntityResolver({resolveEntity:function(d,e){var f=new b.java.io.FileReader(e);return new b.org.xml.sax.InputSource(f)}});e=d.newDocumentBuilder();e.setEntityResolver(l);
this.byteArrayFromString=function(b,d){var e,f=b.length,c=new Uint8Array(new ArrayBuffer(f));for(e=0;e<f;e+=1)c[e]=b.charCodeAt(e)&255;return c};this.byteArrayToString=Runtime.byteArrayToString;this.getVariable=Runtime.getVariable;this.fromJson=Runtime.fromJson;this.toJson=Runtime.toJson;this.loadXML=function(d,f){var g=new b.java.io.File(d),r=null;try{r=e.parse(g)}catch(c){return print(c),f(c,null)}f(null,r)};this.readFile=function(d,e,h){f&&(d=f+"/"+d);var r=new b.java.io.File(d),c="binary"===e?
"latin1":e;r.isFile()?((d=readFile(d,c))&&"binary"===e&&(d=g.byteArrayFromString(d,"binary")),h(null,d)):h(d+" is not a file.",null)};this.writeFile=function(d,e,g){f&&(d=f+"/"+d);d=new b.java.io.FileOutputStream(d);var r,c=e.length;for(r=0;r<c;r+=1)d.write(e[r]);d.close();g(null)};this.deleteFile=function(d,e){f&&(d=f+"/"+d);var g=new b.java.io.File(d),r=d+Math.random(),r=new b.java.io.File(r);g.rename(r)?(r.deleteOnExit(),e(null)):e("Could not delete "+d)};this.read=function(d,e,g,r){f&&(d=f+"/"+
d);var c;c=d;var a="binary";(new b.java.io.File(c)).isFile()?("binary"===a&&(a="latin1"),c=readFile(c,a)):c=null;c?r(null,this.byteArrayFromString(c.substring(e,e+g),"binary")):r("Cannot read "+d,null)};this.readFileSync=function(b,d){if(!d)return"";var e=readFile(b,d);if(null===e)throw"File could not be read.";return e};this.isFile=function(d,e){f&&(d=f+"/"+d);var g=new b.java.io.File(d);e(g.isFile())};this.getFileSize=function(d,e){f&&(d=f+"/"+d);var g=new b.java.io.File(d);e(g.length())};this.log=
h;this.assert=function(b,d,e){b||(h("alert","ASSERTION FAILED: "+d),e&&e())};this.setTimeout=function(b){b();return 0};this.clearTimeout=function(){};this.libraryPaths=function(){return["lib"]};this.setCurrentDirectory=function(b){f=b};this.currentDirectory=function(){return f};this.type=function(){return"RhinoRuntime"};this.getDOMImplementation=function(){return e.getDOMImplementation()};this.parseXML=function(d){d=new b.java.io.StringReader(d);d=new b.org.xml.sax.InputSource(d);return e.parse(d)};
this.exit=quit;this.getWindow=function(){return null};this.requestAnimationFrame=function(b){b();return 0};this.cancelAnimationFrame=function(){}}Runtime.create=function(){return"undefined"!==String(typeof window)?new BrowserRuntime(window.document.getElementById("logoutput")):"undefined"!==String(typeof require)?new NodeJSRuntime:new RhinoRuntime};var runtime=Runtime.create(),core={},gui={},xmldom={},odf={},ops={},webodf={};
(function(){webodf.Version="undefined"!==String(typeof webodf_version)?webodf_version:"From Source"})();
(function(){function h(b,d,e){var f=b+"/manifest.json",c,a;runtime.log("Loading manifest: "+f);try{c=runtime.readFileSync(f,"utf-8")}catch(n){if(e)runtime.log("No loadable manifest found.");else throw console.log(String(n)),n;return}e=JSON.parse(c);for(a in e)e.hasOwnProperty(a)&&(d[a]={dir:b,deps:e[a]})}function g(b,d,e){function f(k){if(!n[k]&&!e(k)){if(a[k])throw"Circular dependency detected for "+k+".";a[k]=!0;if(!d[k])throw"Missing dependency information for class "+k+".";var b=d[k],g=b.deps,
h,l=g.length;for(h=0;h<l;h+=1)f(g[h]);a[k]=!1;n[k]=!0;c.push(b.dir+"/"+k.replace(".","/")+".js")}}var c=[],a={},n={};b.forEach(f);return c}function b(b,d){return d=d+("\n//# sourceURL="+b)+("\n//@ sourceURL="+b)}function d(d){var e,f;for(e=0;e<d.length;e+=1)f=runtime.readFileSync(d[e],"utf-8"),f=b(d[e],f),eval(f)}function e(b){b=b.split(".");var d,e=f,g=b.length;for(d=0;d<g;d+=1){if(!e.hasOwnProperty(b[d]))return!1;e=e[b[d]]}return!0}var l,f={core:core,gui:gui,xmldom:xmldom,odf:odf,ops:ops};runtime.loadClasses=
function(b,f){if(IS_COMPILED_CODE||0===b.length)return f&&f();var m;if(!(m=l)){m=[];var r=runtime.libraryPaths(),c;runtime.currentDirectory()&&-1===r.indexOf(runtime.currentDirectory())&&h(runtime.currentDirectory(),m,!0);for(c=0;c<r.length;c+=1)h(r[c],m)}l=m;b=g(b,l,e);if(0===b.length)return f&&f();if("BrowserRuntime"===runtime.type()&&f){m=b;r=document.currentScript||document.documentElement.lastChild;c=document.createDocumentFragment();var a,n;for(n=0;n<m.length;n+=1)a=document.createElement("script"),
a.type="text/javascript",a.charset="utf-8",a.async=!1,a.setAttribute("src",m[n]),c.appendChild(a);f&&(a.onload=f);r.parentNode.insertBefore(c,r)}else d(b),f&&f()};runtime.loadClass=function(b,d){runtime.loadClasses([b],d)}})();(function(){var h=function(g){return g};runtime.getTranslator=function(){return h};runtime.setTranslator=function(g){h=g};runtime.tr=function(g){var b=h(g);return b&&"string"===String(typeof b)?b:g}})();
(function(h){function g(b){if(b.length){var d=b[0];runtime.readFile(d,"utf8",function(e,g){function f(){var b;(b=eval(q))&&runtime.exit(b)}var h="",h=d.lastIndexOf("/"),q=g,h=-1!==h?d.substring(0,h):".";runtime.setCurrentDirectory(h);e?(runtime.log(e),runtime.exit(1)):null===q?(runtime.log("No code found for "+d),runtime.exit(1)):f.apply(null,b)})}}h=h?Array.prototype.slice.call(h):[];"NodeJSRuntime"===runtime.type()?g(process.argv.slice(2)):"RhinoRuntime"===runtime.type()?g(h):g(h.slice(1))})("undefined"!==
String(typeof arguments)&&arguments);
// Input 2
(function(){core.Async=function(){return{forEach:function(h,g,b){function d(d){f!==l&&(d?(f=l,b(d)):(f+=1,f===l&&b(null)))}var e,l=h.length,f=0;for(e=0;e<l;e+=1)g(h[e],d)},destroyAll:function(h,g){function b(d,e){if(e)g(e);else if(d<h.length)h[d](function(e){b(d+1,e)});else g()}b(0,void 0)}}}()})();
// Input 3
function makeBase64(){function h(a){var c,b=a.length,k=new Uint8Array(new ArrayBuffer(b));for(c=0;c<b;c+=1)k[c]=a.charCodeAt(c)&255;return k}function g(a){var c,b="",k,n=a.length-2;for(k=0;k<n;k+=3)c=a[k]<<16|a[k+1]<<8|a[k+2],b+="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"[c>>>18],b+="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"[c>>>12&63],b+="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"[c>>>6&63],b+="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"[c&
63];k===n+1?(c=a[k]<<4,b+="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"[c>>>6],b+="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"[c&63],b+="=="):k===n&&(c=a[k]<<10|a[k+1]<<2,b+="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"[c>>>12],b+="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"[c>>>6&63],b+="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"[c&63],b+="=");return b}function b(a){a=a.replace(/[^A-Za-z0-9+\/]+/g,
"");var c=a.length,b=new Uint8Array(new ArrayBuffer(3*c)),n=a.length%4,d=0,e,f;for(e=0;e<c;e+=4)f=(k[a.charAt(e)]||0)<<18|(k[a.charAt(e+1)]||0)<<12|(k[a.charAt(e+2)]||0)<<6|(k[a.charAt(e+3)]||0),b[d]=f>>16,b[d+1]=f>>8&255,b[d+2]=f&255,d+=3;c=3*c-[0,0,2,1][n];return b.subarray(0,c)}function d(a){var c,b,k=a.length,n=0,d=new Uint8Array(new ArrayBuffer(3*k));for(c=0;c<k;c+=1)b=a[c],128>b?d[n++]=b:(2048>b?d[n++]=192|b>>>6:(d[n++]=224|b>>>12&15,d[n++]=128|b>>>6&63),d[n++]=128|b&63);return d.subarray(0,
n)}function e(a){var c,b,k,n,d=a.length,e=new Uint8Array(new ArrayBuffer(d)),f=0;for(c=0;c<d;c+=1)b=a[c],128>b?e[f++]=b:(c+=1,k=a[c],224>b?e[f++]=(b&31)<<6|k&63:(c+=1,n=a[c],e[f++]=(b&15)<<12|(k&63)<<6|n&63));return e.subarray(0,f)}function l(a){return g(h(a))}function f(a){return String.fromCharCode.apply(String,b(a))}function p(a){return e(h(a))}function q(a){a=e(a);for(var c="",b=0;b<a.length;)c+=String.fromCharCode.apply(String,a.subarray(b,b+45E3)),b+=45E3;return c}function m(a,c,b){var k,n,
d,e="";for(d=c;d<b;d+=1)c=a.charCodeAt(d)&255,128>c?e+=String.fromCharCode(c):(d+=1,k=a.charCodeAt(d)&255,224>c?e+=String.fromCharCode((c&31)<<6|k&63):(d+=1,n=a.charCodeAt(d)&255,e+=String.fromCharCode((c&15)<<12|(k&63)<<6|n&63)));return e}function r(a,c){function b(){var d=n+1E5;d>a.length&&(d=a.length);k+=m(a,n,d);n=d;d=n===a.length;c(k,d)&&!d&&runtime.setTimeout(b,0)}var k="",n=0;1E5>a.length?c(m(a,0,a.length),!0):("string"!==typeof a&&(a=a.slice()),b())}function c(a){return d(h(a))}function a(a){return String.fromCharCode.apply(String,
d(a))}function n(a){return String.fromCharCode.apply(String,d(h(a)))}var k=function(a){var c={},b,k;b=0;for(k=a.length;b<k;b+=1)c[a.charAt(b)]=b;return c}("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"),t,s,y=runtime.getWindow(),z,w;y&&y.btoa?(z=y.btoa,t=function(a){return z(n(a))}):(z=l,t=function(a){return g(c(a))});y&&y.atob?(w=y.atob,s=function(a){a=w(a);return m(a,0,a.length)}):(w=f,s=function(a){return q(b(a))});core.Base64=function(){this.convertByteArrayToBase64=this.convertUTF8ArrayToBase64=
g;this.convertBase64ToByteArray=this.convertBase64ToUTF8Array=b;this.convertUTF16ArrayToByteArray=this.convertUTF16ArrayToUTF8Array=d;this.convertByteArrayToUTF16Array=this.convertUTF8ArrayToUTF16Array=e;this.convertUTF8StringToBase64=l;this.convertBase64ToUTF8String=f;this.convertUTF8StringToUTF16Array=p;this.convertByteArrayToUTF16String=this.convertUTF8ArrayToUTF16String=q;this.convertUTF8StringToUTF16String=r;this.convertUTF16StringToByteArray=this.convertUTF16StringToUTF8Array=c;this.convertUTF16ArrayToUTF8String=
a;this.convertUTF16StringToUTF8String=n;this.convertUTF16StringToBase64=t;this.convertBase64ToUTF16String=s;this.fromBase64=f;this.toBase64=l;this.atob=w;this.btoa=z;this.utob=n;this.btou=r;this.encode=t;this.encodeURI=function(a){return t(a).replace(/[+\/]/g,function(a){return"+"===a?"-":"_"}).replace(/\\=+$/,"")};this.decode=function(a){return s(a.replace(/[\-_]/g,function(a){return"-"===a?"+":"/"}))};return this};return core.Base64}core.Base64=makeBase64();
// Input 4
core.ByteArray=function(h){this.pos=0;this.data=h;this.readUInt32LE=function(){this.pos+=4;var g=this.data,b=this.pos;return g[--b]<<24|g[--b]<<16|g[--b]<<8|g[--b]};this.readUInt16LE=function(){this.pos+=2;var g=this.data,b=this.pos;return g[--b]<<8|g[--b]}};
// Input 5
core.ByteArrayWriter=function(h){function g(b){b>e-d&&(e=Math.max(2*e,d+b),b=new Uint8Array(new ArrayBuffer(e)),b.set(l),l=b)}var b=this,d=0,e=1024,l=new Uint8Array(new ArrayBuffer(e));this.appendByteArrayWriter=function(d){b.appendByteArray(d.getByteArray())};this.appendByteArray=function(b){var e=b.length;g(e);l.set(b,d);d+=e};this.appendArray=function(b){var e=b.length;g(e);l.set(b,d);d+=e};this.appendUInt16LE=function(d){b.appendArray([d&255,d>>8&255])};this.appendUInt32LE=function(d){b.appendArray([d&
255,d>>8&255,d>>16&255,d>>24&255])};this.appendString=function(d){b.appendByteArray(runtime.byteArrayFromString(d,h))};this.getLength=function(){return d};this.getByteArray=function(){var b=new Uint8Array(new ArrayBuffer(d));b.set(l.subarray(0,d));return b}};
// Input 6
core.CSSUnits=function(){var h=this,g={"in":1,cm:2.54,mm:25.4,pt:72,pc:12,px:96};this.convert=function(b,d,e){return b*g[e]/g[d]};this.convertMeasure=function(b,d){var e,g;b&&d&&(e=parseFloat(b),g=b.replace(e.toString(),""),e=h.convert(e,g,d));return e};this.getUnits=function(b){return b.substr(b.length-2,b.length)}};
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
(function(){function h(){var d,e,g,f,h,q,m,r,c;void 0===b&&(e=(d=runtime.getWindow())&&d.document,q=e.documentElement,m=e.body,b={rangeBCRIgnoresElementBCR:!1,unscaledRangeClientRects:!1,elementBCRIgnoresBodyScroll:!1},e&&(f=e.createElement("div"),f.style.position="absolute",f.style.left="-99999px",f.style.transform="scale(2)",f.style["-webkit-transform"]="scale(2)",h=e.createElement("div"),f.appendChild(h),m.appendChild(f),d=e.createRange(),d.selectNode(h),b.rangeBCRIgnoresElementBCR=0===d.getClientRects().length,
h.appendChild(e.createTextNode("Rect transform test")),e=h.getBoundingClientRect(),g=d.getBoundingClientRect(),b.unscaledRangeClientRects=2<Math.abs(e.height-g.height),f.style.transform="",f.style["-webkit-transform"]="",e=q.style.overflow,g=m.style.overflow,r=m.style.height,c=m.scrollTop,q.style.overflow="visible",m.style.overflow="visible",m.style.height="200%",m.scrollTop=m.scrollHeight,b.elementBCRIgnoresBodyScroll=d.getBoundingClientRect().top!==h.getBoundingClientRect().top,m.scrollTop=c,m.style.height=
r,m.style.overflow=g,q.style.overflow=e,d.detach(),m.removeChild(f),d=Object.keys(b).map(function(a){return a+":"+String(b[a])}).join(", "),runtime.log("Detected browser quirks - "+d)));return b}function g(b,e,g){for(b=b?b.firstElementChild:null;b;){if(b.localName===g&&b.namespaceURI===e)return b;b=b.nextElementSibling}return null}var b;core.DomUtils=function(){function b(a,c){for(var k=0,d;a.parentNode!==c;)runtime.assert(null!==a.parentNode,"parent is null"),a=a.parentNode;for(d=c.firstChild;d!==
a;)k+=1,d=d.nextSibling;return k}function e(a,c){return 0>=a.compareBoundaryPoints(Range.START_TO_START,c)&&0<=a.compareBoundaryPoints(Range.END_TO_END,c)}function l(a,c){var b=null;a.nodeType===Node.TEXT_NODE&&(0===a.length?(a.parentNode.removeChild(a),c.nodeType===Node.TEXT_NODE&&(b=c)):(c.nodeType===Node.TEXT_NODE&&(a.appendData(c.data),c.parentNode.removeChild(c)),b=a));return b}function f(a){for(var c=a.parentNode;a.firstChild;)c.insertBefore(a.firstChild,a);c.removeChild(a);return c}function p(a,
c){for(var b=a.parentNode,d=a.firstChild,e;d;)e=d.nextSibling,p(d,c),d=e;b&&c(a)&&f(a);return b}function q(a,c){return a===c||Boolean(a.compareDocumentPosition(c)&Node.DOCUMENT_POSITION_CONTAINED_BY)}function m(a,c){return h().unscaledRangeClientRects?a:a/c}function r(a,c,b){Object.keys(c).forEach(function(d){var e=d.split(":"),f=e[1],g=b(e[0]),e=c[d],h=typeof e;"object"===h?Object.keys(e).length&&(d=g?a.getElementsByTagNameNS(g,f)[0]||a.ownerDocument.createElementNS(g,d):a.getElementsByTagName(f)[0]||
a.ownerDocument.createElement(d),a.appendChild(d),r(d,e,b)):g&&(runtime.assert("number"===h||"string"===h,"attempting to map unsupported type '"+h+"' (key: "+d+")"),a.setAttributeNS(g,d,String(e)))})}var c=null;this.splitBoundaries=function(a){var c,k=[],e,f,g;if(a.startContainer.nodeType===Node.TEXT_NODE||a.endContainer.nodeType===Node.TEXT_NODE){e=a.endContainer;f=a.endContainer.nodeType!==Node.TEXT_NODE?a.endOffset===a.endContainer.childNodes.length:!1;g=a.endOffset;c=a.endContainer;if(g<c.childNodes.length)for(c=
c.childNodes.item(g),g=0;c.firstChild;)c=c.firstChild;else for(;c.lastChild;)c=c.lastChild,g=c.nodeType===Node.TEXT_NODE?c.textContent.length:c.childNodes.length;c===e&&(e=null);a.setEnd(c,g);g=a.endContainer;0!==a.endOffset&&g.nodeType===Node.TEXT_NODE&&(c=g,a.endOffset!==c.length&&(k.push(c.splitText(a.endOffset)),k.push(c)));g=a.startContainer;0!==a.startOffset&&g.nodeType===Node.TEXT_NODE&&(c=g,a.startOffset!==c.length&&(g=c.splitText(a.startOffset),k.push(c),k.push(g),a.setStart(g,0)));if(null!==
e){for(g=a.endContainer;g.parentNode&&g.parentNode!==e;)g=g.parentNode;f=f?e.childNodes.length:b(g,e);a.setEnd(e,f)}}return k};this.containsRange=e;this.rangesIntersect=function(a,c){return 0>=a.compareBoundaryPoints(Range.END_TO_START,c)&&0<=a.compareBoundaryPoints(Range.START_TO_END,c)};this.getNodesInRange=function(a,c,b){var d=[],e=a.commonAncestorContainer,e=e.nodeType===Node.TEXT_NODE?e.parentNode:e;b=a.startContainer.ownerDocument.createTreeWalker(e,b,c,!1);var g,f;a.endContainer.childNodes[a.endOffset-
1]?(g=a.endContainer.childNodes[a.endOffset-1],f=Node.DOCUMENT_POSITION_PRECEDING|Node.DOCUMENT_POSITION_CONTAINED_BY):(g=a.endContainer,f=Node.DOCUMENT_POSITION_PRECEDING);a.startContainer.childNodes[a.startOffset]?(a=a.startContainer.childNodes[a.startOffset],b.currentNode=a):a.startOffset===(a.startContainer.nodeType===Node.TEXT_NODE?a.startContainer.length:a.startContainer.childNodes.length)?(a=a.startContainer,b.currentNode=a,b.lastChild(),a=b.nextNode()):(a=a.startContainer,b.currentNode=a);
if(a){a=b.currentNode;if(a!==e)for(a=a.parentNode;a&&a!==e;)c(a)===NodeFilter.FILTER_REJECT&&(b.currentNode=a),a=a.parentNode;a=b.currentNode;switch(c(a)){case NodeFilter.FILTER_REJECT:for(a=b.nextSibling();!a&&b.parentNode();)a=b.nextSibling();break;case NodeFilter.FILTER_SKIP:a=b.nextNode()}for(;a;){c=g.compareDocumentPosition(a);if(0!==c&&0===(c&f))break;d.push(a);a=b.nextNode()}}return d};this.normalizeTextNodes=function(a){a&&a.nextSibling&&(a=l(a,a.nextSibling));a&&a.previousSibling&&l(a.previousSibling,
a)};this.rangeContainsNode=function(a,c){var b=c.ownerDocument.createRange(),d=c.ownerDocument.createRange(),g;b.setStart(a.startContainer,a.startOffset);b.setEnd(a.endContainer,a.endOffset);d.selectNodeContents(c);g=e(b,d);b.detach();d.detach();return g};this.mergeIntoParent=f;this.removeUnwantedNodes=p;this.getElementsByTagNameNS=function(a,c,b){var d=[];a=a.getElementsByTagNameNS(c,b);d.length=b=a.length;for(c=0;c<b;c+=1)d[c]=a.item(c);return d};this.containsNode=function(a,c){return a===c||a.contains(c)};
this.comparePoints=function(a,c,k,e){if(a===k)return e-c;var g=a.compareDocumentPosition(k);2===g?g=-1:4===g?g=1:10===g?(c=b(a,k),g=c<e?1:-1):(e=b(k,a),g=e<c?-1:1);return g};this.adaptRangeDifferenceToZoomLevel=m;this.translateRect=function(a,c,b){return{top:m(a.top-c.top,b),left:m(a.left-c.left,b),bottom:m(a.bottom-c.top,b),right:m(a.right-c.left,b),width:m(a.width,b),height:m(a.height,b)}};this.getBoundingClientRect=function(a){var b=a.ownerDocument,k=h(),d=b.body;if((!1===k.unscaledRangeClientRects||
k.rangeBCRIgnoresElementBCR)&&a.nodeType===Node.ELEMENT_NODE)return a=a.getBoundingClientRect(),k.elementBCRIgnoresBodyScroll?{left:a.left+d.scrollLeft,right:a.right+d.scrollLeft,top:a.top+d.scrollTop,bottom:a.bottom+d.scrollTop,width:a.width,height:a.height}:a;var e;c?e=c:c=e=b.createRange();k=e;k.selectNode(a);return k.getBoundingClientRect()};this.mapKeyValObjOntoNode=function(a,c,b){Object.keys(c).forEach(function(d){var e=d.split(":"),g=e[1],e=b(e[0]),f=c[d];e?(g=a.getElementsByTagNameNS(e,g)[0],
g||(g=a.ownerDocument.createElementNS(e,d),a.appendChild(g)),g.textContent=f):runtime.log("Key ignored: "+d)})};this.removeKeyElementsFromNode=function(a,c,b){c.forEach(function(c){var d=c.split(":"),e=d[1];(d=b(d[0]))?(e=a.getElementsByTagNameNS(d,e)[0])?e.parentNode.removeChild(e):runtime.log("Element for "+c+" not found."):runtime.log("Property Name ignored: "+c)})};this.getKeyValRepresentationOfNode=function(a,c){for(var b={},d=a.firstElementChild,e;d;){if(e=c(d.namespaceURI))b[e+":"+d.localName]=
d.textContent;d=d.nextElementSibling}return b};this.mapObjOntoNode=r;this.getDirectChild=g;(function(a){var c,b;b=runtime.getWindow();null!==b&&(c=b.navigator.appVersion.toLowerCase(),b=-1===c.indexOf("chrome")&&(-1!==c.indexOf("applewebkit")||-1!==c.indexOf("safari")),c=c.indexOf("msie"),b||c)&&(a.containsNode=q)})(this)}})();
// Input 8
core.Cursor=function(h,g){function b(c){c.parentNode&&(p.push(c.previousSibling),p.push(c.nextSibling),c.parentNode.removeChild(c))}function d(c,a,b){if(a.nodeType===Node.TEXT_NODE){runtime.assert(Boolean(a),"putCursorIntoTextNode: invalid container");var d=a.parentNode;runtime.assert(Boolean(d),"putCursorIntoTextNode: container without parent");runtime.assert(0<=b&&b<=a.length,"putCursorIntoTextNode: offset is out of bounds");0===b?d.insertBefore(c,a):(b!==a.length&&a.splitText(b),d.insertBefore(c,
a.nextSibling))}else a.nodeType===Node.ELEMENT_NODE&&a.insertBefore(c,a.childNodes.item(b));p.push(c.previousSibling);p.push(c.nextSibling)}var e=h.createElementNS("urn:webodf:names:cursor","cursor"),l=h.createElementNS("urn:webodf:names:cursor","anchor"),f,p=[],q=h.createRange(),m,r=new core.DomUtils;this.getNode=function(){return e};this.getAnchorNode=function(){return l.parentNode?l:e};this.getSelectedRange=function(){m?(q.setStartBefore(e),q.collapse(!0)):(q.setStartAfter(f?l:e),q.setEndBefore(f?
e:l));return q};this.setSelectedRange=function(c,a){q&&q!==c&&q.detach();q=c;f=!1!==a;(m=c.collapsed)?(b(l),b(e),d(e,c.startContainer,c.startOffset)):(b(l),b(e),d(f?e:l,c.endContainer,c.endOffset),d(f?l:e,c.startContainer,c.startOffset));p.forEach(r.normalizeTextNodes);p.length=0};this.hasForwardSelection=function(){return f};this.remove=function(){b(e);p.forEach(r.normalizeTextNodes);p.length=0};e.setAttributeNS("urn:webodf:names:cursor","memberId",g);l.setAttributeNS("urn:webodf:names:cursor","memberId",
g)};
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
core.Destroyable=function(){};core.Destroyable.prototype.destroy=function(h){};
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
core.EventNotifier=function(h){var g={};this.emit=function(b,d){var e,h;runtime.assert(g.hasOwnProperty(b),'unknown event fired "'+b+'"');h=g[b];for(e=0;e<h.length;e+=1)h[e](d)};this.subscribe=function(b,d){runtime.assert(g.hasOwnProperty(b),'tried to subscribe to unknown event "'+b+'"');g[b].push(d)};this.unsubscribe=function(b,d){var e;runtime.assert(g.hasOwnProperty(b),'tried to unsubscribe from unknown event "'+b+'"');e=g[b].indexOf(d);runtime.assert(-1!==e,'tried to unsubscribe unknown callback from event "'+
b+'"');-1!==e&&g[b].splice(e,1)};(function(){var b,d;for(b=0;b<h.length;b+=1)d=h[b],runtime.assert(!g.hasOwnProperty(d),'Duplicated event ids: "'+d+'" registered more than once.'),g[d]=[]})()};
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
core.LoopWatchDog=function(h,g){var b=Date.now(),d=0;this.check=function(){var e;if(h&&(e=Date.now(),e-b>h))throw runtime.log("alert","watchdog timeout"),"timeout!";if(0<g&&(d+=1,d>g))throw runtime.log("alert","watchdog loop overflow"),"loop overflow";}};
// Input 12
core.PositionIterator=function(h,g,b,d){function e(){this.acceptNode=function(a){return!a||a.nodeType===n&&0===a.length?s:t}}function l(a){this.acceptNode=function(c){return!c||c.nodeType===n&&0===c.length?s:a.acceptNode(c)}}function f(){var a=r.currentNode,b=a.nodeType;c=b===n?a.length-1:b===k?1:0}function p(){if(null===r.previousSibling()){if(!r.parentNode()||r.currentNode===h)return r.firstChild(),!1;c=0}else f();return!0}function q(){var b=r.currentNode,d;d=a(b);if(b!==h)for(b=b.parentNode;b&&
b!==h;)a(b)===s&&(r.currentNode=b,d=s),b=b.parentNode;d===s?(c=1,b=m.nextPosition()):b=d===t?!0:m.nextPosition();b&&runtime.assert(a(r.currentNode)===t,"moveToAcceptedNode did not result in walker being on an accepted node");return b}var m=this,r,c,a,n=Node.TEXT_NODE,k=Node.ELEMENT_NODE,t=NodeFilter.FILTER_ACCEPT,s=NodeFilter.FILTER_REJECT;this.nextPosition=function(){var a=r.currentNode,b=a.nodeType;if(a===h)return!1;if(0===c&&b===k)null===r.firstChild()&&(c=1);else if(b===n&&c+1<a.length)c+=1;else if(null!==
r.nextSibling())c=0;else if(r.parentNode())c=1;else return!1;return!0};this.previousPosition=function(){var a=!0,b=r.currentNode;0===c?a=p():b.nodeType===n?c-=1:null!==r.lastChild()?f():b===h?a=!1:c=0;return a};this.previousNode=p;this.container=function(){var a=r.currentNode,b=a.nodeType;0===c&&b!==n&&(a=a.parentNode);return a};this.rightNode=function(){var b=r.currentNode,d=b.nodeType;if(d===n&&c===b.length)for(b=b.nextSibling;b&&a(b)!==t;)b=b.nextSibling;else d===k&&1===c&&(b=null);return b};this.leftNode=
function(){var b=r.currentNode;if(0===c)for(b=b.previousSibling;b&&a(b)!==t;)b=b.previousSibling;else if(b.nodeType===k)for(b=b.lastChild;b&&a(b)!==t;)b=b.previousSibling;return b};this.getCurrentNode=function(){return r.currentNode};this.unfilteredDomOffset=function(){if(r.currentNode.nodeType===n)return c;for(var a=0,b=r.currentNode,b=1===c?b.lastChild:b.previousSibling;b;)a+=1,b=b.previousSibling;return a};this.getPreviousSibling=function(){var a=r.currentNode,c=r.previousSibling();r.currentNode=
a;return c};this.getNextSibling=function(){var a=r.currentNode,c=r.nextSibling();r.currentNode=a;return c};this.setPositionBeforeElement=function(a){runtime.assert(Boolean(a),"setPositionBeforeElement called without element");r.currentNode=a;c=0;return q()};this.setUnfilteredPosition=function(a,b){runtime.assert(Boolean(a),"PositionIterator.setUnfilteredPosition called without container");r.currentNode=a;if(a.nodeType===n)return c=b,runtime.assert(b<=a.length,"Error in setPosition: "+b+" > "+a.length),
runtime.assert(0<=b,"Error in setPosition: "+b+" < 0"),b===a.length&&(r.nextSibling()?c=0:r.parentNode()?c=1:runtime.assert(!1,"Error in setUnfilteredPosition: position not valid.")),!0;b<a.childNodes.length?(r.currentNode=a.childNodes.item(b),c=0):c=1;return q()};this.moveToEnd=function(){r.currentNode=h;c=1};this.moveToEndOfNode=function(a){a.nodeType===n?m.setUnfilteredPosition(a,a.length):(r.currentNode=a,c=1)};this.isBeforeNode=function(){return 0===c};this.getNodeFilter=function(){return a};
a=(b?new l(b):new e).acceptNode;a.acceptNode=a;g=g||NodeFilter.SHOW_ALL;runtime.assert(h.nodeType!==Node.TEXT_NODE,"Internet Explorer doesn't allow tree walker roots to be text nodes");r=h.ownerDocument.createTreeWalker(h,g,a,d);c=0;null===r.firstChild()&&(c=1)};
// Input 13
core.PositionFilter=function(){};core.PositionFilter.FilterResult={FILTER_ACCEPT:1,FILTER_REJECT:2,FILTER_SKIP:3};core.PositionFilter.prototype.acceptPosition=function(h){};
// Input 14
core.PositionFilterChain=function(){var h=[],g=core.PositionFilter.FilterResult.FILTER_ACCEPT,b=core.PositionFilter.FilterResult.FILTER_REJECT;this.acceptPosition=function(d){var e;for(e=0;e<h.length;e+=1)if(h[e].acceptPosition(d)===b)return b;return g};this.addFilter=function(b){h.push(b)}};
// Input 15
core.zip_HuftNode=function(){this.n=this.b=this.e=0;this.t=null};core.zip_HuftList=function(){this.list=this.next=null};
core.RawInflate=function(){function h(a,c,b,d,k,e){this.BMAX=16;this.N_MAX=288;this.status=0;this.root=null;this.m=0;var n=Array(this.BMAX+1),g,f,h,r,l,m,p,K=Array(this.BMAX+1),t,J,q,D=new core.zip_HuftNode,A=Array(this.BMAX);r=Array(this.N_MAX);var s,O=Array(this.BMAX+1),G,w,W;W=this.root=null;for(l=0;l<n.length;l++)n[l]=0;for(l=0;l<K.length;l++)K[l]=0;for(l=0;l<A.length;l++)A[l]=null;for(l=0;l<r.length;l++)r[l]=0;for(l=0;l<O.length;l++)O[l]=0;g=256<c?a[256]:this.BMAX;t=a;J=0;l=c;do n[t[J]]++,J++;
while(0<--l);if(n[0]===c)this.root=null,this.status=this.m=0;else{for(m=1;m<=this.BMAX&&0===n[m];m++);p=m;e<m&&(e=m);for(l=this.BMAX;0!==l&&0===n[l];l--);h=l;e>l&&(e=l);for(G=1<<m;m<l;m++,G<<=1)if(G-=n[m],0>G){this.status=2;this.m=e;return}G-=n[l];if(0>G)this.status=2,this.m=e;else{n[l]+=G;O[1]=m=0;t=n;J=1;for(q=2;0<--l;)m+=t[J++],O[q++]=m;t=a;l=J=0;do m=t[J++],0!==m&&(r[O[m]++]=l);while(++l<c);c=O[h];O[0]=l=0;t=r;J=0;r=-1;s=K[0]=0;q=null;w=0;for(p=p-1+1;p<=h;p++)for(a=n[p];0<a--;){for(;p>s+K[1+r];){s+=
K[1+r];r++;w=h-s;w=w>e?e:w;m=p-s;f=1<<m;if(f>a+1)for(f-=a+1,q=p;++m<w;){f<<=1;if(f<=n[++q])break;f-=n[q]}s+m>g&&s<g&&(m=g-s);w=1<<m;K[1+r]=m;q=Array(w);for(f=0;f<w;f++)q[f]=new core.zip_HuftNode;W=null===W?this.root=new core.zip_HuftList:W.next=new core.zip_HuftList;W.next=null;W.list=q;A[r]=q;0<r&&(O[r]=l,D.b=K[r],D.e=16+m,D.t=q,m=(l&(1<<s)-1)>>s-K[r],A[r-1][m].e=D.e,A[r-1][m].b=D.b,A[r-1][m].n=D.n,A[r-1][m].t=D.t)}D.b=p-s;J>=c?D.e=99:t[J]<b?(D.e=256>t[J]?16:15,D.n=t[J++]):(D.e=k[t[J]-b],D.n=d[t[J++]-
b]);f=1<<p-s;for(m=l>>s;m<w;m+=f)q[m].e=D.e,q[m].b=D.b,q[m].n=D.n,q[m].t=D.t;for(m=1<<p-1;0!==(l&m);m>>=1)l^=m;for(l^=m;(l&(1<<s)-1)!==O[r];)s-=K[r],r--}this.m=K[1];this.status=0!==G&&1!==h?1:0}}}function g(b){for(;a<b;){var d=c,k;k=u.length===C?-1:u[C++];c=d|k<<a;a+=8}}function b(a){return c&A[a]}function d(b){c>>=b;a-=b}function e(a,c,k){var e,h,r;if(0===k)return 0;for(r=0;;){g(w);h=y.list[b(w)];for(e=h.e;16<e;){if(99===e)return-1;d(h.b);e-=16;g(e);h=h.t[b(e)];e=h.e}d(h.b);if(16===e)p&=32767,a[c+
r++]=f[p++]=h.n;else{if(15===e)break;g(e);t=h.n+b(e);d(e);g(v);h=z.list[b(v)];for(e=h.e;16<e;){if(99===e)return-1;d(h.b);e-=16;g(e);h=h.t[b(e)];e=h.e}d(h.b);g(e);s=p-h.n-b(e);for(d(e);0<t&&r<k;)t--,s&=32767,p&=32767,a[c+r++]=f[p++]=f[s++]}if(r===k)return k}n=-1;return r}function l(a,c,k){var n,f,r,l,m,p,t,q=Array(316);for(n=0;n<q.length;n++)q[n]=0;g(5);p=257+b(5);d(5);g(5);t=1+b(5);d(5);g(4);n=4+b(4);d(4);if(286<p||30<t)return-1;for(f=0;f<n;f++)g(3),q[K[f]]=b(3),d(3);for(f=n;19>f;f++)q[K[f]]=0;w=
7;f=new h(q,19,19,null,null,w);if(0!==f.status)return-1;y=f.root;w=f.m;l=p+t;for(n=r=0;n<l;)if(g(w),m=y.list[b(w)],f=m.b,d(f),f=m.n,16>f)q[n++]=r=f;else if(16===f){g(2);f=3+b(2);d(2);if(n+f>l)return-1;for(;0<f--;)q[n++]=r}else{17===f?(g(3),f=3+b(3),d(3)):(g(7),f=11+b(7),d(7));if(n+f>l)return-1;for(;0<f--;)q[n++]=0;r=0}w=9;f=new h(q,p,257,D,G,w);0===w&&(f.status=1);if(0!==f.status)return-1;y=f.root;w=f.m;for(n=0;n<t;n++)q[n]=q[n+p];v=6;f=new h(q,t,0,J,O,v);z=f.root;v=f.m;return 0===v&&257<p||0!==f.status?
-1:e(a,c,k)}var f=[],p,q=null,m,r,c,a,n,k,t,s,y,z,w,v,u,C,A=[0,1,3,7,15,31,63,127,255,511,1023,2047,4095,8191,16383,32767,65535],D=[3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,67,83,99,115,131,163,195,227,258,0,0],G=[0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0,99,99],J=[1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,2049,3073,4097,6145,8193,12289,16385,24577],O=[0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13],K=[16,17,18,0,8,7,9,6,
10,5,11,4,12,3,13,2,14,1,15],W;this.inflate=function(K,A){f.length=65536;a=c=p=0;n=-1;k=!1;t=s=0;y=null;u=K;C=0;var P=new Uint8Array(new ArrayBuffer(A));a:for(var M=0,Y;M<A&&(!k||-1!==n);){if(0<t){if(0!==n)for(;0<t&&M<A;)t--,s&=32767,p&=32767,P[0+M]=f[p]=f[s],M+=1,p+=1,s+=1;else{for(;0<t&&M<A;)t-=1,p&=32767,g(8),P[0+M]=f[p]=b(8),M+=1,p+=1,d(8);0===t&&(n=-1)}if(M===A)break}if(-1===n){if(k)break;g(1);0!==b(1)&&(k=!0);d(1);g(2);n=b(2);d(2);y=null;t=0}switch(n){case 0:Y=P;var ba=0+M,V=A-M,$=void 0,$=
a&7;d($);g(16);$=b(16);d(16);g(16);if($!==(~c&65535))Y=-1;else{d(16);t=$;for($=0;0<t&&$<V;)t--,p&=32767,g(8),Y[ba+$++]=f[p++]=b(8),d(8);0===t&&(n=-1);Y=$}break;case 1:if(null!==y)Y=e(P,0+M,A-M);else b:{Y=P;ba=0+M;V=A-M;if(null===q){for(var x=void 0,$=Array(288),x=void 0,x=0;144>x;x++)$[x]=8;for(x=144;256>x;x++)$[x]=9;for(x=256;280>x;x++)$[x]=7;for(x=280;288>x;x++)$[x]=8;r=7;x=new h($,288,257,D,G,r);if(0!==x.status){alert("HufBuild error: "+x.status);Y=-1;break b}q=x.root;r=x.m;for(x=0;30>x;x++)$[x]=
5;W=5;x=new h($,30,0,J,O,W);if(1<x.status){q=null;alert("HufBuild error: "+x.status);Y=-1;break b}m=x.root;W=x.m}y=q;z=m;w=r;v=W;Y=e(Y,ba,V)}break;case 2:Y=null!==y?e(P,0+M,A-M):l(P,0+M,A-M);break;default:Y=-1}if(-1===Y)break a;M+=Y}u=new Uint8Array(new ArrayBuffer(0));return P}};
// Input 16
core.ScheduledTask=function(h,g,b){function d(){f&&(b(l),f=!1)}function e(){d();h.apply(void 0,p);p=null}var l,f=!1,p=[];this.trigger=function(){p=Array.prototype.slice.call(arguments);f||(f=!0,l=g(e))};this.triggerImmediate=function(){p=Array.prototype.slice.call(arguments);e()};this.processRequests=function(){f&&e()};this.cancel=d;this.destroy=function(b){d();b()}};
// Input 17
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
core.StepDirection={PREVIOUS:1,NEXT:2};
// Input 18
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
core.StepIterator=function(h,g){function b(){r=null;a=c=void 0}function d(){void 0===a&&(a=h.acceptPosition(g)===m);return a}function e(a,c){b();return g.setUnfilteredPosition(a,c)}function l(){r||(r=g.container());return r}function f(){void 0===c&&(c=g.unfilteredDomOffset());return c}function p(){for(b();g.nextPosition();)if(b(),d())return!0;return!1}function q(){for(b();g.previousPosition();)if(b(),d())return!0;return!1}var m=core.PositionFilter.FilterResult.FILTER_ACCEPT,r,c,a;this.isStep=d;this.setPosition=
e;this.container=l;this.offset=f;this.nextStep=p;this.previousStep=q;this.advanceStep=function(a){return a===core.StepDirection.NEXT?p():q()};this.roundToClosestStep=function(){var a=l(),c=f(),b=d();b||(b=q(),b||(e(a,c),b=p()));return b};this.roundToPreviousStep=function(){var a=d();a||(a=q());return a};this.roundToNextStep=function(){var a=d();a||(a=p());return a};this.leftNode=function(){return g.leftNode()}};
// Input 19
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
(function(){var h;core.Task={};core.Task.SUPPRESS_MANUAL_PROCESSING=!1;core.Task.processTasks=function(){core.Task.SUPPRESS_MANUAL_PROCESSING||h.performRedraw()};core.Task.createRedrawTask=function(g){return new core.ScheduledTask(g,h.requestRedrawTask,h.cancelRedrawTask)};core.Task.createTimeoutTask=function(g,b){return new core.ScheduledTask(g,function(d){return runtime.setTimeout(d,b)},runtime.clearTimeout)};h=new function(){var g={};this.requestRedrawTask=function(b){var d=runtime.requestAnimationFrame(function(){b();
delete g[d]});g[d]=b;return d};this.performRedraw=function(){Object.keys(g).forEach(function(b){g[b]();runtime.cancelAnimationFrame(parseInt(b,10))});g={}};this.cancelRedrawTask=function(b){runtime.cancelAnimationFrame(b);delete g[b]}}})();
// Input 20
core.UnitTest=function(){};core.UnitTest.prototype.setUp=function(){};core.UnitTest.prototype.tearDown=function(){};core.UnitTest.prototype.description=function(){};core.UnitTest.prototype.tests=function(){};core.UnitTest.prototype.asyncTests=function(){};
core.UnitTest.provideTestAreaDiv=function(){var h=runtime.getWindow().document,g=h.getElementById("testarea");runtime.assert(!g,'Unclean test environment, found a div with id "testarea".');g=h.createElement("div");g.setAttribute("id","testarea");h.body.appendChild(g);return g};
core.UnitTest.cleanupTestAreaDiv=function(){var h=runtime.getWindow().document,g=h.getElementById("testarea");runtime.assert(!!g&&g.parentNode===h.body,'Test environment broken, found no div with id "testarea" below body.');h.body.removeChild(g)};core.UnitTest.createXmlDocument=function(h,g,b){var d="<?xml version='1.0' encoding='UTF-8'?>",d=d+("<"+h);Object.keys(b).forEach(function(e){d+=" xmlns:"+e+'="'+b[e]+'"'});d+=">";d+=g;d+="</"+h+">";return runtime.parseXML(d)};
core.UnitTest.createOdtDocument=function(h,g){return core.UnitTest.createXmlDocument("office:document",h,g)};
core.UnitTestLogger=function(){var h=[],g=0,b=0,d="",e="";this.startTest=function(l,f){h=[];g=0;d=l;e=f;b=Date.now()};this.endTest=function(){var l=Date.now();return{description:e,suite:[d,e],success:0===g,log:h,time:l-b}};this.debug=function(b){h.push({category:"debug",message:b})};this.fail=function(b){g+=1;h.push({category:"fail",message:b})};this.pass=function(b){h.push({category:"pass",message:b})}};
core.UnitTestRunner=function(h,g){function b(a){q+=1;c?g.debug(a):g.fail(a)}function d(a,c){var d;try{if(a.length!==c.length)return b("array of length "+a.length+" should be "+c.length+" long"),!1;for(d=0;d<a.length;d+=1)if(a[d]!==c[d])return b(a[d]+" should be "+c[d]+" at array index "+d),!1}catch(e){return!1}return!0}function e(a,c,d){var f=a.attributes,g=f.length,h,r,l;for(h=0;h<g;h+=1)if(r=f.item(h),"xmlns"!==r.prefix&&"urn:webodf:names:steps"!==r.namespaceURI){l=c.getAttributeNS(r.namespaceURI,
r.localName);if(!c.hasAttributeNS(r.namespaceURI,r.localName))return b("Attribute "+r.localName+" with value "+r.value+" was not present"),!1;if(l!==r.value)return b("Attribute "+r.localName+" was "+l+" should be "+r.value),!1}return d?!0:e(c,a,!0)}function l(a,c){var d,f;d=a.nodeType;f=c.nodeType;if(d!==f)return b("Nodetype '"+d+"' should be '"+f+"'"),!1;if(d===Node.TEXT_NODE){if(a.data===c.data)return!0;b("Textnode data '"+a.data+"' should be '"+c.data+"'");return!1}runtime.assert(d===Node.ELEMENT_NODE,
"Only textnodes and elements supported.");if(a.namespaceURI!==c.namespaceURI)return b("namespace '"+a.namespaceURI+"' should be '"+c.namespaceURI+"'"),!1;if(a.localName!==c.localName)return b("localName '"+a.localName+"' should be '"+c.localName+"'"),!1;if(!e(a,c,!1))return!1;d=a.firstChild;for(f=c.firstChild;d;){if(!f)return b("Nodetype '"+d.nodeType+"' is unexpected here."),!1;if(!l(d,f))return!1;d=d.nextSibling;f=f.nextSibling}return f?(b("Nodetype '"+f.nodeType+"' is missing here."),!1):!0}function f(a,
c,b){if(0===c)return a===c&&1/a===1/c;if(a===c)return!0;if(null===a||null===c)return!1;if("number"===typeof c&&isNaN(c))return"number"===typeof a&&isNaN(a);if("number"===typeof c&&"number"===typeof a){if(a===c)return!0;void 0===b&&(b=1E-4);runtime.assert("number"===typeof b,"Absolute tolerance not given as number.");runtime.assert(0<=b,"Absolute tolerance should be given as positive number, was "+b);a=Math.abs(a-c);return a<=b}return Object.prototype.toString.call(c)===Object.prototype.toString.call([])?
d(a,c):"object"===typeof c&&"object"===typeof a?c.constructor===Element||c.constructor===Node?l(a,c):r(a,c):!1}function p(a,c,d,e){"string"===typeof c&&"string"===typeof d||g.debug("WARN: shouldBe() expects string arguments");var h,r;try{r=eval(c)}catch(l){h=l}a=eval(d);h?b(c+" should be "+a+". Threw exception "+h):f(r,a,e)?g.pass(c+" is "+d):String(typeof r)===String(typeof a)?(d=0===r&&0>1/r?"-0":String(r),b(c+" should be "+a+". Was "+d+".")):b(c+" should be "+a+" (of type "+typeof a+"). Was "+
r+" (of type "+typeof r+").")}var q=0,m,r,c=!1;this.resourcePrefix=function(){return h};this.beginExpectFail=function(){m=q;c=!0};this.endExpectFail=function(){var a=m===q;c=!1;q=m;a&&(q+=1,g.fail("Expected at least one failed test, but none registered."))};r=function(a,c){var e=Object.keys(a),g=Object.keys(c);e.sort();g.sort();return d(e,g)&&Object.keys(a).every(function(d){var e=a[d],k=c[d];return f(e,k)?!0:(b(e+" should be "+k+" for key "+d),!1)})};this.areNodesEqual=l;this.shouldBeNull=function(a,
c){p(a,c,"null")};this.shouldBeNonNull=function(a,c){var d,e;try{e=eval(c)}catch(f){d=f}d?b(c+" should be non-null. Threw exception "+d):null!==e?g.pass(c+" is non-null."):b(c+" should be non-null. Was "+e)};this.shouldBe=p;this.testFailed=b;this.countFailedTests=function(){return q};this.name=function(a){var c,b,d=[],e=a.length;d.length=e;for(c=0;c<e;c+=1){b=Runtime.getFunctionName(a[c])||"";if(""===b)throw"Found a function without a name.";d[c]={f:a[c],name:b}}return d}};
core.UnitTester=function(){function h(b,d){return"<span style='color:blue;cursor:pointer' onclick='"+d+"'>"+b+"</span>"}function g(d){b.reporter&&b.reporter(d)}var b=this,d=0,e=new core.UnitTestLogger,l={},f="BrowserRuntime"===runtime.type();this.resourcePrefix="";this.reporter=function(b){var d,e;f?runtime.log("<span>Running "+h(b.description,'runTest("'+b.suite[0]+'","'+b.description+'")')+"</span>"):runtime.log("Running "+b.description);if(!b.success)for(d=0;d<b.log.length;d+=1)e=b.log[d],runtime.log(e.category,
e.message)};this.runTests=function(p,q,m){function r(b){function f(){p&&a.endExpectFail();g(e.endTest());n.tearDown();k[h]=w===a.countFailedTests();r(b.slice(1))}var h,p;if(0===b.length)l[c]=k,d+=a.countFailedTests(),q();else if(s=b[0].f,h=b[0].name,p=!0===b[0].expectFail,w=a.countFailedTests(),m.length&&-1===m.indexOf(h))r(b.slice(1));else{n.setUp();e.startTest(c,h);p&&a.beginExpectFail();try{s(f)}catch(t){a.testFailed("Unexpected exception encountered: "+t.toString()+"\n"+t.stack),f()}}}var c=Runtime.getFunctionName(p)||
"",a=new core.UnitTestRunner(b.resourcePrefix,e),n=new p(a),k={},t,s,y,z,w;if(l.hasOwnProperty(c))runtime.log("Test "+c+" has already run.");else{f?runtime.log("<span>Running "+h(c,'runSuite("'+c+'");')+": "+n.description()+"</span>"):runtime.log("Running "+c+": "+n.description);y=n.tests();for(t=0;t<y.length;t+=1)if(s=y[t].f,p=y[t].name,z=!0===y[t].expectFail,!m.length||-1!==m.indexOf(p)){w=a.countFailedTests();n.setUp();e.startTest(c,p);z&&a.beginExpectFail();try{s()}catch(v){a.testFailed("Unexpected exception encountered: "+
v.toString()+"\n"+v.stack)}z&&a.endExpectFail();g(e.endTest());n.tearDown();k[p]=w===a.countFailedTests()}r(n.asyncTests())}};this.failedTestsCount=function(){return d};this.results=function(){return l}};
// Input 21
core.Utils=function(){function h(g,b){if(b&&Array.isArray(b)){g=g||[];if(!Array.isArray(g))throw"Destination is not an array.";g=g.concat(b.map(function(b){return h(null,b)}))}else if(b&&"object"===typeof b){g=g||{};if("object"!==typeof g)throw"Destination is not an object.";Object.keys(b).forEach(function(d){g[d]=h(g[d],b[d])})}else g=b;return g}this.hashString=function(g){var b=0,d,e;d=0;for(e=g.length;d<e;d+=1)b=(b<<5)-b+g.charCodeAt(d),b|=0;return b};this.mergeObjects=function(g,b){Object.keys(b).forEach(function(d){g[d]=
h(g[d],b[d])});return g}};
// Input 22
/*

 WebODF
 Copyright (c) 2010 Jos van den Oever
 Licensed under the ... License:

 Project home: http://www.webodf.org/
*/
core.Zip=function(h,g){function b(a){var c=[0,1996959894,3993919788,2567524794,124634137,1886057615,3915621685,2657392035,249268274,2044508324,3772115230,2547177864,162941995,2125561021,3887607047,2428444049,498536548,1789927666,4089016648,2227061214,450548861,1843258603,4107580753,2211677639,325883990,1684777152,4251122042,2321926636,335633487,1661365465,4195302755,2366115317,997073096,1281953886,3579855332,2724688242,1006888145,1258607687,3524101629,2768942443,901097722,1119000684,3686517206,2898065728,
853044451,1172266101,3705015759,2882616665,651767980,1373503546,3369554304,3218104598,565507253,1454621731,3485111705,3099436303,671266974,1594198024,3322730930,2970347812,795835527,1483230225,3244367275,3060149565,1994146192,31158534,2563907772,4023717930,1907459465,112637215,2680153253,3904427059,2013776290,251722036,2517215374,3775830040,2137656763,141376813,2439277719,3865271297,1802195444,476864866,2238001368,4066508878,1812370925,453092731,2181625025,4111451223,1706088902,314042704,2344532202,
4240017532,1658658271,366619977,2362670323,4224994405,1303535960,984961486,2747007092,3569037538,1256170817,1037604311,2765210733,3554079995,1131014506,879679996,2909243462,3663771856,1141124467,855842277,2852801631,3708648649,1342533948,654459306,3188396048,3373015174,1466479909,544179635,3110523913,3462522015,1591671054,702138776,2966460450,3352799412,1504918807,783551873,3082640443,3233442989,3988292384,2596254646,62317068,1957810842,3939845945,2647816111,81470997,1943803523,3814918930,2489596804,
225274430,2053790376,3826175755,2466906013,167816743,2097651377,4027552580,2265490386,503444072,1762050814,4150417245,2154129355,426522225,1852507879,4275313526,2312317920,282753626,1742555852,4189708143,2394877945,397917763,1622183637,3604390888,2714866558,953729732,1340076626,3518719985,2797360999,1068828381,1219638859,3624741850,2936675148,906185462,1090812512,3747672003,2825379669,829329135,1181335161,3412177804,3160834842,628085408,1382605366,3423369109,3138078467,570562233,1426400815,3317316542,
2998733608,733239954,1555261956,3268935591,3050360625,752459403,1541320221,2607071920,3965973030,1969922972,40735498,2617837225,3943577151,1913087877,83908371,2512341634,3803740692,2075208622,213261112,2463272603,3855990285,2094854071,198958881,2262029012,4057260610,1759359992,534414190,2176718541,4139329115,1873836001,414664567,2282248934,4279200368,1711684554,285281116,2405801727,4167216745,1634467795,376229701,2685067896,3608007406,1308918612,956543938,2808555105,3495958263,1231636301,1047427035,
2932959818,3654703836,1088359270,936918E3,2847714899,3736837829,1202900863,817233897,3183342108,3401237130,1404277552,615818150,3134207493,3453421203,1423857449,601450431,3009837614,3294710456,1567103746,711928724,3020668471,3272380065,1510334235,755167117],b,d,e=a.length,k=0,k=0;b=-1;for(d=0;d<e;d+=1)k=(b^a[d])&255,k=c[k],b=b>>>8^k;return b^-1}function d(a){return new Date((a>>25&127)+1980,(a>>21&15)-1,a>>16&31,a>>11&15,a>>5&63,(a&31)<<1)}function e(a){var c=a.getFullYear();return 1980>c?0:c-1980<<
25|a.getMonth()+1<<21|a.getDate()<<16|a.getHours()<<11|a.getMinutes()<<5|a.getSeconds()>>1}function l(a,c){var b,e,f,g,n,h,r,l=this;this.load=function(c){if(null!==l.data)c(null,l.data);else{var b=n+34+e+f+256;b+r>k&&(b=k-r);runtime.read(a,r,b,function(b,d){if(b||null===d)c(b,d);else a:{var e=d,k=new core.ByteArray(e),f=k.readUInt32LE(),r;if(67324752!==f)c("File entry signature is wrong."+f.toString()+" "+e.length.toString(),null);else{k.pos+=22;f=k.readUInt16LE();r=k.readUInt16LE();k.pos+=f+r;if(g){e=
e.subarray(k.pos,k.pos+n);if(n!==e.length){c("The amount of compressed bytes read was "+e.length.toString()+" instead of "+n.toString()+" for "+l.filename+" in "+a+".",null);break a}e=s(e,h)}else e=e.subarray(k.pos,k.pos+h);h!==e.length?c("The amount of bytes read was "+e.length.toString()+" instead of "+h.toString()+" for "+l.filename+" in "+a+".",null):(l.data=e,c(null,e))}}})}};this.set=function(a,c,b,d){l.filename=a;l.data=c;l.compressed=b;l.date=d};this.error=null;c&&(b=c.readUInt32LE(),33639248!==
b?this.error="Central directory entry has wrong signature at position "+(c.pos-4).toString()+' for file "'+a+'": '+c.data.length.toString():(c.pos+=6,g=c.readUInt16LE(),this.date=d(c.readUInt32LE()),c.readUInt32LE(),n=c.readUInt32LE(),h=c.readUInt32LE(),e=c.readUInt16LE(),f=c.readUInt16LE(),b=c.readUInt16LE(),c.pos+=8,r=c.readUInt32LE(),this.filename=runtime.byteArrayToString(c.data.subarray(c.pos,c.pos+e),"utf8"),this.data=null,c.pos+=e+f+b))}function f(a,c){if(22!==a.length)c("Central directory length should be 22.",
y);else{var b=new core.ByteArray(a),d;d=b.readUInt32LE();101010256!==d?c("Central directory signature is wrong: "+d.toString(),y):(d=b.readUInt16LE(),0!==d?c("Zip files with non-zero disk numbers are not supported.",y):(d=b.readUInt16LE(),0!==d?c("Zip files with non-zero disk numbers are not supported.",y):(d=b.readUInt16LE(),t=b.readUInt16LE(),d!==t?c("Number of entries is inconsistent.",y):(d=b.readUInt32LE(),b=b.readUInt16LE(),b=k-22-d,runtime.read(h,b,k-b,function(a,b){if(a||null===b)c(a,y);else a:{var d=
new core.ByteArray(b),e,k;n=[];for(e=0;e<t;e+=1){k=new l(h,d);if(k.error){c(k.error,y);break a}n[n.length]=k}c(null,y)}})))))}}function p(a,c){var b=null,d,e;for(e=0;e<n.length;e+=1)if(d=n[e],d.filename===a){b=d;break}b?b.data?c(null,b.data):b.load(c):c(a+" not found.",null)}function q(a){var c=new core.ByteArrayWriter("utf8"),d=0;c.appendArray([80,75,3,4,20,0,0,0,0,0]);a.data&&(d=a.data.length);c.appendUInt32LE(e(a.date));c.appendUInt32LE(a.data?b(a.data):0);c.appendUInt32LE(d);c.appendUInt32LE(d);
c.appendUInt16LE(a.filename.length);c.appendUInt16LE(0);c.appendString(a.filename);a.data&&c.appendByteArray(a.data);return c}function m(a,c){var d=new core.ByteArrayWriter("utf8"),k=0;d.appendArray([80,75,1,2,20,0,20,0,0,0,0,0]);a.data&&(k=a.data.length);d.appendUInt32LE(e(a.date));d.appendUInt32LE(a.data?b(a.data):0);d.appendUInt32LE(k);d.appendUInt32LE(k);d.appendUInt16LE(a.filename.length);d.appendArray([0,0,0,0,0,0,0,0,0,0,0,0]);d.appendUInt32LE(c);d.appendString(a.filename);return d}function r(a,
c){if(a===n.length)c(null);else{var b=n[a];null!==b.data?r(a+1,c):b.load(function(b){b?c(b):r(a+1,c)})}}function c(a,c){r(0,function(b){if(b)c(b);else{var d,e,k=new core.ByteArrayWriter("utf8"),f=[0];for(d=0;d<n.length;d+=1)k.appendByteArrayWriter(q(n[d])),f.push(k.getLength());b=k.getLength();for(d=0;d<n.length;d+=1)e=n[d],k.appendByteArrayWriter(m(e,f[d]));d=k.getLength()-b;k.appendArray([80,75,5,6,0,0,0,0]);k.appendUInt16LE(n.length);k.appendUInt16LE(n.length);k.appendUInt32LE(d);k.appendUInt32LE(b);
k.appendArray([0,0]);a(k.getByteArray())}})}function a(a,b){c(function(c){runtime.writeFile(a,c,b)},b)}var n,k,t,s=(new core.RawInflate).inflate,y=this,z=new core.Base64;this.load=p;this.save=function(a,c,b,d){var e,k;for(e=0;e<n.length;e+=1)if(k=n[e],k.filename===a){k.set(a,c,b,d);return}k=new l(h);k.set(a,c,b,d);n.push(k)};this.remove=function(a){var c,b;for(c=0;c<n.length;c+=1)if(b=n[c],b.filename===a)return n.splice(c,1),!0;return!1};this.write=function(c){a(h,c)};this.writeAs=a;this.createByteArray=
c;this.loadContentXmlAsFragments=function(a,c){y.loadAsString(a,function(a,b){if(a)return c.rootElementReady(a);c.rootElementReady(null,b,!0)})};this.loadAsString=function(a,c){p(a,function(a,b){if(a||null===b)return c(a,null);var d=runtime.byteArrayToString(b,"utf8");c(null,d)})};this.loadAsDOM=function(a,c){y.loadAsString(a,function(a,b){if(a||null===b)c(a,null);else{var d=(new DOMParser).parseFromString(b,"text/xml");c(null,d)}})};this.loadAsDataURL=function(a,c,b){p(a,function(a,d){if(a||!d)return b(a,
null);var e=0,k;c||(c=80===d[1]&&78===d[2]&&71===d[3]?"image/png":255===d[0]&&216===d[1]&&255===d[2]?"image/jpeg":71===d[0]&&73===d[1]&&70===d[2]?"image/gif":"");for(k="data:"+c+";base64,";e<d.length;)k+=z.convertUTF8ArrayToBase64(d.subarray(e,Math.min(e+45E3,d.length))),e+=45E3;b(null,k)})};this.getEntries=function(){return n.slice()};k=-1;null===g?n=[]:runtime.getFileSize(h,function(a){k=a;0>k?g("File '"+h+"' cannot be read.",y):runtime.read(h,k-22,22,function(a,c){a||null===g||null===c?g(a,y):
f(c,g)})})};
// Input 23
xmldom.LSSerializerFilter=function(){};xmldom.LSSerializerFilter.prototype.acceptNode=function(h){};
// Input 24
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
odf.OdfNodeFilter=function(){this.acceptNode=function(h){return"http://www.w3.org/1999/xhtml"===h.namespaceURI?NodeFilter.FILTER_SKIP:h.namespaceURI&&h.namespaceURI.match(/^urn:webodf:/)?NodeFilter.FILTER_REJECT:NodeFilter.FILTER_ACCEPT}};
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
odf.Namespaces={namespaceMap:{db:"urn:oasis:names:tc:opendocument:xmlns:database:1.0",dc:"http://purl.org/dc/elements/1.1/",dr3d:"urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0",draw:"urn:oasis:names:tc:opendocument:xmlns:drawing:1.0",chart:"urn:oasis:names:tc:opendocument:xmlns:chart:1.0",fo:"urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0",form:"urn:oasis:names:tc:opendocument:xmlns:form:1.0",meta:"urn:oasis:names:tc:opendocument:xmlns:meta:1.0",number:"urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0",
office:"urn:oasis:names:tc:opendocument:xmlns:office:1.0",presentation:"urn:oasis:names:tc:opendocument:xmlns:presentation:1.0",style:"urn:oasis:names:tc:opendocument:xmlns:style:1.0",svg:"urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0",table:"urn:oasis:names:tc:opendocument:xmlns:table:1.0",text:"urn:oasis:names:tc:opendocument:xmlns:text:1.0",xlink:"http://www.w3.org/1999/xlink",xml:"http://www.w3.org/XML/1998/namespace"},prefixMap:{},dbns:"urn:oasis:names:tc:opendocument:xmlns:database:1.0",
dcns:"http://purl.org/dc/elements/1.1/",dr3dns:"urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0",drawns:"urn:oasis:names:tc:opendocument:xmlns:drawing:1.0",chartns:"urn:oasis:names:tc:opendocument:xmlns:chart:1.0",fons:"urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0",formns:"urn:oasis:names:tc:opendocument:xmlns:form:1.0",metans:"urn:oasis:names:tc:opendocument:xmlns:meta:1.0",numberns:"urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0",officens:"urn:oasis:names:tc:opendocument:xmlns:office:1.0",
presentationns:"urn:oasis:names:tc:opendocument:xmlns:presentation:1.0",stylens:"urn:oasis:names:tc:opendocument:xmlns:style:1.0",svgns:"urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0",tablens:"urn:oasis:names:tc:opendocument:xmlns:table:1.0",textns:"urn:oasis:names:tc:opendocument:xmlns:text:1.0",xlinkns:"http://www.w3.org/1999/xlink",xmlns:"http://www.w3.org/XML/1998/namespace"};
(function(){var h=odf.Namespaces.namespaceMap,g=odf.Namespaces.prefixMap,b;for(b in h)h.hasOwnProperty(b)&&(g[h[b]]=b)})();odf.Namespaces.forEachPrefix=function(h){var g=odf.Namespaces.namespaceMap,b;for(b in g)g.hasOwnProperty(b)&&h(b,g[b])};odf.Namespaces.lookupNamespaceURI=function(h){var g=null;odf.Namespaces.namespaceMap.hasOwnProperty(h)&&(g=odf.Namespaces.namespaceMap[h]);return g};odf.Namespaces.lookupPrefix=function(h){var g=odf.Namespaces.prefixMap;return g.hasOwnProperty(h)?g[h]:null};
odf.Namespaces.lookupNamespaceURI.lookupNamespaceURI=odf.Namespaces.lookupNamespaceURI;
// Input 26
xmldom.XPathIterator=function(){};xmldom.XPathIterator.prototype.next=function(){};xmldom.XPathIterator.prototype.reset=function(){};
function createXPathSingleton(){function h(b,c,a){return-1!==b&&(b<c||-1===c)&&(b<a||-1===a)}function g(b){for(var c=[],a=0,d=b.length,e;a<d;){var f=b,g=d,l=c,p="",q=[],v=f.indexOf("[",a),u=f.indexOf("/",a),C=f.indexOf("=",a);h(u,v,C)?(p=f.substring(a,u),a=u+1):h(v,u,C)?(p=f.substring(a,v),a=m(f,v,q)):h(C,u,v)?(p=f.substring(a,C),a=C):(p=f.substring(a,g),a=g);l.push({location:p,predicates:q});if(a<d&&"="===b[a]){e=b.substring(a+1,d);if(2<e.length&&("'"===e[0]||'"'===e[0]))e=e.slice(1,e.length-1);
else try{e=parseInt(e,10)}catch(A){}a=d}}return{steps:c,value:e}}function b(){var b=null,c=!1;this.setNode=function(a){b=a};this.reset=function(){c=!1};this.next=function(){var a=c?null:b;c=!0;return a}}function d(b,c,a){this.reset=function(){b.reset()};this.next=function(){for(var d=b.next();d;){d.nodeType===Node.ELEMENT_NODE&&(d=d.getAttributeNodeNS(c,a));if(d)break;d=b.next()}return d}}function e(b,c){var a=b.next(),d=null;this.reset=function(){b.reset();a=b.next();d=null};this.next=function(){for(;a;){if(d)if(c&&
d.firstChild)d=d.firstChild;else{for(;!d.nextSibling&&d!==a;)d=d.parentNode;d===a?a=b.next():d=d.nextSibling}else{do(d=a.firstChild)||(a=b.next());while(a&&!d)}if(d&&d.nodeType===Node.ELEMENT_NODE)return d}return null}}function l(b,c){this.reset=function(){b.reset()};this.next=function(){for(var a=b.next();a&&!c(a);)a=b.next();return a}}function f(b,c,a){c=c.split(":",2);var d=a(c[0]),e=c[1];return new l(b,function(a){return a.localName===e&&a.namespaceURI===d})}function p(d,c,a){var e=new b,k=q(e,
c,a),f=c.value;return void 0===f?new l(d,function(a){e.setNode(a);k.reset();return null!==k.next()}):new l(d,function(a){e.setNode(a);k.reset();return(a=k.next())?a.nodeValue===f:!1})}var q,m;m=function(b,c,a){for(var d=c,e=b.length,f=0;d<e;)"]"===b[d]?(f-=1,0>=f&&a.push(g(b.substring(c,d)))):"["===b[d]&&(0>=f&&(c=d+1),f+=1),d+=1;return d};q=function(b,c,a){var g,k,h,l;for(g=0;g<c.steps.length;g+=1){h=c.steps[g];k=h.location;if(""===k)b=new e(b,!1);else if("@"===k[0]){k=k.substr(1).split(":",2);l=
a(k[0]);if(!l)throw"No namespace associated with the prefix "+k[0];b=new d(b,l,k[1])}else"."!==k&&(b=new e(b,!1),-1!==k.indexOf(":")&&(b=f(b,k,a)));for(k=0;k<h.predicates.length;k+=1)l=h.predicates[k],b=p(b,l,a)}return b};return{getODFElementsWithXPath:function(d,c,a){var e=d.ownerDocument,k=[],f=null;if(e&&"function"===typeof e.evaluate)for(a=e.evaluate(c,d,a,XPathResult.UNORDERED_NODE_ITERATOR_TYPE,null),f=a.iterateNext();null!==f;)f.nodeType===Node.ELEMENT_NODE&&k.push(f),f=a.iterateNext();else{k=
new b;k.setNode(d);d=g(c);k=q(k,d,a);d=[];for(a=k.next();a;)d.push(a),a=k.next();k=d}return k}}}xmldom.XPath=createXPathSingleton();
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
odf.StyleInfo=function(){function h(a,c){var b,d,e,k,f,g=0;if(b=D[a.localName])if(e=b[a.namespaceURI])g=e.length;for(b=0;b<g;b+=1)d=e[b],k=d.ns,f=d.localname,(d=a.getAttributeNS(k,f))&&a.setAttributeNS(k,C[k]+f,c+d);for(e=a.firstElementChild;e;)h(e,c),e=e.nextElementSibling}function g(a,c){var b,d,e,k,f,h=0;if(b=D[a.localName])if(e=b[a.namespaceURI])h=e.length;for(b=0;b<h;b+=1)if(d=e[b],k=d.ns,f=d.localname,d=a.getAttributeNS(k,f))d=d.replace(c,""),a.setAttributeNS(k,C[k]+f,d);for(e=a.firstElementChild;e;)g(e,
c),e=e.nextElementSibling}function b(a,c){var b,d,e,k,f,g=0;if(b=D[a.localName])if(e=b[a.namespaceURI])g=e.length;for(b=0;b<g;b+=1)if(k=e[b],d=k.ns,f=k.localname,d=a.getAttributeNS(d,f))c=c||{},k=k.keyname,c.hasOwnProperty(k)?c[k][d]=1:(f={},f[d]=1,c[k]=f);return c}function d(a,c){var e,k;b(a,c);for(e=a.firstChild;e;)e.nodeType===Node.ELEMENT_NODE&&(k=e,d(k,c)),e=e.nextSibling}function e(a,c,b){this.key=a;this.name=c;this.family=b;this.requires={}}function l(a,c,b){var d=a+'"'+c,k=b[d];k||(k=b[d]=
new e(d,a,c));return k}function f(a,c,b){var d,e,k,g,h,n=0;d=a.getAttributeNS(w,"name");g=a.getAttributeNS(w,"family");d&&g&&(c=l(d,g,b));if(c){if(d=D[a.localName])if(k=d[a.namespaceURI])n=k.length;for(d=0;d<n;d+=1)if(g=k[d],e=g.ns,h=g.localname,e=a.getAttributeNS(e,h))g=g.keyname,g=l(e,g,b),c.requires[g.key]=g}for(a=a.firstElementChild;a;)f(a,c,b),a=a.nextElementSibling;return b}function p(a,c){var b=c[a.family];b||(b=c[a.family]={});b[a.name]=1;Object.keys(a.requires).forEach(function(b){p(a.requires[b],
c)})}function q(a,c){var b=f(a,null,{});Object.keys(b).forEach(function(a){a=b[a];var d=c[a.family];d&&d.hasOwnProperty(a.name)&&p(a,c)})}function m(a,c){function b(c){(c=k.getAttributeNS(w,c))&&(a[c]=!0)}var d=["font-name","font-name-asian","font-name-complex"],e,k;for(e=c&&c.firstElementChild;e;)k=e,d.forEach(b),m(a,k),e=e.nextElementSibling}function r(a,c){function b(a){var d=k.getAttributeNS(w,a);d&&c.hasOwnProperty(d)&&k.setAttributeNS(w,"style:"+a,c[d])}var d=["font-name","font-name-asian",
"font-name-complex"],e,k;for(e=a&&a.firstElementChild;e;)k=e,d.forEach(b),r(k,c),e=e.nextElementSibling}var c=odf.Namespaces.chartns,a=odf.Namespaces.dbns,n=odf.Namespaces.dr3dns,k=odf.Namespaces.drawns,t=odf.Namespaces.formns,s=odf.Namespaces.numberns,y=odf.Namespaces.officens,z=odf.Namespaces.presentationns,w=odf.Namespaces.stylens,v=odf.Namespaces.tablens,u=odf.Namespaces.textns,C={"urn:oasis:names:tc:opendocument:xmlns:chart:1.0":"chart:","urn:oasis:names:tc:opendocument:xmlns:database:1.0":"db:",
"urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0":"dr3d:","urn:oasis:names:tc:opendocument:xmlns:drawing:1.0":"draw:","urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0":"fo:","urn:oasis:names:tc:opendocument:xmlns:form:1.0":"form:","urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0":"number:","urn:oasis:names:tc:opendocument:xmlns:office:1.0":"office:","urn:oasis:names:tc:opendocument:xmlns:presentation:1.0":"presentation:","urn:oasis:names:tc:opendocument:xmlns:style:1.0":"style:","urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0":"svg:",
"urn:oasis:names:tc:opendocument:xmlns:table:1.0":"table:","urn:oasis:names:tc:opendocument:xmlns:text:1.0":"chart:","http://www.w3.org/XML/1998/namespace":"xml:"},A={text:[{ens:w,en:"tab-stop",ans:w,a:"leader-text-style"},{ens:w,en:"drop-cap",ans:w,a:"style-name"},{ens:u,en:"notes-configuration",ans:u,a:"citation-body-style-name"},{ens:u,en:"notes-configuration",ans:u,a:"citation-style-name"},{ens:u,en:"a",ans:u,a:"style-name"},{ens:u,en:"alphabetical-index",ans:u,a:"style-name"},{ens:u,en:"linenumbering-configuration",
ans:u,a:"style-name"},{ens:u,en:"list-level-style-number",ans:u,a:"style-name"},{ens:u,en:"ruby-text",ans:u,a:"style-name"},{ens:u,en:"span",ans:u,a:"style-name"},{ens:u,en:"a",ans:u,a:"visited-style-name"},{ens:w,en:"text-properties",ans:w,a:"text-line-through-text-style"},{ens:u,en:"alphabetical-index-source",ans:u,a:"main-entry-style-name"},{ens:u,en:"index-entry-bibliography",ans:u,a:"style-name"},{ens:u,en:"index-entry-chapter",ans:u,a:"style-name"},{ens:u,en:"index-entry-link-end",ans:u,a:"style-name"},
{ens:u,en:"index-entry-link-start",ans:u,a:"style-name"},{ens:u,en:"index-entry-page-number",ans:u,a:"style-name"},{ens:u,en:"index-entry-span",ans:u,a:"style-name"},{ens:u,en:"index-entry-tab-stop",ans:u,a:"style-name"},{ens:u,en:"index-entry-text",ans:u,a:"style-name"},{ens:u,en:"index-title-template",ans:u,a:"style-name"},{ens:u,en:"list-level-style-bullet",ans:u,a:"style-name"},{ens:u,en:"outline-level-style",ans:u,a:"style-name"}],paragraph:[{ens:k,en:"caption",ans:k,a:"text-style-name"},{ens:k,
en:"circle",ans:k,a:"text-style-name"},{ens:k,en:"connector",ans:k,a:"text-style-name"},{ens:k,en:"control",ans:k,a:"text-style-name"},{ens:k,en:"custom-shape",ans:k,a:"text-style-name"},{ens:k,en:"ellipse",ans:k,a:"text-style-name"},{ens:k,en:"frame",ans:k,a:"text-style-name"},{ens:k,en:"line",ans:k,a:"text-style-name"},{ens:k,en:"measure",ans:k,a:"text-style-name"},{ens:k,en:"path",ans:k,a:"text-style-name"},{ens:k,en:"polygon",ans:k,a:"text-style-name"},{ens:k,en:"polyline",ans:k,a:"text-style-name"},
{ens:k,en:"rect",ans:k,a:"text-style-name"},{ens:k,en:"regular-polygon",ans:k,a:"text-style-name"},{ens:y,en:"annotation",ans:k,a:"text-style-name"},{ens:t,en:"column",ans:t,a:"text-style-name"},{ens:w,en:"style",ans:w,a:"next-style-name"},{ens:v,en:"body",ans:v,a:"paragraph-style-name"},{ens:v,en:"even-columns",ans:v,a:"paragraph-style-name"},{ens:v,en:"even-rows",ans:v,a:"paragraph-style-name"},{ens:v,en:"first-column",ans:v,a:"paragraph-style-name"},{ens:v,en:"first-row",ans:v,a:"paragraph-style-name"},
{ens:v,en:"last-column",ans:v,a:"paragraph-style-name"},{ens:v,en:"last-row",ans:v,a:"paragraph-style-name"},{ens:v,en:"odd-columns",ans:v,a:"paragraph-style-name"},{ens:v,en:"odd-rows",ans:v,a:"paragraph-style-name"},{ens:u,en:"notes-configuration",ans:u,a:"default-style-name"},{ens:u,en:"alphabetical-index-entry-template",ans:u,a:"style-name"},{ens:u,en:"bibliography-entry-template",ans:u,a:"style-name"},{ens:u,en:"h",ans:u,a:"style-name"},{ens:u,en:"illustration-index-entry-template",ans:u,a:"style-name"},
{ens:u,en:"index-source-style",ans:u,a:"style-name"},{ens:u,en:"object-index-entry-template",ans:u,a:"style-name"},{ens:u,en:"p",ans:u,a:"style-name"},{ens:u,en:"table-index-entry-template",ans:u,a:"style-name"},{ens:u,en:"table-of-content-entry-template",ans:u,a:"style-name"},{ens:u,en:"table-index-entry-template",ans:u,a:"style-name"},{ens:u,en:"user-index-entry-template",ans:u,a:"style-name"},{ens:w,en:"page-layout-properties",ans:w,a:"register-truth-ref-style-name"}],chart:[{ens:c,en:"axis",ans:c,
a:"style-name"},{ens:c,en:"chart",ans:c,a:"style-name"},{ens:c,en:"data-label",ans:c,a:"style-name"},{ens:c,en:"data-point",ans:c,a:"style-name"},{ens:c,en:"equation",ans:c,a:"style-name"},{ens:c,en:"error-indicator",ans:c,a:"style-name"},{ens:c,en:"floor",ans:c,a:"style-name"},{ens:c,en:"footer",ans:c,a:"style-name"},{ens:c,en:"grid",ans:c,a:"style-name"},{ens:c,en:"legend",ans:c,a:"style-name"},{ens:c,en:"mean-value",ans:c,a:"style-name"},{ens:c,en:"plot-area",ans:c,a:"style-name"},{ens:c,en:"regression-curve",
ans:c,a:"style-name"},{ens:c,en:"series",ans:c,a:"style-name"},{ens:c,en:"stock-gain-marker",ans:c,a:"style-name"},{ens:c,en:"stock-loss-marker",ans:c,a:"style-name"},{ens:c,en:"stock-range-line",ans:c,a:"style-name"},{ens:c,en:"subtitle",ans:c,a:"style-name"},{ens:c,en:"title",ans:c,a:"style-name"},{ens:c,en:"wall",ans:c,a:"style-name"}],section:[{ens:u,en:"alphabetical-index",ans:u,a:"style-name"},{ens:u,en:"bibliography",ans:u,a:"style-name"},{ens:u,en:"illustration-index",ans:u,a:"style-name"},
{ens:u,en:"index-title",ans:u,a:"style-name"},{ens:u,en:"object-index",ans:u,a:"style-name"},{ens:u,en:"section",ans:u,a:"style-name"},{ens:u,en:"table-of-content",ans:u,a:"style-name"},{ens:u,en:"table-index",ans:u,a:"style-name"},{ens:u,en:"user-index",ans:u,a:"style-name"}],ruby:[{ens:u,en:"ruby",ans:u,a:"style-name"}],table:[{ens:a,en:"query",ans:a,a:"style-name"},{ens:a,en:"table-representation",ans:a,a:"style-name"},{ens:v,en:"background",ans:v,a:"style-name"},{ens:v,en:"table",ans:v,a:"style-name"}],
"table-column":[{ens:a,en:"column",ans:a,a:"style-name"},{ens:v,en:"table-column",ans:v,a:"style-name"}],"table-row":[{ens:a,en:"query",ans:a,a:"default-row-style-name"},{ens:a,en:"table-representation",ans:a,a:"default-row-style-name"},{ens:v,en:"table-row",ans:v,a:"style-name"}],"table-cell":[{ens:a,en:"column",ans:a,a:"default-cell-style-name"},{ens:v,en:"table-column",ans:v,a:"default-cell-style-name"},{ens:v,en:"table-row",ans:v,a:"default-cell-style-name"},{ens:v,en:"body",ans:v,a:"style-name"},
{ens:v,en:"covered-table-cell",ans:v,a:"style-name"},{ens:v,en:"even-columns",ans:v,a:"style-name"},{ens:v,en:"covered-table-cell",ans:v,a:"style-name"},{ens:v,en:"even-columns",ans:v,a:"style-name"},{ens:v,en:"even-rows",ans:v,a:"style-name"},{ens:v,en:"first-column",ans:v,a:"style-name"},{ens:v,en:"first-row",ans:v,a:"style-name"},{ens:v,en:"last-column",ans:v,a:"style-name"},{ens:v,en:"last-row",ans:v,a:"style-name"},{ens:v,en:"odd-columns",ans:v,a:"style-name"},{ens:v,en:"odd-rows",ans:v,a:"style-name"},
{ens:v,en:"table-cell",ans:v,a:"style-name"}],graphic:[{ens:n,en:"cube",ans:k,a:"style-name"},{ens:n,en:"extrude",ans:k,a:"style-name"},{ens:n,en:"rotate",ans:k,a:"style-name"},{ens:n,en:"scene",ans:k,a:"style-name"},{ens:n,en:"sphere",ans:k,a:"style-name"},{ens:k,en:"caption",ans:k,a:"style-name"},{ens:k,en:"circle",ans:k,a:"style-name"},{ens:k,en:"connector",ans:k,a:"style-name"},{ens:k,en:"control",ans:k,a:"style-name"},{ens:k,en:"custom-shape",ans:k,a:"style-name"},{ens:k,en:"ellipse",ans:k,a:"style-name"},
{ens:k,en:"frame",ans:k,a:"style-name"},{ens:k,en:"g",ans:k,a:"style-name"},{ens:k,en:"line",ans:k,a:"style-name"},{ens:k,en:"measure",ans:k,a:"style-name"},{ens:k,en:"page-thumbnail",ans:k,a:"style-name"},{ens:k,en:"path",ans:k,a:"style-name"},{ens:k,en:"polygon",ans:k,a:"style-name"},{ens:k,en:"polyline",ans:k,a:"style-name"},{ens:k,en:"rect",ans:k,a:"style-name"},{ens:k,en:"regular-polygon",ans:k,a:"style-name"},{ens:y,en:"annotation",ans:k,a:"style-name"}],presentation:[{ens:n,en:"cube",ans:z,
a:"style-name"},{ens:n,en:"extrude",ans:z,a:"style-name"},{ens:n,en:"rotate",ans:z,a:"style-name"},{ens:n,en:"scene",ans:z,a:"style-name"},{ens:n,en:"sphere",ans:z,a:"style-name"},{ens:k,en:"caption",ans:z,a:"style-name"},{ens:k,en:"circle",ans:z,a:"style-name"},{ens:k,en:"connector",ans:z,a:"style-name"},{ens:k,en:"control",ans:z,a:"style-name"},{ens:k,en:"custom-shape",ans:z,a:"style-name"},{ens:k,en:"ellipse",ans:z,a:"style-name"},{ens:k,en:"frame",ans:z,a:"style-name"},{ens:k,en:"g",ans:z,a:"style-name"},
{ens:k,en:"line",ans:z,a:"style-name"},{ens:k,en:"measure",ans:z,a:"style-name"},{ens:k,en:"page-thumbnail",ans:z,a:"style-name"},{ens:k,en:"path",ans:z,a:"style-name"},{ens:k,en:"polygon",ans:z,a:"style-name"},{ens:k,en:"polyline",ans:z,a:"style-name"},{ens:k,en:"rect",ans:z,a:"style-name"},{ens:k,en:"regular-polygon",ans:z,a:"style-name"},{ens:y,en:"annotation",ans:z,a:"style-name"}],"drawing-page":[{ens:k,en:"page",ans:k,a:"style-name"},{ens:z,en:"notes",ans:k,a:"style-name"},{ens:w,en:"handout-master",
ans:k,a:"style-name"},{ens:w,en:"master-page",ans:k,a:"style-name"}],"list-style":[{ens:u,en:"list",ans:u,a:"style-name"},{ens:u,en:"numbered-paragraph",ans:u,a:"style-name"},{ens:u,en:"list-item",ans:u,a:"style-override"},{ens:w,en:"style",ans:w,a:"list-style-name"}],data:[{ens:w,en:"style",ans:w,a:"data-style-name"},{ens:w,en:"style",ans:w,a:"percentage-data-style-name"},{ens:z,en:"date-time-decl",ans:w,a:"data-style-name"},{ens:u,en:"creation-date",ans:w,a:"data-style-name"},{ens:u,en:"creation-time",
ans:w,a:"data-style-name"},{ens:u,en:"database-display",ans:w,a:"data-style-name"},{ens:u,en:"date",ans:w,a:"data-style-name"},{ens:u,en:"editing-duration",ans:w,a:"data-style-name"},{ens:u,en:"expression",ans:w,a:"data-style-name"},{ens:u,en:"meta-field",ans:w,a:"data-style-name"},{ens:u,en:"modification-date",ans:w,a:"data-style-name"},{ens:u,en:"modification-time",ans:w,a:"data-style-name"},{ens:u,en:"print-date",ans:w,a:"data-style-name"},{ens:u,en:"print-time",ans:w,a:"data-style-name"},{ens:u,
en:"table-formula",ans:w,a:"data-style-name"},{ens:u,en:"time",ans:w,a:"data-style-name"},{ens:u,en:"user-defined",ans:w,a:"data-style-name"},{ens:u,en:"user-field-get",ans:w,a:"data-style-name"},{ens:u,en:"user-field-input",ans:w,a:"data-style-name"},{ens:u,en:"variable-get",ans:w,a:"data-style-name"},{ens:u,en:"variable-input",ans:w,a:"data-style-name"},{ens:u,en:"variable-set",ans:w,a:"data-style-name"}],"page-layout":[{ens:z,en:"notes",ans:w,a:"page-layout-name"},{ens:w,en:"handout-master",ans:w,
a:"page-layout-name"},{ens:w,en:"master-page",ans:w,a:"page-layout-name"}]},D,G=xmldom.XPath;this.collectUsedFontFaces=m;this.changeFontFaceNames=r;this.UsedStyleList=function(a,c){var b={};this.uses=function(a){var c=a.localName,d=a.getAttributeNS(k,"name")||a.getAttributeNS(w,"name");a="style"===c?a.getAttributeNS(w,"family"):a.namespaceURI===s?"data":c;return(a=b[a])?0<a[d]:!1};d(a,b);c&&q(c,b)};this.getStyleName=function(a,c){var b,d,e=D[c.localName];if(e&&(e=e[c.namespaceURI]))for(d=0;d<e.length;d+=
1)if(e[d].keyname===a&&(e=e[d],c.hasAttributeNS(e.ns,e.localname))){b=c.getAttributeNS(e.ns,e.localname);break}return b};this.hasDerivedStyles=function(a,c,b){var d=b.getAttributeNS(w,"name");b=b.getAttributeNS(w,"family");return G.getODFElementsWithXPath(a,"//style:*[@style:parent-style-name='"+d+"'][@style:family='"+b+"']",c).length?!0:!1};this.prefixStyleNames=function(a,c,b){var d;if(a){for(d=a.firstChild;d;){if(d.nodeType===Node.ELEMENT_NODE){var e=d,f=c,g=e.getAttributeNS(k,"name"),n=void 0;
g?n=k:(g=e.getAttributeNS(w,"name"))&&(n=w);n&&e.setAttributeNS(n,C[n]+"name",f+g)}d=d.nextSibling}h(a,c);b&&h(b,c)}};this.removePrefixFromStyleNames=function(a,c,b){var d=RegExp("^"+c);if(a){for(c=a.firstChild;c;){if(c.nodeType===Node.ELEMENT_NODE){var e=c,f=d,h=e.getAttributeNS(k,"name"),n=void 0;h?n=k:(h=e.getAttributeNS(w,"name"))&&(n=w);n&&(h=h.replace(f,""),e.setAttributeNS(n,C[n]+"name",h))}c=c.nextSibling}g(a,d);b&&g(b,d)}};this.determineStylesForNode=b;D=function(){var a,c,b,d,e,k={},f,g,
h,n;for(b in A)if(A.hasOwnProperty(b))for(d=A[b],c=d.length,a=0;a<c;a+=1)e=d[a],h=e.en,n=e.ens,k.hasOwnProperty(h)?f=k[h]:k[h]=f={},f.hasOwnProperty(n)?g=f[n]:f[n]=g=[],g.push({ns:e.ans,localname:e.a,keyname:b});return k}()};
// Input 28
"function"!==typeof Object.create&&(Object.create=function(h){var g=function(){};g.prototype=h;return new g});
xmldom.LSSerializer=function(){function h(b){var d=b||{},f=function(b){var c={},a;for(a in b)b.hasOwnProperty(a)&&(c[b[a]]=a);return c}(b),g=[d],h=[f],m=0;this.push=function(){m+=1;d=g[m]=Object.create(d);f=h[m]=Object.create(f)};this.pop=function(){g.pop();h.pop();m-=1;d=g[m];f=h[m]};this.getLocalNamespaceDefinitions=function(){return f};this.getQName=function(b){var c=b.namespaceURI,a=0,e;if(!c)return b.localName;if(e=f[c])return e+":"+b.localName;do{e||!b.prefix?(e="ns"+a,a+=1):e=b.prefix;if(d[e]===
c)break;if(!d[e]){d[e]=c;f[c]=e;break}e=null}while(null===e);return e+":"+b.localName}}function g(b){return b.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/'/g,"&apos;").replace(/"/g,"&quot;")}function b(e,h){var f="",p=d.filter?d.filter.acceptNode(h):NodeFilter.FILTER_ACCEPT,q;if(p===NodeFilter.FILTER_ACCEPT&&h.nodeType===Node.ELEMENT_NODE){e.push();q=e.getQName(h);var m,r=h.attributes,c,a,n,k="",t;m="<"+q;c=r.length;for(a=0;a<c;a+=1)n=r.item(a),"http://www.w3.org/2000/xmlns/"!==
n.namespaceURI&&(t=d.filter?d.filter.acceptNode(n):NodeFilter.FILTER_ACCEPT,t===NodeFilter.FILTER_ACCEPT&&(t=e.getQName(n),n="string"===typeof n.value?g(n.value):n.value,k+=" "+(t+'="'+n+'"')));c=e.getLocalNamespaceDefinitions();for(a in c)c.hasOwnProperty(a)&&((r=c[a])?"xmlns"!==r&&(m+=" xmlns:"+c[a]+'="'+a+'"'):m+=' xmlns="'+a+'"');f+=m+(k+">")}if(p===NodeFilter.FILTER_ACCEPT||p===NodeFilter.FILTER_SKIP){for(p=h.firstChild;p;)f+=b(e,p),p=p.nextSibling;h.nodeValue&&(f+=g(h.nodeValue))}q&&(f+="</"+
q+">",e.pop());return f}var d=this;this.filter=null;this.writeToString=function(d,g){if(!d)return"";var f=new h(g);return b(f,d)}};
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
(function(){function h(b){var c,a=p.length;for(c=0;c<a;c+=1)if("urn:oasis:names:tc:opendocument:xmlns:office:1.0"===b.namespaceURI&&b.localName===p[c])return c;return-1}function g(b,c){var a=new e.UsedStyleList(b,c),d=new odf.OdfNodeFilter;this.acceptNode=function(b){var e=d.acceptNode(b);e===NodeFilter.FILTER_ACCEPT&&b.parentNode===c&&b.nodeType===Node.ELEMENT_NODE&&(e=a.uses(b)?NodeFilter.FILTER_ACCEPT:NodeFilter.FILTER_REJECT);return e}}function b(b,c){var a=new g(b,c);this.acceptNode=function(c){var b=
a.acceptNode(c);b!==NodeFilter.FILTER_ACCEPT||!c.parentNode||c.parentNode.namespaceURI!==odf.Namespaces.textns||"s"!==c.parentNode.localName&&"tab"!==c.parentNode.localName||(b=NodeFilter.FILTER_REJECT);return b}}function d(b,c){if(c){var a=h(c),d,e=b.firstChild;if(-1!==a){for(;e;){d=h(e);if(-1!==d&&d>a)break;e=e.nextSibling}b.insertBefore(c,e)}}}var e=new odf.StyleInfo,l=new core.DomUtils,f=odf.Namespaces.stylens,p="meta settings scripts font-face-decls styles automatic-styles master-styles body".split(" "),
q=Date.now()+"_webodf_",m=new core.Base64;odf.ODFElement=function(){};odf.ODFDocumentElement=function(){};odf.ODFDocumentElement.prototype=new odf.ODFElement;odf.ODFDocumentElement.prototype.constructor=odf.ODFDocumentElement;odf.ODFDocumentElement.prototype.fontFaceDecls=null;odf.ODFDocumentElement.prototype.manifest=null;odf.ODFDocumentElement.prototype.settings=null;odf.ODFDocumentElement.namespaceURI="urn:oasis:names:tc:opendocument:xmlns:office:1.0";odf.ODFDocumentElement.localName="document";
odf.AnnotationElement=function(){};odf.OdfPart=function(b,c,a,d){var e=this;this.size=0;this.type=null;this.name=b;this.container=a;this.url=null;this.mimetype=c;this.onstatereadychange=this.document=null;this.EMPTY=0;this.LOADING=1;this.DONE=2;this.state=this.EMPTY;this.data="";this.load=function(){null!==d&&(this.mimetype=c,d.loadAsDataURL(b,c,function(a,c){a&&runtime.log(a);e.url=c;if(e.onchange)e.onchange(e);if(e.onstatereadychange)e.onstatereadychange(e)}))}};odf.OdfPart.prototype.load=function(){};
odf.OdfPart.prototype.getUrl=function(){return this.data?"data:;base64,"+m.toBase64(this.data):null};odf.OdfContainer=function c(a,h){function k(a){for(var c=a.firstChild,b;c;)b=c.nextSibling,c.nodeType===Node.ELEMENT_NODE?k(c):c.nodeType===Node.PROCESSING_INSTRUCTION_NODE&&a.removeChild(c),c=b}function p(a){var c={},b,d,e=a.ownerDocument.createNodeIterator(a,NodeFilter.SHOW_ELEMENT,null,!1);for(a=e.nextNode();a;)"urn:oasis:names:tc:opendocument:xmlns:office:1.0"===a.namespaceURI&&("annotation"===
a.localName?(b=a.getAttributeNS("urn:oasis:names:tc:opendocument:xmlns:office:1.0","name"))&&(c.hasOwnProperty(b)?runtime.log("Warning: annotation name used more than once with <office:annotation/>: '"+b+"'"):c[b]=a):"annotation-end"===a.localName&&((b=a.getAttributeNS("urn:oasis:names:tc:opendocument:xmlns:office:1.0","name"))?c.hasOwnProperty(b)?(d=c[b],d.annotationEndElement?runtime.log("Warning: annotation name used more than once with <office:annotation-end/>: '"+b+"'"):d.annotationEndElement=
a):runtime.log("Warning: annotation end without an annotation start, name: '"+b+"'"):runtime.log("Warning: annotation end without a name found"))),a=e.nextNode()}function s(a,c){for(var b=a&&a.firstChild;b;)b.nodeType===Node.ELEMENT_NODE&&b.setAttributeNS("urn:webodf:names:scope","scope",c),b=b.nextSibling}function y(a,c){for(var b=Q.rootElement.meta,b=b&&b.firstChild;b&&(b.namespaceURI!==a||b.localName!==c);)b=b.nextSibling;for(b=b&&b.firstChild;b&&b.nodeType!==Node.TEXT_NODE;)b=b.nextSibling;return b?
b.data:null}function z(a){var c={},b;for(a=a.firstChild;a;)a.nodeType===Node.ELEMENT_NODE&&a.namespaceURI===f&&"font-face"===a.localName&&(b=a.getAttributeNS(f,"name"),c[b]=a),a=a.nextSibling;return c}function w(a,c){var b=null,d,e,k;if(a)for(b=a.cloneNode(!0),d=b.firstElementChild;d;)e=d.nextElementSibling,(k=d.getAttributeNS("urn:webodf:names:scope","scope"))&&k!==c&&b.removeChild(d),d=e;return b}function v(a,b){var c,d,k,g=null,h={};if(a)for(b.forEach(function(a){e.collectUsedFontFaces(h,a)}),
g=a.cloneNode(!0),c=g.firstElementChild;c;)d=c.nextElementSibling,k=c.getAttributeNS(f,"name"),h[k]||g.removeChild(c),c=d;return g}function u(a){var c=Q.rootElement.ownerDocument,b;if(a){k(a.documentElement);try{b=c.importNode(a.documentElement,!0)}catch(d){}}return b}function C(a){Q.state=a;if(Q.onchange)Q.onchange(Q);if(Q.onstatereadychange)Q.onstatereadychange(Q)}function A(a){X=null;Q.rootElement=a;a.fontFaceDecls=l.getDirectChild(a,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","font-face-decls");
a.styles=l.getDirectChild(a,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","styles");a.automaticStyles=l.getDirectChild(a,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","automatic-styles");a.masterStyles=l.getDirectChild(a,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","master-styles");a.body=l.getDirectChild(a,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","body");a.meta=l.getDirectChild(a,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","meta");a.settings=l.getDirectChild(a,"urn:oasis:names:tc:opendocument:xmlns:office:1.0",
"settings");a.scripts=l.getDirectChild(a,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","scripts");p(a)}function D(a){var b=u(a),k=Q.rootElement,f;b&&"document-styles"===b.localName&&"urn:oasis:names:tc:opendocument:xmlns:office:1.0"===b.namespaceURI?(k.fontFaceDecls=l.getDirectChild(b,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","font-face-decls"),d(k,k.fontFaceDecls),f=l.getDirectChild(b,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","styles"),k.styles=f||a.createElementNS("urn:oasis:names:tc:opendocument:xmlns:office:1.0",
"styles"),d(k,k.styles),f=l.getDirectChild(b,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","automatic-styles"),k.automaticStyles=f||a.createElementNS("urn:oasis:names:tc:opendocument:xmlns:office:1.0","automatic-styles"),s(k.automaticStyles,"document-styles"),d(k,k.automaticStyles),b=l.getDirectChild(b,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","master-styles"),k.masterStyles=b||a.createElementNS("urn:oasis:names:tc:opendocument:xmlns:office:1.0","master-styles"),d(k,k.masterStyles),
e.prefixStyleNames(k.automaticStyles,q,k.masterStyles)):C(c.INVALID)}function G(a){a=u(a);var b,k,g,h;if(a&&"document-content"===a.localName&&"urn:oasis:names:tc:opendocument:xmlns:office:1.0"===a.namespaceURI){b=Q.rootElement;g=l.getDirectChild(a,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","font-face-decls");if(b.fontFaceDecls&&g){h=b.fontFaceDecls;var n,m,p,q,t={};k=z(h);q=z(g);for(g=g.firstElementChild;g;){n=g.nextElementSibling;if(g.namespaceURI===f&&"font-face"===g.localName)if(m=g.getAttributeNS(f,
"name"),k.hasOwnProperty(m)){if(!g.isEqualNode(k[m])){p=m;for(var D=k,K=q,J=0,A=void 0,A=p=p.replace(/\d+$/,"");D.hasOwnProperty(A)||K.hasOwnProperty(A);)J+=1,A=p+J;p=A;g.setAttributeNS(f,"style:name",p);h.appendChild(g);k[p]=g;delete q[m];t[m]=p}}else h.appendChild(g),k[m]=g,delete q[m];g=n}h=t}else g&&(b.fontFaceDecls=g,d(b,g));k=l.getDirectChild(a,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","automatic-styles");s(k,"document-content");h&&e.changeFontFaceNames(k,h);if(b.automaticStyles&&k)for(h=
k.firstChild;h;)b.automaticStyles.appendChild(h),h=k.firstChild;else k&&(b.automaticStyles=k,d(b,k));a=l.getDirectChild(a,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","body");if(null===a)throw"<office:body/> tag is mising.";b.body=a;d(b,b.body)}else C(c.INVALID)}function J(a){a=u(a);var b;a&&"document-meta"===a.localName&&"urn:oasis:names:tc:opendocument:xmlns:office:1.0"===a.namespaceURI&&(b=Q.rootElement,b.meta=l.getDirectChild(a,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","meta"),
d(b,b.meta))}function O(a){a=u(a);var b;a&&"document-settings"===a.localName&&"urn:oasis:names:tc:opendocument:xmlns:office:1.0"===a.namespaceURI&&(b=Q.rootElement,b.settings=l.getDirectChild(a,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","settings"),d(b,b.settings))}function K(a){a=u(a);var b;if(a&&"manifest"===a.localName&&"urn:oasis:names:tc:opendocument:xmlns:manifest:1.0"===a.namespaceURI)for(b=Q.rootElement,b.manifest=a,a=b.manifest.firstElementChild;a;)"file-entry"===a.localName&&"urn:oasis:names:tc:opendocument:xmlns:manifest:1.0"===
a.namespaceURI&&(T[a.getAttributeNS("urn:oasis:names:tc:opendocument:xmlns:manifest:1.0","full-path")]=a.getAttributeNS("urn:oasis:names:tc:opendocument:xmlns:manifest:1.0","media-type")),a=a.nextElementSibling}function W(a){var b=a.shift();b?L.loadAsDOM(b.path,function(d,e){b.handler(e);Q.state===c.INVALID?d?runtime.log("ERROR: Unable to load "+b.path+" - "+d):runtime.log("ERROR: Unable to load "+b.path):(d&&runtime.log("DEBUG: Unable to load "+b.path+" - "+d),W(a))}):(p(Q.rootElement),C(c.DONE))}
function I(){W([{path:"styles.xml",handler:D},{path:"content.xml",handler:G},{path:"meta.xml",handler:J},{path:"settings.xml",handler:O},{path:"META-INF/manifest.xml",handler:K}])}function aa(a){var b="";odf.Namespaces.forEachPrefix(function(a,c){b+=" xmlns:"+a+'="'+c+'"'});return'<?xml version="1.0" encoding="UTF-8"?><office:'+a+" "+b+' office:version="1.2">'}function P(){var a=new xmldom.LSSerializer,b=aa("document-meta");a.filter=new odf.OdfNodeFilter;b+=a.writeToString(Q.rootElement.meta,odf.Namespaces.namespaceMap);
return b+"</office:document-meta>"}function M(a,b){var c=document.createElementNS("urn:oasis:names:tc:opendocument:xmlns:manifest:1.0","manifest:file-entry");c.setAttributeNS("urn:oasis:names:tc:opendocument:xmlns:manifest:1.0","manifest:full-path",a);c.setAttributeNS("urn:oasis:names:tc:opendocument:xmlns:manifest:1.0","manifest:media-type",b);return c}function Y(){var a=runtime.parseXML('<manifest:manifest xmlns:manifest="urn:oasis:names:tc:opendocument:xmlns:manifest:1.0" manifest:version="1.2"></manifest:manifest>'),
b=a.documentElement,c=new xmldom.LSSerializer,d;for(d in T)T.hasOwnProperty(d)&&b.appendChild(M(d,T[d]));c.filter=new odf.OdfNodeFilter;return'<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n'+c.writeToString(a,odf.Namespaces.namespaceMap)}function ba(){var a,b,c,d=odf.Namespaces.namespaceMap,k=new xmldom.LSSerializer,f=aa("document-styles");b=w(Q.rootElement.automaticStyles,"document-styles");c=Q.rootElement.masterStyles.cloneNode(!0);a=v(Q.rootElement.fontFaceDecls,[c,Q.rootElement.styles,
b]);e.removePrefixFromStyleNames(b,q,c);k.filter=new g(c,b);f+=k.writeToString(a,d);f+=k.writeToString(Q.rootElement.styles,d);f+=k.writeToString(b,d);f+=k.writeToString(c,d);return f+"</office:document-styles>"}function V(){var a,c,d=odf.Namespaces.namespaceMap,e=new xmldom.LSSerializer,k=aa("document-content");c=w(Q.rootElement.automaticStyles,"document-content");a=v(Q.rootElement.fontFaceDecls,[c]);e.filter=new b(Q.rootElement.body,c);k+=e.writeToString(a,d);k+=e.writeToString(c,d);k+=e.writeToString(Q.rootElement.body,
d);return k+"</office:document-content>"}function $(a,b){runtime.loadXML(a,function(a,d){if(a)b(a);else{var e=u(d);e&&"document"===e.localName&&"urn:oasis:names:tc:opendocument:xmlns:office:1.0"===e.namespaceURI?(A(e),C(c.DONE)):C(c.INVALID)}})}function x(a,b){var c;c=Q.rootElement;var e=c.meta;e||(c.meta=e=document.createElementNS("urn:oasis:names:tc:opendocument:xmlns:office:1.0","meta"),d(c,e));c=e;a&&l.mapKeyValObjOntoNode(c,a,odf.Namespaces.lookupNamespaceURI);b&&l.removeKeyElementsFromNode(c,
b,odf.Namespaces.lookupNamespaceURI)}function R(a){function b(a,c){var d;c||(c=a);d=document.createElementNS("urn:oasis:names:tc:opendocument:xmlns:office:1.0",c);k[a]=d;k.appendChild(d)}var d=new core.Zip("",null),e=runtime.byteArrayFromString("application/vnd.oasis.opendocument."+a,"utf8"),k=Q.rootElement,f=document.createElementNS("urn:oasis:names:tc:opendocument:xmlns:office:1.0",a);d.save("mimetype",e,!1,new Date);b("meta");b("settings");b("scripts");b("fontFaceDecls","font-face-decls");b("styles");
b("automaticStyles","automatic-styles");b("masterStyles","master-styles");b("body");k.body.appendChild(f);T["/"]="application/vnd.oasis.opendocument."+a;T["settings.xml"]="text/xml";T["meta.xml"]="text/xml";T["styles.xml"]="text/xml";T["content.xml"]="text/xml";C(c.DONE);return d}function N(a){var b=new core.Zip("",null);a=a.files;var c,d;for(c in a)a.hasOwnProperty(c)&&(d="string"===typeof a[c]?runtime.byteArrayFromString(a[c],"utf8"):a[c],b.save(c,d,!1,new Date));return b}function U(){var a,b=new Date,
c="";Q.rootElement.settings&&Q.rootElement.settings.firstElementChild&&(a=new xmldom.LSSerializer,c=aa("document-settings"),a.filter=new odf.OdfNodeFilter,c+=a.writeToString(Q.rootElement.settings,odf.Namespaces.namespaceMap),c+="</office:document-settings>");(a=c)?(a=runtime.byteArrayFromString(a,"utf8"),L.save("settings.xml",a,!0,b)):L.remove("settings.xml");c=runtime.getWindow();a="WebODF/"+webodf.Version;c&&(a=a+" "+c.navigator.userAgent);x({"meta:generator":a},null);a=runtime.byteArrayFromString(P(),
"utf8");L.save("meta.xml",a,!0,b);a=runtime.byteArrayFromString(ba(),"utf8");L.save("styles.xml",a,!0,b);a=runtime.byteArrayFromString(V(),"utf8");L.save("content.xml",a,!0,b);a=runtime.byteArrayFromString(Y(),"utf8");L.save("META-INF/manifest.xml",a,!0,b)}function H(a,b){U();L.writeAs(a,function(a){b(a)})}var Q=this,L,T={},X,B="",ja={};this.onstatereadychange=h;this.state=this.onchange=null;this.getMetadata=y;this.setRootElement=A;this.getContentElement=function(){var a;X||(a=Q.rootElement.body,
X=l.getDirectChild(a,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","text")||l.getDirectChild(a,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","presentation")||l.getDirectChild(a,"urn:oasis:names:tc:opendocument:xmlns:office:1.0","spreadsheet"));if(!X)throw"Could not find content element in <office:body/>.";return X};this.getDocumentType=function(){var a=Q.getContentElement();return a&&a.localName};this.getPart=function(a){return new odf.OdfPart(a,T[a],Q,L)};this.getPartData=function(a,b){L.load(a,
b)};this.setMetadata=x;this.incrementEditingCycles=function(){var a=y(odf.Namespaces.metans,"editing-cycles"),a=a?parseInt(a,10):0;isNaN(a)&&(a=0);x({"meta:editing-cycles":a+1},null);return a+1};this.createByteArray=function(a,b){U();L.createByteArray(a,b)};this.saveAs=H;this.save=function(a){H(B,a)};this.getUrl=function(){return B};this.setBlob=function(a,b,c){c=m.convertBase64ToByteArray(c);L.save(a,c,!1,new Date);T.hasOwnProperty(a)&&runtime.log(a+" has been overwritten.");T[a]=b};this.removeBlob=
function(a){var b=L.remove(a);runtime.assert(b,"file is not found: "+a);delete T[a]};this.state=c.LOADING;this.rootElement=function(a){var b=document.createElementNS(a.namespaceURI,a.localName),c;a=new a.Type;for(c in a)a.hasOwnProperty(c)&&(b[c]=a[c]);return b}({Type:odf.ODFDocumentElement,namespaceURI:odf.ODFDocumentElement.namespaceURI,localName:odf.ODFDocumentElement.localName});a===odf.OdfContainer.DocumentType.TEXT?L=R("text"):a===odf.OdfContainer.DocumentType.PRESENTATION?L=R("presentation"):
a===odf.OdfContainer.DocumentType.SPREADSHEET?L=R("spreadsheet"):(ja=a,ja.type===odf.OdfContainer.DocumentType.OOX?(L=N(ja),I()):(B=a,L=new core.Zip(B,function(a,b){L=b;a?$(B,function(b){a&&(L.error=a+"\n"+b,C(c.INVALID))}):I()})))};odf.OdfContainer.EMPTY=0;odf.OdfContainer.LOADING=1;odf.OdfContainer.DONE=2;odf.OdfContainer.INVALID=3;odf.OdfContainer.SAVING=4;odf.OdfContainer.MODIFIED=5;odf.OdfContainer.getContainer=function(b){return new odf.OdfContainer(b,null)}})();
odf.OdfContainer.DocumentType={TEXT:1,PRESENTATION:2,SPREADSHEET:3,OOX:4};
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
odf.OdfUtils=function(){function h(a){return"image"===(a&&a.localName)&&a.namespaceURI===I}function g(a){return null!==a&&a.nodeType===Node.ELEMENT_NODE&&"frame"===a.localName&&a.namespaceURI===I&&"as-char"===a.getAttributeNS(W,"anchor-type")}function b(a){var b;(b="annotation"===(a&&a.localName)&&a.namespaceURI===odf.Namespaces.officens)||(b="div"===(a&&a.localName)&&"annotationWrapper"===a.className);return b}function d(a){return"a"===(a&&a.localName)&&a.namespaceURI===W}function e(a){var b=a&&
a.localName;return("p"===b||"h"===b)&&a.namespaceURI===W}function l(a){for(;a&&!e(a);)a=a.parentNode;return a}function f(a){return/^[ \t\r\n]+$/.test(a)}function p(a){if(null===a||a.nodeType!==Node.ELEMENT_NODE)return!1;var b=a.localName;return/^(span|p|h|a|meta)$/.test(b)&&a.namespaceURI===W||"span"===b&&"webodf-annotationHighlight"===a.className}function q(a){var b=a&&a.localName,c=!1;b&&(a=a.namespaceURI,a===W&&(c="s"===b||"tab"===b||"line-break"===b));return c}function m(a){return q(a)||g(a)||
b(a)}function r(a){var b=a&&a.localName,c=!1;b&&(a=a.namespaceURI,a===W&&(c="s"===b));return c}function c(a){return-1!==Y.indexOf(a.namespaceURI)}function a(b){if(q(b))return!1;if(c(b.parentNode)&&b.nodeType===Node.TEXT_NODE)return 0===b.textContent.length;for(b=b.firstChild;b;){if(c(b)||!a(b))return!1;b=b.nextSibling}return!0}function n(a){for(;null!==a.firstChild&&p(a);)a=a.firstChild;return a}function k(a){for(;null!==a.lastChild&&p(a);)a=a.lastChild;return a}function t(a){for(;!e(a)&&null===a.previousSibling;)a=
a.parentNode;return e(a)?null:k(a.previousSibling)}function s(a){for(;!e(a)&&null===a.nextSibling;)a=a.parentNode;return e(a)?null:n(a.nextSibling)}function y(a){for(var b=!1;a;)if(a.nodeType===Node.TEXT_NODE)if(0===a.length)a=t(a);else return!f(a.data.substr(a.length-1,1));else m(a)?(b=!1===r(a),a=null):a=t(a);return b}function z(a){var b=!1,c;for(a=a&&n(a);a;){c=a.nodeType===Node.TEXT_NODE?a.length:0;if(0<c&&!f(a.data)){b=!0;break}if(m(a)){b=!0;break}a=s(a)}return b}function w(a,b){return f(a.data.substr(b))?
!z(s(a)):!1}function v(a,b){var c=a.data,d;if(!f(c[b])||m(a.parentNode))return!1;0<b?f(c[b-1])||(d=!0):y(t(a))&&(d=!0);return!0===d?w(a,b)?!1:!0:!1}function u(a){return(a=/(-?[0-9]*[0-9][0-9]*(\.[0-9]*)?|0+\.[0-9]*[1-9][0-9]*|\.[0-9]*[1-9][0-9]*)((cm)|(mm)|(in)|(pt)|(pc)|(px)|(%))/.exec(a))?{value:parseFloat(a[1]),unit:a[3]}:null}function C(a){return(a=u(a))&&(0>a.value||"%"===a.unit)?null:a}function A(a){return(a=u(a))&&"%"!==a.unit?null:a}function D(a){switch(a.namespaceURI){case odf.Namespaces.drawns:case odf.Namespaces.svgns:case odf.Namespaces.dr3dns:return!1;
case odf.Namespaces.textns:switch(a.localName){case "note-body":case "ruby-text":return!1}break;case odf.Namespaces.officens:switch(a.localName){case "annotation":case "binary-data":case "event-listeners":return!1}break;default:switch(a.localName){case "cursor":case "editinfo":return!1}}return!0}function G(a,b){for(;0<b.length&&!M.rangeContainsNode(a,b[0]);)b.shift();for(;0<b.length&&!M.rangeContainsNode(a,b[b.length-1]);)b.pop()}function J(a,c,d){var e;e=M.getNodesInRange(a,function(a){var c=NodeFilter.FILTER_REJECT;
if(q(a.parentNode)||b(a))c=NodeFilter.FILTER_REJECT;else if(a.nodeType===Node.TEXT_NODE){if(d||Boolean(l(a)&&(!f(a.textContent)||v(a,0))))c=NodeFilter.FILTER_ACCEPT}else if(m(a))c=NodeFilter.FILTER_ACCEPT;else if(D(a)||p(a))c=NodeFilter.FILTER_SKIP;return c},NodeFilter.SHOW_ELEMENT|NodeFilter.SHOW_TEXT);c||G(a,e);return e}function O(a,c,d){for(;a;){if(d(a)){c[0]!==a&&c.unshift(a);break}if(b(a))break;a=a.parentNode}}function K(a,b){var c=a;if(b<c.childNodes.length-1)c=c.childNodes[b+1];else{for(;!c.nextSibling;)c=
c.parentNode;c=c.nextSibling}for(;c.firstChild;)c=c.firstChild;return c}var W=odf.Namespaces.textns,I=odf.Namespaces.drawns,aa=odf.Namespaces.xlinkns,P=/^\s*$/,M=new core.DomUtils,Y=[odf.Namespaces.dbns,odf.Namespaces.dcns,odf.Namespaces.dr3dns,odf.Namespaces.drawns,odf.Namespaces.chartns,odf.Namespaces.formns,odf.Namespaces.numberns,odf.Namespaces.officens,odf.Namespaces.presentationns,odf.Namespaces.stylens,odf.Namespaces.svgns,odf.Namespaces.tablens,odf.Namespaces.textns];this.isImage=h;this.isCharacterFrame=
g;this.isInlineRoot=b;this.isTextSpan=function(a){return"span"===(a&&a.localName)&&a.namespaceURI===W};this.isHyperlink=d;this.getHyperlinkTarget=function(a){return a.getAttributeNS(aa,"href")||""};this.isParagraph=e;this.getParagraphElement=l;this.isWithinTrackedChanges=function(a,b){for(;a&&a!==b;){if(a.namespaceURI===W&&"tracked-changes"===a.localName)return!0;a=a.parentNode}return!1};this.isListItem=function(a){return"list-item"===(a&&a.localName)&&a.namespaceURI===W};this.isLineBreak=function(a){return"line-break"===
(a&&a.localName)&&a.namespaceURI===W};this.isODFWhitespace=f;this.isGroupingElement=p;this.isCharacterElement=q;this.isAnchoredAsCharacterElement=m;this.isSpaceElement=r;this.isODFNode=c;this.hasNoODFContent=a;this.firstChild=n;this.lastChild=k;this.previousNode=t;this.nextNode=s;this.scanLeftForNonSpace=y;this.lookLeftForCharacter=function(a){var b,c=b=0;a.nodeType===Node.TEXT_NODE&&(c=a.length);0<c?(b=a.data,b=f(b.substr(c-1,1))?1===c?y(t(a))?2:0:f(b.substr(c-2,1))?0:2:1):m(a)&&(b=1);return b};
this.lookRightForCharacter=function(a){var b=!1,c=0;a&&a.nodeType===Node.TEXT_NODE&&(c=a.length);0<c?b=!f(a.data.substr(0,1)):m(a)&&(b=!0);return b};this.scanLeftForAnyCharacter=function(a){var b=!1,c;for(a=a&&k(a);a;){c=a.nodeType===Node.TEXT_NODE?a.length:0;if(0<c&&!f(a.data)){b=!0;break}if(m(a)){b=!0;break}a=t(a)}return b};this.scanRightForAnyCharacter=z;this.isTrailingWhitespace=w;this.isSignificantWhitespace=v;this.isDowngradableSpaceElement=function(a){return r(a)?y(t(a))&&z(s(a)):!1};this.getFirstNonWhitespaceChild=
function(a){for(a=a&&a.firstChild;a&&a.nodeType===Node.TEXT_NODE&&P.test(a.nodeValue);)a=a.nextSibling;return a};this.parseLength=u;this.parseNonNegativeLength=C;this.parseFoFontSize=function(a){var b;b=(b=u(a))&&(0>=b.value||"%"===b.unit)?null:b;return b||A(a)};this.parseFoLineHeight=function(a){return C(a)||A(a)};this.isTextContentContainingNode=D;this.getTextNodes=function(a,b){var c;c=M.getNodesInRange(a,function(a){var b=NodeFilter.FILTER_REJECT;a.nodeType===Node.TEXT_NODE?Boolean(l(a)&&(!f(a.textContent)||
v(a,0)))&&(b=NodeFilter.FILTER_ACCEPT):D(a)&&(b=NodeFilter.FILTER_SKIP);return b},NodeFilter.SHOW_ELEMENT|NodeFilter.SHOW_TEXT);b||G(a,c);return c};this.getTextElements=J;this.getParagraphElements=function(a){var b;b=M.getNodesInRange(a,function(a){var b=NodeFilter.FILTER_REJECT;if(e(a))b=NodeFilter.FILTER_ACCEPT;else if(D(a)||p(a))b=NodeFilter.FILTER_SKIP;return b},NodeFilter.SHOW_ELEMENT);O(a.startContainer,b,e);return b};this.getImageElements=function(a){var b;b=M.getNodesInRange(a,function(a){var b=
NodeFilter.FILTER_SKIP;h(a)&&(b=NodeFilter.FILTER_ACCEPT);return b},NodeFilter.SHOW_ELEMENT);O(a.startContainer,b,h);return b};this.getHyperlinkElements=function(a){var b=[],c=a.cloneRange();a.collapsed&&a.endContainer.nodeType===Node.ELEMENT_NODE&&(a=K(a.endContainer,a.endOffset),a.nodeType===Node.TEXT_NODE&&c.setEnd(a,1));J(c,!0,!1).forEach(function(a){for(a=a.parentNode;!e(a);){if(d(a)&&-1===b.indexOf(a)){b.push(a);break}a=a.parentNode}});c.detach();return b};this.getNormalizedFontFamilyName=function(a){/^(["'])(?:.|[\n\r])*?\1$/.test(a)||
(a=a.replace(/^[ \t\r\n\f]*((?:.|[\n\r])*?)[ \t\r\n\f]*$/,"$1"),/[ \t\r\n\f]/.test(a)&&(a="'"+a.replace(/[ \t\r\n\f]+/g," ")+"'"));return a}};
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
gui.AnnotatableCanvas=function(){};gui.AnnotatableCanvas.prototype.refreshSize=function(){};gui.AnnotatableCanvas.prototype.getZoomLevel=function(){};gui.AnnotatableCanvas.prototype.getSizer=function(){};
gui.AnnotationViewManager=function(h,g,b,d){function e(a){var b=a.annotationEndElement,c=m.createRange(),d=a.getAttributeNS(odf.Namespaces.officens,"name");b&&(c.setStart(a,a.childNodes.length),c.setEnd(b,0),a=r.getTextNodes(c,!1),a.forEach(function(a){var b=m.createElement("span");b.className="webodf-annotationHighlight";b.setAttribute("annotation",d);a.parentNode.insertBefore(b,a);b.appendChild(a)}));c.detach()}function l(a){var d=h.getSizer();a?(b.style.display="inline-block",d.style.paddingRight=
c.getComputedStyle(b).width):(b.style.display="none",d.style.paddingRight=0);h.refreshSize()}function f(){q.sort(function(a,b){return 0!==(a.compareDocumentPosition(b)&Node.DOCUMENT_POSITION_FOLLOWING)?-1:1})}function p(){var a;for(a=0;a<q.length;a+=1){var c=q[a],d=c.parentNode,e=d.nextElementSibling,f=e.nextElementSibling,g=d.parentNode,l=0,l=q[q.indexOf(c)-1],r=void 0,c=h.getZoomLevel();d.style.left=(b.getBoundingClientRect().left-g.getBoundingClientRect().left)/c+"px";d.style.width=b.getBoundingClientRect().width/
c+"px";e.style.width=parseFloat(d.style.left)-30+"px";l&&(r=l.parentNode.getBoundingClientRect(),20>=(g.getBoundingClientRect().top-r.bottom)/c?d.style.top=Math.abs(g.getBoundingClientRect().top-r.bottom)/c+20+"px":d.style.top="0px");f.style.left=e.getBoundingClientRect().width/c+"px";var e=f.style,g=f.getBoundingClientRect().left/c,l=f.getBoundingClientRect().top/c,r=d.getBoundingClientRect().left/c,m=d.getBoundingClientRect().top/c,p=0,C=0,p=r-g,p=p*p,C=m-l,C=C*C,g=Math.sqrt(p+C);e.width=g+"px";
l=Math.asin((d.getBoundingClientRect().top-f.getBoundingClientRect().top)/(c*parseFloat(f.style.width)));f.style.transform="rotate("+l+"rad)";f.style.MozTransform="rotate("+l+"rad)";f.style.WebkitTransform="rotate("+l+"rad)";f.style.msTransform="rotate("+l+"rad)"}}var q=[],m=g.ownerDocument,r=new odf.OdfUtils,c=runtime.getWindow();runtime.assert(Boolean(c),"Expected to be run in an environment which has a global window, like a browser.");this.rerenderAnnotations=p;this.getMinimumHeightForAnnotationPane=
function(){return"none"!==b.style.display&&0<q.length?(q[q.length-1].parentNode.getBoundingClientRect().bottom-b.getBoundingClientRect().top)/h.getZoomLevel()+"px":null};this.addAnnotation=function(a){l(!0);q.push(a);f();var b=m.createElement("div"),c=m.createElement("div"),g=m.createElement("div"),h=m.createElement("div"),r;b.className="annotationWrapper";a.parentNode.insertBefore(b,a);c.className="annotationNote";c.appendChild(a);d&&(r=m.createElement("div"),r.className="annotationRemoveButton",
c.appendChild(r));g.className="annotationConnector horizontal";h.className="annotationConnector angular";b.appendChild(c);b.appendChild(g);b.appendChild(h);a.annotationEndElement&&e(a);p()};this.forgetAnnotations=function(){for(;q.length;){var a=q[0],b=q.indexOf(a),c=a.parentNode.parentNode;"div"===c.localName&&(c.parentNode.insertBefore(a,c),c.parentNode.removeChild(c));for(var a=a.getAttributeNS(odf.Namespaces.officens,"name"),a=m.querySelectorAll('span.webodf-annotationHighlight[annotation="'+
a+'"]'),d=c=void 0,c=0;c<a.length;c+=1){for(d=a.item(c);d.firstChild;)d.parentNode.insertBefore(d.firstChild,d);d.parentNode.removeChild(d)}-1!==b&&q.splice(b,1);0===q.length&&l(!1)}}};
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
(function(){function h(b,g,f,p,q){var m,r=0,c;for(c in b)if(b.hasOwnProperty(c)){if(r===f){m=c;break}r+=1}m?g.getPartData(b[m].href,function(a,c){if(a)runtime.log(a);else if(c){var k="@font-face { font-family: "+(b[m].family||m)+"; src: url(data:application/x-font-ttf;charset=binary;base64,"+d.convertUTF8ArrayToBase64(c)+') format("truetype"); }';try{p.insertRule(k,p.cssRules.length)}catch(r){runtime.log("Problem inserting rule in CSS: "+runtime.toJson(r)+"\nRule: "+k)}}else runtime.log("missing font data for "+
b[m].href);h(b,g,f+1,p,q)}):q&&q()}var g=xmldom.XPath,b=new odf.OdfUtils,d=new core.Base64;odf.FontLoader=function(){this.loadFonts=function(d,l){for(var f=d.rootElement.fontFaceDecls;l.cssRules.length;)l.deleteRule(l.cssRules.length-1);if(f){var p={},q,m,r,c;if(f)for(f=g.getODFElementsWithXPath(f,"style:font-face[svg:font-face-src]",odf.Namespaces.lookupNamespaceURI),q=0;q<f.length;q+=1)m=f[q],r=m.getAttributeNS(odf.Namespaces.stylens,"name"),c=b.getNormalizedFontFamilyName(m.getAttributeNS(odf.Namespaces.svgns,
"font-family")),m=g.getODFElementsWithXPath(m,"svg:font-face-src/svg:font-face-uri",odf.Namespaces.lookupNamespaceURI),0<m.length&&(m=m[0].getAttributeNS(odf.Namespaces.xlinkns,"href"),p[r]={href:m,family:c});h(p,d,0,l)}}}})();
// Input 33
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
odf.Formatting=function(){function h(a){return(a=C[a])?v.mergeObjects({},a):{}}function g(){for(var a=c.rootElement.fontFaceDecls,b={},d,e,a=a&&a.firstElementChild;a;){if(d=a.getAttributeNS(k,"name"))if((e=a.getAttributeNS(n,"font-family"))||0<a.getElementsByTagNameNS(n,"font-face-uri").length)b[d]=e;a=a.nextElementSibling}return b}function b(a){for(var b=c.rootElement.styles.firstElementChild;b;){if(b.namespaceURI===k&&"default-style"===b.localName&&b.getAttributeNS(k,"family")===a)return b;b=b.nextElementSibling}return null}
function d(a,b,d){var e,f,g;d=d||[c.rootElement.automaticStyles,c.rootElement.styles];for(g=0;g<d.length;g+=1)for(e=d[g],e=e.firstElementChild;e;){f=e.getAttributeNS(k,"name");if(e.namespaceURI===k&&"style"===e.localName&&e.getAttributeNS(k,"family")===b&&f===a||"list-style"===b&&e.namespaceURI===t&&"list-style"===e.localName&&f===a||"data"===b&&e.namespaceURI===s&&f===a)return e;e=e.nextElementSibling}return null}function e(a){for(var b,c,d,e,f={},g=a.firstElementChild;g;){if(g.namespaceURI===k)for(d=
f[g.nodeName]={},c=g.attributes,b=0;b<c.length;b+=1)e=c.item(b),d[e.name]=e.value;g=g.nextElementSibling}c=a.attributes;for(b=0;b<c.length;b+=1)e=c.item(b),f[e.name]=e.value;return f}function l(a,f){for(var g=c.rootElement.styles,l,n={},r=a.getAttributeNS(k,"family"),m=a;m;)l=e(m),n=v.mergeObjects(l,n),m=(l=m.getAttributeNS(k,"parent-style-name"))?d(l,r,[g]):null;if(m=b(r))l=e(m),n=v.mergeObjects(l,n);!1!==f&&(l=h(r),n=v.mergeObjects(l,n));return n}function f(b,c){function d(a){Object.keys(a).forEach(function(b){Object.keys(a[b]).forEach(function(a){g+=
"|"+b+":"+a+"|"})})}for(var e=b.nodeType===Node.TEXT_NODE?b.parentNode:b,k,f=[],g="",h=!1;e;)!h&&z.isGroupingElement(e)&&(h=!0),(k=a.determineStylesForNode(e))&&f.push(k),e=e.parentNode;h&&(f.forEach(d),c&&(c[g]=f));return h?f:void 0}function p(a){var b={orderedStyles:[]};a.forEach(function(a){Object.keys(a).forEach(function(e){var f=Object.keys(a[e])[0],g={name:f,family:e,displayName:void 0,isCommonStyle:!1},h;(h=d(f,e))?(e=l(h),b=v.mergeObjects(e,b),g.displayName=h.getAttributeNS(k,"display-name")||
void 0,g.isCommonStyle=h.parentNode===c.rootElement.styles):runtime.log("No style element found for '"+f+"' of family '"+e+"'");b.orderedStyles.push(g)})});return b}function q(a,b){var c={},d=[];b||(b={});a.forEach(function(a){f(a,c)});Object.keys(c).forEach(function(a){b[a]||(b[a]=p(c[a]));d.push(b[a])});return d}function m(a){for(var b=c.rootElement.masterStyles.firstElementChild;b&&(b.namespaceURI!==k||"master-page"!==b.localName||b.getAttributeNS(k,"name")!==a);)b=b.nextElementSibling;return b}
function r(a,b){var c;a&&(c=u.convertMeasure(a,"px"));void 0===c&&b&&(c=u.convertMeasure(b,"px"));return c}var c,a=new odf.StyleInfo,n=odf.Namespaces.svgns,k=odf.Namespaces.stylens,t=odf.Namespaces.textns,s=odf.Namespaces.numberns,y=odf.Namespaces.fons,z=new odf.OdfUtils,w=new core.DomUtils,v=new core.Utils,u=new core.CSSUnits,C={paragraph:{"style:paragraph-properties":{"fo:text-align":"left"}}};this.getSystemDefaultStyleAttributes=h;this.setOdfContainer=function(a){c=a};this.getFontMap=g;this.getAvailableParagraphStyles=
function(){for(var a=c.rootElement.styles,b,d,e=[],a=a&&a.firstElementChild;a;)"style"===a.localName&&a.namespaceURI===k&&(b=a.getAttributeNS(k,"family"),"paragraph"===b&&(b=a.getAttributeNS(k,"name"),d=a.getAttributeNS(k,"display-name")||b,b&&d&&e.push({name:b,displayName:d}))),a=a.nextElementSibling;return e};this.isStyleUsed=function(b){var d,e=c.rootElement;d=a.hasDerivedStyles(e,odf.Namespaces.lookupNamespaceURI,b);b=(new a.UsedStyleList(e.styles)).uses(b)||(new a.UsedStyleList(e.automaticStyles)).uses(b)||
(new a.UsedStyleList(e.body)).uses(b);return d||b};this.getDefaultStyleElement=b;this.getStyleElement=d;this.getStyleAttributes=e;this.getInheritedStyleAttributes=l;this.getFirstCommonParentStyleNameOrSelf=function(a){var b=c.rootElement.styles,e;if(e=d(a,"paragraph",[c.rootElement.automaticStyles]))if(a=e.getAttributeNS(k,"parent-style-name"),!a)return null;return(e=d(a,"paragraph",[b]))?a:null};this.hasParagraphStyle=function(a){return Boolean(d(a,"paragraph"))};this.getAppliedStyles=q;this.getAppliedStylesForElement=
function(a,b){return q([a],b)[0]};this.updateStyle=function(a,b){var d,e;w.mapObjOntoNode(a,b,odf.Namespaces.lookupNamespaceURI);(d=b["style:text-properties"]&&b["style:text-properties"]["style:font-name"])&&!g().hasOwnProperty(d)&&(e=a.ownerDocument.createElementNS(k,"style:font-face"),e.setAttributeNS(k,"style:name",d),e.setAttributeNS(n,"svg:font-family",d),c.rootElement.fontFaceDecls.appendChild(e))};this.createDerivedStyleObject=function(a,b,k){var f=d(a,b);runtime.assert(Boolean(f),"No style element found for '"+
a+"' of family '"+b+"'");a=f.parentNode===c.rootElement.styles?{"style:parent-style-name":a}:e(f);a["style:family"]=b;v.mergeObjects(a,k);return a};this.getDefaultTabStopDistance=function(){for(var a=b("paragraph"),a=a&&a.firstElementChild,c;a;)a.namespaceURI===k&&"paragraph-properties"===a.localName&&(c=a.getAttributeNS(k,"tab-stop-distance")),a=a.nextElementSibling;c||(c="1.25cm");return z.parseNonNegativeLength(c)};this.getMasterPageElement=m;this.getContentSize=function(a,b){var e,f,g,h,l,n,p,
q,t,s;a:{f=d(a,b);runtime.assert("paragraph"===b||"table"===b,"styleFamily must be either paragraph or table");if(f){if(f=f.getAttributeNS(k,"master-page-name"))(e=m(f))||runtime.log("WARN: No master page definition found for "+f);e||(e=m("Standard"));e||(e=c.rootElement.masterStyles.getElementsByTagNameNS(k,"master-page")[0])||runtime.log("WARN: Document has no master pages defined");if(e)for(f=e.getAttributeNS(k,"page-layout-name"),g=w.getElementsByTagNameNS(c.rootElement.automaticStyles,k,"page-layout"),
h=0;h<g.length;h+=1)if(e=g[h],e.getAttributeNS(k,"name")===f)break a}e=null}e||(e=w.getDirectChild(c.rootElement.styles,k,"default-page-layout"));(e=w.getDirectChild(e,k,"page-layout-properties"))?("landscape"===e.getAttributeNS(k,"print-orientation")?(f="29.7cm",g="21.001cm"):(f="21.001cm",g="29.7cm"),f=r(e.getAttributeNS(y,"page-width"),f),g=r(e.getAttributeNS(y,"page-height"),g),h=r(e.getAttributeNS(y,"margin")),void 0===h?(h=r(e.getAttributeNS(y,"margin-left"),"2cm"),l=r(e.getAttributeNS(y,"margin-right"),
"2cm"),n=r(e.getAttributeNS(y,"margin-top"),"2cm"),p=r(e.getAttributeNS(y,"margin-bottom"),"2cm")):h=l=n=p=h,q=r(e.getAttributeNS(y,"padding")),void 0===q?(q=r(e.getAttributeNS(y,"padding-left"),"0cm"),t=r(e.getAttributeNS(y,"padding-right"),"0cm"),s=r(e.getAttributeNS(y,"padding-top"),"0cm"),e=r(e.getAttributeNS(y,"padding-bottom"),"0cm")):q=t=s=e=q):(f=r("21.001cm"),g=r("29.7cm"),h=l=n=p=h=r("2cm"),q=t=s=e=q=r("0cm"));return{width:f-h-l-q-t,height:g-n-p-s-e}}};
// Input 34
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
(function(){var h=odf.Namespaces.stylens,g=odf.Namespaces.textns,b={graphic:"draw","drawing-page":"draw",paragraph:"text",presentation:"presentation",ruby:"text",section:"text",table:"table","table-cell":"table","table-column":"table","table-row":"table",text:"text",list:"text",page:"office"};odf.StyleTreeNode=function(b){this.derivedStyles={};this.element=b};odf.StyleTree=function(d,e){function l(b){var c,a,d,e={};if(!b)return e;for(b=b.firstElementChild;b;){if(a=b.namespaceURI!==h||"style"!==b.localName&&
"default-style"!==b.localName?b.namespaceURI===g&&"list-style"===b.localName?"list":b.namespaceURI!==h||"page-layout"!==b.localName&&"default-page-layout"!==b.localName?void 0:"page":b.getAttributeNS(h,"family"))(c=b.getAttributeNS(h,"name"))||(c=""),e.hasOwnProperty(a)?d=e[a]:e[a]=d={},d[c]=b;b=b.nextElementSibling}return e}function f(b,c){if(b.hasOwnProperty(c))return b[c];var a=null,d=Object.keys(b),e;for(e=0;e<d.length&&!(a=f(b[d[e]].derivedStyles,c));e+=1);return a}function p(b,c,a){var d,e,
g;if(!c.hasOwnProperty(b))return null;d=new odf.StyleTreeNode(c[b]);e=d.element.getAttributeNS(h,"parent-style-name");g=null;e&&(g=f(a,e)||p(e,c,a));g?g.derivedStyles[b]=d:a[b]=d;delete c[b];return d}function q(b,c){b&&Object.keys(b).forEach(function(a){p(a,b,c)})}var m={};this.getStyleTree=function(){return m};(function(){var f,c,a;c=l(d);a=l(e);Object.keys(b).forEach(function(b){f=m[b]={};q(c[b],f);q(a[b],f)})})()}})();
// Input 35
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
(function(){var h=odf.Namespaces.fons,g=odf.Namespaces.stylens,b=odf.Namespaces.textns,d={1:"decimal",a:"lower-latin",A:"upper-latin",i:"lower-roman",I:"upper-roman"};odf.ListStyleToCss=function(){function e(b){var c=m.parseLength(b);return c?q.convert(c.value,c.unit,"px"):(runtime.log("Could not parse value '"+b+"'."),0)}function l(b,c){try{b.insertRule(c,b.cssRules.length)}catch(a){runtime.log("cannot load rule: "+c+" - "+a)}}function f(b){return b.replace(/\\/g,"\\\\").replace(/"/g,'\\"')}function p(d,
c,a,f){c='text|list[text|style-name="'+c+'"]';for(var k=a.getAttributeNS(b,"level"),m,p,q,z,w,v,k=k&&parseInt(k,10);1<k;)c+=" > text|list-item > text|list",k-=1;(k=a.getElementsByTagNameNS(g,"list-level-properties")[0])?(m=k.getAttributeNS(b,"list-level-position-and-space-mode"),q=k.getAttributeNS(h,"text-align")||"left","label-alignment"===m?(p=k.getElementsByTagNameNS(g,"list-level-label-alignment")[0],a=p.getAttributeNS(h,"margin-left")||"0px",v=p.getAttributeNS(h,"text-indent")||"0px",p=p.getAttributeNS(b,
"label-followed-by"),k=e(a)):(a=k.getAttributeNS(b,"space-before")||"0px",z=k.getAttributeNS(b,"min-label-width")||"0px",w=k.getAttributeNS(b,"min-label-distance")||"0px",k=e(a)+e(z))):(w=z="0px",k=e("0px")+e(z));switch(q){case "end":q="right";break;case "start":q="left"}a=c+" > text|list-item{";a+="margin-left: "+k+"px;";a+="}";l(d,a);a=c+" > text|list-item > text|list{";a+="margin-left: "+-k+"px;";a+="}";l(d,a);a=c+" > text|list-item > *:not(text|list):first-child:before{";a+="text-align: "+q+";";
a+="counter-increment:list;";a+="display: inline-block;";"label-alignment"===m?(a+="margin-left: "+v+";","space"===p?f+=" '\\a0'":"listtab"===p&&(a+="padding-right: 0.2cm;")):(a+="min-width: "+z+";",a+="margin-left: -"+z+";",a+="padding-right: "+w+";");a+="\n"+f+";\n";a+="}";l(d,a)}var q=new core.CSSUnits,m=new odf.OdfUtils;this.applyListStyles=function(e,c){var a,h;(a=c.list)&&Object.keys(a).forEach(function(c){h=a[c];for(var l=h.element.firstChild,m,q;l;){if(l.namespaceURI===b)if(m=l,"list-level-style-number"===
l.localName){var z=m;q=z.getAttributeNS(g,"num-format");var w=z.getAttributeNS(g,"num-suffix")||"",z=z.getAttributeNS(g,"num-prefix")||"",v="";z&&(v+='"'+f(z)+'"\n');v=d.hasOwnProperty(q)?v+(" counter(list, "+d[q]+")"):q?v+(' "'+q+'"'):v+' ""';q="content:"+v+' "'+f(w)+'"';p(e,c,m,q)}else"list-level-style-image"===l.localName?(q="content: none",p(e,c,m,q)):"list-level-style-bullet"===l.localName&&(q=m.getAttributeNS(b,"bullet-char"),q='content: "'+f(q)+'"',p(e,c,m,q));l=l.nextSibling}})}}})();
// Input 36
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
odf.Style2CSS=function(){function h(a,b,c){var d=[];c=c.derivedStyles;var e;var f=k[a],g;void 0===f?b=null:(g=b?"["+f+'|style-name="'+b+'"]':"","presentation"===f&&(f="draw",g=b?'[presentation|style-name="'+b+'"]':""),b=f+"|"+t[a].join(g+","+f+"|")+g);null!==b&&d.push(b);for(e in c)c.hasOwnProperty(e)&&(b=h(a,e,c[e]),d=d.concat(b));return d}function g(a,b){var c="",d,e,f;for(d=0;d<b.length;d+=1)if(e=b[d],f=a.getAttributeNS(e[0],e[1])){f=f.trim();if(J.hasOwnProperty(e[1])){var k=f.indexOf(" "),g=void 0,
h=void 0;-1!==k?(g=f.substring(0,k),h=f.substring(k)):(g=f,h="");(g=K.parseLength(g))&&"pt"===g.unit&&0.75>g.value&&(f="0.75pt"+h)}e[2]&&(c+=e[2]+":"+f+";")}return c}function b(a){return(a=n.getDirectChild(a,q,"text-properties"))?K.parseFoFontSize(a.getAttributeNS(f,"font-size")):null}function d(a,b,c,d){return b+b+c+c+d+d}function e(k,m,t,J){if("page"===m){var x=J.element;t="";var R,N;N=R="";var U=n.getDirectChild(x,q,"page-layout-properties"),H;if(U)if(H=x.getAttributeNS(q,"name"),t+=g(U,D),(R=
n.getDirectChild(U,q,"background-image"))&&(N=R.getAttributeNS(c,"href"))&&(t=t+("background-image: url('odfkit:"+N+"');")+g(R,y)),"presentation"===W)for(x=(x=n.getDirectChild(x.parentNode.parentNode,p,"master-styles"))&&x.firstElementChild;x;)x.namespaceURI===q&&"master-page"===x.localName&&x.getAttributeNS(q,"page-layout-name")===H&&(N=x.getAttributeNS(q,"name"),R="draw|page[draw|master-page-name="+N+"] {"+t+"}",N="office|body, draw|page[draw|master-page-name="+N+"] {"+g(U,G)+" }",k.insertRule(R,
k.cssRules.length),k.insertRule(N,k.cssRules.length)),x=x.nextElementSibling;else"text"===W&&(R="office|text {"+t+"}",N="office|body {width: "+U.getAttributeNS(f,"page-width")+";}",k.insertRule(R,k.cssRules.length),k.insertRule(N,k.cssRules.length))}else{t=h(m,t,J).join(",");U="";if(H=n.getDirectChild(J.element,q,"text-properties")){N=H;var Q,L,x=Q="";R=1;H=""+g(N,s);L=N.getAttributeNS(q,"text-underline-style");"solid"===L&&(Q+=" underline");L=N.getAttributeNS(q,"text-line-through-style");"solid"===
L&&(Q+=" line-through");Q.length&&(H+="text-decoration:"+Q+";");if(Q=N.getAttributeNS(q,"font-name")||N.getAttributeNS(f,"font-family"))L=O[Q],H+="font-family: "+(L||Q)+";";L=N.parentNode;if(N=b(L)){for(;L;){if(N=b(L)){if("%"!==N.unit){x="font-size: "+N.value*R+N.unit+";";break}R*=N.value/100}N=L;Q=L="";L=null;"default-style"===N.localName?L=null:(L=N.getAttributeNS(q,"parent-style-name"),Q=N.getAttributeNS(q,"family"),L=P.getODFElementsWithXPath(I,L?"//style:*[@style:name='"+L+"'][@style:family='"+
Q+"']":"//style:default-style[@style:family='"+Q+"']",odf.Namespaces.lookupNamespaceURI)[0])}x||(x="font-size: "+parseFloat(aa)*R+M.getUnits(aa)+";");H+=x}U+=H}if(H=n.getDirectChild(J.element,q,"paragraph-properties"))x=H,H=""+g(x,z),(R=n.getDirectChild(x,q,"background-image"))&&(N=R.getAttributeNS(c,"href"))&&(H=H+("background-image: url('odfkit:"+N+"');")+g(R,y)),(x=x.getAttributeNS(f,"line-height"))&&"normal"!==x&&(x=K.parseFoLineHeight(x),H="%"!==x.unit?H+("line-height: "+x.value+x.unit+";"):
H+("line-height: "+x.value/100+";")),U+=H;if(H=n.getDirectChild(J.element,q,"graphic-properties"))N=H,H=""+g(N,w),x=N.getAttributeNS(l,"opacity"),R=N.getAttributeNS(l,"fill"),N=N.getAttributeNS(l,"fill-color"),"solid"===R||"hatch"===R?N&&"none"!==N?(x=isNaN(parseFloat(x))?1:parseFloat(x)/100,R=N.replace(/^#?([a-f\d])([a-f\d])([a-f\d])$/i,d),(N=(R=/^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(R))?{r:parseInt(R[1],16),g:parseInt(R[2],16),b:parseInt(R[3],16)}:null)&&(H+="background-color: rgba("+
N.r+","+N.g+","+N.b+","+x+");")):H+="background: none;":"none"===R&&(H+="background: none;"),U+=H;if(H=n.getDirectChild(J.element,q,"drawing-page-properties"))x=""+g(H,w),"true"===H.getAttributeNS(a,"background-visible")&&(x+="background: none;"),U+=x;if(H=n.getDirectChild(J.element,q,"table-cell-properties"))H=""+g(H,v),U+=H;if(H=n.getDirectChild(J.element,q,"table-row-properties"))H=""+g(H,C),U+=H;if(H=n.getDirectChild(J.element,q,"table-column-properties"))H=""+g(H,u),U+=H;if(H=n.getDirectChild(J.element,
q,"table-properties"))x=H,H=""+g(x,A),x=x.getAttributeNS(r,"border-model"),"collapsing"===x?H+="border-collapse:collapse;":"separating"===x&&(H+="border-collapse:separate;"),U+=H;0!==U.length&&k.insertRule(t+"{"+U+"}",k.cssRules.length)}for(var T in J.derivedStyles)J.derivedStyles.hasOwnProperty(T)&&e(k,m,T,J.derivedStyles[T])}var l=odf.Namespaces.drawns,f=odf.Namespaces.fons,p=odf.Namespaces.officens,q=odf.Namespaces.stylens,m=odf.Namespaces.svgns,r=odf.Namespaces.tablens,c=odf.Namespaces.xlinkns,
a=odf.Namespaces.presentationns,n=new core.DomUtils,k={graphic:"draw","drawing-page":"draw",paragraph:"text",presentation:"presentation",ruby:"text",section:"text",table:"table","table-cell":"table","table-column":"table","table-row":"table",text:"text",list:"text",page:"office"},t={graphic:"circle connected control custom-shape ellipse frame g line measure page page-thumbnail path polygon polyline rect regular-polygon".split(" "),paragraph:"alphabetical-index-entry-template h illustration-index-entry-template index-source-style object-index-entry-template p table-index-entry-template table-of-content-entry-template user-index-entry-template".split(" "),
presentation:"caption circle connector control custom-shape ellipse frame g line measure page-thumbnail path polygon polyline rect regular-polygon".split(" "),"drawing-page":"caption circle connector control page custom-shape ellipse frame g line measure page-thumbnail path polygon polyline rect regular-polygon".split(" "),ruby:["ruby","ruby-text"],section:"alphabetical-index bibliography illustration-index index-title object-index section table-of-content table-index user-index".split(" "),table:["background",
"table"],"table-cell":"body covered-table-cell even-columns even-rows first-column first-row last-column last-row odd-columns odd-rows table-cell".split(" "),"table-column":["table-column"],"table-row":["table-row"],text:"a index-entry-chapter index-entry-link-end index-entry-link-start index-entry-page-number index-entry-span index-entry-tab-stop index-entry-text index-title-template linenumbering-configuration list-level-style-number list-level-style-bullet outline-level-style span".split(" "),
list:["list-item"]},s=[[f,"color","color"],[f,"background-color","background-color"],[f,"font-weight","font-weight"],[f,"font-style","font-style"]],y=[[q,"repeat","background-repeat"]],z=[[f,"background-color","background-color"],[f,"text-align","text-align"],[f,"text-indent","text-indent"],[f,"padding","padding"],[f,"padding-left","padding-left"],[f,"padding-right","padding-right"],[f,"padding-top","padding-top"],[f,"padding-bottom","padding-bottom"],[f,"border-left","border-left"],[f,"border-right",
"border-right"],[f,"border-top","border-top"],[f,"border-bottom","border-bottom"],[f,"margin","margin"],[f,"margin-left","margin-left"],[f,"margin-right","margin-right"],[f,"margin-top","margin-top"],[f,"margin-bottom","margin-bottom"],[f,"border","border"]],w=[[f,"background-color","background-color"],[f,"min-height","min-height"],[l,"stroke","border"],[m,"stroke-color","border-color"],[m,"stroke-width","border-width"],[f,"border","border"],[f,"border-left","border-left"],[f,"border-right","border-right"],
[f,"border-top","border-top"],[f,"border-bottom","border-bottom"]],v=[[f,"background-color","background-color"],[f,"border-left","border-left"],[f,"border-right","border-right"],[f,"border-top","border-top"],[f,"border-bottom","border-bottom"],[f,"border","border"]],u=[[q,"column-width","width"]],C=[[q,"row-height","height"],[f,"keep-together",null]],A=[[q,"width","width"],[f,"margin-left","margin-left"],[f,"margin-right","margin-right"],[f,"margin-top","margin-top"],[f,"margin-bottom","margin-bottom"]],
D=[[f,"background-color","background-color"],[f,"padding","padding"],[f,"padding-left","padding-left"],[f,"padding-right","padding-right"],[f,"padding-top","padding-top"],[f,"padding-bottom","padding-bottom"],[f,"border","border"],[f,"border-left","border-left"],[f,"border-right","border-right"],[f,"border-top","border-top"],[f,"border-bottom","border-bottom"],[f,"margin","margin"],[f,"margin-left","margin-left"],[f,"margin-right","margin-right"],[f,"margin-top","margin-top"],[f,"margin-bottom","margin-bottom"]],
G=[[f,"page-width","width"],[f,"page-height","height"]],J={border:!0,"border-left":!0,"border-right":!0,"border-top":!0,"border-bottom":!0,"stroke-width":!0},O={},K=new odf.OdfUtils,W,I,aa,P=xmldom.XPath,M=new core.CSSUnits;this.style2css=function(a,b,c,d,f){var g,h,l;for(I=b;c.cssRules.length;)c.deleteRule(c.cssRules.length-1);odf.Namespaces.forEachPrefix(function(a,b){g="@namespace "+a+" url("+b+");";try{c.insertRule(g,c.cssRules.length)}catch(d){}});O=d;W=a;aa=runtime.getWindow().getComputedStyle(document.body,
null).getPropertyValue("font-size")||"12pt";for(l in k)if(k.hasOwnProperty(l))for(h in a=f[l],a)a.hasOwnProperty(h)&&e(c,l,h,a[h])}};
// Input 37
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
(function(){function h(g,b){var d=this;this.getDistance=function(b){var g=d.x-b.x;b=d.y-b.y;return Math.sqrt(g*g+b*b)};this.getCenter=function(b){return new h((d.x+b.x)/2,(d.y+b.y)/2)};d.x=g;d.y=b}gui.ZoomHelper=function(){function g(b,c,d,e){b=e?"translate3d("+b+"px, "+c+"px, 0) scale3d("+d+", "+d+", 1)":"translate("+b+"px, "+c+"px) scale("+d+")";a.style.WebkitTransform=b;a.style.MozTransform=b;a.style.msTransform=b;a.style.OTransform=b;a.style.transform=b}function b(a){a?g(-n.x,-n.y,s,!0):(g(0,
0,s,!0),g(0,0,s,!1))}function d(a){if(w&&D){var b=w.style.overflow,c=w.classList.contains("webodf-customScrollbars");a&&c||!a&&!c||(a?(w.classList.add("webodf-customScrollbars"),w.style.overflow="hidden",runtime.requestAnimationFrame(function(){w.style.overflow=b})):w.classList.remove("webodf-customScrollbars"))}}function e(){g(-n.x,-n.y,s,!0);w.scrollLeft=0;w.scrollTop=0;G=v.style.overflow;v.style.overflow="visible";d(!1)}function l(){g(0,0,s,!0);w.scrollLeft=n.x;w.scrollTop=n.y;v.style.overflow=
G||"";d(!0)}function f(b){return new h(b.pageX-a.offsetLeft,b.pageY-a.offsetTop)}function p(b){k&&(n.x-=b.x-k.x,n.y-=b.y-k.y,n=new h(Math.min(Math.max(n.x,a.offsetLeft),(a.offsetLeft+a.offsetWidth)*s-w.clientWidth),Math.min(Math.max(n.y,a.offsetTop),(a.offsetTop+a.offsetHeight)*s-w.clientHeight)));k=b}function q(a){var b=a.touches.length,c=0<b?f(a.touches[0]):null;a=1<b?f(a.touches[1]):null;c&&a?(t=c.getDistance(a),y=s,k=c.getCenter(a),e(),A=C.PINCH):c&&(k=c,A=C.SCROLL)}function m(c){var d=c.touches.length,
k=0<d?f(c.touches[0]):null,d=1<d?f(c.touches[1]):null;if(k&&d)if(c.preventDefault(),A===C.SCROLL)A=C.PINCH,e(),t=k.getDistance(d);else{c=k.getCenter(d);k=k.getDistance(d)/t;p(c);var d=s,g=Math.min(z,a.offsetParent.clientWidth/a.offsetWidth);s=y*k;s=Math.min(Math.max(s,g),z);k=s/d;n.x+=(k-1)*(c.x+n.x);n.y+=(k-1)*(c.y+n.y);b(!0)}else k&&(A===C.PINCH?(A=C.SCROLL,l()):p(k))}function r(){A===C.PINCH&&(u.emit(gui.ZoomHelper.signalZoomChanged,s),l(),b(!1));A=C.NONE}function c(){w&&(w.removeEventListener("touchstart",
q,!1),w.removeEventListener("touchmove",m,!1),w.removeEventListener("touchend",r,!1))}var a,n,k,t,s,y,z=4,w,v,u=new core.EventNotifier([gui.ZoomHelper.signalZoomChanged]),C={NONE:0,SCROLL:1,PINCH:2},A=C.NONE,D=runtime.getWindow().hasOwnProperty("ontouchstart"),G="";this.subscribe=function(a,b){u.subscribe(a,b)};this.unsubscribe=function(a,b){u.unsubscribe(a,b)};this.getZoomLevel=function(){return s};this.setZoomLevel=function(c){a&&(s=c,b(!1),u.emit(gui.ZoomHelper.signalZoomChanged,s))};this.destroy=
function(a){c();d(!1);a()};this.setZoomableElement=function(e){c();a=e;w=a.offsetParent;v=a.parentElement;b(!1);w&&(w.addEventListener("touchstart",q,!1),w.addEventListener("touchmove",m,!1),w.addEventListener("touchend",r,!1));d(!0)};y=s=1;n=new h(0,0)};gui.ZoomHelper.signalZoomChanged="zoomChanged"})();
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
ops.Canvas=function(){};ops.Canvas.prototype.getZoomLevel=function(){};ops.Canvas.prototype.getElement=function(){};ops.Canvas.prototype.getSizer=function(){};ops.Canvas.prototype.getZoomHelper=function(){};
// Input 39
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
(function(){function h(){function a(d){c=!0;runtime.setTimeout(function(){try{d()}catch(e){runtime.log(String(e))}c=!1;0<b.length&&a(b.pop())},10)}var b=[],c=!1;this.clearQueue=function(){b.length=0};this.addToQueue=function(d){if(0===b.length&&!c)return a(d);b.push(d)}}function g(a){function b(){for(;0<c.cssRules.length;)c.deleteRule(0);c.insertRule("#shadowContent draw|page {display:none;}",0);c.insertRule("office|presentation draw|page {display:none;}",1);c.insertRule("#shadowContent draw|page:nth-of-type("+
d+") {display:block;}",2);c.insertRule("office|presentation draw|page:nth-of-type("+d+") {display:block;}",3)}var c=a.sheet,d=1;this.showFirstPage=function(){d=1;b()};this.showNextPage=function(){d+=1;b()};this.showPreviousPage=function(){1<d&&(d-=1,b())};this.showPage=function(a){0<a&&(d=a,b())};this.css=a;this.destroy=function(b){a.parentNode.removeChild(a);b()}}function b(a){for(;a.firstChild;)a.removeChild(a.firstChild)}function d(a){a=a.sheet;for(var b=a.cssRules;b.length;)a.deleteRule(b.length-
1)}function e(a,b,c){var d=new odf.Style2CSS,e=new odf.ListStyleToCss;c=c.sheet;var f=(new odf.StyleTree(a.rootElement.styles,a.rootElement.automaticStyles)).getStyleTree();d.style2css(a.getDocumentType(),a.rootElement,c,b.getFontMap(),f);e.applyListStyles(c,f)}function l(a,b,c){var d=null;a=a.rootElement.body.getElementsByTagNameNS(K,c+"-decl");c=b.getAttributeNS(K,"use-"+c+"-name");var e;if(c&&0<a.length)for(b=0;b<a.length;b+=1)if(e=a[b],e.getAttributeNS(K,"name")===c){d=e.textContent;break}return d}
function f(a,c,d,e){var f=a.ownerDocument;c=a.getElementsByTagNameNS(c,d);for(a=0;a<c.length;a+=1)b(c[a]),e&&(d=c[a],d.appendChild(f.createTextNode(e)))}function p(a,b,c){b.setAttributeNS("urn:webodf:names:helper","styleid",a);var d,e=b.getAttributeNS(G,"anchor-type"),f=b.getAttributeNS(A,"x"),k=b.getAttributeNS(A,"y"),g=b.getAttributeNS(A,"width"),h=b.getAttributeNS(A,"height"),l=b.getAttributeNS(v,"min-height"),m=b.getAttributeNS(v,"min-width");if("as-char"===e)d="display: inline-block;";else if(e||
f||k)d="position: absolute;";else if(g||h||l||m)d="display: block;";f&&(d+="left: "+f+";");k&&(d+="top: "+k+";");g&&(d+="width: "+g+";");h&&(d+="height: "+h+";");l&&(d+="min-height: "+l+";");m&&(d+="min-width: "+m+";");d&&(d="draw|"+b.localName+'[webodfhelper|styleid="'+a+'"] {'+d+"}",c.insertRule(d,c.cssRules.length))}function q(a){for(a=a.firstChild;a;){if(a.namespaceURI===u&&"binary-data"===a.localName)return"data:image/png;base64,"+a.textContent.replace(/[\r\n\s]/g,"");a=a.nextSibling}return""}
function m(a,b,c,d){function e(b){b&&(b='draw|image[webodfhelper|styleid="'+a+'"] {'+("background-image: url("+b+");")+"}",d.insertRule(b,d.cssRules.length))}function f(a){e(a.url)}c.setAttributeNS("urn:webodf:names:helper","styleid",a);var k=c.getAttributeNS(J,"href"),g;if(k)try{g=b.getPart(k),g.onchange=f,g.load()}catch(h){runtime.log("slight problem: "+String(h))}else k=q(c),e(k)}function r(a){var b=a.ownerDocument;P.getElementsByTagNameNS(a,G,"line-break").forEach(function(a){a.hasChildNodes()||
a.appendChild(b.createElement("br"))})}function c(a){var b=a.ownerDocument;P.getElementsByTagNameNS(a,G,"s").forEach(function(a){for(var c,d;a.firstChild;)a.removeChild(a.firstChild);a.appendChild(b.createTextNode(" "));d=parseInt(a.getAttributeNS(G,"c"),10);if(1<d)for(a.removeAttributeNS(G,"c"),c=1;c<d;c+=1)a.parentNode.insertBefore(a.cloneNode(!0),a)})}function a(a){P.getElementsByTagNameNS(a,G,"tab").forEach(function(a){a.textContent="\t"})}function n(a,b){function c(a,d){var k=g.documentElement.namespaceURI;
"video/"===d.substr(0,6)?(e=g.createElementNS(k,"video"),e.setAttribute("controls","controls"),f=g.createElementNS(k,"source"),a&&f.setAttribute("src",a),f.setAttribute("type",d),e.appendChild(f),b.parentNode.appendChild(e)):b.innerHtml="Unrecognised Plugin"}function d(a){c(a.url,a.mimetype)}var e,f,k,g=b.ownerDocument,h;if(k=b.getAttributeNS(J,"href"))try{h=a.getPart(k),h.onchange=d,h.load()}catch(l){runtime.log("slight problem: "+String(l))}else runtime.log("using MP4 data fallback"),k=q(b),c(k,
"video/mp4")}function k(a,b){try{a.insertRule(b,a.cssRules.length)}catch(c){runtime.log("cannot load rule: "+b+" - "+c)}}function t(a){return a.replace(/\\/g,"\\\\").replace(/"/g,'\\"')}function s(a){var b=a.getElementsByTagName("head")[0],c,d;c=a.styleSheets.length;for(d=b.firstElementChild;d&&("style"!==d.localName||!d.hasAttribute("webodfcss"));)d=d.nextElementSibling;if(d)return c=parseInt(d.getAttribute("webodfcss"),10),d.setAttribute("webodfcss",c+1),d;"string"===String(typeof webodf_css)?c=
webodf_css:(d="webodf.css",runtime.currentDirectory&&(d=runtime.currentDirectory(),0<d.length&&"/"!==d.substr(-1)&&(d+="/"),d+="../webodf.css"),c=runtime.readFileSync(d,"utf-8"));d=a.createElementNS(b.namespaceURI,"style");d.setAttribute("media","screen, print, handheld, projection");d.setAttribute("type","text/css");d.setAttribute("webodfcss","1");d.appendChild(a.createTextNode(c));b.appendChild(d);return d}function y(a){var b=parseInt(a.getAttribute("webodfcss"),10);1===b?a.parentNode.removeChild(a):
a.setAttribute("count",b-1)}function z(a){var b=a.getElementsByTagName("head")[0],c=a.createElementNS(b.namespaceURI,"style"),d="";c.setAttribute("type","text/css");c.setAttribute("media","screen, print, handheld, projection");odf.Namespaces.forEachPrefix(function(a,b){d+="@namespace "+a+" url("+b+");\n"});d+="@namespace webodfhelper url(urn:webodf:names:helper);\n";c.appendChild(a.createTextNode(d));b.appendChild(c);return c}var w=odf.Namespaces.drawns,v=odf.Namespaces.fons,u=odf.Namespaces.officens,
C=odf.Namespaces.stylens,A=odf.Namespaces.svgns,D=odf.Namespaces.tablens,G=odf.Namespaces.textns,J=odf.Namespaces.xlinkns,O=odf.Namespaces.xmlns,K=odf.Namespaces.presentationns,W=runtime.getWindow(),I=xmldom.XPath,aa=new odf.OdfUtils,P=new core.DomUtils;odf.OdfCanvas=function(q){function A(a,b,c){function d(a,b,c,e){na.addToQueue(function(){m(a,b,c,e)})}var e,f;e=b.getElementsByTagNameNS(w,"image");for(b=0;b<e.length;b+=1)f=e.item(b),d("image"+String(b),a,f,c)}function J(a,b){function c(a,b){na.addToQueue(function(){n(a,
b)})}var d,e,f;e=b.getElementsByTagNameNS(w,"plugin");for(d=0;d<e.length;d+=1)f=e.item(d),c(a,f)}function v(){var a;a=T.firstChild;var b=ga.getZoomLevel();a&&(T.style.WebkitTransformOrigin="0% 0%",T.style.MozTransformOrigin="0% 0%",T.style.msTransformOrigin="0% 0%",T.style.OTransformOrigin="0% 0%",T.style.transformOrigin="0% 0%",ca&&((a=ca.getMinimumHeightForAnnotationPane())?T.style.minHeight=a:T.style.removeProperty("min-height")),q.style.width=Math.round(b*T.offsetWidth)+"px",q.style.height=Math.round(b*
T.offsetHeight)+"px",q.style.display="inline-block")}function $(a){B?(X.parentNode||T.appendChild(X),ca&&ca.forgetAnnotations(),ca=new gui.AnnotationViewManager(N,a.body,X,ja),P.getElementsByTagNameNS(a.body,u,"annotation").forEach(ca.addAnnotation),ca.rerenderAnnotations(),v()):X.parentNode&&(T.removeChild(X),ca.forgetAnnotations(),v())}function x(g){function h(){d(ea);d(qa);d(ka);b(q);q.style.display="inline-block";var m=H.rootElement;q.ownerDocument.importNode(m,!0);Q.setOdfContainer(H);var n=
H,s=ea;(new odf.FontLoader).loadFonts(n,s.sheet);e(H,Q,qa);s=H;n=ka.sheet;b(q);T=U.createElementNS(q.namespaceURI,"div");T.style.display="inline-block";T.style.background="white";T.style.setProperty("float","left","important");T.appendChild(m);q.appendChild(T);X=U.createElementNS(q.namespaceURI,"div");X.id="annotationsPane";fa=U.createElementNS(q.namespaceURI,"div");fa.id="shadowContent";fa.style.position="absolute";fa.style.top=0;fa.style.left=0;s.getContentElement().appendChild(fa);var x=m.body,
y,v=[],z;for(y=x.firstElementChild;y&&y!==x;)if(y.namespaceURI===w&&(v[v.length]=y),y.firstElementChild)y=y.firstElementChild;else{for(;y&&y!==x&&!y.nextElementSibling;)y=y.parentNode;y&&y.nextElementSibling&&(y=y.nextElementSibling)}for(z=0;z<v.length;z+=1)y=v[z],p("frame"+String(z),y,n);v=I.getODFElementsWithXPath(x,".//*[*[@text:anchor-type='paragraph']]",odf.Namespaces.lookupNamespaceURI);for(y=0;y<v.length;y+=1)x=v[y],x.setAttributeNS&&x.setAttributeNS("urn:webodf:names:helper","containsparagraphanchor",
!0);x=Q;y=fa;var N,R,P,B;B=0;var L,V;z=s.rootElement.ownerDocument;if((v=m.body.firstElementChild)&&v.namespaceURI===u&&("presentation"===v.localName||"drawing"===v.localName))for(v=v.firstElementChild;v;){if(N=(N=v.getAttributeNS(w,"master-page-name"))?x.getMasterPageElement(N):null){R=v.getAttributeNS("urn:webodf:names:helper","styleid");P=z.createElementNS(w,"draw:page");V=N.firstElementChild;for(L=0;V;)"true"!==V.getAttributeNS(K,"placeholder")&&(B=V.cloneNode(!0),P.appendChild(B),p(R+"_"+L,B,
n)),V=V.nextElementSibling,L+=1;V=L=B=void 0;var ha=P.getElementsByTagNameNS(w,"frame");for(B=0;B<ha.length;B+=1)L=ha[B],(V=L.getAttributeNS(K,"class"))&&!/^(date-time|footer|header|page-number)$/.test(V)&&L.parentNode.removeChild(L);y.appendChild(P);B=String(y.getElementsByTagNameNS(w,"page").length);f(P,G,"page-number",B);f(P,K,"header",l(s,v,"header"));f(P,K,"footer",l(s,v,"footer"));p(R,P,n);P.setAttributeNS(w,"draw:master-page-name",N.getAttributeNS(C,"name"))}v=v.nextElementSibling}x=q.namespaceURI;
v=m.body.getElementsByTagNameNS(D,"table-cell");for(y=0;y<v.length;y+=1)z=v.item(y),z.hasAttributeNS(D,"number-columns-spanned")&&z.setAttributeNS(x,"colspan",z.getAttributeNS(D,"number-columns-spanned")),z.hasAttributeNS(D,"number-rows-spanned")&&z.setAttributeNS(x,"rowspan",z.getAttributeNS(D,"number-rows-spanned"));r(m.body);c(m.body);a(m.body);A(s,m.body,n);J(s,m.body);z=m.body;s=q.namespaceURI;y={};var v={},Z;N=W.document.getElementsByTagNameNS(G,"list-style");for(x=0;x<N.length;x+=1)B=N.item(x),
(L=B.getAttributeNS(C,"name"))&&(v[L]=B);z=z.getElementsByTagNameNS(G,"list");for(x=0;x<z.length;x+=1)if(B=z.item(x),N=B.getAttributeNS(O,"id")){R=B.getAttributeNS(G,"continue-list");B.setAttributeNS(s,"id",N);P="text|list#"+N+" > text|list-item > *:first-child:before {";if(L=B.getAttributeNS(G,"style-name"))B=v[L],Z=aa.getFirstNonWhitespaceChild(B),B=void 0,Z&&("list-level-style-number"===Z.localName?(L=Z,Z=L.getAttributeNS(C,"num-format"),B=L.getAttributeNS(C,"num-suffix")||"",L=L.getAttributeNS(C,
"num-prefix")||"",V="",V={1:"decimal",a:"lower-latin",A:"upper-latin",i:"lower-roman",I:"upper-roman"},ha=void 0,L&&(ha='"'+t(L)+'"\n'),ha=V.hasOwnProperty(Z)?ha+(" counter(list, "+V[Z]+")"):Z?ha+("'"+Z+"';"):ha+' ""',B&&(ha+=' "'+t(B)+'"'),B=V="content:"+ha+";"):"list-level-style-image"===Z.localName?B="content: none;":"list-level-style-bullet"===Z.localName&&(Z=Z.getAttributeNS(G,"bullet-char"),B='content: "'+t(Z)+'"\n;')),Z=B,Z="\n"+Z+"\n";if(R){for(B=y[R];B;)B=y[B];P+="counter-increment:"+R+";";
Z?(Z=Z.replace("list",R),P+=Z):P+="content:counter("+R+");"}else R="",Z?(Z=Z.replace("list",N),P+=Z):P+="content: counter("+N+");",P+="counter-increment:"+N+";",k(n,"text|list#"+N+" {counter-reset:"+N+"}");P+="}";y[N]=R;P&&k(n,P)}T.insertBefore(fa,T.firstChild);ga.setZoomableElement(T);$(m);if(!g&&(m=[H],la.hasOwnProperty("statereadychange")))for(n=la.statereadychange,Z=0;Z<n.length;Z+=1)n[Z].apply(null,m)}H.state===odf.OdfContainer.DONE?h():(runtime.log("WARNING: refreshOdf called but ODF was not DONE."),
oa=runtime.setTimeout(function F(){H.state===odf.OdfContainer.DONE?h():(runtime.log("will be back later..."),oa=runtime.setTimeout(F,500))},100))}function R(a){na.clearQueue();q.innerHTML=runtime.tr("Loading File")+"...";q.removeAttribute("style");H=new odf.OdfContainer(a,function(a){H=a;x(!1)})}runtime.assert(null!==q&&void 0!==q,"odf.OdfCanvas constructor needs DOM element");runtime.assert(null!==q.ownerDocument&&void 0!==q.ownerDocument,"odf.OdfCanvas constructor needs DOM");var N=this,U=q.ownerDocument,
H,Q=new odf.Formatting,L,T=null,X=null,B=!1,ja=!1,ca=null,da,ea,qa,ka,fa,la={},oa,pa,ia=!1,ma=!1,na=new h,ga=new gui.ZoomHelper;this.refreshCSS=function(){ia=!0;pa.trigger()};this.refreshSize=function(){pa.trigger()};this.odfContainer=function(){return H};this.setOdfContainer=function(a,b){H=a;x(!0===b)};this.load=this.load=R;this.save=function(a){H.save(a)};this.addListener=function(a,b){switch(a){case "click":var c=q,d=a;c.addEventListener?c.addEventListener(d,b,!1):c.attachEvent?c.attachEvent("on"+
d,b):c["on"+d]=b;break;default:c=la.hasOwnProperty(a)?la[a]:la[a]=[],b&&-1===c.indexOf(b)&&c.push(b)}};this.getFormatting=function(){return Q};this.getAnnotationViewManager=function(){return ca};this.refreshAnnotations=function(){$(H.rootElement)};this.rerenderAnnotations=function(){ca&&(ma=!0,pa.trigger())};this.getSizer=function(){return T};this.enableAnnotations=function(a,b){a!==B&&(B=a,ja=b,H&&$(H.rootElement))};this.addAnnotation=function(a){ca&&(ca.addAnnotation(a),v())};this.forgetAnnotations=
function(){ca&&(ca.forgetAnnotations(),v())};this.getZoomHelper=function(){return ga};this.setZoomLevel=function(a){ga.setZoomLevel(a)};this.getZoomLevel=function(){return ga.getZoomLevel()};this.fitToContainingElement=function(a,b){var c=ga.getZoomLevel(),d=q.offsetHeight/c,c=a/(q.offsetWidth/c);b/d<c&&(c=b/d);ga.setZoomLevel(c)};this.fitToWidth=function(a){var b=q.offsetWidth/ga.getZoomLevel();ga.setZoomLevel(a/b)};this.fitSmart=function(a,b){var c,d;d=ga.getZoomLevel();c=q.offsetWidth/d;d=q.offsetHeight/
d;c=a/c;void 0!==b&&b/d<c&&(c=b/d);ga.setZoomLevel(Math.min(1,c))};this.fitToHeight=function(a){var b=q.offsetHeight/ga.getZoomLevel();ga.setZoomLevel(a/b)};this.showFirstPage=function(){L.showFirstPage()};this.showNextPage=function(){L.showNextPage()};this.showPreviousPage=function(){L.showPreviousPage()};this.showPage=function(a){L.showPage(a);v()};this.getElement=function(){return q};this.addCssForFrameWithImage=function(a){var b=a.getAttributeNS(w,"name"),c=a.firstElementChild;p(b,a,ka.sheet);
c&&m(b+"img",H,c,ka.sheet)};this.destroy=function(a){var b=U.getElementsByTagName("head")[0],c=[L.destroy,pa.destroy];runtime.clearTimeout(oa);X&&X.parentNode&&X.parentNode.removeChild(X);ga.destroy(function(){T&&(q.removeChild(T),T=null)});y(da);b.removeChild(ea);b.removeChild(qa);b.removeChild(ka);core.Async.destroyAll(c,a)};da=s(U);L=new g(z(U));ea=z(U);qa=z(U);ka=z(U);pa=core.Task.createRedrawTask(function(){ia&&(e(H,Q,qa),ia=!1);ma&&(ca&&ca.rerenderAnnotations(),ma=!1);v()});ga.subscribe(gui.ZoomHelper.signalZoomChanged,
v)}})();
// Input 40
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
odf.StepUtils=function(){this.getContentBounds=function(h){var g=h.container(),b,d;runtime.assert(h.isStep(),"Step iterator must be on a step");g.nodeType===Node.TEXT_NODE&&0<h.offset()?b=h.offset():(g=h.leftNode())&&g.nodeType===Node.TEXT_NODE&&(b=g.length);g&&(g.nodeType===Node.TEXT_NODE?(runtime.assert(0<b,"Empty text node found"),d={container:g,startOffset:b-1,endOffset:b}):d={container:g,startOffset:0,endOffset:g.childNodes.length});return d}};
// Input 41
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
ops.Member=function(h,g){var b=new ops.MemberProperties;this.getMemberId=function(){return h};this.getProperties=function(){return b};this.setProperties=function(d){Object.keys(d).forEach(function(e){b[e]=d[e]})};this.removeProperties=function(d){Object.keys(d).forEach(function(d){"fullName"!==d&&"color"!==d&&"imageUrl"!==d&&b.hasOwnProperty(d)&&delete b[d]})};runtime.assert(Boolean(h),"No memberId was supplied!");g.fullName||(g.fullName=runtime.tr("Unknown Author"));g.color||(g.color="black");g.imageUrl||
(g.imageUrl="avatar-joe.png");b=g};
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
gui.SelectionMover=function(h,g){function b(){r.setUnfilteredPosition(h.getNode(),0);return r}function d(a,b){var c,d=null;a&&0<a.length&&(c=b?a.item(a.length-1):a.item(0));c&&(d={top:c.top,left:b?c.right:c.left,bottom:c.bottom});return d}function e(a,b,c,f){var h=a.nodeType;c.setStart(a,b);c.collapse(!f);f=d(c.getClientRects(),!0===f);!f&&0<b&&(c.setStart(a,b-1),c.setEnd(a,b),f=d(c.getClientRects(),!0));f||(h===Node.ELEMENT_NODE&&0<b&&a.childNodes.length>=b?f=e(a,b-1,c,!0):a.nodeType===Node.TEXT_NODE&&
0<b?f=e(a,b-1,c,!0):a.previousSibling?f=e(a.previousSibling,a.previousSibling.nodeType===Node.TEXT_NODE?a.previousSibling.textContent.length:a.previousSibling.childNodes.length,c,!0):a.parentNode&&a.parentNode!==g?f=e(a.parentNode,0,c,!1):(c.selectNode(g),f=d(c.getClientRects(),!1)));runtime.assert(Boolean(f),"No visible rectangle found");return f}function l(a,d,e){for(var f=b(),g=new core.LoopWatchDog(1E4),h=0,l=0;0<a&&f.nextPosition();)g.check(),e.acceptPosition(f)===c&&(h+=1,d.acceptPosition(f)===
c&&(l+=h,h=0,a-=1));return l}function f(a,d,e){for(var f=b(),g=new core.LoopWatchDog(1E4),h=0,l=0;0<a&&f.previousPosition();)g.check(),e.acceptPosition(f)===c&&(h+=1,d.acceptPosition(f)===c&&(l+=h,h=0,a-=1));return l}function p(a,d){var f=b(),h=0,l=0,m=0>a?-1:1;for(a=Math.abs(a);0<a;){for(var r=d,p=m,q=f,u=q.container(),C=0,A=null,D=void 0,G=10,J=void 0,O=0,K=void 0,W=void 0,I=void 0,J=void 0,aa=g.ownerDocument.createRange(),P=new core.LoopWatchDog(1E4),J=e(u,q.unfilteredDomOffset(),aa),K=J.top,W=
J.left,I=K;!0===(0>p?q.previousPosition():q.nextPosition());)if(P.check(),r.acceptPosition(q)===c&&(C+=1,u=q.container(),J=e(u,q.unfilteredDomOffset(),aa),J.top!==K)){if(J.top!==I&&I!==K)break;I=J.top;J=Math.abs(W-J.left);if(null===A||J<G)A=u,D=q.unfilteredDomOffset(),G=J,O=C}null!==A?(q.setUnfilteredPosition(A,D),C=O):C=0;aa.detach();h+=C;if(0===h)break;l+=h;a-=1}return l*m}function q(a,d){var f,h,l,r,p=b(),q=m.getParagraphElement(p.getCurrentNode()),v=0,u=g.ownerDocument.createRange();0>a?(f=p.previousPosition,
h=-1):(f=p.nextPosition,h=1);for(l=e(p.container(),p.unfilteredDomOffset(),u);f.call(p);)if(d.acceptPosition(p)===c){if(m.getParagraphElement(p.getCurrentNode())!==q)break;r=e(p.container(),p.unfilteredDomOffset(),u);if(r.bottom!==l.bottom&&(l=r.top>=l.top&&r.bottom<l.bottom||r.top<=l.top&&r.bottom>l.bottom,!l))break;v+=h;l=r}u.detach();return v}var m=new odf.OdfUtils,r,c=core.PositionFilter.FilterResult.FILTER_ACCEPT;this.getStepCounter=function(){return{convertForwardStepsBetweenFilters:l,convertBackwardStepsBetweenFilters:f,
countLinesSteps:p,countStepsToLineBoundary:q}};(function(){r=gui.SelectionMover.createPositionIterator(g);var a=g.ownerDocument.createRange();a.setStart(r.container(),r.unfilteredDomOffset());a.collapse(!0);h.setSelectedRange(a)})()};
gui.SelectionMover.createPositionIterator=function(h){var g=new function(){this.acceptNode=function(b){return b&&"urn:webodf:names:cursor"!==b.namespaceURI&&"urn:webodf:names:editinfo"!==b.namespaceURI?NodeFilter.FILTER_ACCEPT:NodeFilter.FILTER_REJECT}};return new core.PositionIterator(h,5,g,!1)};
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
ops.Document=function(){};ops.Document.prototype.getMemberIds=function(){};ops.Document.prototype.removeCursor=function(h){};ops.Document.prototype.getDocumentElement=function(){};ops.Document.prototype.getRootNode=function(){};ops.Document.prototype.getDOMDocument=function(){};ops.Document.prototype.cloneDocumentElement=function(){};ops.Document.prototype.setDocumentElement=function(h){};ops.Document.prototype.subscribe=function(h,g){};ops.Document.prototype.unsubscribe=function(h,g){};
ops.Document.prototype.getCanvas=function(){};ops.Document.prototype.createRootFilter=function(h){};ops.Document.signalCursorAdded="cursor/added";ops.Document.signalCursorRemoved="cursor/removed";ops.Document.signalCursorMoved="cursor/moved";ops.Document.signalMemberAdded="member/added";ops.Document.signalMemberUpdated="member/updated";ops.Document.signalMemberRemoved="member/removed";
// Input 44
ops.OdtCursor=function(h,g){var b=this,d={},e,l,f,p=new core.EventNotifier([ops.OdtCursor.signalCursorUpdated]);this.removeFromDocument=function(){f.remove()};this.subscribe=function(b,d){p.subscribe(b,d)};this.unsubscribe=function(b,d){p.unsubscribe(b,d)};this.getStepCounter=function(){return l.getStepCounter()};this.getMemberId=function(){return h};this.getNode=function(){return f.getNode()};this.getAnchorNode=function(){return f.getAnchorNode()};this.getSelectedRange=function(){return f.getSelectedRange()};
this.setSelectedRange=function(d,e){f.setSelectedRange(d,e);p.emit(ops.OdtCursor.signalCursorUpdated,b)};this.hasForwardSelection=function(){return f.hasForwardSelection()};this.getDocument=function(){return g};this.getSelectionType=function(){return e};this.setSelectionType=function(b){d.hasOwnProperty(b)?e=b:runtime.log("Invalid selection type: "+b)};this.resetSelectionType=function(){b.setSelectionType(ops.OdtCursor.RangeSelection)};f=new core.Cursor(g.getDOMDocument(),h);l=new gui.SelectionMover(f,
g.getRootNode());d[ops.OdtCursor.RangeSelection]=!0;d[ops.OdtCursor.RegionSelection]=!0;b.resetSelectionType()};ops.OdtCursor.RangeSelection="Range";ops.OdtCursor.RegionSelection="Region";ops.OdtCursor.signalCursorUpdated="cursorUpdated";
// Input 45
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
(function(){var h=0;ops.StepsCache=function(g,b,d){function e(a,b){var c=this;this.nodeId=a;this.steps=-1;this.node=b;this.previousBookmark=this.nextBookmark=null;this.setIteratorPosition=function(a){a.setPositionBeforeElement(b);d(c.steps,a)}}function l(a,b,c){var e=this;this.nodeId=a;this.steps=b;this.node=c;this.previousBookmark=this.nextBookmark=null;this.setIteratorPosition=function(a){a.setUnfilteredPosition(c,0);d(e.steps,a)}}function f(a,b){var c="["+a.nodeId;b&&(c+=" => "+b.nodeId);return c+
"]"}function p(){for(var a=y,b,c,d,e=new core.LoopWatchDog(0,1E5),h={};a;){e.check();(b=a.previousBookmark)?runtime.assert(b.nextBookmark===a,"Broken bookmark link to previous @"+f(b,a)):(runtime.assert(a===y,"Broken bookmark link @"+f(a)),runtime.assert(void 0===z||y===y||y.steps<=z,"Base point is damaged @"+f(a)));(c=a.nextBookmark)&&runtime.assert(c.previousBookmark===a,"Broken bookmark link to next @"+f(a,c));if(void 0===z||a===y||a.steps<=z)runtime.assert(s.containsNode(g,a.node),"Disconnected node is being reported as undamaged @"+
f(a)),b&&(d=a.node.compareDocumentPosition(b.node),runtime.assert(0===d||0!==(d&v),"Bookmark order with previous does not reflect DOM order @"+f(b,a))),c&&s.containsNode(g,c.node)&&(d=a.node.compareDocumentPosition(c.node),runtime.assert(0===d||0!==(d&w),"Bookmark order with next does not reflect DOM order @"+f(a,c)));a=a.nextBookmark}Object.keys(k).forEach(function(a){var b=k[a];(void 0===z||a<=z)&&runtime.assert(b.steps<=a,"Bookmark step of "+b.steps+" exceeds cached step lookup for "+a+" @"+f(b));
runtime.assert(!1===h.hasOwnProperty(b.nodeId),"Bookmark "+f(b)+" appears twice in cached step lookup at steps "+h[b.nodeId]+" and "+a);h[b.nodeId]=a})}function q(a){var b="";a.nodeType===Node.ELEMENT_NODE&&(b=a.getAttributeNS(n,"nodeId")||"");return b}function m(a){var b=h.toString();a.setAttributeNS(n,"nodeId",b);h+=1;return b}function r(a){var c,d,e=new core.LoopWatchDog(0,1E4);void 0!==z&&a>z&&(a=z);for(c=Math.floor(a/b)*b;!d&&0<=c;)d=k[c],c-=b;for(d=d||y;d.nextBookmark&&d.nextBookmark.steps<=
a;)e.check(),d=d.nextBookmark;runtime.assert(-1===a||d.steps<=a,"Bookmark @"+f(d)+" at step "+d.steps+" exceeds requested step of "+a);return d}function c(a){a.previousBookmark&&(a.previousBookmark.nextBookmark=a.nextBookmark);a.nextBookmark&&(a.nextBookmark.previousBookmark=a.previousBookmark)}function a(a){for(var b,c=null;!c&&a&&a!==g;)(b=q(a))&&(c=t[b])&&c.node!==a&&(runtime.log("Cloned node detected. Creating new bookmark"),c=null,a.removeAttributeNS(n,"nodeId")),a=a.parentNode;return c}var n=
"urn:webodf:names:steps",k={},t={},s=new core.DomUtils,y,z,w=Node.DOCUMENT_POSITION_FOLLOWING,v=Node.DOCUMENT_POSITION_PRECEDING,u;this.updateBookmark=function(a,d){var f,h=Math.ceil(a/b)*b,l,n,p;if(void 0!==z&&z<a){l=r(z);for(n=l.nextBookmark;n&&n.steps<=a;)f=n.nextBookmark,p=Math.ceil(n.steps/b)*b,k[p]===n&&delete k[p],s.containsNode(g,n.node)?n.steps=a+1:(c(n),delete t[n.nodeId]),n=f;z=a}else l=r(a);n=q(d)||m(d);f=t[n];f?f.node!==d&&(runtime.log("Cloned node detected. Creating new bookmark"),n=
m(d),f=t[n]=new e(n,d)):f=t[n]=new e(n,d);n=f;n.steps!==a&&(f=Math.ceil(n.steps/b)*b,f!==h&&k[f]===n&&delete k[f],n.steps=a);if(l!==n&&l.nextBookmark!==n){if(l.steps===n.steps)for(;0!==(n.node.compareDocumentPosition(l.node)&w)&&l!==y;)l=l.previousBookmark;l!==n&&l.nextBookmark!==n&&(c(n),f=l.nextBookmark,n.nextBookmark=l.nextBookmark,n.previousBookmark=l,l.nextBookmark=n,f&&(f.previousBookmark=n))}l=k[h];if(!l||n.steps>l.steps)k[h]=n;u()};this.setToClosestStep=function(a,b){var c;u();c=r(a);c.setIteratorPosition(b);
return c.steps};this.setToClosestDomPoint=function(b,c,d){var e,f;u();if(b===g&&0===c)e=y;else if(b===g&&c===g.childNodes.length)for(f in e=y,k)k.hasOwnProperty(f)&&(b=k[f],b.steps>e.steps&&(e=b));else if(e=a(b.childNodes.item(c)||b),!e)for(d.setUnfilteredPosition(b,c);!e&&d.previousNode();)e=a(d.getCurrentNode());e=e||y;void 0!==z&&e.steps>z&&(e=r(z));e.setIteratorPosition(d);return e.steps};this.damageCacheAfterStep=function(a){0>a&&(a=-1);void 0===z?z=a:a<z&&(z=a);u()};(function(){var a=q(g)||
m(g);y=new l(a,0,g);u=ops.StepsCache.ENABLE_CACHE_VERIFICATION?p:function(){}})()};ops.StepsCache.ENABLE_CACHE_VERIFICATION=!1;ops.StepsCache.Bookmark=function(){};ops.StepsCache.Bookmark.prototype.setIteratorPosition=function(g){}})();
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
(function(){ops.OdtStepsTranslator=function(h,g,b,d){function e(a,b,c){var d=b.getCurrentNode();b.isBeforeNode()&&r.isParagraph(d)&&(c||(a+=1),m.updateBookmark(a,d))}function l(a,c){do{if(b.acceptPosition(c)===n){e(a,c,!0);break}e(a-1,c,!1)}while(c.nextPosition())}function f(){var b=h();b!==q&&(q&&runtime.log("Undo detected. Resetting steps cache"),q=b,m=new ops.StepsCache(q,d,l),a=g(q))}function p(a,c){if(!c||b.acceptPosition(a)===n)return!0;for(;a.previousPosition();)if(b.acceptPosition(a)===n){if(c(0,
a.container(),a.unfilteredDomOffset()))return!0;break}for(;a.nextPosition();)if(b.acceptPosition(a)===n){if(c(1,a.container(),a.unfilteredDomOffset()))return!0;break}return!1}var q,m,r=new odf.OdfUtils,c=new core.DomUtils,a,n=core.PositionFilter.FilterResult.FILTER_ACCEPT;this.convertStepsToDomPoint=function(c){var d,g;if(isNaN(c))throw new TypeError("Requested steps is not numeric ("+c+")");if(0>c)throw new RangeError("Requested steps is negative ("+c+")");f();for(d=m.setToClosestStep(c,a);d<c&&
a.nextPosition();)(g=b.acceptPosition(a)===n)&&(d+=1),e(d,a,g);if(d!==c)throw new RangeError("Requested steps ("+c+") exceeds available steps ("+d+")");return{node:a.container(),offset:a.unfilteredDomOffset()}};this.convertDomPointToSteps=function(d,g,h){var l;f();c.containsNode(q,d)||(g=0>c.comparePoints(q,0,d,g),d=q,g=g?0:q.childNodes.length);a.setUnfilteredPosition(d,g);p(a,h)||a.setUnfilteredPosition(d,g);h=a.container();g=a.unfilteredDomOffset();d=m.setToClosestDomPoint(h,g,a);if(0>c.comparePoints(a.container(),
a.unfilteredDomOffset(),h,g))return 0<d?d-1:d;for(;(a.container()!==h||a.unfilteredDomOffset()!==g)&&a.nextPosition();)(l=b.acceptPosition(a)===n)&&(d+=1),e(d,a,l);return d+0};this.prime=function(){var c,d;f();for(c=m.setToClosestStep(0,a);a.nextPosition();)(d=b.acceptPosition(a)===n)&&(c+=1),e(c,a,d)};this.handleStepsInserted=function(a){f();m.damageCacheAfterStep(a.position)};this.handleStepsRemoved=function(a){f();m.damageCacheAfterStep(a.position-1)};f()};ops.OdtStepsTranslator.PREVIOUS_STEP=
0;ops.OdtStepsTranslator.NEXT_STEP=1})();
// Input 47
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
ops.Operation=function(){};ops.Operation.prototype.init=function(h){};ops.Operation.prototype.execute=function(h){};ops.Operation.prototype.spec=function(){};
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
ops.TextPositionFilter=function(h){function g(d,e,g){var h,c;if(e){if(b.isInlineRoot(e)&&b.isGroupingElement(g))return f;h=b.lookLeftForCharacter(e);if(1===h||2===h&&(b.scanRightForAnyCharacter(g)||b.scanRightForAnyCharacter(b.nextNode(d))))return l}else if(b.isInlineRoot(d.previousSibling)&&b.isGroupingElement(d))return l;h=null===e&&b.isParagraph(d);c=b.lookRightForCharacter(g);if(h)return c?l:b.scanRightForAnyCharacter(g)?f:l;if(!c)return f;e=e||b.previousNode(d);return b.scanLeftForAnyCharacter(e)?
f:l}var b=new odf.OdfUtils,d=Node.ELEMENT_NODE,e=Node.TEXT_NODE,l=core.PositionFilter.FilterResult.FILTER_ACCEPT,f=core.PositionFilter.FilterResult.FILTER_REJECT;this.acceptPosition=function(p){var q=p.container(),m=q.nodeType,r,c,a;if(m!==d&&m!==e)return f;if(m===e){if(!b.isGroupingElement(q.parentNode)||b.isWithinTrackedChanges(q.parentNode,h()))return f;m=p.unfilteredDomOffset();r=q.data;runtime.assert(m!==r.length,"Unexpected offset.");if(0<m){p=r[m-1];if(!b.isODFWhitespace(p))return l;if(1<m)if(p=
r[m-2],!b.isODFWhitespace(p))c=l;else{if(!b.isODFWhitespace(r.substr(0,m)))return f}else a=b.previousNode(q),b.scanLeftForNonSpace(a)&&(c=l);if(c===l)return b.isTrailingWhitespace(q,m)?f:l;c=r[m];return b.isODFWhitespace(c)?f:b.scanLeftForAnyCharacter(b.previousNode(q))?f:l}a=p.leftNode();c=q;q=q.parentNode;c=g(q,a,c)}else!b.isGroupingElement(q)||b.isWithinTrackedChanges(q,h())?c=f:(a=p.leftNode(),c=p.rightNode(),c=g(q,a,c));return c}};
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
ops.OdtDocument=function(h){function g(){var a=h.odfContainer().getContentElement(),b=a&&a.localName;runtime.assert("text"===b,"Unsupported content element type '"+b+"' for OdtDocument");return a}function b(){return c.getDocumentElement().ownerDocument}function d(a){for(;a&&!(a.namespaceURI===odf.Namespaces.officens&&"text"===a.localName||a.namespaceURI===odf.Namespaces.officens&&"annotation"===a.localName);)a=a.parentNode;return a}function e(a){this.acceptPosition=function(b){b=b.container();var c;
c="string"===typeof a?t[a].getNode():a;return d(b)===d(c)?z:w}}function l(a,b,c,d){d=gui.SelectionMover.createPositionIterator(d);var e;1===c.length?e=c[0]:(e=new core.PositionFilterChain,c.forEach(e.addFilter));c=new core.StepIterator(e,d);c.setPosition(a,b);return c}function f(a){var b=gui.SelectionMover.createPositionIterator(g());a=u.convertStepsToDomPoint(a);b.setUnfilteredPosition(a.node,a.offset);return b}function p(a){return n.getParagraphElement(a)}function q(a,b){return h.getFormatting().getStyleElement(a,
b)}function m(a){return q(a,"paragraph")}function r(a,b,c){a=a.childNodes.item(b)||a;return(a=p(a))&&k.containsNode(c,a)?a:c}var c=this,a,n,k,t={},s={},y=new core.EventNotifier([ops.Document.signalMemberAdded,ops.Document.signalMemberUpdated,ops.Document.signalMemberRemoved,ops.Document.signalCursorAdded,ops.Document.signalCursorRemoved,ops.Document.signalCursorMoved,ops.OdtDocument.signalParagraphChanged,ops.OdtDocument.signalParagraphStyleModified,ops.OdtDocument.signalCommonStyleCreated,ops.OdtDocument.signalCommonStyleDeleted,
ops.OdtDocument.signalTableAdded,ops.OdtDocument.signalOperationStart,ops.OdtDocument.signalOperationEnd,ops.OdtDocument.signalProcessingBatchStart,ops.OdtDocument.signalProcessingBatchEnd,ops.OdtDocument.signalUndoStackChanged,ops.OdtDocument.signalStepsInserted,ops.OdtDocument.signalStepsRemoved,ops.OdtDocument.signalMetadataUpdated]),z=core.PositionFilter.FilterResult.FILTER_ACCEPT,w=core.PositionFilter.FilterResult.FILTER_REJECT,v,u,C;this.getDocumentElement=function(){return h.odfContainer().rootElement};
this.getDOMDocument=function(){return this.getDocumentElement().ownerDocument};this.cloneDocumentElement=function(){var a=c.getDocumentElement(),b=h.getAnnotationViewManager();b&&b.forgetAnnotations();a=a.cloneNode(!0);h.refreshAnnotations();return a};this.setDocumentElement=function(a){var b=h.odfContainer();b.setRootElement(a);h.setOdfContainer(b,!0);h.refreshCSS()};this.getDOMDocument=b;this.getRootElement=d;this.createStepIterator=l;this.getIteratorAtPosition=f;this.convertDomPointToCursorStep=
function(a,b,c){return u.convertDomPointToSteps(a,b,c)};this.convertDomToCursorRange=function(a){var b;b=u.convertDomPointToSteps(a.anchorNode,a.anchorOffset);a=a.anchorNode===a.focusNode&&a.anchorOffset===a.focusOffset?b:u.convertDomPointToSteps(a.focusNode,a.focusOffset);return{position:b,length:a-b}};this.convertCursorToDomRange=function(a,c){var d=b().createRange(),e,f;e=u.convertStepsToDomPoint(a);c?(f=u.convertStepsToDomPoint(a+c),0<c?(d.setStart(e.node,e.offset),d.setEnd(f.node,f.offset)):
(d.setStart(f.node,f.offset),d.setEnd(e.node,e.offset))):d.setStart(e.node,e.offset);return d};this.getStyleElement=q;this.upgradeWhitespacesAtPosition=function(b){var c=f(b),c=new core.StepIterator(v,c),d,e=2;runtime.assert(c.isStep(),"positionIterator is not at a step (requested step: "+b+")");do{if(d=a.getContentBounds(c))if(b=d.container,d=d.startOffset,b.nodeType===Node.TEXT_NODE&&n.isSignificantWhitespace(b,d)){runtime.assert(" "===b.data[d],"upgradeWhitespaceToElement: textNode.data[offset] should be a literal space");
var g=b.ownerDocument.createElementNS(odf.Namespaces.textns,"text:s"),k=b.parentNode,h=b;g.appendChild(b.ownerDocument.createTextNode(" "));1===b.length?k.replaceChild(g,b):(b.deleteData(d,1),0<d&&(d<b.length&&b.splitText(d),h=b.nextSibling),k.insertBefore(g,h));b=g;c.setPosition(b,b.childNodes.length);c.roundToPreviousStep()}e-=1}while(0<e&&c.nextStep())};this.downgradeWhitespacesAtPosition=function(b){var c=f(b),c=new core.StepIterator(v,c),d=[],e,g=2;runtime.assert(c.isStep(),"positionIterator is not at a step (requested step: "+
b+")");do{if(b=a.getContentBounds(c))if(b=b.container,n.isDowngradableSpaceElement(b)){for(e=b.lastChild;b.firstChild;)d.push(b.firstChild),b.parentNode.insertBefore(b.firstChild,b);b.parentNode.removeChild(b);c.setPosition(e,e.nodeType===Node.TEXT_NODE?e.length:e.childNodes.length);c.roundToPreviousStep()}g-=1}while(0<g&&c.nextStep());d.forEach(k.normalizeTextNodes)};this.getParagraphStyleElement=m;this.getParagraphElement=p;this.getParagraphStyleAttributes=function(a){return(a=m(a))?h.getFormatting().getInheritedStyleAttributes(a,
!1):null};this.getTextNodeAtStep=function(a,d){var e=f(a),g=e.container(),k,h=0,l=null;g.nodeType===Node.TEXT_NODE?(k=g,h=e.unfilteredDomOffset(),0<k.length&&(0<h&&(k=k.splitText(h)),k.parentNode.insertBefore(b().createTextNode(""),k),k=k.previousSibling,h=0)):(k=b().createTextNode(""),h=0,g.insertBefore(k,e.rightNode()));if(d){if(t[d]&&c.getCursorPosition(d)===a){for(l=t[d].getNode();l.nextSibling&&"cursor"===l.nextSibling.localName;)l.parentNode.insertBefore(l.nextSibling,l);0<k.length&&k.nextSibling!==
l&&(k=b().createTextNode(""),h=0);l.parentNode.insertBefore(k,l)}}else for(;k.nextSibling&&"cursor"===k.nextSibling.localName;)k.parentNode.insertBefore(k.nextSibling,k);for(;k.previousSibling&&k.previousSibling.nodeType===Node.TEXT_NODE;)e=k.previousSibling,e.appendData(k.data),h=e.length,k=e,k.parentNode.removeChild(k.nextSibling);for(;k.nextSibling&&k.nextSibling.nodeType===Node.TEXT_NODE;)e=k.nextSibling,k.appendData(e.data),k.parentNode.removeChild(e);return{textNode:k,offset:h}};this.fixCursorPositions=
function(){Object.keys(t).forEach(function(a){var b=t[a],e=d(b.getNode()),f=c.createRootFilter(e),g,k,h,n=!1;h=b.getSelectedRange();g=r(h.startContainer,h.startOffset,e);k=l(h.startContainer,h.startOffset,[v,f],g);h.collapsed?e=k:(g=r(h.endContainer,h.endOffset,e),e=l(h.endContainer,h.endOffset,[v,f],g));k.isStep()&&e.isStep()?k.container()!==e.container()||k.offset()!==e.offset()||h.collapsed&&b.getAnchorNode()===b.getNode()||(n=!0,h.setStart(k.container(),k.offset()),h.collapse(!0)):(n=!0,runtime.assert(k.roundToClosestStep(),
"No walkable step found for cursor owned by "+a),h.setStart(k.container(),k.offset()),runtime.assert(e.roundToClosestStep(),"No walkable step found for cursor owned by "+a),h.setEnd(e.container(),e.offset()));n&&(b.setSelectedRange(h,b.hasForwardSelection()),c.emit(ops.Document.signalCursorMoved,b))})};this.getCursorPosition=function(a){return(a=t[a])?u.convertDomPointToSteps(a.getNode(),0):0};this.getCursorSelection=function(a){a=t[a];var b=0,c=0;a&&(b=u.convertDomPointToSteps(a.getNode(),0),c=u.convertDomPointToSteps(a.getAnchorNode(),
0));return{position:c,length:b-c}};this.getPositionFilter=function(){return v};this.getOdfCanvas=function(){return h};this.getCanvas=function(){return h};this.getRootNode=g;this.addMember=function(a){runtime.assert(void 0===s[a.getMemberId()],"This member already exists");s[a.getMemberId()]=a};this.getMember=function(a){return s.hasOwnProperty(a)?s[a]:null};this.removeMember=function(a){delete s[a]};this.getCursor=function(a){return t[a]};this.getMemberIds=function(){var a=[],b;for(b in t)t.hasOwnProperty(b)&&
a.push(t[b].getMemberId());return a};this.addCursor=function(a){runtime.assert(Boolean(a),"OdtDocument::addCursor without cursor");var b=a.getMemberId(),d=c.convertCursorToDomRange(0,0);runtime.assert("string"===typeof b,"OdtDocument::addCursor has cursor without memberid");runtime.assert(!t[b],"OdtDocument::addCursor is adding a duplicate cursor with memberid "+b);a.setSelectedRange(d,!0);t[b]=a};this.removeCursor=function(a){var b=t[a];return b?(b.removeFromDocument(),delete t[a],c.emit(ops.Document.signalCursorRemoved,
a),!0):!1};this.moveCursor=function(a,b,d,e){a=t[a];b=c.convertCursorToDomRange(b,d);a&&(a.setSelectedRange(b,0<=d),a.setSelectionType(e||ops.OdtCursor.RangeSelection))};this.getFormatting=function(){return h.getFormatting()};this.emit=function(a,b){y.emit(a,b)};this.subscribe=function(a,b){y.subscribe(a,b)};this.unsubscribe=function(a,b){y.unsubscribe(a,b)};this.createRootFilter=function(a){return new e(a)};this.close=function(a){a()};this.destroy=function(a){a()};v=new ops.TextPositionFilter(g);
n=new odf.OdfUtils;k=new core.DomUtils;a=new odf.StepUtils;u=new ops.OdtStepsTranslator(g,gui.SelectionMover.createPositionIterator,v,500);y.subscribe(ops.OdtDocument.signalStepsInserted,u.handleStepsInserted);y.subscribe(ops.OdtDocument.signalStepsRemoved,u.handleStepsRemoved);y.subscribe(ops.OdtDocument.signalOperationEnd,function(a){var b=a.spec(),d=b.memberid,e=(new Date(b.timestamp)).toISOString(),f=h.odfContainer(),g={setProperties:{},removedProperties:[]};a.isEdit&&("UpdateMetadata"===b.optype&&
(g.setProperties=JSON.parse(JSON.stringify(b.setProperties)),b.removedProperties&&(g.removedProperties=b.removedProperties.attributes.split(","))),b=c.getMember(d).getProperties().fullName,f.setMetadata({"dc:creator":b,"dc:date":e},null),g.setProperties["dc:creator"]=b,g.setProperties["dc:date"]=e,C||(g.setProperties["meta:editing-cycles"]=f.incrementEditingCycles(),f.setMetadata(null,["meta:editing-duration","meta:document-statistic"])),C=a,c.emit(ops.OdtDocument.signalMetadataUpdated,g))});y.subscribe(ops.OdtDocument.signalProcessingBatchEnd,
core.Task.processTasks)};ops.OdtDocument.signalParagraphChanged="paragraph/changed";ops.OdtDocument.signalTableAdded="table/added";ops.OdtDocument.signalCommonStyleCreated="style/created";ops.OdtDocument.signalCommonStyleDeleted="style/deleted";ops.OdtDocument.signalParagraphStyleModified="paragraphstyle/modified";ops.OdtDocument.signalOperationStart="operation/start";ops.OdtDocument.signalOperationEnd="operation/end";ops.OdtDocument.signalProcessingBatchStart="router/batchstart";
ops.OdtDocument.signalProcessingBatchEnd="router/batchend";ops.OdtDocument.signalUndoStackChanged="undo/changed";ops.OdtDocument.signalStepsInserted="steps/inserted";ops.OdtDocument.signalStepsRemoved="steps/removed";ops.OdtDocument.signalMetadataUpdated="metadata/updated";
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
ops.OpAddAnnotation=function(){function h(b,d,e){var f=b.getTextNodeAtStep(e,g);f&&(b=f.textNode,e=b.parentNode,f.offset!==b.length&&b.splitText(f.offset),e.insertBefore(d,b.nextSibling),0===b.length&&e.removeChild(b))}var g,b,d,e,l,f;this.init=function(f){g=f.memberid;b=parseInt(f.timestamp,10);d=parseInt(f.position,10);e=parseInt(f.length,10)||0;l=f.name};this.isEdit=!0;this.group=void 0;this.execute=function(p){var q=p.getCursor(g),m,r;r=new core.DomUtils;f=p.getDOMDocument();var c=new Date(b),
a,n,k,t;a=f.createElementNS(odf.Namespaces.officens,"office:annotation");a.setAttributeNS(odf.Namespaces.officens,"office:name",l);m=f.createElementNS(odf.Namespaces.dcns,"dc:creator");m.setAttributeNS("urn:webodf:names:editinfo","editinfo:memberid",g);m.textContent=p.getMember(g).getProperties().fullName;n=f.createElementNS(odf.Namespaces.dcns,"dc:date");n.appendChild(f.createTextNode(c.toISOString()));c=f.createElementNS(odf.Namespaces.textns,"text:list");k=f.createElementNS(odf.Namespaces.textns,
"text:list-item");t=f.createElementNS(odf.Namespaces.textns,"text:p");k.appendChild(t);c.appendChild(k);a.appendChild(m);a.appendChild(n);a.appendChild(c);e&&(m=f.createElementNS(odf.Namespaces.officens,"office:annotation-end"),m.setAttributeNS(odf.Namespaces.officens,"office:name",l),a.annotationEndElement=m,h(p,m,d+e));h(p,a,d);p.emit(ops.OdtDocument.signalStepsInserted,{position:d});q&&(m=f.createRange(),r=r.getElementsByTagNameNS(a,odf.Namespaces.textns,"p")[0],m.selectNodeContents(r),q.setSelectedRange(m,
!1),p.emit(ops.Document.signalCursorMoved,q));p.getOdfCanvas().addAnnotation(a);p.fixCursorPositions();return!0};this.spec=function(){return{optype:"AddAnnotation",memberid:g,timestamp:b,position:d,length:e,name:l}}};
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
ops.OpAddCursor=function(){var h,g;this.init=function(b){h=b.memberid;g=b.timestamp};this.isEdit=!1;this.group=void 0;this.execute=function(b){var d=b.getCursor(h);if(d)return!1;d=new ops.OdtCursor(h,b);b.addCursor(d);b.emit(ops.Document.signalCursorAdded,d);return!0};this.spec=function(){return{optype:"AddCursor",memberid:h,timestamp:g}}};
// Input 52
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
ops.OpAddMember=function(){var h,g,b;this.init=function(d){h=d.memberid;g=parseInt(d.timestamp,10);b=d.setProperties};this.isEdit=!1;this.group=void 0;this.execute=function(d){var e;if(d.getMember(h))return!1;e=new ops.Member(h,b);d.addMember(e);d.emit(ops.Document.signalMemberAdded,e);return!0};this.spec=function(){return{optype:"AddMember",memberid:h,timestamp:g,setProperties:b}}};
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
ops.OpAddStyle=function(){var h,g,b,d,e,l,f=odf.Namespaces.stylens;this.init=function(f){h=f.memberid;g=f.timestamp;b=f.styleName;d=f.styleFamily;e="true"===f.isAutomaticStyle||!0===f.isAutomaticStyle;l=f.setProperties};this.isEdit=!0;this.group=void 0;this.execute=function(g){var h=g.getOdfCanvas().odfContainer(),m=g.getFormatting(),r=g.getDOMDocument().createElementNS(f,"style:style");if(!r)return!1;l&&m.updateStyle(r,l);r.setAttributeNS(f,"style:family",d);r.setAttributeNS(f,"style:name",b);e?
h.rootElement.automaticStyles.appendChild(r):h.rootElement.styles.appendChild(r);g.getOdfCanvas().refreshCSS();e||g.emit(ops.OdtDocument.signalCommonStyleCreated,{name:b,family:d});return!0};this.spec=function(){return{optype:"AddStyle",memberid:h,timestamp:g,styleName:b,styleFamily:d,isAutomaticStyle:e,setProperties:l}}};
// Input 54
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
odf.ObjectNameGenerator=function(h,g){function b(a,b){var c={};this.generateName=function(){var d=b(),e=0,f;do f=a+e,e+=1;while(c[f]||d[f]);c[f]=!0;return f}}function d(){var a={};[h.rootElement.automaticStyles,h.rootElement.styles].forEach(function(b){for(b=b.firstElementChild;b;)b.namespaceURI===e&&"style"===b.localName&&(a[b.getAttributeNS(e,"name")]=!0),b=b.nextElementSibling});return a}var e=odf.Namespaces.stylens,l=odf.Namespaces.drawns,f=odf.Namespaces.xlinkns,p=new core.DomUtils,q=(new core.Utils).hashString(g),
m=null,r=null,c=null,a={},n={};this.generateStyleName=function(){null===m&&(m=new b("auto"+q+"_",function(){return d()}));return m.generateName()};this.generateFrameName=function(){null===r&&(p.getElementsByTagNameNS(h.rootElement.body,l,"frame").forEach(function(b){a[b.getAttributeNS(l,"name")]=!0}),r=new b("fr"+q+"_",function(){return a}));return r.generateName()};this.generateImageName=function(){null===c&&(p.getElementsByTagNameNS(h.rootElement.body,l,"image").forEach(function(a){a=a.getAttributeNS(f,
"href");a=a.substring(9,a.lastIndexOf("."));n[a]=!0}),c=new b("img"+q+"_",function(){return n}));return c.generateName()}};
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
odf.TextStyleApplicator=function(h,g,b){function d(b){function d(a,b){return"object"===typeof a&&"object"===typeof b?Object.keys(a).every(function(c){return d(a[c],b[c])}):a===b}var c={};this.isStyleApplied=function(a){a=g.getAppliedStylesForElement(a,c);return d(b,a)}}function e(d){var e={};this.applyStyleToContainer=function(c){var a;a=c.getAttributeNS(p,"style-name");var f=c.ownerDocument;a=a||"";if(!e.hasOwnProperty(a)){var k=a,l;l=a?g.createDerivedStyleObject(a,"text",d):d;f=f.createElementNS(q,
"style:style");g.updateStyle(f,l);f.setAttributeNS(q,"style:name",h.generateStyleName());f.setAttributeNS(q,"style:family","text");f.setAttributeNS("urn:webodf:names:scope","scope","document-content");b.appendChild(f);e[k]=f}a=e[a].getAttributeNS(q,"name");c.setAttributeNS(p,"text:style-name",a)}}function l(b,d){var c=b.ownerDocument,a=b.parentNode,e,g,h,l=new core.LoopWatchDog(1E4);g=[];g.push(b);for(h=b.nextSibling;h&&f.rangeContainsNode(d,h);)l.check(),g.push(h),h=h.nextSibling;"span"!==a.localName||
a.namespaceURI!==p?(e=c.createElementNS(p,"text:span"),a.insertBefore(e,b),c=!1):(b.previousSibling&&!f.rangeContainsNode(d,a.firstChild)?(e=a.cloneNode(!1),a.parentNode.insertBefore(e,a.nextSibling)):e=a,c=!0);g.forEach(function(a){a.parentNode!==e&&e.appendChild(a)});if(h&&c)for(g=e.cloneNode(!1),e.parentNode.insertBefore(g,e.nextSibling);h;)l.check(),c=h.nextSibling,g.appendChild(h),h=c;return e}var f=new core.DomUtils,p=odf.Namespaces.textns,q=odf.Namespaces.stylens;this.applyStyle=function(b,
f,c){var a={},g,h,p,q;runtime.assert(c&&c.hasOwnProperty("style:text-properties"),"applyStyle without any text properties");a["style:text-properties"]=c["style:text-properties"];p=new e(a);q=new d(a);b.forEach(function(a){g=q.isStyleApplied(a);!1===g&&(h=l(a,f),p.applyStyleToContainer(h))})}};
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
ops.OpApplyDirectStyling=function(){function h(b,d,e){var c=b.getOdfCanvas().odfContainer(),a=p.splitBoundaries(d),h=f.getTextNodes(d,!1);(new odf.TextStyleApplicator(new odf.ObjectNameGenerator(c,g),b.getFormatting(),c.rootElement.automaticStyles)).applyStyle(h,d,e);a.forEach(p.normalizeTextNodes)}var g,b,d,e,l,f=new odf.OdfUtils,p=new core.DomUtils;this.init=function(f){g=f.memberid;b=f.timestamp;d=parseInt(f.position,10);e=parseInt(f.length,10);l=f.setProperties};this.isEdit=!0;this.group=void 0;
this.execute=function(p){var m=p.convertCursorToDomRange(d,e),r=f.getParagraphElements(m);h(p,m,l);m.detach();p.getOdfCanvas().refreshCSS();p.fixCursorPositions();r.forEach(function(c){p.emit(ops.OdtDocument.signalParagraphChanged,{paragraphElement:c,memberId:g,timeStamp:b})});p.getOdfCanvas().rerenderAnnotations();return!0};this.spec=function(){return{optype:"ApplyDirectStyling",memberid:g,timestamp:b,position:d,length:e,setProperties:l}}};
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
ops.OpApplyHyperlink=function(){function h(b){for(;b;){if(p.isHyperlink(b))return!0;b=b.parentNode}return!1}var g,b,d,e,l,f=new core.DomUtils,p=new odf.OdfUtils;this.init=function(f){g=f.memberid;b=f.timestamp;d=f.position;e=f.length;l=f.hyperlink};this.isEdit=!0;this.group=void 0;this.execute=function(q){var m=q.getDOMDocument(),r=q.convertCursorToDomRange(d,e),c=f.splitBoundaries(r),a=[],n=p.getTextNodes(r,!1);if(0===n.length)return!1;n.forEach(function(b){var c=p.getParagraphElement(b);runtime.assert(!1===
h(b),"The given range should not contain any link.");var d=l,e=m.createElementNS(odf.Namespaces.textns,"text:a");e.setAttributeNS(odf.Namespaces.xlinkns,"xlink:type","simple");e.setAttributeNS(odf.Namespaces.xlinkns,"xlink:href",d);b.parentNode.insertBefore(e,b);e.appendChild(b);-1===a.indexOf(c)&&a.push(c)});c.forEach(f.normalizeTextNodes);r.detach();q.getOdfCanvas().refreshSize();q.getOdfCanvas().rerenderAnnotations();a.forEach(function(a){q.emit(ops.OdtDocument.signalParagraphChanged,{paragraphElement:a,
memberId:g,timeStamp:b})});return!0};this.spec=function(){return{optype:"ApplyHyperlink",memberid:g,timestamp:b,position:d,length:e,hyperlink:l}}};
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
ops.OpInsertImage=function(){var h,g,b,d,e,l,f,p,q=odf.Namespaces.drawns,m=odf.Namespaces.svgns,r=odf.Namespaces.textns,c=odf.Namespaces.xlinkns;this.init=function(a){h=a.memberid;g=a.timestamp;b=a.position;d=a.filename;e=a.frameWidth;l=a.frameHeight;f=a.frameStyleName;p=a.frameName};this.isEdit=!0;this.group=void 0;this.execute=function(a){var n=a.getOdfCanvas(),k=a.getTextNodeAtStep(b,h),t,s;if(!k)return!1;t=k.textNode;s=a.getParagraphElement(t);var k=k.offset!==t.length?t.splitText(k.offset):t.nextSibling,
y=a.getDOMDocument(),z=y.createElementNS(q,"draw:image"),y=y.createElementNS(q,"draw:frame");z.setAttributeNS(c,"xlink:href",d);z.setAttributeNS(c,"xlink:type","simple");z.setAttributeNS(c,"xlink:show","embed");z.setAttributeNS(c,"xlink:actuate","onLoad");y.setAttributeNS(q,"draw:style-name",f);y.setAttributeNS(q,"draw:name",p);y.setAttributeNS(r,"text:anchor-type","as-char");y.setAttributeNS(m,"svg:width",e);y.setAttributeNS(m,"svg:height",l);y.appendChild(z);t.parentNode.insertBefore(y,k);a.emit(ops.OdtDocument.signalStepsInserted,
{position:b});0===t.length&&t.parentNode.removeChild(t);n.addCssForFrameWithImage(y);n.refreshCSS();a.emit(ops.OdtDocument.signalParagraphChanged,{paragraphElement:s,memberId:h,timeStamp:g});n.rerenderAnnotations();return!0};this.spec=function(){return{optype:"InsertImage",memberid:h,timestamp:g,filename:d,position:b,frameWidth:e,frameHeight:l,frameStyleName:f,frameName:p}}};
// Input 59
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
ops.OpInsertTable=function(){function h(b,c){var a;if(1===m.length)a=m[0];else if(3===m.length)switch(b){case 0:a=m[0];break;case d-1:a=m[2];break;default:a=m[1]}else a=m[b];if(1===a.length)return a[0];if(3===a.length)switch(c){case 0:return a[0];case e-1:return a[2];default:return a[1]}return a[c]}var g,b,d,e,l,f,p,q,m;this.init=function(h){g=h.memberid;b=h.timestamp;l=h.position;d=h.initialRows;e=h.initialColumns;f=h.tableName;p=h.tableStyleName;q=h.tableColumnStyleName;m=h.tableCellStyleMatrix};
this.isEdit=!0;this.group=void 0;this.execute=function(m){var c=m.getTextNodeAtStep(l),a=m.getRootNode();if(c){var n=m.getDOMDocument(),k=n.createElementNS("urn:oasis:names:tc:opendocument:xmlns:table:1.0","table:table"),t=n.createElementNS("urn:oasis:names:tc:opendocument:xmlns:table:1.0","table:table-column"),s,y,z,w;p&&k.setAttributeNS("urn:oasis:names:tc:opendocument:xmlns:table:1.0","table:style-name",p);f&&k.setAttributeNS("urn:oasis:names:tc:opendocument:xmlns:table:1.0","table:name",f);t.setAttributeNS("urn:oasis:names:tc:opendocument:xmlns:table:1.0",
"table:number-columns-repeated",e);q&&t.setAttributeNS("urn:oasis:names:tc:opendocument:xmlns:table:1.0","table:style-name",q);k.appendChild(t);for(z=0;z<d;z+=1){t=n.createElementNS("urn:oasis:names:tc:opendocument:xmlns:table:1.0","table:table-row");for(w=0;w<e;w+=1)s=n.createElementNS("urn:oasis:names:tc:opendocument:xmlns:table:1.0","table:table-cell"),(y=h(z,w))&&s.setAttributeNS("urn:oasis:names:tc:opendocument:xmlns:table:1.0","table:style-name",y),y=n.createElementNS("urn:oasis:names:tc:opendocument:xmlns:text:1.0",
"text:p"),s.appendChild(y),t.appendChild(s);k.appendChild(t)}c=m.getParagraphElement(c.textNode);a.insertBefore(k,c.nextSibling);m.emit(ops.OdtDocument.signalStepsInserted,{position:l});m.getOdfCanvas().refreshSize();m.emit(ops.OdtDocument.signalTableAdded,{tableElement:k,memberId:g,timeStamp:b});m.getOdfCanvas().rerenderAnnotations();return!0}return!1};this.spec=function(){return{optype:"InsertTable",memberid:g,timestamp:b,position:l,initialRows:d,initialColumns:e,tableName:f,tableStyleName:p,tableColumnStyleName:q,
tableCellStyleMatrix:m}}};
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
ops.OpInsertText=function(){var h,g,b,d,e,l=new odf.OdfUtils;this.init=function(f){h=f.memberid;g=f.timestamp;b=f.position;e=f.text;d="true"===f.moveCursor||!0===f.moveCursor};this.isEdit=!0;this.group=void 0;this.execute=function(f){var p,q,m,r=null,c=f.getDOMDocument(),a,n=0,k,t=f.getCursor(h),s;f.upgradeWhitespacesAtPosition(b);if(p=f.getTextNodeAtStep(b)){q=p.textNode;r=q.nextSibling;m=q.parentNode;a=f.getParagraphElement(q);for(s=0;s<e.length;s+=1)if("\t"===e[s]||"\t"!==e[s]&&l.isODFWhitespace(e[s])&&
(0===s||s===e.length-1||"\t"!==e[s-1]&&l.isODFWhitespace(e[s-1])))0===n?(p.offset!==q.length&&(r=q.splitText(p.offset)),0<s&&q.appendData(e.substring(0,s))):n<s&&(n=e.substring(n,s),m.insertBefore(c.createTextNode(n),r)),n=s+1,"\t"===e[s]?(k=c.createElementNS("urn:oasis:names:tc:opendocument:xmlns:text:1.0","text:tab"),k.appendChild(c.createTextNode("\t"))):(" "!==e[s]&&runtime.log("WARN: InsertText operation contains non-tab, non-space whitespace character (character code "+e.charCodeAt(s)+")"),
k=c.createElementNS("urn:oasis:names:tc:opendocument:xmlns:text:1.0","text:s"),k.appendChild(c.createTextNode(" "))),m.insertBefore(k,r);0===n?q.insertData(p.offset,e):n<e.length&&(p=e.substring(n),m.insertBefore(c.createTextNode(p),r));m=q.parentNode;r=q.nextSibling;m.removeChild(q);m.insertBefore(q,r);0===q.length&&q.parentNode.removeChild(q);f.emit(ops.OdtDocument.signalStepsInserted,{position:b});t&&d&&(f.moveCursor(h,b+e.length,0),f.emit(ops.Document.signalCursorMoved,t));f.downgradeWhitespacesAtPosition(b);
f.downgradeWhitespacesAtPosition(b+e.length);f.getOdfCanvas().refreshSize();f.emit(ops.OdtDocument.signalParagraphChanged,{paragraphElement:a,memberId:h,timeStamp:g});f.getOdfCanvas().rerenderAnnotations();return!0}return!1};this.spec=function(){return{optype:"InsertText",memberid:h,timestamp:g,position:b,text:e,moveCursor:d}}};
// Input 61
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
ops.OpMoveCursor=function(){var h,g,b,d,e;this.init=function(l){h=l.memberid;g=l.timestamp;b=l.position;d=l.length||0;e=l.selectionType||ops.OdtCursor.RangeSelection};this.isEdit=!1;this.group=void 0;this.execute=function(g){var f=g.getCursor(h),p;if(!f)return!1;p=g.convertCursorToDomRange(b,d);f.setSelectedRange(p,0<=d);f.setSelectionType(e);g.emit(ops.Document.signalCursorMoved,f);return!0};this.spec=function(){return{optype:"MoveCursor",memberid:h,timestamp:g,position:b,length:d,selectionType:e}}};
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
ops.OpRemoveAnnotation=function(){var h,g,b,d,e;this.init=function(l){h=l.memberid;g=l.timestamp;b=parseInt(l.position,10);d=parseInt(l.length,10);e=new core.DomUtils};this.isEdit=!0;this.group=void 0;this.execute=function(d){function f(b){h.parentNode.insertBefore(b,h)}for(var g=d.getIteratorAtPosition(b).container(),h;g.namespaceURI!==odf.Namespaces.officens||"annotation"!==g.localName;)g=g.parentNode;if(null===g)return!1;h=g;g=h.annotationEndElement;d.getOdfCanvas().forgetAnnotations();e.getElementsByTagNameNS(h,
"urn:webodf:names:cursor","cursor").forEach(f);e.getElementsByTagNameNS(h,"urn:webodf:names:cursor","anchor").forEach(f);h.parentNode.removeChild(h);g&&g.parentNode.removeChild(g);d.emit(ops.OdtDocument.signalStepsRemoved,{position:0<b?b-1:b});d.fixCursorPositions();d.getOdfCanvas().refreshAnnotations();return!0};this.spec=function(){return{optype:"RemoveAnnotation",memberid:h,timestamp:g,position:b,length:d}}};
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
ops.OpRemoveBlob=function(){var h,g,b;this.init=function(d){h=d.memberid;g=d.timestamp;b=d.filename};this.isEdit=!0;this.group=void 0;this.execute=function(d){d.getOdfCanvas().odfContainer().removeBlob(b);return!0};this.spec=function(){return{optype:"RemoveBlob",memberid:h,timestamp:g,filename:b}}};
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
ops.OpRemoveCursor=function(){var h,g;this.init=function(b){h=b.memberid;g=b.timestamp};this.isEdit=!1;this.group=void 0;this.execute=function(b){return b.removeCursor(h)?!0:!1};this.spec=function(){return{optype:"RemoveCursor",memberid:h,timestamp:g}}};
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
ops.OpRemoveHyperlink=function(){var h,g,b,d,e=new core.DomUtils,l=new odf.OdfUtils;this.init=function(e){h=e.memberid;g=e.timestamp;b=e.position;d=e.length};this.isEdit=!0;this.group=void 0;this.execute=function(f){var p=f.convertCursorToDomRange(b,d),q=l.getHyperlinkElements(p);runtime.assert(1===q.length,"The given range should only contain a single link.");q=e.mergeIntoParent(q[0]);p.detach();f.getOdfCanvas().refreshSize();f.emit(ops.OdtDocument.signalParagraphChanged,{paragraphElement:l.getParagraphElement(q),
memberId:h,timeStamp:g});f.getOdfCanvas().rerenderAnnotations();return!0};this.spec=function(){return{optype:"RemoveHyperlink",memberid:h,timestamp:g,position:b,length:d}}};
// Input 66
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
ops.OpRemoveMember=function(){var h,g;this.init=function(b){h=b.memberid;g=parseInt(b.timestamp,10)};this.isEdit=!1;this.group=void 0;this.execute=function(b){if(!b.getMember(h))return!1;b.removeMember(h);b.emit(ops.Document.signalMemberRemoved,h);return!0};this.spec=function(){return{optype:"RemoveMember",memberid:h,timestamp:g}}};
// Input 67
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
ops.OpRemoveStyle=function(){var h,g,b,d;this.init=function(e){h=e.memberid;g=e.timestamp;b=e.styleName;d=e.styleFamily};this.isEdit=!0;this.group=void 0;this.execute=function(e){var g=e.getStyleElement(b,d);if(!g)return!1;g.parentNode.removeChild(g);e.getOdfCanvas().refreshCSS();e.emit(ops.OdtDocument.signalCommonStyleDeleted,{name:b,family:d});return!0};this.spec=function(){return{optype:"RemoveStyle",memberid:h,timestamp:g,styleName:b,styleFamily:d}}};
// Input 68
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
ops.OpRemoveText=function(){function h(b){function d(b){return l.isODFNode(b)||"br"===b.localName&&l.isLineBreak(b.parentNode)||b.nodeType===Node.TEXT_NODE&&l.isODFNode(b.parentNode)}function e(g){var c;g.nodeType===Node.TEXT_NODE?(c=g.parentNode,c.removeChild(g)):c=f.removeUnwantedNodes(g,d);return c&&!l.isParagraph(c)&&c!==b&&l.hasNoODFContent(c)?e(c):c}this.mergeChildrenIntoParent=e}var g,b,d,e,l,f;this.init=function(h){runtime.assert(0<=h.length,"OpRemoveText only supports positive lengths");
g=h.memberid;b=h.timestamp;d=parseInt(h.position,10);e=parseInt(h.length,10);l=new odf.OdfUtils;f=new core.DomUtils};this.isEdit=!0;this.group=void 0;this.execute=function(p){var q,m,r,c,a=p.getCursor(g),n=new h(p.getRootNode());p.upgradeWhitespacesAtPosition(d);p.upgradeWhitespacesAtPosition(d+e);m=p.convertCursorToDomRange(d,e);f.splitBoundaries(m);q=p.getParagraphElement(m.startContainer);r=l.getTextElements(m,!1,!0);c=l.getParagraphElements(m);m.detach();r.forEach(function(a){a.parentNode?n.mergeChildrenIntoParent(a):
runtime.log("WARN: text element has already been removed from it's container")});m=c.reduce(function(a,b){for(var c;b.firstChild;)c=b.firstChild,b.removeChild(c),"editinfo"!==c.localName&&a.appendChild(c);n.mergeChildrenIntoParent(b);return a});p.emit(ops.OdtDocument.signalStepsRemoved,{position:d});p.downgradeWhitespacesAtPosition(d);p.fixCursorPositions();p.getOdfCanvas().refreshSize();p.emit(ops.OdtDocument.signalParagraphChanged,{paragraphElement:m||q,memberId:g,timeStamp:b});a&&(a.resetSelectionType(),
p.emit(ops.Document.signalCursorMoved,a));p.getOdfCanvas().rerenderAnnotations();return!0};this.spec=function(){return{optype:"RemoveText",memberid:g,timestamp:b,position:d,length:e}}};
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
ops.OpSetBlob=function(){var h,g,b,d,e;this.init=function(l){h=l.memberid;g=l.timestamp;b=l.filename;d=l.mimetype;e=l.content};this.isEdit=!0;this.group=void 0;this.execute=function(g){g.getOdfCanvas().odfContainer().setBlob(b,d,e);return!0};this.spec=function(){return{optype:"SetBlob",memberid:h,timestamp:g,filename:b,mimetype:d,content:e}}};
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
ops.OpSetParagraphStyle=function(){var h,g,b,d;this.init=function(e){h=e.memberid;g=e.timestamp;b=e.position;d=e.styleName};this.isEdit=!0;this.group=void 0;this.execute=function(e){var l;l=e.getIteratorAtPosition(b);return(l=e.getParagraphElement(l.container()))?(""!==d?l.setAttributeNS("urn:oasis:names:tc:opendocument:xmlns:text:1.0","text:style-name",d):l.removeAttributeNS("urn:oasis:names:tc:opendocument:xmlns:text:1.0","style-name"),e.getOdfCanvas().refreshSize(),e.emit(ops.OdtDocument.signalParagraphChanged,
{paragraphElement:l,timeStamp:g,memberId:h}),e.getOdfCanvas().rerenderAnnotations(),!0):!1};this.spec=function(){return{optype:"SetParagraphStyle",memberid:h,timestamp:g,position:b,styleName:d}}};
// Input 71
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
ops.OpSplitParagraph=function(){var h,g,b,d,e;this.init=function(l){h=l.memberid;g=l.timestamp;b=l.position;d="true"===l.moveCursor||!0===l.moveCursor;e=new odf.OdfUtils};this.isEdit=!0;this.group=void 0;this.execute=function(l){var f,p,q,m,r,c,a,n=l.getCursor(h);l.upgradeWhitespacesAtPosition(b);f=l.getTextNodeAtStep(b);if(!f)return!1;p=l.getParagraphElement(f.textNode);if(!p)return!1;q=e.isListItem(p.parentNode)?p.parentNode:p;0===f.offset?(a=f.textNode.previousSibling,c=null):(a=f.textNode,c=f.offset>=
f.textNode.length?null:f.textNode.splitText(f.offset));for(m=f.textNode;m!==q;){m=m.parentNode;r=m.cloneNode(!1);c&&r.appendChild(c);if(a)for(;a&&a.nextSibling;)r.appendChild(a.nextSibling);else for(;m.firstChild;)r.appendChild(m.firstChild);m.parentNode.insertBefore(r,m.nextSibling);a=m;c=r}e.isListItem(c)&&(c=c.childNodes.item(0));0===f.textNode.length&&f.textNode.parentNode.removeChild(f.textNode);l.emit(ops.OdtDocument.signalStepsInserted,{position:b});n&&d&&(l.moveCursor(h,b+1,0),l.emit(ops.Document.signalCursorMoved,
n));l.fixCursorPositions();l.getOdfCanvas().refreshSize();l.emit(ops.OdtDocument.signalParagraphChanged,{paragraphElement:p,memberId:h,timeStamp:g});l.emit(ops.OdtDocument.signalParagraphChanged,{paragraphElement:c,memberId:h,timeStamp:g});l.getOdfCanvas().rerenderAnnotations();return!0};this.spec=function(){return{optype:"SplitParagraph",memberid:h,timestamp:g,position:b,moveCursor:d}}};
// Input 72
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
ops.OpUpdateMember=function(){function h(b){var e="//dc:creator[@editinfo:memberid='"+g+"']";b=xmldom.XPath.getODFElementsWithXPath(b.getRootNode(),e,function(b){return"editinfo"===b?"urn:webodf:names:editinfo":odf.Namespaces.lookupNamespaceURI(b)});for(e=0;e<b.length;e+=1)b[e].textContent=d.fullName}var g,b,d,e;this.init=function(h){g=h.memberid;b=parseInt(h.timestamp,10);d=h.setProperties;e=h.removedProperties};this.isEdit=!1;this.group=void 0;this.execute=function(b){var f=b.getMember(g);if(!f)return!1;
e&&f.removeProperties(e);d&&(f.setProperties(d),d.fullName&&h(b));b.emit(ops.Document.signalMemberUpdated,f);return!0};this.spec=function(){return{optype:"UpdateMember",memberid:g,timestamp:b,setProperties:d,removedProperties:e}}};
// Input 73
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
ops.OpUpdateMetadata=function(){var h,g,b,d;this.init=function(e){h=e.memberid;g=parseInt(e.timestamp,10);b=e.setProperties;d=e.removedProperties};this.isEdit=!0;this.group=void 0;this.execute=function(e){e=e.getOdfCanvas().odfContainer();var g=null;d&&(g=d.attributes.split(","));e.setMetadata(b,g);return!0};this.spec=function(){return{optype:"UpdateMetadata",memberid:h,timestamp:g,setProperties:b,removedProperties:d}}};
// Input 74
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
ops.OpUpdateParagraphStyle=function(){function h(b,d){var e,f,c=d?d.split(","):[];for(e=0;e<c.length;e+=1)f=c[e].split(":"),b.removeAttributeNS(odf.Namespaces.lookupNamespaceURI(f[0]),f[1])}var g,b,d,e,l,f=odf.Namespaces.stylens;this.init=function(f){g=f.memberid;b=f.timestamp;d=f.styleName;e=f.setProperties;l=f.removedProperties};this.isEdit=!0;this.group=void 0;this.execute=function(b){var g=b.getFormatting(),m,r,c;return(m=""!==d?b.getParagraphStyleElement(d):g.getDefaultStyleElement("paragraph"))?
(r=m.getElementsByTagNameNS(f,"paragraph-properties").item(0),c=m.getElementsByTagNameNS(f,"text-properties").item(0),e&&g.updateStyle(m,e),l&&(g=l["style:paragraph-properties"],r&&g&&(h(r,g.attributes),0===r.attributes.length&&m.removeChild(r)),g=l["style:text-properties"],c&&g&&(h(c,g.attributes),0===c.attributes.length&&m.removeChild(c)),h(m,l.attributes)),b.getOdfCanvas().refreshCSS(),b.emit(ops.OdtDocument.signalParagraphStyleModified,d),b.getOdfCanvas().rerenderAnnotations(),!0):!1};this.spec=
function(){return{optype:"UpdateParagraphStyle",memberid:g,timestamp:b,styleName:d,setProperties:e,removedProperties:l}}};
// Input 75
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
ops.OperationFactory=function(){function h(b){return function(d){return new b}}var g;this.register=function(b,d){g[b]=d};this.create=function(b){var d=null,e=g[b.optype];e&&(d=e(b),d.init(b));return d};g={AddMember:h(ops.OpAddMember),UpdateMember:h(ops.OpUpdateMember),RemoveMember:h(ops.OpRemoveMember),AddCursor:h(ops.OpAddCursor),ApplyDirectStyling:h(ops.OpApplyDirectStyling),SetBlob:h(ops.OpSetBlob),RemoveBlob:h(ops.OpRemoveBlob),InsertImage:h(ops.OpInsertImage),InsertTable:h(ops.OpInsertTable),
InsertText:h(ops.OpInsertText),RemoveText:h(ops.OpRemoveText),SplitParagraph:h(ops.OpSplitParagraph),SetParagraphStyle:h(ops.OpSetParagraphStyle),UpdateParagraphStyle:h(ops.OpUpdateParagraphStyle),AddStyle:h(ops.OpAddStyle),RemoveStyle:h(ops.OpRemoveStyle),MoveCursor:h(ops.OpMoveCursor),RemoveCursor:h(ops.OpRemoveCursor),AddAnnotation:h(ops.OpAddAnnotation),RemoveAnnotation:h(ops.OpRemoveAnnotation),UpdateMetadata:h(ops.OpUpdateMetadata),ApplyHyperlink:h(ops.OpApplyHyperlink),RemoveHyperlink:h(ops.OpRemoveHyperlink)}};
// Input 76
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
ops.OperationRouter=function(){};ops.OperationRouter.prototype.setOperationFactory=function(h){};ops.OperationRouter.prototype.setPlaybackFunction=function(h){};ops.OperationRouter.prototype.push=function(h){};ops.OperationRouter.prototype.close=function(h){};ops.OperationRouter.prototype.subscribe=function(h,g){};ops.OperationRouter.prototype.unsubscribe=function(h,g){};ops.OperationRouter.prototype.hasLocalUnsyncedOps=function(){};ops.OperationRouter.prototype.hasSessionHostConnection=function(){};
ops.OperationRouter.signalProcessingBatchStart="router/batchstart";ops.OperationRouter.signalProcessingBatchEnd="router/batchend";
// Input 77
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
ops.TrivialOperationRouter=function(){var h=new core.EventNotifier([ops.OperationRouter.signalProcessingBatchStart,ops.OperationRouter.signalProcessingBatchEnd]),g,b,d=0;this.setOperationFactory=function(b){g=b};this.setPlaybackFunction=function(d){b=d};this.push=function(e){d+=1;h.emit(ops.OperationRouter.signalProcessingBatchStart,{});e.forEach(function(e){e=e.spec();e.timestamp=Date.now();e=g.create(e);e.group="g"+d;b(e)});h.emit(ops.OperationRouter.signalProcessingBatchEnd,{})};this.close=function(b){b()};
this.subscribe=function(b,d){h.subscribe(b,d)};this.unsubscribe=function(b,d){h.unsubscribe(b,d)};this.hasLocalUnsyncedOps=function(){return!1};this.hasSessionHostConnection=function(){return!0}};
// Input 78
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
ops.Session=function(h){function g(b){e.emit(ops.OdtDocument.signalProcessingBatchStart,b)}function b(b){e.emit(ops.OdtDocument.signalProcessingBatchEnd,b)}var d=new ops.OperationFactory,e=new ops.OdtDocument(h),l=null;this.setOperationFactory=function(b){d=b;l&&l.setOperationFactory(d)};this.setOperationRouter=function(f){l&&(l.unsubscribe(ops.OperationRouter.signalProcessingBatchStart,g),l.unsubscribe(ops.OperationRouter.signalProcessingBatchEnd,b));l=f;l.subscribe(ops.OperationRouter.signalProcessingBatchStart,
g);l.subscribe(ops.OperationRouter.signalProcessingBatchEnd,b);f.setPlaybackFunction(function(b){e.emit(ops.OdtDocument.signalOperationStart,b);return b.execute(e)?(e.emit(ops.OdtDocument.signalOperationEnd,b),!0):!1});f.setOperationFactory(d)};this.getOperationFactory=function(){return d};this.getOdtDocument=function(){return e};this.enqueue=function(b){l.push(b)};this.close=function(b){l.close(function(d){d?b(d):e.close(b)})};this.destroy=function(b){e.destroy(b)};this.setOperationRouter(new ops.TrivialOperationRouter)};
// Input 79
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
gui.AnnotationController=function(h,g){function b(){var b=f.getCursor(g),b=b&&b.getNode(),c=!1;if(b){a:{for(c=f.getRootNode();b&&b!==c;){if(b.namespaceURI===m&&"annotation"===b.localName){b=!0;break a}b=b.parentNode}b=!1}c=!b}c!==p&&(p=c,q.emit(gui.AnnotationController.annotatableChanged,p))}function d(d){d.getMemberId()===g&&b()}function e(d){d===g&&b()}function l(d){d.getMemberId()===g&&b()}var f=h.getOdtDocument(),p=!1,q=new core.EventNotifier([gui.AnnotationController.annotatableChanged]),m=odf.Namespaces.officens;
this.isAnnotatable=function(){return p};this.addAnnotation=function(){var b=new ops.OpAddAnnotation,c=f.getCursorSelection(g),a=c.length,c=c.position;p&&(c=0<=a?c:c+a,a=Math.abs(a),b.init({memberid:g,position:c,length:a,name:g+Date.now()}),h.enqueue([b]))};this.removeAnnotation=function(b){var c,a;c=f.convertDomPointToCursorStep(b,0)+1;a=f.convertDomPointToCursorStep(b,b.childNodes.length);b=new ops.OpRemoveAnnotation;b.init({memberid:g,position:c,length:a-c});a=new ops.OpMoveCursor;a.init({memberid:g,
position:0<c?c-1:c,length:0});h.enqueue([b,a])};this.subscribe=function(b,c){q.subscribe(b,c)};this.unsubscribe=function(b,c){q.unsubscribe(b,c)};this.destroy=function(b){f.unsubscribe(ops.Document.signalCursorAdded,d);f.unsubscribe(ops.Document.signalCursorRemoved,e);f.unsubscribe(ops.Document.signalCursorMoved,l);b()};f.subscribe(ops.Document.signalCursorAdded,d);f.subscribe(ops.Document.signalCursorRemoved,e);f.subscribe(ops.Document.signalCursorMoved,l);b()};
gui.AnnotationController.annotatableChanged="annotatable/changed";
// Input 80
gui.Avatar=function(h,g){var b=this,d,e,l;this.setColor=function(b){e.style.borderColor=b};this.setImageUrl=function(d){b.isVisible()?e.src=d:l=d};this.isVisible=function(){return"block"===d.style.display};this.show=function(){l&&(e.src=l,l=void 0);d.style.display="block"};this.hide=function(){d.style.display="none"};this.markAsFocussed=function(b){b?d.classList.add("active"):d.classList.remove("active")};this.destroy=function(b){h.removeChild(d);b()};(function(){var b=h.ownerDocument,l=b.documentElement.namespaceURI;
d=b.createElementNS(l,"div");e=b.createElementNS(l,"img");e.width=64;e.height=64;d.appendChild(e);d.style.width="64px";d.style.height="70px";d.style.position="absolute";d.style.top="-80px";d.style.left="-34px";d.style.display=g?"block":"none";d.className="handle";h.appendChild(d)})()};
// Input 81
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
gui.GuiStepUtils=function(){var h=new odf.OdfUtils,g=new odf.StepUtils,b=new core.DomUtils;this.getContentRect=function(d){d=g.getContentBounds(d);var e,l=null;if(d)if(d.container.nodeType===Node.TEXT_NODE)e=d.container.ownerDocument.createRange(),e.setStart(d.container,d.startOffset),e.setEnd(d.container,d.endOffset),(l=0<e.getClientRects().length?e.getBoundingClientRect():null)&&" "===d.container.data.substring(d.startOffset,d.endOffset)&&1>=l.width&&(l=null),e.detach();else if(h.isCharacterElement(d.container)||
h.isCharacterFrame(d.container))l=b.getBoundingClientRect(d.container);return l}};
// Input 82
gui.Caret=function(h,g,b){function d(){m.style.opacity="0"===m.style.opacity?"1":"0";w.trigger()}function e(){n.selectNodeContents(a);return n.getBoundingClientRect()}function l(){Object.keys(A).forEach(function(a){D[a]=A[a]})}function f(){var a,d,f,g;if(!1===A.isShown||h.getSelectionType()!==ops.OdtCursor.RangeSelection||!b&&!h.getSelectedRange().collapsed)A.visibility="hidden",m.style.visibility="hidden",w.cancel();else{A.visibility="visible";m.style.visibility="visible";if(!1===A.isFocused)m.style.opacity=
"1",w.cancel();else{if(v||D.visibility!==A.visibility)m.style.opacity="1",w.cancel();w.trigger()}if(C||u||D.visibility!==A.visibility){a=h.getNode();var n;f=t.getBoundingClientRect(k.getSizer());g=!1;if(0<a.getClientRects().length)n=e(),g=!0;else if(y.setPosition(a,0),n=s.getContentRect(y),!n&&y.nextStep()&&(d=s.getContentRect(y))&&(n=d,g=!0),n||(a.setAttributeNS("urn:webodf:names:cursor","caret-sizer-active","true"),n=e(),g=!0),!n)for(runtime.log("WARN: No suitable client rectangle found for visual caret for "+
h.getMemberId());a;){if(0<a.getClientRects().length){n=t.getBoundingClientRect(a);g=!0;break}a=a.parentNode}n=t.translateRect(n,f,k.getZoomLevel());a={top:n.top,height:n.height,right:g?n.left:n.right};8>a.height&&(a={top:a.top-(8-a.height)/2,height:8,right:a.right});q.style.height=a.height+"px";q.style.top=a.top+"px";q.style.left=a.right+"px";c&&(a=runtime.getWindow().getComputedStyle(m,null),a.font?c.style.font=a.font:(c.style.fontStyle=a.fontStyle,c.style.fontVariant=a.fontVariant,c.style.fontWeight=
a.fontWeight,c.style.fontSize=a.fontSize,c.style.lineHeight=a.lineHeight,c.style.fontFamily=a.fontFamily))}if(u){n=h.getDocument().getCanvas().getElement().parentNode;var p;f=n.offsetWidth-n.clientWidth+5;g=n.offsetHeight-n.clientHeight+5;p=m.getBoundingClientRect();a=p.left-f;d=p.top-g;f=p.right+f;g=p.bottom+g;p=n.getBoundingClientRect();d<p.top?n.scrollTop-=p.top-d:g>p.bottom&&(n.scrollTop+=g-p.bottom);a<p.left?n.scrollLeft-=p.left-a:f>p.right&&(n.scrollLeft+=f-p.right)}}D.isFocused!==A.isFocused&&
r.markAsFocussed(A.isFocused);l();C=u=v=!1}function p(b){q.parentNode.removeChild(q);a.parentNode.removeChild(a);b()}var q,m,r,c,a,n,k=h.getDocument().getCanvas(),t=new core.DomUtils,s=new gui.GuiStepUtils,y,z,w,v=!1,u=!1,C=!1,A={isFocused:!1,isShown:!0,visibility:"hidden"},D={isFocused:!A.isFocused,isShown:!A.isShown,visibility:"hidden"};this.handleUpdate=function(){C=!0;"hidden"!==A.visibility&&(A.visibility="hidden",m.style.visibility="hidden",h.getNode().removeAttributeNS("urn:webodf:names:cursor",
"caret-sizer-active"));z.trigger()};this.refreshCursorBlinking=function(){v=!0;z.trigger()};this.setFocus=function(){A.isFocused=!0;z.trigger()};this.removeFocus=function(){A.isFocused=!1;z.trigger()};this.show=function(){A.isShown=!0;z.trigger()};this.hide=function(){A.isShown=!1;z.trigger()};this.setAvatarImageUrl=function(a){r.setImageUrl(a)};this.setColor=function(a){m.style.borderColor=a;r.setColor(a)};this.getCursor=function(){return h};this.getFocusElement=function(){return m};this.toggleHandleVisibility=
function(){r.isVisible()?r.hide():r.show()};this.showHandle=function(){r.show()};this.hideHandle=function(){r.hide()};this.setOverlayElement=function(a){c=a;q.appendChild(a);C=!0;z.trigger()};this.ensureVisible=function(){u=!0;z.trigger()};this.destroy=function(a){core.Async.destroyAll([z.destroy,w.destroy,r.destroy,p],a)};(function(){var b=h.getDocument(),c=[b.createRootFilter(h.getMemberId()),b.getPositionFilter()],e=b.getDOMDocument();n=e.createRange();a=e.createElement("span");a.className="webodf-caretSizer";
a.textContent="|";h.getNode().appendChild(a);q=e.createElement("div");q.setAttributeNS("urn:webodf:names:editinfo","editinfo:memberid",h.getMemberId());q.className="webodf-caretOverlay";m=e.createElement("div");m.className="caret";q.appendChild(m);r=new gui.Avatar(q,g);k.getSizer().appendChild(q);y=b.createStepIterator(h.getNode(),0,c,b.getRootNode());z=core.Task.createRedrawTask(f);w=core.Task.createTimeoutTask(d,500);z.triggerImmediate()})()};
// Input 83
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
odf.TextSerializer=function(){function h(d){var e="",l=g.filter?g.filter.acceptNode(d):NodeFilter.FILTER_ACCEPT,f=d.nodeType,p;if((l===NodeFilter.FILTER_ACCEPT||l===NodeFilter.FILTER_SKIP)&&b.isTextContentContainingNode(d))for(p=d.firstChild;p;)e+=h(p),p=p.nextSibling;l===NodeFilter.FILTER_ACCEPT&&(f===Node.ELEMENT_NODE&&b.isParagraph(d)?e+="\n":f===Node.TEXT_NODE&&d.textContent&&(e+=d.textContent));return e}var g=this,b=new odf.OdfUtils;this.filter=null;this.writeToString=function(b){if(!b)return"";
b=h(b);"\n"===b[b.length-1]&&(b=b.substr(0,b.length-1));return b}};
// Input 84
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
gui.MimeDataExporter=function(){var h,g;this.exportRangeToDataTransfer=function(b,d){var e;e=d.startContainer.ownerDocument.createElement("span");e.appendChild(d.cloneContents());e=h.writeToString(e);try{b.setData("text/plain",e)}catch(g){b.setData("Text",e)}};h=new odf.TextSerializer;g=new odf.OdfNodeFilter;h.filter=g};
// Input 85
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
gui.Clipboard=function(h){this.setDataFromRange=function(g,b){var d,e=g.clipboardData;d=runtime.getWindow();!e&&d&&(e=d.clipboardData);e?(d=!0,h.exportRangeToDataTransfer(e,b),g.preventDefault()):d=!1;return d}};
// Input 86
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
gui.StyleSummary=function(h){function g(b,d){var g=b+"|"+d,q;e.hasOwnProperty(g)||(q=[],h.forEach(function(e){e=(e=e[b])&&e[d];-1===q.indexOf(e)&&q.push(e)}),e[g]=q);return e[g]}function b(b,d,e){return function(){var h=g(b,d);return e.length>=h.length&&h.every(function(b){return-1!==e.indexOf(b)})}}function d(b,d){var e=g(b,d);return 1===e.length?e[0]:void 0}var e={};this.getPropertyValues=g;this.getCommonValue=d;this.isBold=b("style:text-properties","fo:font-weight",["bold"]);this.isItalic=b("style:text-properties",
"fo:font-style",["italic"]);this.hasUnderline=b("style:text-properties","style:text-underline-style",["solid"]);this.hasStrikeThrough=b("style:text-properties","style:text-line-through-style",["solid"]);this.fontSize=function(){var b=d("style:text-properties","fo:font-size");return b&&parseFloat(b)};this.fontName=function(){return d("style:text-properties","style:font-name")};this.isAlignedLeft=b("style:paragraph-properties","fo:text-align",["left","start"]);this.isAlignedCenter=b("style:paragraph-properties",
"fo:text-align",["center"]);this.isAlignedRight=b("style:paragraph-properties","fo:text-align",["right","end"]);this.isAlignedJustified=b("style:paragraph-properties","fo:text-align",["justify"]);this.text={isBold:this.isBold,isItalic:this.isItalic,hasUnderline:this.hasUnderline,hasStrikeThrough:this.hasStrikeThrough,fontSize:this.fontSize,fontName:this.fontName};this.paragraph={isAlignedLeft:this.isAlignedLeft,isAlignedCenter:this.isAlignedCenter,isAlignedRight:this.isAlignedRight,isAlignedJustified:this.isAlignedJustified}};
// Input 87
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
gui.DirectFormattingController=function(h,g,b,d,e){function l(a){var b;a.collapsed?(b=a.startContainer,b.hasChildNodes()&&a.startOffset<b.childNodes.length&&(b=b.childNodes.item(a.startOffset)),a=[b]):a=I.getTextNodes(a,!0);return a}function f(a,b){var c={};Object.keys(a).forEach(function(d){var e=a[d](),f=b[d]();e!==f&&(c[d]=f)});return c}function p(){var a,b,c;a=(a=(a=K.getCursor(g))&&a.getSelectedRange())?l(a):[];a=K.getFormatting().getAppliedStyles(a);a[0]&&Y&&(a[0]=W.mergeObjects(a[0],Y));ba=
a;c=new gui.StyleSummary(ba);a=f(V.text,c.text);b=f(V.paragraph,c.paragraph);V=c;0<Object.keys(a).length&&aa.emit(gui.DirectFormattingController.textStylingChanged,a);0<Object.keys(b).length&&aa.emit(gui.DirectFormattingController.paragraphStylingChanged,b)}function q(a){("string"===typeof a?a:a.getMemberId())===g&&p()}function m(){p()}function r(a){var b=K.getCursor(g);a=a.paragraphElement;b&&K.getParagraphElement(b.getNode())===a&&p()}function c(a,b){b(!a());return!0}function a(a){var b=K.getCursorSelection(g),
c={"style:text-properties":a};0!==b.length?(a=new ops.OpApplyDirectStyling,a.init({memberid:g,position:b.position,length:b.length,setProperties:c}),h.enqueue([a])):(Y=W.mergeObjects(Y||{},c),p())}function n(b,c){var d={};d[b]=c;a(d)}function k(a){a=a.spec();Y&&a.memberid===g&&"SplitParagraph"!==a.optype&&(Y=null,p())}function t(a){n("fo:font-weight",a?"bold":"normal")}function s(a){n("fo:font-style",a?"italic":"normal")}function y(a){n("style:text-underline-style",a?"solid":"none")}function z(a){n("style:text-line-through-style",
a?"solid":"none")}function w(a){return a===ops.OdtStepsTranslator.NEXT_STEP}function v(a){var c=K.getCursor(g).getSelectedRange(),c=I.getParagraphElements(c),d=K.getFormatting(),e=[],f={},k;c.forEach(function(c){var h=K.convertDomPointToCursorStep(c,0,w),l=c.getAttributeNS(odf.Namespaces.textns,"style-name"),n;c=l?f.hasOwnProperty(l)?f[l]:void 0:k;c||(c=b.generateStyleName(),l?(f[l]=c,n=d.createDerivedStyleObject(l,"paragraph",{})):(k=c,n={}),n=a(n),l=new ops.OpAddStyle,l.init({memberid:g,styleName:c.toString(),
styleFamily:"paragraph",isAutomaticStyle:!0,setProperties:n}),e.push(l));l=new ops.OpSetParagraphStyle;l.init({memberid:g,styleName:c.toString(),position:h});e.push(l)});h.enqueue(e)}function u(a){v(function(b){return W.mergeObjects(b,a)})}function C(a){u({"style:paragraph-properties":{"fo:text-align":a}})}function A(a,b){var c=K.getFormatting().getDefaultTabStopDistance(),d=b["style:paragraph-properties"],e;d&&(d=d["fo:margin-left"],e=I.parseLength(d));return W.mergeObjects(b,{"style:paragraph-properties":{"fo:margin-left":e&&
e.unit===c.unit?e.value+a*c.value+e.unit:a*c.value+c.unit}})}function D(a,b){var c=l(a),d=K.getFormatting().getAppliedStyles(c)[0],e=K.getFormatting().getAppliedStylesForElement(b);if(!d||"text"!==d["style:family"]||!d["style:text-properties"])return!1;if(!e||!e["style:text-properties"])return!0;d=d["style:text-properties"];e=e["style:text-properties"];return!Object.keys(d).every(function(a){return d[a]===e[a]})}function G(){}function J(){return!1}var O=this,K=h.getOdtDocument(),W=new core.Utils,
I=new odf.OdfUtils,aa=new core.EventNotifier([gui.DirectFormattingController.textStylingChanged,gui.DirectFormattingController.paragraphStylingChanged]),P=odf.Namespaces.textns,M=core.PositionFilter.FilterResult.FILTER_ACCEPT,Y,ba=[],V=new gui.StyleSummary(ba);this.formatTextSelection=a;this.createCursorStyleOp=function(a,b,c){var d=null;(c=c?ba[0]:Y)&&c["style:text-properties"]&&(d=new ops.OpApplyDirectStyling,d.init({memberid:g,position:a,length:b,setProperties:{"style:text-properties":c["style:text-properties"]}}),
Y=null,p());return d};this.setBold=t;this.setItalic=s;this.setHasUnderline=y;this.setHasStrikethrough=z;this.setFontSize=function(a){n("fo:font-size",a+"pt")};this.setFontName=function(a){n("style:font-name",a)};this.getAppliedStyles=function(){return ba};this.toggleBold=c.bind(O,function(){return V.isBold()},t);this.toggleItalic=c.bind(O,function(){return V.isItalic()},s);this.toggleUnderline=c.bind(O,function(){return V.hasUnderline()},y);this.toggleStrikethrough=c.bind(O,function(){return V.hasStrikeThrough()},
z);this.isBold=function(){return V.isBold()};this.isItalic=function(){return V.isItalic()};this.hasUnderline=function(){return V.hasUnderline()};this.hasStrikeThrough=function(){return V.hasStrikeThrough()};this.fontSize=function(){return V.fontSize()};this.fontName=function(){return V.fontName()};this.isAlignedLeft=function(){return V.isAlignedLeft()};this.isAlignedCenter=function(){return V.isAlignedCenter()};this.isAlignedRight=function(){return V.isAlignedRight()};this.isAlignedJustified=function(){return V.isAlignedJustified()};
this.alignParagraphLeft=function(){C("left");return!0};this.alignParagraphCenter=function(){C("center");return!0};this.alignParagraphRight=function(){C("right");return!0};this.alignParagraphJustified=function(){C("justify");return!0};this.indent=function(){v(A.bind(null,1));return!0};this.outdent=function(){v(A.bind(null,-1));return!0};this.createParagraphStyleOps=function(a){var c=K.getCursor(g),d=c.getSelectedRange(),e=[],f,h;c.hasForwardSelection()?(f=c.getAnchorNode(),h=c.getNode()):(f=c.getNode(),
h=c.getAnchorNode());c=K.getParagraphElement(h);runtime.assert(Boolean(c),"DirectFormattingController: Cursor outside paragraph");var k;a:{k=c;var l=gui.SelectionMover.createPositionIterator(k),n=new core.PositionFilterChain;n.addFilter(K.getPositionFilter());n.addFilter(K.createRootFilter(g));for(l.setUnfilteredPosition(d.endContainer,d.endOffset);l.nextPosition();)if(n.acceptPosition(l)===M){k=K.getParagraphElement(l.getCurrentNode())!==k;break a}k=!0}if(!k)return e;h!==f&&(c=K.getParagraphElement(f));
if(!Y&&!D(d,c))return e;d=ba[0];if(!d)return e;if(f=c.getAttributeNS(P,"style-name"))d={"style:text-properties":d["style:text-properties"]},d=K.getFormatting().createDerivedStyleObject(f,"paragraph",d);c=b.generateStyleName();f=new ops.OpAddStyle;f.init({memberid:g,styleName:c,styleFamily:"paragraph",isAutomaticStyle:!0,setProperties:d});e.push(f);f=new ops.OpSetParagraphStyle;f.init({memberid:g,styleName:c,position:a});e.push(f);return e};this.subscribe=function(a,b){aa.subscribe(a,b)};this.unsubscribe=
function(a,b){aa.unsubscribe(a,b)};this.destroy=function(a){K.unsubscribe(ops.Document.signalCursorAdded,q);K.unsubscribe(ops.Document.signalCursorRemoved,q);K.unsubscribe(ops.Document.signalCursorMoved,q);K.unsubscribe(ops.OdtDocument.signalParagraphStyleModified,m);K.unsubscribe(ops.OdtDocument.signalParagraphChanged,r);K.unsubscribe(ops.OdtDocument.signalOperationEnd,k);a()};(function(){K.subscribe(ops.Document.signalCursorAdded,q);K.subscribe(ops.Document.signalCursorRemoved,q);K.subscribe(ops.Document.signalCursorMoved,
q);K.subscribe(ops.OdtDocument.signalParagraphStyleModified,m);K.subscribe(ops.OdtDocument.signalParagraphChanged,r);K.subscribe(ops.OdtDocument.signalOperationEnd,k);p();d||(O.formatTextSelection=G,O.setBold=G,O.setItalic=G,O.setHasUnderline=G,O.setHasStrikethrough=G,O.setFontSize=G,O.setFontName=G,O.toggleBold=J,O.toggleItalic=J,O.toggleUnderline=J,O.toggleStrikethrough=J);e||(O.alignParagraphCenter=G,O.alignParagraphJustified=G,O.alignParagraphLeft=G,O.alignParagraphRight=G,O.createParagraphStyleOps=
function(){return[]},O.indent=G,O.outdent=G)})()};gui.DirectFormattingController.textStylingChanged="textStyling/changed";gui.DirectFormattingController.paragraphStylingChanged="paragraphStyling/changed";
// Input 88
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
gui.KeyboardHandler=function(){function h(b,d){d||(d=g.None);switch(b){case gui.KeyboardHandler.KeyCode.LeftMeta:case gui.KeyboardHandler.KeyCode.RightMeta:case gui.KeyboardHandler.KeyCode.MetaInMozilla:d|=g.Meta;break;case gui.KeyboardHandler.KeyCode.Ctrl:d|=g.Ctrl;break;case gui.KeyboardHandler.KeyCode.Alt:d|=g.Alt;break;case gui.KeyboardHandler.KeyCode.Shift:d|=g.Shift}return b+":"+d}var g=gui.KeyboardHandler.Modifier,b=null,d={};this.setDefault=function(d){b=d};this.bind=function(b,g,f,p){b=h(b,
g);runtime.assert(p||!1===d.hasOwnProperty(b),"tried to overwrite the callback handler of key combo: "+b);d[b]=f};this.unbind=function(b,g){var f=h(b,g);delete d[f]};this.reset=function(){b=null;d={}};this.handleEvent=function(e){var l=e.keyCode,f=g.None;e.metaKey&&(f|=g.Meta);e.ctrlKey&&(f|=g.Ctrl);e.altKey&&(f|=g.Alt);e.shiftKey&&(f|=g.Shift);l=h(l,f);l=d[l];f=!1;l?f=l():null!==b&&(f=b(e));f&&(e.preventDefault?e.preventDefault():e.returnValue=!1)}};
gui.KeyboardHandler.Modifier={None:0,Meta:1,Ctrl:2,Alt:4,CtrlAlt:6,Shift:8,MetaShift:9,CtrlShift:10,AltShift:12};gui.KeyboardHandler.KeyCode={Backspace:8,Tab:9,Clear:12,Enter:13,Shift:16,Ctrl:17,Alt:18,End:35,Home:36,Left:37,Up:38,Right:39,Down:40,Delete:46,A:65,B:66,C:67,D:68,E:69,F:70,G:71,H:72,I:73,J:74,K:75,L:76,M:77,N:78,O:79,P:80,Q:81,R:82,S:83,T:84,U:85,V:86,W:87,X:88,Y:89,Z:90,LeftMeta:91,RightMeta:93,MetaInMozilla:224};
// Input 89
gui.HyperlinkClickHandler=function(h,g,b){function d(){var a=h();runtime.assert(Boolean(a.classList),"Document container has no classList element");a.classList.remove("webodf-inactiveLinks")}function e(){var a=h();runtime.assert(Boolean(a.classList),"Document container has no classList element");a.classList.add("webodf-inactiveLinks")}function l(){c.removeEventListener("focus",e,!1);n.forEach(function(a){g.unbind(a.keyCode,a.modifier);b.unbind(a.keyCode,a.modifier)});n.length=0}function f(a){l();
if(a!==p.None){c.addEventListener("focus",e,!1);switch(a){case p.Ctrl:n.push({keyCode:q.Ctrl,modifier:p.None});break;case p.Meta:n.push({keyCode:q.LeftMeta,modifier:p.None}),n.push({keyCode:q.RightMeta,modifier:p.None}),n.push({keyCode:q.MetaInMozilla,modifier:p.None})}n.forEach(function(a){g.bind(a.keyCode,a.modifier,d);b.bind(a.keyCode,a.modifier,e)})}}var p=gui.KeyboardHandler.Modifier,q=gui.KeyboardHandler.KeyCode,m=xmldom.XPath,r=new odf.OdfUtils,c=runtime.getWindow(),a=p.None,n=[];runtime.assert(null!==
c,"Expected to be run in an environment which has a global window, like a browser.");this.handleClick=function(b){var d=b.target||b.srcElement,e,f;b.ctrlKey?e=p.Ctrl:b.metaKey&&(e=p.Meta);if(a===p.None||a===e){a:{for(;null!==d;){if(r.isHyperlink(d))break a;if(r.isParagraph(d))break;d=d.parentNode}d=null}d&&(d=r.getHyperlinkTarget(d),""!==d&&("#"===d[0]?(d=d.substring(1),e=h(),f=m.getODFElementsWithXPath(e,"//text:bookmark-start[@text:name='"+d+"']",odf.Namespaces.lookupNamespaceURI),0===f.length&&
(f=m.getODFElementsWithXPath(e,"//text:bookmark[@text:name='"+d+"']",odf.Namespaces.lookupNamespaceURI)),0<f.length&&f[0].scrollIntoView(!0)):c.open(d),b.preventDefault?b.preventDefault():b.returnValue=!1))}};this.setModifier=function(b){a!==b&&(runtime.assert(b===p.None||b===p.Ctrl||b===p.Meta,"Unsupported KeyboardHandler.Modifier value: "+b),a=b,a!==p.None?e():d(),f(a))};this.getModifier=function(){return a};this.destroy=function(a){e();l();a()}};
// Input 90
gui.HyperlinkController=function(h,g){var b=new odf.OdfUtils,d=h.getOdtDocument();this.addHyperlink=function(b,l){var f=d.getCursorSelection(g),p=new ops.OpApplyHyperlink,q=[];if(0===f.length||l)l=l||b,p=new ops.OpInsertText,p.init({memberid:g,position:f.position,text:l}),f.length=l.length,q.push(p);p=new ops.OpApplyHyperlink;p.init({memberid:g,position:f.position,length:f.length,hyperlink:b});q.push(p);h.enqueue(q)};this.removeHyperlinks=function(){var e=gui.SelectionMover.createPositionIterator(d.getRootNode()),
l=d.getCursor(g).getSelectedRange(),f=b.getHyperlinkElements(l),p=l.collapsed&&1===f.length,q=d.getDOMDocument().createRange(),m=[],r,c;0!==f.length&&(f.forEach(function(a){q.selectNodeContents(a);r=d.convertDomToCursorRange({anchorNode:q.startContainer,anchorOffset:q.startOffset,focusNode:q.endContainer,focusOffset:q.endOffset});c=new ops.OpRemoveHyperlink;c.init({memberid:g,position:r.position,length:r.length});m.push(c)}),p||(p=f[0],-1===l.comparePoint(p,0)&&(q.setStart(p,0),q.setEnd(l.startContainer,
l.startOffset),r=d.convertDomToCursorRange({anchorNode:q.startContainer,anchorOffset:q.startOffset,focusNode:q.endContainer,focusOffset:q.endOffset}),0<r.length&&(c=new ops.OpApplyHyperlink,c.init({memberid:g,position:r.position,length:r.length,hyperlink:b.getHyperlinkTarget(p)}),m.push(c))),f=f[f.length-1],e.moveToEndOfNode(f),e=e.unfilteredDomOffset(),1===l.comparePoint(f,e)&&(q.setStart(l.endContainer,l.endOffset),q.setEnd(f,e),r=d.convertDomToCursorRange({anchorNode:q.startContainer,anchorOffset:q.startOffset,
focusNode:q.endContainer,focusOffset:q.endOffset}),0<r.length&&(c=new ops.OpApplyHyperlink,c.init({memberid:g,position:r.position,length:r.length,hyperlink:b.getHyperlinkTarget(f)}),m.push(c)))),h.enqueue(m),q.detach())}};
// Input 91
gui.EventManager=function(h){function g(a){function b(a,c,d){var e,f=!1;e="on"+c;a.attachEvent&&(a.attachEvent(e,d),f=!0);!f&&a.addEventListener&&(a.addEventListener(c,d,!1),f=!0);f&&!v[c]||!a.hasOwnProperty(e)||(a[e]=d)}function c(a,b,d){var e="on"+b;a.detachEvent&&a.detachEvent(e,d);a.removeEventListener&&a.removeEventListener(b,d,!1);a[e]===d&&(a[e]=null)}function d(b){-1===f.indexOf(b)&&(f.push(b),e.filters.every(function(a){return a(b)})&&g.emit(a,b),runtime.setTimeout(function(){f.splice(f.indexOf(b),
1)},0))}var e=this,f=[],g=new core.EventNotifier([a]);this.filters=[];this.subscribe=function(b){g.subscribe(a,b)};this.unsubscribe=function(b){g.unsubscribe(a,b)};this.destroy=function(){c(w,a,d);c(D,a,d);c(G,a,d)};u[a]&&b(w,a,d);b(D,a,d);b(G,a,d)}function b(a,b,c){function d(b){c(b,e,function(b){b.type=a;f.emit(a,b)})}var e={},f=new core.EventNotifier([a]);this.subscribe=function(b){f.subscribe(a,b)};this.unsubscribe=function(b){f.unsubscribe(a,b)};this.destroy=function(){b.forEach(function(a){J.unsubscribe(a,
d)})};(function(){b.forEach(function(a){J.subscribe(a,d)})})()}function d(a){runtime.clearTimeout(a);delete O[a]}function e(a,b){var c=runtime.setTimeout(function(){a();d(c)},b);O[c]=!0;return c}function l(a,b,c){var f=a.touches.length,g=a.touches[0],h=b.timer;"touchmove"===a.type||"touchend"===a.type?h&&d(h):"touchstart"===a.type&&(1!==f?runtime.clearTimeout(h):h=e(function(){c({clientX:g.clientX,clientY:g.clientY,pageX:g.pageX,pageY:g.pageY,target:a.target||a.srcElement||null,detail:1})},400));
b.timer=h}function f(a,b,c){var d=a.touches[0],e=a.target||a.srcElement||null,f=b.target;1!==a.touches.length||"touchend"===a.type?f=null:"touchstart"===a.type&&"webodf-draggable"===e.getAttribute("class")?f=e:"touchmove"===a.type&&f&&(a.preventDefault(),a.stopPropagation(),c({clientX:d.clientX,clientY:d.clientY,pageX:d.pageX,pageY:d.pageY,target:f,detail:1}));b.target=f}function p(a,b,c){var d=a.target||a.srcElement||null,e=b.dragging;"drag"===a.type?e=!0:"touchend"===a.type&&e&&(e=!1,a=a.changedTouches[0],
c({clientX:a.clientX,clientY:a.clientY,pageX:a.pageX,pageY:a.pageY,target:d,detail:1}));b.dragging=e}function q(){G.classList.add("webodf-touchEnabled");J.unsubscribe("touchstart",q)}function m(a){var b=a.scrollX,c=a.scrollY;this.restore=function(){a.scrollX===b&&a.scrollY===c||a.scrollTo(b,c)}}function r(a){var b=a.scrollTop,c=a.scrollLeft;this.restore=function(){if(a.scrollTop!==b||a.scrollLeft!==c)a.scrollTop=b,a.scrollLeft=c}}function c(a,b){var c=A[a]||C[a]||null;!c&&b&&(c=A[a]=new g(a));return c}
function a(a,b){c(a,!0).subscribe(b)}function n(a,b){var d=c(a,!1);d&&d.unsubscribe(b)}function k(){return h.getDOMDocument().activeElement===D}function t(){k()&&D.blur();D.setAttribute("disabled","true")}function s(){D.removeAttribute("disabled")}function y(a){for(var b=[];a;)(a.scrollWidth>a.clientWidth||a.scrollHeight>a.clientHeight)&&b.push(new r(a)),a=a.parentNode;b.push(new m(w));return b}function z(){var a;k()||(a=y(D),s(),D.focus(),a.forEach(function(a){a.restore()}))}var w=runtime.getWindow(),
v={beforecut:!0,beforepaste:!0,longpress:!0,drag:!0,dragstop:!0},u={mousedown:!0,mouseup:!0,focus:!0},C={},A={},D,G=h.getCanvas().getElement(),J=this,O={};this.addFilter=function(a,b){c(a,!0).filters.push(b)};this.removeFilter=function(a,b){var d=c(a,!0),e=d.filters.indexOf(b);-1!==e&&d.filters.splice(e,1)};this.subscribe=a;this.unsubscribe=n;this.hasFocus=k;this.focus=z;this.getEventTrap=function(){return D};this.setEditing=function(a){var b=k();b&&D.blur();a?D.removeAttribute("readOnly"):D.setAttribute("readOnly",
"true");b&&z()};this.destroy=function(a){n("touchstart",q);Object.keys(O).forEach(function(a){d(parseInt(a,10))});O.length=0;Object.keys(C).forEach(function(a){C[a].destroy()});C={};n("mousedown",t);n("mouseup",s);n("contextmenu",s);Object.keys(A).forEach(function(a){A[a].destroy()});A={};D.parentNode.removeChild(D);a()};(function(){var c=h.getOdfCanvas().getSizer(),d=c.ownerDocument;runtime.assert(Boolean(w),"EventManager requires a window object to operate correctly");D=d.createElement("input");
D.id="eventTrap";D.setAttribute("tabindex","-1");D.setAttribute("readOnly","true");c.appendChild(D);a("mousedown",t);a("mouseup",s);a("contextmenu",s);C.longpress=new b("longpress",["touchstart","touchmove","touchend"],l);C.drag=new b("drag",["touchstart","touchmove","touchend"],f);C.dragstop=new b("dragstop",["drag","touchend"],p);a("touchstart",q)})()};
// Input 92
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
gui.IOSSafariSupport=function(h){function g(){b.innerHeight!==b.outerHeight&&(d.style.display="none",runtime.requestAnimationFrame(function(){d.style.display="block"}))}var b=runtime.getWindow(),d=h.getEventTrap();this.destroy=function(b){h.unsubscribe("focus",g);d.removeAttribute("autocapitalize");d.style.WebkitTransform="";b()};h.subscribe("focus",g);d.setAttribute("autocapitalize","off");d.style.WebkitTransform="translateX(-10000px)"};
// Input 93
gui.ImageController=function(h,g,b){var d={"image/gif":".gif","image/jpeg":".jpg","image/png":".png"},e=odf.Namespaces.textns,l=h.getOdtDocument(),f=l.getFormatting();this.insertImage=function(p,q,m,r){runtime.assert(0<m&&0<r,"Both width and height of the image should be greater than 0px.");r={width:m,height:r};if(m=l.getParagraphElement(l.getCursor(g).getNode()).getAttributeNS(e,"style-name")){m=f.getContentSize(m,"paragraph");var c=1,a=1;r.width>m.width&&(c=m.width/r.width);r.height>m.height&&(a=
m.height/r.height);m=Math.min(c,a);r={width:r.width*m,height:r.height*m}}m=r.width+"px";r=r.height+"px";var n=l.getOdfCanvas().odfContainer().rootElement.styles,c=p.toLowerCase(),a=d.hasOwnProperty(c)?d[c]:null,k,c=[];runtime.assert(null!==a,"Image type is not supported: "+p);a="Pictures/"+b.generateImageName()+a;k=new ops.OpSetBlob;k.init({memberid:g,filename:a,mimetype:p,content:q});c.push(k);f.getStyleElement("Graphics","graphic",[n])||(p=new ops.OpAddStyle,p.init({memberid:g,styleName:"Graphics",
styleFamily:"graphic",isAutomaticStyle:!1,setProperties:{"style:graphic-properties":{"text:anchor-type":"paragraph","svg:x":"0cm","svg:y":"0cm","style:wrap":"dynamic","style:number-wrapped-paragraphs":"no-limit","style:wrap-contour":"false","style:vertical-pos":"top","style:vertical-rel":"paragraph","style:horizontal-pos":"center","style:horizontal-rel":"paragraph"}}}),c.push(p));p=b.generateStyleName();q=new ops.OpAddStyle;q.init({memberid:g,styleName:p,styleFamily:"graphic",isAutomaticStyle:!0,
setProperties:{"style:parent-style-name":"Graphics","style:graphic-properties":{"style:vertical-pos":"top","style:vertical-rel":"baseline","style:horizontal-pos":"center","style:horizontal-rel":"paragraph","fo:background-color":"transparent","style:background-transparency":"100%","style:shadow":"none","style:mirror":"none","fo:clip":"rect(0cm, 0cm, 0cm, 0cm)","draw:luminance":"0%","draw:contrast":"0%","draw:red":"0%","draw:green":"0%","draw:blue":"0%","draw:gamma":"100%","draw:color-inversion":"false",
"draw:image-opacity":"100%","draw:color-mode":"standard"}}});c.push(q);k=new ops.OpInsertImage;k.init({memberid:g,position:l.getCursorPosition(g),filename:a,frameWidth:m,frameHeight:r,frameStyleName:p,frameName:b.generateFrameName()});c.push(k);h.enqueue(c)}};
// Input 94
gui.ImageSelector=function(h){function g(){var b=h.getSizer(),g=e.createElement("div");g.id="imageSelector";g.style.borderWidth="1px";b.appendChild(g);d.forEach(function(b){var d=e.createElement("div");d.className=b;g.appendChild(d)});return g}var b=odf.Namespaces.svgns,d="topLeft topRight bottomRight bottomLeft topMiddle rightMiddle bottomMiddle leftMiddle".split(" "),e=h.getElement().ownerDocument,l=!1;this.select=function(d){var p,q,m=e.getElementById("imageSelector");m||(m=g());l=!0;p=m.parentNode;
q=d.getBoundingClientRect();var r=p.getBoundingClientRect(),c=h.getZoomLevel();p=(q.left-r.left)/c-1;q=(q.top-r.top)/c-1;m.style.display="block";m.style.left=p+"px";m.style.top=q+"px";m.style.width=d.getAttributeNS(b,"width");m.style.height=d.getAttributeNS(b,"height")};this.clearSelection=function(){var b;l&&(b=e.getElementById("imageSelector"))&&(b.style.display="none");l=!1};this.isSelectorElement=function(b){var d=e.getElementById("imageSelector");return d?b===d||b.parentNode===d:!1}};
// Input 95
(function(){function h(g){function b(b){f=b.which&&String.fromCharCode(b.which)===h;h=void 0;return!1===f}function d(){f=!1}function e(b){h=b.data;f=!1}var h,f=!1;this.destroy=function(f){g.unsubscribe("textInput",d);g.unsubscribe("compositionend",e);g.removeFilter("keypress",b);f()};g.subscribe("textInput",d);g.subscribe("compositionend",e);g.addFilter("keypress",b)}gui.InputMethodEditor=function(g,b){function d(b){a&&(b?a.getNode().setAttributeNS(c,"composing","true"):(a.getNode().removeAttributeNS(c,
"composing"),t.textContent=""))}function e(){z&&(z=!1,d(!1),v.emit(gui.InputMethodEditor.signalCompositionEnd,{data:w}),w="")}function l(){e();a&&a.getSelectedRange().collapsed?n.value="":n.value=s;n.setSelectionRange(0,n.value.length)}function f(){b.hasFocus()&&y.trigger()}function p(){u=void 0;y.cancel();d(!0);z||v.emit(gui.InputMethodEditor.signalCompositionStart,{data:""})}function q(a){a=u=a.data;z=!0;w+=a;y.trigger()}function m(a){a.data!==u&&(a=a.data,z=!0,w+=a,y.trigger());u=void 0}function r(){t.textContent=
n.value}var c="urn:webodf:names:cursor",a=null,n=b.getEventTrap(),k=n.ownerDocument,t,s="b",y,z=!1,w="",v=new core.EventNotifier([gui.InputMethodEditor.signalCompositionStart,gui.InputMethodEditor.signalCompositionEnd]),u,C=[],A;this.subscribe=v.subscribe;this.unsubscribe=v.unsubscribe;this.registerCursor=function(c){c.getMemberId()===g&&(a=c,a.getNode().appendChild(t),c.subscribe(ops.OdtCursor.signalCursorUpdated,f),b.subscribe("input",r),b.subscribe("compositionupdate",r))};this.removeCursor=function(c){a&&
c===g&&(a.getNode().removeChild(t),a.unsubscribe(ops.OdtCursor.signalCursorUpdated,f),b.unsubscribe("input",r),b.unsubscribe("compositionupdate",r),a=null)};this.destroy=function(a){b.unsubscribe("compositionstart",p);b.unsubscribe("compositionend",q);b.unsubscribe("textInput",m);b.unsubscribe("keypress",e);b.unsubscribe("focus",l);core.Async.destroyAll(A,a)};(function(){b.subscribe("compositionstart",p);b.subscribe("compositionend",q);b.subscribe("textInput",m);b.subscribe("keypress",e);b.subscribe("focus",
l);C.push(new h(b));A=C.map(function(a){return a.destroy});t=k.createElement("span");t.setAttribute("id","composer");y=core.Task.createTimeoutTask(l,1);A.push(y.destroy)})()};gui.InputMethodEditor.signalCompositionStart="input/compositionstart";gui.InputMethodEditor.signalCompositionEnd="input/compositionend"})();
// Input 96
gui.MetadataController=function(h,g){function b(b){l.emit(gui.MetadataController.signalMetadataChanged,b)}function d(b){var d=-1===f.indexOf(b);d||runtime.log("Setting "+b+" is restricted.");return d}var e=h.getOdtDocument(),l=new core.EventNotifier([gui.MetadataController.signalMetadataChanged]),f=["dc:creator","dc:date","meta:editing-cycles","meta:editing-duration","meta:document-statistic"];this.setMetadata=function(b,e){var f={},l="",c;b&&Object.keys(b).filter(d).forEach(function(a){f[a]=b[a]});
e&&(l=e.filter(d).join(","));if(0<l.length||0<Object.keys(f).length)c=new ops.OpUpdateMetadata,c.init({memberid:g,setProperties:f,removedProperties:0<l.length?{attributes:l}:null}),h.enqueue([c])};this.getMetadata=function(b){var d;runtime.assert("string"===typeof b,"Property must be a string");d=b.split(":");runtime.assert(2===d.length,"Property must be a namespace-prefixed string");b=odf.Namespaces.lookupNamespaceURI(d[0]);runtime.assert(Boolean(b),"Prefix must be for an ODF namespace.");return e.getOdfCanvas().odfContainer().getMetadata(b,
d[1])};this.subscribe=function(b,d){l.subscribe(b,d)};this.unsubscribe=function(b,d){l.unsubscribe(b,d)};this.destroy=function(d){e.unsubscribe(ops.OdtDocument.signalMetadataUpdated,b);d()};e.subscribe(ops.OdtDocument.signalMetadataUpdated,b)};gui.MetadataController.signalMetadataChanged="metadata/changed";
// Input 97
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
gui.PlainTextPasteboard=function(h,g){function b(b,e){b.init(e);return b}this.createPasteOps=function(d){var e=h.getCursorPosition(g),l=[];d.replace(/\r/g,"").split("\n").forEach(function(d){l.push(b(new ops.OpInsertText,{memberid:g,position:e,text:d,moveCursor:!0}));e+=d.length;l.push(b(new ops.OpSplitParagraph,{memberid:g,position:e,moveCursor:!0}));e+=1});l.pop();return l}};
// Input 98
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
odf.WordBoundaryFilter=function(h,g){function b(a,b,c){for(var d=null,e=h.getRootNode(),f;a!==e&&null!==a&&null===d;)f=0>b?a.previousSibling:a.nextSibling,c(f)===NodeFilter.FILTER_ACCEPT&&(d=f),a=a.parentNode;return d}function d(a,b){var c;return null===a?n.NO_NEIGHBOUR:f.isCharacterElement(a)?n.SPACE_CHAR:a.nodeType===e||f.isTextSpan(a)||f.isHyperlink(a)?(c=a.textContent.charAt(b()),q.test(c)?n.SPACE_CHAR:p.test(c)?n.PUNCTUATION_CHAR:n.WORD_CHAR):n.OTHER}var e=Node.TEXT_NODE,l=Node.ELEMENT_NODE,
f=new odf.OdfUtils,p=/[!-#%-*,-\/:-;?-@\[-\]_{}\u00a1\u00ab\u00b7\u00bb\u00bf;\u00b7\u055a-\u055f\u0589-\u058a\u05be\u05c0\u05c3\u05c6\u05f3-\u05f4\u0609-\u060a\u060c-\u060d\u061b\u061e-\u061f\u066a-\u066d\u06d4\u0700-\u070d\u07f7-\u07f9\u0964-\u0965\u0970\u0df4\u0e4f\u0e5a-\u0e5b\u0f04-\u0f12\u0f3a-\u0f3d\u0f85\u0fd0-\u0fd4\u104a-\u104f\u10fb\u1361-\u1368\u166d-\u166e\u169b-\u169c\u16eb-\u16ed\u1735-\u1736\u17d4-\u17d6\u17d8-\u17da\u1800-\u180a\u1944-\u1945\u19de-\u19df\u1a1e-\u1a1f\u1b5a-\u1b60\u1c3b-\u1c3f\u1c7e-\u1c7f\u2000-\u206e\u207d-\u207e\u208d-\u208e\u3008-\u3009\u2768-\u2775\u27c5-\u27c6\u27e6-\u27ef\u2983-\u2998\u29d8-\u29db\u29fc-\u29fd\u2cf9-\u2cfc\u2cfe-\u2cff\u2e00-\u2e7e\u3000-\u303f\u30a0\u30fb\ua60d-\ua60f\ua673\ua67e\ua874-\ua877\ua8ce-\ua8cf\ua92e-\ua92f\ua95f\uaa5c-\uaa5f\ufd3e-\ufd3f\ufe10-\ufe19\ufe30-\ufe52\ufe54-\ufe61\ufe63\ufe68\ufe6a-\ufe6b\uff01-\uff03\uff05-\uff0a\uff0c-\uff0f\uff1a-\uff1b\uff1f-\uff20\uff3b-\uff3d\uff3f\uff5b\uff5d\uff5f-\uff65]|\ud800[\udd00-\udd01\udf9f\udfd0]|\ud802[\udd1f\udd3f\ude50-\ude58]|\ud809[\udc00-\udc7e]/,
q=/\s/,m=core.PositionFilter.FilterResult.FILTER_ACCEPT,r=core.PositionFilter.FilterResult.FILTER_REJECT,c=odf.WordBoundaryFilter.IncludeWhitespace.TRAILING,a=odf.WordBoundaryFilter.IncludeWhitespace.LEADING,n={NO_NEIGHBOUR:0,SPACE_CHAR:1,PUNCTUATION_CHAR:2,WORD_CHAR:3,OTHER:4};this.acceptPosition=function(e){var f=e.container(),h=e.leftNode(),p=e.rightNode(),q=e.unfilteredDomOffset,w=function(){return e.unfilteredDomOffset()-1};f.nodeType===l&&(null===p&&(p=b(f,1,e.getNodeFilter())),null===h&&(h=
b(f,-1,e.getNodeFilter())));f!==p&&(q=function(){return 0});f!==h&&null!==h&&(w=function(){return h.textContent.length-1});f=d(h,w);p=d(p,q);return f===n.WORD_CHAR&&p===n.WORD_CHAR||f===n.PUNCTUATION_CHAR&&p===n.PUNCTUATION_CHAR||g===c&&f!==n.NO_NEIGHBOUR&&p===n.SPACE_CHAR||g===a&&f===n.SPACE_CHAR&&p!==n.NO_NEIGHBOUR?r:m}};odf.WordBoundaryFilter.IncludeWhitespace={None:0,TRAILING:1,LEADING:2};
// Input 99
gui.SelectionController=function(h,g){function b(a,b,c){c=new odf.WordBoundaryFilter(s,c);var d=s.getRootElement(a),e=s.createRootFilter(d);return s.createStepIterator(a,b,[w,e,c],d)}function d(a,b){return b?{anchorNode:a.startContainer,anchorOffset:a.startOffset,focusNode:a.endContainer,focusOffset:a.endOffset}:{anchorNode:a.endContainer,anchorOffset:a.endOffset,focusNode:a.startContainer,focusOffset:a.startOffset}}function e(a,b,c){var d=new ops.OpMoveCursor;d.init({memberid:g,position:a,length:b||
0,selectionType:c});return d}function l(a,b,c){var f;f=s.getCursor(g);f=d(f.getSelectedRange(),f.hasForwardSelection());f.focusNode=a;f.focusOffset=b;c||(f.anchorNode=f.focusNode,f.anchorOffset=f.focusOffset);a=s.convertDomToCursorRange(f);h.enqueue([e(a.position,a.length)])}function f(a){var c;c=b(a.startContainer,a.startOffset,C);c.roundToPreviousStep()&&a.setStart(c.container(),c.offset());c=b(a.endContainer,a.endOffset,A);c.roundToNextStep()&&a.setEnd(c.container(),c.offset())}function p(a){var b=
z.getParagraphElements(a),c=b[0],b=b[b.length-1];c&&a.setStart(c,0);b&&(z.isParagraph(a.endContainer)&&0===a.endOffset?a.setEndBefore(b):a.setEnd(b,b.childNodes.length))}function q(a,b,c,d){var e,f;d?(e=c.startContainer,f=c.startOffset):(e=c.endContainer,f=c.endOffset);y.containsNode(a,e)||(f=0>y.comparePoints(a,0,e,f)?0:a.childNodes.length,e=a);a=s.createStepIterator(e,f,b,z.getParagraphElement(e)||a);a.roundToClosestStep()||runtime.assert(!1,"No step found in requested range");d?c.setStart(a.container(),
a.offset()):c.setEnd(a.container(),a.offset())}function m(a){var b=s.getCursorSelection(g),c=s.getCursor(g).getStepCounter();0!==a&&(a=0<a?c.convertForwardStepsBetweenFilters(a,v,w):-c.convertBackwardStepsBetweenFilters(-a,v,w),a=b.length+a,h.enqueue([e(b.position,a)]))}function r(a){var b=s.getCursorPosition(g),c=s.getCursor(g).getStepCounter();0!==a&&(a=0<a?c.convertForwardStepsBetweenFilters(a,v,w):-c.convertBackwardStepsBetweenFilters(-a,v,w),h.enqueue([e(b+a,0)]))}function c(a,b){var c;c=s.getCursor(g).getNode();
c=s.createStepIterator(c,0,[w,u],s.getRootElement(c));c.advanceStep(a)&&l(c.container(),c.offset(),b)}function a(a,b){var c=s.getParagraphElement(s.getCursor(g).getNode()),d=a===G?1:-1;runtime.assert(Boolean(c),"SelectionController: Cursor outside paragraph");c=s.getCursor(g).getStepCounter().countLinesSteps(d,v);b?m(c):r(c)}function n(a,b){var c=a===core.StepDirection.NEXT?1:-1,c=s.getCursor(g).getStepCounter().countStepsToLineBoundary(c,v);b?m(c):r(c)}function k(a,c){var e=s.getCursor(g),e=d(e.getSelectedRange(),
e.hasForwardSelection()),e=b(e.focusNode,e.focusOffset,C);e.advanceStep(a)&&l(e.container(),e.offset(),c)}function t(a,b,c){var e=!1,f=s.getCursor(g),f=d(f.getSelectedRange(),f.hasForwardSelection()),e=s.getRootElement(f.focusNode);runtime.assert(Boolean(e),"SelectionController: Cursor outside root");f=s.createStepIterator(f.focusNode,f.focusOffset,[w,u],e);f.roundToClosestStep();f.advanceStep(a)&&(c=c(f.container()))&&(a===D?(f.setPosition(c,0),e=f.roundToNextStep()):(f.setPosition(c,c.childNodes.length),
e=f.roundToPreviousStep()),e&&l(f.container(),f.offset(),b))}var s=h.getOdtDocument(),y=new core.DomUtils,z=new odf.OdfUtils,w=s.getPositionFilter(),v=new core.PositionFilterChain,u=s.createRootFilter(g),C=odf.WordBoundaryFilter.IncludeWhitespace.TRAILING,A=odf.WordBoundaryFilter.IncludeWhitespace.LEADING,D=core.StepDirection.PREVIOUS,G=core.StepDirection.NEXT;this.selectionToRange=function(a){var b=0<=y.comparePoints(a.anchorNode,a.anchorOffset,a.focusNode,a.focusOffset),c=a.focusNode.ownerDocument.createRange();
b?(c.setStart(a.anchorNode,a.anchorOffset),c.setEnd(a.focusNode,a.focusOffset)):(c.setStart(a.focusNode,a.focusOffset),c.setEnd(a.anchorNode,a.anchorOffset));return{range:c,hasForwardSelection:b}};this.rangeToSelection=d;this.selectImage=function(a){var b=s.getRootElement(a),c=s.createRootFilter(b),b=s.createStepIterator(a,0,[c,s.getPositionFilter()],b),d;b.roundToPreviousStep()||runtime.assert(!1,"No walkable position before frame");c=b.container();d=b.offset();b.setPosition(a,a.childNodes.length);
b.roundToNextStep()||runtime.assert(!1,"No walkable position after frame");a=s.convertDomToCursorRange({anchorNode:c,anchorOffset:d,focusNode:b.container(),focusOffset:b.offset()});a=e(a.position,a.length,ops.OdtCursor.RegionSelection);h.enqueue([a])};this.expandToWordBoundaries=f;this.expandToParagraphBoundaries=p;this.selectRange=function(a,b,c){var k=s.getOdfCanvas().getElement(),l,n=[w];l=y.containsNode(k,a.startContainer);k=y.containsNode(k,a.endContainer);if(l||k)if(l&&k&&(2===c?f(a):3<=c&&
p(a)),(c=b?s.getRootElement(a.startContainer):s.getRootElement(a.endContainer))||(c=s.getRootNode()),n.push(s.createRootFilter(c)),q(c,n,a,!0),q(c,n,a,!1),a=d(a,b),b=s.convertDomToCursorRange(a),a=s.getCursorSelection(g),b.position!==a.position||b.length!==a.length)a=e(b.position,b.length,ops.OdtCursor.RangeSelection),h.enqueue([a])};this.moveCursorToLeft=function(){c(D,!1);return!0};this.moveCursorToRight=function(){c(G,!1);return!0};this.extendSelectionToLeft=function(){c(D,!0);return!0};this.extendSelectionToRight=
function(){c(G,!0);return!0};this.moveCursorUp=function(){a(D,!1);return!0};this.moveCursorDown=function(){a(G,!1);return!0};this.extendSelectionUp=function(){a(D,!0);return!0};this.extendSelectionDown=function(){a(G,!0);return!0};this.moveCursorBeforeWord=function(){k(D,!1);return!0};this.moveCursorPastWord=function(){k(G,!1);return!0};this.extendSelectionBeforeWord=function(){k(D,!0);return!0};this.extendSelectionPastWord=function(){k(G,!0);return!0};this.moveCursorToLineStart=function(){n(D,!1);
return!0};this.moveCursorToLineEnd=function(){n(G,!1);return!0};this.extendSelectionToLineStart=function(){n(D,!0);return!0};this.extendSelectionToLineEnd=function(){n(G,!0);return!0};this.extendSelectionToParagraphStart=function(){t(D,!0,s.getParagraphElement);return!0};this.extendSelectionToParagraphEnd=function(){t(G,!0,s.getParagraphElement);return!0};this.moveCursorToParagraphStart=function(){t(D,!1,s.getParagraphElement);return!0};this.moveCursorToParagraphEnd=function(){t(G,!1,s.getParagraphElement);
return!0};this.moveCursorToDocumentStart=function(){t(D,!1,s.getRootElement);return!0};this.moveCursorToDocumentEnd=function(){t(G,!1,s.getRootElement);return!0};this.extendSelectionToDocumentStart=function(){t(D,!0,s.getRootElement);return!0};this.extendSelectionToDocumentEnd=function(){t(G,!0,s.getRootElement);return!0};this.extendSelectionToEntireDocument=function(){var a=s.getCursor(g),a=s.getRootElement(a.getNode()),b,c,d;runtime.assert(Boolean(a),"SelectionController: Cursor outside root");
d=s.createStepIterator(a,0,[w,u],a);d.roundToClosestStep();b=d.container();c=d.offset();d.setPosition(a,a.childNodes.length);d.roundToClosestStep();a=s.convertDomToCursorRange({anchorNode:b,anchorOffset:c,focusNode:d.container(),focusOffset:d.offset()});h.enqueue([e(a.position,a.length)]);return!0};v.addFilter(w);v.addFilter(s.createRootFilter(g))};
// Input 100
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
gui.TextController=function(h,g,b,d){function e(b,d){var c,a;c=new ops.OpRemoveText;var e=[c];c.init({memberid:g,position:d.position,length:d.length});c=p.getParagraphElement(b.startContainer);a=p.getParagraphElement(b.endContainer);c!==a&&(c=q.hasNoODFContent(c)?a.getAttributeNS(odf.Namespaces.textns,"style-name")||"":c.getAttributeNS(odf.Namespaces.textns,"style-name")||"",a=new ops.OpSetParagraphStyle,a.init({memberid:g,position:d.position,styleName:c}),e.push(a));return e}function l(b){0>b.length&&
(b.position+=b.length,b.length=-b.length);return b}function f(b){var d,c=p.getCursor(g).getSelectedRange().cloneRange(),a=l(p.getCursorSelection(g)),f;if(0===a.length){a=void 0;d=p.getCursor(g).getNode();f=p.getRootElement(d);var k=[p.getPositionFilter(),p.createRootFilter(f)];f=p.createStepIterator(d,0,k,f);f.roundToClosestStep()&&(b?f.nextStep():f.previousStep())&&(a=l(p.convertDomToCursorRange({anchorNode:d,anchorOffset:0,focusNode:f.container(),focusOffset:f.offset()})),b?(c.setStart(d,0),c.setEnd(f.container(),
f.offset())):(c.setStart(f.container(),f.offset()),c.setEnd(d,0)))}a&&h.enqueue(e(c,a));return void 0!==a}var p=h.getOdtDocument(),q=new odf.OdfUtils;this.enqueueParagraphSplittingOps=function(){var b=p.getCursor(g).getSelectedRange(),f=l(p.getCursorSelection(g)),c=[];0<f.length&&(c=c.concat(e(b,f)));b=new ops.OpSplitParagraph;b.init({memberid:g,position:f.position,moveCursor:!0});c.push(b);d&&(f=d(f.position+1),c=c.concat(f));h.enqueue(c);return!0};this.removeTextByBackspaceKey=function(){return f(!1)};
this.removeTextByDeleteKey=function(){return f(!0)};this.removeCurrentSelection=function(){var b=p.getCursor(g).getSelectedRange(),d=l(p.getCursorSelection(g));0!==d.length&&h.enqueue(e(b,d));return!0};this.insertText=function(d){var f=p.getCursor(g).getSelectedRange(),c=l(p.getCursorSelection(g)),a=[],n=!1;0<c.length&&(a=a.concat(e(f,c)),n=!0);f=new ops.OpInsertText;f.init({memberid:g,position:c.position,text:d,moveCursor:!0});a.push(f);b&&(d=b(c.position,d.length,n))&&a.push(d);h.enqueue(a)}};
// Input 101
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
gui.UndoManager=function(){};gui.UndoManager.prototype.subscribe=function(h,g){};gui.UndoManager.prototype.unsubscribe=function(h,g){};gui.UndoManager.prototype.setDocument=function(h){};gui.UndoManager.prototype.setInitialState=function(){};gui.UndoManager.prototype.initialize=function(){};gui.UndoManager.prototype.purgeInitialState=function(){};gui.UndoManager.prototype.setPlaybackFunction=function(h){};gui.UndoManager.prototype.hasUndoStates=function(){};
gui.UndoManager.prototype.hasRedoStates=function(){};gui.UndoManager.prototype.moveForward=function(h){};gui.UndoManager.prototype.moveBackward=function(h){};gui.UndoManager.prototype.onOperationExecuted=function(h){};gui.UndoManager.signalUndoStackChanged="undoStackChanged";gui.UndoManager.signalUndoStateCreated="undoStateCreated";gui.UndoManager.signalUndoStateModified="undoStateModified";
// Input 102
gui.SessionControllerOptions=function(){this.annotationsEnabled=this.directParagraphStylingEnabled=this.directTextStylingEnabled=!1};
(function(){var h=core.PositionFilter.FilterResult.FILTER_ACCEPT;gui.SessionController=function(g,b,d,e){function l(a){return a.target||a.srcElement||null}function f(a,b){var c=M.getDOMDocument(),d=null;c.caretRangeFromPoint?(c=c.caretRangeFromPoint(a,b),d={container:c.startContainer,offset:c.startOffset}):c.caretPositionFromPoint&&(c=c.caretPositionFromPoint(a,b))&&c.offsetNode&&(d={container:c.offsetNode,offset:c.offset});return d}function p(a){var c=M.getCursor(b).getSelectedRange();c.collapsed?
a.preventDefault():$.setDataFromRange(a,c)?ea.removeCurrentSelection():runtime.log("Cut operation failed")}function q(){return!1!==M.getCursor(b).getSelectedRange().collapsed}function m(a){var c=M.getCursor(b).getSelectedRange();c.collapsed?a.preventDefault():$.setDataFromRange(a,c)||runtime.log("Copy operation failed")}function r(a){var b;P.clipboardData&&P.clipboardData.getData?b=P.clipboardData.getData("Text"):a.clipboardData&&a.clipboardData.getData&&(b=a.clipboardData.getData("text/plain"));
b&&(ea.removeCurrentSelection(),g.enqueue(pa.createPasteOps(b)));a.preventDefault?a.preventDefault():a.returnValue=!1}function c(){return!1}function a(a){if(X)X.onOperationExecuted(a)}function n(a){M.emit(ops.OdtDocument.signalUndoStackChanged,a)}function k(){var a;return X?(a=B.hasFocus(),X.moveBackward(1),a&&B.focus(),!0):!1}function t(){var a;return X?(a=B.hasFocus(),X.moveForward(1),a&&B.focus(),!0):!1}function s(a){var c=M.getCursor(b).getSelectedRange(),e=l(a).getAttribute("end");c&&e&&(a=f(a.clientX,
a.clientY))&&(fa.setUnfilteredPosition(a.container,a.offset),L.acceptPosition(fa)===h&&(c=c.cloneRange(),"left"===e?c.setStart(fa.container(),fa.unfilteredDomOffset()):c.setEnd(fa.container(),fa.unfilteredDomOffset()),d.setSelectedRange(c,"right"===e),M.emit(ops.Document.signalCursorMoved,d)))}function y(){S.selectRange(d.getSelectedRange(),d.hasForwardSelection(),1)}function z(){var a=P.getSelection(),b=0<a.rangeCount&&S.selectionToRange(a);U&&b&&(Q=!0,ka.clearSelection(),fa.setUnfilteredPosition(a.focusNode,
a.focusOffset),L.acceptPosition(fa)===h&&(2===ma?S.expandToWordBoundaries(b.range):3<=ma&&S.expandToParagraphBoundaries(b.range),d.setSelectedRange(b.range,b.hasForwardSelection),M.emit(ops.Document.signalCursorMoved,d)))}function w(a){var c=l(a),d=M.getCursor(b);if(U=null!==c&&Y.containsNode(M.getOdfCanvas().getElement(),c))Q=!1,L=M.createRootFilter(c),ma=0===a.button?a.detail:0,d&&a.shiftKey?P.getSelection().collapse(d.getAnchorNode(),0):(a=P.getSelection(),c=d.getSelectedRange(),a.extend?d.hasForwardSelection()?
(a.collapse(c.startContainer,c.startOffset),a.extend(c.endContainer,c.endOffset)):(a.collapse(c.endContainer,c.endOffset),a.extend(c.startContainer,c.startOffset)):(a.removeAllRanges(),a.addRange(c.cloneRange()))),1<ma&&z()}function v(a){var b=M.getRootElement(a),c=M.createRootFilter(b),b=M.createStepIterator(a,0,[c,M.getPositionFilter()],b);b.setPosition(a,a.childNodes.length);return b.roundToNextStep()?{container:b.container(),offset:b.offset()}:null}function u(a){var b;b=(b=P.getSelection())?{anchorNode:b.anchorNode,
anchorOffset:b.anchorOffset,focusNode:b.focusNode,focusOffset:b.focusOffset}:null;var c=P.getSelection().isCollapsed,d,e;b.anchorNode||b.focusNode||!(d=f(a.clientX,a.clientY))||(b.anchorNode=d.container,b.anchorOffset=d.offset,b.focusNode=b.anchorNode,b.focusOffset=b.anchorOffset);if(ba.isImage(b.focusNode)&&0===b.focusOffset&&ba.isCharacterFrame(b.focusNode.parentNode)){if(e=b.focusNode.parentNode,d=e.getBoundingClientRect(),a.clientX>d.left&&(d=v(e)))b.focusNode=d.container,b.focusOffset=d.offset,
c&&(b.anchorNode=b.focusNode,b.anchorOffset=b.focusOffset)}else ba.isImage(b.focusNode.firstChild)&&1===b.focusOffset&&ba.isCharacterFrame(b.focusNode)&&(d=v(b.focusNode))&&(b.anchorNode=b.focusNode=d.container,b.anchorOffset=b.focusOffset=d.offset);b.anchorNode&&b.focusNode&&(b=S.selectionToRange(b),S.selectRange(b.range,b.hasForwardSelection,0===a.button?a.detail:0));B.focus()}function C(a){var b;if(b=f(a.clientX,a.clientY))a=b.container,b=b.offset,a={anchorNode:a,anchorOffset:b,focusNode:a,focusOffset:b},
a=S.selectionToRange(a),S.selectRange(a.range,a.hasForwardSelection,2),B.focus()}function A(a){var b=l(a),c,e;la.processRequests();U&&(ba.isImage(b)&&ba.isCharacterFrame(b.parentNode)&&P.getSelection().isCollapsed?(S.selectImage(b.parentNode),B.focus()):ka.isSelectorElement(b)?B.focus():Q?(b=d.getSelectedRange(),c=b.collapsed,ba.isImage(b.endContainer)&&0===b.endOffset&&ba.isCharacterFrame(b.endContainer.parentNode)&&(e=b.endContainer.parentNode,e=v(e))&&(b.setEnd(e.container,e.offset),c&&b.collapse(!1)),
S.selectRange(b,d.hasForwardSelection(),0===a.button?a.detail:0),B.focus()):ta?u(a):T=runtime.setTimeout(function(){u(a)},0),ma=0,Q=U=!1)}function D(a){var c=M.getCursor(b).getSelectedRange();c.collapsed||V.exportRangeToDataTransfer(a.dataTransfer,c)}function G(){U&&B.focus();ma=0;Q=U=!1}function J(a){A(a)}function O(a){var b=l(a),c=null;"annotationRemoveButton"===b.className?(runtime.assert(ja,"Remove buttons are displayed on annotations while annotation editing is disabled in the controller."),
c=Y.getElementsByTagNameNS(b.parentNode,odf.Namespaces.officens,"annotation")[0],ca.removeAnnotation(c),B.focus()):"webodf-draggable"!==b.getAttribute("class")&&A(a)}function K(a){(a=a.data)&&(-1===a.indexOf("\n")?ea.insertText(a):g.enqueue(pa.createPasteOps(a)))}function W(a){return function(){a();return!0}}function I(a){return function(c){return M.getCursor(b).getSelectionType()===ops.OdtCursor.RangeSelection?a(c):!0}}function aa(b){B.unsubscribe("keydown",x.handleEvent);B.unsubscribe("keypress",
R.handleEvent);B.unsubscribe("keyup",N.handleEvent);B.unsubscribe("copy",m);B.unsubscribe("mousedown",w);B.unsubscribe("mousemove",la.trigger);B.unsubscribe("mouseup",O);B.unsubscribe("contextmenu",J);B.unsubscribe("dragstart",D);B.unsubscribe("dragend",G);B.unsubscribe("click",na.handleClick);B.unsubscribe("longpress",C);B.unsubscribe("drag",s);B.unsubscribe("dragstop",y);M.unsubscribe(ops.OdtDocument.signalOperationEnd,oa.trigger);M.unsubscribe(ops.Document.signalCursorAdded,ia.registerCursor);
M.unsubscribe(ops.Document.signalCursorRemoved,ia.removeCursor);M.unsubscribe(ops.OdtDocument.signalOperationEnd,a);b()}var P=runtime.getWindow(),M=g.getOdtDocument(),Y=new core.DomUtils,ba=new odf.OdfUtils,V=new gui.MimeDataExporter,$=new gui.Clipboard(V),x=new gui.KeyboardHandler,R=new gui.KeyboardHandler,N=new gui.KeyboardHandler,U=!1,H=new odf.ObjectNameGenerator(M.getOdfCanvas().odfContainer(),b),Q=!1,L=null,T,X=null,B=new gui.EventManager(M),ja=e.annotationsEnabled,ca=new gui.AnnotationController(g,
b),da=new gui.DirectFormattingController(g,b,H,e.directTextStylingEnabled,e.directParagraphStylingEnabled),ea=new gui.TextController(g,b,da.createCursorStyleOp,da.createParagraphStyleOps),qa=new gui.ImageController(g,b,H),ka=new gui.ImageSelector(M.getOdfCanvas()),fa=gui.SelectionMover.createPositionIterator(M.getRootNode()),la,oa,pa=new gui.PlainTextPasteboard(M,b),ia=new gui.InputMethodEditor(b,B),ma=0,na=new gui.HyperlinkClickHandler(M.getOdfCanvas().getElement,x,N),ga=new gui.HyperlinkController(g,
b),S=new gui.SelectionController(g,b),ha=new gui.MetadataController(g,b),E=gui.KeyboardHandler.Modifier,F=gui.KeyboardHandler.KeyCode,ra=-1!==P.navigator.appVersion.toLowerCase().indexOf("mac"),ta=-1!==["iPad","iPod","iPhone"].indexOf(P.navigator.platform),sa;runtime.assert(null!==P,"Expected to be run in an environment which has a global window, like a browser.");this.undo=k;this.redo=t;this.insertLocalCursor=function(){runtime.assert(void 0===g.getOdtDocument().getCursor(b),"Inserting local cursor a second time.");
var a=new ops.OpAddCursor;a.init({memberid:b});g.enqueue([a]);B.focus()};this.removeLocalCursor=function(){runtime.assert(void 0!==g.getOdtDocument().getCursor(b),"Removing local cursor without inserting before.");var a=new ops.OpRemoveCursor;a.init({memberid:b});g.enqueue([a])};this.startEditing=function(){ia.subscribe(gui.InputMethodEditor.signalCompositionStart,ea.removeCurrentSelection);ia.subscribe(gui.InputMethodEditor.signalCompositionEnd,K);B.subscribe("beforecut",q);B.subscribe("cut",p);
B.subscribe("beforepaste",c);B.subscribe("paste",r);X&&X.initialize();B.setEditing(!0);na.setModifier(ra?E.Meta:E.Ctrl);x.bind(F.Backspace,E.None,W(ea.removeTextByBackspaceKey),!0);x.bind(F.Delete,E.None,ea.removeTextByDeleteKey);x.bind(F.Tab,E.None,I(function(){ea.insertText("\t");return!0}));ra?(x.bind(F.Clear,E.None,ea.removeCurrentSelection),x.bind(F.B,E.Meta,I(da.toggleBold)),x.bind(F.I,E.Meta,I(da.toggleItalic)),x.bind(F.U,E.Meta,I(da.toggleUnderline)),x.bind(F.L,E.MetaShift,I(da.alignParagraphLeft)),
x.bind(F.E,E.MetaShift,I(da.alignParagraphCenter)),x.bind(F.R,E.MetaShift,I(da.alignParagraphRight)),x.bind(F.J,E.MetaShift,I(da.alignParagraphJustified)),ja&&x.bind(F.C,E.MetaShift,ca.addAnnotation),x.bind(F.Z,E.Meta,k),x.bind(F.Z,E.MetaShift,t)):(x.bind(F.B,E.Ctrl,I(da.toggleBold)),x.bind(F.I,E.Ctrl,I(da.toggleItalic)),x.bind(F.U,E.Ctrl,I(da.toggleUnderline)),x.bind(F.L,E.CtrlShift,I(da.alignParagraphLeft)),x.bind(F.E,E.CtrlShift,I(da.alignParagraphCenter)),x.bind(F.R,E.CtrlShift,I(da.alignParagraphRight)),
x.bind(F.J,E.CtrlShift,I(da.alignParagraphJustified)),ja&&x.bind(F.C,E.CtrlAlt,ca.addAnnotation),x.bind(F.Z,E.Ctrl,k),x.bind(F.Z,E.CtrlShift,t));R.setDefault(I(function(a){var b;b=null===a.which||void 0===a.which?String.fromCharCode(a.keyCode):0!==a.which&&0!==a.charCode?String.fromCharCode(a.which):null;return!b||a.altKey||a.ctrlKey||a.metaKey?!1:(ea.insertText(b),!0)}));R.bind(F.Enter,E.None,I(ea.enqueueParagraphSplittingOps))};this.endEditing=function(){ia.unsubscribe(gui.InputMethodEditor.signalCompositionStart,
ea.removeCurrentSelection);ia.unsubscribe(gui.InputMethodEditor.signalCompositionEnd,K);B.unsubscribe("cut",p);B.unsubscribe("beforecut",q);B.unsubscribe("paste",r);B.unsubscribe("beforepaste",c);B.setEditing(!1);na.setModifier(E.None);x.bind(F.Backspace,E.None,function(){return!0},!0);x.unbind(F.Delete,E.None);x.unbind(F.Tab,E.None);ra?(x.unbind(F.Clear,E.None),x.unbind(F.B,E.Meta),x.unbind(F.I,E.Meta),x.unbind(F.U,E.Meta),x.unbind(F.L,E.MetaShift),x.unbind(F.E,E.MetaShift),x.unbind(F.R,E.MetaShift),
x.unbind(F.J,E.MetaShift),ja&&x.unbind(F.C,E.MetaShift),x.unbind(F.Z,E.Meta),x.unbind(F.Z,E.MetaShift)):(x.unbind(F.B,E.Ctrl),x.unbind(F.I,E.Ctrl),x.unbind(F.U,E.Ctrl),x.unbind(F.L,E.CtrlShift),x.unbind(F.E,E.CtrlShift),x.unbind(F.R,E.CtrlShift),x.unbind(F.J,E.CtrlShift),ja&&x.unbind(F.C,E.CtrlAlt),x.unbind(F.Z,E.Ctrl),x.unbind(F.Z,E.CtrlShift));R.setDefault(null);R.unbind(F.Enter,E.None)};this.getInputMemberId=function(){return b};this.getSession=function(){return g};this.setUndoManager=function(a){X&&
X.unsubscribe(gui.UndoManager.signalUndoStackChanged,n);if(X=a)X.setDocument(M),X.setPlaybackFunction(g.enqueue),X.subscribe(gui.UndoManager.signalUndoStackChanged,n)};this.getUndoManager=function(){return X};this.getMetadataController=function(){return ha};this.getAnnotationController=function(){return ca};this.getDirectFormattingController=function(){return da};this.getHyperlinkClickHandler=function(){return na};this.getHyperlinkController=function(){return ga};this.getImageController=function(){return qa};
this.getSelectionController=function(){return S};this.getTextController=function(){return ea};this.getEventManager=function(){return B};this.getKeyboardHandlers=function(){return{keydown:x,keypress:R}};this.destroy=function(a){var b=[la.destroy,oa.destroy,da.destroy,ia.destroy,B.destroy,na.destroy,ha.destroy,aa];sa&&b.unshift(sa.destroy);runtime.clearTimeout(T);core.Async.destroyAll(b,a)};la=core.Task.createRedrawTask(z);oa=core.Task.createRedrawTask(function(){var a=M.getCursor(b);if(a&&a.getSelectionType()===
ops.OdtCursor.RegionSelection&&(a=ba.getImageElements(a.getSelectedRange())[0])){ka.select(a.parentNode);return}ka.clearSelection()});x.bind(F.Left,E.None,I(S.moveCursorToLeft));x.bind(F.Right,E.None,I(S.moveCursorToRight));x.bind(F.Up,E.None,I(S.moveCursorUp));x.bind(F.Down,E.None,I(S.moveCursorDown));x.bind(F.Left,E.Shift,I(S.extendSelectionToLeft));x.bind(F.Right,E.Shift,I(S.extendSelectionToRight));x.bind(F.Up,E.Shift,I(S.extendSelectionUp));x.bind(F.Down,E.Shift,I(S.extendSelectionDown));x.bind(F.Home,
E.None,I(S.moveCursorToLineStart));x.bind(F.End,E.None,I(S.moveCursorToLineEnd));x.bind(F.Home,E.Ctrl,I(S.moveCursorToDocumentStart));x.bind(F.End,E.Ctrl,I(S.moveCursorToDocumentEnd));x.bind(F.Home,E.Shift,I(S.extendSelectionToLineStart));x.bind(F.End,E.Shift,I(S.extendSelectionToLineEnd));x.bind(F.Up,E.CtrlShift,I(S.extendSelectionToParagraphStart));x.bind(F.Down,E.CtrlShift,I(S.extendSelectionToParagraphEnd));x.bind(F.Home,E.CtrlShift,I(S.extendSelectionToDocumentStart));x.bind(F.End,E.CtrlShift,
I(S.extendSelectionToDocumentEnd));ra?(x.bind(F.Left,E.Alt,I(S.moveCursorBeforeWord)),x.bind(F.Right,E.Alt,I(S.moveCursorPastWord)),x.bind(F.Left,E.Meta,I(S.moveCursorToLineStart)),x.bind(F.Right,E.Meta,I(S.moveCursorToLineEnd)),x.bind(F.Home,E.Meta,I(S.moveCursorToDocumentStart)),x.bind(F.End,E.Meta,I(S.moveCursorToDocumentEnd)),x.bind(F.Left,E.AltShift,I(S.extendSelectionBeforeWord)),x.bind(F.Right,E.AltShift,I(S.extendSelectionPastWord)),x.bind(F.Left,E.MetaShift,I(S.extendSelectionToLineStart)),
x.bind(F.Right,E.MetaShift,I(S.extendSelectionToLineEnd)),x.bind(F.Up,E.AltShift,I(S.extendSelectionToParagraphStart)),x.bind(F.Down,E.AltShift,I(S.extendSelectionToParagraphEnd)),x.bind(F.Up,E.MetaShift,I(S.extendSelectionToDocumentStart)),x.bind(F.Down,E.MetaShift,I(S.extendSelectionToDocumentEnd)),x.bind(F.A,E.Meta,I(S.extendSelectionToEntireDocument))):(x.bind(F.Left,E.Ctrl,I(S.moveCursorBeforeWord)),x.bind(F.Right,E.Ctrl,I(S.moveCursorPastWord)),x.bind(F.Left,E.CtrlShift,I(S.extendSelectionBeforeWord)),
x.bind(F.Right,E.CtrlShift,I(S.extendSelectionPastWord)),x.bind(F.A,E.Ctrl,I(S.extendSelectionToEntireDocument)));ta&&(sa=new gui.IOSSafariSupport(B));B.subscribe("keydown",x.handleEvent);B.subscribe("keypress",R.handleEvent);B.subscribe("keyup",N.handleEvent);B.subscribe("copy",m);B.subscribe("mousedown",w);B.subscribe("mousemove",la.trigger);B.subscribe("mouseup",O);B.subscribe("contextmenu",J);B.subscribe("dragstart",D);B.subscribe("dragend",G);B.subscribe("click",na.handleClick);B.subscribe("longpress",
C);B.subscribe("drag",s);B.subscribe("dragstop",y);M.subscribe(ops.OdtDocument.signalOperationEnd,oa.trigger);M.subscribe(ops.Document.signalCursorAdded,ia.registerCursor);M.subscribe(ops.Document.signalCursorRemoved,ia.removeCursor);M.subscribe(ops.OdtDocument.signalOperationEnd,a)}})();
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
gui.CaretManager=function(h){function g(b){return a.hasOwnProperty(b)?a[b]:null}function b(){return Object.keys(a).map(function(b){return a[b]})}function d(b){var c=a[b];c&&(c.destroy(function(){}),b===h.getInputMemberId()&&h.getEventManager().unsubscribe("compositionupdate",c.handleUpdate),delete a[b])}function e(a){a=a.getMemberId();a===h.getInputMemberId()&&(a=g(a))&&a.refreshCursorBlinking()}function l(){var a=g(h.getInputMemberId());t=!1;a&&a.ensureVisible()}function f(){var a=g(h.getInputMemberId());
a&&(a.handleUpdate(),t||(t=!0,k=runtime.setTimeout(l,50)))}function p(a){a.memberId===h.getInputMemberId()&&f()}function q(){var a=g(h.getInputMemberId());a&&a.setFocus()}function m(){var a=g(h.getInputMemberId());a&&a.removeFocus()}function r(){var a=g(h.getInputMemberId());a&&a.show()}function c(){var a=g(h.getInputMemberId());a&&a.hide()}var a={},n=runtime.getWindow(),k,t=!1;this.registerCursor=function(b,c,d){var e=b.getMemberId();c=new gui.Caret(b,c,d);d=h.getEventManager();a[e]=c;e===h.getInputMemberId()?
(runtime.log("Starting to track input on new cursor of "+e),b.subscribe(ops.OdtCursor.signalCursorUpdated,f),d.subscribe("compositionupdate",c.handleUpdate),c.setOverlayElement(d.getEventTrap())):b.subscribe(ops.OdtCursor.signalCursorUpdated,c.handleUpdate);return c};this.getCaret=g;this.getCarets=b;this.destroy=function(f){var g=h.getSession().getOdtDocument(),l=h.getEventManager(),t=b().map(function(a){return a.destroy});runtime.clearTimeout(k);g.unsubscribe(ops.OdtDocument.signalParagraphChanged,
p);g.unsubscribe(ops.Document.signalCursorMoved,e);g.unsubscribe(ops.Document.signalCursorRemoved,d);l.unsubscribe("focus",q);l.unsubscribe("blur",m);n.removeEventListener("focus",r,!1);n.removeEventListener("blur",c,!1);a={};core.Async.destroyAll(t,f)};(function(){var a=h.getSession().getOdtDocument(),b=h.getEventManager();a.subscribe(ops.OdtDocument.signalParagraphChanged,p);a.subscribe(ops.Document.signalCursorMoved,e);a.subscribe(ops.Document.signalCursorRemoved,d);b.subscribe("focus",q);b.subscribe("blur",
m);n.addEventListener("focus",r,!1);n.addEventListener("blur",c,!1)})()};
// Input 104
gui.EditInfoHandle=function(h){var g=[],b,d=h.ownerDocument,e=d.documentElement.namespaceURI;this.setEdits=function(h){g=h;var f,p,q,m;b.innerHTML="";for(h=0;h<g.length;h+=1)f=d.createElementNS(e,"div"),f.className="editInfo",p=d.createElementNS(e,"span"),p.className="editInfoColor",p.setAttributeNS("urn:webodf:names:editinfo","editinfo:memberid",g[h].memberid),q=d.createElementNS(e,"span"),q.className="editInfoAuthor",q.setAttributeNS("urn:webodf:names:editinfo","editinfo:memberid",g[h].memberid),
m=d.createElementNS(e,"span"),m.className="editInfoTime",m.setAttributeNS("urn:webodf:names:editinfo","editinfo:memberid",g[h].memberid),m.innerHTML=g[h].time,f.appendChild(p),f.appendChild(q),f.appendChild(m),b.appendChild(f)};this.show=function(){b.style.display="block"};this.hide=function(){b.style.display="none"};this.destroy=function(d){h.removeChild(b);d()};b=d.createElementNS(e,"div");b.setAttribute("class","editInfoHandle");b.style.display="none";h.appendChild(b)};
// Input 105
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
ops.EditInfo=function(h,g){function b(){var b=[],d;for(d in e)e.hasOwnProperty(d)&&b.push({memberid:d,time:e[d].time});b.sort(function(b,d){return b.time-d.time});return b}var d,e={};this.getNode=function(){return d};this.getOdtDocument=function(){return g};this.getEdits=function(){return e};this.getSortedEdits=function(){return b()};this.addEdit=function(b,d){e[b]={time:d}};this.clearEdits=function(){e={}};this.destroy=function(b){h.parentNode&&h.removeChild(d);b()};d=g.getDOMDocument().createElementNS("urn:webodf:names:editinfo",
"editinfo");h.insertBefore(d,h.firstChild)};
// Input 106
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
gui.EditInfoMarker=function(h,g){function b(b,c){return runtime.setTimeout(function(){f.style.opacity=b},c)}var d=this,e,l,f,p,q,m;this.addEdit=function(d,c){var a=Date.now()-c;h.addEdit(d,c);l.setEdits(h.getSortedEdits());f.setAttributeNS("urn:webodf:names:editinfo","editinfo:memberid",d);runtime.clearTimeout(q);runtime.clearTimeout(m);1E4>a?(p=b(1,0),q=b(0.5,1E4-a),m=b(0.2,2E4-a)):1E4<=a&&2E4>a?(p=b(0.5,0),m=b(0.2,2E4-a)):p=b(0.2,0)};this.getEdits=function(){return h.getEdits()};this.clearEdits=
function(){h.clearEdits();l.setEdits([]);f.hasAttributeNS("urn:webodf:names:editinfo","editinfo:memberid")&&f.removeAttributeNS("urn:webodf:names:editinfo","editinfo:memberid")};this.getEditInfo=function(){return h};this.show=function(){f.style.display="block"};this.hide=function(){d.hideHandle();f.style.display="none"};this.showHandle=function(){l.show()};this.hideHandle=function(){l.hide()};this.destroy=function(b){runtime.clearTimeout(p);runtime.clearTimeout(q);runtime.clearTimeout(m);e.removeChild(f);
l.destroy(function(c){c?b(c):h.destroy(b)})};(function(){var b=h.getOdtDocument().getDOMDocument();f=b.createElementNS(b.documentElement.namespaceURI,"div");f.setAttribute("class","editInfoMarker");f.onmouseover=function(){d.showHandle()};f.onmouseout=function(){d.hideHandle()};e=h.getNode();e.appendChild(f);l=new gui.EditInfoHandle(e);g||d.hide()})()};
// Input 107
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
gui.HyperlinkTooltipView=function(h,g){var b=new core.DomUtils,d=new odf.OdfUtils,e=runtime.getWindow(),l,f,p;runtime.assert(null!==e,"Expected to be run in an environment which has a global window, like a browser.");this.showTooltip=function(q){var m=q.target||q.srcElement,r=h.getSizer(),c=h.getZoomLevel(),a;a:{for(;m;){if(d.isHyperlink(m))break a;if(d.isParagraph(m)||d.isInlineRoot(m))break;m=m.parentNode}m=null}if(m){b.containsNode(r,p)||r.appendChild(p);a=f;var n;switch(g()){case gui.KeyboardHandler.Modifier.Ctrl:n=
runtime.tr("Ctrl-click to follow link");break;case gui.KeyboardHandler.Modifier.Meta:n=runtime.tr("\u2318-click to follow link");break;default:n=""}a.textContent=n;l.textContent=d.getHyperlinkTarget(m);p.style.display="block";a=e.innerWidth-p.offsetWidth-15;m=q.clientX>a?a:q.clientX+15;a=e.innerHeight-p.offsetHeight-10;q=q.clientY>a?a:q.clientY+10;r=r.getBoundingClientRect();m=(m-r.left)/c;q=(q-r.top)/c;p.style.left=m+"px";p.style.top=q+"px"}};this.hideTooltip=function(){p.style.display="none"};this.destroy=
function(b){p.parentNode&&p.parentNode.removeChild(p);b()};(function(){var b=h.getElement().ownerDocument;l=b.createElement("span");f=b.createElement("span");l.className="webodf-hyperlinkTooltipLink";f.className="webodf-hyperlinkTooltipText";p=b.createElement("div");p.className="webodf-hyperlinkTooltip";p.appendChild(l);p.appendChild(f);h.getElement().appendChild(p)})()};
// Input 108
gui.ShadowCursor=function(h){var g=h.getDOMDocument().createRange(),b=!0;this.removeFromDocument=function(){};this.getMemberId=function(){return gui.ShadowCursor.ShadowCursorMemberId};this.getSelectedRange=function(){return g};this.setSelectedRange=function(d,e){g=d;b=!1!==e};this.hasForwardSelection=function(){return b};this.getDocument=function(){return h};this.getSelectionType=function(){return ops.OdtCursor.RangeSelection};g.setStart(h.getRootNode(),0)};gui.ShadowCursor.ShadowCursorMemberId="";
// Input 109
gui.SelectionView=function(h){};gui.SelectionView.prototype.rerender=function(){};gui.SelectionView.prototype.show=function(){};gui.SelectionView.prototype.hide=function(){};gui.SelectionView.prototype.destroy=function(h){};
// Input 110
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
gui.SelectionViewManager=function(h){function g(){return Object.keys(b).map(function(d){return b[d]})}var b={};this.getSelectionView=function(d){return b.hasOwnProperty(d)?b[d]:null};this.getSelectionViews=g;this.removeSelectionView=function(d){b.hasOwnProperty(d)&&(b[d].destroy(function(){}),delete b[d])};this.hideSelectionView=function(d){b.hasOwnProperty(d)&&b[d].hide()};this.showSelectionView=function(d){b.hasOwnProperty(d)&&b[d].show()};this.rerenderSelectionViews=function(){Object.keys(b).forEach(function(d){b[d].rerender()})};
this.registerCursor=function(d,e){var g=d.getMemberId(),f=new h(d);e?f.show():f.hide();return b[g]=f};this.destroy=function(b){function e(f,g){g?b(g):f<h.length?h[f].destroy(function(b){e(f+1,b)}):b()}var h=g();e(0,void 0)}};
// Input 111
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
(function(){gui.SessionView=function(h,g,b,d,e){function l(a,b,c){function d(b,c,e){c=b+'[editinfo|memberid="'+a+'"]'+e+c;a:{var f=n.firstChild;for(b=b+'[editinfo|memberid="'+a+'"]'+e+"{";f;){if(f.nodeType===Node.TEXT_NODE&&0===f.data.indexOf(b)){b=f;break a}f=f.nextSibling}b=null}b?b.data=c:n.appendChild(document.createTextNode(c))}d("div.editInfoMarker","{ background-color: "+c+"; }","");d("span.editInfoColor","{ background-color: "+c+"; }","");d("span.editInfoAuthor",'{ content: "'+b+'"; }',":before");
d("dc|creator","{ background-color: "+c+"; }","");d(".webodf-selectionOverlay","{ fill: "+c+"; stroke: "+c+";}","");a!==gui.ShadowCursor.ShadowCursorMemberId&&a!==g||d(".webodf-touchEnabled .webodf-selectionOverlay","{ display: block; }"," > .webodf-draggable")}function f(a){var b,c;for(c in t)t.hasOwnProperty(c)&&(b=t[c],a?b.show():b.hide())}function p(a){d.getCarets().forEach(function(b){a?b.showHandle():b.hideHandle()})}function q(a){var b=a.getMemberId();a=a.getProperties();l(b,a.fullName,a.color);
g===b&&l("","",a.color)}function m(a){var c=a.getMemberId(),f=b.getOdtDocument().getMember(c).getProperties();d.registerCursor(a,y,z);e.registerCursor(a,!0);if(a=d.getCaret(c))a.setAvatarImageUrl(f.imageUrl),a.setColor(f.color);runtime.log("+++ View here +++ eagerly created an Caret for '"+c+"'! +++")}function r(a){a=a.getMemberId();var b=e.getSelectionView(g),c=e.getSelectionView(gui.ShadowCursor.ShadowCursorMemberId),f=d.getCaret(g);a===g?(c.hide(),b&&b.show(),f&&f.show()):a===gui.ShadowCursor.ShadowCursorMemberId&&
(c.show(),b&&b.hide(),f&&f.hide())}function c(a){e.removeSelectionView(a)}function a(a){var c=a.paragraphElement,d=a.memberId;a=a.timeStamp;var e,f="",g=c.getElementsByTagNameNS(k,"editinfo").item(0);g?(f=g.getAttributeNS(k,"id"),e=t[f]):(f=Math.random().toString(),e=new ops.EditInfo(c,b.getOdtDocument()),e=new gui.EditInfoMarker(e,s),g=c.getElementsByTagNameNS(k,"editinfo").item(0),g.setAttributeNS(k,"id",f),t[f]=e);e.addEdit(d,new Date(a))}var n,k="urn:webodf:names:editinfo",t={},s=void 0!==h.editInfoMarkersInitiallyVisible?
Boolean(h.editInfoMarkersInitiallyVisible):!0,y=void 0!==h.caretAvatarsInitiallyVisible?Boolean(h.caretAvatarsInitiallyVisible):!0,z=void 0!==h.caretBlinksOnRangeSelect?Boolean(h.caretBlinksOnRangeSelect):!0;this.showEditInfoMarkers=function(){s||(s=!0,f(s))};this.hideEditInfoMarkers=function(){s&&(s=!1,f(s))};this.showCaretAvatars=function(){y||(y=!0,p(y))};this.hideCaretAvatars=function(){y&&(y=!1,p(y))};this.getSession=function(){return b};this.getCaret=function(a){return d.getCaret(a)};this.destroy=
function(d){var f=b.getOdtDocument(),g=Object.keys(t).map(function(a){return t[a]});f.unsubscribe(ops.Document.signalMemberAdded,q);f.unsubscribe(ops.Document.signalMemberUpdated,q);f.unsubscribe(ops.Document.signalCursorAdded,m);f.unsubscribe(ops.Document.signalCursorRemoved,c);f.unsubscribe(ops.OdtDocument.signalParagraphChanged,a);f.unsubscribe(ops.Document.signalCursorMoved,r);f.unsubscribe(ops.OdtDocument.signalParagraphChanged,e.rerenderSelectionViews);f.unsubscribe(ops.OdtDocument.signalTableAdded,
e.rerenderSelectionViews);f.unsubscribe(ops.OdtDocument.signalParagraphStyleModified,e.rerenderSelectionViews);n.parentNode.removeChild(n);(function A(a,b){b?d(b):a<g.length?g[a].destroy(function(b){A(a+1,b)}):d()})(0,void 0)};(function(){var d=b.getOdtDocument(),f=document.getElementsByTagName("head").item(0);d.subscribe(ops.Document.signalMemberAdded,q);d.subscribe(ops.Document.signalMemberUpdated,q);d.subscribe(ops.Document.signalCursorAdded,m);d.subscribe(ops.Document.signalCursorRemoved,c);d.subscribe(ops.OdtDocument.signalParagraphChanged,
a);d.subscribe(ops.Document.signalCursorMoved,r);d.subscribe(ops.OdtDocument.signalParagraphChanged,e.rerenderSelectionViews);d.subscribe(ops.OdtDocument.signalTableAdded,e.rerenderSelectionViews);d.subscribe(ops.OdtDocument.signalParagraphStyleModified,e.rerenderSelectionViews);n=document.createElementNS(f.namespaceURI,"style");n.type="text/css";n.media="screen, print, handheld, projection";n.appendChild(document.createTextNode("@namespace editinfo url(urn:webodf:names:editinfo);"));n.appendChild(document.createTextNode("@namespace dc url(http://purl.org/dc/elements/1.1/);"));
f.appendChild(n)})()}})();
// Input 112
gui.SvgSelectionView=function(h){function g(){var b=a.getRootNode();n!==b&&(n=b,k=a.getCanvas().getSizer(),k.appendChild(s),s.setAttribute("class","webodf-selectionOverlay"),z.setAttribute("class","webodf-draggable"),w.setAttribute("class","webodf-draggable"),z.setAttribute("end","left"),w.setAttribute("end","right"),z.setAttribute("r",8),w.setAttribute("r",8),s.appendChild(y),s.appendChild(z),s.appendChild(w))}function b(a){a=a.getBoundingClientRect();return Boolean(a&&0!==a.height)}function d(a){var c=
v.getTextElements(a,!0,!1),d=a.cloneRange(),e=a.cloneRange();a=a.cloneRange();if(!c.length)return null;var f;a:{f=0;var g=c[f],h=d.startContainer===g?d.startOffset:0,k=h;d.setStart(g,h);for(d.setEnd(g,k);!b(d);){if(g.nodeType===Node.ELEMENT_NODE&&k<g.childNodes.length)k=g.childNodes.length;else if(g.nodeType===Node.TEXT_NODE&&k<g.length)k+=1;else if(c[f])g=c[f],f+=1,h=k=0;else{f=!1;break a}d.setStart(g,h);d.setEnd(g,k)}f=!0}if(!f)return null;a:{f=c.length-1;g=c[f];k=h=e.endContainer===g?e.endOffset:
g.nodeType===Node.TEXT_NODE?g.length:g.childNodes.length;e.setStart(g,h);for(e.setEnd(g,k);!b(e);){if(g.nodeType===Node.ELEMENT_NODE&&0<h)h=0;else if(g.nodeType===Node.TEXT_NODE&&0<h)h-=1;else if(c[f])g=c[f],f-=1,h=k=g.length||g.childNodes.length;else{c=!1;break a}e.setStart(g,h);e.setEnd(g,k)}c=!0}if(!c)return null;a.setStart(d.startContainer,d.startOffset);a.setEnd(e.endContainer,e.endOffset);return{firstRange:d,lastRange:e,fillerRange:a}}function e(a,b){var c={};c.top=Math.min(a.top,b.top);c.left=
Math.min(a.left,b.left);c.right=Math.max(a.right,b.right);c.bottom=Math.max(a.bottom,b.bottom);c.width=c.right-c.left;c.height=c.bottom-c.top;return c}function l(a,b){b&&0<b.width&&0<b.height&&(a=a?e(a,b):b);return a}function f(b){function c(a){D.setUnfilteredPosition(a,0);return w.acceptNode(a)===G&&s.acceptPosition(D)===G?G:J}function d(a){var b=null;c(a)===G&&(b=u.getBoundingClientRect(a));return b}var e=b.commonAncestorContainer,f=b.startContainer,g=b.endContainer,h=b.startOffset,k=b.endOffset,
n,m,p=null,q,r=t.createRange(),s,w=new odf.OdfNodeFilter,y;if(f===e||g===e)return r=b.cloneRange(),p=r.getBoundingClientRect(),r.detach(),p;for(b=f;b.parentNode!==e;)b=b.parentNode;for(m=g;m.parentNode!==e;)m=m.parentNode;s=a.createRootFilter(f);for(e=b.nextSibling;e&&e!==m;)q=d(e),p=l(p,q),e=e.nextSibling;if(v.isParagraph(b))p=l(p,u.getBoundingClientRect(b));else if(b.nodeType===Node.TEXT_NODE)e=b,r.setStart(e,h),r.setEnd(e,e===m?k:e.length),q=r.getBoundingClientRect(),p=l(p,q);else for(y=t.createTreeWalker(b,
NodeFilter.SHOW_TEXT,c,!1),e=y.currentNode=f;e&&e!==g;)r.setStart(e,h),r.setEnd(e,e.length),q=r.getBoundingClientRect(),p=l(p,q),n=e,h=0,e=y.nextNode();n||(n=f);if(v.isParagraph(m))p=l(p,u.getBoundingClientRect(m));else if(m.nodeType===Node.TEXT_NODE)e=m,r.setStart(e,e===b?h:0),r.setEnd(e,k),q=r.getBoundingClientRect(),p=l(p,q);else for(y=t.createTreeWalker(m,NodeFilter.SHOW_TEXT,c,!1),e=y.currentNode=g;e&&e!==n;)if(r.setStart(e,0),r.setEnd(e,k),q=r.getBoundingClientRect(),p=l(p,q),e=y.previousNode())k=
e.length;return p}function p(a,b){var c=a.getBoundingClientRect(),d={width:0};d.top=c.top;d.bottom=c.bottom;d.height=c.height;d.left=d.right=b?c.right:c.left;return d}function q(){var a=h.getSelectedRange(),b;if(b=A&&h.getSelectionType()===ops.OdtCursor.RangeSelection&&!a.collapsed){g();var c=u.getBoundingClientRect(k),l=C.getZoomLevel(),a=d(a),n,m,q,r,t,v;if(a){b=a.firstRange;n=a.lastRange;m=a.fillerRange;q=u.translateRect(p(b,!1),c,l);t=u.translateRect(p(n,!0),c,l);r=(r=f(m))?u.translateRect(r,
c,l):e(q,t);v=r.left;r=q.left+Math.max(0,r.width-(q.left-r.left));c=Math.min(q.top,t.top);l=t.top+t.height;v=[{x:q.left,y:c+q.height},{x:q.left,y:c},{x:r,y:c},{x:r,y:l-t.height},{x:t.right,y:l-t.height},{x:t.right,y:l},{x:v,y:l},{x:v,y:c+q.height},{x:q.left,y:c+q.height}];r="";var x;for(x=0;x<v.length;x+=1)r+=v[x].x+","+v[x].y+" ";y.setAttribute("points",r);z.setAttribute("cx",q.left);z.setAttribute("cy",c+q.height/2);w.setAttribute("cx",t.right);w.setAttribute("cy",l-t.height/2);b.detach();n.detach();
m.detach()}b=Boolean(a)}s.style.display=b?"block":"none"}function m(a){A&&a===h&&O.trigger()}function r(a){a=8/a;z.setAttribute("r",a);w.setAttribute("r",a)}function c(a){k.removeChild(s);k.classList.remove("webodf-virtualSelections");h.getDocument().unsubscribe(ops.Document.signalCursorMoved,m);C.unsubscribe(gui.ZoomHelper.signalZoomChanged,r);a()}var a=h.getDocument(),n,k,t=a.getDOMDocument(),s=t.createElementNS("http://www.w3.org/2000/svg","svg"),y=t.createElementNS("http://www.w3.org/2000/svg",
"polygon"),z=t.createElementNS("http://www.w3.org/2000/svg","circle"),w=t.createElementNS("http://www.w3.org/2000/svg","circle"),v=new odf.OdfUtils,u=new core.DomUtils,C=a.getCanvas().getZoomHelper(),A=!0,D=gui.SelectionMover.createPositionIterator(a.getRootNode()),G=NodeFilter.FILTER_ACCEPT,J=NodeFilter.FILTER_REJECT,O;this.rerender=function(){A&&O.trigger()};this.show=function(){A=!0;O.trigger()};this.hide=function(){A=!1;O.trigger()};this.destroy=function(a){core.Async.destroyAll([O.destroy,c],
a)};(function(){var a=h.getMemberId();O=core.Task.createRedrawTask(q);g();s.setAttributeNS("urn:webodf:names:editinfo","editinfo:memberid",a);k.classList.add("webodf-virtualSelections");h.getDocument().subscribe(ops.Document.signalCursorMoved,m);C.subscribe(gui.ZoomHelper.signalZoomChanged,r);r(C.getZoomLevel())})()};
// Input 113
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
gui.UndoStateRules=function(){function h(b,d){var f=b.length;this.previous=function(){for(f-=1;0<=f;f-=1)if(d(b[f]))return b[f];return null}}function g(b){b=b.spec();var d;b.hasOwnProperty("position")&&(d=b.position);return d}function b(b){return b.isEdit}function d(b,d,f){if(!f)return f=g(b)-g(d),0===f||1===Math.abs(f);b=g(b);d=g(d);f=g(f);return b-d===d-f}this.isEditOperation=b;this.isPartOfOperationSet=function(e,g){var f=void 0!==e.group,p;if(!e.isEdit||0===g.length)return!0;p=g[g.length-1];if(f&&
e.group===p.group)return!0;a:switch(e.spec().optype){case "RemoveText":case "InsertText":p=!0;break a;default:p=!1}if(p&&g.some(b)){if(f){var q;f=e.spec().optype;p=new h(g,b);var m=p.previous(),r=null,c,a;runtime.assert(Boolean(m),"No edit operations found in state");a=m.group;runtime.assert(void 0!==a,"Operation has no group");for(c=1;m&&m.group===a;){if(f===m.spec().optype){q=m;break}m=p.previous()}if(q){for(m=p.previous();m;){if(m.group!==a){if(2===c)break;a=m.group;c+=1}if(f===m.spec().optype){r=
m;break}m=p.previous()}q=d(e,q,r)}else q=!1;return q}q=e.spec().optype;f=new h(g,b);p=f.previous();runtime.assert(Boolean(p),"No edit operations found in state");q=q===p.spec().optype?d(e,p,f.previous()):!1;return q}return!1}};
// Input 114
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
gui.TrivialUndoManager=function(h){function g(a){0<a.length&&(v=!0,n(a),v=!1)}function b(){z.emit(gui.UndoManager.signalUndoStackChanged,{undoAvailable:q.hasUndoStates(),redoAvailable:q.hasRedoStates()})}function d(){t!==a&&t!==s[s.length-1]&&s.push(t)}function e(a){var b=a.previousSibling||a.nextSibling;a.parentNode.removeChild(a);r.normalizeTextNodes(b)}function l(a){return Object.keys(a).map(function(b){return a[b]})}function f(a){function b(a){var g=a.spec();if(e[g.memberid])switch(g.optype){case "AddCursor":c[g.memberid]||
(c[g.memberid]=a,delete e[g.memberid],f-=1);break;case "MoveCursor":d[g.memberid]||(d[g.memberid]=a)}}var c={},d={},e={},f,g=a.pop();k.getMemberIds().forEach(function(a){e[a]=!0});for(f=Object.keys(e).length;g&&0<f;)g.reverse(),g.forEach(b),g=a.pop();return l(c).concat(l(d))}function p(){var g=c=k.cloneDocumentElement();r.getElementsByTagNameNS(g,m,"cursor").forEach(e);r.getElementsByTagNameNS(g,m,"anchor").forEach(e);d();t=a=f([a].concat(s));s.length=0;y.length=0;b()}var q=this,m="urn:webodf:names:cursor",
r=new core.DomUtils,c,a=[],n,k,t=[],s=[],y=[],z=new core.EventNotifier([gui.UndoManager.signalUndoStackChanged,gui.UndoManager.signalUndoStateCreated,gui.UndoManager.signalUndoStateModified,gui.TrivialUndoManager.signalDocumentRootReplaced]),w=h||new gui.UndoStateRules,v=!1;this.subscribe=function(a,b){z.subscribe(a,b)};this.unsubscribe=function(a,b){z.unsubscribe(a,b)};this.hasUndoStates=function(){return 0<s.length};this.hasRedoStates=function(){return 0<y.length};this.setDocument=function(a){k=
a};this.purgeInitialState=function(){s.length=0;y.length=0;a.length=0;t.length=0;c=null;b()};this.setInitialState=p;this.initialize=function(){c||p()};this.setPlaybackFunction=function(a){n=a};this.onOperationExecuted=function(c){v||(w.isEditOperation(c)&&(t===a||0<y.length)||!w.isPartOfOperationSet(c,t)?(y.length=0,d(),t=[c],s.push(t),z.emit(gui.UndoManager.signalUndoStateCreated,{operations:t}),b()):(t.push(c),z.emit(gui.UndoManager.signalUndoStateModified,{operations:t})))};this.moveForward=function(a){for(var c=
0,d;a&&y.length;)d=y.pop(),s.push(d),g(d),a-=1,c+=1;c&&(t=s[s.length-1],b());return c};this.moveBackward=function(d){for(var e=0;d&&s.length;)y.push(s.pop()),d-=1,e+=1;e&&(k.getMemberIds().forEach(function(a){k.removeCursor(a)}),k.setDocumentElement(c.cloneNode(!0)),z.emit(gui.TrivialUndoManager.signalDocumentRootReplaced,{}),g(a),s.forEach(g),t=s[s.length-1]||a,b());return e}};gui.TrivialUndoManager.signalDocumentRootReplaced="documentRootReplaced";
// Input 115
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
odf.LazyStyleProperties=function(h,g){var b={};this.value=function(d){var e;b.hasOwnProperty(d)?e=b[d]:(e=g[d](),void 0===e&&h&&(e=h.value(d)),b[d]=e);return e};this.reset=function(d){h=d;b={}}};
odf.StyleParseUtils=function(){function h(b){var d,e;b=(b=/(-?[0-9]*[0-9][0-9]*(\.[0-9]*)?|0+\.[0-9]*[1-9][0-9]*|\.[0-9]*[1-9][0-9]*)((cm)|(mm)|(in)|(pt)|(pc)|(px))/.exec(b))?{value:parseFloat(b[1]),unit:b[3]}:null;e=b&&b.unit;"px"===e?d=b.value:"cm"===e?d=96*(b.value/2.54):"mm"===e?d=96*(b.value/25.4):"in"===e?d=96*b.value:"pt"===e?d=b.value/0.75:"pc"===e&&(d=16*b.value);return d}var g=odf.Namespaces.stylens;this.parseLength=h;this.parsePositiveLengthOrPercent=function(b,d,e){var g;b&&(g=parseFloat(b.substr(0,
b.indexOf("%"))),isNaN(g)&&(g=void 0));var f;void 0!==g?(e&&(f=e.value(d)),g=void 0===f?void 0:g*(f/100)):g=h(b);return g};this.getPropertiesElement=function(b,d,e){for(d=e?e.nextElementSibling:d.firstElementChild;null!==d&&(d.localName!==b||d.namespaceURI!==g);)d=d.nextElementSibling;return d}};
// Input 116
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
odf.GraphicProperties=function(h,g,b){var d=this,e=odf.Namespaces.stylens,l=odf.Namespaces.svgns;this.verticalPos=function(){return d.data.value("verticalPos")};this.verticalRel=function(){return d.data.value("verticalRel")};this.horizontalPos=function(){return d.data.value("horizontalPos")};this.horizontalRel=function(){return d.data.value("horizontalRel")};this.strokeWidth=function(){return d.data.value("strokeWidth")};d.data=new odf.LazyStyleProperties(void 0===b?void 0:b.data,{verticalPos:function(){var b=
h.getAttributeNS(e,"vertical-pos");return""===b?void 0:b},verticalRel:function(){var b=h.getAttributeNS(e,"vertical-rel");return""===b?void 0:b},horizontalPos:function(){var b=h.getAttributeNS(e,"horizontal-pos");return""===b?void 0:b},horizontalRel:function(){var b=h.getAttributeNS(e,"horizontal-rel");return""===b?void 0:b},strokeWidth:function(){var b=h.getAttributeNS(l,"stroke-width");return g.parseLength(b)}})};
odf.ComputedGraphicProperties=function(){var h;this.setGraphicProperties=function(g){h=g};this.verticalPos=function(){return h&&h.verticalPos()||"from-top"};this.verticalRel=function(){return h&&h.verticalRel()||"page"};this.horizontalPos=function(){return h&&h.horizontalPos()||"from-left"};this.horizontalRel=function(){return h&&h.horizontalRel()||"page"}};
// Input 117
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
odf.PageLayoutProperties=function(h,g,b){var d=this,e=odf.Namespaces.fons;this.pageHeight=function(){return d.data.value("pageHeight")||1123};this.pageWidth=function(){return d.data.value("pageWidth")||794};d.data=new odf.LazyStyleProperties(void 0===b?void 0:b.data,{pageHeight:function(){var b;h&&(b=h.getAttributeNS(e,"page-height"),b=g.parseLength(b));return b},pageWidth:function(){var b;h&&(b=h.getAttributeNS(e,"page-width"),b=g.parseLength(b));return b}})};
odf.PageLayout=function(h,g,b){var d=null;h&&(d=g.getPropertiesElement("page-layout-properties",h));this.pageLayout=new odf.PageLayoutProperties(d,g,b&&b.pageLayout)};odf.PageLayoutCache=function(){};odf.PageLayoutCache.prototype.getPageLayout=function(h){};odf.PageLayoutCache.prototype.getDefaultPageLayout=function(){};
// Input 118
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
odf.ParagraphProperties=function(h,g,b){var d=this,e=odf.Namespaces.fons;this.marginTop=function(){return d.data.value("marginTop")};d.data=new odf.LazyStyleProperties(void 0===b?void 0:b.data,{marginTop:function(){var d=h.getAttributeNS(e,"margin-top");return g.parsePositiveLengthOrPercent(d,"marginTop",b&&b.data)}})};
odf.ComputedParagraphProperties=function(){var h={},g=[];this.setStyleChain=function(b){g=b;h={}};this.marginTop=function(){var b,d;if(h.hasOwnProperty("marginTop"))b=h.marginTop;else{for(d=0;void 0===b&&d<g.length;d+=1)b=g[d].marginTop();h.marginTop=b}return b||0}};
// Input 119
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
odf.TextProperties=function(h,g,b){var d=this,e=odf.Namespaces.fons;this.fontSize=function(){return d.data.value("fontSize")};d.data=new odf.LazyStyleProperties(void 0===b?void 0:b.data,{fontSize:function(){var d=h.getAttributeNS(e,"font-size");return g.parsePositiveLengthOrPercent(d,"fontSize",b&&b.data)}})};
odf.ComputedTextProperties=function(){var h={},g=[];this.setStyleChain=function(b){g=b;h={}};this.fontSize=function(){var b,d;if(h.hasOwnProperty("fontSize"))b=h.fontSize;else{for(d=0;void 0===b&&d<g.length;d+=1)b=g[d].fontSize();h.fontSize=b}return b||12}};
// Input 120
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
odf.MasterPage=function(h,g){var b;h?(b=h.getAttributeNS(odf.Namespaces.stylens,"page-layout-name"),this.pageLayout=g.getPageLayout(b)):this.pageLayout=g.getDefaultPageLayout()};odf.MasterPageCache=function(){};odf.MasterPageCache.prototype.getMasterPage=function(h){};
odf.StylePileEntry=function(h,g,b,d){this.masterPage=function(){var d=h.getAttributeNS(odf.Namespaces.stylens,"master-page-name"),g=null;d&&(g=b.getMasterPage(d));return g};(function(b){var l=h.getAttributeNS(odf.Namespaces.stylens,"family"),f=null;if("graphic"===l||"chart"===l)b.graphic=void 0===d?void 0:d.graphic,f=g.getPropertiesElement("graphic-properties",h,f),null!==f&&(b.graphic=new odf.GraphicProperties(f,g,b.graphic));if("paragraph"===l||"table-cell"===l||"graphic"===l||"presentation"===
l||"chart"===l)b.paragraph=void 0===d?void 0:d.paragraph,f=g.getPropertiesElement("paragraph-properties",h,f),null!==f&&(b.paragraph=new odf.ParagraphProperties(f,g,b.paragraph));if("text"===l||"paragraph"===l||"table-cell"===l||"graphic"===l||"presentation"===l||"chart"===l)b.text=void 0===d?void 0:d.text,f=g.getPropertiesElement("text-properties",h,f),null!==f&&(b.text=new odf.TextProperties(f,g,b.text))})(this)};
odf.StylePile=function(h,g){function b(b,c){var a,e;b.hasAttributeNS(d,"parent-style-name")&&(e=b.getAttributeNS(d,"parent-style-name"),-1===c.indexOf(e)&&(a=m(e,c)));return new odf.StylePileEntry(b,h,g,a)}var d=odf.Namespaces.stylens,e={},l={},f,p={},q={},m;m=function(d,c){var a=p[d],f;!a&&(f=e[d])&&(c.push(d),a=b(f,c),p[d]=a);return a};this.getStyle=function(d){var c=q[d]||p[d],a,f=[];c||(a=l[d],a||(a=e[d])&&f.push(d),a&&(c=b(a,f)));return c};this.addCommonStyle=function(b){var c;b.hasAttributeNS(d,
"name")&&(c=b.getAttributeNS(d,"name"),e.hasOwnProperty(c)||(e[c]=b))};this.addAutomaticStyle=function(b){var c;b.hasAttributeNS(d,"name")&&(c=b.getAttributeNS(d,"name"),l.hasOwnProperty(c)||(l[c]=b))};this.setDefaultStyle=function(d){void 0===f&&(f=b(d,[]))};this.getDefaultStyle=function(){return f}};odf.ComputedGraphicStyle=function(){this.text=new odf.ComputedTextProperties;this.paragraph=new odf.ComputedParagraphProperties;this.graphic=new odf.ComputedGraphicProperties};
odf.ComputedParagraphStyle=function(){this.text=new odf.ComputedTextProperties;this.paragraph=new odf.ComputedParagraphProperties};odf.ComputedTextStyle=function(){this.text=new odf.ComputedTextProperties};
odf.StyleCache=function(h){function g(a,b,c,d){b=c.getAttributeNS(b,"class-names");var e;if(b)for(b=b.split(" "),e=0;e<b.length;e+=1)if(c=b[e])d.push(a),d.push(c)}function b(a,b){var c=s.getStyleName("paragraph",a);void 0!==c&&(b.push("paragraph"),b.push(c));a.namespaceURI!==k||"h"!==a.localName&&"p"!==a.localName||g("paragraph",k,a,b);return b}function d(a,b,c){var d=[],e,f,g,h;for(e=0;e<a.length;e+=2)g=a[e],h=a[e+1],g=p[g],h=g.getStyle(h),void 0!==h&&(h=h[b],void 0!==h&&h!==f&&(d.push(h),f=h));
g=p[c];if(h=g.getDefaultStyle())h=h[b],void 0!==h&&h!==f&&d.push(h);return d}function e(a,c){var d=s.getStyleName("text",a),f=a.parentElement;void 0!==d&&(c.push("text"),c.push(d));"span"===a.localName&&a.namespaceURI===k&&g("text",k,a,c);if(!f||f===h)return c;f.namespaceURI!==k||"p"!==f.localName&&"h"!==f.localName?e(f,c):b(f,c);return c}function l(a){a=a.getAttributeNS(t,"family");return p[a]}var f=this,p,q,m,r,c,a,n,k=odf.Namespaces.textns,t=odf.Namespaces.stylens,s=new odf.StyleInfo,y=new odf.StyleParseUtils,
z,w,v,u,C,A;this.getComputedGraphicStyle=function(a){var b=[];a=s.getStyleName("graphic",a);void 0!==a&&(b.push("graphic"),b.push(a));a=b.join("/");var c=r[a];runtime.assert(0===b.length%2,"Invalid style chain.");void 0===c&&(c=new odf.ComputedGraphicStyle,c.graphic.setGraphicProperties(d(b,"graphic","graphic")[0]),c.text.setStyleChain(d(b,"text","graphic")),c.paragraph.setStyleChain(d(b,"paragraph","graphic")),r[a]=c);return c};this.getComputedParagraphStyle=function(a){a=b(a,[]);var c=a.join("/"),
e=m[c];runtime.assert(0===a.length%2,"Invalid style chain.");void 0===e&&(e=new odf.ComputedParagraphStyle,e.text.setStyleChain(d(a,"text","paragraph")),e.paragraph.setStyleChain(d(a,"paragraph","paragraph")),m[c]=e);return e};this.getComputedTextStyle=function(a){a=e(a,[]);var b=a.join("/"),c=q[b];runtime.assert(0===a.length%2,"Invalid style chain.");void 0===c&&(c=new odf.ComputedTextStyle,c.text.setStyleChain(d(a,"text","text")),q[b]=c);return c};this.getPageLayout=function(a){var b=A[a];b||((b=
C[a])?(b=new odf.PageLayout(b,y,u),A[a]=b):b=u);return b};this.getDefaultPageLayout=function(){return u};this.getMasterPage=function(a){var b=w[a];void 0===b&&((b=z[a])?(b=new odf.MasterPage(b,f),w[a]=b):b=null);return b};this.getDefaultMasterPage=function(){return v};this.update=function(){var b,d,e=null,g=null;q={};m={};r={};z={};w={};A={};C={};c=new odf.StylePile(y,f);a=new odf.StylePile(y,f);n=new odf.StylePile(y,f);p={text:c,paragraph:a,graphic:n};for(b=h.styles.firstElementChild;b;)b.namespaceURI===
t&&((d=l(b))?"style"===b.localName?d.addCommonStyle(b):"default-style"===b.localName&&d.setDefaultStyle(b):"default-page-layout"===b.localName&&(e=b)),b=b.nextElementSibling;u=new odf.PageLayout(e,y);for(b=h.automaticStyles.firstElementChild;b;)b.namespaceURI===t&&((d=l(b))&&"style"===b.localName?d.addAutomaticStyle(b):"page-layout"===b.localName&&(C[b.getAttributeNS(t,"name")]=b)),b=b.nextElementSibling;for(b=h.masterStyles.firstElementChild;b;)b.namespaceURI===t&&"master-page"===b.localName&&(g=
g||b,d=b,e=d.getAttributeNS(t,"name"),0<e.length&&!z.hasOwnProperty(e)&&(z[e]=d)),b=b.nextElementSibling;v=new odf.MasterPage(g,f)}};
// Input 121
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
ops.OperationTransformMatrix=function(){function h(b){b.position+=b.length;b.length*=-1}function g(b){var a=0>b.length;a&&h(b);return a}function b(b,a){function d(f){b[f]===a&&e.push(f)}var e=[];b&&["style:parent-style-name","style:next-style-name"].forEach(d);return e}function d(b,a){function d(e){b[e]===a&&delete b[e]}b&&["style:parent-style-name","style:next-style-name"].forEach(d)}function e(b){var a={};Object.keys(b).forEach(function(d){a[d]="object"===typeof b[d]?e(b[d]):b[d]});return a}function l(b,
a,d,e){var f,g=!1,h=!1,l,m=[];e&&e.attributes&&(m=e.attributes.split(","));b&&(d||0<m.length)&&Object.keys(b).forEach(function(a){var e=b[a],f;"object"!==typeof e&&(d&&(f=d[a]),void 0!==f?(delete b[a],h=!0,f===e&&(delete d[a],g=!0)):-1!==m.indexOf(a)&&(delete b[a],h=!0))});if(a&&a.attributes&&(d||0<m.length)){l=a.attributes.split(",");for(e=0;e<l.length;e+=1)if(f=l[e],d&&void 0!==d[f]||m&&-1!==m.indexOf(f))l.splice(e,1),e-=1,h=!0;0<l.length?a.attributes=l.join(","):delete a.attributes}return{majorChanged:g,
minorChanged:h}}function f(b){for(var a in b)if(b.hasOwnProperty(a))return!0;return!1}function p(b){for(var a in b)if(b.hasOwnProperty(a)&&("attributes"!==a||0<b.attributes.length))return!0;return!1}function q(b,a,d,e,g){var h=b?b[g]:null,m=a?a[g]:null,q=d?d[g]:null,r=e?e[g]:null,v;v=l(h,m,q,r);h&&!f(h)&&delete b[g];m&&!p(m)&&delete a[g];q&&!f(q)&&delete d[g];r&&!p(r)&&delete e[g];return v}function m(b,a){return{opSpecsA:[b],opSpecsB:[a]}}var r;r={AddCursor:{AddCursor:m,AddMember:m,AddStyle:m,ApplyDirectStyling:m,
InsertText:m,MoveCursor:m,RemoveCursor:m,RemoveMember:m,RemoveStyle:m,RemoveText:m,SetParagraphStyle:m,SplitParagraph:m,UpdateMember:m,UpdateMetadata:m,UpdateParagraphStyle:m},AddMember:{AddStyle:m,InsertText:m,MoveCursor:m,RemoveCursor:m,RemoveStyle:m,RemoveText:m,SetParagraphStyle:m,SplitParagraph:m,UpdateMetadata:m,UpdateParagraphStyle:m},AddStyle:{AddStyle:m,ApplyDirectStyling:m,InsertText:m,MoveCursor:m,RemoveCursor:m,RemoveMember:m,RemoveStyle:function(c,a){var e,f=[c],g=[a];c.styleFamily===
a.styleFamily&&(e=b(c.setProperties,a.styleName),0<e.length&&(e={optype:"UpdateParagraphStyle",memberid:a.memberid,timestamp:a.timestamp,styleName:c.styleName,removedProperties:{attributes:e.join(",")}},g.unshift(e)),d(c.setProperties,a.styleName));return{opSpecsA:f,opSpecsB:g}},RemoveText:m,SetParagraphStyle:m,SplitParagraph:m,UpdateMember:m,UpdateMetadata:m,UpdateParagraphStyle:m},ApplyDirectStyling:{ApplyDirectStyling:function(b,a,d){var g,h,l,m,p,r,v,u;m=[b];l=[a];if(!(b.position+b.length<=a.position||
b.position>=a.position+a.length)){g=d?b:a;h=d?a:b;if(b.position!==a.position||b.length!==a.length)r=e(g),v=e(h);a=q(h.setProperties,null,g.setProperties,null,"style:text-properties");if(a.majorChanged||a.minorChanged)l=[],b=[],m=g.position+g.length,p=h.position+h.length,h.position<g.position?a.minorChanged&&(u=e(v),u.length=g.position-h.position,b.push(u),h.position=g.position,h.length=p-h.position):g.position<h.position&&a.majorChanged&&(u=e(r),u.length=h.position-g.position,l.push(u),g.position=
h.position,g.length=m-g.position),p>m?a.minorChanged&&(r=v,r.position=m,r.length=p-m,b.push(r),h.length=m-h.position):m>p&&a.majorChanged&&(r.position=p,r.length=m-p,l.push(r),g.length=p-g.position),g.setProperties&&f(g.setProperties)&&l.push(g),h.setProperties&&f(h.setProperties)&&b.push(h),d?(m=l,l=b):m=b}return{opSpecsA:m,opSpecsB:l}},InsertText:function(b,a){a.position<=b.position?b.position+=a.text.length:a.position<=b.position+b.length&&(b.length+=a.text.length);return{opSpecsA:[b],opSpecsB:[a]}},
MoveCursor:m,RemoveCursor:m,RemoveStyle:m,RemoveText:function(b,a){var d=b.position+b.length,e=a.position+a.length,f=[b],g=[a];e<=b.position?b.position-=a.length:a.position<d&&(b.position<a.position?b.length=e<d?b.length-a.length:a.position-b.position:(b.position=a.position,e<d?b.length=d-e:f=[]));return{opSpecsA:f,opSpecsB:g}},SetParagraphStyle:m,SplitParagraph:function(b,a){a.position<b.position?b.position+=1:a.position<b.position+b.length&&(b.length+=1);return{opSpecsA:[b],opSpecsB:[a]}},UpdateMetadata:m,
UpdateParagraphStyle:m},InsertText:{InsertText:function(b,a,d){b.position<a.position?a.position+=b.text.length:b.position>a.position?b.position+=a.text.length:d?a.position+=b.text.length:b.position+=a.text.length;return{opSpecsA:[b],opSpecsB:[a]}},MoveCursor:function(b,a){var d=g(a);b.position<a.position?a.position+=b.text.length:b.position<a.position+a.length&&(a.length+=b.text.length);d&&h(a);return{opSpecsA:[b],opSpecsB:[a]}},RemoveCursor:m,RemoveMember:m,RemoveStyle:m,RemoveText:function(b,a){var d;
d=a.position+a.length;var e=[b],f=[a];d<=b.position?b.position-=a.length:b.position<=a.position?a.position+=b.text.length:(a.length=b.position-a.position,d={optype:"RemoveText",memberid:a.memberid,timestamp:a.timestamp,position:b.position+b.text.length,length:d-b.position},f.unshift(d),b.position=a.position);return{opSpecsA:e,opSpecsB:f}},SplitParagraph:function(b,a){b.position<=a.position?a.position+=b.text.length:b.position+=1;return{opSpecsA:[b],opSpecsB:[a]}},UpdateMember:m,UpdateMetadata:m,UpdateParagraphStyle:m},
MoveCursor:{MoveCursor:m,RemoveCursor:function(b,a){return{opSpecsA:b.memberid===a.memberid?[]:[b],opSpecsB:[a]}},RemoveMember:m,RemoveStyle:m,RemoveText:function(b,a){var d=g(b),e=b.position+b.length,f=a.position+a.length;f<=b.position?b.position-=a.length:a.position<e&&(b.position<a.position?b.length=f<e?b.length-a.length:a.position-b.position:(b.position=a.position,b.length=f<e?e-f:0));d&&h(b);return{opSpecsA:[b],opSpecsB:[a]}},SetParagraphStyle:m,SplitParagraph:function(b,a){var d=g(b);a.position<
b.position?b.position+=1:a.position<b.position+b.length&&(b.length+=1);d&&h(b);return{opSpecsA:[b],opSpecsB:[a]}},UpdateMember:m,UpdateMetadata:m,UpdateParagraphStyle:m},RemoveCursor:{RemoveCursor:function(b,a){var d=b.memberid===a.memberid;return{opSpecsA:d?[]:[b],opSpecsB:d?[]:[a]}},RemoveMember:m,RemoveStyle:m,RemoveText:m,SetParagraphStyle:m,SplitParagraph:m,UpdateMember:m,UpdateMetadata:m,UpdateParagraphStyle:m},RemoveMember:{RemoveStyle:m,RemoveText:m,SetParagraphStyle:m,SplitParagraph:m,UpdateMetadata:m,
UpdateParagraphStyle:m},RemoveStyle:{RemoveStyle:function(b,a){var d=b.styleName===a.styleName&&b.styleFamily===a.styleFamily;return{opSpecsA:d?[]:[b],opSpecsB:d?[]:[a]}},RemoveText:m,SetParagraphStyle:function(b,a){var d,e=[b],f=[a];"paragraph"===b.styleFamily&&b.styleName===a.styleName&&(d={optype:"SetParagraphStyle",memberid:b.memberid,timestamp:b.timestamp,position:a.position,styleName:""},e.unshift(d),a.styleName="");return{opSpecsA:e,opSpecsB:f}},SplitParagraph:m,UpdateMember:m,UpdateMetadata:m,
UpdateParagraphStyle:function(c,a){var e,f=[c],g=[a];"paragraph"===c.styleFamily&&(e=b(a.setProperties,c.styleName),0<e.length&&(e={optype:"UpdateParagraphStyle",memberid:c.memberid,timestamp:c.timestamp,styleName:a.styleName,removedProperties:{attributes:e.join(",")}},f.unshift(e)),c.styleName===a.styleName?g=[]:d(a.setProperties,c.styleName));return{opSpecsA:f,opSpecsB:g}}},RemoveText:{RemoveText:function(b,a){var d=b.position+b.length,e=a.position+a.length,f=[b],g=[a];e<=b.position?b.position-=
a.length:d<=a.position?a.position-=b.length:a.position<d&&(b.position<a.position?(b.length=e<d?b.length-a.length:a.position-b.position,d<e?(a.position=b.position,a.length=e-d):g=[]):(d<e?a.length-=b.length:a.position<b.position?a.length=b.position-a.position:g=[],e<d?(b.position=a.position,b.length=d-e):f=[]));return{opSpecsA:f,opSpecsB:g}},SplitParagraph:function(b,a){var d=b.position+b.length,e=[b],f=[a];a.position<=b.position?b.position+=1:a.position<d&&(b.length=a.position-b.position,d={optype:"RemoveText",
memberid:b.memberid,timestamp:b.timestamp,position:a.position+1,length:d-a.position},e.unshift(d));b.position+b.length<=a.position?a.position-=b.length:b.position<a.position&&(a.position=b.position);return{opSpecsA:e,opSpecsB:f}},UpdateMember:m,UpdateMetadata:m,UpdateParagraphStyle:m},SetParagraphStyle:{UpdateMember:m,UpdateMetadata:m,UpdateParagraphStyle:m},SplitParagraph:{SplitParagraph:function(b,a,d){b.position<a.position?a.position+=1:b.position>a.position?b.position+=1:b.position===a.position&&
(d?a.position+=1:b.position+=1);return{opSpecsA:[b],opSpecsB:[a]}},UpdateMember:m,UpdateMetadata:m,UpdateParagraphStyle:m},UpdateMember:{UpdateMetadata:m,UpdateParagraphStyle:m},UpdateMetadata:{UpdateMetadata:function(b,a,d){var e,g=[b],h=[a];e=d?b:a;b=d?a:b;l(b.setProperties||null,b.removedProperties||null,e.setProperties||null,e.removedProperties||null);e.setProperties&&f(e.setProperties)||e.removedProperties&&p(e.removedProperties)||(d?g=[]:h=[]);b.setProperties&&f(b.setProperties)||b.removedProperties&&
p(b.removedProperties)||(d?h=[]:g=[]);return{opSpecsA:g,opSpecsB:h}},UpdateParagraphStyle:m},UpdateParagraphStyle:{UpdateParagraphStyle:function(b,a,d){var e,g=[b],h=[a];b.styleName===a.styleName&&(e=d?b:a,b=d?a:b,q(b.setProperties,b.removedProperties,e.setProperties,e.removedProperties,"style:paragraph-properties"),q(b.setProperties,b.removedProperties,e.setProperties,e.removedProperties,"style:text-properties"),l(b.setProperties||null,b.removedProperties||null,e.setProperties||null,e.removedProperties||
null),e.setProperties&&f(e.setProperties)||e.removedProperties&&p(e.removedProperties)||(d?g=[]:h=[]),b.setProperties&&f(b.setProperties)||b.removedProperties&&p(b.removedProperties)||(d?h=[]:g=[]));return{opSpecsA:g,opSpecsB:h}}}};this.passUnchanged=m;this.extendTransformations=function(b){Object.keys(b).forEach(function(a){var d=b[a],e,f=r.hasOwnProperty(a);runtime.log((f?"Extending":"Adding")+" map for optypeA: "+a);f||(r[a]={});e=r[a];Object.keys(d).forEach(function(b){var c=e.hasOwnProperty(b);
runtime.assert(a<=b,"Wrong order:"+a+", "+b);runtime.log("  "+(c?"Overwriting":"Adding")+" entry for optypeB: "+b);e[b]=d[b]})})};this.transformOpspecVsOpspec=function(b,a){var d=b.optype<=a.optype,e;runtime.log("Crosstransforming:");runtime.log(runtime.toJson(b));runtime.log(runtime.toJson(a));d||(e=b,b=a,a=e);(e=(e=r[b.optype])&&e[a.optype])?(e=e(b,a,!d),d||null===e||(e={opSpecsA:e.opSpecsB,opSpecsB:e.opSpecsA})):e=null;runtime.log("result:");e?(runtime.log(runtime.toJson(e.opSpecsA)),runtime.log(runtime.toJson(e.opSpecsB))):
runtime.log("null");return e}};
// Input 122
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
ops.OperationTransformer=function(){function h(b,d){for(var e,l,f=[],p=[];0<b.length&&d;){e=b.shift();e=g.transformOpspecVsOpspec(e,d);if(!e)return null;f=f.concat(e.opSpecsA);if(0===e.opSpecsB.length){f=f.concat(b);d=null;break}for(;1<e.opSpecsB.length;){l=h(b,e.opSpecsB.shift());if(!l)return null;p=p.concat(l.opSpecsB);b=l.opSpecsA}d=e.opSpecsB.pop()}d&&p.push(d);return{opSpecsA:f,opSpecsB:p}}var g=new ops.OperationTransformMatrix;this.getOperationTransformMatrix=function(){return g};this.transform=
function(b,d){for(var e,g=[];0<d.length;){e=h(b,d.shift());if(!e)return null;b=e.opSpecsA;g=g.concat(e.opSpecsB)}return{opSpecsA:b,opSpecsB:g}}};
// Input 123
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
ops.Server=function(){};ops.Server.prototype.connect=function(h,g){};ops.Server.prototype.networkStatus=function(){};ops.Server.prototype.login=function(h,g,b,d){};ops.Server.prototype.joinSession=function(h,g,b,d){};ops.Server.prototype.leaveSession=function(h,g,b,d){};ops.Server.prototype.getGenesisUrl=function(h){};
// Input 124
var webodf_css="@namespace draw url(urn:oasis:names:tc:opendocument:xmlns:drawing:1.0);\n@namespace fo url(urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0);\n@namespace office url(urn:oasis:names:tc:opendocument:xmlns:office:1.0);\n@namespace presentation url(urn:oasis:names:tc:opendocument:xmlns:presentation:1.0);\n@namespace style url(urn:oasis:names:tc:opendocument:xmlns:style:1.0);\n@namespace svg url(urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0);\n@namespace table url(urn:oasis:names:tc:opendocument:xmlns:table:1.0);\n@namespace text url(urn:oasis:names:tc:opendocument:xmlns:text:1.0);\n@namespace webodfhelper url(urn:webodf:names:helper);\n@namespace cursor url(urn:webodf:names:cursor);\n@namespace editinfo url(urn:webodf:names:editinfo);\n@namespace annotation url(urn:webodf:names:annotation);\n@namespace dc url(http://purl.org/dc/elements/1.1/);\n@namespace svgns url(http://www.w3.org/2000/svg);\n\noffice|document > *, office|document-content > * {\n  display: none;\n}\noffice|body, office|document {\n  display: inline-block;\n  position: relative;\n}\n\ntext|p, text|h {\n  display: block;\n  padding: 0;\n  margin: 0;\n  line-height: normal;\n  position: relative;\n  min-height: 1.3em; /* prevent empty paragraphs and headings from collapsing if they are empty */\n}\n*[webodfhelper|containsparagraphanchor] {\n  position: relative;\n}\ntext|s {\n    white-space: pre;\n}\ntext|tab {\n  display: inline;\n  white-space: pre;\n}\ntext|tracked-changes {\n  /*Consumers that do not support change tracking, should ignore changes.*/\n  display: none;\n}\noffice|binary-data {\n  display: none;\n}\noffice|text {\n  display: block;\n  text-align: left;\n  overflow: visible;\n  word-wrap: break-word;\n}\n\noffice|text::selection {\n  /** Let's not draw selection highlight that overflows into the office|text\n   * node when selecting content across several paragraphs\n   */\n  background: transparent;\n}\n\n.webodf-virtualSelections *::selection {\n  background: transparent;\n}\n.webodf-virtualSelections *::-moz-selection {\n  background: transparent;\n}\n\noffice|text * draw|text-box {\n/** only for text documents */\n    display: block;\n    border: 1px solid #d3d3d3;\n}\noffice|text draw|frame {\n  /** make sure frames are above the main text. */\n  z-index: 1;\n}\noffice|spreadsheet {\n  display: block;\n  border-collapse: collapse;\n  empty-cells: show;\n  font-family: sans-serif;\n  font-size: 10pt;\n  text-align: left;\n  page-break-inside: avoid;\n  overflow: hidden;\n}\noffice|presentation {\n  display: inline-block;\n  text-align: left;\n}\n#shadowContent {\n  display: inline-block;\n  text-align: left;\n}\ndraw|page {\n  display: block;\n  position: relative;\n  overflow: hidden;\n}\npresentation|notes, presentation|footer-decl, presentation|date-time-decl {\n    display: none;\n}\n@media print {\n  draw|page {\n    border: 1pt solid black;\n    page-break-inside: avoid;\n  }\n  presentation|notes {\n    /*TODO*/\n  }\n}\noffice|spreadsheet text|p {\n  border: 0px;\n  padding: 1px;\n  margin: 0px;\n}\noffice|spreadsheet table|table {\n  margin: 3px;\n}\noffice|spreadsheet table|table:after {\n  /* show sheet name the end of the sheet */\n  /*content: attr(table|name);*/ /* gives parsing error in opera */\n}\noffice|spreadsheet table|table-row {\n  counter-increment: row;\n}\noffice|spreadsheet table|table-row:before {\n  width: 3em;\n  background: #cccccc;\n  border: 1px solid black;\n  text-align: center;\n  content: counter(row);\n  display: table-cell;\n}\noffice|spreadsheet table|table-cell {\n  border: 1px solid #cccccc;\n}\ntable|table {\n  display: table;\n}\ndraw|frame table|table {\n  width: 100%;\n  height: 100%;\n  background: white;\n}\ntable|table-header-rows {\n  display: table-header-group;\n}\ntable|table-row {\n  display: table-row;\n}\ntable|table-column {\n  display: table-column;\n}\ntable|table-cell {\n  width: 0.889in;\n  display: table-cell;\n  word-break: break-all; /* prevent long words from extending out the table cell */\n}\ndraw|frame {\n  display: block;\n}\ndraw|image {\n  display: block;\n  width: 100%;\n  height: 100%;\n  top: 0px;\n  left: 0px;\n  background-repeat: no-repeat;\n  background-size: 100% 100%;\n  -moz-background-size: 100% 100%;\n  background-color: #CCC;\n}\n/* only show the first image in frame */\ndraw|frame > draw|image:nth-of-type(n+2) {\n  display: none;\n}\ntext|list:before {\n    display: none;\n    content:\"\";\n}\ntext|list {\n    display: block;\n    counter-reset: list;\n}\ntext|list-item {\n    display: block;\n}\ntext|number {\n    display:none;\n}\n\ntext|a {\n    color: blue;\n    text-decoration: underline;\n    cursor: pointer;\n}\n.webodf-inactiveLinks text|a {\n    cursor: text;\n}\ntext|note-citation {\n    vertical-align: super;\n    font-size: smaller;\n}\ntext|note-body {\n    display: none;\n}\ntext|note:hover text|note-citation {\n    background: #dddddd;\n}\ntext|note:hover text|note-body {\n    display: block;\n    left:1em;\n    max-width: 80%;\n    position: absolute;\n    background: #ffffaa;\n}\ntext|bibliography-source {\n  display: none;\n}\nsvg|title, svg|desc {\n    display: none;\n}\nvideo {\n    width: 100%;\n    height: 100%\n}\n\n/* below set up the cursor */\ncursor|anchor {\n    display: none;\n}\n\ncursor|cursor {\n    display: none;\n}\n\n.webodf-caretOverlay {\n    position: absolute;\n    top: 5%; /* push down the caret; 0px can do the job, 5% looks better, 10% is a bit over */\n    height: 1em;\n    margin-left: -1px;\n    z-index: 10;\n    pointer-events: none;\n}\n\n.webodf-caretOverlay .caret {\n    position: absolute;\n    border-left: 2px solid black;\n    top: 0;\n    bottom: 0;\n}\n\n.webodf-caretOverlay .handle {\n    margin-top: 5px;\n    padding-top: 3px;\n    margin-left: auto;\n    margin-right: auto;\n    width: 64px !important;\n    height: 68px !important;\n    border-radius: 5px;\n    opacity: 0.3;\n    text-align: center;\n    background-color: black !important;\n    box-shadow: 0px 0px 5px rgb(90, 90, 90);\n    border: 1px solid black;\n\n    top: -85px !important;\n    left: -32px !important;\n}\n\n.webodf-caretOverlay .handle > img {\n    box-shadow: 0px 0px 5px rgb(90, 90, 90) inset;\n    background-color: rgb(200, 200, 200);\n    border-radius: 5px;\n    border: 2px solid;\n    height: 60px !important;\n    width: 60px !important;\n    display: block;\n    margin: auto;\n}\n\n.webodf-caretOverlay .handle.active {\n    opacity: 0.8;\n}\n\n.webodf-caretOverlay .handle:after {\n    content: ' ';\n    position: absolute;\n    width: 0px;\n    height: 0px;\n    border-style: solid;\n    border-width: 8.7px 5px 0 5px;\n    border-color: black transparent transparent transparent;\n\n    top: 100%;\n    left: 43%;\n}\n\n.webodf-caretSizer {\n    display: inline-block; /* inline-block is necessary so the width can be set to 0 */\n    width: 0; /* the caret sizer shouldn't take up any horizontal space */\n    visibility: hidden; /* \"hidden\" means the client rects are still calculated, but the node content is not shown */\n}\n\n/** Input Method Editor input pane & behaviours */\n/* not within a cursor */\n#eventTrap {\n    height: auto;\n    display: block;\n    position: absolute;\n    bottom: 0;\n    right: 0;\n    width: 1px;\n    outline: none;\n    opacity: 0;\n    color: rgba(255, 255, 255, 0); /* hide the blinking caret by setting the colour to fully transparent */\n    overflow: hidden; /* The overflow visibility is used to hide and show characters being entered */\n    pointer-events: none;\n}\n\n/* within a cursor */\ncursor|cursor > #composer {\n    text-decoration: underline;\n}\n\ncursor|cursor[cursor|caret-sizer-active=\"true\"],\ncursor|cursor[cursor|composing=\"true\"] {\n    display: inline;\n}\n\neditinfo|editinfo {\n    /* Empty or invisible display:inline elements respond very badly to mouse selection.\n       Inline blocks are much more reliably selectable in Chrome & friends */\n    display: inline-block;\n}\n\n.editInfoMarker {\n    position: absolute;\n    width: 10px;\n    height: 100%;\n    left: -20px;\n    opacity: 0.8;\n    top: 0;\n    border-radius: 5px;\n    background-color: transparent;\n    box-shadow: 0px 0px 5px rgba(50, 50, 50, 0.75);\n}\n.editInfoMarker:hover {\n    box-shadow: 0px 0px 8px rgba(0, 0, 0, 1);\n}\n\n.editInfoHandle {\n    position: absolute;\n    background-color: black;\n    padding: 5px;\n    border-radius: 5px;\n    opacity: 0.8;\n    box-shadow: 0px 0px 5px rgba(50, 50, 50, 0.75);\n    bottom: 100%;\n    margin-bottom: 10px;\n    z-index: 3;\n    left: -25px;\n}\n.editInfoHandle:after {\n    content: ' ';\n    position: absolute;\n    width: 0px;\n    height: 0px;\n    border-style: solid;\n    border-width: 8.7px 5px 0 5px;\n    border-color: black transparent transparent transparent;\n\n    top: 100%;\n    left: 5px;\n}\n.editInfo {\n    font-family: sans-serif;\n    font-weight: normal;\n    font-style: normal;\n    text-decoration: none;\n    color: white;\n    width: 100%;\n    height: 12pt;\n}\n.editInfoColor {\n    float: left;\n    width: 10pt;\n    height: 10pt;\n    border: 1px solid white;\n}\n.editInfoAuthor {\n    float: left;\n    margin-left: 5pt;\n    font-size: 10pt;\n    text-align: left;\n    height: 12pt;\n    line-height: 12pt;\n}\n.editInfoTime {\n    float: right;\n    margin-left: 30pt;\n    font-size: 8pt;\n    font-style: italic;\n    color: yellow;\n    height: 12pt;\n    line-height: 12pt;\n}\n\n.annotationWrapper {\n    display: inline;\n    position: relative;\n}\n\n.annotationRemoveButton:before {\n    content: '\u00d7';\n    color: white;\n    padding: 5px;\n    line-height: 1em;\n}\n\n.annotationRemoveButton {\n    width: 20px;\n    height: 20px;\n    border-radius: 10px;\n    background-color: black;\n    box-shadow: 0px 0px 5px rgba(50, 50, 50, 0.75);\n    position: absolute;\n    top: -10px;\n    left: -10px;\n    z-index: 3;\n    text-align: center;\n    font-family: sans-serif;\n    font-style: normal;\n    font-weight: normal;\n    text-decoration: none;\n    font-size: 15px;\n}\n.annotationRemoveButton:hover {\n    cursor: pointer;\n    box-shadow: 0px 0px 5px rgba(0, 0, 0, 1);\n}\n\n.annotationNote {\n    width: 4cm;\n    position: absolute;\n    display: inline;\n    z-index: 10;\n    top: 0;\n}\n.annotationNote > office|annotation {\n    display: block;\n    text-align: left;\n}\n\n.annotationConnector {\n    position: absolute;\n    display: inline;\n    top: 0;\n    z-index: 2;\n    border-top: 1px dashed brown;\n}\n.annotationConnector.angular {\n    -moz-transform-origin: left top;\n    -webkit-transform-origin: left top;\n    -ms-transform-origin: left top;\n    transform-origin: left top;\n}\n.annotationConnector.horizontal {\n    left: 0;\n}\n.annotationConnector.horizontal:before {\n    content: '';\n    display: inline;\n    position: absolute;\n    width: 0px;\n    height: 0px;\n    border-style: solid;\n    border-width: 8.7px 5px 0 5px;\n    border-color: brown transparent transparent transparent;\n    top: -1px;\n    left: -5px;\n}\n\noffice|annotation {\n    width: 100%;\n    height: 100%;\n    display: none;\n    background: rgb(198, 238, 184);\n    background: -moz-linear-gradient(90deg, rgb(198, 238, 184) 30%, rgb(180, 196, 159) 100%);\n    background: -webkit-linear-gradient(90deg, rgb(198, 238, 184) 30%, rgb(180, 196, 159) 100%);\n    background: -o-linear-gradient(90deg, rgb(198, 238, 184) 30%, rgb(180, 196, 159) 100%);\n    background: -ms-linear-gradient(90deg, rgb(198, 238, 184) 30%, rgb(180, 196, 159) 100%);\n    background: linear-gradient(180deg, rgb(198, 238, 184) 30%, rgb(180, 196, 159) 100%);\n    box-shadow: 0 3px 4px -3px #ccc;\n}\n\noffice|annotation > dc|creator {\n    display: block;\n    font-size: 10pt;\n    font-weight: normal;\n    font-style: normal;\n    font-family: sans-serif;\n    color: white;\n    background-color: brown;\n    padding: 4px;\n}\noffice|annotation > dc|date {\n    display: block;\n    font-size: 10pt;\n    font-weight: normal;\n    font-style: normal;\n    font-family: sans-serif;\n    border: 4px solid transparent;\n    color: black;\n}\noffice|annotation > text|list {\n    display: block;\n    padding: 5px;\n}\n\n/* This is very temporary CSS. This must go once\n * we start bundling webodf-default ODF styles for annotations.\n */\noffice|annotation text|p {\n    font-size: 10pt;\n    color: black;\n    font-weight: normal;\n    font-style: normal;\n    text-decoration: none;\n    font-family: sans-serif;\n}\n\n#annotationsPane {\n    background-color: #EAEAEA;\n    width: 4cm;\n    height: 100%;\n    display: none;\n    position: absolute;\n    outline: 1px solid #ccc;\n}\n\n.webodf-annotationHighlight {\n    background-color: yellow;\n    position: relative;\n}\n\n.webodf-selectionOverlay {\n    position: absolute;\n    pointer-events: none;\n    top: 0;\n    left: 0;\n    top: 0;\n    left: 0;\n    width: 100%;\n    height: 100%;\n    z-index: 15;\n}\n.webodf-selectionOverlay > polygon {\n    fill-opacity: 0.3;\n    stroke-opacity: 0.8;\n    stroke-width: 1;\n    fill-rule: evenodd;\n}\n\n.webodf-selectionOverlay > .webodf-draggable {\n    fill-opacity: 0.8;\n    stroke-opacity: 0;\n    stroke-width: 8;\n    pointer-events: all;\n    display: none;\n\n    -moz-transform-origin: center center;\n    -webkit-transform-origin: center center;\n    -ms-transform-origin: center center;\n    transform-origin: center center;\n}\n\n#imageSelector {\n    display: none;\n    position: absolute;\n    border-style: solid;\n    border-color: black;\n}\n\n#imageSelector > div {\n    width: 5px;\n    height: 5px;\n    display: block;\n    position: absolute;\n    border: 1px solid black;\n    background-color: #ffffff;\n}\n\n#imageSelector > .topLeft {\n    top: -4px;\n    left: -4px;\n}\n\n#imageSelector > .topRight {\n    top: -4px;\n    right: -4px;\n}\n\n#imageSelector > .bottomRight {\n    right: -4px;\n    bottom: -4px;\n}\n\n#imageSelector > .bottomLeft {\n    bottom: -4px;\n    left: -4px;\n}\n\n#imageSelector > .topMiddle {\n    top: -4px;\n    left: 50%;\n    margin-left: -2.5px; /* half of the width defined in #imageSelector > div */\n}\n\n#imageSelector > .rightMiddle {\n    top: 50%;\n    right: -4px;\n    margin-top: -2.5px; /* half of the height defined in #imageSelector > div */\n}\n\n#imageSelector > .bottomMiddle {\n    bottom: -4px;\n    left: 50%;\n    margin-left: -2.5px; /* half of the width defined in #imageSelector > div */\n}\n\n#imageSelector > .leftMiddle {\n    top: 50%;\n    left: -4px;\n    margin-top: -2.5px; /* half of the height defined in #imageSelector > div */\n}\n\ndiv.webodf-customScrollbars::-webkit-scrollbar\n{\n    width: 8px;\n    height: 8px;\n    background-color: transparent;\n}\n\ndiv.webodf-customScrollbars::-webkit-scrollbar-track\n{\n    background-color: transparent;\n}\n\ndiv.webodf-customScrollbars::-webkit-scrollbar-thumb\n{\n    background-color: #444;\n    border-radius: 4px;\n}\n\n.webodf-hyperlinkTooltip {\n    display: none;\n    color: white;\n    background-color: black;\n    border-radius: 5px;\n    box-shadow: 2px 2px 5px gray;\n    padding: 3px;\n    position: absolute;\n    max-width: 210px;\n    text-align: left;\n    word-break: break-all;\n    z-index: 16;\n}\n\n.webodf-hyperlinkTooltipText {\n    display: block;\n    font-weight: bold;\n}\n";

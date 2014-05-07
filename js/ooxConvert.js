//// <summary>
//// An abstract base class for converting files according to Open Packaging Conventions standard
//// to a single XML stream.
//// This XML stream has the following form:
////     &lt;?xml version="1.0" encoding="utf-8" standalone="yes"?&gt;
////     &lt;oox:package xmlns:oox="urn:oox"&gt;
////         &lt;oox:part oox:name="_rels/.rels"&gt;
////             [content of package part _rels/.rels]
////         &lt;/oox:part&gt;
////         &lt;oox:part oox:name="docProps/app.xml" oox:type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties" oox:rId="rId3"&gt;
////             [content of package part docProps/app.xml]
////         &lt;/oox:part&gt;
////         &lt;oox:part oox:name="docProps/core.xml" oox:type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" oox:rId="rId2"&gt;
////             [content of package part docProps/core.xml]
////         &lt;/oox:part&gt;
////         &lt;oox:part oox:name="word/_rels/document.xml.rels"&gt;
////             [content of package part word/_rels/document.xml.rels]
////         &lt;/oox:part&gt;
////         &lt;oox:part oox:name="word/document.xml" oox:type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" oox:rId="rId1"&gt;  
////             [content of package part word/document.rels]
////         &lt;/oox:part&gt;
////     &lt;/oox:package>
//// </summary>
function analysisDocx(zipfiles) {
  var fileheader = '<?xml version="1.0"?><oox:package xmlns:oox="urn:oox">';
  var filefooter = '</oox:package>';
  var contentheader = '<oox:part oox:name="partname" oox:type="parttype">';
  var contentIdheader = '<oox:part oox:name="partname" oox:type="parttype" oox:rId="partrId">';
  var contentfooter = '</oox:part>';
  var Content_TypesXml = '[Content_Types].xml';
  var rels = '.rels';
  var _rels = '_rels';
  var xml = '.xml';
  var xmlfile = fileheader;
  var xmlGroup = [];

  if (!zipfiles[Content_TypesXml]) {
    return null;
  }
  var parser = new DOMParser();
  xmlDoc = parser.parseFromString(zipfiles[Content_TypesXml].asText(), "text/xml");
  var tempjson = {
    name: Content_TypesXml,
    type: xmlDoc.children[0].attributes.getNamedItem('xmlns').value,
	id: null
  };
  xmlGroup.push(tempjson);
  for (var i = 0; i < xmlDoc.children[0].children.length; i++) {
    var filename = xmlDoc.children[0].children[i].attributes.getNamedItem('PartName').value;
	if(filename.substring(filename.length-rels.length, filename.length) != rels) {
      continue;
    }
	if(filename.indexOf('/') == 0) {
	  filename = filename.substring(1, filename.length);
	}
	var relsparser = new DOMParser();
    var relsDoc = relsparser.parseFromString(zipfiles[filename].asText(), "text/xml");
    tempjson = {
      name: filename,
      type: relsDoc.children[0].attributes.getNamedItem('xmlns').value,
	  id: null
    };
	xmlGroup.push(tempjson);
	var path = filename.substring(0, filename.indexOf(_rels));
	for (var j = 0; j < relsDoc.children[0].children.length; j++) {
      var tempname = path + relsDoc.children[0].children[j].attributes.getNamedItem('Target').value;
      if (xml != tempname.substring(tempname.length - xml.length, tempname.length)) {
	    continue;
	  }
      tempjson = {
        name: tempname,
        type: relsDoc.children[0].children[j].attributes.getNamedItem('Type').value,
        id: relsDoc.children[0].children[j].attributes.getNamedItem('Id').value
      };
	  xmlGroup.push(tempjson);
    }
  }

  for (var i = 0; i < xmlGroup.length; i++) {
    var zipfile = zipfiles[xmlGroup[i].name];
    if (!zipfile._data) {
      continue;
    }
    var tempheader;
    if (!xmlGroup[i].id) {
      tempheader = contentheader.replace("partname", xmlGroup[i].name);
      tempheader = tempheader.replace("parttype", xmlGroup[i].type);
    } else {
      tempheader = contentIdheader.replace("partname", xmlGroup[i].name);
      tempheader = tempheader.replace("parttype", xmlGroup[i].type);
      tempheader = tempheader.replace("partrId", xmlGroup[i].id);
    }
    xmlfile = xmlfile + tempheader;
    parser = new DOMParser();
    xmlDoc = parser.parseFromString(zipfile.asText(), "text/xml");
    xmlfile = xmlfile + xmlDoc.children[0].outerHTML;
    xmlfile = xmlfile + contentfooter;
  }
  xmlfile = xmlfile + filefooter;
  return xmlfile;
}
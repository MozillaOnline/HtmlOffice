var xslDocxFile = './xsl/word/oox2odf/oox2odf.xsl';
var xslXlsxFile = './xsl/spreadsheet/oox2odf/oox2odf.xsl';
var xslPptxFile = './xsl/presentation/oox2odf/oox2odf.xsl';

String.prototype.format = function(args) {
  if (arguments.length > 0) {
    var result = this;
    if (arguments.length == 1 && typeof(args) == 'object') {
      for (var key in args) {
        var reg = new RegExp('({' + key + '})', 'g');
        result = result.replace(reg, args[key]);
      }
    } else {
      for (var i = 0; i < arguments.length; i++) {
        if (arguments[i] == undefined) {
          return '';
        } else {
          var reg = new RegExp('({[' + i + ']})', 'g');
          result = result.replace(reg, arguments[i]);
        }
      }
    }
    return result;
  } else {
    return this;
  }
}

function unique(data) {
  data = data || [];
  var a = {};
  for (var i = 0; i < data.length; i++) {
    var v = data[i];
    if (typeof(a[v]) == 'undefined') {
      a[v] = 1;
    }
  };
  data.length = 0;
  for (var i in a) {
    data[data.length] = i;
  }
  return data;
}

function NumbersToChars(num) {
  var letter = '';
  num--;
  if (num > 25) {
    var val2 = Math.floor(num / 26.0);
    letter = NumbersToChars(val2);
    num = num - val2 * 26;
  }
  return '' + letter + '' + ((char)(num + 65)) + '';
}

function GetColId(value) {
  var result = 0;
  var temp = value.split('');
  temp.forEach(function(c) {
    if (c >= 'A' && c <= 'Z') {
      result = (26 * result) + (c.charCodeAt(0) - 'A'.charCodeAt(0) + 1);
    }
  });
  return result;
}

function GetRowId(value) {
  var result = 0;
  var temp = value.split('');
  temp.forEach(function(c) {
    if (c >= '0' && c <= '9') {
      result = (10 * result) + (c.charCodeAt(0) - '0'.charCodeAt(0));
    }
  });
  return result;
}

function RegexReplace(input, pattern, replacement, ignoreCase, defaultValue) {
  var output;
  if (!RegExp.prototype.isPrototypeOf(pattern)) {
    output = input.replace(new RegExp(pattern, (ignoreCase == 'true' ? 'gi' : 'g')), replacement);
  } else {
    output = input.replace(pattern, replacement);
  }
  if (!output && defaultValue) {
    output = defaultValue;
  }
  return output;
}

/// <summary>
/// Formats a given date as an XSD dateTime string in the format CCYY-MM-DDThh:mm:ss
/// If the input value is an empty node-set the current date and time are returned
/// </summary>
function FormatDateTime(dateTime) {
  var output;
  output = new Date(dateTime).format('yyyy-MM-dd HH:mm:ss');
  if (!output) {
    output = new Date().format('yyyy-MM-ddTHH:mm:ss');
  }
  return output;
}

/// <summary>
/// Formats a given date as an XSD dateTime string in the format CCYY-MM-DDThh:mm:ss
/// If the date string cannot be parsed an empty string is returned
/// </summary>
function XsdDateTimeFromField(fieldInstruction, fieldValue) {
  var output;
  // parse the date format from the field code
  //    date-and-time-formatting-switch:
  //       \@ [ " ] switch-argument [ " ]
  var dateFormat = RegexReplace(fieldInstruction, '\\\\@ *(?:\"(.*)\"|([^ ]*))', '$1$2', true);
  // 'AM/PM' in Word needs to be replaced by 'tt' in .NET
  dateFormat = RegexReplace(dateFormat, '(.*)AM/PM(.*)', '$1tt$2', true);
  // remove other noise from the pattern
  dateFormat = dateFormat.replace('\'', '');
  output = new Date(dateFormat).format('yyyy-MM-dd HH:mm:ss');
  return output;
}

function RegexReplaceCmFromMeasuredUnit(input, pattern, replacement, ignoreCase, defaultValue) {
  var output;
  var MeasuredUnit = RegexReplace(input, pattern, replacement, ignoreCase, defaultValue);
  var value = 0;
  var factor = 1.0;
  var regexp = new RegExp('\s*([-.0-9]+)\s*([a-zA-Z]*)\s*');
  var groups = MeasuredUnit.match(regexp);
  if (groups && groups.length == 3) {
    var strValue = groups[1];
    var strUnit = groups[2];
    switch (strUnit) {
      case 'cm':
        factor = 1.0;
        break;
      case 'mm':
        factor = 0.1;
        break;
      case 'in':
      case 'inch':
        factor = 2.54;
        break;
      case 'pt':
        factor = 2.54 / 72.0;
        break;
      case 'twip':
        factor = 2.54 / 1440;
        break;
      case 'pica':
        factor = 2.54 / 6.0;
        break;
      case 'dpt':
        factor = 2.54 / 72.0;
        break;
      case 'px':
        factor = 2.54 / 96.0;
        break;
      default:
        factor = 2.54 / 1440;
        break;
    }
    value = parseInt(strValue) * factor;
  }
  output = value + 'cm';
  return output;
}

/// <summary>
/// Removes all invalid characters from a style name and - if the name is not yet unique - 
/// appends a counter to make the name unique
/// </summary>
var _name2ncname = [];
var _ncname2name = [];

function NCNameFromString(name) {
  var output;
  var ncname;
  // see http://www.w3.org/TR/REC-xml-names/#NT-NCName for allowed characters in NCName
  var _invalidLettersAtStart = new RegExp('^([^\\w+_])(.*)', 'g'); // valid start chars are \p{Ll}\p{Lu}\p{Lo}\p{Lt}\p{Nl}_
  var _invalidChars = new RegExp('[^_\\w+]', 'g');
  if (_name2ncname.indexOf(name) >= 0) {
    ncname = _name2ncname[_name2ncname.indexOf(name)];
  } else {
    // escape invalid characters
    ncname = name;
    var invalidCharsMatch = ncname.match(_invalidChars);
    var template1 = '_{0}_';
    var template2 = '_{0}_{1}';
    var template3 = '{0}_{1}';
    if (invalidCharsMatch && invalidCharsMatch.length > 0) {
      invalidCharsMatch.forEach(function(invalidCharCapture) {
        ncname = ncname.replace(invalidCharCapture, template1.format(parseInt(invalidCharCapture.charCodeAt(0), 10).toString(16)));
      });
    }

    // escape invalid start character
    var firstChar = ncname.match(_invalidLettersAtStart);
    if (firstChar && firstChar.length > 0) {
      ncname = template2.format(parseInt(firstChar[0].charCodeAt(0), 10).toString(16), firstChar[1]);
    }
    // create new unique ncname
    var counter = 0;
    var uniqueName = ncname;
    while (_ncname2name.indexOf(uniqueName) >= 0) {
      uniqueName = template3.format(ncname, counter);
      counter++;
    }
    ncname = uniqueName;
    _ncname2name.push(ncname, name);
    _name2ncname.push(name, ncname);
  }
  output = ncname;
  return output;
}

function linkFuncFromString(vals) {
  var output = '';
  switch (vals[0]) {
    case 'RegexReplace':
      if (vals.length > 5) {
        output = RegexReplace(vals[1], vals[2], vals[3], vals[4], vals[5]);
      } else {
        output = RegexReplace(vals[1], vals[2], vals[3], vals[4]);
      }
      break;
    case 'FormatDateTime':
      output = FormatDateTime(vals[1]);
      break;
    case 'XsdDateTimeFromField':
      output = XsdDateTimeFromField(vals[1], vals[2]);
      break;
    case 'UriFromPath':
      output = encodeURI(vals[1]);
      break;
    case 'NCNameFromString':
      output = NCNameFromString(vals[1]);
      break;
    case 'RegexReplaceCmFromMeasuredUnit':
      if (vals.length > 5) {
        output = RegexReplaceCmFromMeasuredUnit(vals[1], vals[2], vals[3], vals[4], vals[5]);
      } else {
        output = RegexReplaceCmFromMeasuredUnit(vals[1], vals[2], vals[3], vals[4]);
      }
      break;
    case 'NumbersToChars':
      output = NumbersToChars(vals[1]);
      break;
    default:
      break;
  }
  return output;
}

function unzipFile(file, callback) {
  var reader = new FileReader();
  reader.onload = function(aEvent) {
    var zipfile = btoa(aEvent.target.result);
    var zip = JSZip();
    zip.load(zipfile, {
      base64: true
    });
    callback(zip);
  }
  reader.readAsBinaryString(file);
}

function zipFile(sourcePzip, sourceFiles) {
  var pzipElementHeader = '<pzip:';
  var elementFooter = '>';
  var sourceAttrHeader = 'pzip:source="';
  var targetAttrHeader = 'pzip:target="';
  var namespaceHeader = 'xmlns:';
  var attrFooter = '"';

  var zip = new JSZip();
  var parser = new DOMParser();
  var xmlDoc = parser.parseFromString(sourcePzip, 'text/xml');
  for (var i = 0; i < xmlDoc.children[0].children.length; i++) {
    var xmlfilepath = xmlDoc.children[0].children[i].attributes.getNamedItem('pzip:target');
    if (!xmlfilepath) {
      continue;
    }
    xmlfilepath = xmlfilepath.value;
    var xmlfilecontent = xmlDoc.children[0].children[i].attributes.getNamedItem('pzip:content');
    if (!xmlfilecontent) {
      xmlfilecontent = xmlDoc.children[0].children[i].innerHTML;
      var startIndex = 0;
      var start = xmlfilecontent.indexOf(pzipElementHeader, startIndex);
      startIndex = start;
      var end = xmlfilecontent.indexOf(elementFooter, start);
      while (start >= 0 && end > start) {
        var temppzip = xmlfilecontent.substring(start, end + elementFooter.length);
        xmlfilecontent = xmlfilecontent.replace(temppzip, '');
        start = xmlfilecontent.indexOf(pzipElementHeader, startIndex);
        end = xmlfilecontent.indexOf(elementFooter, start);
        startIndex = start;
        var sourceIndex = temppzip.indexOf(sourceAttrHeader, 0) + sourceAttrHeader.length;
        var sourceEnd = temppzip.indexOf(attrFooter, sourceIndex);
        var targetIndex = temppzip.indexOf(targetAttrHeader, 0) + targetAttrHeader.length;
        var targetEnd = temppzip.indexOf(attrFooter, targetIndex);
        var temppzipsource = temppzip.substring(sourceIndex, sourceEnd);
        var temppziptarget = temppzip.substring(targetIndex, targetEnd);
        if (sourceFiles[temppzipsource]) {
          zip.file(temppziptarget, sourceFiles[temppzipsource].asUint8Array());
        }
      }

      startIndex = 0;
      start = xmlfilecontent.indexOf(namespaceHeader, startIndex);
      startIndex = start;
      end = xmlfilecontent.indexOf(attrFooter, start);
      end = xmlfilecontent.indexOf(attrFooter, end + attrFooter.length);
      var xmlns = [];
      while (start >= 0 && end > start) {
        var tempxmlns = xmlfilecontent.substring(start, end + attrFooter.length);
        if (xmlns.length > 0) {
          xmlfilecontent = xmlfilecontent.replace(tempxmlns, '');
          if (xmlns.indexOf(tempxmlns) < 0) {
            xmlns.push(tempxmlns);
          }
        } else {
          startIndex = startIndex + tempxmlns.length;
          xmlns.push(tempxmlns);
        }
        start = xmlfilecontent.indexOf(namespaceHeader, startIndex);
        end = xmlfilecontent.indexOf(attrFooter, start);
        end = xmlfilecontent.indexOf(attrFooter, end + attrFooter.length);
        startIndex = start;
      }
      if (xmlns.length > 1) {
        var tempxmlns = unique(xmlns);
        xmlfilecontent = xmlfilecontent.replace(xmlns[0], tempxmlns.join(' '));
      }
    } else {
      xmlfilecontent = xmlfilecontent.value;
    }
    zip.file(xmlfilepath, xmlfilecontent);
  }
  zip.remove('tempfile');
  var zipfile = zip.generate({
    base64: false,
    type: 'blob'
  });
  return zipfile;
}

var idSheet = 0;
var idRow = 1;
var idFont = 0;
var idaFont = 0;
var idFill = 0;
var idBorder = 0;
var idXf = 0;
var idCellStyle = 0;
var idDxf = 0;
var idSi = 0;
var idCf = 0;
var _partId = 0;
var ptitle = 'oox:p';
var idtitle = 'oox:id';
var parttitle = 'oox:part';
var ConditionalInheritancetitle = 'oox:ConditionalInheritance';
var SPREADSHEET_ML_NS = 'http://schemas.openxmlformats.org/spreadsheetml/2006/main';

function JXONTree(oXMLParent) {
  var nAttrLen = 0, nLength = 0, sCollectedTxt = '';
  if (oXMLParent.hasChildNodes()) {
    for (var oNode, nItem = 0; nItem < oXMLParent.childNodes.length; nItem++) {
      oNode = oXMLParent.childNodes.item(nItem);
      if (oNode.nodeType === 1) {
        JXONTree(oNode);
      }
    }
  }
  if (oXMLParent.hasAttributes()) {
    var oAttrib;
    var s;
    for (nAttrLen; nAttrLen < oXMLParent.attributes.length; nAttrLen++) {
      oAttrib = oXMLParent.attributes.item(nAttrLen);
      switch (oAttrib.name.toLowerCase()) {
        case 'r':
          if (oXMLParent.nodeName.toLowerCase() == 'c' && oXMLParent.namespaceURI == SPREADSHEET_ML_NS) {
            oXMLParent.setAttribute(ptitle, GetColId(oAttrib.value) + '|' + GetRowId(oAttrib.value));
          }
          break;
        case 's':
          s = oAttrib.value;
          break;
        default:
          break;
      }
    }
  }

  switch (oXMLParent.nodeName) {
    case 'oox:part':
      _partId++;
      break;
    case 'sheets':
      idSheet = 0;
      break;
    case 'sheetData':
      idRow = 1;
      break;
    case 'fonts':
      idFont = 0;
      break;
    case 'fills':
      idFill = 0;
      break;
    case 'borders':
      idBorder = 0;
      break;
    case 'cellXfs':
    case 'cellStyleXfs':
      idXf = 0;
      break;
    case 'cellStyles':
      idCellStyle = 0;
      break;
    case 'dxfs':
      idDxf = 0;
      break;
    case 'sst':
      idSi = 0;
      break;
    // add id values
    case 'sheet':
      oXMLParent.setAttribute(idtitle, (idSheet++).toString());
      break;
    case 'row':
      oXMLParent.setAttribute(idtitle, (idRow++).toString());
      break;
    case 'font':
      oXMLParent.setAttribute(idtitle, (idFont++).toString());
      break;
    case 'fill':
      oXMLParent.setAttribute(idtitle, (idFill++).toString());
      break;
    case 'border':
      oXMLParent.setAttribute(idtitle, (idBorder++).toString());
      break;
    case 'xf':
      oXMLParent.setAttribute(idtitle, (idXf++).toString());
      break;
    case 'cellStyle':
      oXMLParent.setAttribute(idtitle, (idCellStyle++).toString());
      break;
    case 'dxf':
      oXMLParent.setAttribute(idtitle, (idDxf++).toString());
      break;
    case 'si':
      // sharedStrings
      oXMLParent.setAttribute(idtitle, (idSi++).toString());
      break;
    case 'worksheet':
    case 'chartSpace':
      oXMLParent.setAttribute(parttitle, _partId.toString());
      break;
    case 'conditionalFormatting':
      oXMLParent.setAttribute(parttitle, _partId.toString());
      oXMLParent.setAttribute(idtitle, (idCf++).toString());
      oXMLParent.setAttribute(ConditionalInheritancetitle, (idCf++).toString());
      break;
    case 'col':
    case 'sheetFormatPr':
    case 'mergeCell':
    case 'drawing':
    case 'hyperlink':
    case 'ser':
    case 'val':
    case 'xVal':
    case 'cat':
    case 'plotArea':
    case 'grouping':
    case 'spPr':
    case 'errBars':
      oXMLParent.setAttribute(parttitle, _partId.toString());
      break;
    case "a:font":
      oXMLParent.setAttribute(idtitle, (idaFont++).toString());
      break;
    default:
      break;
  }
  return;
}

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
var Content_TypesXml = '[Content_Types].xml';
var rels = '.rels';
var _rels = '_rels';
var xml = '.xml';
var updir = '../';

function generateOdfxml(zipfiles, xmlGroup, fileType) {
  var fileheader = '<?xml version="1.0" encoding="utf-8" standalone="yes"?><oox:package xmlns:oox="urn:oox">';
  var filefooter = '</oox:package>';
  var contentheader = '<oox:part oox:name="partname" oox:type="parttype">';
  var contentIdheader = '<oox:part oox:name="partname" oox:type="parttype" oox:rId="partrId">';
  var contentfooter = '</oox:part>';
  if (fileType == 'pptx') {
    fileheader = '<?xml version="1.0" encoding="utf-8" standalone="yes"?><oox:source xmlns:oox="urn:oox">';
    filefooter = '</oox:source>';
  }
  var xmlfile = fileheader;
  for (var i = 0; i < xmlGroup.length; i++) {
    var zipfile = zipfiles[xmlGroup[i].name];
    if (!zipfile || !zipfile._data) {
      continue;
    }
    var tempheader;
    tempheader = contentheader.replace('partname', xmlGroup[i].name);
    tempheader = tempheader.replace('parttype', xmlGroup[i].type);
    if (xmlGroup[i].id) {
      tempheader = tempheader.replace('partrId', xmlGroup[i].id);
    }
    xmlfile = xmlfile + tempheader;
    var parser = new DOMParser();
    var xmlDoc = parser.parseFromString(zipfile.asText(), 'text/xml');
    xmlfile = xmlfile + xmlDoc.children[0].outerHTML;
    xmlfile = xmlfile + contentfooter;
  }
  xmlfile = xmlfile + filefooter;
  return xmlfile;
}

var pxsi = {};

function transformXlsx(oXMLParent) {
  var nAttrLen = 0, nLength = 0, sCollectedTxt = '';
  if (!oXMLParent.hasChildNodes()) {
    return;
  }
  for (var oNode, nItem = 0; nItem < oXMLParent.childNodes.length; nItem++) {
    oNode = oXMLParent.childNodes.item(nItem);
    if (oNode.nodeName == 'pxsi:v') {
      var num = oNode.innerHTML;
      oXMLParent.removeChild(oNode);
      oXMLParent.innerHTML = pxsi[num];
      nItem--;
    } else {
      if (oNode.nodeName == 'pxsi:si') {
        var numberAttr = oNode.getAttribute('pxsi:number');
        pxsi[numberAttr] = oNode.innerHTML;
      }
      if (oNode.nodeType === 1) {
        transformXlsx(oNode);
      }
      if (oNode.nodeName == 'pxsi:sst') {
        oXMLParent.removeChild(oNode);
        nItem--;
      }
    }
  }
}

/*
 * Convert the xml format from docx/xslx/pptx to odt/ods/odp
 */
function xslTransform(xmlFile, fileType) {
  var xslFile;
  switch (fileType) {
    case 'docx':
      xslFile = xslDocxFile;
      break;
    case 'xlsx':
      xslFile = xslXlsxFile;
      break;
    case 'pptx':
      xslFile = xslPptxFile;
      break;
  }
  if (!xmlFile || !xslFile) {
    return null;
  }

  var xslStylesheet;
  var xsltProcessor = new XSLTProcessor();
  var ooxXMLHTTPRequest = new XMLHttpRequest();
  ooxXMLHTTPRequest.open('GET', xslFile, false);
  ooxXMLHTTPRequest.send(null);
  xslStylesheet = ooxXMLHTTPRequest.responseXML;
  xsltProcessor.importStylesheet(xslStylesheet);

  var parser = new DOMParser();
  var xmlDoc = parser.parseFromString(xmlFile, 'text/xml');
  var newDocument = xsltProcessor.transformToDocument(xmlDoc);
  if (!newDocument.childNodes || newDocument.childNodes.length == 0) {
    return null;
  }
  
/*
* Convert ooc-function-oop-attr1-oop-attr2...-ooe to vals['function', 'attr1', 'attr2'...]
*/
  var startString = 'ooc-';
  var endString = '-ooe';
  var attrString = '-oop-';
  var xmlString = newDocument.childNodes[0].outerHTML;
  var startIndex = 0;
  var start = xmlString.indexOf(startString, startIndex);
  startIndex = start;
  var end = xmlString.indexOf(endString, start);
  while (start >= 0 && end > start) {
    var tempfuncstring = xmlString.substring(start, end + endString.length);
    var multiooc = tempfuncstring.indexOf(startString, startString.length);
    while (multiooc >= 0) {
      tempfuncstring = tempfuncstring.substring(multiooc, tempfuncstring.length);
      multiooc = tempfuncstring.indexOf(startString, startString.length);
    }
    var funcString = tempfuncstring;
    tempfuncstring = tempfuncstring.substring(startString.length, funcString.length - endString.length);
    var vals = tempfuncstring.split(attrString);
    var retString = linkFuncFromString(vals);
    xmlString = xmlString.replace(funcString, retString);
    start = xmlString.indexOf(startString, startIndex);
    end = xmlString.indexOf(endString, start);
    startIndex = start;
  }
  if (fileType == 'xlsx') {
    var parser = new DOMParser();
    var oXMLParent = parser.parseFromString(xmlString, "text/xml");
    transformXlsx(oXMLParent);
    xmlString = oXMLParent.children[0].outerHTML;
  }
  return xmlString;
}

function analysisOox(xmlFile, fileType) {
  var xmlGroup = [];
  if (!zipfiles[Content_TypesXml]) {
    return null;
  }
  var parser = new DOMParser();
  var xmlDoc = parser.parseFromString(zipfiles[Content_TypesXml].asText(), 'text/xml');
  var tempjson = {
    name: Content_TypesXml,
    type: xmlDoc.children[0].attributes.getNamedItem('xmlns').value,
    id: null
  };
  xmlGroup.push(tempjson);
  for (var filename in zipfiles) {
    if (filename.substring(filename.length - rels.length, filename.length) != rels) {
      continue;
    }
    var relsparser = new DOMParser();
    var relsDoc = relsparser.parseFromString(zipfiles[filename].asText(), 'text/xml');
    tempjson = {
      name: filename,
      type: relsDoc.children[0].attributes.getNamedItem('xmlns').value,
      id: null
    };
    xmlGroup.push(tempjson);
    var path = filename.substring(0, filename.indexOf(_rels));
    for (var i = 0; i < relsDoc.children[0].children.length; i++) {
      var tempname = relsDoc.children[0].children[i].attributes.getNamedItem('Target').value;
      if (xml != tempname.substring(tempname.length - xml.length, tempname.length)) {
        continue;
      }
      if (tempname.indexOf(updir) == 0) {
        var temppath = path.split('/');
        temppath.splice(temppath.length - 2, 1);
        tempname = temppath.join('/') + tempname.substring(updir.length, tempname.length);
      } else {
        tempname = path + tempname;
      }
      tempjson = {
        name: tempname,
        type: relsDoc.children[0].children[i].attributes.getNamedItem('Type').value,
        id: relsDoc.children[0].children[i].attributes.getNamedItem('Id').value
      };
      xmlGroup.push(tempjson);
    }
  }
  var xmlfile = generateOdfxml(zipfiles, xmlGroup);
  if (fileType == 'xlsx') {
    parser = new DOMParser();
    xmlDoc = parser.parseFromString(xmlfile, 'text/xml');
    JXONTree(xmlDoc);
    xmlfile = xmlDoc.children[0].outerHTML;
  }
  return xmlfile;
}

function convertoox2odf(ooxFile, callback) {
  _name2ncname = [];
  _ncname2name = [];
  pxsi = {};

  var docx = 'docx';
  var xlsx = 'xlsx';
  var pptx = 'pptx';
  unzipFile(ooxFile, function(zip) {
    var fileType = ooxFile.name.substring(ooxFile.name.length - docx.length, ooxFile.name.length);
    var xmlfile;
    switch (fileType) {
    case docx:
    case xlsx:
      xmlfile = analysisOox(zip.files, fileType);
      break;
    case pptx:
      xmlfile = analysisPptx(zip.files);
      break;
    default:
      callback(null);
      return;
    }
    if (xmlfile) {
      var sourcePzip = xslTransform(xmlfile, fileType);
      if (sourcePzip) {
        xmlfile = zipFile(sourcePzip, zip.files);
      } else {
        xmlfile = '';
      }
    }
    callback(xmlfile);
    return;
  });
}
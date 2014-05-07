var _name2ncname = [];
var _ncname2name = [];

String.prototype.format = function(args) {
  if (arguments.length > 0) {
    var result = this;
    if (arguments.length == 1 && typeof(args) == "object") {
      for (var key in args) {
        var reg = new RegExp("({" + key + "})", "g");
        result = result.replace(reg, args[key]);
      }
    } else {
      for (var i = 0; i < arguments.length; i++) {
        if (arguments[i] == undefined) {
          return "";
        } else {
          var reg = new RegExp("({[" + i + "]})", "g");
          result = result.replace(reg, arguments[i]);
        }
      }
    }
    return result;
  } else {
    return this;
  }
}

function RegexReplace(input, pattern, replacement, ignoreCase, defaultValue) {
  var output;
  if (!RegExp.prototype.isPrototypeOf(pattern)) {
    output = input.replace(new RegExp(pattern, (ignoreCase == 'true' ? "gi" : "g")), replacement);
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
  output = new Date(dateTime).format("yyyy-MM-dd HH:mm:ss");
  if (!output) {
    output = new Date().format("yyyy-MM-ddTHH:mm:ss");
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
  var dateFormat = RegexReplace(fieldInstruction, "\\\\@ *(?:\"(.*)\"|([^ ]*))", "$1$2", true);
  // 'AM/PM' in Word needs to be replaced by 'tt' in .NET
  dateFormat = RegexReplace(dateFormat, "(.*)AM/PM(.*)", "$1tt$2", true);
  // remove other noise from the pattern
  dateFormat = dateFormat.replace("'", "");
  output = new Date(dateFormat).format("yyyy-MM-dd HH:mm:ss");
  return output;
}

function RegexReplaceCmFromMeasuredUnit(input, pattern, replacement, ignoreCase, defaultValue) {
  var output;
  var MeasuredUnit = RegexReplace(input, pattern, replacement, ignoreCase, defaultValue);
  var value = 0;
  var factor = 1.0;
  var regexp = new RegExp("\s*([-.0-9]+)\s*([a-zA-Z]*)\s*");
  var groups = MeasuredUnit.match(regexp);
  if (groups && groups.length == 3) {
    var strValue = groups[1];
    var strUnit = groups[2];
    switch (strUnit) {
    case "cm":
      factor = 1.0;
      break;
    case "mm":
      factor = 0.1;
      break;
    case "in":
    case "inch":
      factor = 2.54;
      break;
    case "pt":
      factor = 2.54 / 72.0;
      break;
    case "twip":
      factor = 2.54 / 1440;
      break;
    case "pica":
      factor = 2.54 / 6.0;
      break;
    case "dpt":
      factor = 2.54 / 72.0;
      break;
    case "px":
      factor = 2.54 / 96.0;
      break;
    default:
      factor = 2.54 / 1440;
      break;
    }
    value = parseInt(strValue) * factor;
  }
  output = value + "cm";
  return output;
}

/// <summary>
/// Removes all invalid characters from a style name and - if the name is not yet unique - 
/// appends a counter to make the name unique
/// </summary>
function NCNameFromString(name) {
  var output;
  var ncname;
  // see http://www.w3.org/TR/REC-xml-names/#NT-NCName for allowed characters in NCName
  var _invalidLettersAtStart = new RegExp("^([^\\w+_])(.*)", 'g'); // valid start chars are \p{Ll}\p{Lu}\p{Lo}\p{Lt}\p{Nl}_
  var _invalidChars = new RegExp("[^_\\w+]", 'g');
  if (_name2ncname.indexOf(name) >= 0) {
    ncname = _name2ncname[_name2ncname.indexOf(name)];
  } else {
    // escape invalid characters
    ncname = name;
    var invalidCharsMatch = ncname.match(_invalidChars);
    var template1 = "_{0}_";
    var template2 = "_{0}_{1}";
    var template3 = "{0}_{1}";
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
  var xmlDoc = parser.parseFromString(sourcePzip, "text/xml");
  for (var i = 0; i < xmlDoc.children[0].children.length; i++) {
    var xmlfilepath = xmlDoc.children[0].children[i].attributes.getNamedItem('pzip:target').value;
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
        zip.file(temppziptarget, sourceFiles[temppzipsource].asUint8Array());
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
          xmlns.push(tempxmlns);
        } else {
          startIndex = startIndex + namespaceHeader.length;
        }
        start = xmlfilecontent.indexOf(namespaceHeader, startIndex);
        end = xmlfilecontent.indexOf(attrFooter, start);
        end = xmlfilecontent.indexOf(attrFooter, end + attrFooter.length);
        startIndex = start;
      }
	  if (xmlns.length > 1) {
        xmlfilecontent = xmlfilecontent.replace(xmlns[0], xmlns.join(' '));
      }
    } else {
      xmlfilecontent = xmlfilecontent.value;
    }		
    zip.file(xmlfilepath, xmlfilecontent);
  }
  zip.remove("tempfile");
  var zipfile = zip.generate({
    base64: false,
    type: "String"
  });
  return zipfile;
}

/*
 * Convert the xml format from docx/xslx/pptx to odt/ods/odp
 */
function xslTransform(xmlFile, xslFile) {
  if (!xmlFile) {
    return null;
  }
  if (!xslFile) {
    return xmlFile;
  }

  var xslStylesheet;
  var xsltProcessor = new XSLTProcessor();
  var ooxXMLHTTPRequest = new XMLHttpRequest();
  ooxXMLHTTPRequest.open("GET", xslFile, false);
  ooxXMLHTTPRequest.send(null);
  xslStylesheet = ooxXMLHTTPRequest.responseXML;
  xsltProcessor.importStylesheet(xslStylesheet);

  var parser = new DOMParser();
  var xmlDoc = parser.parseFromString(xmlFile, "text/xml");
  var ownerDocument = document.implementation.createDocument("", "test", null);
  var fragment = xsltProcessor.transformToFragment(xmlDoc, ownerDocument);

  /*
  * Convert ooc-function-oop-attr1-oop-attr2...-ooe to vals['function', 'attr1', 'attr2'...]
  */
  var startString = 'ooc-';
  var endString = '-ooe';
  var attrString = '-oop-';
  var xmlString = fragment.childNodes[0].outerHTML;
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
  return xmlString;
}

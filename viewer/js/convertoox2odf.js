var xslDocxFile = 'xsl/word/oox2odf/oox2odf.xsl';
var xslXlsxFile = 'xsl/spreadsheet/oox2odf/oox2odf.xsl';
var xslPptxFile = 'xsl/presentation/oox2odf/oox2odf.xsl';

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

Date.prototype.format = function(fmt) {
  var o = {
    "M+": this.getMonth() + 1,
    "d+": this.getDate(),
    "h+": this.getHours(),
    "m+": this.getMinutes(),
    "s+": this.getSeconds(),
    "q+": Math.floor((this.getMonth() + 3) / 3),
    "S": this.getMilliseconds()
  };
  if (/(y+)/.test(fmt)) {
    fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
  }
  for (var k in o) {
    if (new RegExp("(" + k + ")").test(fmt)) {
      fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    }
  }
  return fmt;
}

function padLeft(str, width, padChar) {
  var ret = str;
  while (ret.length < width) {
    if (ret.length + padChar.length < width) {
      ret = padChar + ret;
    } else {
      ret = padChar.substring(0, width - ret.length) + ret;
    }
  }
  return ret;
}

function indexOfAny(str, chars) {
  if (str) {
    for (var j = 0; j < chars.length; j++) {
      for (var i = 0; i < str.length; i++) {
        if (str.charAt(i) == chars[j]) return i;
      }
    }
    return -1;
  } else {
    return -1;
  }
}

function NumbersToChars(num) {
  var letter = '';
  num--;
  if (num > 25) {
    var val2 = Math.floor(num / 26.0);
    letter = NumbersToChars(val2);
    num = num - val2 * 26;
  }
  return '' + letter + '' + String.fromCharCode(num + 65) + '';
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
  output = new Date(dateTime).format('yyyy-MM-ddThh:mm:ss');
  if (!output) {
    output = new Date().format('yyyy-MM-ddThh:mm:ss');
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
  output = new Date(dateFormat).format('yyyy-MM-dd hh:mm:ss');
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

function IsValidString(strExpression, strChkFor) {
  var matches;
  if (strChkFor) {
    matches = strExpression.match('[' + strChkFor + ']');
  } else {
    matches = strExpression.match('[""]');
  }
  var intQoutes;
  if (matches) intQoutes = matches.length;
  else
  intQoutes = 0;
  intQoutes = intQoutes % 2;
  if (intQoutes == 0) return true;
  else
  return false;
}

function isLetter(str, index) {
  var c = str.charAt(index);
  if ((c < "a" || c > "z") && (c < "A" || c > "Z")) {
    return false;
  }
  return true;
}

function TransOoxRefToOdf(strExpresion) {
  var strOoxExpression = strExpresion;
  var strFnAnalysis = "(BESSELI(BESSELJ(BESSELK(BESSELY(BIN2DEC(BIN2HEX(BIN2OCT(COMPLEX(CONVERT(DEC2BIN(DEC2HEX(DEC2OCT(DELTA(ERF(ERFC(GESTEP(HEX2BIN(HEX2DEC(HEX2OCT(IMABS(IMAGINARY(IMARGUMENT(IMCONJUGATE(IMCOS(IMDIV(IMEXP(IMLN(IMLOG10(IMLOG2(IMPOWER(IMPRODUCT(IMREAL(IMSIN(IMSQRT(IMSUB(IMSUM(OCT2BIN(OCT2DEC(OCT2HEX(EDATE(EOMONTH(NETWORKDAYS(WEEKNUM(WORKDAY(YEARFRAC(ISEVEN(ISODD(FACTDOUBLE(GCD(LCM(MROUND(MULTINOMIAL(QUOTIENT(RANDBETWEEN(SERIESSUM(SQRTPI(ACCRINT(ACCRINTM(AMORDEGRC(AMORLINC(COUPDAYBS(COUPDAYS(COUPDAYSNC(COUPNCD(COUPNUM(COUPPCD(DOLLARDE(DOLLARFR(FVSCHEDULE(INTRATE(MDURATION(ODDFPRICE(ODDFYIELD(ODDLPRICE(ODDLYIELD(PRICEDISC(PRICEMAT(RECEIVED(TBILLEQ(TBILLPRICE(TBILLYIELD(XIRR(YIELDDISC(YIELDMAT(CUMIPMT(CUMPRINC(EFFECT(NOMINAL(";
  //DISC(PRICE(YIELD(DURATION
  var strFnDate = "(DAYSINMONTH(DAYSINYEAR(ISLEAPYEAR(WEEKSINYEAR(";
  var strFnDateDif = "(MONTHS(WEEKS(YEARS(";
  var arlFnToChange = [];
  //split the expression on charecters and add only cell reference string to array.
  var arlCellRef = [];
  var arrContents = strOoxExpression.split('/[,^*//+-&=<>%(){};]/');
  var strVal = "";
  for (var i = 0; i < arrContents.length; i++) {
    if (arrContents[i].length == 0) {
      arrContents.splice(i, 1);
    }
  }
  for (var i = 0; i < arrContents.length; i++) {
    //if the value is string i.e. starts with ", no need to consider.
    if (strVal != "") {
      strVal = strVal + arrContents[i];
      if (IsValidString(strVal)) {
        strVal = "";
      }
    } else if (arrContents[i].indexOf("\"") == 0) {
      strVal = arrContents[i];
      if (IsValidString(strVal)) {
        strVal = "";
      }
    } else if (!isNaN(arrContents[i].trim())) {
      //if its a number, then no need to consider.
      strVal = "";
    } else if (arrContents[i].indexOf(":") >= 0 || arrContents[i].indexOf("!") >= 0) {
      //if it contains any of the cell reference chars : or !.. consider
      arlCellRef.push(arrContents[i].trim());
      strVal = "";
    } else {
      //if the string starts with $ or alphabet and ends with number, then its a cell address.
      strVal = arrContents[i].trim();
      var chrFirst = strVal[0];
      var chrLast = strVal[strVal.length - 1];
      var intCharFirst = chrFirst.charCodeAt(0);
      if (strVal.length <= 12 && (isLetter(strVal, 0) || strVal[0] == '$') && !isNaN(strVal.substring(0, strVal.length - 1)) && (strVal.toUpperCase() != "IMLOG10" || strVal.toUpperCase() != "IMLOG2" || strVal.toUpperCase() != "SUMX2MY2" || strVal.toUpperCase() != "SUMX2PY2" || strVal.toUpperCase() != "SUMXMY2")) {
        arlCellRef.push(strVal);
      } else {
        if (strFnDateDif.indexOf("(" + arrContents[i].trim().toUpperCase() + "(") >= 0) {
          if (arlFnToChange.indexOf(arrContents[i].trim() + "(1") < 0) {
            arlFnToChange.push(arrContents[i].trim() + "(1");
          }
        } else if (strFnDate.indexOf("(" + arrContents[i].trim().toUpperCase() + "(") >= 0) {
          if (arlFnToChange.indexOf(arrContents[i].trim() + "(2") < 0) {
            arlFnToChange.push(arrContents[i].trim() + "(2");
          }
        } else if (strFnAnalysis.indexOf("(" + arrContents[i].trim().toUpperCase() + "(") >= 0) {
          if (arlFnToChange.indexOf(arrContents[i].trim() + "(3") < 0) {
            arlFnToChange.push(arrContents[i].trim() + "(3");
          }
        }
      }
      //chk for key word and replace with com.addin
      strVal = "";
    }
  }
  //store the oox and corresponding odf represention in 2-dimentional array
  var arrOoxToOdf = [];
  for (var i = 0; i < arlCellRef.length; i++) {
    var strOoxCellRef = arlCellRef[i];
    var temparrOoxToOdf = [];
    temparrOoxToOdf.push(strOoxCellRef);
    //if reference not contains ! then no reference with sheetname exists.
    if (strOoxCellRef.indexOf("!") < 0) {
      strOoxCellRef = "[." + strOoxCellRef;
      strOoxCellRef = strOoxCellRef.replace(" ", "]![.");
      strOoxCellRef = strOoxCellRef.replace(":", ":.");
      strOoxCellRef = strOoxCellRef + "]";
      temparrOoxToOdf.push(strOoxCellRef);
    } else {
      //reference with sheetname
      var strSheetRange = "";
      var blnSheetRange = false;
      strSheetRange = strOoxCellRef.substring(0, strOoxCellRef.indexOf('!'));
      var intFrom = strOoxCellRef.indexOf('!');
      //sheetname with special char
      if (strSheetRange.indexOf("'") >= 0) {
        var blnInvalid = true;
        while (blnInvalid) {
          if (IsValidString(strSheetRange, "'")) {
            blnInvalid = false;
          } else {
            strSheetRange = strOoxCellRef.substring(0, strOoxCellRef.indexOf('!', intFrom + 1));
          }
        }
        if (!blnInvalid) {
          //if sheetname contains :, eg.Sheet1:Sheet3!B2 --> [Sheet1.B2:Sheet3.B2]
          if (strSheetRange.indexOf(":") >= 0) {
            blnSheetRange = true;
            var strCellRef = strOoxCellRef.substring(strOoxCellRef.indexOf('!', intFrom));
            strSheetRange = "[" + strSheetRange.substring(0, strSheetRange.indexOf(':') - 1) + "." + strCellRef + ":" + strSheetRange.substring(strSheetRange.indexOf(':')) + "." + strCellRef + "]";
            temparrOoxToOdf.push(strSheetRange);
          }
        }
      } else {
        if (strSheetRange.indexOf(":") >= 0) {
          blnSheetRange = true;
          var strCellRef = strOoxCellRef.substring(strOoxCellRef.indexOf('!') + 1);
          strSheetRange = "[" + strSheetRange.substring(0, strSheetRange.indexOf(':')) + "." + strCellRef + ":" + strSheetRange.substring(strSheetRange.indexOf(':') + 1) + "." + strCellRef + "]";
          temparrOoxToOdf.push(strSheetRange);
        }
      }
      //if not sheet range
      if (!blnSheetRange) {
        strOoxCellRef = "[" + strOoxCellRef;
        if (strOoxCellRef.indexOf("'") >= 0) {
          //chk for special sheet name
          //strOoxCellRef = strOoxCellRef.Replace('!', '.');
          var arrSheetName = strOoxCellRef.split('!');
          var strChkValid = "";
          for (var j = 0; j < arrSheetName.length - 1; j++) {
            strChkValid = strChkValid + arrSheetName[j];
            if (IsValidString(strChkValid, "'")) {
              strOoxCellRef = strOoxCellRef.replace(strChkValid + "!", strChkValid + ".");
              strChkValid = "";
            } else {
              strChkValid = strChkValid + "!";
            }
          }
        } else {
          strOoxCellRef = strOoxCellRef.replace('!', '.');
        }
        strOoxCellRef = strOoxCellRef.replace(":", ":.");
        strOoxCellRef = strOoxCellRef + "]";
        //intersection space in oox should be replaced with ! in odf
        if (strOoxCellRef.indexOf(" ") >= 0) {
          var arrSheetName = strOoxCellRef.split(' ');
          var strChkValid = "";
          for (var j = 0; j < arrSheetName.length - 1; j++) {
            strChkValid = strChkValid + arrSheetName[j];
            if (IsValidString(strChkValid, "'")) {
              strOoxCellRef = strOoxCellRef.replace(strChkValid + " ", strChkValid + "]![");
              strChkValid = "";
            } else {
              strChkValid = strChkValid + " ";
            }
          }
        }
        temparrOoxToOdf.push(strSheetRange);
      }
    }
    arrOoxToOdf.push(temparrOoxToOdf);
  }
  //replace the oox cell refrence with odf cell ref.
  var strOdfFromula = "";
  var intStartIndex = 0;
  //var intEndIndex = 0;
  for (var intReplace = 0; intReplace < arrOoxToOdf.length / 2; intReplace++) {
    intStartIndex = strOoxExpression.indexOf(arrOoxToOdf[intReplace][0]);
    strOdfFromula = strOdfFromula + strOoxExpression.substring(0, intStartIndex);
    strOdfFromula = strOdfFromula + arrOoxToOdf[intReplace][1];
    strOoxExpression = strOoxExpression.substring(intStartIndex + arrOoxToOdf[intReplace][0].length, strOoxExpression.length);
  }
  strOdfFromula = strOdfFromula + strOoxExpression;
  for (var i = 0; i < arlFnToChange.length; i++) {
    var strFnToChange = arlFnToChange[i];
    var strLast = strFnToChange.substring(0, strFnToChange.length - 1);
    switch (strLast) {
    case "1":
      strOdfFromula = strOdfFromula.replace(strFnToChange, "com.sun.star.sheet.addin.DateFunctions.getDiff" + strFnToChange);
      break;
    case "2":
      strOdfFromula = strOdfFromula.replace(strFnToChange, "com.sun.star.sheet.addin.DateFunctions.get" + strFnToChange);
      break;
    case "3":
      strOdfFromula = strOdfFromula.replace(strFnToChange, "com.sun.star.sheet.addin.Analysis.get" + strFnToChange);
      break;
    }
  }
  if (strOdfFromula.indexOf("ERROR.TYPE(") >= 0) {
    strOdfFromula = strOdfFromula.replace("ERROR.TYPE(", "ERRORTYPE(");
  }
  return strOdfFromula;
}

function TransOoxParmsToOdf(strExpresion) {
  var arrParms = strExpresion.split(',');
  var strOdfExpression = "";
  for (var intComaIndex = 0; intComaIndex < arrParms.length; intComaIndex++) {
    if (arrParms[intComaIndex].indexOf("\"") >= 0 || arrParms[intComaIndex].indexOf("'") >= 0) {
      var intIndexOfDQ = arrParms[intComaIndex].indexOf("\"");
      var intIndexOfSQ = arrParms[intComaIndex].indexOf("'");
      if (intIndexOfDQ < intIndexOfSQ) {
        if (IsValidString(arrParms[intComaIndex])) {
          strOdfExpression = strOdfExpression + arrParms[intComaIndex] + ";";
        } else {
          var blnChk = false;
          var strValid = arrParms[intComaIndex];
          while (!blnChk && intComaIndex < arrParms.length - 1) {
            intComaIndex++;
            strValid = strValid + "," + arrParms[intComaIndex];
            blnChk = IsValidString(strValid);
          }
          strOdfExpression = strOdfExpression + strValid + ";";
        }
      } else {
        if (IsValidString(arrParms[intComaIndex], "'")) {
          strOdfExpression = strOdfExpression + arrParms[intComaIndex] + ";";
        } else {
          var blnChk = false;
          var strValid = arrParms[intComaIndex];
          while (!blnChk && intComaIndex < arrParms.length - 1) {
            intComaIndex++;
            strValid = strValid + "," + arrParms[intComaIndex];
            blnChk = IsValidString(strValid, "'");
          }
          strOdfExpression = strOdfExpression + strValid + ";";
        }
      }
    } else {
      strOdfExpression = strOdfExpression + arrParms[intComaIndex] + ";";
    }
  }
  strOdfExpression = strOdfExpression.substring(0, strOdfExpression.length - 1)
  strOdfExpression = "oooc:=" + strOdfExpression;
  //strOdfExpression = strOdfExpression.Replace("\"", "&quot;"); //not required
  // strOdfExpression = strOdfExpression.Replace("'", "&apos;");//not required
  //replace > < & ' " chars with equivalent representation//not required
  //add remove parms
  strOdfExpression = TransFormulaParms(strOdfExpression);
  return strOdfExpression;
}

function TransFormulaParms(strFormula) {
  var strTransFormula = "";
  var strFormulaToTrans = "";
  var strExpression = "";
  //chking for key word
  if (strFormula.indexOf("ADDRESS(") >= 0 || strFormula.indexOf("PERCENTAGERANK(") >= 0) {
    while (strFormula != "") {
      //TODO : Include other formulas.
      if (strFormula.indexOf("ADDRESS(") >= 0 || strFormula.indexOf("PERCENTAGERANK(") >= 0) {
        var arrIndex = new Array();
        var strFunction = "";
        var intFunction = 0;
        var intIndex = 0;
        arrIndex[0] = strFormula.indexOf("ADDRESS("); //remove 4th parm:1
        arrIndex[1] = strFormula.indexOf("PERCENTAGERANK("); //remove 3rd parm
        //arrIndex[2] = strFormula.indexOf("FLOOR(");//remove 3rd parm
        if (arrIndex[0] >= 0 && arrIndex[0] > arrIndex[1]) {
          strFunction = "ADDRESS(";
          intFunction = 1;
          intIndex = arrIndex[0];
        } else if (arrIndex[1] >= 0 && arrIndex[1] > arrIndex[0]) {
          strFunction = "PERCENTAGERANK(";
          intFunction = 2;
          intIndex = arrIndex[1];
        }
        var strConvertedExp = "";
        strTransFormula = strTransFormula + strFormula.substring(0, intIndex);
        strFormulaToTrans = strFormula.substring(intIndex);
        if (strFormulaToTrans.indexOf(")") >= 0) {
          strExpression = GetExpression(strFormulaToTrans);
        }
        if (strExpression != "") {
          //TODO : if function with one parm and second to be added.
          if (strExpression.indexOf(";") >= 0) {
            if (intFunction == 1) {
              strConvertedExp = AddRemoveParm(strExpression, 4, false, true, "");
            } else {
              strConvertedExp = AddRemoveParm(strExpression, 3, false, true, "");
            }
          } else {
            strConvertedExp = strExpression;
          }
          //use converted and send remaining for chk
          strTransFormula = strTransFormula + strConvertedExp;
          strFormula = strFormulaToTrans;
          strFormula = strFormula.substring(strExpression.length, strFormula.length)
        } else {
          //remove the key word and send remaing for chk
          strTransFormula = strTransFormula + strFormulaToTrans.substring(0, strFunction.length);
          strFormula = strFormulaToTrans.substring(strFormula.length, strFormulaToTrans.length);
        }
      } else {
        strTransFormula = strTransFormula + strFormula;
        strFormula = "";
      }
    }
  } else {
    strTransFormula = strFormula;
  }
  return strTransFormula;
}

function GetExpression(strExpression) {
  var strChkValidExp = "";
  var blnValidExp = false;
  var intChkFrom = 0;
  while (!blnValidExp) {
    if (intChkFrom == 0) {
      intChkFrom = strExpression.indexOf(')');
    } else {
      intChkFrom = strExpression.indexOf(')', intChkFrom + 1);
    }
    strChkValidExp = strExpression.substring(0, intChkFrom + 1);
    blnValidExp = IsValidExpression(strChkValidExp);
  }
  return strChkValidExp;
}

function IsValidExpression(strExpression) {
  var intOpenBracket;
  var intClosedBracket;
  var intOpenFlower;
  var intClosedFlower;
  var intQoutes;
  var matches = strExpression.match('[""]');
  intQoutes = matches.length;
  intQoutes = intQoutes % 2;
  if (intQoutes == 0) {
    var strChkQoutes = strExpression;
    while (strChkQoutes.indexOf('""') >= 0) {
      var intStart = 0;
      var intEnd = 0;
      intStart = strChkQoutes.indexOf('"');
      intEnd = strChkQoutes.indexOf('"', intStart + 1);
      var strRemvChars = strChkQoutes.substring(intStart + 1, intEnd - intStart - 1);
      var r = new RegExp('[(){}]', 'g');
      strRemvChars = strRemvChars.replace(r, " ");
      strChkQoutes = strChkQoutes.substring(0, intStart) + strRemvChars + strChkQoutes.substring(intEnd + 1);
      //strChkQoutes = strChkQoutes.Substring(0, intStart);
    }
    strExpression = strChkQoutes;
  }
  matches = strExpression.match('[/(]');
  intOpenBracket = matches.length;
  matches = strExpression.match('[/)]');
  intClosedBracket = matches.length;
  matches = strExpression.match('[/{]');
  intOpenFlower = matches.length;
  matches = strExpression.match('[/}]');
  intClosedFlower = matches.length;
  matches = strExpression.match('[""]');
  intQoutes = matches.length;
  intQoutes = intQoutes % 2;
  if (intOpenBracket == intClosedBracket && intOpenFlower == intClosedFlower && intQoutes == 0) {
    return true;
  } else {
    return false;
  }
}

function AddRemoveParm(strExpresion, intPossition, blnParmAdd, blnParmRemove, strParmAdd) {
  var strTransFormula = "";
  var strFormulaKeyword = strExpresion.substring(0, strExpresion.indexOf('('));
  strExpresion = strExpresion.substring(strExpresion.indexOf('(') + 1);
  strExpresion = strExpresion.substring(0, strExpresion.length - 1);
  var arlParms = GetParms(strExpresion);
  if (arlParms.length >= intPossition) {
    if (blnParmAdd == true && blnParmRemove == false) {
      strTransFormula = strFormulaKeyword + "(";
      for (var i = 0; i < arlParms.length; i++) {
        if (intPossition == i + 1) {
          strTransFormula = strTransFormula + strParmAdd + ";" + arlParms[i] + ";";
        } else {
          strTransFormula = strTransFormula + arlParms[i] + ";";
        }
      }
      strTransFormula = strTransFormula.substring(0, strTransFormula.length - 1) + ")";
    } else if (blnParmAdd == false && blnParmRemove == true) {
      strTransFormula = strFormulaKeyword + "(";
      for (var i = 0; i < arlParms.length; i++) {
        if (intPossition != i + 1) {
          strTransFormula = strTransFormula + arlParms[i] + ";";
        }
      }
      strTransFormula = strTransFormula.substring(0, strTransFormula.length - 1) + ")";
    }
  } else {
    strTransFormula = strFormulaKeyword + "(" + strExpresion + ")";
  }
  return strTransFormula;
}

function GetParms(strExpression) {
  var arlParms = [];
  var strArrParm = strExpression.split(';');
  var strExpToVald = "";
  if (strArrParm.length > 0) {
    for (var i = 0; i < strArrParm.length; i++) {
      if (strExpToVald == "") {
        strExpToVald = strArrParm[i];
      } else {
        strExpToVald = strExpToVald + ";" + strArrParm[i];
      }
      if (strExpToVald.indexOf("\"") == 0) {
        if (IsValidString(strExpToVald)) {
          arlParms.push(strExpToVald);
          strExpToVald = "";
        }
      } else if (IsValidExpression(strExpToVald)) {
        strExpToVald = TransFormulaParms(strExpToVald);
        arlParms.push(strExpToVald);
        strExpToVald = "";
      }
    }
  }
  return arlParms;
}

function GetSheetNames(strSheetNames) {
  var sheetNames = strSheetNames.substring(0, strSheetNames.length - 2);
  var sheetArrayWithSplChars = sheetNames.split('::');
  var sheetArray = [];
  for (var i = 0; i < sheetArrayWithSplChars.length; i++) {
    var intSepIndex = sheetArrayWithSplChars[i].indexOf(':');
    var tempsheetArray = [];
    tempsheetArray.push(sheetArrayWithSplChars[i].substring(0, intSepIndex).replace("'", "''"));
    tempsheetArray.push(sheetArrayWithSplChars[i].substring(intSepIndex + 1));
    sheetArray.push(tempsheetArray);
  }
  return sheetArray;
}

function GetFormula(strOoxFormula) {
  var intIndexSheetName = strOoxFormula.indexOf('##shtName##');
  var strFormulaToTrans = '';
  if (intIndexSheetName != -1) {
    strFormulaToTrans = strOoxFormula.substring(0, intIndexSheetName);
    var arrSheetName = GetSheetNames(strOoxFormula.substring(intIndexSheetName + 11));
    for (var intCnt = 0; intCnt < arrSheetName.length; intCnt++) {
      if (arrSheetName[intCnt][0] != arrSheetName[intCnt][1]) {
        strFormulaToTrans = strFormulaToTrans.replace("'" + arrSheetName[intCnt][0] + "':", "'" + arrSheetName[intCnt][1] + "':");
        strFormulaToTrans = strFormulaToTrans.replace("'" + arrSheetName[intCnt][0] + "'!", "'" + arrSheetName[intCnt][1] + "'!");
        strFormulaToTrans = strFormulaToTrans.replace(arrSheetName[intCnt][0] + ":", arrSheetName[intCnt][1] + ":");
        strFormulaToTrans = strFormulaToTrans.replace(arrSheetName[intCnt][0] + "!", arrSheetName[intCnt][1] + "!");
      }
    }
  } else {
    strFormulaToTrans = strOoxFormula;
  }
  if (strFormulaToTrans != '') {
    strFormulaToTrans = TransOoxRefToOdf(strFormulaToTrans);
    strFormulaToTrans = TransOoxParmsToOdf(strFormulaToTrans);
  }
  return strFormulaToTrans;
}

function EvaltransFileName(arrVal1, arrVal2) {
  var filename = '';
  return arrVal1 + filename + arrVal2;
}

function EvalShadowExpression(arrVal) {
  var x = 0;
  if (arrVal.length == 3) {
    var arrDist = parseFloat(arrVal[1]);
    var arrDir = parseFloat(arrVal[2]);
    arrDir = (arrDir / 60000) * (Math.PI / 180.0);
    if (arrVal[0] == "shadow-offset-x") {
      x = Math.round(Math.sin((arrDir)) * (arrDist / 360000), 3);
    } else if (arrVal[0] == "shadow-offset-y") {
      x = Math.round(Math.cos((arrDir)) * (arrDist / 360000), 3);
    }
  }
  return x + "cm";
}

function EvalShadeExpression(arrVal) {
  var dblRed = parseFloat(arrVal[1]);
  var dblGreen = parseFloat(arrVal[2]);
  var dblBlue = parseFloat(arrVal[3]);
  var dblShade = parseFloat(arrVal[4]);
  var sR;
  if (dblRed < 10) {
    sR = 2.4865 * dblRed;
  } else {
    sR = (Math.pow(((dblRed + 14.025) / 269.025), 2.4)) * 8192;
  }
  var sG;
  if (dblGreen < 10) {
    sG = 2.4865 * dblGreen;
  } else {
    sG = (Math.pow(((dblGreen + 14.025) / 269.025), 2.4)) * 8192;
  }
  var sB;
  if (dblBlue < 10) {
    sB = 2.4865 * dblBlue;
  } else {
    sB = (Math.pow(((dblBlue + 14.025) / 269.025), 2.4)) * 8192;
  }

  var NewRed;
  var sRead;
  sRead = (sR * dblShade / 100);

  if (sRead < 10) {
    NewRed = 0;
  } else if (sRead < 24) {
    NewRed = (12.92 * 255 * sR / 8192);
  } else if (sRead <= 8192) {
    NewRed = ((Math.pow(sRead / 8192, 1 / 2.4) * 1.055) - 0.055) * 255;
  } else {
    NewRed = 255;
  }
  NewRed = Math.round(NewRed);

  var NewGreen;
  var sGreen;
  sGreen = (sG * dblShade / 100);

  if (sGreen < 0) {
    NewGreen = 0;
  } else if (sGreen < 24) {
    NewGreen = (12.92 * 255 * dblGreen / 8192);
  } else if (sGreen < 8193) {
    NewGreen = ((Math.pow(sGreen / 8192, 1 / 2.4) * 1.055) - 0.055) * 255;
  } else {
    NewGreen = 255;
  }
  NewGreen = Math.round(NewGreen);

  var NewBlue;
  var sBlue;
  sBlue = (sB * dblShade / 100);

  if (sBlue < 0) {
    NewBlue = 0;
  } else if (sBlue < 24) {
    NewBlue = (12.92 * 255 * dblBlue / 8192);
  } else if (sBlue < 8193) {
    NewBlue = ((Math.pow(sBlue / 8192, 1 / 2.4) * 1.055) - 0.055) * 255;;
  } else {
    NewBlue = 255;
  }
  NewBlue = Math.round(NewBlue);

  var intRed = NewRed;
  var intGreen = NewGreen;
  var intBlue = NewBlue;

  var hexRed = parseInt(intRed).toString(16);
  var hexGreen = parseInt(intGreen).toString(16);
  var hexBlue = parseInt(intBlue).toString(16);

  return ('#' + padLeft(hexRed.toUpperCase(), 2, '0') + padLeft(hexGreen.toUpperCase(), 2, '0') + padLeft(hexBlue.toUpperCase(), 2, '0'));
}

function GetChartWidth(text) {
  var textArray = text.split('|');
  var fontName = textArray[1];
  var fontSize = textArray[2];
  var defColCount = parseFloat(textArray[3]);
  var customColWidth = parseFloat(textArray[4]);
  var startOffset = parseFloat(textArray[5]);
  var endOffset = parseFloat(textArray[6]);
  var defColumnWidth = GetColumnWidth1(false, fontName, fontSize, 0.0);
  var defColumnWidthPX = parseFloat(defColumnWidth);
  var customColumnWidth = GetColumnWidth1(true, fontName, fontSize, customColWidth);
  var customColumnWidthPX = parseFloat(customColumnWidth);
  var totalWidthPX = ((defColCount * defColumnWidthPX) + customColumnWidthPX);
  var totalWidthCM = (totalWidthPX / 96.21212121 * 2.54) + endOffset - startOffset;
  return totalWidthCM + "cm";
}

function GetColumnWidth(text) {
  var CALC_DPI = 0.7874;
  var preDefinedWidth = 0.0;
  var textArray = text.split('|');
  var isWidDefined = (textArray[0] == 'True');
  var fontName = textArray[1];
  var fontSize = textArray[2];
  var dblFontSizePt = parseFloat(fontSize);
  var dblMaxDigitWidth = MaxDigitWidth(fontName, dblFontSizePt);
  if (isWidDefined) {
    preDefinedWidth = parseFloat(textArray[3]);
  }
  var iWidthInPixel = WidthToPixel(dblMaxDigitWidth, preDefinedWidth, isWidDefined);
  var dblWidthInPt = CALC_DPI * iWidthInPixel;
  var columnWidthInch = (dblWidthInPt / 72);
  var columnWidthCM = columnWidthInch * 2.54;
  return Math.round(columnWidthCM * 1000) / 1000 + "cm";
}

function GetColumnWidth1(isWidDefined, fontName, fontSize, customWid) {
  var CALC_DPI = 0.7874;
  var preDefinedWidth = 0.0;
  var dblFontSizePt = parseFloat(fontSize);
  var dblMaxDigitWidth = MaxDigitWidth(fontName, dblFontSizePt);
  if (isWidDefined) {
    preDefinedWidth = parseFloat(customWid);
  }
  var iWidthInPixel = WidthToPixel(dblMaxDigitWidth, preDefinedWidth, isWidDefined);
  return iWidthInPixel;
}

function MaxDigitWidth(fontName, dblSizePt) {
  // Avoid dependency on X11 on Linux here... just approximate
  return dblSizePt * 0.75;
}

function WidthToPixel(dblMaxDigitWidth, preDefinedWidth, isWidDefined) {
  var colWidPt = 0.0;
  if (isWidDefined) {
    colWidPt = preDefinedWidth;
  } else {
    colWidPt = parseInt((((8 * dblMaxDigitWidth) + 5) / dblMaxDigitWidth) * 256) / 256;
  }
  var colWidPx = parseInt(((256 * colWidPt + parseInt(128.0 / dblMaxDigitWidth)) / 256) * dblMaxDigitWidth);
  return colWidPx;
}

function EvalWordShapesFormula(arrPart) {
  var strFormula = '';
  var strShapeSize = arrPart[2].split(',');
  var width = strShapeSize[0];
  var height = strShapeSize[1];
  var arrFormulaVals = arrPart[1].split(' ');
  if (arrPart.length == 3) {
    if (arrFormulaVals[0] == "sum") {
      strFormula = arrFormulaVals[1] + " + " + arrFormulaVals[2] + " - " + arrFormulaVals[3];
    } else if (arrFormulaVals[0] == "if") {
      strFormula = "if(" + arrFormulaVals[1] + ", " + arrFormulaVals[2] + " , " + arrFormulaVals[3] + ")";
    } else if (arrFormulaVals[0] == "prod") {
      strFormula = arrFormulaVals[1] + " * " + arrFormulaVals[2] + " / " + arrFormulaVals[3];
    } else if (arrFormulaVals[0] == "abs") {
      strFormula = "abs(" + arrFormulaVals[1] + ")";
    } else if (arrFormulaVals[0] == "val") {
      strFormula = arrFormulaVals[1];
    } else if (arrFormulaVals[0] == "mid") {
      strFormula = "(" + arrFormulaVals[1] + " + " + arrFormulaVals[2] + ") / " + 2;
    } else if (arrFormulaVals[0] == "sqrt") {
      strFormula = "sqrt(abs(" + arrFormulaVals[1] + "))";
    } else if (arrFormulaVals[0] == "max") {
      strFormula = "max(" + arrFormulaVals[1] + ", " + arrFormulaVals[2] + ")";
    } else if (arrFormulaVals[0] == "min") {
      strFormula = "min(" + arrFormulaVals[1] + ", " + arrFormulaVals[2] + ")";
    } else if (arrFormulaVals[0] == "cos") {
      strFormula = arrFormulaVals[1] + " * " + "cos(" + arrFormulaVals[2] + ")";
    } else if (arrFormulaVals[0] == "sin") {
      strFormula = arrFormulaVals[1] + " * " + "sin(" + arrFormulaVals[2] + ")";
    } else if (arrFormulaVals[0] == "tan") {
      strFormula = arrFormulaVals[1] + " * " + "tan(" + arrFormulaVals[2] + ")";
    } else if (arrFormulaVals[0] == "mod") {
      strFormula = "sqrt(abs((" + arrFormulaVals[1] + " *" + arrFormulaVals[1] + ")+(" + arrFormulaVals[2] + " *" + arrFormulaVals[2] + ")+(" + arrFormulaVals[3] + " *" + arrFormulaVals[3] + ")))";
    } else if (arrFormulaVals[0] == "sumangle") {
      strFormula = arrFormulaVals[1] + " + " + arrFormulaVals[2] + " * 65536 - " + arrFormulaVals[3] + " *65536";
    } else if (arrFormulaVals[0] == "sinatan2") {
      strFormula = arrFormulaVals[1] + " * sin(atan2(" + arrFormulaVals[2] + "," + arrFormulaVals[3] + "))";
    } else if (arrFormulaVals[0] == "cosatan2") {
      strFormula = arrFormulaVals[1] + " * cos(atan2(" + arrFormulaVals[2] + "," + arrFormulaVals[3] + "))";
    } else if (arrFormulaVals[0] == "ellipse") {
      strFormula = arrFormulaVals[3] + " *sqrt( abs(1-((" + arrFormulaVals[1] + " *" + arrFormulaVals[1] + ")/(" + arrFormulaVals[2] + " *" + arrFormulaVals[2] + "))))";
    } else if (arrFormulaVals[0] == "atan2") {
      strFormula = "atan2(" + arrFormulaVals[2] + "," + arrFormulaVals[1] + ")";
    }
  }
  strFormula = strFormula.replace("#", "$");
  strFormula = strFormula.replace("pixelwidth", "width * 0.0264");
  strFormula = strFormula.replace("pixellinewidth", "width * 0.0264");
  strFormula = strFormula.replace("pixelheight", "height * 0.0264");
  strFormula = strFormula.replace("pixellineheight", "height * 0.0264");

  strFormula = strFormula.replace("pixelWidth", "width * 0.0264");
  strFormula = strFormula.replace("pixellineWidth", "width * 0.0264");
  strFormula = strFormula.replace("pixelHeight", "height * 0.0264");
  strFormula = strFormula.replace("pixellineHeight", "height * 0.0264");

  strFormula = strFormula.replace("pixelLineWidth", "width * 0.0264");
  strFormula = strFormula.replace("pixelLineHeight", "height * 0.0264");
  strFormula = strFormula.replace("linedrawn", "1");
  strFormula = strFormula.replace("lineDrawn", "1");

  strFormula = strFormula.replace("emuwidth", "width");
  strFormula = strFormula.replace("emuheight", "height");
  strFormula = strFormula.replace("emuwidth2", "width");
  strFormula = strFormula.replace("emuheight2", "height");

  strFormula = strFormula.replace("@", "?f");

  return strFormula;
}

function EvalTableCord(text) {
  try {
    var arrPart = text.split('@');
    var arrVal = arrPart[0].split(':');
    var arrVal1 = arrPart[1].split(':');
    var dblTempCell = 0.0;
    var dblXY = 0.0;
    var dblRetXY = 0.0;
    var dblSUBXY = 0.0;
    dblXY = parseFloat(arrVal1[1]);

    if (arrVal1[0] == "1") {
      dblRetXY = dblXY;
    } else {
      for (var intCount = 0; intCount < arrVal.length - 2; intCount++) {
        dblTempCell = parseFloat(arrVal[intCount]);
        dblSUBXY += dblTempCell;
      }
      dblRetXY = dblXY + dblSUBXY;
    }
    var str = dblRetXY / 360000;
    return str + "cm";
  } catch (e) {
    alert(e);
  }
}

function EvalWordModifier(arrPart) {
  var strModf = '';
  if (arrPart) {
    strModf = arrPart;
    strModf = strModf.replace(",,,,,", ",0,0,0,0,");
    strModf = strModf.replace(",,,,", ",0,0,0,");
    strModf = strModf.replace(",,,", ",0,0,");
    strModf = strModf.replace(",,", ",0,");
    strModf = strModf.replace(",", " ");
  }
  return strModf;
}

function TranslateRCommand(strpath) {
  var reg = new RegExp('([-0-9]+[ ]+[-0-9]+[ ]+[RP]+[ ]+[-0-9]+[ ]+[-0-9]+[ ])', 'g');
  var delegate = function(match) {
    var strMatch = match;
    var arrRValues = strMatch.split(' ');
    var dblX = parseFloat(arrRValues[0]) + parseFloat(arrRValues[3]);
    var dblY = parseFloat(arrRValues[1]) + parseFloat(arrRValues[4]);
    if (strMatch.indexOf("R") >= 0) {
      strMatch = arrRValues[0] + " " + arrRValues[1] + " L " + dblX + " " + dblY + " ";
    } else if (strMatch.indexOf("P") >= 0) {
      strMatch = arrRValues[0] + " " + arrRValues[1] + " M" + dblX + " " + dblY + " ";
    }
    return strMatch;
  };
  return strpath.replace(reg, delegate);
}

function TranslateVCommand(strpath) {
  var reg = new RegExp('([-0-9]+[ ]+[-0-9]+[ ]+[E]+[ ]+[-0-9]+[ ]+[-0-9]+[ ]+[-0-9]+[ ]+[-0-9]+[ ]+[-0-9]+[ ]+[-0-9]+[ ])', 'g');
  var delegate = function(match) {
    var strMatch = match;
    var arrVValues = strMatch.split(' ');

    var dblX0 = parseInt(arrVValues[0]);
    var dblY0 = parseInt(arrVValues[1]);
    var dblX1 = parseInt(arrVValues[3]);
    var dblY1 = parseInt(arrVValues[4]);
    var dblX2 = parseInt(arrVValues[5]);
    var dblY2 = parseInt(arrVValues[6]);
    var dblX3 = parseInt(arrVValues[7]);
    var dblY3 = parseInt(arrVValues[8]);
    strMatch = arrVValues[0] + " " + arrVValues[1] + " C " + (dblX0 + dblX1) + " " + (dblY0 + dblY1) + " " + (dblX0 + dblX2) + " " + (dblY0 + dblY2) + " " + (dblX0 + dblX3) + " " + (dblY0 + dblY3) + " ";
    return strMatch;
  };
  return strpath.replace(reg, delegate);
}

function Translate_CommandComma(strpath) {
  var reg = new RegExp('([ABCFLMNSTUVWXYZREP]+[,])', 'g');
  var delegate = function(match) {
    var strMatch = match;
    strMatch = strMatch.substring(0, strMatch.indexOf(',')) + "0,";
    return strMatch;
  };
  return strpath.replace(reg, delegate);
}

function Translate_CommaCommand(strpath) {
  var reg = new RegExp('([,]+[ABCFLMNSTUVWXYZREP])', 'g');
  var delegate = function(match) {
    var arrCommands = ['A', 'B', 'C', 'F', 'L', 'M', 'N', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'R', 'E', 'P'];
    var strMatch = match;
    strMatch = ",0 " + strMatch.substring(indexOfAny(strMatch, arrCommands), strMatch.length);
    return strMatch;
  };
  return strpath.replace(reg, delegate);
}

function regexpres(strpath) {
  var reg = new RegExp('([-0-9]+[ABCFLMNSTUVWXYZREP])', 'g');
  var delegate = function(match) {
    var arrCommands = ['A', 'B', 'C', 'F', 'L', 'M', 'N', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'R', 'E', 'P'];
    var strMatch = match;
    strMatch = strMatch.substring(0, indexOfAny(strMatch, arrCommands)) + " " + strMatch.substring(indexOfAny(strMatch, arrCommands));
    return strMatch;
  };
  return strpath.replace(reg, delegate);
}

function EvalWordEnhacePath(arrPart) {
  var strPath = '';
  if (arrPart) {
    strPath = arrPart;
    strPath = strPath.replace(",,,,,", ",0,0,0,0,");
    strPath = strPath.replace(",,,,", ",0,0,0,");
    strPath = strPath.replace(",,,", ",0,0,");
    strPath = strPath.replace(",,", ",0,");
    strPath = strPath.replace("h", "");
    strPath = strPath.replace("d", "");
    strPath = strPath.replace("at", "A");
    strPath = strPath.replace("ar", "B");
    strPath = strPath.replace("v", "E");
    strPath = strPath.replace("c", "C");
    strPath = strPath.replace("nf", "F");
    strPath = strPath.replace("al", "U");
    strPath = strPath.replace("wr", "V");
    strPath = strPath.replace("wa", "W");
    strPath = strPath.replace("ae", "T");
    strPath = strPath.replace("qx", "X");
    strPath = strPath.replace("qy", "Y");
    strPath = strPath.replace("l", "L");
    strPath = strPath.replace("x", "Z");
    strPath = strPath.replace("m", "M");
    strPath = strPath.replace("ns", "S");
    strPath = strPath.replace("e", "N");
    strPath = strPath.replace("r", "R");
    strPath = strPath.replace("t", "P");

    strPath = Translate_CommandComma(strPath);
    strPath = Translate_CommaCommand(strPath);
    strPath = regexpres(strPath);

    strPath = strPath.replace("@", " ?f");
    strPath = strPath.replace("N", "N ");
    strPath = strPath.replace("A", "A ");
    strPath = strPath.replace("B", "B ");
    strPath = strPath.replace("X", "X ");
    strPath = strPath.replace("Y", "Y ");
    strPath = strPath.replace("M", "M ");
    strPath = strPath.replace("L", "L ");
    strPath = strPath.replace("T", "T ");
    strPath = strPath.replace("U", "U ");
    strPath = strPath.replace("F", "F ");
    strPath = strPath.replace("S", "S ");
    strPath = strPath.replace("C", "C ");
    strPath = strPath.replace("Z", "Z ");
    strPath = strPath.replace("V", "V ");
    strPath = strPath.replace("W", "W ");
    strPath = strPath.replace("R", "R ");
    strPath = strPath.replace("E", "E ");
    strPath = strPath.replace("P", "P ");
    strPath = strPath.replace(",", " ");

    strPath = TranslateRCommand(strPath);
    strPath = TranslateVCommand(strPath);
  }
  if (strPath.trim() == "M 10800 0 A 0 0 21600 21600 10800 0 10800 0 Z N") {
    strPath = "M 10800 0 L 10799 0 C 4835 0 0 4835 0 10799 0 16764 4835 21600 10800 21600 16764 21600 21600 16764 21600 10800 21600 4835 16764 0 10800 0 Z N";
  }
  return strPath.trim();
}

function EvalRotationExpression(arrPart) {
  var strRotate;
  var strTranslate;
  var arrVal = arrPart.split(':');
  var dblRadius = 0.0;
  var dblXf = 0.0;
  var dblYf = 0.0;
  var dblalpha = 0.0;
  var dblbeta = 0.0;
  var dblgammaDegree = 0.0;
  var dblgammaR = 0.0;
  var dblRotAngle = 0.0;
  var dblX2 = 0.0;
  var dblY2 = 0.0;
  var centreX = 0.0;
  var centreY = 0.0;

  if (arrVal.length == 7) {
    var arrValueX = parseFloat(arrVal[0]);
    var arrValueY = parseFloat(arrVal[1]);
    var arrValueCx = parseFloat(arrVal[2]);
    var arrValueCy = parseFloat(arrVal[3]);
    var arrValueFlipH = parseFloat(arrVal[4]);
    var arrValueFlipV = parseFloat(arrVal[5]);
    var arrValueRot = parseFloat(arrVal[6]);
    if (arrVal[0].indexOf("draw-transform") >= 0) {
      centreX = arrValueX + (arrValueCx / 2);
      centreY = arrValueY + (arrValueCy / 2);
      if (arrValueFlipH == 1.0) {
        dblXf = arrValueX + ((centreX - arrValueX) * 2);
      } else {
        dblXf = arrValueX;
      }
      if (arrValueFlipV == 1.0) {
        dblYf = arrValueY + ((centreY - arrValueY) * 2);
      } else {
        dblYf = arrValueY;
      }
      dblRadius = Math.sqrt((arrValueCx * arrValueCx) + (arrValueCy * arrValueCy)) / 2.0;
      if ((arrValueFlipH == 0.0 && arrValueFlipV == 1.0) || (arrValueFlipH == 0.0 && arrValueFlipV == 1.0)) {
        dblalpha = 360.00 - ((arrValueRot / 60000.00) % 360);
      } else {
        dblalpha = (arrValueRot / 60000.00) % 360;
      }
      if (dblalpha > 180.00) {
        dblRotAngle = (360.00 - dblalpha) / 180.00 * Math.PI;
      } else {
        dblRotAngle = (-1.00 * dblalpha) / 180.00 * Math.PI;
      }
      if (Math.abs(centreY - dblYf) > 0) {
        dblbeta = Math.atan(Math.abs(centreX - dblXf) / Math.abs(centreY - dblYf)) * (180.00 / Math.PI);
      }
      if (Math.abs(dblbeta - dblalpha) > 0) {
        dblgammaDegree = ((dblbeta - dblalpha) % (((dblbeta - dblalpha) / Math.abs(dblbeta - dblalpha)) * 360)) + 90.00;
      } else {
        dblgammaDegree = 90.00;
      }
      dblgammaR = (360.00 - dblgammaDegree) / 180.00 * Math.PI;
      dblX2 = Math.round((centreX + (dblRadius * Math.cos(dblgammaR))) / 360036.00, 3);
      dblY2 = Math.round((centreY + (dblRadius * Math.sin(dblgammaR))) / 360036.00, 3);

    }
  }
  strRotate = "rotate (" + dblRotAngle + ")";
  strTranslate = "translate (" + dblX2 + "cm " + dblY2 + "cm)";
  return strRotate + " " + strTranslate;
}

function EvalExpression(arrVal) {
  var x = 0;
  if (arrVal.length == 5) {
    var arrValue1 = parseFloat(arrVal[1]);
    var arrValue2 = parseFloat(arrVal[2]);
    var arrValue3 = parseFloat(arrVal[3]);
    var arrValue4 = parseFloat(arrVal[4]);
    if (arrVal[0] == "svg-x1") {
      x = Math.round(((arrValue1 - Math.cos(arrValue4) * arrValue2 + Math.sin(arrValue4) * arrValue3) / 360000), 2);
    } else if (arrVal[0] == "svg-y1") {
      x = Math.round(((arrValue1 - Math.sin(arrValue4) * arrValue2 - Math.cos(arrValue4) * arrValue3) / 360000), 2);
    } else if (arrVal[0] == "svg-x2") {
      x = Math.round(((arrValue1 + Math.cos(arrValue4) * arrValue2 - Math.sin(arrValue4) * arrValue3) / 360000), 2);
    } else if (arrVal[0] == "svg-y2") {
      x = Math.round(((arrValue1 + Math.sin(arrValue4) * arrValue2 + Math.cos(arrValue4) * arrValue3) / 360000), 2);
    }
  }
  return x + "cm";
}

function EvalCalloutAdjustment(arrVal) {
  var drawMod = "";
  var callAdjVal = arrVal[0];

  var X = parseFloat(arrVal[1]);
  var Y = parseFloat(arrVal[2]);
  var CX = parseFloat(arrVal[3]);
  var CY = parseFloat(arrVal[4]);
  var flipH = parseInt(arrVal[5]);
  var flipV = parseInt(arrVal[6]);
  var rot = parseFloat(arrVal[7]);

  var xCenter = (X + CX / 2);
  var yCenter = (Y + CY / 2);
  var ang = ((rot / 60000) * (Math.PI / 180.0));

  var xCtrBy2;
  if (flipH == 1) {
    xCtrBy2 = ((-1) * (CX / 2));
  } else {
    xCtrBy2 = (CX / 2);
  }
  var yCtrBy2;
  if (flipV == 1) {
    yCtrBy2 = ((-1) * (CY / 2));
  } else {
    yCtrBy2 = (CY / 2);
  }

  var X1;
  X1 = (xCenter - Math.cos(ang) * xCtrBy2 + Math.sin(ang) * yCtrBy2);

  var Y1;
  Y1 = (yCenter - Math.sin(ang) * xCtrBy2 - Math.cos(ang) * yCtrBy2);

  var X2;
  X2 = (xCenter + Math.cos(ang) * xCtrBy2 - Math.sin(ang) * yCtrBy2);

  var Y2;
  Y2 = (yCenter + Math.sin(ang) * xCtrBy2 + Math.cos(ang) * yCtrBy2);

  X1 = Math.round((X1 / 360000), 3);
  Y1 = Math.round((Y1 / 360000), 3);
  X2 = Math.round((X2 / 360000), 3);
  Y2 = Math.round((Y2 / 360000), 3);

  var width;
  width = (X2 - X1);

  var height;
  height = (Y2 - Y1);

  if (callAdjVal.trim() == "Callout-AdjNotline") {
    var fm1 = 0.0;
    var fm2 = 0.0;
    if (arrVal[8] != "") {
      fm1 = parseFloat(arrVal[8]);
    }
    if (arrVal[9] != "") {
      fm2 = parseFloat(arrVal[9]);
    }

    var dxPos;
    dxPos = (width * fm1 / 100000);

    var dyPos;
    dyPos = (height * fm2 / 100000);

    var dxFinal;
    dxFinal = ((width / 2) + dxPos);

    var dyFinal;
    dyFinal = ((height / 2) + dyPos);

    var viewWidth = 21600;
    var viewHeight = 21600;

    var viewdxFinal;
    viewdxFinal = (dxFinal / width * viewWidth);

    var viewdyFinal;
    viewdyFinal = (dyFinal / height * viewHeight);

    drawMod = viewdxFinal + " " + viewdyFinal;
  }

  if ((callAdjVal.trim() == "Callout-AdjLine1") || (callAdjVal.trim() == "Callout-AdjLine2") || (callAdjVal.trim() == "Callout-AdjLine3")) {
    var fm1 = 0.0;
    var fm2 = 0.0;
    var fm3 = 0.0;
    var fm4 = 0.0;
    var fm5 = 0.0;
    var fm6 = 0.0;
    var fm7 = 0.0;
    var fm8 = 0.0;

    if (callAdjVal.trim() == "Callout-AdjLine1") {
      if (arrVal[8] != "") {
        fm1 = parseFloat(arrVal[8]);
      }
      if (arrVal[9] != "") {
        fm2 = parseFloat(arrVal[9]);
      }
      if (arrVal[10] != "") {
        fm3 = parseFloat(arrVal[10]);
      }
      if (arrVal[11] != "") {
        fm4 = parseFloat(arrVal[11]);
      }
    }

    if (callAdjVal.trim() == "Callout-AdjLine2") {
      if (arrVal[8] != "") {
        fm1 = parseFloat(arrVal[8]);
      }
      if (arrVal[9] != "") {
        fm2 = parseFloat(arrVal[9]);
      }
      if (arrVal[10] != "") {
        fm3 = parseFloat(arrVal[10]);
      }
      if (arrVal[11] != "") {
        fm4 = parseFloat(arrVal[11]);
      }
      if (arrVal[12] != "") {
        fm5 = parseFloat(arrVal[12]);
      }
      if (arrVal[13] != "") {
        fm6 = parseFloat(arrVal[13]);
      }
    }

    if (callAdjVal.trim() == "Callout-AdjLine3") {
      if (arrVal[8] != "") {
        fm1 = parseFloat(arrVal[8]);
      }
      if (arrVal[9] != "") {
        fm2 = parseFloat(arrVal[9]);
      }
      if (arrVal[10] != "") {
        fm3 = parseFloat(arrVal[10]);
      }
      if (arrVal[11] != "") {
        fm4 = parseFloat(arrVal[11]);
      }
      if (arrVal[12] != "") {
        fm5 = parseFloat(arrVal[12]);
      }
      if (arrVal[13] != "") {
        fm6 = parseFloat(arrVal[13]);
      }
      if (arrVal[14] != "") {
        fm7 = parseFloat(arrVal[14]);
      }
      if (arrVal[15] != "") {
        fm8 = parseFloat(arrVal[15]);
      }
    }

    var viewWidth = 21600;
    var viewHeight = 21600;

    var dxPos;
    dxPos = (width * fm1 / 100);
    var dxFinal;
    dxFinal = ((width / 2) + dxPos);
    var viewdxFinal;
    viewdxFinal = (dxFinal / width * viewWidth);
    viewdxFinal = (viewdxFinal / 1000);

    var dyPos;
    dyPos = (height * fm2 / 100);
    var dyFinal;
    dyFinal = ((height / 2) + dyPos);
    var viewdyFinal;
    viewdyFinal = (dyFinal / height * viewHeight);
    viewdyFinal = (viewdyFinal / 1000);

    var dxPos1;
    dxPos1 = (width * fm3 / 100);
    var dxFinal1;
    dxFinal1 = ((width / 2) + dxPos1);
    var viewdxFinal1;
    viewdxFinal1 = (dxFinal1 / width * viewWidth);

    viewdxFinal1 = (viewdxFinal1 / 1000);

    var dyPos1;
    dyPos1 = (height * fm4 / 100);
    var dyFinal1;
    dyFinal1 = ((height / 2) + dyPos1);
    var viewdyFinal1;
    viewdyFinal1 = (dyFinal1 / height * viewHeight);

    viewdyFinal1 = (viewdyFinal1 / 1000);

    var dxPos2;
    dxPos2 = (width * fm5 / 100);
    var dxFinal2;
    dxFinal2 = ((width / 2) + dxPos2);
    var viewdxFinal2;
    viewdxFinal2 = (dxFinal2 / width * viewWidth);

    viewdxFinal2 = (viewdxFinal2 / 1000);

    var dyPos2;
    dyPos2 = (height * fm6 / 100);
    var dyFinal2;
    dyFinal2 = ((height / 2) + dyPos2);
    var viewdyFinal2;
    viewdyFinal2 = (dyFinal2 / height * viewHeight);

    viewdyFinal2 = (viewdyFinal2 / 1000);

    var dxPos3;
    dxPos3 = (width * fm7 / 100);
    var dxFinal3;
    dxFinal3 = ((width / 2) + dxPos3);
    var viewdxFinal3;
    viewdxFinal3 = (dxFinal3 / width * viewWidth);

    viewdxFinal3 = (viewdxFinal3 / 1000);

    var dyPos3;
    dyPos3 = (height * fm8 / 100);
    var dyFinal3;
    dyFinal3 = ((height / 2) + dyPos3);
    var viewdyFinal3;
    viewdyFinal3 = (dyFinal3 / height * viewHeight);

    viewdyFinal3 = (viewdyFinal3 / 1000);

    if (callAdjVal.trim() == "Callout-AdjLine1") {
      drawMod = viewdyFinal1 + " " + viewdxFinal1 + " " + viewdyFinal + " " + viewdxFinal;
    }

    if (callAdjVal.trim() == "Callout-AdjLine2") {
      drawMod = viewdyFinal2 + " " + viewdxFinal2 + " " + viewdyFinal1 + " " + viewdxFinal1 + " " + viewdyFinal + " " + viewdxFinal;
    }

    if (callAdjVal.trim() == "Callout-AdjLine3") {
      drawMod = viewdyFinal3 + " " + viewdxFinal3 + " " + viewdyFinal2 + " " + viewdxFinal2 + " " + viewdyFinal1 + " " + viewdxFinal1 + " " + viewdyFinal + " " + viewdxFinal;
    }
  }
  return drawMod;
}

function EvalGroupingExpression(vals) {
  var strRet = "";
  var strLineRet = "";
  var strShapeCordinates = "";
  var arrgroupShape = vals[1].split('$');
  var arrgroup = arrgroupShape[0].split('@');

  var dblgrpX;
  var dblgrpY;
  var dblgrpCX;
  var dblgrpCY;
  var dblgrpChX;
  var dblgrpChY;
  var dblgrpChCX;
  var dblgrpChCY;
  var dblgrpRot;
  var dblgrpFlipH;
  var dblgrpFlipV;

  var dblShapeX;
  var dblShapeY;
  var dblShapeCX;
  var dblShapeCY;
  var dblShapeRot;
  var dblShapeFlipH;
  var dblShapeFlipV;

  var arrShapeCordinates;
  var arrInnerGroup;
  var arrFinalRet;

  var _shapes = [];
  var TopLevelgroup;
  var Targetgroup = new OoxTransform([5495925, 3286125, 1419225, 657225, 0, 1, 1]);
  var shapeCord;
  var InnerLevelgroup;
  var Tempgroup;

  if (arrgroup.length >= 3) {
    arrInnerGroup = arrgroup[0].split(':');
    dblgrpX = parseFloat(arrInnerGroup[0]);
    dblgrpY = parseFloat(arrInnerGroup[1]);
    dblgrpCX = parseFloat(arrInnerGroup[2]);
    dblgrpCY = parseFloat(arrInnerGroup[3]);
    dblgrpChX = parseFloat(arrInnerGroup[4]);
    dblgrpChY = parseFloat(arrInnerGroup[5]);
    dblgrpChCX = parseFloat(arrInnerGroup[6]);
    dblgrpChCY = parseFloat(arrInnerGroup[7]);
    dblgrpRot = parseFloat(arrInnerGroup[8]);
    dblgrpFlipH = parseFloat(arrInnerGroup[9]);
    dblgrpFlipV = parseFloat(arrInnerGroup[10]);

    TopLevelgroup = new OoxTransform([dblgrpChX, dblgrpChY, dblgrpChCX, dblgrpChCY, dblgrpX, dblgrpY, dblgrpCX, dblgrpCY, dblgrpRot, 1, 1]);

    for (var intCount = 1; intCount < arrgroup.length - 1; intCount++) {
      arrInnerGroup = arrgroup[intCount].split(':');
      Tempgroup = TopLevelgroup;
      dblgrpX = parseFloat(arrInnerGroup[0]);
      dblgrpY = parseFloat(arrInnerGroup[1]);
      dblgrpCX = parseFloat(arrInnerGroup[2]);
      dblgrpCY = parseFloat(arrInnerGroup[3]);
      dblgrpChX = parseFloat(arrInnerGroup[4]);
      dblgrpChY = parseFloat(arrInnerGroup[5]);
      dblgrpChCX = parseFloat(arrInnerGroup[6]);
      dblgrpChCY = parseFloat(arrInnerGroup[7]);
      dblgrpRot = parseFloat(arrInnerGroup[8]);
      dblgrpFlipH = parseFloat(arrInnerGroup[9]);
      dblgrpFlipV = parseFloat(arrInnerGroup[10]);
      InnerLevelgroup = new OoxTransform([dblgrpChX, dblgrpChY, dblgrpChCX, dblgrpChCY, dblgrpX, dblgrpY, dblgrpCX, dblgrpCY, dblgrpRot, 1, 1]);
      Targetgroup = new OoxTransform(Tempgroup, InnerLevelgroup);
      TopLevelgroup = Targetgroup;
    }
    arrShapeCordinates = arrgroupShape[1].split(':');
    dblShapeX = parseFloat(arrShapeCordinates[1]);
    dblShapeY = parseFloat(arrShapeCordinates[2]);
    dblShapeCX = parseFloat(arrShapeCordinates[3]);
    dblShapeCY = parseFloat(arrShapeCordinates[4]);
    dblShapeRot = parseFloat(arrShapeCordinates[5]);
    dblShapeFlipH = parseFloat(arrShapeCordinates[6]);
    dblShapeFlipV = parseFloat(arrShapeCordinates[7]);
    if (arrgroupShape[1].indexOf("Line") >= 0) {
      if (dblShapeFlipH == 0) dblShapeFlipH = -1;
      if (dblShapeFlipV == 0) dblShapeFlipV = -1;
    }
    _shapes = [];
    if (arrgroupShape[1].indexOf("Line") >= 0) {
      shapeCord = CreateLine(dblShapeX, dblShapeY, dblShapeCX, dblShapeCY, dblShapeRot, dblShapeFlipH, dblShapeFlipV);
    } else {
      shapeCord = new OoxTransform([dblShapeX, dblShapeY, dblShapeCX, dblShapeCY, dblShapeRot, 1, 1]);
    }
    _shapes.push(new OoxTransform([Targetgroup, shapeCord]));
  } else if (arrgroup.length == 2) {
    arrInnerGroup = arrgroup[0].split(':');
    dblgrpX = parseFloat(arrInnerGroup[0]);
    dblgrpY = parseFloat(arrInnerGroup[1]);
    dblgrpCX = parseFloat(arrInnerGroup[2]);
    dblgrpCY = parseFloat(arrInnerGroup[3]);
    dblgrpChX = parseFloat(arrInnerGroup[4]);
    dblgrpChY = parseFloat(arrInnerGroup[5]);
    dblgrpChCX = parseFloat(arrInnerGroup[6]);
    dblgrpChCY = parseFloat(arrInnerGroup[7]);
    dblgrpRot = parseFloat(arrInnerGroup[8]);
    TopLevelgroup = new OoxTransform([dblgrpChX, dblgrpChY, dblgrpChCX, dblgrpChCY, dblgrpX, dblgrpY, dblgrpCX, dblgrpCY, dblgrpRot, 1, 1]);
    arrShapeCordinates = arrgroupShape[1].split(':');
    dblShapeX = parseFloat(arrShapeCordinates[1]);
    dblShapeY = parseFloat(arrShapeCordinates[2]);
    dblShapeCX = parseFloat(arrShapeCordinates[3]);
    dblShapeCY = parseFloat(arrShapeCordinates[4]);
    dblShapeRot = parseFloat(arrShapeCordinates[5]);
    dblShapeFlipH = parseFloat(arrShapeCordinates[6]);
    dblShapeFlipV = parseFloat(arrShapeCordinates[7]);

    if (arrgroupShape[1].indexOf("Line") >= 0) {
      if (dblShapeFlipH == 0) dblShapeFlipH = -1;
      if (dblShapeFlipV == 0) dblShapeFlipV = -1;
    }
    _shapes = [];

    if (arrgroupShape[1].indexOf("Line") >= 0) {
      shapeCord = CreateLine(dblShapeX, dblShapeY, dblShapeCX, dblShapeCY, dblShapeRot, dblShapeFlipH, dblShapeFlipV);
    } else {
      shapeCord = new OoxTransform([dblShapeX, dblShapeY, dblShapeCX, dblShapeCY, dblShapeRot, 1, 1]);
    }
    _shapes.push(new OoxTransform([TopLevelgroup, shapeCord]));
  }
  _shapes.forEach(function(shape) {
    strRet = shape.GetOdf();
    strLineRet = shape.GetLineOdf();
  });

  if (arrgroupShape[1].indexOf("Line") >= 0) {
    arrFinalRet = strLineRet.split('@');
    if (vals[0].indexOf("X1") >= 0) {
      if (arrFinalRet[1].indexOf("NaN") >= 0) {
        strShapeCordinates = "0cm";
      } else {
        strShapeCordinates = arrFinalRet[0];
      }
    } else if (vals[0].indexOf("Y1") >= 0) {
      if (arrFinalRet[2].indexOf("NaN") >= 0) {
        strShapeCordinates = "0cm";
      } else {
        strShapeCordinates = arrFinalRet[1];
      }
    } else if (vals[0].indexOf("X2") >= 0) {
      if (arrFinalRet[3].indexOf("NaN") >= 0) {
        strShapeCordinates = "0cm";
      } else {
        strShapeCordinates = arrFinalRet[2];
      }
    } else if (vals[0].indexOf("Y2") >= 0) {
      if (arrFinalRet[3].indexOf("NaN") >= 0) {
        strShapeCordinates = "0cm";
      } else {
        strShapeCordinates = arrFinalRet[3];
      }
    }
  } else {
    arrFinalRet = strRet.split('@');
    if (arrFinalRet[0] == "YESROT") {
      if (vals[0].indexOf("Width") >= 0) {
        if (arrFinalRet[1].indexOf("NaN") >= 0) {
          strShapeCordinates = "0cm";
        } else {
          strShapeCordinates = arrFinalRet[1];
        }
      } else if (vals[0].indexOf("Height") >= 0) {
        if (arrFinalRet[2].indexOf("NaN") >= 0) {
          strShapeCordinates = "0cm";
        } else {
          strShapeCordinates = arrFinalRet[2];
        }
      } else if (vals[0].indexOf("DrawTranform") >= 0) {
        if (arrFinalRet[3].indexOf("NaN") >= 0) {
          strShapeCordinates = "0cm";
        } else {
          strShapeCordinates = arrFinalRet[3];
        }
      }
    } else if (arrFinalRet[0] == "NOROT") {
      if (vals[0].indexOf("Width") >= 0) {
        if (arrFinalRet[1].indexOf("NaN") >= 0) {
          strShapeCordinates = "0cm";
        } else {
          strShapeCordinates = arrFinalRet[1];
        }
      } else if (vals[0].indexOf("Height") >= 0) {
        if (arrFinalRet[2].indexOf("NaN") >= 0) {
          strShapeCordinates = "0cm";
        } else {
          strShapeCordinates = arrFinalRet[2];
        }
      } else if (vals[0].indexOf("SVGX") >= 0) {
        if (arrFinalRet[3].indexOf("NaN") >= 0) {
          strShapeCordinates = "0cm";
        } else {
          strShapeCordinates = arrFinalRet[3];
        }
      } else if (vals[0].indexOf("SVGY") >= 0) {
        if (arrFinalRet[4].indexOf("NaN") >= 0) {
          strShapeCordinates = "0cm";
        } else {
          strShapeCordinates = arrFinalRet[4];
        }
      }
    }
  }
  return strShapeCordinates;
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
  case 'ExcelPivotField':
    var arrVal = vals[1].split('_');
    var currentValue = arrVal[0];
    var cacheValues = arrVal[1].split('+');
    var sheetValues = arrVal[2].split('+');
    if (cacheValues.length == sheetValues.length) {
      var count = 0;
      for (var i = 1; i < sheetValues.length; i++) {
        var b = 2;
        for (var k = 1; k < sheetValues.length; k++) {
          if (sheetValues[i] == sheetValues[k]) {
            count++;
            if (count > 1) {
              var modifiedValue = sheetValues[k].concat(b);
              if (sheetValues[i] != modifiedValue) {
                sheetValues[sheetValues[k].concat(b)] = k;
                b = b + 1;
              }
            }
          }
        }
        count = 0;
      }
      var j = 1;
      for (var i = 1; i < cacheValues.length; i++) {
        if (cacheValues[i] == currentValue) {
          j = i;
        }
      }
      var excelPivotField = sheetValues[j];
      if (excelPivotField != null) {
        output = excelPivotField;
      } else {
        output = currentValue;
      }
    } else {
      output = currentValue;
    }
    break;
  case 'SonataAnnotation':
    var content = vals[1].split('|');
    var style = content[content.length - 1];
    var textContent = content[0];
    if (textContent.indexOf("\n") >= 0) {
      var p = textContent.split('\n');
      for (var i = 0; i < p.length; i++) {
        if (p[i] == "") {
          output += '<text:span xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" />';
          if (i + 1 < p.length) {
            output += '</text:p>';
            output += '<text:p xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0">';
          }
        } else {
          output = '<text:span xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" text:style-name="' + style + '" >p[i]</text:span>';
          if (i + 1 < p.length) {
            output += '</text:p>';
            output += '<text:p xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0">';
          }
        }
      }
    }
    break;
  case 'sonataColumnWidth':
    output = GetColumnWidth(vals[1]);
    break;
  case 'sonataChartWidth':
    output = GetChartWidth(vals[1]);
    break;
  case 'image-props':
    var source = vals[1];
    var left = parseInt(vals[2]);
    var right = parseInt(vals[3]);
    var top = parseInt(vals[4]);
    var bottom = parseInt(vals[5]);
    var imgaeValues = ImageCopyBinary(source);
    var arrValues = imgaeValues.split(':');
    var width = parseFloat(arrValues[0]);
    var height = parseFloat(arrValues[1]);
    var res = parseFloat(arrValues[2]);
    var cx = width * 2.54 / res;
    var cy = height * 2.54 / res;
    var odpLeft = (left * cx / 100000) / 2.54;
    var odpRight = (right * cx / 100000) / 2.54;
    var odpTop = (top * cy / 100000) / 2.54;
    var odpBottom = (bottom * cy / 100000) / 2.54;
    output = "rect(".concat(parseFloat(odpTop) + "in" + " " + parseFloat(odpRight) + "in" + " " + parseFloat(odpBottom) + "in" + " " + parseFloat(odpLeft) + "in", ")");
    break;
  case 'sonataOoxFormula':
    output = GetFormula(vals[1]);
    break;
  case 'transFileName':
    output = EvaltransFileName(vals[1], vals[2]);
    break;
  case 'shadow-offset-x':
  case 'shadow-offset-y':
    output = EvalShadowExpression(vals);
    break;
  case 'shade-tint':
    output = EvalShadeExpression(vals);
    break;
  case 'TableCord-X':
  case 'TableCord-Y':
    output = EvalTableCord(vals[1]);
    break;
  case 'WordshapesFormula':
    output = EvalWordShapesFormula(vals);
    break;
  case 'Wordshapes-draw-modifier':
    output = EvalWordModifier(vals[1]);
    break;
  case 'WordshapesEnhance-Path':
    output = EvalWordEnhacePath(vals[1]);
    break;
  case 'draw-transform':
    output = EvalRotationExpression(vals[1]);
    break;
  case 'svg-x1':
  case 'svg-x2':
  case 'svg-y1':
  case 'svg-y2':
    output = EvalExpression(vals);
    break;
  case 'Callout-AdjNotline':
  case 'Callout-AdjLine1':
  case 'Callout-AdjLine2':
  case 'Callout-AdjLine3':
    output = EvalCalloutAdjustment(vals);
    break;
  case 'Group-TransformX1':
  case 'Group-TransformY1':
  case 'Group-TransformX2':
  case 'Group-TransformY2':
  case 'Group-TransformSVGX':
  case 'Group-TransformSVGY':
  case 'Group-TransformWidth':
  case 'Group-TransformHeight':
  case 'Group-TransformDrawTranform':
    output = EvalGroupingExpression(vals);
    break;
  default:
    break;
  }
  return output;
}

function ImageCopyBinary(source) {
/*  var img = new Image();
  img.onload = function(){
    console.log(img);
  };
  var blob = new Blob(zipfiles[source].asArrayBuffer(), {type: "image/jpeg"});
  var url = URL.createObjectURL(blob);
  img.src = url;
  return img.width + ":" + img.height + ":" + img.VerticalResolution;*/
  return "320:240:96";
}

function unzipFile(file, callback) {
  var reader = new FileReader();
  reader.onload = function(aEvent) {
    try {
      var zipfile = btoa(aEvent.target.result);
      var zip = JSZip();
      zip.load(zipfile, {
        base64: true
      });
      callback(zip.files);
    } catch (e) {
      callback(null);
    }
  };
  reader.onerror = function(aEvent) {
    callback(null);
  };
  reader.readAsBinaryString(file);
}

function zipFile(xmlDoc) {
  var pzipElementHeader = '<pzip:';
  var elementFooter = '>';
  var sourceAttrHeader = 'pzip:source="';
  var targetAttrHeader = 'pzip:target="';
  var namespaceHeader = 'xmlns:';
  var attrFooter = '"';
  var zipObject = {};
  for (var i = 0; i < xmlDoc.childNodes[0].childNodes.length; i++) {
    var attributes = xmlDoc.childNodes[0].childNodes[i].attributes;
    if (!attributes) {
      continue;
    }
    var xmlfilepath = attributes.getNamedItem('pzip:target');
    if (!xmlfilepath) {
      continue;
    }
    xmlfilepath = xmlfilepath.value;
    var xmlfilecontent = attributes.getNamedItem('pzip:content');
    if (!xmlfilecontent) {
      var oSerializer = new XMLSerializer();
      xmlfilecontent = oSerializer.serializeToString(xmlDoc.childNodes[0].childNodes[i].childNodes[0]);
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
        if (zipfiles[temppzipsource]) {
          zipObject[temppziptarget] = zipfiles[temppzipsource].asUint8Array();
          delete zipfiles[temppzipsource];
        }
      }
    } else {
      xmlfilecontent = xmlfilecontent.value;
    }
    zipObject[xmlfilepath] = xmlfilecontent
  }
  return zipObject;
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
var _paraId = 0;
var _sectPrId = 0;
var _insideField = 0;
var _fieldId = 0;
var _fieldLocked = 0;
var isInIndex = false;
var fieldBegin = false;
var ptitle = 'oox:p';
var stitle = 'oox:s';
var ftitle = 'oox:f';
var idtitle = 'oox:id';
var fidtitle = 'oox:fid';
var fpidtitle = 'oox:fpid';
var flockedtitle = 'oox:flocked';
var fStarttitle = 'oox:fStart';
var indextitle = 'index';
var parttitle = 'oox:part';
var ConditionalInheritancetitle = 'oox:ConditionalInheritance';
var SPREADSHEET_ML_NS = 'http://schemas.openxmlformats.org/spreadsheetml/2006/main';
var ooxnamespace = 'urn:oox';

function CopyPartXlsx(oXMLParent) {
  var nAttrLen = 0;
  if (oXMLParent.hasAttributes()) {
    var oAttrib;
    var s;
    for (nAttrLen; nAttrLen < oXMLParent.attributes.length; nAttrLen++) {
      oAttrib = oXMLParent.attributes.item(nAttrLen);
      switch (oAttrib.name.toLowerCase()) {
      case 'r':
        if (oXMLParent.nodeName.toLowerCase() == 'c' && oXMLParent.namespaceURI == SPREADSHEET_ML_NS) {
          oXMLParent.setAttributeNS(ooxnamespace, ptitle, GetColId(oAttrib.value) + '|' + GetRowId(oAttrib.value));
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
    oXMLParent.setAttributeNS(ooxnamespace, idtitle, (idSheet++).toString());
    break;
  case 'row':
    oXMLParent.setAttributeNS(ooxnamespace, idtitle, (idRow++).toString());
    break;
  case 'font':
    oXMLParent.setAttributeNS(ooxnamespace, idtitle, (idFont++).toString());
    break;
  case 'fill':
    oXMLParent.setAttributeNS(ooxnamespace, idtitle, (idFill++).toString());
    break;
  case 'border':
    oXMLParent.setAttributeNS(ooxnamespace, idtitle, (idBorder++).toString());
    break;
  case 'xf':
    oXMLParent.setAttributeNS(ooxnamespace, idtitle, (idXf++).toString());
    break;
  case 'cellStyle':
    oXMLParent.setAttributeNS(ooxnamespace, idtitle, (idCellStyle++).toString());
    break;
  case 'dxf':
    oXMLParent.setAttributeNS(ooxnamespace, idtitle, (idDxf++).toString());
    break;
  case 'si':
    // sharedStrings
    oXMLParent.setAttributeNS(ooxnamespace, idtitle, (idSi++).toString());
    break;
  case 'worksheet':
  case 'c:chartSpace':
    oXMLParent.setAttributeNS(ooxnamespace, parttitle, _partId.toString());
    break;
  case 'conditionalFormatting':
    oXMLParent.setAttributeNS(ooxnamespace, parttitle, _partId.toString());
    oXMLParent.setAttributeNS(ooxnamespace, idtitle, (idCf++).toString());
    oXMLParent.setAttributeNS(ooxnamespace, ConditionalInheritancetitle, (idCf++).toString());
    break;
  case 'col':
  case 'sheetFormatPr':
  case 'mergeCell':
  case 'drawing':
  case 'hyperlink':
  case 'c:ser':
  case 'c:val':
  case 'c:xVal':
  case 'c:cat':
  case 'c:plotArea':
  case 'c:grouping':
  case 'c:spPr':
  case 'c:errBars':
    oXMLParent.setAttributeNS(ooxnamespace, parttitle, _partId.toString());
    break;
  case "a:font":
    oXMLParent.setAttributeNS(ooxnamespace, idtitle, (idaFont++).toString());
    break;
  default:
    break;
  }
}

function CopyPartDocx(oXMLParent) {
  switch (oXMLParent.nodeName) {
  case "w:fldChar":
    var fldChartype = oXMLParent.getAttribute('w:fldCharType');
    if (fldChartype) {
      if (fldChartype == 'begin') {
        fieldBegin = true;
        _insideField++;
        _fieldId++;
      }
      if (fldChartype == 'end') {
        fieldBegin = false;
        _insideField--;
        if (_insideField == 0) {
          isInIndex = false;
        }
      }
    }
    break;
  case "w:fldCharType":
    if (oXMLParent.nodeValue == 'begin') {
      fieldBegin = true;
      _insideField++;
      _fieldId++;
    }
    if (oXMLParent.nodeValue == 'end') {
      fieldBegin = false;
      _insideField--;
      if (_insideField == 0) {
        isInIndex = false;
      }
    }
    break;
  case "w:fldLock":
    _fieldLocked = (oXMLParent.nodeValue == 'on' || oXMLParent.nodeValue == 'true' || oXMLParent.nodeValue == '1') ? 1 : 0;
    break;
  case "w:p":
    oXMLParent.setAttributeNS(ooxnamespace, idtitle, _paraId.toString());
    oXMLParent.setAttributeNS(ooxnamespace, stitle, _sectPrId.toString());
    _paraId++;
    if (isInIndex) {
      oXMLParent.setAttributeNS(ooxnamespace, indextitle, '1');
    }
    break;
  case "w:instrText":
    if (oXMLParent.textContent.toUpperCase().indexOf('TOC') >= 0 || oXMLParent.textContent.toUpperCase().indexOf('BIBLIOGRAPHY') >= 0 || oXMLParent.textContent.toUpperCase().indexOf('INDEX') >= 0) {
      isInIndex = true;
    }
    break;
  case "w:altChunk":
  case "w:bookmarkEnd":
  case "w:bookmarkStart":
  case "w:commentRangeEnd":
  case "w:commentRangeStart":
  case "w:del":
  case "w:ins":
  case "w:moveFrom":
  case "w:moveFromRangeEnd":
  case "w:moveFromRangeStart":
  case "w:moveToRangeEnd":
  case "w:moveToRangeStart":
  case "w:oMath":
  case "w:oMathPara":
  case "w:permEnd":
  case "w:permStart":
  case "w:proofErr":
  case "w:sdt":
  case "w:tbl":
    oXMLParent.setAttributeNS(ooxnamespace, idtitle, _paraId.toString());
    oXMLParent.setAttributeNS(ooxnamespace, stitle, _sectPrId.toString());
    break;
  case "w:r":
    if (_insideField > 0) {
      oXMLParent.setAttributeNS(ooxnamespace, ftitle, _insideField.toString());
      oXMLParent.setAttributeNS(ooxnamespace, fidtitle, _fieldId.toString());
      oXMLParent.setAttributeNS(ooxnamespace, fpidtitle, _paraId.toString());
      oXMLParent.setAttributeNS(ooxnamespace, flockedtitle, _fieldLocked.toString());
      if (fieldBegin) {
        oXMLParent.setAttributeNS(ooxnamespace, fStarttitle, '1');
        fieldBegin = false;
        _fieldLocked = 0;
      }
    }
    break;
  case "w:sectPr":
    oXMLParent.setAttributeNS(ooxnamespace, stitle, _sectPrId.toString());
    _sectPrId++;
    break;
  case "w:fldSimple":
    if (oXMLParent.hasChildNodes()) {
      _insideField++;
    }
    break;
  default:
    break;
  }
}

function copyPartBeforeTransform(oXMLParent, fileType) {
  if (oXMLParent.hasChildNodes()) {
    for (var nItem = 0; nItem < oXMLParent.childNodes.length; nItem++) {
      if (oXMLParent.childNodes.item(nItem).nodeType === 1) {
        copyPartBeforeTransform(oXMLParent.childNodes.item(nItem), fileType);
      }
    }
  }
  if (fileType == 'docx') {
    CopyPartDocx(oXMLParent);
  } else if (fileType == 'xlsx') {
    CopyPartXlsx(oXMLParent);
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

function generateOdfxml(xmlGroup, fileType) {
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
  var parser;
  var xmlDoc;
  for (var i = 0; i < xmlGroup.length; i++) {
    var zipfile = zipfiles[xmlGroup[i].name];
    if (!zipfile || !zipfile._data) {
      continue;
    }
    delete zipfiles[xmlGroup[i].name];
    var tempheader;
    if (xmlGroup[i].id) {
      tempheader = contentIdheader.replace('partname', xmlGroup[i].name);
      tempheader = tempheader.replace('parttype', xmlGroup[i].type);
      tempheader = tempheader.replace('partrId', xmlGroup[i].id);
    } else {
      tempheader = contentheader.replace('partname', xmlGroup[i].name);
      tempheader = tempheader.replace('parttype', xmlGroup[i].type);
    }
    xmlfile = xmlfile + tempheader;
    parser = new DOMParser();
    xmlDoc = parser.parseFromString(zipfile.asText(), 'text/xml');
    var oSerializer = new XMLSerializer();
    xmlfile = xmlfile + oSerializer.serializeToString(xmlDoc.childNodes[0]);
    xmlfile = xmlfile + contentfooter;
  }
  xmlfile = xmlfile + filefooter;
  return xmlfile;
}

var pxsi = {};

function copyPartAfterTransform(oXMLParent) {
  if (oXMLParent.hasChildNodes()) {
    for (var nItem = 0; nItem < oXMLParent.childNodes.length; nItem++) {
      if (oXMLParent.childNodes.item(nItem).nodeName == 'pxsi:v') {
        var num = oXMLParent.childNodes.item(nItem).textContent;
        oXMLParent.removeChild(oXMLParent.childNodes.item(nItem));
        oXMLParent.textContent = pxsi[num];
        //nItem--;
      } else {
        if (oXMLParent.childNodes.item(nItem).nodeName == 'pxsi:si') {
          var numberAttr = oXMLParent.childNodes.item(nItem).getAttribute('pxsi:number');
          pxsi[numberAttr] = oXMLParent.childNodes.item(nItem).textContent;
        }
        if (oXMLParent.childNodes.item(nItem).nodeType === 1) {
          copyPartAfterTransform(oXMLParent.childNodes.item(nItem));
        }
        if (oXMLParent.childNodes.item(nItem).nodeName == 'pxsi:sst') {
          oXMLParent.removeChild(oXMLParent.childNodes.item(nItem));
          nItem--;
        }
      }
    }
  }
  var nAttrLen = 0;
  var xmlString;
  if (oXMLParent.hasAttributes()) {
    var oAttrib;
    var s;
    for (nAttrLen; nAttrLen < oXMLParent.attributes.length; nAttrLen++) {
      oAttrib = oXMLParent.attributes.item(nAttrLen);
      xmlString = replaceOoc(oAttrib.value);
      if (xmlString) {
        oXMLParent.setAttribute(oAttrib.name, xmlString);
      }
    }
  }
  xmlString = replaceOoc(oXMLParent.nodeValue);
  if (xmlString) {
    oXMLParent.nodeValue = xmlString;
  }
}

function replaceOoc(xmlString) {
  var newString;
  var startString = 'ooc-';
  var endString = '-ooe';
  var attrString = '-oop-';
  var startIndex = 0;
  if (!xmlString) {
    return null;
  }
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
    newString = xmlString;
  }
  return newString;
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
  var parser = new DOMParser();
  var xmlDoc = parser.parseFromString(xmlFile, 'text/xml');
  xmlFile = '';
  if (fileType != 'pptx') {
    copyPartBeforeTransform(xmlDoc, fileType);
  }
  var xslStylesheet;
  var xsltProcessor = new XSLTProcessor();
  var ooxXMLHTTPRequest = new XMLHttpRequest();
  ooxXMLHTTPRequest.open('GET', xslFile, false);
  ooxXMLHTTPRequest.send(null);
  xslStylesheet = ooxXMLHTTPRequest.responseXML;
  xsltProcessor.importStylesheet(xslStylesheet);

  var newDocument = xsltProcessor.transformToDocument(xmlDoc);
  if (!newDocument.childNodes || newDocument.childNodes.length == 0) {
    return null;
  }
  copyPartAfterTransform(newDocument);
  return newDocument;
}
var OOX_DOCUMENT_RELATIONSHIP_TYPE = "http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument";

function analysisOox(fileType) {
  var xmlGroup = [];
  if (!zipfiles[Content_TypesXml]) {
    return null;
  }
  var documentjson;
  var parser = new DOMParser();
  var xmlDoc = parser.parseFromString(zipfiles[Content_TypesXml].asText(), 'text/xml');
  var attributes = xmlDoc.childNodes[0].attributes;
  if (!attributes) {
    return null;
  }
  var tempjson = {
    name: Content_TypesXml,
    type: attributes.getNamedItem('xmlns').value,
    id: null
  };
  xmlGroup.push(tempjson);
  for (var filename in zipfiles) {
    if (filename.substring(filename.length - rels.length, filename.length) != rels) {
      continue;
    }
    var relsparser = new DOMParser();
    var relsDoc = relsparser.parseFromString(zipfiles[filename].asText(), 'text/xml');
    attributes = relsDoc.childNodes[0].attributes;
    if (!attributes) {
      continue;
    }
    tempjson = {
      name: filename,
      type: attributes.getNamedItem('xmlns').value,
      id: null
    };
    xmlGroup.push(tempjson);
    var path = filename.substring(0, filename.indexOf(_rels));
    for (var i = 0; i < relsDoc.childNodes[0].childNodes.length; i++) {
      attributes = relsDoc.childNodes[0].childNodes[i].attributes;
      if (!attributes) {
        continue;
      }
      var tempname = attributes.getNamedItem('Target').value;
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
        type: attributes.getNamedItem('Type').value,
        id: attributes.getNamedItem('Id').value
      };
      if (tempjson.type != OOX_DOCUMENT_RELATIONSHIP_TYPE) {
        xmlGroup.push(tempjson);
      } else {
        documentjson = tempjson;
      }
    }
  }
  if (documentjson) {
    xmlGroup.push(documentjson);
  }
  return generateOdfxml(xmlGroup, fileType);
}

var zipfiles = [];
const MAX_XML_SIZE = 1024 * 1024;

function convertoox2odf(ooxFile, callback) {
  try {
    zipfiles = [];
    _name2ncname = [];
    _ncname2name = [];
    pxsi = {};
    idSheet = 0;
    idRow = 1;
    idFont = 0;
    idaFont = 0;
    idFill = 0;
    idBorder = 0;
    idXf = 0;
    idCellStyle = 0;
    idDxf = 0;
    idSi = 0;
    idCf = 0;
    _partId = 0;
    _paraId = 0;
    _sectPrId = 0;
    _insideField = 0;
    _fieldId = 0;
    _fieldLocked = 0;
    isInIndex = false;
    fieldBegin = false;
    unzipFile(ooxFile, function(zip) {
      if (!zip) {
        callback(null);
        return;
      }
      var docx = 'docx';
      var xlsx = 'xlsx';
      var pptx = 'pptx';
      var fileType = ooxFile.name.substring(ooxFile.name.length - docx.length, ooxFile.name.length);
      var xmlfile;
      var output;
      zipfiles = zip;
      switch (fileType) {
      case docx:
      case xlsx:
      case pptx:
        xmlfile = analysisOox(fileType);
        _name2ncname = [];
        _ncname2name = [];
        output = '';
        if (xmlfile) {
          if (xmlfile.length < MAX_XML_SIZE) {
            var newXmlDoc = xslTransform(xmlfile, fileType);
            if (newXmlDoc) {
              output = zipFile(newXmlDoc);
            }
          } else {
            output = 'FILE_IS_TOO_BIG';
          }
        }
        break;
      default:
        break;
      }
      callback(output);
      return;
    });
  } catch (e) {
    callback(null);
  }
}

function CreateLine(xmlX, xmlY, xmlCx, xmlCy, xmlRot, xmlFlipH, xmlFlipV) {
  var vals = [xmlX, xmlY, xmlCx, xmlCy, xmlRot, xmlFlipH, xmlFlipV];
  var tmp = new OoxTransform(vals);
  var xy1 = tmp.Transform(tmp._x, tmp._y);
  var xy2 = tmp.Transform(tmp._x + tmp._cx, tmp._y + tmp._cy);
  var newX1 = xy1[0] * 360000.0;
  var newY1 = xy1[1] * 360000.0;
  var newX2 = xy2[0] * 360000.0;
  var newY2 = xy2[1] * 360000.0;
  var newFlipH = 1;
  var newFlipV = 1;
  if (newX1 > newX2) {
    var tmpX = newX2;
    newX2 = newX1;
    newX1 = tmpX;
    newFlipH = -1;
  }
  if (newY1 > newY2) {
    var tmpY = newY2;
    newY2 = newY1;
    newY1 = tmpY;
    newFlipV = -1;
  }
  var newVals = [newX1, newY1, newX2 - newX1, newY2 - newY1, newX1, newY1, newX2 - newX1, newY2 - newY1, 0, newFlipH, newFlipV];
  return new OoxTransform(newVals);
}

var OoxTransform = function OoxTransform(vals) {
  if (vals.length == 2) {
    this.init2(vals[0], vals[1]);
  } else if (vals.length == 7) {
    this.init(vals[0], vals[1], vals[2], vals[3], vals[0], vals[1], vals[2], vals[3], vals[4], vals[5], vals[6]);
  } else {
    this.init(vals[0], vals[1], vals[2], vals[3], vals[4], vals[5], vals[6], vals[7], vals[8], vals[9], vals[10]);
  }
};

OoxTransform.prototype = {
  init: function _init(xmlChx, xmlChy, xmlChcx, xmlChcy, xmlX, xmlY, xmlCx, xmlCy, xmlRot, xmlFlipH, xmlFlipV) {
    var chx = xmlChx / 360000.0;
    var chy = xmlChy / 360000.0;
    var chcx = xmlChcx / 360000.0;
    var chcy = xmlChcy / 360000.0;
    var x = xmlX / 360000.0;
    var y = xmlY / 360000.0;
    var cx = xmlCx / 360000.0;
    var cy = xmlCy / 360000.0;
    var rot = xmlRot / 60000.0 * (Math.PI / 180.0);
    var flipH = xmlFlipH;
    var flipV = xmlFlipV;

    this._x = chx;
    this._y = chy;
    this._cx = chcx;
    this._cy = chcy;
    this._scaleX = this.SafeScale(cx, chcx);
    this._scaleY = this.SafeScale(cy, chcy);
    this._rot = rot;
    this._flipH = flipH;
    this._flipV = flipV;
    this.CreateMatrix(chx, chy, chcx, chcy, x, y, cx, cy, rot, this._flipH, this._flipV);
  },

  init2: function _init2(outer, inner) {
    this._x = inner._x;
    this._y = inner._y;
    this._cx = inner._cx;
    this._cy = inner._cy;
    this._rot = this.Normalize(outer._rot + inner._rot);
    this._flipH = outer._flipH * inner._flipH;
    this._flipV = outer._flipV * inner._flipV;
    this._scaleX = outer._scaleX * inner._scaleX;
    this._scaleY = outer._scaleY * inner._scaleY;

    var m = this.Multiplication(outer._transform, inner._transform);
    var newCenterX = m[0] * (this._x + this._cx / 2.0) + m[1] * (this._y + this._cy / 2.0) + m[3];
    var newCenterY = m[3] * (this._x + this._cx / 2.0) + m[4] * (this._y + this._cy / 2.0) + m[5];
    var newCx = this._cx * this._scaleX;
    var newCy = this._cy * this._scaleY;
    var newX = newCenterX - newCx / 2.0;
    var newY = newCenterY - newCy / 2.0;
    this.CreateMatrix(this._x, this._y, this._cx, this._cy, newX, newY, newCx, newCy, this._rot, this._flipH, this._flipV);
  },

  SafeScale: function _SafeScale(num, denom) {
    if (denom == 0.0) {
      return 1;
    } else {
      return num / denom;
    }
  },

  CreateMatrix: function(Bx, By, Dx, Dy, B1x, B1y, D1x, D1y, teta, Fx, Fy) {
    var scaleTranslate = [
    this.SafeScale(D1x, Dx), 0.0, B1x - this.SafeScale(D1x, Dx) * Bx, 0.0, this.SafeScale(D1y, Dy), B1y - this.SafeScale(D1y, Dy) * By, 0.0, 0.0, 1.0];
    var U = [
    1.0, 0.0, -(B1x + D1x / 2.0), 0.0, 1.0, -(B1y + D1y / 2.0), 0.0, 0.0, 1.0];
    var U1 = [
    1.0, 0.0, (B1x + D1x / 2.0), 0.0, 1.0, (B1y + D1y / 2.0), 0.0, 0.0, 1.0];
    var Tmp1 = [
    Math.cos(teta), -Math.sin(teta), 0.0, Math.sin(teta), Math.cos(teta), 0.0, 0.0, 0.0, 1.0];
    var Tmp2 = [
    Fx, 0.0, 0.0, 0.0, Fy, 0.0, 0.0, 0.0, 1.0];
    this._transform = this.Multiplication(this.Multiplication(this.Multiplication(this.Multiplication(U1, Tmp1), Tmp2), U), scaleTranslate);
  },

  Normalize: function _Normalize(angle) {
    if (angle >= 0) {
      angle -= 2.0 * Math.PI * (angle / (2.0 * Math.PI));
      if (angle >= Math.PI) {
        angle -= 2.0 * Math.PI;
      }
    } else {
      angle += 2.0 * Math.PI * ((-angle) / (2.0 * Math.PI));
      if (angle < -Math.PI) {
        angle += 2.0 * Math.PI;
      }
    }
    return angle;
  },

  Multiplication: function _Multiplication(m1, m2) {
    var matrix = [
    m1[0] * m2[0] + m1[1] * m2[3] + m1[2] * m2[6], m1[0] * m2[1] + m1[1] * m2[4] + m1[2] * m2[7], m1[0] * m2[2] + m1[1] * m2[5] + m1[2] * m2[8], m1[3] * m2[0] + m1[4] * m2[3] + m1[5] * m2[6], m1[3] * m2[1] + m1[4] * m2[4] + m1[5] * m2[7], m1[3] * m2[2] + m1[4] * m2[5] + m1[5] * m2[8], m1[6] * m2[0] + m1[7] * m2[3] + m1[8] * m2[6], m1[6] * m2[1] + m1[7] * m2[4] + m1[8] * m2[7], m1[6] * m2[2] + m1[7] * m2[5] + m1[8] * m2[8]];
    return matrix;
  },

  Transform: function _Transform(x, y) {
    var newXY = [this._transform[0] * x + this._transform[1] * y + this._transform[3], this._transform[3] * x + this._transform[4] * y + this._transform[5]];
    return newXY;
  },

  GetOdf: function _GetOdf() {
    var xy = this.Transform(this._x, this._y);
    if (this._rot == 0.0) {
      return "NOROT@" + this._cx * this._scaleX + "cm@" + this._cy * this._scaleY + "cm@" + xy[0] + "cm@" + xy[1] + "cm";
    } else {
      return "YESROT@" + this._cx * this._scaleX + "cm@" + this._cy * this._scaleY + "cm@rotate (" + -this._rot + ") translate (" + xy[0] + "cm " + xy[1] + "cm)";
    }
  },

  GetLineOdf: function _GetLineOdf() {
    var xy1 = this.Transform(this._x, this._y);
    var xy2 = this.Transform(this._x + this._cx, this._y + this._cy);
    return xy2[0] + "cm@" + xy2[1] + "cm@" + xy1[0] + "cm@" + xy1[1] + "cm";
  },
};

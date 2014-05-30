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
  //int intResult;
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
          while (!blnChk && intComaIndex < arrParms.Length - 1) {
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
        //else if (arrIndex[2] >= 0 && arrIndex[2] > arrIndex[1] && arrIndex[2] > arrIndex[0])
        //{
        //    strFunction = "FLOOR(";
        //    intFunction = 3;
        //    intIndex = arrIndex[2];
        //}
        //|| strFormula.Contains("CELING(") || strFormula.Contains("FLOOR("))
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
    var content = vals[1].Split('|');
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
          if (i + 1 < p.Length) {
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
    xmlfile = xmlfile + xmlDoc.children[0].outerHTML;
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
        var num = oXMLParent.childNodes.item(nItem).innerHTML;
        oXMLParent.removeChild(oXMLParent.childNodes.item(nItem));
        oXMLParent.textContent = pxsi[num];
        //nItem--;
      } else {
        if (oXMLParent.childNodes.item(nItem).nodeName == 'pxsi:si') {
          var numberAttr = oXMLParent.childNodes.item(nItem).getAttribute('pxsi:number');
          pxsi[numberAttr] = oXMLParent.childNodes.item(nItem).innerHTML;
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
        if (xmlfile) {
          var newXmlDoc = xslTransform(xmlfile, fileType);
          if (newXmlDoc) {
            output = zipFile(newXmlDoc);
          } else {
            output = null;
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
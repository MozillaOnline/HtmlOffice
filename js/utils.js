function $id(id) {
  return document.getElementById(id);
}

function formatDate(dt) {
  var y = dt.getFullYear();
  var m = dt.getMonth() + 1;
  var d = dt.getDate();
  var h = dt.getHours();
  var min = dt.getMinutes();

  var strDate = y;
  if (m < 10) {
    strDate += '0';
  }
  strDate += '-' + m + '-' + d + ' ';

  if (h < 10) {
    strDate += '0';
  }
  strDate += h + ':';

  if (min < 10) {
    strDate += '0';
  }
  strDate += min;

  return strDate;
}

function formatFileSize(size) {
  var tmp = parseInt(size /1024 /1024);
  if (tmp > 0) {
    return (parseInt(size /1024 /10.24) /100 + 'M');
  }

  return (parseInt(size /10.24) /100 + 'K');
}

function extractFileName(path) {
  var i = path.lastIndexOf('/');
  return path.substr(i + 1);
}

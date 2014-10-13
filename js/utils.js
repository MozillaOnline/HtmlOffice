function $id(id) {
  return document.getElementById(id);
}

function formatDate(dt) {
  var y = dt.getFullYear();
  var m = dt.getMonth() + 1;
  var d = dt.getDate();
  var h = dt.getHours();
  var min = dt.getMinutes();

  var strDate = y + '-';
  if (m < 10) {
    strDate += '0';
  }
  strDate += m + '-' + d + ' ';

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

// Format byte size to KBs or MBs and round it to at most two decimal places.
function formatFileSize(size) {
  function toFixed(num) {
    return Math.round(num * 100) / 100;
  }
  var kbs = toFixed(size / 1024);
  if (kbs < 1024) {
    return kbs + 'K';
  }
  return toFixed(kbs / 1024) + 'M';
}

function extractFileName(path) {
  var i = path.lastIndexOf('/');
  return path.substr(i + 1);
}

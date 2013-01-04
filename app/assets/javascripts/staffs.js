var map;  // GoogleMapを格納する変数

var shelters = new google.maps.MVCArray(); // 参集先マーカを格納する配列
var bigs     = new google.maps.MVCArray(); // 参集先拡大時のマーカを格納する配列

var before = -1; // 前回拡大した参集先マーカの位置を記憶する配列（初期値は-1）

// ページ読み込み時にマップを作成する。
function iniMap() {

  // マップの作成
  map = new google.maps.Map(
    document.getElementById("map_canvas"),{
    zoom : 7,
    center : new google.maps.LatLng(38.4344802,141.3029167),
    mapTypeId : google.maps.MapTypeId.ROADMAP
  });

  // 現在位置のマーカ表示（数字は付けない）
  var marker = new google.maps.Marker({
    position: new google.maps.LatLng(38.4344802, 141.3029167),
    map: map,
    flat: true,
    icon: 'http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=' + '|FF0000|000000'
  });

}

// 参集先のマーカ作成
function iniShelters(pos, id, name, lat, lng) {

  // 参集先候補のマーカ作成
  shelters[pos] = new google.maps.Marker({
    position: new google.maps.LatLng(lat, lng),
    map: map,
    flat: true,
    icon: 'http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=' + (pos + 1) + '|FF0000|000000'
  });

  // 拡大時のマーカ作成（最初は非表示）
  bigs[pos] = new google.maps.Marker({
    position: new google.maps.LatLng(lat, lng),
    map: map,
    flat: true,
    visible: false,
    icon: 'http://chart.apis.google.com/chart?chst=d_map_spin&chld=0.6|0|FF0000|16|b|' + (pos + 1)
  });

  // 拡大されていないマーカをクリックしたときの処理
  google.maps.event.addListener(shelters[pos], 'click', clickMarker);

  // クリックするとマーカが拡大する処理
  function clickMarker(event) {

    // クリックしたマーカを非表示にする。
    shelters[pos].setVisible(false);

    // 拡大マーカを表示する。
    bigs[pos].setVisible(true);

    // 以前に拡大したマーカを元に戻す処理
    if (before != -1) {
      bigs[before].setVisible(false);
      shelters[before].setVisible(true);
    }

    // 拡大したマーカを記憶
    before = pos;
  }

}

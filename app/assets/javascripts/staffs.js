var map;  // GoogleMapを格納する変数

var shelters = new google.maps.MVCArray(); // 参集先マーカを格納する配列
var bigs     = new google.maps.MVCArray(); // 参集先拡大時のマーカを格納する配列

var before = -1; // 前回拡大した参集先マーカの位置を記憶する配列（初期値は-1）
var currentInfoWindow; // 前回表示した吹き出しを格納する変数

// ページ読み込み時にマップを作成する。
function iniMap(lat, lng, zoom) {

  // マップの作成
  map = new google.maps.Map(
    document.getElementById("map_canvas"),{
    zoom : zoom,
    center : new google.maps.LatLng(lat, lng),
    mapTypeId : google.maps.MapTypeId.ROADMAP
  });

  // 現在位置のマーカ表示（数字は付けない）
  var marker = new google.maps.Marker({
    position: new google.maps.LatLng(lat, lng),
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
  google.maps.event.addDomListener(shelters[pos], 'click', function() {
    showShelter(pos, name);
  });

  // 拡大されたマーカをクリックしたときの処理
  google.maps.event.addDomListener(bigs[pos], 'click', function(){
    infoShelter(pos, name);
  });

}

// 参集先マーカの吹き出し表示
function infoShelter(pos, name) {

  //先に開いた情報ウィンドウがあれば、closeする
  if (currentInfoWindow) {
    currentInfoWindow.close();
  }

  // 吹き出しに表示する内容を決定する。
  var infowindow = new google.maps.InfoWindow({
    content: '参集場所：' + name
  });

  // 吹き出しを表示する。
  infowindow.open(map, bigs[pos]);

  // 開いた情報ウィンドウを記録
  currentInfoWindow = infowindow;

  // 拡大したマーカを記憶
  before = pos;

}

// 参集先リンク押下時の処理
function showShelter(pos, name) {

  // クリックしたマーカを非表示にする。
  shelters[pos].setVisible(false);

  // クリックしたマーカを非表示
  shelters[pos].setVisible(false);

  // 以前に拡大したマーカを元に戻す処理
  // 前回と違うマーカをクリックしたときのみ実行
  if (before != -1 && pos != before) {
    bigs[before].setVisible(false);
    shelters[before].setVisible(true);
  }

  // 参集先マーカ拡大
  bigs[pos].setVisible(true);

  // 吹き出し表示
  infoShelter(pos, name);

}

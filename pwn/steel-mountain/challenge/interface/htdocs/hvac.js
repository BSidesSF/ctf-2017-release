(function() {
  var sensors = ["a-1", "a-2", "b-1", "b-2", "b-3"];
  var baseUrl = "/sensor/";

  var refresh = function() {
    sensors.forEach(function(s) {
      $.ajax(baseUrl, {dataType: "json", data: {"sensor": s}}).done(function(data) {
        $('#' + s).val(data['temp'].toFixed(2) + '\xB0C');
      });
    });
  };

  refresh();
  setInterval(refresh, 10000);
}());

(function() {
  $('#setting').submit(function(event){
    var baseUrl = "/setpoint/";
    var sanitize = function(s) {
      return $('<div>').text(s).html();
    };
    $.post(baseUrl, {
      'username': sanitize($('[name="username"]').val()),
      'password': sanitize($('[name="password"]').val()),
      'setpoint': parseInt(sanitize($('[name="setpoint"]').val()))
    },
    function() {
      $('[name="username"]').val('');
      $('[name="password"]').val('');
      $('[name="setpoint"]').val('');
    });
    event.preventDefault();
  });
}());

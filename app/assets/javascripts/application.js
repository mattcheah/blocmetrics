// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require Chart.bundle
//= require chartkick
//= require_tree .


var Cheahlytics = {}

Cheahlytics.record = function(trackingCode, eventName) {
    var event = {event: {name: eventName, trackingCode: trackingCode}};

    var request = new XMLHttpRequest();
    request.open("POST", "http://Cheahlytics.mattcheah.c9users.io/api/events", true);
    request.setRequestHeader('Content-Type', 'application/json');
    request.send(JSON.stringify(event));
    
}


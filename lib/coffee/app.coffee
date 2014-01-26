domready = require "domready"
Gallery  = require "./gallery.coffee"
Tracker  = require "./tracker.coffee"

domready ->
    tracker = new Tracker
    gallery = new Gallery { container: $ '#gallery' }

    window.onfocus = -> tracker.addEvent 'in focus'
    window.onblur  = -> tracker.addEvent 'leave'

    $(window).on 'orientationchange', -> tracker.addEvent 'orientationchange', window.orientation
    
    tracker.addEvent 'start'
    tracker.trackScreenInfo()
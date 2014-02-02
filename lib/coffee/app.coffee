domready = require "domready"
Gallery  = require "./gallery.coffee"
Tracker  = require "./tracker.coffee"

domready ->
    new Gallery { container : $ '#gallery' }

    $(window).on 'orientationchange', -> Tracker.trackEvent 'Other', 'Orientation change', window.orientation
    
    Tracker.trackUniqueVisit()
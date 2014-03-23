domready = require "domready"
Gallery  = require "./gallery.coffee"
Tracker  = require "./tracker.coffee"
Utils    = require "./utils.coffee"

domready ->
    if Utils.isMobile()
        new Gallery { container : $ '#gallery' }

        $(window).on 'orientationchange', -> Tracker.trackEvent 'Other', 'Orientation change', window.orientation
        
        Tracker.trackUniqueVisit()
    else
        $('body').text 'Sorry. This gallery is a part of a research and it is availiable on mobile devices only.'
        Tracker.trackFailedAttempt()
domready = require "domready"
Gallery  = require "./gallery.coffee"
Tracker  = require "./tracker.coffee"
Utils    = require "./utils.coffee"

# TODO: app.coffee should read config?

domready ->
    if Utils.isMobile()
        new Gallery { container : $ '#gallery' }

        $(window).on 'orientationchange', -> Tracker.trackEvent { 'Orientation change' : window.orientation }
    else
        $('body').text 'Sorry. This gallery is a part of a research and it is availiable on mobile devices only.'
        Tracker.trackFailedAttempt()
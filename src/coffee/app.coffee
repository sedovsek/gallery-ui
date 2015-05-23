domready = require "domready"
Gallery  = require "./gallery.coffee"
Utils    = require "./utils.coffee"
Tracker  = require "./tracker.coffee"
Config   = require "../../config.js"

domready ->
    Tracker.init()

    if Utils.isMobile()
        new Gallery { container : $ '#gallery' }

        $(window).on 'orientationchange', -> Tracker.trackEvent { 'Orientation change' : window.orientation }
    else
        $('body').text 'Sorry. This gallery is a part of a research and it is availiable on mobile devices only.'
        Tracker.trackFailedAttempt()
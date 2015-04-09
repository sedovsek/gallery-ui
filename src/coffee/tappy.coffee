Tracker = require "./tracker.coffee"

# Gallery Tappy UI
class Tappy
    
    constructor: (options) ->
        @gallery = options.gallery

        # Touch events
        new Hammer document, { drag_lock_to_axis: true }
        $(document).on 'tap release swipeleft swiperight', (ev) => @handleTouchEvent ev

    handleTouchEvent: (ev) ->
        ev.gesture.stopPropagation()
        
        switch ev.type
            when 'release', 'swipeleft', 'swiperight'
                ev.gesture.stopDetect()
                Tracker.trackEvent 'faultyAction'

            when 'tap'
                ev.gesture.stopPropagation()
                ev.gesture.stopDetect()

                position = Tracker.calculateInteractionPosition { x: ev.gesture.center.pageX, y: ev.gesture.center.pageY }

                if position.horizontal is 'right'
                    @gallery.next()
                else
                    @gallery.prev()

module.exports = Tappy
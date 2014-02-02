Tracker = require "./tracker.coffee"

# Gallery Click UI
class Tappy
    
    constructor: (options) ->
        @gallery = options.gallery

        # Touch events
        new Hammer document, { drag_lock_to_axis: true }
        $(document).on 'tap', (ev) => @handleTapEvent ev

    handleTapEvent: (ev) ->
        ev.gesture.preventDefault()
        
        position = Tracker.calculateInteractionPosition { x: ev.gesture.center.pageX, y: ev.gesture.center.pageY }

        if position.horizontal is 'right'
            @gallery.next()
        else
            @gallery.prev()

module.exports = Tappy
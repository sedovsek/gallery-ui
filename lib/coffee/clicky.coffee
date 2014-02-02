Tracker = require "./tracker.coffee"

# Gallery Click UI
class Clicky
    
    constructor: (options) ->
        @gallery = options.gallery

        # Click events
        $(document).on 'click', (ev) => @handleClickEvent ev

    handleClickEvent: (ev) ->
        pos = Tracker.calculateInteractionPosition { x: ev.pageX, y: ev.pageY }
        
        if pos.horizontal is 'right'
            @gallery.next()
        else
            @gallery.prev()

module.exports = Clicky
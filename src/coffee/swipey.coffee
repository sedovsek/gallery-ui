# Gallery Click UI
class Swipey
    
    constructor: (options) ->
        @gallery = options.gallery

        # Touch events
        new Hammer document, { drag_lock_to_axis: true }
        $(document).on 'release dragleft dragright swipeleft swiperight', (ev) => @handleTouchEvent ev

    handleTouchEvent: (ev) ->
        ev.gesture.preventDefault()
        
        switch ev.type
            when 'dragright', 'dragleft'
                imagesOffset = -(100 / @gallery.totalImages) * @gallery.currentImage
                dragOffset = ((100 / @gallery.containerWidth) * ev.gesture.deltaX) / @gallery.totalImages
                dragOffset *= .4  if (@gallery.currentImage is 0 and ev.gesture.direction is 'right') or (@gallery.currentImage is @gallery.totalImages - 1 and ev.gesture.direction is 'left')
                
                @gallery.setContainerOffset dragOffset + imagesOffset

            when 'swipeleft'
                @gallery.next()
                ev.gesture.stopDetect()

            when 'swiperight'
                @gallery.prev()
                ev.gesture.stopDetect()

            when 'release'
                if Math.abs(ev.gesture.deltaX) > @gallery.containerWidth / 2
                    if ev.gesture.direction is 'right'
                        @gallery.prev()
                    else
                        @gallery.next()
                else
                    @gallery.showImage @gallery.currentImage, true

module.exports = Swipey
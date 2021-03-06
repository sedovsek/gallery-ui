Tracker = require "./tracker.coffee"

# Gallery Swipey UI
class Swipey
    
    constructor: (options) ->
        @gallery = options.gallery

        # Touch events
        new Hammer document, { drag_lock_to_axis: true }
        $(document).on 'tap release dragleft dragright swipeleft swiperight', (ev) => @handleTouchEvent ev

    handleTouchEvent: (ev) ->
        ev.gesture.stopPropagation()
        
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
                # Only show next/prev image if drag gesture was > 50% of a screen
                if Math.abs(ev.gesture.deltaX) > Tracker.deviceWidth / 2
                    @gallery.prev()  if ev.gesture.direction is 'right'
                    @gallery.next()  if ev.gesture.direction is 'left'
                else
                    if ev.gesture.direction in ['left', 'right']
                        Tracker.trackEvent { 'insufficientDrag' : ev.gesture.direction }

                    @gallery.showImage @gallery.currentImage, true

            when 'tap'
                ev.gesture.stopDetect()

                if @gallery.noticeShown
                    @gallery.hideNotice()
                else
                    Tracker.trackEvent { 'faultyAction' : yes }

module.exports = Swipey
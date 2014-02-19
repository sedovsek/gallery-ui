module.exports =

    init: ->
        @screen       = screen
        @deviceWidth  = self.innerWidth
        @deviceHeight = self.innerHeight

        # maybe unless iPhone/Android - disable tracker?

        # Track touch events
        new Hammer document, { drag_lock_to_axis: true }
        $(document).on 'hold
                        tap doubletap
                        swipeup swipedown swipeleft swiperight
                        transform transformstart transformend
                        rotate
                        pinch pinchin pinchout',
                    (ev) => @handleTouchEvent ev

        # Track drag events
        $(document).on 'dragup dragdown dragleft dragright
                        dragstart dragend',
                    (ev) => @handleDragEvent ev
        
    handleTouchEvent: (ev) ->
        position = @calculateInteractionPosition { x: ev.gesture.center.pageX, y: ev.gesture.center.pageY }
        
        @trackEvent ev.type, JSON.stringify position, ev.timeStamp

    handleDragEvent: (ev) ->
        # Track event when drag ends
        # Track: all drag directions, drag durtion, last timestamp
        # Direction is added only if it has changed

        @drags = [] unless @drags
        
        unless ev.type is 'dragstart' or ev.type is 'dragend'
            if ev.type isnt @lastDragDirection
                @lastDragDirection = ev.type
                @drags.push ev.type

        if ev.type is 'dragstart'
            @dragStarted = new Date().getTime()

        if ev.type is 'dragend'
            dragLasted = new Date().getTime() - @dragStarted

            @trackEvent JSON.stringify(@drags), dragLasted, ev.timeStamp

            delete @dragStarted
            delete @lastDragDirection
            delete @drags
            delete @dragEnded

    trackEvent: (category, action, label) ->
        ga 'send', 'event', category, action, label

    setUserInterface: (ui) -> @ui = ui
    getUserInterface: -> @ui

    trackUniqueVisit: ->
        ga 'set', 'title', @getUserInterface() + ' - ' + new Date().getTime()
        ga 'send', 'pageview'

    trackFailedAttempt: ->
        ga 'set', 'title', 'Desktop - ' + new Date().getTime()
        ga 'send', 'pageview'

    calculateInteractionPosition: (coordinates) ->
        # ---------------------------- #
        # |             |              #
        # |   top left  |  top right   #
        # |             |              #
        # |--------------------------- #
        # |             |              #
        # | bottom left | bottom right #
        # |             |              #
        # ---------------------------- #
        pos = {}
        pos.vertical   = if coordinates.y <= (@deviceHeight)/2 then 'bottom' else 'top'
        pos.horizontal = if coordinates.x <= (@deviceWidth)/2  then 'left'   else 'right'

        pos
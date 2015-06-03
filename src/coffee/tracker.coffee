module.exports =

    init: ->
        # Inject Tracking Pixel
        @sessionId = @getUniqueSessionsId()

        @trackingPixel = new Image()
        @trackingPixel.src = 'http://'+Config.trackerHost+':'+Config.trackerPort+'/'+'pixel.gif?event='

        @deviceWidth  = self.innerWidth
        @deviceHeight = self.innerHeight

        @storeSessionMetaData()

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

        # Track page visibility
        visProp = @_getHiddenProp()
        if visProp
            visEvtname = visProp.replace(/[H|h]idden/, '') + 'visibilitychange'
            $(document).on visEvtname, => @handleVisibilityChange()
        
    getUniqueSessionsId: ->
        Math.floor(Math.random()*100000) + '_' + new Date().getTime()

    storeSessionMetaData: ->
        @trackEvent
            'sessionStart' : @sessionId
            'userAgent'    : navigator.userAgent
            'deviceWidth'  : @deviceWidth
            'deviceHeight' : @deviceHeight

    handleTouchEvent: (ev) ->
        position = @calculateInteractionPosition { x: ev.gesture.center.pageX, y: ev.gesture.center.pageY }
        
        @trackEvent { 'gesture' : ev.type, 'position' : position }

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

            @trackEvent { 'drags' : @drags, 'duration' : dragLasted }

            delete @drags
            delete @dragStarted
            delete @lastDragDirection

    handleVisibilityChange: ->
        _isHidden = =>
            prop = @_getHiddenProp()

            if prop
                return document[prop]
            else
                return false
        
        if _isHidden()
            @trackEvent { 'visibilityHidden' : no }
        else
            @trackEvent { 'visibilityHidden' : yes }

    trackEvent: (eventData) ->
        eventData.sessionId = @sessionId
        eventData.timestamp = new Date

        req = new XMLHttpRequest()
        req.open 'GET', @trackingPixel.src.split('=')[0] + '=' + JSON.stringify eventData, true
        req.send()

    trackSelectedUi: (ui) ->
        @trackEvent { 'user-interface': ui }

    trackFailedAttempt: ->
        @trackEvent { 'device': 'desktop', 'stopSession': true }

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
        pos.vertical   = if coordinates.y <= (@deviceHeight)/2 then 'top'  else 'bottom'
        pos.horizontal = if coordinates.x <= (@deviceWidth)/2  then 'left' else 'right'

        pos

    _getHiddenProp: ->
        return 'hidden'  if 'hidden' of document

        for prefix in ['webkit', 'moz', 'ms', 'o']
            return prefix + 'Hidden'  if (prefix + 'Hidden') of document

        return false

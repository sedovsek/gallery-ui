Both     = require "./both.coffee"
Swipey   = require "./swipey.coffee"
Tappy    = require "./tappy.coffee"
Tracker  = require "./tracker.coffee"

# Gallery
class Gallery
    
    constructor: (options) ->
        @container      = $(options.container).find 'ul'
        @containerWidth = 0
        @images         = @container.find $ 'li'
        @totalImages    = @images?.length
        @currentImage   = 0

        @setConainerWidth()

        ui = @getUserInterface()

        @setGalleryUI ui

        # Randomly add notice about which gesture to use
        @notice = document.getElementById 'notice'

        if Math.round(Math.random()) is 0
            @showNotice ui
            Tracker.trackEvent { 'showNotice': true }
        else
            Tracker.trackEvent { 'showNotice': false }

    showNotice: (ui) ->
        # Tap/Swipe/Swipe or Tap
        switch ui
            when 'Tappy'  then gesture = 'Tap'
            when 'Swipey' then gesture = 'Swipe'
            when 'Both'   then gesture = 'Swipe or Tap'

        document.getElementById('gesture').innerText = gesture
        notice.classList.remove 'is-hidden'
        notice.classList.add    'animate-bounceIn'

        @btn = document.getElementById 'close-btn'
        @btn.addEventListener 'tap', @hideNotice, false
        @noticeShown = yes

    hideNotice: (e) ->
        if e
            e.stopPropagation()
            e.gesture.stopDetect()

        notice.style['opacity'] = 0
        notice.addEventListener 'transitionend webkitTransitionEnd oTransitionEnd', removeNotice, false

        removeNotice = ->
            notice.style['display'] = 'none'
            @btn.removeEventListener 'tap', @hideNotice
            @noticeShown = no

    getUserInterface: ->
        interfaces = ['Tappy', 'Swipey', 'Both']
        interfaces[Math.floor(Math.random() * interfaces.length)]

    setGalleryUI: (ui) ->
        if ui is 'Tappy'
            new Tappy { gallery : @ }
        else if ui is 'Swipey'
            new Swipey { gallery : @ }
        else
            new Both { gallery : @ }

        Tracker.trackSelectedUi ui

    showImage: (image) ->
        # When correct gesture was performed, the notice
        # is being removed if it is still present
        @hideNotice()  if @noticeShown

        if image >= @totalImages
            image = 0
        
        if image < 0
            image = @totalImages - 1
        
        image = Math.max(0, Math.min(image, @totalImages - 1))

        @currentImage = image

        offset = -((100 / @totalImages) * image)
        @setContainerOffset offset

    next: ->
        image = @currentImage + 1
        @showImage image, true
        Tracker.trackEvent { 'Next image' : image }
    
    prev: ->
        image = @currentImage - 1
        @showImage image, true
        Tracker.trackEvent { 'Previous image' : image }

    setConainerWidth: ->
        self = @
        @containerWidth = @container.width()
        @images.each -> $(@).width self.containerWidth

        @container.width @containerWidth * @totalImages

    setContainerOffset: (percent) ->
        @container.removeClass 'animate'
        @container.addClass 'animate'
        @container.css
            '-webkit-transform': 'translate3d(' + percent + '%,0,0) scale3d(1,1,1)'
            '-ms-transform': 'translate3d(' + percent + '%,0,0) scale3d(1,1,1)'
            'transform': 'translate3d(' + percent + '%,0,0) scale3d(1,1,1)'

module.exports = Gallery
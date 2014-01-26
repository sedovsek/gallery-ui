Tracker  = require "./tracker.coffee"
Clicky   = require "./clicky.coffee"
Swipey   = require "./swipey.coffee"
Tappy    = require "./tappy.coffee"

# Gallery
class Gallery
    
    constructor: (options) ->
        @container      = $(options.container).find 'ul'
        @containerWidth = 0
        @images         = @container.find $ 'li'
        @totalImages    = @images?.length
        @currentImage   = 0

        @tracker = new Tracker

        @loadUserInterface()

        @setConainerWidth()

    loadUserInterface: =>
        # if Math.round(Math.random()) is 0
        #     ui = new Tappy
        # else
        #     ui = new Swipey

        ui = new Clicky { gallery : @ }

    showImage: (image, animate) ->
        if image >= @totalImages
            image = 0
        
        if image < 0
            image = @totalImages - 1
        
        image = Math.max(0, Math.min(image, @totalImages - 1))

        @currentImage = image

        offset = -((100 / @totalImages) * image)
        @setContainerOffset offset, animate

        @tracker.addEvent 'imageShown', image

    next: -> @showImage @currentImage + 1, true
    prev: -> @showImage @currentImage - 1, true

    setConainerWidth: ->
        self = @
        @containerWidth = @container.width()
        @images.each -> $(@).width self.containerWidth

        @container.width @containerWidth * @totalImages

    setContainerOffset: (percent, animate) ->
        @container.removeClass 'animate'
        @container.addClass('animate') if animate
        @container.css
            '-webkit-transform': 'translate3d(' + percent + '%,0,0) scale3d(1,1,1)'
            '-ms-transform': 'translate3d(' + percent + '%,0,0) scale3d(1,1,1)'
            'transform': 'translate3d(' + percent + '%,0,0) scale3d(1,1,1)'

module.exports = Gallery
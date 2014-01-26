class Tracker
    constructor: ->
        @screen       = screen
        @deviceWidth  = self.innerWidth
        @deviceHeight = self.innerHeight

        @info   = []
        @events = []
    
    trackPageView: (page) ->
        ga 'send', 'pageview'
        
    trackEvent: (category, action, label) ->
        ga 'send', 'event', category, action, label

    trackScreenInfo: ->
        @info.screen        = @screen
        @info.displayWidth  = @displayWidth
        @info.displayHeight = @displayHeight

    addEvent: (type, position, coordinates) ->
        @events.push { timestmamp: Date.now(), type : type, position : position, coordinates : coordinates }

        # @events.forEach (e) ->
        #     console.log e.type

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

module.exports = Tracker
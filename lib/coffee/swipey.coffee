Gallery = require "./gallery.coffee"

# Gallery Swipe UI
class Swipey extends Gallery
    constructor: ->
        $(document).on 'swipeLeft', (e) ->
            console.log 'swipe Left'
            @moveLeft

        $(document).on 'swipeRight', (e) ->
            console.log 'swipe Right'
            @moveRight

module.exports = Swipey
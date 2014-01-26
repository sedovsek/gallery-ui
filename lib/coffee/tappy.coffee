Gallery = require './gallery.coffee'

# Gallery Tap UI
class Tappy extends Gallery
    constructor: ->
        $(document).on 'tap', (e) ->
            console.log 'tapped Left side'
            @moveLeft

        $(document).on 'tap', (e) ->
            console.log 'tapped Right side'
            @moveRight

module.exportss = Tappy
module.exports =

    isMobile: ->
        @isIOS() or @isAndroid()

    isAndroid: ->
        navigator.userAgent.match /Android/

    isIOS: ->
        navigator.userAgent.match /(iPhone|iPod|iPad)/
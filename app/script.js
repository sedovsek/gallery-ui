(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
Config = {
    "trackerPort" : "80",
    "trackerHost" : "uitracker-sedovsek.rhcloud.com"
}
},{}],2:[function(require,module,exports){
/*!
  * domready (c) Dustin Diaz 2012 - License MIT
  */
!function (name, definition) {
  if (typeof module != 'undefined') module.exports = definition()
  else if (typeof define == 'function' && typeof define.amd == 'object') define(definition)
  else this[name] = definition()
}('domready', function (ready) {

  var fns = [], fn, f = false
    , doc = document
    , testEl = doc.documentElement
    , hack = testEl.doScroll
    , domContentLoaded = 'DOMContentLoaded'
    , addEventListener = 'addEventListener'
    , onreadystatechange = 'onreadystatechange'
    , readyState = 'readyState'
    , loadedRgx = hack ? /^loaded|^c/ : /^loaded|c/
    , loaded = loadedRgx.test(doc[readyState])

  function flush(f) {
    loaded = 1
    while (f = fns.shift()) f()
  }

  doc[addEventListener] && doc[addEventListener](domContentLoaded, fn = function () {
    doc.removeEventListener(domContentLoaded, fn, f)
    flush()
  }, f)


  hack && doc.attachEvent(onreadystatechange, fn = function () {
    if (/^c/.test(doc[readyState])) {
      doc.detachEvent(onreadystatechange, fn)
      flush()
    }
  })

  return (ready = hack ?
    function (fn) {
      self != top ?
        loaded ? fn() : fns.push(fn) :
        function () {
          try {
            testEl.doScroll('left')
          } catch (e) {
            return setTimeout(function() { ready(fn) }, 50)
          }
          fn()
        }()
    } :
    function (fn) {
      loaded ? fn() : fns.push(fn)
    })
})

},{}],3:[function(require,module,exports){
var Config, Gallery, Tracker, Utils, domready;

domready = require("domready");

Gallery = require("./gallery.coffee");

Utils = require("./utils.coffee");

Tracker = require("./tracker.coffee");

Config = require("../../config.js");

domready(function() {
  Tracker.init();
  if (Utils.isMobile()) {
    new Gallery({
      container: $('#gallery')
    });
    return $(window).on('orientationchange', function() {
      return Tracker.trackEvent({
        'Orientation change': window.orientation
      });
    });
  } else {
    $('body').text('Sorry. This gallery is a part of a research and it is availiable on mobile devices only.');
    return Tracker.trackFailedAttempt();
  }
});


},{"../../config.js":1,"./gallery.coffee":5,"./tracker.coffee":8,"./utils.coffee":9,"domready":2}],4:[function(require,module,exports){
var Clicky, Tracker;

Tracker = require("./tracker.coffee");

Clicky = (function() {
  function Clicky(options) {
    var _this = this;
    this.gallery = options.gallery;
    $(document).on('click', function(ev) {
      return _this.handleClickEvent(ev);
    });
  }

  Clicky.prototype.handleClickEvent = function(ev) {
    var pos;
    pos = Tracker.calculateInteractionPosition({
      x: ev.pageX,
      y: ev.pageY
    });
    if (pos.horizontal === 'right') {
      return this.gallery.next();
    } else {
      return this.gallery.prev();
    }
  };

  return Clicky;

})();

module.exports = Clicky;


},{"./tracker.coffee":8}],5:[function(require,module,exports){
var Clicky, Gallery, Swipey, Tappy, Tracker;

Clicky = require("./clicky.coffee");

Swipey = require("./swipey.coffee");

Tappy = require("./tappy.coffee");

Tracker = require("./tracker.coffee");

Gallery = (function() {
  function Gallery(options) {
    var _ref;
    this.container = $(options.container).find('ul');
    this.containerWidth = 0;
    this.images = this.container.find($('li'));
    this.totalImages = (_ref = this.images) != null ? _ref.length : void 0;
    this.currentImage = 0;
    this.loadUserInterface();
    Tracker.trackSelectedUi();
    this.setConainerWidth();
  }

  Gallery.prototype.loadUserInterface = function() {
    if (Math.round(Math.random()) === 0) {
      Tracker.setUserInterface('Tappy');
      return new Tappy({
        gallery: this
      });
    } else {
      Tracker.setUserInterface('Swipey');
      return new Swipey({
        gallery: this
      });
    }
  };

  Gallery.prototype.showImage = function(image, animate) {
    var offset;
    if (image >= this.totalImages) {
      image = 0;
    }
    if (image < 0) {
      image = this.totalImages - 1;
    }
    image = Math.max(0, Math.min(image, this.totalImages - 1));
    this.currentImage = image;
    offset = -((100 / this.totalImages) * image);
    return this.setContainerOffset(offset, animate);
  };

  Gallery.prototype.next = function() {
    var image;
    image = this.currentImage + 1;
    this.showImage(image, true);
    return Tracker.trackEvent({
      'Next image': image
    });
  };

  Gallery.prototype.prev = function() {
    var image;
    image = this.currentImage - 1;
    this.showImage(image, true);
    return Tracker.trackEvent({
      'Previous image': image
    });
  };

  Gallery.prototype.setConainerWidth = function() {
    var self;
    self = this;
    this.containerWidth = this.container.width();
    this.images.each(function() {
      return $(this).width(self.containerWidth);
    });
    return this.container.width(this.containerWidth * this.totalImages);
  };

  Gallery.prototype.setContainerOffset = function(percent, animate) {
    this.container.removeClass('animate');
    if (animate) {
      this.container.addClass('animate');
    }
    return this.container.css({
      '-webkit-transform': 'translate3d(' + percent + '%,0,0) scale3d(1,1,1)',
      '-ms-transform': 'translate3d(' + percent + '%,0,0) scale3d(1,1,1)',
      'transform': 'translate3d(' + percent + '%,0,0) scale3d(1,1,1)'
    });
  };

  return Gallery;

})();

module.exports = Gallery;


},{"./clicky.coffee":4,"./swipey.coffee":6,"./tappy.coffee":7,"./tracker.coffee":8}],6:[function(require,module,exports){
var Swipey;

Swipey = (function() {
  function Swipey(options) {
    var _this = this;
    this.gallery = options.gallery;
    new Hammer(document, {
      drag_lock_to_axis: true
    });
    $(document).on('release dragleft dragright swipeleft swiperight', function(ev) {
      return _this.handleTouchEvent(ev);
    });
  }

  Swipey.prototype.handleTouchEvent = function(ev) {
    var dragOffset, imagesOffset;
    ev.gesture.preventDefault();
    switch (ev.type) {
      case 'dragright':
      case 'dragleft':
        imagesOffset = -(100 / this.gallery.totalImages) * this.gallery.currentImage;
        dragOffset = ((100 / this.gallery.containerWidth) * ev.gesture.deltaX) / this.gallery.totalImages;
        if ((this.gallery.currentImage === 0 && ev.gesture.direction === 'right') || (this.gallery.currentImage === this.gallery.totalImages - 1 && ev.gesture.direction === 'left')) {
          dragOffset *= .4;
        }
        return this.gallery.setContainerOffset(dragOffset + imagesOffset);
      case 'swipeleft':
        this.gallery.next();
        return ev.gesture.stopDetect();
      case 'swiperight':
        this.gallery.prev();
        return ev.gesture.stopDetect();
      case 'release':
        if (Math.abs(ev.gesture.deltaX) > this.gallery.containerWidth / 2) {
          if (ev.gesture.direction === 'right') {
            return this.gallery.prev();
          } else {
            return this.gallery.next();
          }
        } else {
          return this.gallery.showImage(this.gallery.currentImage, true);
        }
    }
  };

  return Swipey;

})();

module.exports = Swipey;


},{}],7:[function(require,module,exports){
var Tappy, Tracker;

Tracker = require("./tracker.coffee");

Tappy = (function() {
  function Tappy(options) {
    var _this = this;
    this.gallery = options.gallery;
    new Hammer(document, {
      drag_lock_to_axis: true
    });
    $(document).on('tap', function(ev) {
      return _this.handleTapEvent(ev);
    });
  }

  Tappy.prototype.handleTapEvent = function(ev) {
    var position;
    ev.gesture.preventDefault();
    position = Tracker.calculateInteractionPosition({
      x: ev.gesture.center.pageX,
      y: ev.gesture.center.pageY
    });
    if (position.horizontal === 'right') {
      return this.gallery.next();
    } else {
      return this.gallery.prev();
    }
  };

  return Tappy;

})();

module.exports = Tappy;


},{"./tracker.coffee":8}],8:[function(require,module,exports){
module.exports = {
  init: function() {
    var _this = this;
    this.sessionId = this.getUniqueSessionsId();
    this.trackingPixel = document.createElement('img');
    this.trackingPixel.src = 'http://' + Config.trackerHost + ':' + Config.trackerPort + '/' + 'pixel.gif?event=' + JSON.stringify({
      'sessionStart': this.sessionId
    });
    this.deviceWidth = self.innerWidth;
    this.deviceHeight = self.innerHeight;
    this.storeSessionMetaData();
    new Hammer(document, {
      drag_lock_to_axis: true
    });
    $(document).on('hold\
                        tap doubletap\
                        swipeup swipedown swipeleft swiperight\
                        transform transformstart transformend\
                        rotate\
                        pinch pinchin pinchout', function(ev) {
      return _this.handleTouchEvent(ev);
    });
    return $(document).on('dragup dragdown dragleft dragright\
                        dragstart dragend', function(ev) {
      return _this.handleDragEvent(ev);
    });
  },
  getUniqueSessionsId: function() {
    return Math.floor(Math.random() * 100000) + '_' + new Date().getTime();
  },
  storeSessionMetaData: function() {
    return this.trackEvent({
      'userAgent': navigator.userAgent,
      'deviceWidth': this.deviceWidth,
      'deviceHeight': this.deviceHeight
    });
  },
  handleTouchEvent: function(ev) {
    var position;
    position = this.calculateInteractionPosition({
      x: ev.gesture.center.pageX,
      y: ev.gesture.center.pageY
    });
    return this.trackEvent({
      'gesture': ev.type,
      'position': position
    });
  },
  handleDragEvent: function(ev) {
    var dragLasted;
    if (!this.drags) {
      this.drags = [];
    }
    if (!(ev.type === 'dragstart' || ev.type === 'dragend')) {
      if (ev.type !== this.lastDragDirection) {
        this.lastDragDirection = ev.type;
        this.drags.push(ev.type);
      }
    }
    if (ev.type === 'dragstart') {
      this.dragStarted = new Date().getTime();
    }
    if (ev.type === 'dragend') {
      dragLasted = new Date().getTime() - this.dragStarted;
      this.trackEvent({
        'drags': this.drags,
        'duration': dragLasted
      });
      delete this.drags;
      delete this.dragStarted;
      return delete this.lastDragDirection;
    }
  },
  trackEvent: function(eventData) {
    eventData.sessionId = this.sessionId;
    eventData.timestamp = new Date;
    return this.trackingPixel.src = this.trackingPixel.src.split('=')[0] + '=' + JSON.stringify(eventData);
  },
  setUserInterface: function(ui) {
    return this.ui = ui;
  },
  getUserInterface: function() {
    return this.ui;
  },
  trackSelectedUi: function() {
    return this.trackEvent({
      'user-interface': this.getUserInterface()
    });
  },
  trackFailedAttempt: function() {
    return this.trackEvent({
      'device': 'desktop',
      'stopSession': true
    });
  },
  calculateInteractionPosition: function(coordinates) {
    var pos;
    pos = {};
    pos.vertical = coordinates.y <= this.deviceHeight / 2 ? 'top' : 'bottom';
    pos.horizontal = coordinates.x <= this.deviceWidth / 2 ? 'left' : 'right';
    return pos;
  }
};


},{}],9:[function(require,module,exports){
module.exports = {
  isMobile: function() {
    return this.isIOS() || this.isAndroid();
  },
  isAndroid: function() {
    return navigator.userAgent.match(/Android/);
  },
  isIOS: function() {
    return navigator.userAgent.match(/(iPhone|iPod|iPad)/);
  }
};


},{}]},{},[3])
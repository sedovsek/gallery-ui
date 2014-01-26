(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var Gallery, Tracker, domready;

domready = require("domready");

Gallery = require("./gallery.coffee");

Tracker = require("./tracker.coffee");

domready(function() {
  var gallery, tracker;
  tracker = new Tracker;
  gallery = new Gallery({
    container: $('#gallery')
  });
  window.onfocus = function() {
    return tracker.addEvent('in focus');
  };
  window.onblur = function() {
    return tracker.addEvent('leave');
  };
  $(window).on('orientationchange', function() {
    return tracker.addEvent('orientationchange', window.orientation);
  });
  tracker.addEvent('start');
  return tracker.trackScreenInfo();
});


},{"./gallery.coffee":3,"./tracker.coffee":6,"domready":7}],2:[function(require,module,exports){
var Clicky, Tracker;

Tracker = require("./tracker.coffee");

Clicky = (function() {
  function Clicky(options) {
    var _this = this;
    this.tracker = new Tracker;
    this.gallery = options.gallery;
    new Hammer(document, {
      drag_lock_to_axis: true
    });
    $(document).on('release dragleft dragright swipeleft swiperight', function(ev) {
      return _this.handleTouchEvent(ev);
    });
    $(document).on('click', function(ev) {
      return _this.handleClickEvent(ev);
    });
  }

  Clicky.prototype.handleTouchEvent = function(ev) {
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

  Clicky.prototype.handleClickEvent = function(ev) {
    var pos;
    pos = this.tracker.calculateInteractionPosition({
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


},{"./tracker.coffee":6}],3:[function(require,module,exports){
var Clicky, Gallery, Swipey, Tappy, Tracker,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Tracker = require("./tracker.coffee");

Clicky = require("./clicky.coffee");

Swipey = require("./swipey.coffee");

Tappy = require("./tappy.coffee");

Gallery = (function() {
  function Gallery(options) {
    this.loadUserInterface = __bind(this.loadUserInterface, this);
    var _ref;
    this.container = $(options.container).find('ul');
    this.containerWidth = 0;
    this.images = this.container.find($('li'));
    this.totalImages = (_ref = this.images) != null ? _ref.length : void 0;
    this.currentImage = 0;
    this.tracker = new Tracker;
    this.loadUserInterface();
    this.setConainerWidth();
  }

  Gallery.prototype.loadUserInterface = function() {
    var ui;
    return ui = new Clicky({
      gallery: this
    });
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
    this.setContainerOffset(offset, animate);
    return this.tracker.addEvent('imageShown', image);
  };

  Gallery.prototype.next = function() {
    return this.showImage(this.currentImage + 1, true);
  };

  Gallery.prototype.prev = function() {
    return this.showImage(this.currentImage - 1, true);
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


},{"./clicky.coffee":2,"./swipey.coffee":4,"./tappy.coffee":5,"./tracker.coffee":6}],4:[function(require,module,exports){
var Gallery, Swipey,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Gallery = require("./gallery.coffee");

Swipey = (function(_super) {
  __extends(Swipey, _super);

  function Swipey() {
    $(document).on('swipeLeft', function(e) {
      console.log('swipe Left');
      return this.moveLeft;
    });
    $(document).on('swipeRight', function(e) {
      console.log('swipe Right');
      return this.moveRight;
    });
  }

  return Swipey;

})(Gallery);

module.exports = Swipey;


},{"./gallery.coffee":3}],5:[function(require,module,exports){
var Gallery, Tappy,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Gallery = require('./gallery.coffee');

Tappy = (function(_super) {
  __extends(Tappy, _super);

  function Tappy() {
    $(document).on('tap', function(e) {
      console.log('tapped Left side');
      return this.moveLeft;
    });
    $(document).on('tap', function(e) {
      console.log('tapped Right side');
      return this.moveRight;
    });
  }

  return Tappy;

})(Gallery);

module.exportss = Tappy;


},{"./gallery.coffee":3}],6:[function(require,module,exports){
var Tracker;

Tracker = (function() {
  function Tracker() {
    this.screen = screen;
    this.deviceWidth = self.innerWidth;
    this.deviceHeight = self.innerHeight;
    this.info = [];
    this.events = [];
  }

  Tracker.prototype.trackPageView = function(page) {
    return ga('send', 'pageview');
  };

  Tracker.prototype.trackEvent = function(category, action, label) {
    return ga('send', 'event', category, action, label);
  };

  Tracker.prototype.trackScreenInfo = function() {
    this.info.screen = this.screen;
    this.info.displayWidth = this.displayWidth;
    return this.info.displayHeight = this.displayHeight;
  };

  Tracker.prototype.addEvent = function(type, position, coordinates) {
    return this.events.push({
      timestmamp: Date.now(),
      type: type,
      position: position,
      coordinates: coordinates
    });
  };

  Tracker.prototype.calculateInteractionPosition = function(coordinates) {
    var pos;
    pos = {};
    pos.vertical = coordinates.y <= this.deviceHeight / 2 ? 'bottom' : 'top';
    pos.horizontal = coordinates.x <= this.deviceWidth / 2 ? 'left' : 'right';
    return pos;
  };

  return Tracker;

})();

module.exports = Tracker;


},{}],7:[function(require,module,exports){
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

},{}]},{},[1])
(function() {

  window.Canvas = (function() {

    function Canvas() {
      _.extend(this, Backbone.Events);
      this.canvas = document.getElementById("canvas");
      this.context = this.canvas.getContext('2d');
      this.imgFunctions = new App.Lib.ImageFunctions(this.context);
    }

    Canvas.prototype.loadImage = function(imageUrl) {
      var image,
        _this = this;
      if (imageUrl == null) {
        imageUrl = 'images/kitten.png';
      }
      image = new Image();
      image.src = imageUrl;
      return $(image).load(function() {
        return _this.onImageLoad(image);
      });
    };

    Canvas.prototype.onImageLoad = function(image) {
      this.canvas.width = image.width;
      this.canvas.height = image.height;
      this.context.drawImage(image, 0, 0, image.width, image.height, 0, 0, this.canvas.width, this.canvas.height);
      this.originalImage = this.loadImageDataFromCanvas(image.width, image.height);
      return this.restore();
    };

    Canvas.prototype.cloneImage = function(sourceImage) {
      var imageData;
      imageData = this.context.createImageData(sourceImage.width(), sourceImage.height());
      imageData.data.set(sourceImage.data());
      return new App.Models.ImageData(imageData);
    };

    Canvas.prototype.loadImageDataFromCanvas = function(width, height) {
      var imageData;
      imageData = this.context.getImageData(0, 0, width, height);
      return new App.Models.ImageData(imageData);
    };

    Canvas.prototype.grayscaleByLuminosity = function() {
      return this.callAndWrite(this.imgFunctions.grayscaleByLuminosity);
    };

    Canvas.prototype.grayscaleByAverage = function() {
      return this.callAndWrite(this.imgFunctions.grayscaleByAverage);
    };

    Canvas.prototype.inverse = function() {
      return this.callAndWrite(this.imgFunctions.inverse);
    };

    Canvas.prototype.callAndWrite = function(func) {
      this.imageData = func.call(this, this.imageData);
      return this.writeImage(this.imageData);
    };

    Canvas.prototype.blur = function() {
      this.imageData = this.imgFunctions.blur(this.imageData, this.cloneImage(this.imageData));
      return this.writeImage(this.imageData);
    };

    Canvas.prototype.segmentImage = function() {
      var imageToRead, imageToWrite;
      imageToRead = this.imgFunctions.grayscaleByAverage(this.imageData);
      imageToWrite = this.cloneImage(this.imageData);
      this.imageData = this.imgFunctions.segmentHorizontal(imageToRead, imageToWrite);
      return this.writeImage(this.imageData);
    };

    Canvas.prototype.segment = function(bottom, top, newColor) {
      var _this = this;
      this.imageData.eachPixel(function(pixel) {
        var _ref;
        if ((bottom < (_ref = pixel.average().red) && _ref < top)) {
          pixel.setAllValues(newColor);
          return _this.imageData.setPixel(pixel);
        }
      });
      return this.writeImage(this.imageData);
    };

    Canvas.prototype.restore = function() {
      this.imageData = this.cloneImage(this.originalImage);
      return this.writeImage(this.imageData);
    };

    Canvas.prototype.writeImage = function(image) {
      this.trigger('updated');
      return this.context.putImageData(image.imageData, 0, 0);
    };

    Canvas.prototype.getSegment = function(rowOffset, columnOffset, endRow, endColumn) {
      return this.imgFunctions.getSegment(this.imageData, rowOffset, columnOffset, endRow, endColumn);
    };

    Canvas.prototype.findNextLine = function() {
      var bottom, middle, row, top;
      row = this.lastFoundSegment || 0;
      middle = this.imageData.width() / 2;
      while (this.imageData.getPixel(row, middle).red === 0) {
        row = row + 1;
      }
      top = row;
      while (this.imageData.getPixel(row, middle).red !== 0) {
        row = row + 1;
      }
      bottom = row;
      this.lastFoundSegment = bottom;
      return this.imgFunctions.getSegment(this.imageData, top, 0, bottom, this.imageData.width());
    };

    return Canvas;

  })();

}).call(this);

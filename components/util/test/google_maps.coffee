_             = require 'underscore'
sd            = require('sharify').data
should        = require 'should'
Backbone      = require 'backbone'
benv          = require 'benv'
{ getMapImageSrc, getMapLink } = require "../google_maps.coffee"

describe "PartnerLocation", ->

  beforeEach (done) ->
    @location = 'Address, City, State 00000'
    benv.setup =>
      benv.expose { $: benv.require 'components-jquery' }
      sd.GOOGLE_MAPS_API_KEY = 'GOOGLE-MAPS-API-KEY'
      done()

  describe '#mapImgSrc', ->

    it "returns a correct google maps url", ->
      getMapImageSrc(
        size: "300x300"
        center:  @location
        markers: "color:0x873ff0|#{@location}"
      ).should.equal 'http://maps.googleapis.com/maps/api/staticmap?size=300x300&center=Address%2C+City%2C+State+00000&markers=color%3A0x873ff0%7CAddress%2C+City%2C+State+00000&maptype=roadmap&sensor=false&style=lightness%3A50%7Csaturation%3A-100&zoom=16&key=GOOGLE-MAPS-API-KEY'

  describe '#googleMapsLink', ->

    it 'returns a formatted google maps url', ->
      getMapLink(@location).should.equal 'https://maps.google.com/maps?q=Address%2C+City%2C+State+00000&hnear=Address%2C+City%2C+State+00000'

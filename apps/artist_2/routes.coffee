_ = require 'underscore'
Q = require 'bluebird-q'
fs = require 'fs'
request = require 'superagent'
Backbone = require 'backbone'
ReferrerParser = require 'referer-parser'
{ APPLICATION_NAME } = require '../../config'
cache = require '../../lib/cache'
Artist = require '../../models/artist'
Nav = require './nav'
metaphysics = require '../../lib/metaphysics'
query = require './queries/server.coffee'
helpers = require './view_helpers'
currentShowAuction = require './components/current_show_auction/index'

@index = (req, res, next) ->
  metaphysics
    query: query
    variables: artist_id: req.params.id
  .then ({artist}) ->
    nav = new Nav artist: artist

    if (req.params.tab? or artist.href.replace("/artist/", "/artist_2/") is res.locals.sd.CURRENT_PATH)
      res.locals.sd.ARTIST = artist
      res.locals.sd.TAB = tab = req.params.tab or ''
      currentItem = currentShowAuction(artist)

      res.locals.sd.CURRENT_SHOW_AUCTION = currentItem

      res.render 'index',
        viewHelpers: helpers
        artist: artist
        tab: tab
        nav: nav
        currentItem: currentItem

    else
      res.redirect artist.href.replace "/artist/", "/artist_2/"

  .catch (e) ->
    console.log e
    next()
  .done()

@tab = (req, res, next) =>
  req.params.tab = res.locals.sd.CURRENT_PATH.split('/').pop()
  @index req, res, next

@follow = (req, res) ->
  return res.redirect "/artist_2/#{req.params.id}" unless req.user
  req.user.followArtist req.params.id,
    error: res.backboneError
    success: ->
      res.redirect "/artist_2/#{req.params.id}"

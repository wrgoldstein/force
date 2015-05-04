_ = require 'underscore'
Backbone = require 'backbone'
mediator = require '../../../lib/mediator.coffee'
PartnerLocations = require '../../../apps/artwork/components/partner_locations/index.coffee'
InquiryView = require "../../contact/inquiry.coffee"
SaleArtworkView = require '../../artwork_item/views/sale_artwork.coffee'
ContactPartnerView = require '../../contact/contact_partner.coffee'
ConfirmInquiryView = require '../../contact/confirm_inquiry.coffee'
analytics = require '../../../lib/analytics.coffee'
FlashMessage = require '../../flash/index.coffee'
{ INQUIRY_FLOW } = require('sharify').data
defaultMessage = require '../../contact/default_message.coffee'

artworkRow = -> require('../templates/artwork_row.jade') arguments...

module.exports = class ArtworkRowView extends SaleArtworkView
  displayPurchase: true

  initialize: (options = {})->
    { @$container, @model } = options
    @render()

    super

    @$('.artwork-table__cell--caption, .artwork-table__cell--image').hover \
      (=> @$('.hoverable-image-link').addClass 'is-hovered'), \
      (=> @$('.hoverable-image-link').removeClass 'is-hovered')

  render: ->
    renderedArtwork = artworkRow
      artwork: @model
      displayPurchase: @displayPurchase

    @$el = $(renderedArtwork)
    @$container.append @$el
    @pl = new PartnerLocations $el: @$el, artwork: @model

    return @$el

  contactSeller: (e) ->
    e.preventDefault()
    new ConfirmInquiryView
      artwork: @model
      partner: @model.get 'partner'
      inputMessage: defaultMessage(@model, @model.get('partner'))
      success: =>
        new FlashMessage message: 'Thank you. Your message has been sent.'
    analytics.track.funnel 'Clicked "Contact Gallery" button', @model.attributes
    analytics.snowplowStruct 'contact_gallery', 'click', @model.get('id'), 'artwork'
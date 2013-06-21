class @Modal extends ReactiveTemplate
  template: Template.modal

  events:
    'click .button-primary': 'onSubmit'

  constructor: ->
    super(arguments...)
    if @params.reactiveBody?
      @reactiveBody = @params.reactiveBody
    if @params.onSubmit?
      @onSubmit = @params.onSubmit
    # Allow modals to have a reference in the global namespace
    # XXX this breaks the principles of encapsulation, but allows modals to be
    # reusable for more documents of the same model type
    if @params.globalReference?
      App[@params.globalReference] = this

  rendered: (templateInstance) ->
    super(arguments...)
    # Inject reactive body container that can and might re-render on its in
    # the future whenever it pleases
    $body = $(templateInstance.find('.modal-body'))
    # Make sure the reactive body isn't already injected, which also assures
    # that the `render` callback is not called on child renders
    return unless $body.is(':empty')
    $body.append(@reactiveBody.createReactiveContainer())

    # Store the modal element for access to the Bootstrap Modal methods
    @$modal = $body.closest('.modal')

    # Focus on first input when modal opens. Make sure to remove any previously
    # set events in case the template renders multiple times
    @$modal.closest('.modal').off('shown').on 'shown', ->
      $(this).find('input:not([type=hidden])').first().focus()

  onSubmit: (e) =>
    ###
      Called when the primary modal button is pressed. Extend in subclasses
      or send as a constructor parameter
    ###
    e.preventDefault()

  close: ->
    @$modal.modal('hide')

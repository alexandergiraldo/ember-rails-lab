( ->
  Emberpusher = (channel, store, model) ->
    @channel = channel
    @store = store
    @model = model

    @channel.bind "created", (pushed_model) =>
      console?.log('created' + JSON.stringify(pushed_model))
      foo = @store.find(@model,pushed_model.id)
      if foo.stateManager?.currentState?.name == 'inFlight'
        # do nothing, same process created it
      else if foo.get('id')
        foo.setProperties(pushed_model)
        foo.stateManager.goToState('loaded')
      else
        @store.load(@model, pushed_model)

    @channel.bind "updated", (pushed_model) =>
      console?.log('updated' + JSON.stringify(pushed_model))
      foo = @store.find(@model,pushed_model.id)
      if foo.get('id') and foo.stateManager?.currentState?.name != 'inFlight'
        foo.setProperties(pushed_model)
        foo.stateManager.goToState('loaded')
      else
        @store.load(@model, pushed_model)

    @channel.bind "destroyed", (pushed_model) =>
      console?.log('destroyed' + JSON.stringify(pushed_model))
      foo = @store.find(@model,pushed_model.id)
      if foo.stateManager?.currentState?.name == 'inFlight'
        # nothing
      else if foo.get('id')
        foo.deleteRecord()

  @Emberpusher = Emberpusher
).call this

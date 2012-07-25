# changes the active state for nav
App.NavState = Ember.LayoutState.extend(
  navSelector: ".navbar .nav"
  enter: (stateManager, transition) ->
    @_super stateManager, transition
    $nav = $(@get("navSelector"))
    $nav.children().removeClass "active"
    selector = @get("selector") or ("." + @get("path"))
    $nav.find(selector).addClass "active"
)
# TODO - page doesn't exist for initial state change
# so initial active class isn't appended

# have to place this into the DOM ourselves
App.mainView = App.MainLayoutView.create()

App.router = Ember.RouteManager.create(
  enableLogging: true

  # every view hangs off this one
  rootView: App.mainView

  # Home
  home: App.NavState.create(
    selector: '.home'
    viewClass: App.MainHomeView
  )

  # posts stack
  posts: App.NavState.create(
    selector: ".posts"
    route: "posts"
    viewClass: App.PostsLayoutView
    # posts#index
    index: Ember.LayoutState.create(
      viewClass: App.PostsIndexView
      enter: (stateManager,transition) ->
        @_super stateManager, transition
        App.postsController.findAll()
    )
    # posts#new
    newPost: Ember.LayoutState.create(
      route: "new"
      viewClass: App.PostsNewView
    )
    # posts#show
    show: Ember.LayoutState.create(
      route: ":postId"
      viewClass: App.PostsShowView
      enter: (stateManager, transition) ->
        @_super stateManager, transition
        postId = stateManager.getPath("params.postId")
        App.postsController.selectPost(postId)
        #@get("view").set "post", post
    )
  )
)
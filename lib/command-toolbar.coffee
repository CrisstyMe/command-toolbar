
# lib/command-toolbar.coffee

fs          = require 'fs'
pathUtil    = require 'path'
ToolbarView = require './toolbar-view'

class CommandToolbar
  configDefaults: 
    alwaysShowToolbarOnLoad: yes

  activate: ->
    @state = 
      statePath: pathUtil.dirname(atom.config.getUserConfigPath()) +
                  '/command-toolbar.json'
    try 
      @state = JSON.parse fs.readFileSync @state.statePath
    catch e
      @state.opened = yes
      
    if atom.config.get 'command-toolbar.alwaysShowToolbarOnLoad'
      @state.opened = yes
    if @state.opened then @toggle yes
    
    atom.workspaceView.command "command-toolbar:toggle", => @toggle()
    
  toggle: (forceOn) ->
    if forceOn or not @state.opened
      @state.opened = yes
      @toolbarView ?= new ToolbarView @, @state
      @toolbarView.show()
      @toolbarView.saveState()
    else
      @state.opened = no
      @toolbarView.saveState()
      @toolbarView?.hide()
          
  getToolbar:     -> @toolbarView
  destroyToolbar: -> @toolbarView?.destroy()
    
  deactivate: ->
    @destroyToolbar()
    
module.exports = new CommandToolbar

if typeof console is "undefined" or typeof console.log is "undefined" or typeof console.debug is "undefined"
  window.console = 
    log: (msg) ->
      #alert("log: " + msg)
    debug: (msg) ->
      #alert("debug: " + msg)
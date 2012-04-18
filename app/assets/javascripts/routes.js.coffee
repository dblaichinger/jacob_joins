Path.map("#!/form/:tab").to () ->
  $('#wizard').tabs 'select', '#' + this.params['tab']
  $.scrollTo $('#skipstory'), 800
$ ->
  Path.listen()

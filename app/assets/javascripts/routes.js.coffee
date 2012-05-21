Path.map("#!/form/:tab").to () ->
  $('#wizard').tabs 'select', '#' + this.params['tab']
$ ->
  Path.listen()

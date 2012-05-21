Path.map("#!/:tab").to () ->
  $('#wizard').tabs 'select', '#' + this.params['tab']
$ ->
  Path.listen()

jQuery ->
  $container = $('.users')

  # Load Images
  $container.imagesLoaded () ->

    # Remove JS Fallback Margins
    do removeUserMargins = () ->
      $('.user').css
        margin: '0'

    # Packery
    $container.packery
      itemSelector: '.user'
      gutter: 13

    # Infinite Scroll
    $container.infinitescroll
      loading:
        finishedMsg: ''
        img: ''
        msgText: '<i class="fa fa-spinner fa-spin"></i>&nbsp;&nbsp;Loading...'
        selector: '#loading-users'
      navSelector  : 'nav.pagination'
      nextSelector : 'nav.pagination span.next a'
      itemSelector : '.user'
      bufferPx: 500
    , (arrayOfNewUsers) ->
      $container.append(arrayOfNewUsers)
      removeUserMargins()
      $container.packery('appended', arrayOfNewUsers)
      setUserCallbacks()

  # Users
  do setUserCallbacks = () ->
    $('.user a[data-remote]').on 'ajax:before', (e, data, status, xhr) ->
      $(this.parentNode).find('.user-loading').show()

    $('.user a[data-remote]').on 'ajax:success', (e, data, status, xhr) ->
      $container.packery 'fit', this.parentNode, 0
      $(this.parentNode).find('.user-loading').hide()

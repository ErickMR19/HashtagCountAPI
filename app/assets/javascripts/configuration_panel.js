(function ($) {
  "use strict";
  $('input.setting-field').on('change', function (event) {
    $.ajax({
      url: this.dataset.actionUrl,
      data: {new_value: this.value},
      type: 'PATCH',
      dataType: 'script'
    });
  });
}(jQuery));
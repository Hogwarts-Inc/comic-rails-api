//= require active_admin/base
//= require activeadmin_addons/all

$(document).on('DOMContentLoaded', function() {
  // Define a mapping of descriptionable types to their associated models
  var descriptionableTypeMapping = {
    'Convention': 'conventions',
    'Character': 'characters'
    // Add more mappings as needed
  };

  // Function to update the descriptionable_id select options
  function updateDescriptionableIdSelect(descriptionableType) {
    var $descriptionableIdSelect = $('.descriptionable-id-select');

    // Clear existing options
    $descriptionableIdSelect.empty();

    // Populate options based on the selected descriptionable_type
    if (descriptionableType) {
      $.get('/admin/' + descriptionableTypeMapping[descriptionableType] + '.json', function(data) {
        $.each(data, function(key, value) {
          $descriptionableIdSelect.append($('<option>', {
            value: value.id,
            text: value.name  // Replace with the appropriate attribute name
          }));
        });
      });
    }
  }

  // Initialize descriptionable_id select based on initial descriptionable_type value
  updateDescriptionableIdSelect($('.descriptionable-type-select').val());

  // Listen for changes on the descriptionable_type select
  $('.descriptionable-type-select').on('change', function() {
    var descriptionableType = $(this).val();
    updateDescriptionableIdSelect(descriptionableType);
  });
});

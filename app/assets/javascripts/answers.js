$(document).ready(
  function(){
      $('.edit-answer-link').on(
          'click', function(e){
              e.preventDefault();
              $(this).hide();
              let answerId = $(this).data('answerId');
              $('form#edit-answer-' + answerId).show();
          }
      )
  }
);

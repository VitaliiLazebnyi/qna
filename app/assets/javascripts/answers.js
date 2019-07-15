function setEventOnEditAnswerLink(){
    $('.answers').on(
        'click',
        '.edit-answer-link',
        function(e){
            e.preventDefault();
            $(this).hide();
            let answerId = $(this).data('answerId');
            $('form#edit-answer-' + answerId).removeClass('hidden');
        }
    );
}

$(document).on("turbolinks:load",
    setEventOnEditAnswerLink
);

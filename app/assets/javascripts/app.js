$(document).ready(function(){ 
	$("#new_comment").submit(function(e) {
		e.preventDefault();
		var parentInput = $(this).parent();
		var content = parentInput.find("#comment_text").val();

		$.ajax({
			type: 'post',
			url: this.action, 
			data: {
							comment:
								{
									text: content, 
									photo_id: $(this).find('#photo_id').val()
								}
						},
			dataType: 'script',
			success: function(data) {
				elem = $(".comments-read");
				last = elem.children().length - 1;
				target = $(elem)[0].scrollHeight
				elem.animate({scrollTop:target}, 500);
				}
		});

	}); 

});
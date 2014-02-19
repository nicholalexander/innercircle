$(document).ready(function(){ 
	$("#new_comment").submit(function(e) {
		e.preventDefault();
		console.log("yes")
		console.log(this)
		var parentInput = $(this).parent();
		console.log(parentInput)
		var content = parentInput.find("#comment_text").val();
		console.log(content)
		$.ajax({
			type: 'post',
			url: this.action, 
			data: {comment:
				      {text: content, 
				       photo_id: $(this).find('#photo_id').val()
				      }
				    },
			dataType: 'script'
			// success: function(data) {
			// 	$('.comments').html(data)
			
		});
	});

});


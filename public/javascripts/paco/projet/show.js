$(document).ready(function() {
	$('.toggle_terminees').click(function() {
		$(".terminee").slideToggle();
		return false
	})
	
	$('#nouvelle-tache').live("click", function() {
		$.getScript(this.href);
		return false
	})
	
	$('#new_tache').live('submit', function() {
		$.post($(this).attr('action'), $(this).serialize(), null, "script");  
    return false;
	})
})
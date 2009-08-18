function affichageConditionnel(target) {
	target = $("#date_sortie")
	afficheTargetSiTriggerNonBlanc($(this), target)
}

function afficheTargetSiTriggerNonBlanc(trigger, target) {
	if (trigger.val() == '') {
		target.hide();
	} else {
		target.show();
	}	
}

$(document).ready(function() {
	$("#tache_statut").each(affichageConditionnel)
	$("#tache_statut").keyup(affichageConditionnel)
})
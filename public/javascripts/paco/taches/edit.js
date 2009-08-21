function affichageConditionnel() {
	target = $("#date_sortie")
	$(this).val() == '' ? target.hide() : target.show()
}

$(document).ready(function() {
	$("#tache_statut").each(affichageConditionnel)
	$("#tache_statut").keyup(affichageConditionnel)
})
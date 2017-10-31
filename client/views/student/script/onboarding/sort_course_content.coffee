Template.onboarding_sort.onCreated ->
  window.topThree = [null, null, null]
	# As this is an ASYNC call we must call it here to populate the related helper.
	Meteor.call "last_selected_tags",
		(err, res) -> Session.set("selectedCourseTagsFromDB", res)

Template.onboarding_sort.helpers
	tags: () ->
		return Session.get("coursetags") || Session.get("selectedCourseTagsFromDB").courseTags || []
	errorMessage: () ->
		return Session.get("errorMessage")

Template.onboarding_sort.onRendered () ->
	dragula = require 'dragula'
	dragula({
		isContainer: (el) ->
			return el.classList.contains('dragula-container');
		accepts: (el, target, source, sibling) ->
			if target.id == 'poolContainer'
				return true;
			if target.classList.contains('dropTarget') and target.childElementCount == 0
				return true;
			return false;
	}).on('drop', (el, target, source, sibling) ->
		switch target.id
			when 'poolContainer'
				ind = topThree.indexOf(el.innerHTML)
				if ind != -1
					topThree[ind] = null
			when 'podiumContainer1' then window.topThree[0] = el.innerHTML;
			when 'podiumContainer2' then window.topThree[1] = el.innerHTML;
			when 'podiumContainer3' then window.topThree[2] = el.innerHTML;
	);

Template.onboarding_sort.events
	"click .continue": (event) ->
		first = window.topThree[0]
		second = window.topThree[1]
		third = window.topThree[2]

		if (!(first?) || !(second?) || !(third?))
			Session.set "errorMessage", "You must select your top three favourite"
			return false
		Meteor.call "storeOrderedTags", {0: first, 1: second, 2: third}
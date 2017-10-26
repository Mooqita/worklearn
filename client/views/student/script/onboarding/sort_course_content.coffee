Template.onboarding_sort.onCreated ->
  window.topThree = [null, null, null]
  window.tagPool = ["API design", "Flask", "Generators", "Iterators", "Public nudity"] # TODO get this from DB


Template.onboarding_sort.helpers
  tags: () -> return window.tagPool

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
			return false
	});
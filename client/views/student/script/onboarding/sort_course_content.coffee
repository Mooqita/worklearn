Template.onboarding_sort.onCreated ->
  window.topThree = [null, null, null]
  window.tagPool = ["API design", "Flask", "Generators", "Iterators"] # TODO get this from DB


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
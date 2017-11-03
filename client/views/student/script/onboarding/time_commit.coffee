Template.onboarding_time.onCreated () ->
	window.minHours = 2.0
	window.maxHours = 14.0

	Meteor.call "lastTimeComitted",
		(err, res) ->
			# check for previously entered value
			if err or res == NaN or res == null or res == 0
				res = 10.5 # default to 10.5 hours per week (90 mins per day)
				
			# change from hours to percent
			window.defaultPercent = ((((res - window.minHours) / (window.maxHours - window.minHours)) * 100))	
			Template.onboarding_time.PercentToHours(window.defaultPercent)

Template.onboarding_time.PercentToHours = (percentage) ->
	# Get hours from percentage
	hours = (percentage * (window.maxHours - window.minHours) / 100) + window.minHours
	# Round to .5 hours
	window.hours = (Math.round(hours * 2) / 2).toFixed(1)

Template.onboarding_time.UpdateHoursLabel = () ->
	# If whole number, remove decimal
	numHrs = if window.hours % 1 == 0 then "#{Math.round(window.hours)}" else "#{window.hours}"
	hrs = numHrs
	if parseInt(window.hours) == parseInt(window.maxHours) then hrs += "+"
	slider = $("#timeCommitSlider").data("roundSlider")
	slider.tooltip.context.innerText = hrs + "\nhours"

	dailyMins = numHrs / 7 * 60
	# round to nearest 5 mins, 0dp
	approxMins = (Math.round(dailyMins / 5) * 5).toFixed(0)
	if parseInt(window.hours) == parseInt(window.maxHours) then approxMins += "+"

	document.getElementById('approxMins').innerHTML = approxMins


Template.onboarding_time.onRendered () ->
	$.getScript("https://cdn.jsdelivr.net/npm/round-slider@1.3/dist/roundslider.min.js", () ->
			$("#timeCommitSlider").roundSlider()
			slider = $("#timeCommitSlider").data("roundSlider")
			slider.option("radius", 120)
			slider.option("circleShape", "pie")
			slider.option("sliderType", "min-range")
			slider.option("width", 14)
			slider.option("handleShape", "dot")
			slider.option("handleSize", "+18")
			slider.option("animation", false)
			slider.option("value", window.defaultPercent)
			slider.option("editableTooltip", false)
			Template.onboarding_time.UpdateHoursLabel()
		);

Template.onboarding_time.events
	"change #timeCommitSlider, drag #timeCommitSlider": (event) ->
		Template.onboarding_time.PercentToHours(event.value)
		Template.onboarding_time.UpdateHoursLabel()
	"click .continue": (event) ->
		Meteor.call "timeComitted", window.hours
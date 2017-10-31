Template.onboarding_time.onCreated () ->
	window.minHours = 2.0
	window.maxHours = 14.0

	Meteor.call "lastTimeComitted",
		(err, res) ->
			window.defaultPercent = if res? then ((((res - window.minHours) / (window.maxHours - window.minHours)) * 100)) else 80
			Template.onboarding_time.PercentToHours(window.defaultPercent)

Template.onboarding_time.PercentToHours = (percentage) ->
		# Get hours from percentage
		hours = (percentage * (window.maxHours - window.minHours) / 100) + window.minHours
		# Round to .5 hours
		window.hours = (Math.round(hours * 2) / 2).toFixed(1)

Template.onboarding_time.UpdateHoursLabel = () ->
	# If whole number, remove decimal
	hrs = if window.hours % 1 == 0 then "#{Math.round(window.hours)}" else "#{window.hours}"
	if parseInt(window.hours) == parseInt(window.maxHours) then hrs += "+"
	slider = $("#slider").data("roundSlider")
	slider.tooltip.context.innerText = hrs

Template.onboarding_time.onRendered () ->
	$.getScript("https://cdn.jsdelivr.net/npm/round-slider@1.3/dist/roundslider.min.js", () ->
			$("#slider").roundSlider()
			slider = $("#slider").data("roundSlider")
			slider.option("radius", 120)
			slider.option("width", 22)
			slider.option("endAngle", "+300")
			slider.option("handleSize", "+12")
			slider.option("animation", false)
			slider.option("value", window.defaultPercent)
			slider.option("editableTooltip", false)
			Template.onboarding_time.UpdateHoursLabel()
		);

Template.onboarding_time.events
	"change #slider, drag #slider": (event) ->
		Template.onboarding_time.PercentToHours(event.value)
		Template.onboarding_time.UpdateHoursLabel()

Template.onboarding_time.events
	"click .continue": (event) ->
		Meteor.call "timeComitted", window.hours
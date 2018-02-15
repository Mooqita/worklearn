###############################################################################
@big_five_40 = ["is the life of the party",
				"feels little concern for others",
				"is always prepared",
				"gets stressed out easily",
				"has a rich vocabulary",
				"does not talk a lot",
				"is interested in people",
				"leaves my belongings around",
				"is relaxed most of the time",
				"has difficulty understanding abstract ideas",
				"feels comfortable around people",
				"insults people",
				"pays attention to details",
				"worries about things",
				"has a vivid imagination",
				"keeps in the background",
				"sympathizes with others' feelings",
				"makes a mess of things",
				"seldom feel blue",
				"is not interested in abstract ideas",
				"starts conversations",
				"is not interested in other people's problems",
				"gets chores done right away",
				"is easily disturbed",
				"has excellent ideas",
				"has little to say",
				"has a soft heart",
				"often forgets to put things back in their proper place",
				"gets upset easily",
				"does not have a good imagination",
				"talks to a lot of different people at parties",
				"is not really interested in others",
				"likes order",
				"changes their mood a lot",
				"is quick to understand things",
				"doesn't like to draw attention to myself",
				"takes time out for others",
				"shirk their duties",
				"has frequent mood swings",
				"uses difficult words",
				"does't mind being the center of attention",
				"feels others' emotions",
				"follows a schedule",
				"gets irritated easily",
				"spends time reflecting on things",
				"is quiet around strangers",
				"makes people feel at ease",
				"is exacting in their work",
				"often feels blue",
				"is full of ideas"]

# see: https://www.psytoolkit.org/survey-library/big5-bfi-s.html
@big_five_short = [
	"worries a lot",
	"gets nervous easily",
	"remains calm in tense situations",
	"is talkative"
	"is outgoing, sociable",
	"is reserved",
	"is original, comes up with new ideas",
	"values artistic, aesthetic experiences",
	"has an active imagination",
	"is sometimes rude to others",
	"has a forgiving nature",
	"is considerate and kind to almost everyone",
	"does a thorough job",
	"tends to be lazy",
	"does things efficiently",
]

###############################################################################
@big_5_mean =
	Extroversion:
		m: 3.27
		sd: 0.89
	Agreeableness:
		m: 3.73
		sd: 0.69
	Conscientiousness:
		m: 3.63
		sd: 0.71
	Stability:
		m: 3.22
		sd: 0.84
	Openness:
		m: 3.92
		sd: 0.67


###############################################################################
@calculate_trait_40 = (trait, answers) ->
	v = (i) ->
		q = big_five_40[i-1]
		n = answers[q]

		return Number(n)

	switch trait
		when "Extroversion" then return 20 + v(1) - v(6)  + v(11) - v(16) + v(21) - v(26) + v(31) - v(36) + v(41) - v(46)
		when "Agreeableness" then return 14 - v(2) + v(7)  - v(12) + v(17) - v(22) + v(27) - v(32) + v(37) + v(42) + v(47)
		when "Conscientiousness" then return 14 + v(3) - v(8)  + v(13) - v(18) + v(23) - v(28) + v(33) - v(38) + v(43) + v(48)
		when "Stability" then return 2  + v(4) - v(9)  + v(14) - v(19) + v(24) + v(29) + v(34) + v(39) + v(44) + v(49)
		when "Openness" then return 8  + v(5) - v(10) + v(15) - v(20) + v(25) - v(30) + v(35) + v(40) + v(45) + v(50)


###############################################################################
@calculate_persona_40 = (answers) ->
	C = calculate_trait_40 "Conscientiousness", answers
	A = calculate_trait_40 "Agreeableness", answers
	E = calculate_trait_40 "Extroversion", answers
	S = calculate_trait_40 "Stability", answers
	O = calculate_trait_40 "Openness", answers

	persona = [ { label: "Stability", value: S },
							{ label: "Openness", value: O },
							{ label: "Agreeableness", value: A },
							{ label: "Extroversion", value: E },
							{ label: "Conscientiousness", value: C } ]

	return persona

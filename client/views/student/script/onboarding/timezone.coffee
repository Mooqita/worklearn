tagID = "commtagsSelectedcommtags" # this.data.method + "Selected" + category

Template.timezoneselect.helpers
  timezones: () -> return ["(UTC-12:00) International Date Line West",
    "(UTC-11:00) Co-ordinated Universal Time-11",
    "(UTC-10:00) Aleutian Islands",
    "(UTC-10:00) Hawaii",
    "(UTC-09:30) Marquesas Islands",
    "(UTC-09:00) Alaska",
    "(UTC-09:00) Co-ordinated Universal Time-09",
    "(UTC-08:00) Baja California",
    "(UTC-08:00) Co-ordinated Universal Time-08",
    "(UTC-08:00) Pacific Time (US & Canada)",
    "(UTC-07:00) Arizona",
    "(UTC-07:00) Chihuahua, La Paz, Mazatlan",
    "(UTC-07:00) Mountain Time (US & Canada)",
    "(UTC-06:00) Central America",
    "(UTC-06:00) Central Time (US & Canada)",
    "(UTC-06:00) Easter Island",
    "(UTC-06:00) Guadalajara, Mexico City, Monterrey",
    "(UTC-06:00) Saskatchewan",
    "(UTC-05:00) Bogota, Lima, Quito, Rio Branco",
    "(UTC-05:00) Chetumal",
    "(UTC-05:00) Eastern Time (US & Canada)",
    "(UTC-05:00) Haiti",
    "(UTC-05:00) Havana",
    "(UTC-05:00) Indiana (East)",
    "(UTC-04:00) Asuncion",
    "(UTC-04:00) Atlantic Time (Canada)",
    "(UTC-04:00) Caracas",
    "(UTC-04:00) Cuiaba",
    "(UTC-04:00) Georgetown, La Paz, Manaus, San Juan",
    "(UTC-04:00) Santiago",
    "(UTC-04:00) Turks and Caicos",
    "(UTC-03:30) Newfoundland",
    "(UTC-03:00) Araguaina",
    "(UTC-03:00) Brasilia",
    "(UTC-03:00) Cayenne, Fortaleza",
    "(UTC-03:00) City of Buenos Aires",
    "(UTC-03:00) Greenland",
    "(UTC-03:00) Montevideo",
    "(UTC-03:00) Punta Arenas",
    "(UTC-03:00) Saint Pierre and Miquelon",
    "(UTC-03:00) Salvador",
    "(UTC-02:00) Co-ordinated Universal Time-02",
    "(UTC-02:00) Mid-Atlantic - Old",
    "(UTC-01:00) Azores",
    "(UTC-01:00) Cabo Verde Is.",
    "(UTC) Co-ordinated Universal Time",
    "(UTC+00:00) Casablanca",
    "(UTC+00:00) Dublin, Edinburgh, Lisbon, London",
    "(UTC+00:00) Monrovia, Reykjavik",
    "(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna",
    "(UTC+01:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague",
    "(UTC+01:00) Brussels, Copenhagen, Madrid, Paris",
    "(UTC+01:00) Sarajevo, Skopje, Warsaw, Zagreb",
    "(UTC+01:00) West Central Africa",
    "(UTC+01:00) Windhoek",
    "(UTC+02:00) Amman",
    "(UTC+02:00) Athens, Bucharest",
    "(UTC+02:00) Beirut",
    "(UTC+02:00) Cairo",
    "(UTC+02:00) Chisinau",
    "(UTC+02:00) Damascus",
    "(UTC+02:00) Gaza, Hebron",
    "(UTC+02:00) Harare, Pretoria",
    "(UTC+02:00) Helsinki, Kyiv, Riga, Sofia, Tallinn, Vilnius",
    "(UTC+02:00) Jerusalem",
    "(UTC+02:00) Kaliningrad",
    "(UTC+02:00) Tripoli",
    "(UTC+03:00) Baghdad",
    "(UTC+03:00) Istanbul",
    "(UTC+03:00) Kuwait, Riyadh",
    "(UTC+03:00) Minsk",
    "(UTC+03:00) Moscow, St. Petersburg, Volgograd",
    "(UTC+03:00) Nairobi",
    "(UTC+03:30) Tehran",
    "(UTC+04:00) Abu Dhabi, Muscat",
    "(UTC+04:00) Astrakhan, Ulyanovsk",
    "(UTC+04:00) Baku",
    "(UTC+04:00) Izhevsk, Samara",
    "(UTC+04:00) Port Louis",
    "(UTC+04:00) Saratov",
    "(UTC+04:00) Tbilisi",
    "(UTC+04:00) Yerevan",
    "(UTC+04:30) Kabul",
    "(UTC+05:00) Ashgabat, Tashkent",
    "(UTC+05:00) Ekaterinburg",
    "(UTC+05:00) Islamabad, Karachi",
    "(UTC+05:30) Chennai, Kolkata, Mumbai, New Delhi",
    "(UTC+05:30) Sri Jayawardenepura",
    "(UTC+05:45) Kathmandu",
    "(UTC+06:00) Astana",
    "(UTC+06:00) Dhaka",
    "(UTC+06:00) Omsk",
    "(UTC+06:30) Yangon (Rangoon)",
    "(UTC+07:00) Bangkok, Hanoi, Jakarta",
    "(UTC+07:00) Barnaul, Gorno-Altaysk",
    "(UTC+07:00) Hovd",
    "(UTC+07:00) Krasnoyarsk",
    "(UTC+07:00) Novosibirsk",
    "(UTC+07:00) Tomsk",
    "(UTC+08:00) Beijing, Chongqing, Hong Kong SAR, Urumqi",
    "(UTC+08:00) Irkutsk",
    "(UTC+08:00) Kuala Lumpur, Singapore",
    "(UTC+08:00) Perth",
    "(UTC+08:00) Taipei",
    "(UTC+08:00) Ulaanbaatar",
    "(UTC+08:30) Pyongyang",
    "(UTC+08:45) Eucla",
    "(UTC+09:00) Chita",
    "(UTC+09:00) Osaka, Sapporo, Tokyo",
    "(UTC+09:00) Seoul",
    "(UTC+09:00) Yakutsk",
    "(UTC+09:30) Adelaide",
    "(UTC+09:30) Darwin",
    "(UTC+10:00) Brisbane",
    "(UTC+10:00) Canberra, Melbourne, Sydney",
    "(UTC+10:00) Guam, Port Moresby",
    "(UTC+10:00) Hobart",
    "(UTC+10:00) Vladivostok",
    "(UTC+10:30) Lord Howe Island",
    "(UTC+11:00) Bougainville Island",
    "(UTC+11:00) Chokurdakh",
    "(UTC+11:00) Magadan",
    "(UTC+11:00) Norfolk Island",
    "(UTC+11:00) Sakhalin",
    "(UTC+11:00) Solomon Is., New Caledonia",
    "(UTC+12:00) Anadyr, Petropavlovsk-Kamchatsky",
    "(UTC+12:00) Auckland, Wellington",
    "(UTC+12:00) Co-ordinated Universal Time+12",
    "(UTC+12:00) Fiji",
    "(UTC+12:00) Petropavlovsk-Kamchatsky - Old",
    "(UTC+12:45) Chatham Islands",
    "(UTC+13:00) Co-ordinated Universal Time+13",
    "(UTC+13:00) Nuku'alofa",
    "(UTC+13:00) Samoa",
    "(UTC+14:00) Kiritimati Island"]

Template.timezoneselect.onRendered ->
  Meteor.call "lastTzIndex",
    (err, res) -> $("#timezone")[0].selectedIndex = res || 10 # US

Template.preflangselect.helpers
  languages: () -> return ["Albanian",
    "Amharic",
    "Arabic",
    "Armenian",
    "Azerbaijani",
    "Basque",
    "Belarusian",
    "Bengali",
    "Bosnian",
    "Bulgarian",
    "Catalan",
    "Cebuano",
    "Chichewa",
    "Chinese",
    "Corsican",
    "Croatian",
    "Czech",
    "Danish",
    "Dutch",
    "English",
    "Esperanto",
    "Estonian",
    "Filipino",
    "Finnish",
    "French",
    "Frisian",
    "Galician",
    "Georgian",
    "German",
    "Greek",
    "Gujarati",
    "Haitian Creole",
    "Hausa",
    "Hawaiian",
    "Hebrew",
    "Hindi",
    "Hmong",
    "Hungarian",
    "Icelandic",
    "Igbo",
    "Indonesian",
    "Irish",
    "Italian",
    "Japanese",
    "Javanese",
    "Kannada",
    "Kazakh",
    "Khmer",
    "Korean",
    "Kurdish (Kurmanji)",
    "Kyrgyz",
    "Lao",
    "Latin",
    "Latvian",
    "Lithuanian",
    "Luxembourgish",
    "Macedonian",
    "Malagasy",
    "Malay",
    "Malayalam",
    "Maltese",
    "Maori",
    "Marathi",
    "Mongolian",
    "Myanmar (Burmese)",
    "Nepali",
    "Norwegian",
    "Pashto",
    "Persian",
    "Polish",
    "Portuguese",
    "Punjabi",
    "Romanian",
    "Russian",
    "Samoan",
    "Scots Gaelic",
    "Serbian",
    "Sesotho",
    "Shona",
    "Sindhi",
    "Sinhala",
    "Slovak",
    "Slovenian",
    "Somali",
    "Spanish",
    "Sundanese",
    "Swahili",
    "Swedish",
    "Tajik",
    "Tamil",
    "Telugu",
    "Thai",
    "Turkish",
    "Ukrainian",
    "Urdu",
    "Uzbek",
    "Vietnamese",
    "Welsh",
    "Xhosa",
    "Yiddish",
    "Yoruba",
    "Zulu"]

Template.preflangselect.onRendered ->
  Meteor.call "lastLangIndex",
    (err, res) -> $("#language")[0].selectedIndex = res || 20 # English

Template.onboarding_timezone.helpers
  tags: () -> ["phone", "Skype", "Hangout", "e-mail", "Facebook", "Slack", "Messenger"]

selectOrAddTag = (tag) =>
  selectedtags = Session.get(tagID)
  lowertags = t.toLowerCase() for t in selectedtags
  lowertag = tag.toLowerCase()
  
  if (lowertags.indexOf(lowertag) < 0)
    # not selected yet
    selectedtags.push(tag)
    Session.set(tagID, selectedtags)

  spantags = $(".tag").map(() -> this.innerText.toLowerCase()).get()
  spanindex = spantags.indexOf(lowertag)

  if (spanindex >= 0)
    $(".tag")[spanindex].className += " selected"
  else
    newtag = $("<span class='tag label label-info selected'></span>")
    newtag[0].innerText = tag
    $("#commtags").append(newtag)

Template.onboarding_timezone.onRendered ->
  Meteor.call "commtagsSelected",
    (err, res) -> 
      selectedtags = Session.get(tagID)
      if (selectedtags)
        selectOrAddTag(tag) for tag in selectedtags

  Meteor.call "lastCommAny",
    (err, res) -> $("#commany")[0].checked = res

Template.onboarding_timezone.events
  "click .continue": (event) ->
    # validation

  "click .addcom": (event) ->
    selectOrAddTag($("#addcomValue").val())
    $("#addcomValue")[0].value = ""
    Meteor.call "commtags", {category:"commtags", tags: Session.get(tagID)} # save to db

  "change #timezone" : (event) ->
    Meteor.call "insertOnboardingForUser", "tzIndex", event.target.selectedIndex

  "change #language" : (event) ->
    Meteor.call "insertOnboardingForUser", "langIndex", event.target.selectedIndex

  "change #commany" : (event) ->
    Meteor.call "insertOnboardingForUser", "commAny", event.target.checked

  "keyup #addcomValue" : (event) ->
    if (event.key == "Enter")
      $("#addcomButton").click()
      event.preventDefault()
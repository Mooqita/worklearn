Template.obtags.onCreated ->
  category = if this.data.category? then this.data.category else ""
  this.data.tagID = this.data.method + "Selected" + category
  _tagID = this.data.tagID
  method = this.data.method

  Meteor.call (method + "Selected"), category,
    (err, res) -> Session.set(_tagID, res)

Template.obtags.helpers
  # Only called when page loads, so pre-sets all the previously selected tags
  isSelected: (item) ->
    prevtags = Session.get(Template.instance().data.tagID)
    if (prevtags)
      return if prevtags.filter((e) => e.toLowerCase() == item.toLowerCase()).length > 0 then "selected" else ""
    return ""

Template.obtags.events
  "click .tag": (event) ->
    self = Template.instance().data
    _tagID = self.tagID

    if event.target.className.includes("selected")
      event.target.classList.remove("selected")
      Session.set(_tagID, Session.get(_tagID).filter((e) => e.toLowerCase() != event.target.innerText.toLowerCase()))
    else
      event.target.className += " selected"
      _tags = Session.get(_tagID)
      _tags.push(event.target.innerText)
      Session.set(_tagID, _tags)

    Meteor.call self.method, {category: self.category, tags: Session.get(_tagID)}
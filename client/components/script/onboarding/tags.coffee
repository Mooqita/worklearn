Template.obtags.onRendered ->
  method = this.data.method
  Meteor.call "coursetagsSelected",
    (err, res) -> Session.set(method + "Selected", res)

Template.obtags.helpers
  # Only called when page loads, so pre-sets all the previously selected tags
  isSelected: (item) ->
    return if (Session.get(this.method + "Selected").indexOf(item) >= 0) then "selected" else ""

Template.obtags.events
  "click .tag": (event) ->
    if event.target.className.includes("selected")
      event.target.classList.remove("selected")
      Session.set(this.method + "Selected", Session.get(this.method + "Selected").filter((e) => e != event.target.innerText))
    else
      event.target.className += " selected"
      _tags = Session.get(this.method + "Selected")
      _tags.push(event.target.innerText)
      Session.set(this.method + "Selected", _tags)

    self = Template.instance().data
    category = if self.category? then self.category else ""

    Meteor.call self.method, {category: category, tags: Session.get(this.method + "Selected")}
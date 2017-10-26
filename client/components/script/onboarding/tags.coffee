Template.obtags.onCreated ->
  this.selectedTags = []

Template.obtags.events
  "click .tag": (event) ->
    # Update UI and add/remove tag as needed
    # TODO: add/remove tags from database; at that point the local selectedTags can also be removed.
    if event.target.className.includes("selected")
      event.target.classList.remove("selected")
      Template.instance().selectedTags = Template.instance().selectedTags.filter((e) => e != event.target.innerText)
    else
      event.target.className += " selected"
      Template.instance().selectedTags.push(event.target.innerText)
    # Setting this for now to access it within the views
    Session.set this.method, Template.instance().selectedTags
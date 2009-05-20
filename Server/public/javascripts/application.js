// update items in the list after editing
if( window.AlertItem && AlertItem != '' ) {
  document.observe("dom:loaded", function() {
    var list = $("list-page").down("ul.list")
    var type = list.id.replace(/s$/,'');
    var id = type + "-" + AlertItem;
    console.log("updated: " + id);
    Effect.ScrollTo(id, {afterFinish: function() {
      $(id).highlight();
    }});
  });
}

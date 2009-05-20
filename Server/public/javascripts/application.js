var loc = new String(window.location.search).toQueryParams();
var updated_item = loc['updated_item'];
// update items in the list after editing
if( updated_item && updated_item != '' ) {
  document.observe("dom:loaded", function() {
    var list = $("list-page").down("ul.list")
    var type = list.id.replace(/s$/,'');
    var id = type + "-" + updated_item;
    console.log("updated: " + id);
    Effect.ScrollTo(id, {afterFinish: function() {
      $(id).highlight();
    }});
  });
}

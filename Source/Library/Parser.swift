import UIKit
import Sugar

struct Parser {

  static func parse(json: JSONDictionary) -> [ComponentView] {
    guard let components = json["components"] as? JSONArray else { return [ComponentView]() }
    var views = [ComponentView]()
    for component in components {
      if let type = component["type"] as? String,
      items = component["items"] as? [AnyObject] where type == "list" {
        var componentItems = [ListItem]()
        for item in items {
          guard let json = item as? JSONDictionary else { continue }
          componentItems.append(ListItem(json: json))
        }

        views.append(ListComponent(items: componentItems))
      }
    }

    return views
  }

}
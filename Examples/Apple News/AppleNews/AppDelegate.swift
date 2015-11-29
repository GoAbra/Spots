import UIKit
import Spots


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarDelegate {

  var window: UIWindow?
  var navigationController: UINavigationController?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    window = UIWindow(frame: UIScreen.mainScreen().bounds)

    FeedSpot.configure = { tableView in tableView.tableFooterView = UIView(frame: CGRect.zero) }
    FeedSpot.cells["feed"] = FeedItemCell.self

    ListSpot.headers["search"] = SearchHeaderView.self
    ListSpot.headers["list"] = ListHeaderView.self
    ListSpot.configure = { tableView in tableView.tableFooterView = UIView(frame: CGRect.zero) }

    CarouselSpot.cells["topic"] = GridTopicCell.self
    GridSpot.cells["topic"] = GridTopicCell.self

    let forYouController = ForYouController(title: "For You")
    let favoritesController = FavoritesController(title: "Favorites")
    let exploreController = ExploreController(title: "Explore")
    let searchController = SearchController(title: "Search")
    let savedController = SavedController(title: "Saved")
    let tabBarController = MainController()
    
    forYouController.tabBarItem.image = UIImage(named: "ForYou")
    favoritesController.tabBarItem.image = UIImage(named: "Favorites")
    exploreController.tabBarItem.image = UIImage(named: "Explore")
    searchController.tabBarItem.image = UIImage(named: "Search")
    savedController.tabBarItem.image = UIImage(named: "Saved")
    
    tabBarController.viewControllers = [
      forYouController,
      favoritesController,
      exploreController,
      searchController,
      savedController
    ]
    tabBarController.selectedIndex = 3

    navigationController = UINavigationController(rootViewController: tabBarController)

    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()

    return true
  }
}

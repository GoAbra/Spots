import Foundation
import Cache

//TODO: BK: made changes to this to get it to compile, but it likely will not work.
//It doesn't appear we are actually using caching in Spots, so this should be fine.
//
//Modification was done after reading this thread:
//    https://github.com/hyperoslo/Cache/issues/192#issuecomment-398321936
//
public struct Cachable: Codable {}

/// A StateCache class used for Controller and Component object caching
public final class StateCache {
  static func makeStorage() -> Storage<Cachable>? {
    let cacheName = String(describing: StateCache.self)
    let bundleIdentifier = Bundle.main.bundleIdentifier ?? "Spots.bundle.identifier"
    return try? Storage(
      diskConfig: DiskConfig(name: "\(cacheName)/\(bundleIdentifier)"),
      memoryConfig: MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10),
      transformer: TransformerFactory.forCodable(ofType: Cachable.self)
    )
  }

  static let storage = StateCache.makeStorage()

  /// Remove state cache for all controllers and components.
  public static func removeAll() {
    try? storage?.removeAll()
  }

  /// A unique identifer string for the StateCache
  public let key: String

  /// A JSON Cache object
  let storage: Storage<Cachable>?

  // MARK: - Initialization

  /// Initialize a StateCache with a unique cache key
  ///
  /// - parameter key: A string that is used as an identifier for the StateCache
  ///
  /// - returns: A StateCache object
  public init(key: String) {
    self.storage = StateCache.storage
    self.key = key
  }

  // MARK: - Cache

  /// Save JSON to the StateCache
  ///
  /// - parameter json: A JSON object
  public func save<T: Codable>(_ object: T) {
    let expiry = Expiry.date(Date().addingTimeInterval(60 * 60 * 24 * 3))
    //TODO: BK: A crash here indicates we are using caching and this forced cast workaround broke it
    try? storage?.setObject(object as! Cachable, forKey: key, expiry: expiry)
  }

  /// Load JSON from cache
  ///
  /// - returns: A Swift dictionary
  public func load<T: Codable>() -> T? {
    guard let object = try? storage?.object(forKey: key) else {
      return nil
    }
    //TODO: BK: A crash here indicates we are using caching and this forced cast workaround broke it
    return object as! T
  }

  /// Clear the current StateCache
  public func clear(completion: (() -> Void)? = nil) {
    try? storage?.removeAll()
    completion?()
  }

  /// The StateCache file name
  ///
  /// - returns: An md5 representation of the StateCache's file name, computed from the StateCache key
  func fileName() -> String {
    return MD5(key)
  }
}

//
//  RealmConfiguration.swift
//  Platform
//
//  Created by Paratthakorn Sribunyong on 3/2/2568 BE.
//

import Foundation
import RealmSwift

public enum RealmConfiguration {
  public static func defaultConfig() -> Realm.Configuration {
    var config = Realm.Configuration.defaultConfiguration
    config.schemaVersion = 1
    
    // Handle schema migrations
    config.migrationBlock = { migration, oldSchemaVersion in
      if oldSchemaVersion < 1 {
        // Add migration code here when needed
      }
    }
    
    // Optional: Set a specific file path
    config.fileURL = try? FileManager.default
      .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
      .appendingPathComponent("matrix.realm")
    
    return config
  }
  
  public static func inMemoryConfig() -> Realm.Configuration {
    var config = Realm.Configuration()
    config.inMemoryIdentifier = "MatrixInMemoryRealm"
    return config
  }
  
  public static func testConfig() -> Realm.Configuration {
    var config = Realm.Configuration()
    config.inMemoryIdentifier = "MatrixTestRealm"
    return config
  }
}

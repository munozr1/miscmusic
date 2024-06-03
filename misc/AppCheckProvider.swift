//
//  AppCheckProvider.swift
//  misc
//https://liudasbar.medium.com/implementing-firebase-app-check-on-ios-non-firebase-back-end-df86df494c6c
//  Created by Rodrigo Munoz on 6/2/24.
//

import Foundation
import FirebaseAppCheck
import Firebase
import Combine

public enum TokenError: Error {
    case error(_ with: String)
}

class FirebaseAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
  func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
    return AppAttestProvider(app: app)
  }
}

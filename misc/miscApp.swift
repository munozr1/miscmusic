//
//  miscApp.swift
//  misc
//
//  Created by Rodrigo Munoz on 5/14/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAppCheck


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      let providerFactory = FirebaseAppCheckProviderFactory()
      AppCheck.setAppCheckProviderFactory(providerFactory)
      FirebaseApp.configure()
      return true
  }
}

@main
struct miscApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var spotifyController = SpotifyController.shared
    var authModel = AuthenticationModel()

    var body: some Scene {
        WindowGroup {
            ContentView(authModel: authModel)
                .onOpenURL { url in
                    spotifyController.setAccessToken(from: url)
                    //when redirected back to app from spotify, call connect again, idk why but it works
                    spotifyController.connect()
                }
        }
    }
}

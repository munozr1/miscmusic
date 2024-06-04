//
//  AuthenticationController.swift
//  misc
//
//  Created by Rodrigo Munoz on 5/23/24.
//

import Foundation
import LocalAuthentication
import Observation
import AuthenticationServices
import CryptoKit
import FirebaseAuth

@Observable class AuthenticationModel {
    var context = LAContext();
    static let shared = AuthenticationModel()
    var authenticated: AuthenticationState = .loggedout
    fileprivate var currentNonce: String?
    var user: User?

    
    enum AuthenticationState {
        case loggedin, loggedout
    }
    
    func signout(){
        do{
            try Auth.auth().signOut()
            authenticated = .loggedout
            user = nil
            
        } catch {
            print("Could not sign out: \(error.localizedDescription)")
        }
    }
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest){
        request.requestedScopes = [.email]
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce
    }
    
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>){
        if case .failure(let failure) = result {
            print(failure.localizedDescription)
        }
        else if case .success(let success) = result {
            if let appleIDCredential = success.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else{
                    fatalError("Invalid State: Login callback received but no login request sent")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identity token")
                    return
                }
                guard let appleIDTokenString = String(data: appleIDToken, encoding: .utf8) else{
                    print("unable to serialize token from string")
                    return
                }
                
                let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: appleIDTokenString, rawNonce: nonce)
                Task {
                    do{
                        let res = try await Auth.auth().signIn(with: credential)
                                
                        if  res.credential == nil{
                            print("Error Logging in")
                            return
                        }
                        authenticated = .loggedin
                        user = res.user
                    } catch {
                        print("Error Authenticating \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    
    func AuthenticateWithGoogle(){
        print("TODO: implement google auth")
        authenticated = .loggedin
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }

        

}

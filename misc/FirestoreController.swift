import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Observation

struct SpotifyParty: Codable {
    var name: String
    var currentTrack: String
    var code: String
    var played: Int
    var skipped: Int
    var listeners: Int
    var duration: Float
}

@Observable class FirestoreController: ObservableObject {
    static let shared = FirestoreController()
    private let db = Firestore.firestore()
    var party: SpotifyParty?
    var skipRate: Int = 0

    private var listener: ListenerRegistration?

    // Function to add a document without async
    func newParty(name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let partyData = [
            "name": name,
            "listeners": 0,
            "played": 0,
            "skipped": 0,
            "currentTrack": SpotifyController.shared.currentTrackName ?? "",
            "code": "1234",
            "duration": 2
        ] as [String : Any]
        
        db.collection("parties").document(name).setData(partyData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                self.listenToParty(name: name)
                completion(.success(()))
            }
        }
    }

    // Function to set up a listener for a party document
    func listenToParty(name: String) {
        listener?.remove()  // Remove any existing listener
        listener = db.collection("parties").document(name).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot, document.exists else {
                print("Document does not exist")
                return
            }
            do {
                self.party = try document.data(as: SpotifyParty.self)
                if self.party!.skipped == 0  || self.party!.played == 0{
                    self.skipRate = 0  // or any other value you prefer
                } else {
                    self.skipRate = Int((Float(self.party!.skipped) / Float(self.party!.played)) * 100)
                }

                print(self.party ?? "no party")
            } catch let error {
                print("Error decoding party data: \(error)")
            }
        }
    }

    deinit {
        listener?.remove()  // Clean up the listener when the object is deallocated
    }
}

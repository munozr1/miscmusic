import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Observation

struct SpotifyParty: Codable {
    var name: String
    var host: String
    var currentTrack: String
    var image: String
    var code: String
    var played: Int
    var skipped: Int
    var listeners: Int
    var duration: Float
    var voteSkips: Int
}

@Observable class FirestoreController: ObservableObject {
    static let shared = FirestoreController()
    private let db = Firestore.firestore()
    var timer: Timer?
    var shouldRun: Bool = false;
    var party: SpotifyParty?
    var skipRate: Int = 0
    var isHost: Bool = false
    

    private var listener: ListenerRegistration?

    // Function to add a document without async
    func newParty(name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let uid = AuthenticationModel.shared.user?.uid else { return }
        let partyData = [
            "name": name,
            "host": uid,
            "listeners": 0,
            "played": 0,
            "skipped": 0,
            "voteSkips": 0,
            "currentTrack": SpotifyController.shared.currentTrackName ?? "",
            "image": String(SpotifyController.shared.currentTrackImageURI.split(separator: ":").last!),
            "code": "1234",
            "duration": 0
        ] as [String : Any]
        
        db.collection("parties").document(name).setData(partyData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                self.listenToParty(name: name, timer: true)
                completion(.success(()))
            }
        }
    }
    
    func startTimer() {
        print("Starting Timer")
        //guard let host = party?.host else { print("No host") ; return }
        guard (AuthenticationModel.shared.user?.uid) != nil else {print("Not logged in") ; return }
        //if host != curr_user { print("Not Host") ; return }
        
        timer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true){ _ in
            if !self.shouldRun { self.stopTimer() }
            else { self.incrementDuration() }
        }
        
        print("Timer Started")
    }

    func stopTimer() {
        print("Stopped Timer")
        shouldRun = false
        timer?.invalidate()
        timer = nil
        
    }
    
    func updateParty(name: String, data: [String: Any]){
        db.collection("parties").document(name).updateData(data) 
    }
    
    func endParty() async {
        guard let name = party?.name else { return }
        do {
            self.shouldRun = false;
            try await db.collection("parties").document(name).delete()
            self.party = nil
            self.isHost = false
            print("Document successfully removed!")
        } catch {
          print("Error removing document: \(error)")
        }
        
    }
    
    func voteToSkip() {
        let partyRef = db.collection("parties").document(party!.name)

        partyRef.updateData([
            "voteSkips": FieldValue.increment(Int64(1))
        ]) { error in
            if let error = error {
                print("Error updating vote skips: \(error.localizedDescription)")
            } else {
                print("Vote skip count incremented successfully.")
            }
        }
    }
    
    func incrementSkipped() {
        let partyRef = db.collection("parties").document(party!.name)

        partyRef.updateData([
            "skipped": FieldValue.increment(Int64(1))
        ]) { error in
            if let error = error {
                print("Error updating vote skips: \(error.localizedDescription)")
            } else {
                print("Vote skip count incremented successfully.")
            }
        }
    }
    
    func incrementDuration() {
        guard let name = party?.name else {print("no party") ; return}
        let partyRef = db.collection("parties").document(name)

        partyRef.updateData([
            "duration": FieldValue.increment(Int64(300))
        ]) { error in
            if let error = error {
                print("Error updating vote duration: \(error.localizedDescription)")
            } else {
                print("Duration incremented successfully.")
            }
        }
    }
    
    func incrementPlayed() {
        let partyRef = db.collection("parties").document(party!.name)

        partyRef.updateData([
            "played": FieldValue.increment(Int64(1))
        ]) { error in
            if let error = error {
                print("Error updating vote skips: \(error.localizedDescription)")
            } else {
                print("Vote skip count incremented successfully.")
            }
        }
    }
    
    func incrementListener(name: String) {
        let partyRef = db.collection("parties").document(name)

        partyRef.updateData([
            "listeners": FieldValue.increment(Int64(1))
        ]) { error in
            if let error = error {
                print("Error updating listeners: \(error.localizedDescription)")
            } else {
                print("Vote listeners incremented successfully.")
            }
        }
    }

    func decrementListener() {
        if(party?.name == nil) { return }
        let partyRef = db.collection("parties").document(party!.name)

        partyRef.updateData([
            "listeners": FieldValue.increment(Int64(-1))
        ]) { error in
            if let error = error {
                print("Error updating listeners: \(error.localizedDescription)")
            } else {
                print("Vote listeners decremented successfully.")
            }
        }
    }
    
    func resetListener(){
        decrementListener()
        listener?.remove()
//        party = nil
    }

    // Function to set up a listener for a party document
    func listenToParty(name: String, timer: Bool? = false) {
        print("Start Listen")
        listener?.remove()
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
        resetListener()
    }
}

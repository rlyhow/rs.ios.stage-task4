import Foundation

typealias CallID = UUID

struct Call: Hashable {
    let id: CallID
    let incomingUser: User
    let outgoingUser: User
    var status: CallStatus
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum CallEndReason: Equatable {
    case cancel // Call was canceled before the other user answered
    case end // Call ended after successful conversation
    case userBusy // Call ended because the user is busy
    case error
}

enum CallStatus: Equatable {
    case calling
    case talk
    case ended(reason: CallEndReason)
}


import Foundation

final class CallStation {
    var usersList: Array<User> = []
    var callsList: Array<Call> = []
}

extension CallStation: Station {
    func users() -> [User] {
        if usersList.isEmpty {
            return []
        }
        return Array(usersList)
    }
    
    func add(user: User) {
        if !usersList.contains(user) {
            usersList.append(user)
        }
    }
    
    func remove(user: User) {
        if let index = usersList.firstIndex(of: user) {
            usersList.remove(at: index)
            
            for i in callsList.indices {
                if (callsList[i].incomingUser == user || callsList[i].outgoingUser == user) && (callsList[i].status == .talk || callsList[i].status == .calling) {
                    callsList[i].status = .ended(reason: CallEndReason.error)
                }
            }
            
        }
    }
    
    func execute(action: CallAction) -> CallID? {
        
        switch action {
        case .start(let user1, let user2):
            if !usersList.contains(user1) && !usersList.contains(user2) { return nil }
            print("\(user1) calls to \(user2)")
            
            let callID = UUID()
            var status: CallStatus = usersList.contains(user2) ? .calling : .ended(reason: CallEndReason.error)
            for i in callsList.indices {
                if (callsList[i].incomingUser == user2 || callsList[i].outgoingUser == user2) && callsList[i].status == .talk {
                    status = .ended(reason: CallEndReason.userBusy)
                }
            }
            
            let newCall = Call(id: callID, incomingUser: user1, outgoingUser: user2, status: status) // создаем структуру нового звонка
            callsList.append(newCall) // добавляем новый звонок в список звонков
            return newCall.id
        case .answer(let user2):
            if usersList.contains(user2){
                for i in callsList.indices {
                    if callsList[i].outgoingUser == user2 && callsList[i].status == .calling {
                        callsList[i].status = .talk
                        return callsList[i].id
                    }
                }
            }
            return nil
        case .end(let user):
            for i in callsList.indices {
                if callsList[i].incomingUser == user && callsList[i].status == .talk {
                    callsList[i].status = .ended(reason: CallEndReason.end)
                    return callsList[i].id
                }
                if callsList[i].outgoingUser == user && callsList[i].status == .talk {
                    callsList[i].status = .ended(reason: CallEndReason.end)
                    return callsList[i].id
                }
                if callsList[i].outgoingUser == user && callsList[i].status == .calling {
                    callsList[i].status = .ended(reason: CallEndReason.cancel)
                    return callsList[i].id
                }
            }
            return nil
        }
    }
    
    func calls() -> [Call] {
        if callsList.isEmpty {
            return []
        }
        return Array(callsList)
    }
    
    func calls(user: User) -> [Call] {
        var userArrayCalls: [Call] = []
        for item in callsList {
            if item.outgoingUser == user || item.incomingUser == user {
                userArrayCalls.append(item)
            }
        }
        return userArrayCalls
    }
    
    func call(id: CallID) -> Call? {
        for item in callsList {
            if item.id == id {
                return item
            }
        }
        return nil
    }
    
    func currentCall(user: User) -> Call? {
        for currentUser in callsList where (currentUser.incomingUser == user && (currentUser.status == .calling || currentUser.status == .talk)) {
            return currentUser
        }
        
        for currentUser in callsList where (currentUser.outgoingUser == user && (currentUser.status == .calling || currentUser.status == .talk)) {
            return currentUser
        }
        
        return nil
    }
}

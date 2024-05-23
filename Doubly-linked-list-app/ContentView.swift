//
//  ContentView.swift
//  Doubly-linked-list-app
//
//  Created by Alexandru-Andrei Buzas on 23.05.2024.
//

import SwiftUI
import Foundation

class Node {
    var info: Int
    var pred: Node?
    var succ: Node?
    
    init(_ value: Int) {
        self.info = value
    }
}

class DoublyLinkedList {
    var count: Int = 0
    var front: Node?
    var end: Node?
        
    func search(_ item: Int) -> Node? {
        var temp = front
        while temp != nil {
            if temp!.info == item {
                return temp
            }
            temp = temp!.succ
        }
        return nil
    }
    
    func insertAtBeginning(_ value: Int) {
        let newNode = Node(value)
        if front == nil {
            front = newNode
            end = newNode
        } else {
            newNode.succ = front
            front?.pred = newNode
            front = newNode
        }
        count += 1
    }
    
    func insertAtEnd(_ value: Int) {
        let newNode = Node(value)
        if front == nil {
            front = newNode
            end = newNode
        } else {
            newNode.pred = end
            end?.succ = newNode
            end = newNode
        }
        count += 1
    }
    
    func insertAfter(_ value: Int, afterItem: Int) {
        guard let after = search(afterItem) else {
            print("\nError - element does not exist (insertAfter)")
            return
        }
        
        let newNode = Node(value)
        newNode.pred = after
        newNode.succ = after.succ
        after.succ?.pred = newNode
        after.succ = newNode
        
        count += 1
    }
    
    func deleteFromBeginning() {
        guard front != nil else {
            print("\nError - empty list (deleteFromBeginning)")
            return
        }
        
        front = front?.succ
        front?.pred = nil
        
        count -= 1
    }

    func deleteFromEnd() {
        guard end != nil else {
            print("\nError - empty list (deleteFromEnd)")
            return
        }
        
        end = end?.pred
        end?.succ = nil
        
        count -= 1
    }
    
    func deleteAfter(afterItem: Int) {
        guard let after = search(afterItem) else {
            print("\nError - element does not exist (deleteAfter)")
            return
        }
        
        guard let save = after.succ else {
            print("\nError - element after does not exist (deleteAfter)")
            return
        }
        
        after.succ = save.succ
        save.succ?.pred = after
        
        count -= 1
    }
    
    func update(item: Int, newInfo: Int) {
        guard let node = search(item) else {
            print("\nError - element does not exist (update)")
            return
        }
        
        node.info = newInfo
    }
    
    func displayFromLeft() {
        var temp = front
        while temp != nil {
            print(temp!.info, terminator: " ")
            temp = temp!.succ
        }
    }
    
    func displayFromRight() {
        var temp = end
        while temp != nil {
            print(temp!.info, terminator: " ")
            temp = temp!.pred
        }
    }
    
    func sort() {
        var tempI = front
        while tempI != nil && tempI!.succ != nil {
            var tempJ = tempI!.succ
            while tempJ != nil {
                if tempI!.info > tempJ!.info {
                    let temp = tempI!.info
                    tempI!.info = tempJ!.info
                    tempJ!.info = temp
                }
                tempJ = tempJ!.succ
            }
            tempI = tempI!.succ
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

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

class DoublyLinkedList: ObservableObject {
    @Published var count: Int = 0
    @Published var front: Node?
    @Published var end: Node?
        
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

class ListViewModel: ObservableObject {
    @Published var lists: [DoublyLinkedList] = []
    
    func createNewList(with value: Int) {
        let newList = DoublyLinkedList()
        newList.insertAtBeginning(value)
        lists.append(newList)
    }
    
    func addNumberToList(at index: Int, value: Int) {
        guard index < lists.count else { return }
        lists[index].insertAtEnd(value)
    }
}

struct ContentView: View {
    @StateObject private var viewModel = ListViewModel()
    @State private var selection: String? = "Home"
    
    var body: some View {
        NavigationStack {
            NavigationSplitView {
                List(selection: $selection) {
                    NavigationLink(value: "Home") {
                        Label("Home", systemImage: "house")
                    }
                    NavigationLink(value: "List") {
                        Label("List", systemImage: "star")
                    }
                    NavigationLink(value: "Item") {
                        Label("Item", systemImage: "bell")
                    }
                }
                .listStyle(SidebarListStyle())
                .navigationTitle("Sidebar")
            } detail: {
                if let selection = selection {
                    if selection == "Home" {
                        HomeView(viewModel: viewModel)
                    } else if selection == "List" {
                        ListView(viewModel: viewModel)
                    } else {
                        Text(selection)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                } else {
                    Text("Select an item")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
                }
            }
        }
    }
}

struct HomeView: View {
    @ObservedObject var viewModel: ListViewModel
    @State private var showAlert = false
    @State private var newListValue = ""
    
    var body: some View {
        VStack {
            Text("Home")
                .font(.largeTitle)
            
            if viewModel.lists.isEmpty {
                Text("No lists available")
            }
            
            Button(action: {showAlert = true}) {
                Text("Create New List")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .alert("Create New List", isPresented: $showAlert) {
                TextField("Enter initial value", text: $newListValue)
                Button("Create", action: {
                    if let value = Int(newListValue) {
                        viewModel.createNewList(with: value)
                    }
                })
                Button("Cancel", role: .cancel, action: {})
            }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
    }
}

struct ListView: View {
    @ObservedObject var viewModel: ListViewModel
    
    var body: some View {
        VStack {
            Text("Lists")
                .font(.largeTitle)
            
            List {
                ForEach(0..<viewModel.lists.count, id: \.self) {
                    index in
                    
                    Text("List \(index + 1): \(viewModel.lists[index].front?.info ?? 0)")
                }
            }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}

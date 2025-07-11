//
//  ContentView.swift
//  Birthdays
//
//  Created by Sydney Ramos on 7/11/25.
//

import SwiftUI
import SwiftData

import SwiftUI
import SwiftData

@main
struct birthdayapps: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Friend.self)
        }
    }
}
struct ContentView: View {
    @State private var newName = ""
    @State private var newBirth = Date.now
    
    
    @Query private var friends: [Friend] = [
        Friend(name: "Hayden", birthday: .now),
        Friend(name: "Olive", birthday: Date(timeIntervalSince1970: 0))
    ]
    @Environment(\.modelContext) private var context
    var body: some View {
        NavigationStack {
            List{
                ForEach(friends) { friend in
                    HStack {
                        Text(friend.name)
                        Spacer()
                        Text(friend.birthday, format: .dateTime.month(.wide).day().year())
                    }
                }
            .onDelete(perform: deleteFriend)
        }
            
            .navigationTitle("Birthdays")
            .safeAreaInset(edge: .bottom) {
                VStack(alignment: .center, spacing: 20) {
                    Text("New Birthday")
                        .font(.headline)
                    DatePicker(selection: $newBirth, in: Date.distantPast...Date.now, displayedComponents: .date) {
                        TextField("Name", text: $newName)
                            .textFieldStyle(.roundedBorder)
                    }
                    Button("Save") {
                        let newFriend = Friend(name: newName, birthday: newBirth)
                        context.insert(newFriend)
                        newName = ""
                        newBirth = .now
                    }
                    .bold()
                }
                .padding()
                .background(.bar)
            }
        }
        
    }
    func deleteFriend(at offsets: IndexSet) {
        for index in offsets {
            let friendToDelete = friends[index]
            context.delete(friendToDelete)
        }
    }
}

        #Preview {
    ContentView()
        .modelContainer(for: Friend.self, inMemory: true)
}

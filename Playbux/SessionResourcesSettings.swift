//
//  SessionResourseSettings.swift
//  Playbux
//
//  Created by Daniel Jilg on 25.12.25.
//

import SwiftData
import SwiftUI

struct SessionResourcesSettings: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var session: Session
    
    var body: some View {
        List {
            ForEach(session.resourceTypes) { resourceType in
                NavigationLink {
                    SessionResourceTypeSettings(resourceType: resourceType)
                } label: {
                    Text(resourceType.name)
                }
            }
            .onDelete(perform: deleteResourceType)
        }
        .navigationTitle("Resources")
        .toolbar {
#if os(iOS)
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
#endif
            ToolbarItem {
                Button(action: addResourceType) {
                    Label("Add Resource Type", systemImage: "plus")
                }
            }
        }
    }

    private func addResourceType() {
        withAnimation {
            let newResoureceType = ResourceType(name: "Mäuse")
            session.resourceTypes.append(newResoureceType)
        }
    }

    private func deleteResourceType(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(session.resourceTypes[index])
            }
        }
    }
}

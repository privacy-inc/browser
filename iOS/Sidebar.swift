import SwiftUI

struct Sidebar: View {
    @ObservedObject var session: Session
    
    var body: some View {
        List(selection: $session.sidebar) {
            Section("Browser") {
                NavigationLink(value: Category.tabs) {
                    Label("Tabs", systemImage: "square.on.square.dashed")
                }
                NavigationLink(value: Category.bookmarks) {
                    Label("Bookmarks", systemImage: "bookmark")
                }
                NavigationLink(value: Category.history) {
                    Label("History", systemImage: "clock")
                }
            }
            .headerProminence(.increased)
            
            Section("Protection") {
                NavigationLink(value: Category.forget) {
                    Label("Forget", systemImage: "flame")
                }
                NavigationLink(value: Category.report) {
                    Label("Privacy report", systemImage: "checkerboard.shield")
                }
            }
            .headerProminence(.increased)
            
            Section("App") {
                NavigationLink(value: Category.settings) {
                    Label("Settings", systemImage: "gear")
                }
                NavigationLink(value: Category.sponsor) {
                    Label("Sponsor", systemImage: "heart")
                }
                NavigationLink(value: Category.policy) {
                    Label("Privacy policy", systemImage: "hand.raised")
                }
                NavigationLink(value: Category.about) {
                    Label("About", systemImage: "star")
                }
            }
            .headerProminence(.increased)
        }
        .listStyle(.sidebar)
        .navigationTitle("Menu")
    }
}

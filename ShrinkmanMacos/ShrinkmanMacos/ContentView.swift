//
//  ContentView.swift
//  ShrinkmanMacos
//
//  Created by Vishal Kamble on 19/06/23.
//

import SwiftUI
import CoreData
/*
struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        Text(item.timestamp!, formatter: itemFormatter)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}



*/


import SwiftUI


struct ContentView: View {
    @State private var username: String = ""
    @State private var productKeySegment1 = ""
    @State private var productKeySegment2 = ""
    @State private var productKeySegment3 = ""
    @State private var productKeySegment4 = ""
    @State private var productKeySegment5 = ""
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                Image("loginpage_img")
                    .resizable()
                    .frame(width: geometry.size.width * 0.25, height: geometry.size.height)
                    
                    .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "D4001A"),Color(hex: "064494")]), startPoint: .top, endPoint: .bottom))
                VStack(alignment: .center) {
                    Spacer()
                    
                    Image("Logo")
                        .aspectRatio(contentMode: .fit)
                        .padding(.top, 30.0)
                    
                   
                    
                    HStack {
                        Text("User Name")
                            .font(.headline)
                        TextField("", text: $username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                    }
                    .padding()
                    
                    HStack {
                        Text("Product Key")
                            .font(.headline)
                        ProductKeySegmentField(segment: $productKeySegment1)
                        ProductKeySegmentField(segment: $productKeySegment2)
                        ProductKeySegmentField(segment: $productKeySegment3)
                        ProductKeySegmentField(segment: $productKeySegment4)
                        ProductKeySegmentField(segment: $productKeySegment5)
                    }.padding()
                    
                    
                    Button("Login") {

                    }
                    
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
                    .background(Color.red)
                    Spacer()
                }
                .frame(width: geometry.size.width * 0.75, height: geometry.size.height)

               
                .background(
                    Image("login_background")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    )
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

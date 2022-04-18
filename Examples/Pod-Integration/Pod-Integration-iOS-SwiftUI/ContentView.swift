//
//  ContentView.swift
//  Pod-Integration-watchOS-SwiftUI WatchKit Extension
//
//  Created by Hans Seiffert on 16.04.22.
//  Copyright © 2022 Hans Seiffert. All rights reserved.
//

import SwiftUI
import QAMenuSwiftUI
import QAMenuUtils
import QAMenuCatalog
import QAMenuExampleItems
import QAMenu

struct ContentView: View {

    var body: some View {
        VStack {
            Text("🚧 SwiftUI Support is under development ...")
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
    }
}

#if DEBUG

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#endif

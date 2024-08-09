//
//  Blink_TimeApp.swift
//  Blink Time
//
//  Created by Pieter Yoshua Natanael on 09/08/24.
//

import SwiftUI

@main
struct Blink_TimeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}

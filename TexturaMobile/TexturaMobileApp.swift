//
//  TexturaMobileApp.swift
//  TexturaMobile
//
//  Created by Никита Коробкин on 05.06.2026.
//

import SwiftUI

@main
struct TexturaMobileApp: App {
    init() {
        FontRegistrar.registerBundledFonts()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

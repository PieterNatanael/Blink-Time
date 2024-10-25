//
//  ContentView.swift
//  Blink Time
//
//  Created by Pieter Yoshua Natanael on 09/08/24.
//

import SwiftUI
import AVFoundation


struct ContentView: View {
    @State private var blinkRate: Int = 15
    @State private var timer: Timer?
    @State private var player: AVAudioPlayer?
    @State private var backgroundPlayer: AVAudioPlayer?
    @State private var isBlinking: Bool = false
    @State private var volume: Float = 1.0
    @State private var showExplain: Bool = false
    @State private var showVolumeSlider: Bool = false

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(colors: [.brown, .brown], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack {
                // Header
                HStack {
                    Text("")
                        .frame(width: 30, height: 30)
                        .padding()
                    Spacer()
                    Text("Blink Time")
                        .font(.extraLargeTitle)
                        .foregroundColor(.black)
                    Spacer()
                    Button(action: {
                        showExplain = true
                    }) {
                        Image(systemName: "questionmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                            .padding()
                    }
                }

                Spacer()

                // Blink rate picker
                Picker("Blink Rate", selection: $blinkRate) {
                    Text("15 times per minute").tag(15)
                    Text("20 times per minute").tag(20)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // Start/Stop button
                Button(action: {
                    isBlinking.toggle()
                    if isBlinking {
                        startBlinking()
                    } else {
                        stopBlinking()
                    }
                }) {
                    Text(isBlinking ? "Stop" : "Start")
                        .font(.title.bold())
                        .padding()
                        .frame(width: 233)
                        .foregroundColor(isBlinking ? Color.white : Color.black)
                        .background(isBlinking ? Color.red : Color.white)
                        .cornerRadius(25.0)
                }
                .padding()

                // Volume control button
                Button("Volume") {
                    showVolumeSlider.toggle()
                }
                .font(.title2.bold())
                .padding()
                .frame(width: 233)
                .background(Color.black)
                .cornerRadius(25)
                .foregroundColor(.white)
                .padding()

                Spacer()
            }
            .sheet(isPresented: $showExplain) {
                ShowExplainView(onConfirm: {
                    showExplain = false
                })
            }
            .onAppear {
                // Add observers for starting and stopping the blink timer
                NotificationCenter.default.addObserver(forName: .startBlinkTimer, object: nil, queue: .main) { _ in
                    startBlinking()
                }
                NotificationCenter.default.addObserver(forName: .stopBlinkTimer, object: nil, queue: .main) { _ in
                    stopBlinking()
                }
            }

            // Volume slider
            if showVolumeSlider {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Slider(value: $volume, in: 0...1, step: 0.1)
                            .padding()
                            .accentColor(.green)
                            .background(Color.brown)
                            .cornerRadius(25)
                            .padding()
                            .onChange(of: volume) { oldValue, newValue in
                            player?.volume = newValue
                            backgroundPlayer?.volume = newValue
                        }
//                            .onChange(of: volume) { newValue in
//                                player?.volume = volume
//                                backgroundPlayer?.volume = volume
//                            }
                        Spacer()
                    }
                    .padding(.bottom)
                }
                .transition(.move(edge: .bottom))
//                .animation(.easeInOut, value: 1)
//                .animation(.easeInOut)
            }
        }
    }

    // Start the blink timer
    func startBlinking() {
        stopBlinking() // Stop any existing timer
        let interval = 60.0 / Double(blinkRate)
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            playBlinkSound()
        }
    }

    // Stop the blink timer
    func stopBlinking() {
        timer?.invalidate()
        timer = nil
    }

    // Play blink sound
    func playBlinkSound() {
        guard let url = Bundle.main.url(forResource: "blink_sound", withExtension: "mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = volume
            player?.play()
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }
}

extension Notification.Name {
    static let startBlinkTimer = Notification.Name("startBlinkTimer")
    static let stopBlinkTimer = Notification.Name("stopBlinkTimer")
}

#Preview {
    ContentView()
}

// MARK: - Explain View
struct ShowExplainView: View {
    var onConfirm: () -> Void

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("App Functionality")
                        .font(.title.bold())
                    Spacer()
                }

                Text("""
               • Adjust Blink Rate: Choose between 15 blinks per minute or 20 blinks per minute before pressing the start button.
               • Start/Stop Blinking: Press the button to start or stop the blink reminder function.
               • Volume Control: Adjust the volume of the reminder sound using the slider.
               """)
                .font(.title3)
                .multilineTextAlignment(.leading)
                .padding()

                Spacer()
                HStack {
                    Text("Blink Time is developed by Three Dollar.")
                        .font(.title3.bold())
                        .onTapGesture {
                            if let url = URL(string: "https://b33.biz/three-dollar/") {
                                UIApplication.shared.open(url)
                            }
                        }
                    Spacer()
                }

                Button("Close") {
                    // Perform confirmation action
                    onConfirm()
                }
                .font(.title)
                .padding()
                .cornerRadius(25.0)
                .padding()
            }
            .padding()
            .cornerRadius(15.0)
            .padding()
        }
    }
}

/*
import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        VStack {
            Model3D(named: "Scene", bundle: realityKitContentBundle)
                .padding(.bottom, 50)

            Text("Hello, world!")

            Toggle("Show ImmersiveSpace", isOn: $showImmersiveSpace)
                .font(.title)
                .frame(width: 360)
                .padding(24)
                .glassBackgroundEffect()
        }
        .padding()
        .onChange(of: showImmersiveSpace) { _, newValue in
            Task {
                if newValue {
                    switch await openImmersiveSpace(id: "ImmersiveSpace") {
                    case .opened:
                        immersiveSpaceIsShown = true
                    case .error, .userCancelled:
                        fallthrough
                    @unknown default:
                        immersiveSpaceIsShown = false
                        showImmersiveSpace = false
                    }
                } else if immersiveSpaceIsShown {
                    await dismissImmersiveSpace()
                    immersiveSpaceIsShown = false
                }
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}

*/

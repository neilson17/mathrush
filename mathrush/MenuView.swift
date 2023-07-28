//
//  MenuView.swift
//  mathrush
//
//  Created by Neilson Soeratman on 08/05/23.
//

import SwiftUI
import SceneKit
import CoreMotion
import AVFoundation

class TimerClass: ObservableObject{
    @Published var timer: Timer?
}

var player: AVAudioPlayer!
var player2: AVAudioPlayer!

func playSound(name: String){
    let url = Bundle.main.url(forResource: name, withExtension: "mp3")
    
    guard url != nil else {
        return
    }
    
    do {
        player = try AVAudioPlayer(contentsOf: url!)
        player?.play()
    }
    catch{
        print("error")
    }
}

func adjustVolumeSound(volume: Float){
    player?.volume = volume
}


func playSoundLoop(name: String){
    let url = Bundle.main.url(forResource: name, withExtension: "mp3")
    
    guard url != nil else {
        return
    }
    
    do {
        player = try AVAudioPlayer(contentsOf: url!)
        player?.numberOfLoops = -1
        player?.play()
    }
    catch{
        print("error")
    }
}

func stopSound(){
    player?.stop()
}

func playSound2(name: String){
    let url = Bundle.main.url(forResource: name, withExtension: "mp3")
    
    guard url != nil else {
        return
    }
    
    do {
        player2 = try AVAudioPlayer(contentsOf: url!)
        player2?.play()
    }
    catch{
        print("error")
    }
}

class TimerClass2: ObservableObject{
    @Published var timer: Timer?
}

struct MenuView: View {
    @State private var menuScale = 0.0
    @State private var goToPlay = false
    @StateObject var timerClass: TimerClass = TimerClass()
    @StateObject var timerClass2: TimerClass2 = TimerClass2()
    @State private var howToPlayShown = 0.0
    
    var body: some View {
        NavigationView {
            ZStack{
                NavigationLink(destination: PlayView().environmentObject(timerClass).environmentObject(timerClass2), isActive: $goToPlay, label: {})
                SceneKitView()
                    .ignoresSafeArea()
                ZStack{ }
                    .ignoresSafeArea()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .background(.white.opacity(0.2))
                    .backgroundStyle(.ultraThinMaterial)
                    .opacity(menuScale)
                    .animation(Animation.linear)
                
                VStack{
                    VStack{
                        Text("MATH RUSH")
                            .font(.custom("Sigmar", size: 50))
                            .foregroundColor(Color(#colorLiteral(red: 0.1239937916, green: 0.1239937916, blue: 0.1239937916, alpha: 1)))
                            .shadow(color: .black, radius: 0.5)
                        Button("Start"){
                            goToPlay = true
                            playSound2(name: "button")
                        }
                        .buttonStyle(BorderedButton(rotationDeg: 2.0, width: 200, height: 60, fontSize: 20.0, cornerRadius: 10.0))
                        .padding(.bottom, 30)
                        Button("How to Play"){
                            playSound2(name: "button")
                            howToPlayShown = 1.0
                        }.buttonStyle(BorderedButton(rotationDeg: -0.5, width: 200, height: 60, fontSize: 20.0, cornerRadius: 10.0))
                    }
                    .padding(.top, (UIScreen.main.bounds.height / 6))
                    .scaleEffect(menuScale)
                    .animation(Animation.interpolatingSpring(stiffness: 120, damping: 10))
                    
                    Spacer()
                    ZStack{
                        Button("Let Me Play with the Bombs"){
                            menuScale = 0.0
                        }
                        .font(.custom("Sigmar", size: 12))
                        .foregroundColor(Color(#colorLiteral(red: 0.1239937916, green: 0.1239937916, blue: 0.1239937916, alpha: 1)))
                        .opacity(menuScale)
                        
                        Button("Enough Playing"){
                            menuScale = 1.0
                        }
                        .font(.custom("Sigmar", size: 12))
                        .foregroundColor(Color(#colorLiteral(red: 0.1239937916, green: 0.1239937916, blue: 0.1239937916, alpha: 1)))
                        .opacity(1.0 - menuScale)
                    }
                    .padding(.bottom, 40)
                }
                .onAppear {
                    playSoundLoop(name: "resonant-victory-glbml-22044")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        menuScale = 1.0
                    }
                }
                .navigationBarBackButtonHidden(true)
                
                ZStack {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Text("How to Play")
                            .foregroundColor(.white)
                            .font(.custom("Sigmar", size: 16))
                            .padding(.top, 40)
                            .padding(.bottom, 30)
                            .multilineTextAlignment(.center)
                        
                        
                        Text("The Bombe machine was created by British mathematician Alan Turing and his team during World War II. This huge complex electro-mechanical device was used by the British to decrypt German messages encrypted by the Enigma machine. By automating the analysis of potential Enigma settings, the machine greatly sped up the decryption process, playing a crucial role in the Allied victory and shortening the war.")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight:.medium))
                            .padding(.horizontal, 40)
                            .padding(.vertical, 30)
                            .multilineTextAlignment(.center)
                        
                        HStack {
                            Button(action:{
                                howToPlayShown = 0.0
                            }){
                                Text("Close")
                                    .padding(.vertical, 15)
                                    .padding(.horizontal, 20)
                                    .background(.white)
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                            }
                            .padding(.bottom, 40)
                        }
                    }
                    .frame(width: (UIScreen.main.bounds.width - 60), height: 300)
                    .background(Color(#colorLiteral(red: 0.1977964342, green: 0.1878973842, blue: 0.1880778372, alpha: 1)))
                    .cornerRadius(40)
                    .shadow(radius: 10)
                }
                .opacity(howToPlayShown)
                .animation(Animation.interpolatingSpring(stiffness: 120, damping: 10))
            }
        }
    }
}

struct BorderedButton: ButtonStyle {
    let rotationDeg: Double
    let width: Double
    let height: Double
    let fontSize: Double
    let cornerRadius: Double
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("Sigmar", fixedSize:fontSize))
            .padding(.horizontal, 15)
            .padding(.vertical, 5)
            .foregroundColor(configuration.isPressed ? Color.white : Color(#colorLiteral(red: 0.1239937916, green: 0.1239937916, blue: 0.1239937916, alpha: 1)))
            .overlay(
                ZStack{
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(configuration.isPressed ?  .white.opacity(0.2) : Color(#colorLiteral(red: 0.1239937916, green: 0.1239937916, blue: 0.1239937916, alpha: 1)).opacity(0.3))
                        .rotationEffect(.degrees(rotationDeg))
                        .frame(width: width, height: height)
                        .shadow(color: .black, radius: 5.0)
                }
            )
    }
}

struct SceneKitView: UIViewRepresentable {
    @State private var motionRate = CMAcceleration()

    private let motionManager = CMMotionManager()
    
    func makeUIView(context: Context) -> SCNView {
        // Create a SceneKit scene
        let scene = SCNScene(named: "MenuScene.scn")!
        scene.isPaused = false

        // Create a SceneKit view and add the scene to it
        let scnView = SCNView()
        scnView.autoenablesDefaultLighting = true
        scnView.scene = scene
        
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdates(to: .main) { data, _ in
            if let data = data {
                self.motionRate = data.gravity
                if let physicsWorld = scnView.scene?.physicsWorld {
                    physicsWorld.gravity = SCNVector3Make(Float(motionRate.x * 9.81), Float(self.motionRate.y * 9.81), Float(self.motionRate.z * 9.81))
                }
            }
        }
        
//        scnView.debugOptions = .showCameras
//        scnView.debugOptions = .showPhysicsShapes
//        scnView.allowsCameraControl = true
        
        return scnView
    }
    

    func updateUIView(_ uiView: SCNView, context: Context) {}
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}

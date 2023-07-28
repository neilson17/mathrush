//
//  PlayView.swift
//  mathrush
//
//  Created by Neilson Soeratman on 12/05/23.
//

import SwiftUI
import ARKit
import RealityKit

struct NumberPadView: View {
    @Binding var selectedNumber: String
    @Binding var health: Int
    @Binding var score: Int
    
    var body: some View {
        ZStack{
            VStack{
                VStack{
                    Text("Your Score: \(score)")
                        .font(.custom("Sigmar", size: 16))
                        .foregroundColor(Color(#colorLiteral(red: 0.1239937916, green: 0.1239937916, blue: 0.1239937916, alpha: 1)))
                    Text("Your Health: \(health)")
                        .font(.custom("Sigmar", size: 16))
                        .foregroundColor(Color(#colorLiteral(red: 0.1239937916, green: 0.1239937916, blue: 0.1239937916, alpha: 1)))
                }
                .padding(.top, 30)
                Spacer()
                VStack{
                    Text(selectedNumber)
                        .frame(height: 100)
                        .padding()
                    
                    Grid(alignment: .bottom, horizontalSpacing: 30, verticalSpacing: 30){
                        GridRow{
                            Button("7"){
                                selectedNumber = selectedNumber + "7"
                            }
                            .buttonStyle(BorderedButton(rotationDeg: 0.0, width: 70.0, height: 70.0, fontSize: 24.0, cornerRadius: 100.0))
                            Button("8"){
                                selectedNumber = selectedNumber + "8"
                            }
                            .buttonStyle(BorderedButton(rotationDeg: 0.0, width: 70.0, height: 70.0, fontSize: 24.0, cornerRadius: 100.0))
                            Button("9"){
                                selectedNumber = selectedNumber + "9"
                            }
                            .buttonStyle(BorderedButton(rotationDeg: 0.0, width: 70.0, height: 70.0, fontSize: 24.0, cornerRadius: 100.0))
                        }
                        GridRow{
                            Button("4"){
                                selectedNumber = selectedNumber + "4"
                            }
                            .buttonStyle(BorderedButton(rotationDeg: 0.0, width: 70.0, height: 70.0, fontSize: 24.0, cornerRadius: 100.0))
                            Button("5"){
                                selectedNumber = selectedNumber + "5"
                            }
                            .buttonStyle(BorderedButton(rotationDeg: 0.0, width: 70.0, height: 70.0, fontSize: 24.0, cornerRadius: 100.0))
                            Button("6"){
                                selectedNumber = selectedNumber + "6"
                            }
                            .buttonStyle(BorderedButton(rotationDeg: 0.0, width: 70.0, height: 70.0, fontSize: 24.0, cornerRadius: 100.0))
                        }
                        GridRow{
                            Button("1"){
                                selectedNumber = selectedNumber + "1"
                            }
                            .buttonStyle(BorderedButton(rotationDeg: 0.0, width: 70.0, height: 70.0, fontSize: 24.0, cornerRadius: 100.0))
                            Button("2"){
                                selectedNumber = selectedNumber + "2"
                            }
                            .buttonStyle(BorderedButton(rotationDeg: 0.0, width: 70.0, height: 70.0, fontSize: 24.0, cornerRadius: 100.0))
                            Button("3"){
                                selectedNumber = selectedNumber + "3"
                            }
                            .buttonStyle(BorderedButton(rotationDeg: 0.0, width: 70.0, height: 70.0, fontSize: 24.0, cornerRadius: 100.0))
                        }
                        GridRow{
                            Button("X"){
                                selectedNumber = ""
                            }
                            .buttonStyle(BorderedButton(rotationDeg: 0.0, width: 70.0, height: 70.0, fontSize: 24.0, cornerRadius: 100.0))
                            Button("0"){
                                selectedNumber = selectedNumber + "0"
                            }
                            .buttonStyle(BorderedButton(rotationDeg: 0.0, width: 70.0, height: 70.0, fontSize: 24.0, cornerRadius: 100.0))
                            Button("<"){
                                if (selectedNumber != ""){
                                    selectedNumber.removeLast()
                                }
                            }
                            .buttonStyle(BorderedButton(rotationDeg: 0.0, width: 70.0, height: 70.0, fontSize: 24.0, cornerRadius: 100.0))
                        }
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var questionAnswer: [AnchorEntity]
    @State var health: Int = 3
    @State var wrong: Double = 0.0
    @EnvironmentObject var timer: TimerClass
    @EnvironmentObject var timer2: TimerClass2
    @Binding var goToNextView: Bool
    @State private var selectedNumber: String = ""
    @State private var score: Int = 0
    @Binding var scoreFinal: Int
    
    var bombTimer: Timer?
    var arView = ARView(frame: .zero)
    var bombNumber = 1
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func checkAnswer(){
        if let index = questionAnswer.firstIndex(where: { String($0.name).split(separator: "_")[1] == "\(selectedNumber)" }) {
            questionAnswer[index].removeFromParent()
            questionAnswer.remove(at: index)
            score = score + 10
            selectedNumber = ""
            print("removed")
            playSound2(name: "correct")
        }
    }
    
    // ARView configuration
    func makeUIView(context: Context) -> ARView {
        let config = ARWorldTrackingConfiguration()
        
//        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
//            fatalError("error")
//        }
//        config.detectionImages = referenceImages
        
        config.wantsHDREnvironmentTextures = true
        config.planeDetection = [.horizontal, .vertical]
        arView.session.run(config, options: [])
        arView.session.delegate = context.coordinator
        
        timer.timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { timer in
            let questionStr = generateQuestionEasy().split(separator: ";")
            spawnBomb(name: "bomb_\(questionStr[0])", question: "\(questionStr[1])")
        }
        timer2.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            checkAnswer()
        }
        
        let numberPadView = NumberPadView(selectedNumber: $selectedNumber, health: $health, score: $score)
        
        let arViewContainer = UIHostingController(rootView: numberPadView)
        arViewContainer.view.backgroundColor = .clear
        arView.addSubview(arViewContainer.view)
        
        // Position the number pad view in the AR view
        arViewContainer.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arViewContainer.view.topAnchor.constraint(equalTo: arView.topAnchor),
            arViewContainer.view.leadingAnchor.constraint(equalTo: arView.leadingAnchor),
            arViewContainer.view.trailingAnchor.constraint(equalTo: arView.trailingAnchor),
            arViewContainer.view.bottomAnchor.constraint(equalTo: arView.bottomAnchor),
        ])
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    class Coordinator: NSObject, ARSessionDelegate {
        let parent: ARViewContainer
        
        init(_ parent: ARViewContainer) {
            self.parent = parent
            super.init()
        }
        
        func sessionWasInterrupted(_ session: ARSession) {
            parent.timer.timer?.invalidate()
            parent.timer2.timer?.invalidate()
            parent.arView.session.pause()
        }
        
        func sessionInterruptionEnded(_ session: ARSession) {
            let config = ARWorldTrackingConfiguration()
            config.planeDetection = [.horizontal, .vertical]
            parent.arView.session.run(config, options: [])
        }
    }
    
    private func generateQuestionEasy() -> String {
        // Pertambahan dan pengurangan hanya sampe 20
        // Multiplication dari 1 digit dikali 1 digit
        // Division hasilnya 1 digit
        let operatorRand = Int.random(in: 1...4)
        var operatorSign = ""
        var answer = 0
        var firstNumber = 0
        var secondNumber = 0
        
        if (operatorRand == 1) { // addition
            firstNumber = Int.random(in: 1...20)
            secondNumber = Int.random(in: 1...20)
            operatorSign = "+"
            answer = firstNumber + secondNumber
        }
        else if (operatorRand == 2){ // subtraction
            firstNumber = Int.random(in: 1...20)
            secondNumber = Int.random(in: 1...20)
            while (firstNumber <= secondNumber){
                firstNumber = Int.random(in: 1...20)
                secondNumber = Int.random(in: 1...20)
            }
            operatorSign = "-"
            answer = firstNumber - secondNumber
        }
        else if (operatorRand == 3){ // multiplication
            firstNumber = Int.random(in: 1...9)
            secondNumber = Int.random(in: 0...9)
            operatorSign = "x"
            answer = firstNumber * secondNumber
        }
        else { // division
            answer = Int.random(in: 1...9)
            secondNumber = Int.random(in: 1...9)
            firstNumber = answer * secondNumber
            operatorSign = "/"
        }
        
        return "\(answer);\(firstNumber) \(operatorSign) \(secondNumber)"
    }
    
    private func spawnBomb(name: String, question: String) {
        var angleVal = Int.random(in: 0...360) // randomize angle 0-360
        while(true){
            var breakNow = false
            if (questionAnswer.count > 0){
                for entityBomb in questionAnswer{
                    let angleLoop = entityBomb.name.split(separator: "_")[2]
                    if (abs(angleVal - (Int("\(angleLoop)") ?? 0)) <= 30){
                        angleVal = Int.random(in: 0...360)
                    }
                    else {
                        breakNow = true
                    }
                }
            }
            else {
                breakNow = true
            }
            if(breakNow){
                break
            }
        }
        let angle = degToRad(degree: angleVal)
        
        // =============================== BOMB ===============================
        let distance = 1.7
        
        let x = Float(sin(Double(angle)) * distance)
        let y = Float(0.0)
        let z = Float(cos(Double(angle)) * distance)
        
        let entity = try! ModelEntity.loadModel(named: "Round_Bomb")
        entity.position = [x, y, z]
        entity.scale = [0.025, 0.025, 0.025]
        
        // =============================== TEXT ===============================
        let textMesh = MeshResource.generateText(
            question,
            extrusionDepth: 0.1,
            font: UIFont(name: "Sigmar", size: 6) ?? .systemFont(ofSize: 4),
            containerFrame: CGRect(),
            alignment: .center,
            lineBreakMode: .byTruncatingMiddle
        )
        let textMaterial = SimpleMaterial(color: .white, isMetallic: false)
        let textModel = ModelEntity(mesh: textMesh, materials: [textMaterial])
        
        textModel.look(at: [0,y,0], from: [-x, y, -z], relativeTo: nil)
        
        textModel.position = [x, (y + 14), z]
        entity.addChild(textModel)
        
        // =============================== ADD BOMB & TEXT ===============================
        let anchor = AnchorEntity()
        anchor.name = "\(name)_\(angleVal)"
        print(anchor.name)
        arView.scene.anchors.append(anchor)
        
        // Add bomb and text nodes to the scene
        anchor.addChild(entity)
        arView.scene.addAnchor(anchor)
        questionAnswer.append(anchor)
        
        // Schedule bomb and text node removal
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            if let index = questionAnswer.firstIndex(where: { $0.name == "\(name)_\(angleVal)" }) {
                questionAnswer[index].removeFromParent()
                questionAnswer.remove(at: index)
                
                health = health - 1
                
                print("health berkurang")
                playSound2(name: "explosion-6055")
                if (health <= 0){
                    timer.timer?.invalidate()
                    timer2.timer?.invalidate()
                    
                    self.arView.removeFromSuperview()
                    self.arView.session.pause()
                    arView.session.delegate = nil
                    
                    goToNextView = true
                    scoreFinal = score
                }
            }
        }
    }
    
    private func degToRad(degree: Int) -> Double{
        return Double(degree) * Double.pi / 180.0
    }
}

struct PlayView: View {
    @State public var questionAnswer: [AnchorEntity] = []
    @State public var goToNextView: Bool = false
    @State public var scoreFinal: Int = 0
    
    var body: some View {
        NavigationView{
            ZStack{
                ARViewContainer(questionAnswer: $questionAnswer, goToNextView: $goToNextView, scoreFinal: $scoreFinal)
                    .ignoresSafeArea()
                NavigationLink(destination: ResultView(score: scoreFinal), isActive: $goToNextView, label: {})
            }
            .onAppear{
                playSoundLoop(name: "addiction")
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView()
    }
}

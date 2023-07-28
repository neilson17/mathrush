//
//  GyroView.swift
//  mathrush
//
//  Created by Neilson Soeratman on 11/05/23.
//

import SwiftUI
import CoreMotion

struct GyroView: View {
    @State private var rotationRate = CMRotationRate()

    private let motionManager = CMMotionManager()

    var body: some View {
        VStack {
            Text("Gyroscope Rotation Rate")
                .font(.title)

            Text("x: \(rotationRate.x)")
            Text("y: \(rotationRate.y)")
            Text("z: \(rotationRate.z)")
        }
        .onAppear {
            motionManager.gyroUpdateInterval = 0.1
            motionManager.startGyroUpdates(to: .main) { data, _ in
                if let data = data {
                    self.rotationRate = data.rotationRate
                }
            }
        }
        .onDisappear {
            motionManager.stopGyroUpdates()
        }
    }
}

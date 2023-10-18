//
//  ContentView.swift
//  MetalBug
//
//  Created by Todd Littlejohn on 10/17/23.
//

import SwiftUI

struct ContentView: View {
    
    let bugManager = BugManager()
    
    var body: some View {
        VStack {
            Button("Run The MF Metal") {
                Task {
                    await compareGpuAndCpu()
                }
            }
        }
        .padding()
    }
    
    func compareGpuAndCpu() async {
        let results = bugManager.getResults()
        let r1Results = results.0
        let r2Results = results.1
        for r1 in r1Results {
            print("r1: \(r1)")
        }
        for r2 in r2Results {
            print("r2: \(r2)")
        }
    }
}

#Preview {
    ContentView()
}

import Foundation
import RealityKit
import Combine
import Metal

class BugManager: ObservableObject {
    
    let metalBug: MetalBug
    let units = 3000
            
    init() {
        if let device = MTLCreateSystemDefaultDevice() {
            metalBug = MetalBug(device: device, arrayLength: units )
        } else {
            fatalError()
        }
    }
        
    func getResults() -> ( [Float32], [Float32] ) {
        metalBug.sendComputeCommand()
        return metalBug.getResults()
    }
        
}

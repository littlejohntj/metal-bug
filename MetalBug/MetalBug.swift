//
//  MetalBug.swift
//  MetalBug
//
//  Created by Todd Littlejohn on 10/17/23.
//

import Foundation
import Metal

class MetalBug {
    
    private let arrayLength: Int
    
    let device: MTLDevice
    let pipelineState: MTLComputePipelineState
    let commandQueue: MTLCommandQueue
    
    var r1: MTLBuffer
    var r2: MTLBuffer

    init( device: MTLDevice, arrayLength: Int ) {
        
        guard let defaultLibrary = device.makeDefaultLibrary() else { fatalError() }
        guard let computeCubeFunction = defaultLibrary.makeFunction(name: "test_bug") else { fatalError() }
        self.pipelineState = try! device.makeComputePipelineState(function: computeCubeFunction)
        guard let commandQueue = device.makeCommandQueue() else { fatalError() }
        self.commandQueue = commandQueue
        
        self.r1 = device.makeBuffer(length: arrayLength * MemoryLayout<Float32>.size, options: .storageModeShared)!
        self.r2 = device.makeBuffer(length: arrayLength * MemoryLayout<Float32>.size, options: .storageModeShared)!
        
        self.device = device
        self.arrayLength = arrayLength

    }
    
    func sendComputeCommand() {
        
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { fatalError() }
        guard let computeEncoder = commandBuffer.makeComputeCommandEncoder() else { fatalError() }
        self.encoderAddCommand(encoder: computeEncoder)
        computeEncoder.endEncoding()
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
    
    }
    
    func encoderAddCommand( encoder: MTLComputeCommandEncoder ) {
        
        encoder.setComputePipelineState(pipelineState)
        encoder.setBuffer(r1, offset: 0, index: 0)
        encoder.setBuffer(r2, offset: 0, index: 1)
        
        let gridSize = MTLSize(width: arrayLength, height: 1, depth: 1)
        var threadGroupSize = pipelineState.maxTotalThreadsPerThreadgroup
        if threadGroupSize > arrayLength {
            threadGroupSize = arrayLength
        }
        let threadgroupSize = MTLSizeMake(threadGroupSize, 1, 1);
        encoder.dispatchThreadgroups(gridSize, threadsPerThreadgroup: threadgroupSize)
        
    }
    
    func getResults() -> ( [Float32], [Float32] ) {
        
        let floatLen: Int = MemoryLayout<Float32>.size
        
        let r1Ptr = r1.contents()
        
        let r1Values = (0..<(arrayLength)).map { r1Index in
            return r1Ptr.load(fromByteOffset: r1Index * floatLen , as: Float32.self)
        }
        
        let r2Ptr = r2.contents()
        
        let r2Values = (0..<(arrayLength)).map { r2Index in
            return r2Ptr.load(fromByteOffset: r2Index * floatLen, as: Float32.self)
        }
        
        return ( r1Values, r2Values )

    }



    
}

//
//  bug.metal
//  MetalBug
//
//  Created by Todd Littlejohn on 10/17/23.
//

#include <metal_stdlib>
using namespace metal;

kernel void test_bug(
                     device float* r1,
                     device float* r2,
                     uint index [[thread_position_in_grid]])
{
    r1[index] = 11.1;
    r2[index] = 22.2;
}

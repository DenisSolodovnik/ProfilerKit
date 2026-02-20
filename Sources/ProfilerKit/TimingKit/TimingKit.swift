//
//  TimingKit.swift
//  ProfileKit
//
//  Created by Денис Солодовник on 20.02.2026.
//

import Foundation
import Darwin

public struct TimingKitParameters {

    let isLogEnabled: Bool
    let prefix: String
    let decimalCount: Int
    let skipFirstIterations: Int
    let iterations: Int

    /// Options Constructor
    /// - Parameters:
    ///   - logEnabled: Should the result be printed to the console?
    ///   - decimalCount: Number of decimal part
    ///   - numberOfChecks: Number of code checks
    public init(
        logEnabled: Bool = true,
        prefix: String = "Test result",
        decimalCount: Int = 5,
        skipFirstIterations: Int = 50,
        iterations: Int = 150
    ) {
        self.isLogEnabled = logEnabled
        self.prefix = prefix
        self.decimalCount = decimalCount
        self.skipFirstIterations = skipFirstIterations
        self.iterations = iterations
    }
}

#if PROFILERKIT_ENABLED

// Precompute the factor to convert mach_absolute_time ticks to seconds.
// This is done once at load time so that each loop iteration performs only
// a single multiplication, without extra type conversions or closure calls.
private let secondsPerTickFactor: Double = {
    var tb = mach_timebase_info_data_t()
    mach_timebase_info(&tb)
    // secondsPerTick = (numer/denom) * 1e-9
    return (Double(tb.numer) / Double(tb.denom)) / 1_000_000_000.0
}()

// TimingKit is used to test code execution speed.
public struct TimingKit {

    public init() {}

    /// Testing code execution speed
    /// - Parameters:
    ///   - function: Your code closure to benchmark.
    ///   - parameters: Fine-tuning parameters.
    /// - Returns: Average execution time in seconds over collected samples.
    public func test(
        function: () -> Void,
        parameters: TimingKitParameters = .init()
    ) -> Double {

        // Enforce a minimum number of total iterations (10) to stabilize results.
        let requestedIterations = parameters.iterations
        let iterations = max(requestedIterations, 10)
        if parameters.isLogEnabled, iterations != requestedIterations {
            print("\(parameters.prefix): warning - numberOfChecks=\(requestedIterations) is below minimum 10; using \(iterations).")
        }

        // Warmup semantics:
        // - Skip exactly `skipFirstChecks` initial iterations.
        // - Include samples starting from index >= skipFirstChecks.
        // - Clamp warmup to [0, iterations - 1] to guarantee at least one sample.
        let requestedWarmup = parameters.skipFirstIterations
        let warmupCount = max(0, min(requestedWarmup, iterations - 1))
        if parameters.isLogEnabled, warmupCount != requestedWarmup {
            if requestedWarmup < 0 {
                print("\(parameters.prefix): warning - skipFirstChecks=\(requestedWarmup) is negative; using 0.")
            } else if requestedWarmup >= iterations {
                print("\(parameters.prefix): warning - skipFirstChecks=\(requestedWarmup) is too large for iterations=\(iterations); using \(warmupCount).")
            }
        }

        // Preallocate storage: number of samples = iterations - warmupCount.
        var timings: [Double] = []
        timings.reserveCapacity(iterations - warmupCount)

        for index in 0..<iterations {
            let start = mach_absolute_time()
            function()
            let end = mach_absolute_time()

            // Conversion happens AFTER measuring the delta, so it does not affect
            // the measured execution interval of function().
            let duration = Double(end &- start) * secondsPerTickFactor

            // Include sample if index >= warmupCount
            if index >= warmupCount {
                timings.append(duration)
            }
        }

        // With warmupCount <= iterations - 1, timings is guaranteed to be non-empty.
        let samplesCount = timings.count
        let average = timings.reduce(0, +) / Double(samplesCount)

        if parameters.isLogEnabled {
            let str = String(format: "\(parameters.prefix): %.\(parameters.decimalCount)f sec.", average)
            print(str)
        }

        return average
    }
}

#else
public struct TimingKit {

    public init() {}

    @discardableResult
    public func test(
        function: () -> Void,
        parameters: TimingKitParameters = .init()
    ) -> Double {
        return -1
    }
}
#endif

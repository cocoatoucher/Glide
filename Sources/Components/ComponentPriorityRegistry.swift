//
//  ComponentPriorityRegistry.swift
//  glide
//
//  Copyright (c) 2019 cocoatoucher user on github.com (https://github.com/cocoatoucher/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import GameplayKit

/// That class is a singleton used to keep a record of the priorities for each
/// `GKComponent that adopts `GlideComponent`.
public class ComponentPriorityRegistry {
    
    public static var shared = ComponentPriorityRegistry()
    
    /// Returns the registered priority for a given component type.
    ///
    /// - Parameters:
    ///     - componentType: Type of the component to fetch the priority for.
    /// Note that the component of this type should also adopt to `GlideComponent`
    public func priority(for componentType: GKComponent.Type) -> Int {
        for obj in componentTypeToPriority {
            if obj.value.firstIndex(where: { $0 === componentType }) != nil {
                return obj.key
            }
        }
        return 0
    }
    
    /// Prints the registered priorities of component types in the app bundle.
    /// Note that, this works only if `DEBUG` flag is enabled during compile time.
    public func prettyPrintPriorityList() {
        #if DEBUG
        let sorted = componentTypeToPriority.sorted { (left, right) -> Bool in
            return left.key < right.key
        }
        
        for obj in sorted {
            for value in obj.value {
                if let className = NSString(string: "\(value)").utf8String {
                    let result = String(format: "%-50s %d", className, obj.key)
                    print(result)
                }
                
            }
        }
        #endif
    }
    
    // MARK: - Internal
    
    func initializeIfNeeded() {
        initialize()
    }
    
    // MARK: - Private
    
    private var componentTypeToPriority: [Int: [GKComponent.Type]] = [:]
    
    /// Flag to prevent component priority registration more than once.
    private var didInitialize: Bool = false
    
    private init() {
        initialize()
    }
    
    private func initialize() {
        guard didInitialize == false else {
            return
        }
        
        didInitialize = true
        
        var numClasses: Int32 = 0
        var allClasses: AutoreleasingUnsafeMutablePointer<AnyClass>?
        defer {
            allClasses = nil
        }
        
        numClasses = objc_getClassList(nil, 0)
        
        if numClasses > 0 {
            var ptr = UnsafeMutablePointer<AnyClass?>.allocate(capacity: Int(numClasses))
            defer {
                ptr.deinitialize(count: 1)
                ptr.deallocate()
            }
            allClasses = AutoreleasingUnsafeMutablePointer<AnyClass>(ptr)
            numClasses = objc_getClassList(allClasses, numClasses)
            
            for i in 0 ..< numClasses {
                guard let currentClass: AnyClass = allClasses?[Int(i)] else {
                    continue
                }
                if
                    let glideComponentClass = currentClass as? GlideComponent.Type,
                    let gkComponentClass = currentClass as? GKComponent.Type {
                    setPriority(glideComponentClass.componentPriority, for: gkComponentClass)
                }
            }
        }
    }
    
    private func setPriority(_ priority: Int, for componentType: GKComponent.Type) {
        for obj in componentTypeToPriority {
            if let index = obj.value.firstIndex(where: { $0 === componentType }) {
                var types = obj.value
                types.remove(at: index)
                componentTypeToPriority[obj.key] = types
                break
            }
        }
        
        var types: [GKComponent.Type] = []
        if let existingTypes = componentTypeToPriority[priority] {
            types = existingTypes
        }
        
        types.append(componentType)
        componentTypeToPriority[priority] = types
    }
    
}

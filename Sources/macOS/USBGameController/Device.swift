//
//  Device.swift
//  glide
//
//  Ported from https://www.dribin.org/dave/software/#ddhidlib
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

#if os(macOS)
import Foundation
import IOKit
import CoreFoundation

private var kIOHIDDeviceUserClientTypeID: CFUUID {
    return CFUUIDGetConstantUUIDWithBytes(nil,
                                          0xFA, 0x12, 0xFA, 0x38, 0x6F, 0x1A, 0x11, 0xD4,
                                          0xBA, 0x0C, 0x00, 0x05, 0x02, 0x8F, 0x18, 0xD5)
}

private var kIOCFPlugInInterfaceID: CFUUID {
    return CFUUIDGetConstantUUIDWithBytes(nil,
                                          0xC2, 0x44, 0xE8, 0x58, 0x10, 0x9C, 0x11, 0xD4,
                                          0x91, 0xD4, 0x00, 0x50, 0xE4, 0xC6, 0x42, 0x6F)
}

private var kIOHIDDeviceInterfaceID: CFUUID {
    return CFUUIDGetConstantUUIDWithBytes(nil,
                                          0x78, 0xBD, 0x42, 0x0C, 0x6F, 0x14, 0x11, 0xD4,
                                          0x94, 0x74, 0x00, 0x05, 0x02, 0x8F, 0x18, 0xD5)
}

extension USBGameController {
    
    internal class Device {
        
        weak var delegate: USBGameControllerDeviceDelegate?
        
        var uniqueId: String? {
            return (properties?[kIOHIDLocationIDKey] as? NSNumber)?.stringValue
        }
        
        var locationId: CLong? {
            return properties?[kIOHIDLocationIDKey] as? CLong
        }
        
        var vendorId: Int? {
            return properties?[kIOHIDVendorIDKey] as? Int
        }
        
        var productId: Int? {
            return properties?[kIOHIDProductIDKey] as? Int
        }
        
        var logicalDeviceElements: [[Element]] = []
        let elementsByCookie: [UInt: Element]
        var buttons: [Element] = []
        var sticks: [Stick] = []
        
        init?(device: io_object_t, logicalDeviceNumber: Int) {
            
            self.device = device
            self.logicalDeviceNumber = logicalDeviceNumber
            IOObjectRetain(device)
            
            // Properties
            
            var properties: Unmanaged<CFMutableDictionary>?
            let result = IORegistryEntryCreateCFProperties(device, &properties, kCFAllocatorDefault, 0)
            if result != kIOReturnSuccess {
                return nil
            }
            
            let propertiesAsDictionary = properties?.takeUnretainedValue() as? [String: AnyObject]
            self.properties = propertiesAsDictionary
            
            guard let transport = self.properties?[kIOHIDTransportKey] as? String else {
                return nil
            }
            
            let vendorId = propertiesAsDictionary?[kIOHIDVendorIDKey] as? Int
            let productId = propertiesAsDictionary?[kIOHIDProductIDKey] as? Int
            // Making an exception for Joy-Cons 🧙🏼‍♂️🕹
            let isJoyCon = transport == "Bluetooth" && vendorId == 1406 && (productId == 8198 || productId == 8199)
            guard transport == "USB" || isJoyCon else {
                return nil
            }
            
            if let elements = self.properties?[kIOHIDElementKey] as? [[String: AnyObject]] {
                self.elements = elements.map { Element(properties: $0) }
            } else {
                self.elements = []
            }
            
            var elementsByCookie = [UInt: Element]()
            for element in elements {
                if let cookie = element.properties[kIOHIDElementCookieKey] as? UInt {
                    elementsByCookie[cookie] = element
                }
            }
            self.elementsByCookie = elementsByCookie
            
            self.primaryUsage = Usage(properties: self.properties ?? [:], variant: .primary)
            
            let usagePairs = self.properties?[kIOHIDDeviceUsagePairsKey] as? [[String: AnyObject]]
            self.usages = usagePairs?.map { Usage(properties: $0, variant: .device) } ?? []
            
            // Device interface
            guard let plugInInterface = setupDeviceInterface() else {
                return nil
            }
            
            // Now done with the plugin interface.
            _ = plugInInterface.pointee?.pointee.Release(plugInInterface)
            
            setupLogicalDeviceElements()
            
            if logicalDeviceElements.isEmpty {
                return nil
            }
            
            if self.logicalDeviceNumber >= logicalDeviceElements.count {
                self.logicalDeviceNumber = logicalDeviceElements.count - 1
            }
            
            let stickElements = logicalDeviceElements[self.logicalDeviceNumber]
            setupJoystickElements(for: stickElements)
        }
        
        func startListening() {
            guard isListening == false else {
                return
            }

            _ = deviceInterface?.pointee?.pointee.open(deviceInterface, 0x00)

            eventQueue = createQueueWithSize(10)
            eventQueue?.delegate = self
            addElementsToEventQueue()
            eventQueue?.startOnCurrentRunLoop()
        }

        func stopListening() {
            guard isListening else {
                return
            }

            eventQueue?.stop()
            eventQueue = nil
            _ = deviceInterface?.pointee?.pointee.close(deviceInterface)
        }
        
        // MARK: - Private
        
        private let device: io_object_t
        private var logicalDeviceNumber: Int
        private let properties: [String: AnyObject]?
        private let elements: [Element]
        private let primaryUsage: Usage
        private let usages: [Usage]
        private var deviceInterface: UnsafeMutablePointer<UnsafeMutablePointer<IOHIDDeviceInterface122>?>?
        private var eventQueue: EventQueue?
        
        private var isListening: Bool {
            return eventQueue != nil
        }
        
        private func setupDeviceInterface() -> UnsafeMutablePointer<UnsafeMutablePointer<IOCFPlugInInterface>?>? {
            var plugInInterface: UnsafeMutablePointer<UnsafeMutablePointer<IOCFPlugInInterface>?>?
            var score: Int32 = 0

            let result = IOCreatePlugInInterfaceForService(device,
                                                           kIOHIDDeviceUserClientTypeID,
                                                           kIOCFPlugInInterfaceID,
                                                           &plugInInterface,
                                                           &score)
            if result != kIOReturnSuccess {
                return nil
            }

            _ = withUnsafeMutablePointer(to: &deviceInterface) {
                $0.withMemoryRebound(to: Optional<LPVOID>.self, capacity: 1) {
                    plugInInterface?.pointee?.pointee.QueryInterface(
                        plugInInterface,
                        CFUUIDGetUUIDBytes(kIOHIDDeviceInterfaceID),
                        $0)
                }
            }

            if result == kIOReturnSuccess {
                return plugInInterface
            }
            return nil
        }
        
        private func setupLogicalDeviceElements() {
            for element in elements {
                
                if element.usage.page == kHIDPage_GenericDesktop &&
                    (element.usage.id == kHIDUsage_GD_Joystick || element.usage.id == kHIDUsage_GD_GamePad) {
                    logicalDeviceElements.append([element])
                }
            }
        }
        
        private func setupJoystickElements(for elements: [Element]) {
            let currentStick = Stick()
            var stickHasElements: Bool = false
            
            for element in elements {
                let usageId = element.usage.id
                let usagePage = element.usage.page
                
                if element.subElements.isEmpty == false {
                    setupJoystickElements(for: element.subElements)
                } else if usagePage == kHIDPage_GenericDesktop && usageId == kHIDUsage_GD_Pointer {
                    #if DEBUG
                    print("ignored")
                    #endif
                } else if currentStick.attemptToAddElement(element) == true {
                    stickHasElements = true
                } else if usagePage == kHIDPage_Button && usageId > 0 {
                    buttons.append(element)
                }
            }
            
            if stickHasElements {
                sticks.append(currentStick)
            }
        }
        
        private func addElementsToEventQueue() {
            sticks.forEach { eventQueue?.addElements($0.allElements) }
            eventQueue?.addElements(buttons)
        }
        
        private func createQueueWithSize(_ size: UInt32) -> EventQueue? {
            let q = deviceInterface?.pointee?.pointee.allocQueue(deviceInterface)
            guard let hidQueue = q else {
                return nil
            }
            
            return EventQueue(hidQueue: hidQueue, size: size)
        }
        
        deinit {
            if deviceInterface != nil {
                _ = deviceInterface?.pointee?.pointee.close(deviceInterface)
                _ = deviceInterface?.pointee?.pointee.Release(deviceInterface)
            }
            IOObjectRelease(device)
            deviceInterface = nil
        }
    }
}
#endif

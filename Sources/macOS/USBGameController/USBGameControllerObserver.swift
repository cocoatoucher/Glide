//
//  CustomGameControllerObserver.swift
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

internal class USBGameControllerObserver {
    let managerRef = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))

    var didUpdateControllersHandler: (([USBGameController.Device]) -> Void)?

    init() {
        let deviceMatches: [[String: Any]] = [
            [kIOHIDDeviceUsagePageKey: kHIDPage_GenericDesktop, kIOHIDDeviceUsageKey: kHIDUsage_GD_Joystick],
            [kIOHIDDeviceUsagePageKey: kHIDPage_GenericDesktop, kIOHIDDeviceUsageKey: kHIDUsage_GD_GamePad],
            [kIOHIDDeviceUsagePageKey: kHIDPage_GenericDesktop, kIOHIDDeviceUsageKey: kHIDUsage_GD_MultiAxisController],
        ]

        IOHIDManagerSetDeviceMatchingMultiple(managerRef, deviceMatches as CFArray)
        IOHIDManagerScheduleWithRunLoop(managerRef, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
        IOHIDManagerOpen(managerRef, IOOptionBits(kIOHIDOptionsTypeNone))

        let matchingCallback: IOHIDDeviceCallback = { inContext, _, _, inIOHIDDeviceRef in

            print("added")
            print(inIOHIDDeviceRef)

            let this: USBGameControllerObserver = unsafeBitCast(inContext, to: USBGameControllerObserver.self)
            this.didUpdateControllersHandler?(this.connectedControllers)
        }

        let removalCallback: IOHIDDeviceCallback = { inContext, _, _, _ in

            print("removed")

            let this: USBGameControllerObserver = unsafeBitCast(inContext, to: USBGameControllerObserver.self)
            this.didUpdateControllersHandler?(this.connectedControllers)
        }

        IOHIDManagerRegisterDeviceMatchingCallback(managerRef, matchingCallback, unsafeBitCast(self, to: UnsafeMutableRawPointer.self))
        IOHIDManagerRegisterDeviceRemovalCallback(managerRef, removalCallback, unsafeBitCast(self, to: UnsafeMutableRawPointer.self))
    }

    var connectedControllers: [USBGameController.Device] {
        let allGamePads = allDevicesMatching(usagePage: kHIDPage_GenericDesktop,
                                             usageId: kHIDUsage_GD_GamePad,
                                             skipZeroLocations: true)
        let allJoysticks = allDevicesMatching(usagePage: kHIDPage_GenericDesktop,
                                              usageId: kHIDUsage_GD_Joystick,
                                              skipZeroLocations: true)
        let allMultiAxisControllers = allDevicesMatching(usagePage: kHIDPage_GenericDesktop,
                                                         usageId: kHIDUsage_GD_MultiAxisController,
                                                         skipZeroLocations: true)
        var all = (allGamePads ?? []) + (allJoysticks ?? []) + (allMultiAxisControllers ?? [])
        all.sort { (leftDevice, rightDevice) -> Bool in
            let leftLocationId = leftDevice.locationId ?? 0
            let rightLocationId = rightDevice.locationId ?? 0

            return leftLocationId < rightLocationId
        }

        return all
    }

    func allDevicesMatching(usagePage: Int, usageId: Int, skipZeroLocations: Bool) -> [USBGameController.Device]? {
        guard let dictionary = IOServiceMatching(kIOHIDDeviceKey) else {
            return nil
        }

        (dictionary as NSMutableDictionary).setValue(usagePage, forKey: kIOHIDDeviceUsagePageKey)
        (dictionary as NSMutableDictionary).setValue(usageId, forKey: kIOHIDDeviceUsageKey)

        return createDevicesWith(dictionary: dictionary, skipZeroLocations: false)
    }

    func createDevicesWith(dictionary: CFMutableDictionary, skipZeroLocations: Bool) -> [USBGameController.Device]? {
        var hidObjectIterator = io_iterator_t(MACH_PORT_NULL)
        let result = IOServiceGetMatchingServices(kIOMasterPortDefault, dictionary, &hidObjectIterator)
        if result != kIOReturnSuccess {
            return nil
        }

        guard hidObjectIterator > 0 else {
            return nil
        }

        var allDevices: [USBGameController.Device] = []
        while case let hidDevice = IOIteratorNext(hidObjectIterator), hidDevice != 0 {
            if let devices = self.devices(for: hidDevice, skipZeroLocations: skipZeroLocations) {
                allDevices.append(contentsOf: devices)
            }
        }
        if hidObjectIterator != MACH_PORT_NULL {
            IOObjectRelease(hidObjectIterator)
        }

        return allDevices
    }

    func devices(for hidDevice: io_object_t, skipZeroLocations: Bool) -> [USBGameController.Device]? {
        guard let device = USBGameController.Device(device: hidDevice, logicalDeviceNumber: 0) else {
            return nil
        }
        if device.locationId == 0 && skipZeroLocations {
            return nil
        }

        var result = [device]

        for index in device.logicalDeviceElements.indices {
            if let device = USBGameController.Device(device: hidDevice, logicalDeviceNumber: index + 1) {
                result.append(device)
            }
        }

        return result
    }
}
#endif

//
//  KibeaconBlocks.h
//  iOS-Kibeacon-SDK
//
//  Created by thenopen on 2014. 10. 27..
//  Copyright (c) 2014년 KIES. All rights reserved.
//

#ifndef iOS_Kibeacon_SDK_KibeaconBlocks_h
#define iOS_Kibeacon_SDK_KibeaconBlocks_h

#import <CoreBluetooth/CoreBluetooth.h>
@class KBPeripheral;
/// Object Status Changed
typedef void(^KBObjectChangedBlock)(NSError * error);
/// Peripheral Read RSS
typedef void(^KBPeripheralRSSIBlock)(NSError *error);
/// The Kibeacon Scan Service Status has Changed
typedef void(^KBPeripheralBlock)(KBPeripheral * peripheral);
/// The Kibeacon Connected
typedef void(^KBPeripheralConnectionBlock)(KBPeripheral * peripheral,NSError * error);
/// The Kibeacon Characteristic Read
typedef void(^KBCentralReadRequestBlock)(NSDictionary *dict, unsigned long serviceCount);
/// The Kibeacon Characteristic Write
typedef void(^KBCharacteristicChangedBlock)(CBCharacteristic * characteristic, NSError * error);
/// The Kibeacon Specify Service Updated
typedef void(^KBSpecifiedServiceUpdatedBlock)(CBService * service,NSError * error);
#endif

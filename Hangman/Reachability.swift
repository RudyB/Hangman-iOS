//
//  Reachability.swift
//  Hangman
//
//  Created by Rudy Bermudez on 6/19/16.
//  Copyright © 2016 Rudy Bermudez. All rights reserved.
//

import Foundation
import SystemConfiguration

open class Reachability {
	class func isConnectedToNetwork() -> Bool {
//		var zeroAddress = sockaddr_in()
//		zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
//		zeroAddress.sin_family = sa_family_t(AF_INET)
//		let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
//			SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
//		}
//		var flags = SCNetworkReachabilityFlags()
//		if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
//			return false
//		}
//		let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
//		let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
//		return (isReachable && !needsConnection)
		return true
	}
	enum ConnectivityErrors: Error {
		case noActiveInternetConnection
	}
}

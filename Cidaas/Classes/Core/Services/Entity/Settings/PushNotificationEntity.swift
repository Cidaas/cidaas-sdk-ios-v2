//
//  PushNotificationEntity.swift
//  Cidaas
//
//  Created by ganesh on 30/11/18.
//

import Foundation

public class PushNotificationEntity : Codable {
    public var requestTime : Int64 = 0
    public var physicalVerificationId : String = ""
    public var statusId : String = ""
    public var sub : String = ""
    public var verificationType : String = ""
    public var randomNumbers : String = ""
    public var address : PushAddress = PushAddress()
    public var deviceInfo : PushDeviceInfo = PushDeviceInfo()
    
    public var dataShareType: String = ""
    public var baseurl: String = ""
    public var client_id: String = ""
    public var redirect_url: String = ""
    public var user_device_id: String = ""
    
    //
    public var exchange_id : String = ""
    public var expires_at : String = ""
    public var tenant_key : String = ""
    public var tenant_name : String = ""
    public var requested_types : [String] = []
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.requestTime = try container.decodeIfPresent(Int64.self, forKey: .requestTime) ?? 0
        self.physicalVerificationId = try container.decodeIfPresent(String.self, forKey: .physicalVerificationId) ?? ""
        self.statusId = try container.decodeIfPresent(String.self, forKey: .statusId) ?? ""
        self.sub = try container.decodeIfPresent(String.self, forKey: .sub) ?? ""
        self.verificationType = try container.decodeIfPresent(String.self, forKey: .verificationType) ?? ""
        self.randomNumbers = try container.decodeIfPresent(String.self, forKey: .randomNumbers) ?? ""
        self.address = try container.decodeIfPresent(PushAddress.self, forKey: .address) ?? PushAddress()
        self.deviceInfo = try container.decodeIfPresent(PushDeviceInfo.self, forKey: .deviceInfo) ?? PushDeviceInfo()
        
        self.dataShareType = try container.decodeIfPresent(String.self, forKey: .dataShareType) ?? ""
        self.baseurl = try container.decodeIfPresent(String.self, forKey: .baseurl) ?? ""
        self.client_id = try container.decodeIfPresent(String.self, forKey: .client_id) ?? ""
        self.user_device_id = try container.decodeIfPresent(String.self, forKey: .user_device_id) ?? ""
        self.redirect_url = try container.decodeIfPresent(String.self, forKey: .redirect_url) ?? ""
        
        //
        self.exchange_id = try container.decodeIfPresent(String.self, forKey: .exchange_id) ?? ""
        self.expires_at = try container.decodeIfPresent(String.self, forKey: .expires_at) ?? ""
        self.tenant_key = try container.decodeIfPresent(String.self, forKey: .tenant_key) ?? ""
        self.tenant_name = try container.decodeIfPresent(String.self, forKey: .tenant_name) ?? ""
        self.requested_types = try container.decodeIfPresent([String].self, forKey: .requested_types) ?? []
    }
}


public class PushDeviceInfo : Codable {
    public var os : PushOS = PushOS()
    public var browser : PushBrowser = PushBrowser()
    public var engine : PushEngine = PushEngine()
    public var deviceMake : String = ""
    public var deviceModel : String = ""
    public var userAgent : String = ""
    public var sub: String = ""
    public var ipAddress: String = ""
    public var pushNotificationId: String = ""
    public var deviceId: String = ""
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.os = try container.decodeIfPresent(PushOS.self, forKey: .os) ?? PushOS()
        self.browser = try container.decodeIfPresent(PushBrowser.self, forKey: .browser) ?? PushBrowser()
        self.engine = try container.decodeIfPresent(PushEngine.self, forKey: .engine) ?? PushEngine()
        self.deviceMake = try container.decodeIfPresent(String.self, forKey: .deviceMake) ?? ""
        self.deviceModel = try container.decodeIfPresent(String.self, forKey: .deviceModel) ?? ""
        self.userAgent = try container.decodeIfPresent(String.self, forKey: .userAgent) ?? ""
        self.sub = try container.decodeIfPresent(String.self, forKey: .sub) ?? ""
        self.ipAddress = try container.decodeIfPresent(String.self, forKey: .ipAddress) ?? ""
        self.pushNotificationId = try container.decodeIfPresent(String.self, forKey: .pushNotificationId) ?? ""
    }
}

public class PushAddress : Codable {
    public var zipcode : String = ""
    public var country_short : String = ""
    public var ip_no : String = ""
    public var formattedAddress : String = ""
    public var city : String = ""
    public var ip : String = ""
    public var latitude : Double = 0.0
    public var region : String = ""
    public var country_long : String = ""
    public var longitude : Double = 0.0
    public var status : String = ""
    public var street: String = ""
    public var houseNo: String = ""
    public var resolver: String = ""
    public var elevation: Int32 = 0
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.zipcode = try container.decodeIfPresent(String.self, forKey: .zipcode) ?? ""
        self.country_short = try container.decodeIfPresent(String.self, forKey: .country_short) ?? ""
        self.ip_no = try container.decodeIfPresent(String.self, forKey: .ip_no) ?? ""
        self.formattedAddress = try container.decodeIfPresent(String.self, forKey: .formattedAddress) ?? ""
        self.city = try container.decodeIfPresent(String.self, forKey: .city) ?? ""
        self.ip = try container.decodeIfPresent(String.self, forKey: .ip) ?? ""
        self.latitude = try container.decodeIfPresent(Double.self, forKey: .latitude) ?? 0.0
        self.region = try container.decodeIfPresent(String.self, forKey: .region) ?? ""
        self.country_long = try container.decodeIfPresent(String.self, forKey: .country_long) ?? ""
        self.longitude = try container.decodeIfPresent(Double.self, forKey: .longitude) ?? 0.0
        self.status = try container.decodeIfPresent(String.self, forKey: .status) ?? ""
        self.street = try container.decodeIfPresent(String.self, forKey: .street) ?? ""
        self.houseNo = try container.decodeIfPresent(String.self, forKey: .houseNo) ?? ""
        self.resolver = try container.decodeIfPresent(String.self, forKey: .resolver) ?? ""
        self.elevation = try container.decodeIfPresent(Int32.self, forKey: .elevation) ?? 0
        
    }
}

public class PushBrowser : Codable {
    public var major : String = ""
    public var name : String = ""
    public var version : String = ""
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.major = try container.decodeIfPresent(String.self, forKey: .major) ?? ""
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.version = try container.decodeIfPresent(String.self, forKey: .version) ?? ""
    }
}

public class PushOS : Codable {
    public var name : String = ""
    public var version : String = ""
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.version = try container.decodeIfPresent(String.self, forKey: .version) ?? ""
    }
}

public class PushEngine : Codable {
    public var name : String = ""
    public var version : String = ""
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.version = try container.decodeIfPresent(String.self, forKey: .version) ?? ""
    }
}

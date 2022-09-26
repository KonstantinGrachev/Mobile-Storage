//
//  MobileStorage.swift
//  TestTaskMobileStorage
//
//  Created by Konstantin Gracheff on 26.09.2022.
//

// Implement mobile phone storage protocol
// Requirements:
// - Mobiles must be unique (IMEI is an unique number)
// - Mobiles must be stored in memory

protocol MobileStorage {
    func getAll() -> Set<Mobile>
    func findByImei(_ imei: String) -> Mobile?
    func save(_ mobile: Mobile) throws -> Mobile
    func delete(_ product: Mobile) throws
    func exists(_ product: Mobile) -> Bool
}

import RealmSwift

class Mobile: Object {
    @objc dynamic var imei: String = ""
    @objc dynamic var model: String = ""
    
    convenience init(imei: String, model: String) {
        self.init()
        self.imei = imei
        self.model = model
    }
}



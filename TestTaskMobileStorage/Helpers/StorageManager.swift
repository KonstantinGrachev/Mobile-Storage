//
//  StorageManager.swift
//  TestTaskMobileStorage
//
//  Created by Konstantin Gracheff on 26.09.2022.
//

import RealmSwift

let realm = try! Realm()

class StorageManager: MobileStorage {
    
    var mobiles: Results<Mobile>! = realm.objects(Mobile.self)
    var filteredMobiles: Results<Mobile>!

    func getAll() -> Set<Mobile> {
        Set(mobiles)
    }

    func findByImei(_ imei: String) -> Mobile? {
        var desiredMobile: Mobile?
        for mobile in mobiles {
            if mobile.imei == imei {
                desiredMobile = mobile
            }
        }
        return desiredMobile
    }

    func save(_ mobile: Mobile) throws -> Mobile {
        do {
            try realm.write({
                realm.add(mobile)
            })
        } catch let error {
            print(error)
        }
        return mobile
    }

    func delete(_ product: Mobile) throws {
        do {
            try realm.write({
                realm.delete(product)
            })
        } catch let error {
            print(error)
        }
    }

    func exists(_ product: Mobile) -> Bool {
        var bool = false
        
        for mobile in mobiles {
            if mobile.model == product.model && mobile.imei == product.imei {
                bool = true
            }
        }
        return bool
    }
    
    
}

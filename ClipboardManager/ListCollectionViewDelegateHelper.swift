//
//  ListCollectionViewDelegateHelper.swift
//  ClipboardManager
//
//  Created by Pavel Morozov on 17.06.2020.
//  Copyright © 2020 Pavel Morozov. All rights reserved.
//

import Cocoa

class ListCollectionViewDelegateHelper: NSObject {
        var data: [String] = []
        var didSelectBlock: ((String) -> Void)?
    }

    extension ListCollectionViewDelegateHelper: NSCollectionViewDataSource {
        func numberOfSections(in collectionView: NSCollectionView) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.data.count
        }
        
        func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
            let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ListCollectionViewItem"), for: indexPath)
            guard let collectionViewItem = item as? ListCollectionViewItem else {
                return item
            }
            collectionViewItem.textLabel.stringValue = self.data[indexPath.item].removeExtraSpaces()
//            collectionViewItem.textLabel.stringValue = String(self.data[indexPath.item].compactMap({ $0.isNewline ? nil : $0 }))
//            let model = self.data[indexPath.item]
//            collectionViewItem.iconView.image = model.image
//            collectionViewItem.titleLabel.stringValue = model.title
//            item.textField?.stringValue = self.data[indexPath.item]
            return item
        }
    }

    extension ListCollectionViewDelegateHelper: NSCollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {

            guard let indexPath = indexPaths.first else {
                return
            }
            
            self.didSelectBlock?(self.data[indexPath.item])
        }
        
        func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
          return NSSize(width: 0, height: 0)
        }
    }

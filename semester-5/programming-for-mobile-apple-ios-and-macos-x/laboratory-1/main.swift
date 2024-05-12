//
//  main.swift
//  rogoz_lab1
//
//  Created by Paweł Rogóż on 02/11/2023.
//

import Foundation

class Container {
    var root: Node?
    
    init() {
        print("New container is created")
    }
    
    convenience init(_ rootNode: Node) {
        self.init()
        root = rootNode
    }
    
    deinit {
        print("Container is deleted")
    }
    
    func addNode(key: Int, data: Any) {
        root = insertNode(root, key: key, data: data, parent: nil)
    }
    
    func insertNode(_ node: Node?, key: Int, data: Any, parent: Node?) -> Node {
        if (node == nil) {
            return Node(value: data, key: key, parent: parent)
        } else {
            if (node!.key > key) {
                node!.left = insertNode(node!.left, key: key, data: data, parent: node)
            } else {
                node!.right = insertNode(node!.right, key: key, data: data, parent: node)
            }
        }
        
        return node!
    }

}

class Node {
    var value: Any
    var id: String
    var key: Int
    var left: Node?
    var right: Node?
    weak var parent: Node?
    
    init(value: Any, key: Int, parent: Node? = nil) {
        self.key = key
        self.value = value
        self.parent = parent
        self.id = UUID().uuidString
        print("Node with id: \(id) id created")
    }
    
    deinit {
        print("Node with id: \(id) is deleted")
    }
}

var container: Container? = Container()
container!.addNode(key: 30, data: 10)
container!.addNode(key: 10, data: 5)
container!.addNode(key: 1, data: 90)
print(container?.root?.left?.parent?.key)
print(container?.root?.left?.left?.parent?.key)

container = nil

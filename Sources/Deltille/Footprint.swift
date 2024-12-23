//
//  Footprint.swift
//
//  Created by Zack Brown on 24/05/2024.
//

import Euclid

// MARK: Footprint

open class Footprint<S: Scale,
                     T: Tile,
                     R: Rotation>: Codable,
                                   Hashable,
                                   Rotatable {
    
    open var perimeter: [T] { Array(Set(tiles.flatMap { $0.perimeter })) }
    
    public let origin: T
    public let tiles: [T]
    
    public init(_ origin: T,
                _ tiles: [T]) {
     
        self.origin = origin
        self.tiles = tiles
    }
    
    open func center(_ scale: S) -> Vector { .zero }
    
    open func rotate(_ rotation: R) -> Self { self }
}

extension Footprint {
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(origin)
        hasher.combine(tiles)
    }
    
    public static func == (lhs: Footprint<S, T, R>,
                           rhs: Footprint<S, T, R>) -> Bool {
        
        lhs.origin == rhs.origin &&
        lhs.tiles == rhs.tiles
    }
    
    public func intersects(_ footprint: Footprint) -> Bool {
        
        for tile in footprint.tiles {
            
            guard !intersects(tile) else { return true }
        }
        
        return intersects(footprint.origin)
    }
    
    public func intersects(_ tile: T) -> Bool { tiles.contains(tile) || tile == origin }
}

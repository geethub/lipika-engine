/*
 * LipikaEngine is a multi-codepoint, user-configurable, phonetic, Transliteration Engine.
 * Copyright (C) 2018 Ranganath Atreya
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 */

/// Implement this protocol, typically using `UserDefaults` and pass an instance into `TransliteratorFactory`.
public protocol Config {
    /**
     This character is used to break input aggregation. Typically this is the forward-slash character (`\`).
     
     __Example__: if `a` maps to `1` and `b` maps to `2` and `ab` maps to `3` then inputting `ab` will output `3` but inputting `a\b` will output `12`
     */
    var stopCharacter: Character { get }
    
    /**
     The URL path to the top-level directory where the schemes files are present. Usually this would return something like `Bundle.main.bundleURL.appendingPathComponent("Mapping")`
     */
    var schemesDirectory: URL { get }
    
    /**
     The level at which to NSLog log messages generated by LipikaEngine.
     
     - Important: This configuration only holds within the same thread in which `TransliteratorFactory` was initialized.
     */
    var logLevel: Level { get }
}

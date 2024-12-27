import Foundation

@propertyWrapper public struct Import<Wrapped> {
	public var wrappedValue: Wrapped {
		Modulus.container.dependency(for: Wrapped.self)
	}

	public init(_ type: Wrapped.Type) {}

	public init() {}
}

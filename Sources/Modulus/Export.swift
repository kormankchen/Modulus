import Foundation

@propertyWrapper public struct Export<Wrapped> {
	private var _wrapped: Wrapped {
		get {
			Modulus.container.dependency(for: Wrapped.self)
		}
		set {
			Modulus.container.register(type: Wrapped.self, newValue)
		}
	}

	public var wrappedValue: Wrapped {
		_wrapped
	}

	public init(wrappedValue: Wrapped, for type: Wrapped.Type = Wrapped.self) {
		_wrapped = wrappedValue
	}
}

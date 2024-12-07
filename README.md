# Modulus

<p align="center">
  <img src="./modulus.jpeg" width="33%">
</p>

# Introduction
Modulus is a dependency management library. Modulus is built with the following principles in mind:

- [x] **Simplicity**: Dependency management tools should be clear & simple.
The tools engineers use should be easily understood at a glance. Creating/leveraging dependencies
should require minimal code.
- [x] **Testability**: Dependencies should require minimal effort to mock in tests.

# Usage
This section will describe/showcase principles of the framework with an example.

## Define a dependency
We'll define a `HelloWorldService` in this example that asynchronously calculates a `HelloWorldResult`.

```swift
public protocol HelloWorldService {
  func hello() async -> HelloWorldResult
}

class HelloWorldServiceImpl: HelloWorldService {
  func hello() async -> HelloWorldResult {
    // Asynchronous logic for HelloWorldResult
  }
}
```

## Export a dependency
A modular architecture typically contains more than one dependency to export to other modules.
In `Modulus`, all of a modules exports are defined in that modules `Exportables` object using `@Export`.

```swift
struct HelloWorldExportables: Exportables {
  @Export var helloWorldService: HelloWorldService = HelloWorldServiceImpl()

  // More exports

  init() {}
}
```

## Initialize Modulus
`Modulus` manages linking all your exportables together. A good place to initialize `Modulus`
is inside the `@main` application.

```swift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  let modulus = Modulus.initialize(with: [
    HelloWorldExportables.self
  ])

}
```

## Import a dependency
Once `Modulus` is initialized with our exportables, we can `@Import` our dependency
anywhere we need it.

```swift
class HelloWorldViewModel {
  @Import var helloWorldService: HelloWorldService

  func sayHello() async {
    let result = await helloWorldService.hello()

    // Some other logic
  }
}
```

# Testing

## Mock Exportables
Best testing practices involve mocking most objects. Likewise, each module should define
a mock exportables which acts as a default.

```swift
class HelloWorldServiceMock: HelloWorldService {
}

public struct HelloWorldExportablesMock: Exportables {
  @Export var helloWorldService: HelloWorldService = HelloWorldServiceMock()

  // More exports

  public init() {}
}
```

> Note: It is important that `HelloWorldExportablesMock` is `public` so dependent modules can leverage our mocks.

## Write a test
Tests dependent on `Modulus` can be run in parallel. To start a test with our mock dependencies
we must leverage `Modulus.withExportables()` which ensures any code in our test uses the exported mocks.

```swift
struct HelloWorldViewModelTests {
  @Test func test_hello() {
    Modulus.withExportables([HelloWorldExportablesMock.self]) {
      let viewModel = HelloWorldViewModel()

      // expectations, assertions, etc.
    }
  }
}
```

You can also manually export a mock object when you need to leverage it for validations.

```swift
struct HelloWorldViewModelTests {
  @Test func test_hello() {
    Modulus.withExportables([HelloWorldExportablesMock.self]) {
      @Export var helloWorldService: HelloWorldService = HelloWorldServiceMock()

      let viewModel = HelloWorldViewModel()

      await viewModel.hello()

      #expect(helloWorldService.helloCalled)
    }
  }
}
```

> Note: `Modulus` works on with both XCTest & Testing frameworks.

# Acknowledgements
This library was inspired by:

- [swift-dependencies](https://github.com/pointfreeco/swift-dependencies)

# Safe and Sound: Sum Data Types and utilities for Ruby

This library gives you and alternative syntax to declare new types/classes.
It's inspired by the concise syntax to declare new types in [Elm](https://guide.elm-lang.org/types/custom_types.html) or [Haskell](https://www.schoolofhaskell.com/user/Gabriel439/sum-types)
These types share some properties with types referred to as _algebaric data types_, _sum types_ or _union types_.

We can model similar relationships more verbosely in plain Ruby with classes and subclasses.
This library provides some syntactic shortcuts to create these hierarchy.

````ruby
Vehicle = SafeAndSound.new(
    Car: { horsepower: Integer },
    Bike: { gears: Integer}
  )
```

This will create an abstract base class `Vehicle`.
Instances can only be created for the __concrete__ subclasses `Car` or `Bike`.
The class names act as "constructor" functions and values created that way are immutable.

```ruby
car = Vehicle.car(horsepower: 100)
puts car.horsepower # 100

bike = Vehicle.bike(gears: 'twentyone')
# SafeAndSound::WrgonConstructorArgType (gears must be of type Integer but was String)
```

`nil` is **not** a valid constructor argument. Optional values can be modeled with the [`Maybe` type](examples/maybe.rb) that is also provided with the library.

To add polymorphic behavior we can write functions __without__ having to touch the new types themselves.

By including the `SafeAndSound::Functions` module we get access to the `chase` function.
It immitates the `case` statement but uses the knowledge about our types to make it more safe.

```ruby
include SafeAndSound::Functions

def to_human(vehicle)
  chase vehicle do
    Vehicle::Car,  -> { "I'm a car with #{horsepower} horsepower" }
    Vehicle::Bike, -> { "I'm a bike with #{gears} gears" }
  end
end
```

This offers a stricter version of the case statement.
Specifically it makes sure that all variants are handled (unless an `otherwise` block is given).
This check will still be only performed at runtime, but as long as there is at least one test executing this
`chase` expression we'll get an early, precise exception telling us what's missing.

If you want a more detailed explanation why working with such objects can be appealing I recommend you watch the
[Functional Core, Imperative Shell](https://www.destroyallsoftware.com/screencasts/catalog/functional-core-imperative-shell)
episode of the _Destroy all software_ screencast.

I'm not trying to change how Ruby code is written. This is merely an experiment how far the sum type concept can be taken in terms
of making a syntax for it look like the syntax in languages where this concept is more central.




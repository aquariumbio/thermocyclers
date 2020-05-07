# Aquarium Thermocyclers Models

This library provides an interface for working with multiple makes and models of thermocyclers. The goal is to provide a consistent interface for instructions on how to use the thermocycler. For example, in a protocol `show` block,
```ruby
note "Click the <b>Open Lid</b> button"
image "Actions/TestThermocycler/close_lid.png" 
```
becomes
```ruby
thermocycler = ThermocyclerFactory.build(
  model: TestThermocycler::MODEL
)
.
.
.
note thermocycler.close_lid
image thermocycler.close_lid_image
```
This may seem like a trivial change, but it is very powerful in that, if you are working with a different thermocycler, you can simply change `TestThermocycler` to `BioRadCFX96` and all of the language and image paths will be updated automatically.

Note that this module is intended to work in conjunction with the `PCRProgram` and `PCRComposition` classes from [Aquarium PCR Models](https://github.com/dvnstrcklnd/aq-pcr-models).

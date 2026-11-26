<howto id="define_an_api" @lens="user" @display="Define an API with an example">
An `api` declares the operations a service offers, each an `op` with typed parameters
and a result. Examples on an op are checked against its types, and the docs show each
one as a request and its response.

<step id="declare_types">
Declare the types the op takes and returns with `type`, and each error it can
return as a type of its own with `@status` for its HTTP status.
</step>

<step id="declare_the_op">
Declare the `api` with its binding, `@http(base_path = …)`, and each op with its
method and path, its parameters and its [result_type], and `@throws` for its errors.
</step>

<step id="add_examples">
Give the op an `example` per case worth showing: its parameters by name, and either
`returns` or `throws`.

<example id="pets_api" @display="An API with examples">
```heron
import = ["std/types@1", "std/http@1"]

Pet: type {
  id: String
  name: String
}

@status(404)
PetNotFound: type {
  id: String
}

@http(base_path = "/v1")
pets: api {
  @http<get>("/pets/:id")
  @throws(PetNotFound)
  get_pet(@path id: String): op(Pet) {
    | Returns one pet by its id.

    found: example {
      id = "p1"
      returns = Pet(id = "p1", name = "Rex")
    }

    missing: example {
      id = "p9"
      throws = PetNotFound(id = "p9")
    }
  }
}
```
</example>
</step>

<step id="check_and_publish">
Run ${cli.check.name}: an example with a field the op doesn't take, or a value of the
wrong type, is an error. Then run ${cli.generate.name} with the target `docs`; the
op's page shows each example as a `curl` call, a Heron call and the raw request,
with its response.
</step>
</howto>

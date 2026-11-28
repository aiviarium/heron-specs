<howto id="write_rules" @lens="user" @display="Write a feature with rules">
A feature holds one capability of a system: the goals it serves, the words it uses and the
rules it follows. Each rule states one behaviour, with the part of the system that's bound
by it.

<step id="open_a_feature">
Name the feature after its capability, give it the goals it serves as its references,
and say in a line of prose what it covers. Declare the words it uses as `term` nodes in
it, so every page can link them.
</step>

<step id="add_rules">
Write one `rule` per behaviour. Its references go in its signature: the actor or part that
must act, then the goal it's for, as `rule(desk, self_service)`; the terms it uses are linked
in its text. Its body holds one strength,
`must`, `should`, `may`, `must_not` or `should_not`, with the conditions it holds under:
`where` with the [optional feature](#heron.language.specifications.context.optional_feature) it applies with, any `while`, and at most one trigger, `when` or `if`. Add `then` for what follows, and `instead` for what to do in place of
something a rule forbids. Link a term by its name in brackets, `[refund_window]`, which
reads "refund window" on the page; a bracket meant as text is written `\[optional]`.

<example id="refunds_feature" @display="A feature with rules">
```heron
import = ["std/doc@1"]

self_service: goal {{ Customers fix a wrong charge themselves. }}

desk: part {{ The support console. }}

refunds: feature(self_service) {
  | How the support console refunds a payment.

  refund_window: term {{ The 30 days after a payment is captured. }}

  refund_in_window: rule(desk) {
    when {{ a refund is requested inside the [refund_window] }}
    must {{ refund the amount asked for, up to what's still refundable }}
    then {{ the customer sees the refund on their statement }}
  }

  refund_after_window: rule(desk) {
    when {{ a refund is requested after the [refund_window] }}
    must_not {{ refund the payment }}
    instead {{ offer store credit for the amount }}
  }
}
```
</example>
</step>

<step id="check_it">
Run ${cli.check.name}, then ${cli.lint.name}: the lints ask you to link a term where
prose uses it, and flag weak words such as "should" in a `must`.

<tip>`heron lint -fix` applies the fixes that are no guess, such as wrapping a node's name
in brackets to link it.</tip>
</step>
</howto>

<howto id="write_rules" @lens="user" @display="Write a section with rules">
A section holds one concern of a system: the words it uses and the rules it follows.
Each rule states one behaviour, with the part of the system that's bound by it.

<step id="open_a_section">
Name the section after its concern, and say in a line of prose what it covers.
Declare the words it uses as `term` nodes in it, so every page can link them.
</step>

<step id="add_rules">
Write one `rule` per behaviour. Its annotations go above it: `@targets` names what it's
about, `@by` the actor or part that must act, `@serves` the goal it's for. Its body holds
one strength,
`must`, `should`, `may`, `mustNot` or `shouldNot`, with the conditions it holds under:
`where`, any `while`, and at most one trigger, `when` or `if`. Add `then` for what follows, and `instead` for what to do in place of
something a rule forbids. Link a term by its name in brackets, `[refund_window]`, which
reads "refund window" on the page; a bracket meant as text is written `\[optional]`.

<example id="refunds_section" @display="A section with rules">
```heron
import = ["std/doc@1", "std/spec@1"]

desk: part {{ The support console. }}

refunds: section {
  | How the support console refunds a payment.

  refund_window: term {{ The 30 days after a payment is captured. }}

  @by(desk)
  @targets(refunds)
  refund_in_window: rule {
    when {{ a refund is requested inside the [refund_window] }}
    must {{ refund the amount asked for, up to what's still refundable }}
    then {{ the customer sees the refund on their statement }}
  }

  @by(desk)
  @targets(refunds)
  refund_after_window: rule {
    when {{ a refund is requested after the [refund_window] }}
    mustNot {{ refund the payment }}
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

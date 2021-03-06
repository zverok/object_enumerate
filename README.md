# `Object#enumerate`

This is a small (exactly 1 method) gem to showcase my proposal to core Ruby.

[The proposal at Ruby tracker](https://bugs.ruby-lang.org/issues/14423).

[Discussion log](https://docs.google.com/document/d/e/2PACX-1vR2LdBE87iEcEsVuUUr0G2L6LxSPeGMg_0oeHeh0HYmX36iIa9zkWYlFHilH5D4I_RBJpQnr09yOZaE/pub) from developers meeting:

> Naruse: interesting proposal
>
> Akr: adding method to Object sounds too radical to me.
>
> Usa: I think there is a chance if this is a method of Enumerable.
>
> Shyouhei: my feeling is this should start as a gem.

So, considering Shyouhei's last remark, I am providing this gem for interested parties to experiment.

I still **strongly believe** the method should be a part of language core, so the gem is made as a proof-of-concept, to make experimentation with an idea simple.

**UPD: I thought about alternative proposal, [`Enumerator#generate`](https://github.com/zverok/enumerator_generate), which seems less radical and more powerful at the same time.**

## Synopsys

`Object#enumerate` takes a block and returns an instance of infinite `Enumerator`, where each next element is made by applying the block to the previous.

## Examples of usage

`Object#enumerate` can provide idiomatic replacement for a lot of `while` and `loop` constructs, the same way `each` replaces `for`.

```ruby
require 'object_enumerate'

# Most idiomatic "infinite sequence" possible:
p 1.enumerate(&:succ).take(5)
# => [1, 2, 3, 4, 5]

# Easy Fibonacci
p [0, 1].enumerate { |f0, f1| [f1, f0 + f1] }.take(10).map(&:first)
#=> [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]

# Find next Tuesday
require 'date'
Date.today.enumerate(&:succ).detect { |d| d.wday == 2 }
# => #<Date: 2018-05-22 ((2458261j,0s,0n),+0s,2299161j)>


# Tree navigation
# ---------------
require 'nokogiri'
require 'open-uri'

# Find some element on page, then make list of all parents
p Nokogiri::HTML(open('https://www.ruby-lang.org/en/'))
  .at('a:contains("Ruby 2.2.10 Released")')
  .enumerate(&:parent)
  .take_while { |node| node.respond_to?(:parent)  }
  .map(&:name)
# => ["a", "h3", "div", "div", "div", "div", "div", "div", "body", "html"]

# Pagination
# ----------
require 'octokit'

Octokit.stargazers('rails/rails')
# ^ this method returned just an array, but have set `.last_response` to full response, with data
# and pagination. So now we can do this:
p Octokit.last_response
  .enumerate { |response| response.rels[:next].get } # pagination: `get` fetches next Response
  .first(3)                                          # take just 3 pages of stargazers
  .flat_map(&:data)                                  # `data` is parsed response content (stargazers themselves)
  .map { |h| h[:login] }
# => ["wycats", "brynary", "macournoyer", "topfunky", "tomtt", "jamesgolick", ...
```

### Alternative synopsys

_Not implemented in the gem, just provided for a sake of core language proposal._

```ruby
Enumerable.enumerate(1, &:succ)
Enumerable(1, &:succ)
Enumerator.from(1, &:succ)
```

I personally don't believe any of those look clear enough, so, however risky adding new method to `Object` could look, I'd vote for it.

## UPD: Naming

_I received several responses about the name not being "obvious enough". It was not expected, I am sorry for not providing the reasons about name earlier._

The reasons behind the name `#enumerate`:

* Core method names should be short and mnemonic, not long and descriptive. (Otherwise, we'd have `yield_each` instead of `each`, `yield_each_and_collect` instead of `map`, `parallel_each` instead of `zip` and don't even get me started on `reduce`). It is if you can't guess what core method _exactly_ does _just_ from the name, more important to have it easily remembered and associative.
* Code constructs using the name should be spellable in your head. I pronounce it "1: enumerate succeeding numbers", "last result: enumerate all next" and so on. Judge yourself.
* Concept is present in other languages and frequently named `iterate` (for example, Clojure and Scala). As we call our iterators `Enumerator`, it is logical to call the method `enumerate`.
* Once you got it, the name is hard to confuse with anything (the only other slightly similar name in core is `#to_enum`, but it is typically used in a very far context).

The only other reasonable option I can think about is `deduce`, as an antonym for `reduce` which makes the opposite thing. Elixir follows this way, calling the methods `fold` (for our `reduce`) and `unfold` (for method proposed).

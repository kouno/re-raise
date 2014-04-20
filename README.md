ReRaise
-------

ReRaise is a small library which overrides Kernel.system and raises exception on unexpected errors.

Install
-------

```bash
gem install re-raise
```

Usage
-----

To activate ReRaise:
```ruby
ReRaise.enable

`false`
system('exit 1') # both raise an ReRaise::SystemExitError
```

It is also possible to limit it to a single class by including the ReRaisable module

```ruby
class SafeExec
  include ReRaise::ReRaisable

  def self.do_something
    `exit 1`
  end

  def do_something_else
    `exit 1`
  end
end

SafeExec.do_something # raise an error

SafeExec.new.do_something_else # raise an error
```

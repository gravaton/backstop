backstop
=================

This cookbook provides the 'backstop' resource, a resource designed to catch and disperse notifications at user-designated points during a Chef run.

Requirements
------------
Backstop was developed in a Chef 11 environment and has not been tested on Chef 10.

Usage
-----

To use backstop, create a named backstop resource and send notifications to that resource instead of your target resource.  The notifications should be formatted as follows:

```ruby
file 'test.txt' do
  content 'test'
  notifies( { action: :create, resource: "file[result.txt]" }, 'backstop[test]', :immediately )
end

file 'test2.txt' do
  content 'test'
  notifies( { action: :create, resource: "file[result.txt]" }, 'backstop[test]', :immediately )
end

file 'result.txt' do
  action :nothing
end

backstop 'test' do
  action :execute
end
```

As you can see, instead of notifying using a symbol to specify the desired action, we're passing a Hash as the first parameter.  The Hash passed must contain at least two elements:

:action - a symbol denoting the action to be called on the target object
:resource - a string denoting the final target of the notification

When the "execute" action is performed on the backstop object, all notifications that had been sent to the object previously in the run will be de-duplicated and forwarded to their intended targets.  Future notifications sent to the backstop object will be queued and wait for another "execute" action.  It is perfectly possible to have multiple backstop objects, as long as each has a unique name.

SYNTAX NOTE:  You can see that the 'notifies' statements above use parenthesis ().  This is due to a Ruby issue where passing a Hash literal as a parameter to a function is sometimes misinterpreted as passing a block.  

License and Authors
-------------------

Author: David Bresnick (david.bresnick@gmail.com)

Currently licensed under the Apache 2.0 license as described in the LICENSE file

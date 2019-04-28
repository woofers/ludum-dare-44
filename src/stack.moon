
class Stack
  new: () =>
    @stack = {}

  is_empty: () =>
    #@stack <= 0

  push: (item) =>
    unless @\is_empty!
      @stack[#@stack]\destroy!
    @stack[#@stack + 1] = item
    @\create!

  pop: () =>
    unless @\is_empty!
      @stack[#@stack]\destroy!
      @stack[#@stack] = nil
      @\create!

  create: () =>
    unless @\is_empty!
      @\peek!\create!

  peek: () =>
    unless @\is_empty!
      @stack[#@stack]

  update: (dt) =>
    unless @\is_empty!
      @\peek!\update(dt)

  render: (dt) =>
    unless @\is_empty!
      cls!
      @\peek!\render(dt)

{:Stack}

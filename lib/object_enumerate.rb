class Object
  def enumerate
    raise ArgumentError, "No block given" unless block_given?
    Enumerator.new do |y|
      val = self
      y << val
      loop do
        val = yield(val)
        y << val
      end
    end
  end
end
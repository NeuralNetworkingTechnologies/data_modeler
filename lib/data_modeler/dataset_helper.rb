module DataModeler
  # Converts between time and indices for referencing data lines
  module ConvertingTimeAndIndices
    # Returns the time for a given index
    # @param [Integer] idx row index
    # @return [kind_of_time]
    def time idx
      data[:time][idx]
    end

    # Returns the index for a given time
    # @param [time] time
    # @return [Integer] row index
    def idx time
      # TODO: optimize with `from:`
      # TODO: test corner case when index not found
      # find index of first above time
      idx = data[:time].index { |t| t > time }
      # if index not found: all data is below time, "first above" is outofbound
      idx ||= nrows
      # if first above time is 0: there is no element with that time
      raise TimeNotFoundError, "Time not found: #{time}" if idx.zero?
      # return index of predecessor (last below time)
      idx-1
    end
  end

  # Provides each (which can return an `Iterator`) and `to_a` based on `#next`
  module IteratingBasedOnNext
    # Yields on each [inputs, targets] pair.
    # @return [nil, Iterator] `block_given? ? nil : Iterator`
    def each
      return enum_for(:each) unless block_given?
      loop { yield self.next }
      nil
    end

    # @return [Array]
    def to_a
      each.to_a
    end

  end
end

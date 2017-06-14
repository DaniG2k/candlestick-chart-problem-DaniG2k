require 'csv'

class TradesFormatter
  attr_accessor :input_csv, :window_size

  def initialize(input_csv, window_size)
    @input_csv = input_csv
    @window_size = window_size
  end

  def get_windows
    result = {}
    start_time = @input_csv[0][0].to_i
    end_time = @input_csv[-1][0].to_i

    start_and_end_windows = (start_time..end_time)
      .each_slice(@window_size)
      .map {|slice| [slice[0], slice[-1]] }

    start_and_end_windows.each do |window|
      result[window] = []
      until @input_csv.empty?
        range = (window[0]..window[1])
        if range.include?(@input_csv[0][0].to_i)
          result[window] << @input_csv.shift
        else
          break
        end
      end
    end
    result
  end

  def output
    result = []
    get_windows.each do |batch, entries|
      result << {
        'start'   => batch[0],
        'end'     => batch[1],
        'open'    => get_open(entries),
        'close'   => get_close(entries),
        'high'    => max_entry(entries),
        'low'     => min_entry(entries),
        'average' => avg_entries(entries),
        # I am not sure what I am being expected to
        # weigh by.
        # 'weighted_average'  => ,
        'volume'  => get_btc_volume(entries)
      }
    end
    result
  end

  private
    def yield_with_entries_check(entries)
      if entries.empty?
        nil
      else
        yield if block_given?
      end
    end
 
    def get_open(entries)
      yield_with_entries_check(entries) do
        entries.first[1].to_f.round.to_s
      end
    end

    def get_close(entries)
      yield_with_entries_check(entries) do
        entries.last[1].to_f.round.to_s
      end
    end

    def max_entry(entries)
      yield_with_entries_check(entries) do
        entries.max {|a, b| a[1] <=> b[1]}[1].to_f.round.to_s
      end
    end

    def min_entry(entries)
      yield_with_entries_check(entries) do
        entries.min {|a, b| a[1] <=> b[1]}[1].to_f.round.to_s
      end
    end

    def avg_entries(entries)
      yield_with_entries_check(entries) do
        sum_entries = entries.inject(0) {|sum, entry| sum + entry[1].to_i}
        (sum_entries / entries.count).to_f.round.to_s
      end
    end

    def get_btc_volume(entries)
      num = if entries.empty?
        0
      else
        entries.inject(0) {|sum, entry| sum + entry[2].to_f}
      end
      sprintf("%.8f", num)
    end
end

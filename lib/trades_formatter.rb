require 'csv'

class TradesFormatter
  attr_accessor :input_csv, :window_size

  def initialize(input_csv, window_size)
    @input_csv = input_csv
    @window_size = window_size
  end

  def get_window
    result = {}
    batch = 0

    @input_csv.each do |entry|
      new_time = Time.at(entry.first.to_i)

      if result.empty?
        result[batch] = [entry]
      else
        start_time = Time.at(result[batch].first.first.to_i)
        end_time = start_time + @window_size

        if (start_time..end_time).include?(new_time)
          result[batch] << entry
        else
          batch += 1
          result[batch] = [entry]
        end
      end
    end
    result
  end

  def output
    result = []
    get_window.each do |batch, entries|
      sum_entries = entries.map {|e| e[1].to_i}.reduce(:+)
      avg = sum_entries / entries.count
      result << {
        'open'    => entries.first[1],
        'close'   => entries.last[1],
        'high'    => entries.max {|a, b| a[1] <=> b[1]}[1],
        'low'     => entries.min {|a, b| a[1] <=> b[1]}[1],
        'start'   => entries.first[0].to_i,
        'end'     => entries.last[0].to_i,
        'average' => avg.to_s
        # 'weighted_average'  => ,
        # 'volume'  => ,
      }
    end
    result
  end
end

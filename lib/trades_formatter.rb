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

  # def output
  #   {
  #     'open' => ,
  #     'close' => ,
  #     'high' => ,
  #     'low' => ,
  #     'start' => ,
  #     'end' => ,
  #     'average' => ,
  #     'weighted_average' => ,
  #     'volume' => ,
  #
  #   }
  # end
end

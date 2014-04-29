module MetricFu

  class FlayGenerator < Generator

    def self.metric
      :flay
    end

    def emit
      args =  "#{minimum_duplication_mass} #{dirs_to_flay}"
      @output = run!(args)
    end

    def analyze
      @matches = @output.chomp.split("\n\n").map{|m| m.split("\n  ") }
    end

    def to_h
      target = []
      total_score = @matches.shift.first.split('=').last.strip
      @matches.each do |problem|
        reason = problem.shift.strip
        lines_info = problem.map do |full_line|
          name, line = full_line.split(":")
          {:name => name.strip, :line => line.strip}
        end
        target << [:reason => reason, :matches => lines_info]
      end
      {:flay => {:total_score => total_score, :matches => target.flatten}}
    end

    private

    def minimum_duplication_mass
      flay_mass = options[:minimum_score]
      return "" unless flay_mass


      "--mass #{flay_mass} "
    end

    def dirs_to_flay
      options[:dirs_to_flay].join(" ")
    end

  end
end
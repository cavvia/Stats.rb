=begin
  @author Anil Bawa-Cavia <anil@quotesque.net>
  @license MIT 
=end

module Stats
    
=begin
  @desc Good old mean.
  @return Float mean
=end    
    def Stats.mean(nums)
      return Stats.sum(nums).to_f/nums.size
    end
    
=begin
  @desc Calculate the sum of an enumerable.
  @param Enumerable nums - Some numerics.
  @return Float sum 
=end    
    def Stats.sum(nums)
      nums.inject(0){|sum,x| x.to_f + sum}
    end
    
=begin
  @desc Range expressed as [min,max]
  @return Array [min.max]
=end
    def Stats.range(nums)
      nums = nums.map {|i| i.nil? ? i=0 : i } #deal with sparse array      
      return [nums.min,nums.max]
    end


=begin
  @desc median
  @param Enumerable nums
  @return Numeric 
=end    
    def Stats.median(nums)
        case nums.size % 2
          when 0 then Stats.mean(nums.sort[nums.size/2-1,2])
          when 1 then nums.sort[nums.size/2].to_f
        end if nums.size > 0
    end
    
=begin
  @desc Produce a frequency distribution
  @return Array freq
=end
    def Stats.frequency(nums)
      nums.sort.inject({}){ |freq,x| freq[x] = freq[x].to_i+1; freq }
    end


=begin
  @desc Calculate the most frequently occuring numeric.
  @return Numeric
=end
    def Stats.mode(nums)
      hist = Stats.frequency(nums)
      max = hist.values.max
      hist.keys.select{ |x| hist[x]==max }
    end    
    
    
=begin
  @desc Normalise a set of numbers to the range (0,1)
  @param Enumerable nums
  @param Integer to - What to normalise up to
=end
    def Stats.normalise(nums,to=1)
      max = nums.max
      norm = Array.new
      nums.each do |num|
        norm.push((Float(num)/max)*to)
      end
      norm
    end

=begin
      @desc Produce a complementary cumulative probability distribution (ccd) for a sequence of numerics. 
      @param Enumerable nums - Some numerics.
      @return Enumerable pd - Array of probabilities sorted in the same order as args.
=end
    def Stats.ccd(nums)
      nums = nums.map {|i| i.nil? ? i=0 : i } #deal with sparse array
      nums_c = nums.clone  
      n = nums.length
      pd = Array.new
      nums.each do |node|
        count = nums_c.select { |cmpnode| cmpnode >= node }.length
        probability = Float.induced_from(count)/n
        pd.push(probability)    
      end
      return pd
    end
    
    
=begin
  @desc Sum of squares
  @param Enumerable nums
  @return Float
=end    
    def Stats.squares(nums)
      nums.inject(0){|a,x|x.square+a}
    end
    
=begin
  @desc Statistical variance
  @param Enumerable nums
  @return Float
=end
  def Stats.variance(nums)
    Stats.squares(nums).to_f/nums.size - Stats.mean(nums).square
  end
  
=begin
  @desc Index/Coefficient of dispersion (variance/mean). Also known as fano factor.
  @param Enumerable nums
  @return Float
=end  
  def Stats.dispersion(nums)
    Stats.variance(nums)/Stats.mean(nums)
  end  
  
=begin
  @desc Absolute Deviation
  @param Enumerable nums
  @return Float
=end  
  def Stats.deviation(nums)
    Math::sqrt( Stats.variance(nums) )
  end  
    
=begin
  @desc Native ruby implementation of the pearson correlation coefficient (r). Its range is [-1,1].
  @return Float r
=end
    def Stats.pearson(x,y)
      n=x.length 

      sumx=x.inject(0) {|r,i| r + i}
      sumy=y.inject(0) {|r,i| r + i}

      sumxSq=x.inject(0) {|r,i| r + i**2}
      sumySq=y.inject(0) {|r,i| r + i**2}

      prods=[]; x.each_with_index{|this_x,i| prods << this_x*y[i]}
      pSum=prods.inject(0){|r,i| r + i}

      # Calculate Pearson score 
      num=pSum-(sumx*sumy/n) 
      den=((sumxSq-(sumx**2)/n)*(sumySq-(sumy**2)/n))**0.5 
      if den==0
        return 0 
      end
      r=num/den 
      return r 
    end
end

class Numeric
  def square ; self * self ; end
end

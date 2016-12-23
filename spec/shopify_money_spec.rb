require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ShopifyMoney" do

  before(:each) do
    @money = ShopifyMoney.new
  end

  it "is contructable with empty class method" do
    expect(ShopifyMoney.empty).to eq(@money)
  end

  it "returns itself with to_money" do
    expect(@money.to_money).to eq(@money)
  end

  it "defaults to 0 when constructed with no arguments" do
    expect(@money).to eq(ShopifyMoney.new(0.00))
  end

  it "to_s as a float with 2 decimal places" do
    expect(@money.to_s).to eq("0.00")
  end

  it "is constructable with a BigDecimal" do
    expect(ShopifyMoney.new(BigDecimal.new("1.23"))).to eq(ShopifyMoney.new(1.23))
  end

  it "is constructable with a Fixnum" do
    expect(ShopifyMoney.new(3)).to eq(ShopifyMoney.new(3.00))
  end

  it "is construcatable with a Float" do
    expect(ShopifyMoney.new(3.00)).to eq(ShopifyMoney.new(3.00))
  end

  it "is addable" do
    expect((ShopifyMoney.new(1.51) + ShopifyMoney.new(3.49))).to eq(ShopifyMoney.new(5.00))
  end

  it "raises error if added other is not compatible" do
    expect{ ShopifyMoney.new(5.00) + nil }.to raise_error
  end

  it "is able to add $0 + $0" do
    expect((ShopifyMoney.new + ShopifyMoney.new)).to eq(ShopifyMoney.new)
  end

  it "is subtractable" do
    expect((ShopifyMoney.new(5.00) - ShopifyMoney.new(3.49))).to eq(ShopifyMoney.new(1.51))
  end

  it "raises error if subtracted other is not compatible" do
    expect{ ShopifyMoney.new(5.00) - nil }.to raise_error
  end

  it "is subtractable to $0" do
    expect((ShopifyMoney.new(5.00) - ShopifyMoney.new(5.00))).to eq(ShopifyMoney.new)
  end

  it "is substractable to a negative amount" do
    expect((ShopifyMoney.new(0.00) - ShopifyMoney.new(1.00))).to eq(ShopifyMoney.new("-1.00"))
  end

  it "is never negative zero" do
    expect(ShopifyMoney.new(-0.00).to_s).to eq("0.00")
    expect((ShopifyMoney.new(0) * -1).to_s).to eq("0.00")
  end

  it "inspects to a presentable string" do
    expect(@money.inspect).to eq("#<ShopifyMoney value:0.00>")
  end

  it "is inspectable within an array" do
    expect([@money].inspect).to eq("[#<ShopifyMoney value:0.00>]")
  end

  it "correctly support eql? as a value object" do
    expect(@money).to eq(ShopifyMoney.new)
  end

  it "is addable with integer" do
    expect((ShopifyMoney.new(1.33) + 1)).to eq(ShopifyMoney.new(2.33))
    expect((1 + ShopifyMoney.new(1.33))).to eq(ShopifyMoney.new(2.33))
  end

  it "is addable with float" do
    expect((ShopifyMoney.new(1.33) + 1.50)).to eq(ShopifyMoney.new(2.83))
    expect((1.50 + ShopifyMoney.new(1.33))).to eq(ShopifyMoney.new(2.83))
  end

  it "is subtractable with integer" do
    expect((ShopifyMoney.new(1.66) - 1)).to eq(ShopifyMoney.new(0.66))
    expect((2 - ShopifyMoney.new(1.66))).to eq(ShopifyMoney.new(0.34))
  end

  it "is subtractable with float" do
    expect((ShopifyMoney.new(1.66) - 1.50)).to eq(ShopifyMoney.new(0.16))
    expect((1.50 - ShopifyMoney.new(1.33))).to eq(ShopifyMoney.new(0.17))
  end

  it "is multipliable with an integer" do
    expect((ShopifyMoney.new(1.00) * 55)).to eq(ShopifyMoney.new(55.00))
    expect((55 * ShopifyMoney.new(1.00))).to eq(ShopifyMoney.new(55.00))
  end

  it "is multiplable with a float" do
    expect((ShopifyMoney.new(1.00) * 1.50)).to eq(ShopifyMoney.new(1.50))
    expect((1.50 * ShopifyMoney.new(1.00))).to eq(ShopifyMoney.new(1.50))
  end

  it "is multipliable by a cents amount" do
    expect((ShopifyMoney.new(1.00) * 0.50)).to eq(ShopifyMoney.new(0.50))
    expect((0.50 * ShopifyMoney.new(1.00))).to eq(ShopifyMoney.new(0.50))
  end

  it "is multipliable by a rational" do
    expect((ShopifyMoney.new(3.3) * Rational(1, 12))).to eq(ShopifyMoney.new(0.28))
    expect((Rational(1, 12) * ShopifyMoney.new(3.3))).to eq(ShopifyMoney.new(0.28))
  end

  it "is multipliable by a repeatable floating point number" do
    expect((ShopifyMoney.new(24.00) * (1 / 30.0))).to eq(ShopifyMoney.new(0.80))
    expect(((1 / 30.0) * ShopifyMoney.new(24.00))).to eq(ShopifyMoney.new(0.80))
  end

  it "is multipliable by a repeatable floating point number where the floating point error rounds down" do
    expect((ShopifyMoney.new(3.3) * (1.0 / 12))).to eq(ShopifyMoney.new(0.28))
    expect(((1.0 / 12) * ShopifyMoney.new(3.3))).to eq(ShopifyMoney.new(0.28))
  end

  it "rounds multiplication result with fractional penny of 5 or higher up" do
    expect((ShopifyMoney.new(0.03) * 0.5)).to eq(ShopifyMoney.new(0.02))
    expect((0.5 * ShopifyMoney.new(0.03))).to eq(ShopifyMoney.new(0.02))
  end

  it "rounds multiplication result with fractional penny of 4 or lower down" do
    expect((ShopifyMoney.new(0.10) * 0.33)).to eq(ShopifyMoney.new(0.03))
    expect((0.33 * ShopifyMoney.new(0.10))).to eq(ShopifyMoney.new(0.03))
  end

  it "is less than a bigger integer" do
    expect(ShopifyMoney.new(1)).to be < 2
    expect(2).to be > ShopifyMoney.new(1)
  end

  it "is less than or equal to a bigger integer" do
    expect(ShopifyMoney.new(1)).to be <= 2
    expect(2).to be >= ShopifyMoney.new(1)
  end

  it "is greater than a lesser integer" do
    expect(ShopifyMoney.new(2)).to be > 1
    expect(1).to be < ShopifyMoney.new(2)
  end

  it "is greater than or equal to a lesser integer" do
    expect(ShopifyMoney.new(2)).to be >= 1
    expect(1).to be <= ShopifyMoney.new(2)
  end

  it "raises if divided" do
    expect { ShopifyMoney.new(55.00) / 55 }.to raise_error
  end

  it "returns cents in to_liquid" do
    expect(ShopifyMoney.new(1.00).to_liquid).to eq(100)
  end

  it "returns cents in to_json" do
    expect(ShopifyMoney.new(1.00).to_json).to eq("1.00")
  end

  it "supports absolute value" do
    expect(ShopifyMoney.new(-1.00).abs).to eq(ShopifyMoney.new(1.00))
  end

  it "supports to_i" do
    expect(ShopifyMoney.new(1.50).to_i).to eq(1)
  end

  it "supports to_f" do
    expect(ShopifyMoney.new(1.50).to_f.to_s).to eq("1.5")
  end

  it "is creatable from an integer value in cents" do
    expect(ShopifyMoney.from_cents(1950)).to eq(ShopifyMoney.new(19.50))
  end

  it "is creatable from an integer value of 0 in cents" do
    expect(ShopifyMoney.from_cents(0)).to eq(ShopifyMoney.new)
  end

  it "is creatable from a float cents amount" do
    expect(ShopifyMoney.from_cents(1950.5)).to eq(ShopifyMoney.new(19.51))
  end

  it "raises when constructed with a NaN value" do
    expect { ShopifyMoney.new(0.0 / 0) }.to raise_error
  end

  it "is comparable with non-money objects" do
    expect(@money).not_to eq(nil)
  end

  it "supports floor" do
    expect(ShopifyMoney.new(15.52).floor).to eq(ShopifyMoney.new(15.00))
    expect(ShopifyMoney.new(18.99).floor).to eq(ShopifyMoney.new(18.00))
    expect(ShopifyMoney.new(21).floor).to eq(ShopifyMoney.new(21))
  end

  describe "frozen with amount of $1" do
    before(:each) do
      @money = ShopifyMoney.new(1.00).freeze
    end

    it "is equals to $1" do
      expect(@money).to eq(ShopifyMoney.new(1.00))
    end

    it "is not equals to $2" do
      expect(@money).not_to eq(ShopifyMoney.new(2.00))
    end

    it "<=> $1 is 0" do
      expect((@money <=> ShopifyMoney.new(1.00))).to eq(0)
    end

    it "<=> $2 is -1" do
      expect((@money <=> ShopifyMoney.new(2.00))).to eq(-1)
    end

    it "<=> $0.50 equals 1" do
      expect((@money <=> ShopifyMoney.new(0.50))).to eq(1)
    end

    it "<=> works with non-money objects" do
      expect((@money <=> 1)).to eq(0)
      expect((@money <=> 2)).to eq(-1)
      expect((@money <=> 0.5)).to eq(1)
      expect((1 <=> @money)).to eq(0)
      expect((2 <=> @money)).to eq(1)
      expect((0.5 <=> @money)).to eq(-1)
    end

    it "raises error if compared other is not compatible" do
      expect{ ShopifyMoney.new(5.00) <=> nil }.to raise_error
    end

    it "have the same hash value as $1" do
      expect(@money.hash).to eq(ShopifyMoney.new(1.00).hash)
    end

    it "does not have the same hash value as $2" do
      expect(@money.hash).to eq(ShopifyMoney.new(1.00).hash)
    end

  end

  describe "with amount of $0" do
    before(:each) do
      @money = ShopifyMoney.new
    end

    it "is zero" do
      expect(@money).to be_zero
    end

    it "is greater than -$1" do
      expect(@money).to be > ShopifyMoney.new("-1.00")
    end

    it "is greater than or equal to $0" do
      expect(@money).to be >= ShopifyMoney.new
    end

    it "is less than or equal to $0" do
      expect(@money).to be <= ShopifyMoney.new
    end

    it "is less than $1" do
      expect(@money).to be < ShopifyMoney.new(1.00)
    end
  end

  describe "with amount of $1" do
    before(:each) do
      @money = ShopifyMoney.new(1.00)
    end

    it "is not zero" do
      expect(@money).not_to be_zero
    end

    it "returns cents as a decimal value = 1.00" do
      expect(@money.value).to eq(BigDecimal.new("1.00"))
    end

    it "returns cents as 100 cents" do
      expect(@money.cents).to eq(100)
    end

    it "returns cents as a Fixnum" do
      expect(@money.cents).to be_an_instance_of(Fixnum)
    end

    it "is greater than $0" do
      expect(@money).to be > ShopifyMoney.new(0.00)
    end

    it "is less than $2" do
      expect(@money).to be < ShopifyMoney.new(2.00)
    end

    it "is equal to $1" do
      expect(@money).to eq(ShopifyMoney.new(1.00))
    end
  end

  describe "allocation"do
    specify "#allocate takes no action when one gets all" do
      expect(ShopifyMoney.new(5).allocate([1])).to eq([ShopifyMoney.new(5)])
    end

    specify "#allocate does not lose pennies" do
      moneys = ShopifyMoney.new(0.05).allocate([0.3, 0.7])
      expect(moneys[0]).to eq(ShopifyMoney.new(0.02))
      expect(moneys[1]).to eq(ShopifyMoney.new(0.03))
    end

    specify "#allocate does not lose pennies even when given a lossy split" do
      moneys = ShopifyMoney.new(1).allocate([0.333, 0.333, 0.333])
      expect(moneys[0].cents).to eq(34)
      expect(moneys[1].cents).to eq(33)
      expect(moneys[2].cents).to eq(33)
    end

    specify "#allocate requires total to be less than 1" do
      expect { ShopifyMoney.new(0.05).allocate([0.5, 0.6]) }.to raise_error(ArgumentError)
    end

    specify "#allocate will use rationals if provided" do
      splits = [128400,20439,14589,14589,25936].map{ |num| Rational(num, 203953) } # sums to > 1 if converted to float
      expect(ShopifyMoney.new(2.25).allocate(splits)).to eq([ShopifyMoney.new(1.42), ShopifyMoney.new(0.23), ShopifyMoney.new(0.16), ShopifyMoney.new(0.16), ShopifyMoney.new(0.28)])
    end

    specify "#allocate will convert rationals with high precision" do
      ratios = [Rational(1, 1), Rational(0)]
      expect(ShopifyMoney.new("858993456.12").allocate(ratios)).to eq([ShopifyMoney.new("858993456.12"), ShopifyMoney.empty])
      ratios = [Rational(1, 6), Rational(5, 6)]
      expect(ShopifyMoney.new("3.00").allocate(ratios)).to eq([ShopifyMoney.new("0.50"), ShopifyMoney.new("2.50")])
    end

    specify "#allocate doesn't raise with weird negative rational ratios" do
      rate = Rational(-5, 1201)
      expect { ShopifyMoney.new(1).allocate([rate, 1 - rate]) }.not_to raise_error
    end

    specify "#allocate_max_amounts returns the weighted allocation without exceeding the maxima when there is room for the remainder" do
      expect(
          ShopifyMoney.new(30.75).allocate_max_amounts([ShopifyMoney.new(26), ShopifyMoney.new(4.75)]),
      ).to eq([ShopifyMoney.new(26), ShopifyMoney.new(4.75)])
    end

    specify "#allocate_max_amounts drops the remainder when returning the weighted allocation without exceeding the maxima when there is no room for the remainder" do
      expect(
          ShopifyMoney.new(30.75).allocate_max_amounts([ShopifyMoney.new(26), ShopifyMoney.new(4.74)]),
      ).to eq([ShopifyMoney.new(26), ShopifyMoney.new(4.74)])
    end

    specify "#allocate_max_amounts returns the weighted allocation when there is no remainder" do
      expect(
          ShopifyMoney.new(30).allocate_max_amounts([ShopifyMoney.new(15), ShopifyMoney.new(15)]),
      ).to eq([ShopifyMoney.new(15), ShopifyMoney.new(15)])
    end

    specify "#allocate_max_amounts allocates the remainder round-robin when the maxima are not reached" do
      expect(
          ShopifyMoney.new(1).allocate_max_amounts([ShopifyMoney.new(33), ShopifyMoney.new(33), ShopifyMoney.new(33)]),
      ).to eq([ShopifyMoney.new(0.34), ShopifyMoney.new(0.33), ShopifyMoney.new(0.33)])
    end

    specify "#allocate_max_amounts allocates up to the maxima specified" do
      expect(
          ShopifyMoney.new(100).allocate_max_amounts([ShopifyMoney.new(5), ShopifyMoney.new(2)]),
      ).to eq([ShopifyMoney.new(5), ShopifyMoney.new(2)])
    end

    specify "#allocate_max_amounts supports all-zero maxima" do
      expect(
          ShopifyMoney.new(3).allocate_max_amounts([ShopifyMoney.empty, ShopifyMoney.empty, ShopifyMoney.empty]),
      ).to eq([ShopifyMoney.empty, ShopifyMoney.empty, ShopifyMoney.empty])
    end
  end

  describe "split" do
    specify "#split needs at least one party" do
      expect {ShopifyMoney.new(1).split(0)}.to raise_error(ArgumentError)
      expect {ShopifyMoney.new(1).split(-1)}.to raise_error(ArgumentError)
    end

    specify "#gives 1 cent to both people if we start with 2" do
      expect(ShopifyMoney.new(0.02).split(2)).to eq([ShopifyMoney.new(0.01), ShopifyMoney.new(0.01)])
    end

    specify "#split may distribute no money to some parties if there isnt enough to go around" do
      expect(ShopifyMoney.new(0.02).split(3)).to eq([ShopifyMoney.new(0.01), ShopifyMoney.new(0.01), ShopifyMoney.new(0)])
    end

    specify "#split does not lose pennies" do
      expect(ShopifyMoney.new(0.05).split(2)).to eq([ShopifyMoney.new(0.03), ShopifyMoney.new(0.02)])
    end

    specify "#split a dollar" do
      moneys = ShopifyMoney.new(1).split(3)
      expect(moneys[0].cents).to eq(34)
      expect(moneys[1].cents).to eq(33)
      expect(moneys[2].cents).to eq(33)
    end
  end

  describe "fraction" do
    specify "#fraction needs a positive rate" do
      expect {ShopifyMoney.new(1).fraction(-0.5)}.to raise_error(ArgumentError)
    end

    specify "#fraction returns the amount minus a fraction" do
      expect(ShopifyMoney.new(1.15).fraction(0.15)).to eq(ShopifyMoney.new(1.00))
      expect(ShopifyMoney.new(2.50).fraction(0.15)).to eq(ShopifyMoney.new(2.17))
      expect(ShopifyMoney.new(35.50).fraction(0)).to eq(ShopifyMoney.new(35.50))
    end
  end

  describe "with amount of $1 with created with 3 decimal places" do
    before(:each) do
      @money = ShopifyMoney.new(1.125)
    end

    it "rounds 3rd decimal place" do
      expect(@money.value).to eq(BigDecimal.new("1.13"))
    end
  end

  describe "parser dependency injection" do
    before(:each) do
      ShopifyMoney.parser = AccountingMoneyParser
    end

    it "keeps AccountingMoneyParser class on new money objects" do
      expect(ShopifyMoney.new.class.parser).to eq(AccountingMoneyParser)
    end

    it "supports parenthesis from AccountingMoneyParser" do
      expect(ShopifyMoney.parse("($5.00)")).to eq(ShopifyMoney.new(-5))
    end

    it "supports parenthesis from AccountingMoneyParser for .to_money" do
      expect("($5.00)".to_money).to eq(ShopifyMoney.new(-5))
    end

    after(:each) do
      ShopifyMoney.parser = nil # reset
    end
  end

  describe "round" do

    it "rounds to 0 decimal places by default" do
      expect(ShopifyMoney.new(54.1).round).to eq(ShopifyMoney.new(54))
      expect(ShopifyMoney.new(54.5).round).to eq(ShopifyMoney.new(55))
    end

    # Overview of standard vs. banker's rounding for next 4 specs:
    # http://www.xbeat.net/vbspeed/i_BankersRounding.htm
    it "implements standard rounding for 2 digits" do
      expect(ShopifyMoney.new(54.1754).round(2)).to eq(ShopifyMoney.new(54.18))
      expect(ShopifyMoney.new(343.2050).round(2)).to eq(ShopifyMoney.new(343.21))
      expect(ShopifyMoney.new(106.2038).round(2)).to eq(ShopifyMoney.new(106.20))
    end

    it "implements standard rounding for 1 digit" do
      expect(ShopifyMoney.new(27.25).round(1)).to eq(ShopifyMoney.new(27.3))
      expect(ShopifyMoney.new(27.45).round(1)).to eq(ShopifyMoney.new(27.5))
      expect(ShopifyMoney.new(27.55).round(1)).to eq(ShopifyMoney.new(27.6))
    end

  end
end
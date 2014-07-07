class FishDatabase
  def initialize
    @fish = []
    @count = 0
  end

  def insert(fishie)

    fishie = fishie.dup
    fishie[:id] = @count
    @count += 1
    @fish.push(fishie)

    fishie.dup
  end

  def find(id)
    @fish.select {|fishie| fishie[:id] == id}[0]
  end

  def delete(id)
    @fish.each do |fishie|
      if fishie[:id] == id
        @fish.delete(fishie) or raise UserNotFoundError
      end
    end
  end

  def all
    @fish.dup
  end

  class UserNotFoundError < RuntimeError; end

  private

  def next_id
    @fish.length + 1
  end

  def offset_id(id)
    id - 1
  end

end
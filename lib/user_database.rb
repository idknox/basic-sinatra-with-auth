class UserDatabase
  def initialize
    @users = []
    @count = 0
  end

  def insert(user)
    validate!(user, :username, :password)

    user = user.dup
    user[:id] = @count
    @count += 1

    @users.push(user)

    user.dup
  end

  def find(id)
    @users.select {|user| user[:id] == id}[0]
  end

  def delete(id)
    @users.each do |user|
      if user[:id] == id
        @users.delete(user) or raise UserNotFoundError
      end
    end
  end

  def all
    @users.dup
  end

  class UserNotFoundError < RuntimeError; end

  private

  def validate!(user, *attributes)
    invalid_attributes = attributes.select { |a| !user.has_key?(a) }

    if invalid_attributes.any?
      message = "#{invalid_attributes.join(", ")} required"
      raise ArgumentError, message
    end
  end

  def next_id
    @count
  end

  def offset_id(id)
    id - 1
  end

end

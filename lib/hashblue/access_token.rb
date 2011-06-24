class Hashblue::AccessToken
  def initialize(access_token)
    @access_token = access_token
  end

  def to_s
    @access_token
  end
end
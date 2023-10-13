class User < ApplicationRecord
  enum role: ['organizer', 'presenter', 'participant']

  belongs_to :group
end